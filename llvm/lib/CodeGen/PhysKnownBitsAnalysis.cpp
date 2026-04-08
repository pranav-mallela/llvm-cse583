//===-- lib/CodeGen/PhysKnownBitsAnalysis.cpp --------------------*- C++ *-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
/// Provides analysis for querying information about KnownBits in Machine IR.
///
/// Based on the lib/CodeGen/GlobalISel/GISelKnownBits.cpp, PhysKnownBitsAnalysis
/// for generic Machine IR (gMIR).
//
//===----------------------------------------------------------------------===//
#include "llvm/CodeGen/PhysKnownBitsAnalysis.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetKnownBitsInfo.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/CodeGen/TargetOpcodes.h"
#include "llvm/IR/Module.h"

using namespace llvm;

#define DEBUG_TYPE "phys-known-bits-analysis"

#define KB_LLVM_DEBUG(x){}

char llvm::PhysKnownBitsAnalysisWrapper::ID = 0;

INITIALIZE_PASS_BEGIN(PhysKnownBitsAnalysisWrapper, DEBUG_TYPE,
                "Analysis for Physical KnownBits in Machine IR", false, true)
INITIALIZE_PASS_DEPENDENCY(MachineLoopInfo)
INITIALIZE_PASS_DEPENDENCY(ScalarEvolutionWrapperPass)
INITIALIZE_PASS_END(PhysKnownBitsAnalysisWrapper, DEBUG_TYPE,
                "Analysis for Physical KnownBits in Machine IR", false, true)

PhysKnownBitsAnalysis::PhysKnownBitsAnalysis(MachineFunction &MF, MachineLoopInfo &MLI, ScalarEvolution &SE, unsigned MaxDepth)
    : MF(MF), MLI(&MLI), SE(&SE), MRI(MF.getRegInfo()),
      TRI(*MF.getSubtarget().getRegisterInfo()),
      TKBI(*MF.getSubtarget().getTargetKnownBitsInfo()), MaxDepth(MaxDepth) {}

KnownBits PhysKnownBitsAnalysis::getKnownBits(MachineOperand* MOP) {
  APInt DemandedElts = APInt(1, 1);
  return getKnownBits(MOP, DemandedElts);
}

KnownBits PhysKnownBitsAnalysis::getKnownBits(MachineOperand* MOP,
                           const APInt &DemandedElts, unsigned Depth) {
  // For now, we only maintain the cache during one request.
  assert(ComputeKnownBitsCache.empty() && "Cache should have been cleared");
  TKBI.getComputeKnownBitsCacheInit(InitRegMap, MRI);

  KB_LLVM_DEBUG(dbgs() << "[" << Depth << "]:BEGIN: getKnownBits(): for "; MOP->print(dbgs()); dbgs() << ": ";MOP->getParent()->dump());
  KnownBits Known;
  computeKnownBitsImpl(MOP, Known, DemandedElts);
  ComputeKnownBitsCache.clear();
  KB_LLVM_DEBUG(dbgs() << "[" << Depth << "]:  END:\n");
  KB_LLVM_DEBUG(dumpKnownBits(Known, Depth));
  return Known;
}

void PhysKnownBitsAnalysis::computeKnownBitsImpl(MachineOperand* MOP,
                KnownBits &Known, const APInt &DemandedElts, unsigned Depth) {
  assert(MOP->isReg() && "MOP is not register");
  Register R = MOP->getReg();
  LLVM_DEBUG(dbgs() << "    [" << Depth << "] computeKnownBitsImpl("
                    <<printReg(R, &TRI) <<"): "; MOP->getParent()->dump());

  unsigned BitWidth = TRI.getRegSizeInBits(R, MRI);
  if (InitRegMap.find(R) != InitRegMap.end()) {
    Known = InitRegMap[R];
    LLVM_DEBUG(dbgs() << "Cache hit at "<< printReg(R, &TRI) << "\n");
    return;
  }

  auto CacheEntry = ComputeKnownBitsCache.find(MOP);
  if (CacheEntry != ComputeKnownBitsCache.end()) {
    Known = CacheEntry->second;
    LLVM_DEBUG(dbgs() << "Cache hit at :";MOP->dump();
               dbgs() << ": "; MOP->getParent()->dump(););
    assert(Known.getBitWidth() == BitWidth && "Cache entry size doesn't match");
    return;
  }

  Known = KnownBits(BitWidth); // Don't know anything

  // Depth may get bigger than max depth if it gets passed to a different
  // PhysKnownBitsAnalysis object.
  // This may happen when say a generic part uses a PhysKnownBitsAnalysis object
  // with some max depth, but then we hit TL.computeKnownBitsForTargetInstr
  // which creates a new PhysKnownBitsAnalysis object with a different and smaller
  // depth. If we just check for equality, we would never exit if the depth
  // that is passed down to the target specific PhysKnownBitsAnalysis object is
  // already bigger than its max depth.
  if (Depth >= getMaxDepth())
    return;

  if (!DemandedElts)
    return; // No demanded elts, better to assume we don't know anything.

  if (MOP->isDef()) {
    KB_LLVM_DEBUG(dbgs() << "["<<Depth<<"]: MOP ("; MOP->print(dbgs()); dbgs() <<") is Def\n");
    TKBI.computeKnownBitsForPhysReg(*this, MOP, Known, DemandedElts, MRI, Depth);
    KB_LLVM_DEBUG(dumpResult(MOP, Known, Depth));
  } else {
    // A physical register may have multiple defs. Intersect all.
    KB_LLVM_DEBUG(dbgs() << "["<<Depth<<"]: MOP (";MOP->print(dbgs()); dbgs()<<") is Use\n");
    for (unsigned i = 0, e = MRI.DefMOPMap[MOP].size(); i < e; i++) {
      MachineOperand *defMOP = MRI.DefMOPMap[MOP][i];
      KnownBits KnownDef = KnownBits(BitWidth); // Don't know anything yet
      KB_LLVM_DEBUG(dbgs() << "["<<Depth<<"]: Def MOP ["<<i<<"]: ";defMOP->print(dbgs()); dbgs() << " in "; defMOP->getParent()->dump());
      TKBI.computeKnownBitsForPhysReg(*this, defMOP, KnownDef, DemandedElts, MRI, Depth);
      KB_LLVM_DEBUG(dumpResult(defMOP, KnownDef, Depth));

      if (i == 0) {
        // deepcopy
        Known = KnownBits(KnownDef.Zero, KnownDef.One);
      } else {
        // intersect
        Known = KnownBits::commonBits(Known, KnownDef);
      }
    }
    KB_LLVM_DEBUG(dumpResult(MOP, Known, Depth));
  }

  assert(!Known.hasConflict() && "Bits known to be one AND zero?");
  LLVM_DEBUG(dumpResult(MOP, Known, Depth));

  // Update the cache.
  ComputeKnownBitsCache[MOP] = Known;
}

LLVM_ATTRIBUTE_UNUSED void
PhysKnownBitsAnalysis::dumpResult(const MachineOperand *MOP,
    const KnownBits &Known, unsigned Depth) const {
  dbgs() << "[" << Depth << "] KnownBits result for "; MOP->print(dbgs());
  dbgs() << " in "; MOP->getParent()->dump();
  dumpKnownBits(Known, Depth);
}

LLVM_ATTRIBUTE_UNUSED void
PhysKnownBitsAnalysis::dumpKnownBits(const KnownBits &Known, unsigned Depth) const {
  dbgs() << "[" << Depth << "] Known: 0x"
         << toStringBits(Known.Zero | Known.One, 16, false)
         << " (0x" << toString(Known.Zero | Known.One, 16, false) << ")\n"
         << "[" << Depth << "] Zero : 0x" << toStringBits(Known.Zero, 16, false)
         << " (0x" << toString(Known.Zero, 16, false) << ")\n"
         << "[" << Depth << "] One  : 0x" << toStringBits(Known.One, 16, false)
         << " (0x" << toString(Known.One, 16, false) << ")\n";
}

void PhysKnownBitsAnalysisWrapper::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.setPreservesAll();
  AU.addRequired<MachineLoopInfo>();
  AU.addRequired<ScalarEvolutionWrapperPass>();
  MachineFunctionPass::getAnalysisUsage(AU);
}

bool PhysKnownBitsAnalysisWrapper::runOnMachineFunction(MachineFunction &MF) {
  MLI = &getAnalysis<MachineLoopInfo>();
  SE = &getAnalysis<ScalarEvolutionWrapperPass>().getSE();
  return false;
}
