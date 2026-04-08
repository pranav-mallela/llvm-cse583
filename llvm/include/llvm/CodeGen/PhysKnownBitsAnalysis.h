//===- llvm/CodeGen/PhysKnownBitsAnalysis.h -------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// Provides analysis for querying information about KnownBits in Machine IR.
///
/// Based on the lib/CodeGen/GlobalISel/GISelKnownBits.h, PhysKnownBitsAnalysis
/// for generic Machine IR (gMIR).
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_CODEGEN_PHYSKNOWNBITSANALYSIS_H
#define LLVM_CODEGEN_PHYSKNOWNBITSANALYSIS_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/CodeGen/Register.h"
#include "llvm/InitializePasses.h"
#include "llvm/Support/KnownBits.h"

namespace llvm {

class TargetKnownBitsInfo;

class PhysKnownBitsAnalysis {
  MachineFunction &MF;
  MachineLoopInfo *MLI;
  ScalarEvolution *SE;
  MachineRegisterInfo &MRI;
  const TargetRegisterInfo &TRI;
  const TargetKnownBitsInfo &TKBI;

  unsigned MaxDepth;
  /// Cache maintained during a computeKnownBits request.
  SmallDenseMap<MachineOperand*, KnownBits, 16> ComputeKnownBitsCache;
  /// Contains registers with constant/static KnownBits
  DenseMap<Register, KnownBits> InitRegMap;

public:
  PhysKnownBitsAnalysis(MachineFunction &MF, MachineLoopInfo &MLI, ScalarEvolution &SE, unsigned MaxDepth = 10);
  virtual ~PhysKnownBitsAnalysis() = default;

  const MachineFunction &getMachineFunction() const {
    return MF;
  }

  virtual void computeKnownBitsImpl(MachineOperand* MOP, KnownBits &Known,
                                    const APInt &DemandedElts,
                                    unsigned Depth = 0);

  bool isLoopVariable(MachineOperand *MOP, KnownBits &Known,
                      const APInt &DemandedElts, unsigned Depth = 0);

  // KnownBits API
  KnownBits getKnownBits(MachineOperand* MOP);
  KnownBits getKnownBits(MachineOperand* MOP,
                         const APInt &DemandedElts, unsigned Depth = 0);

  LLVM_ATTRIBUTE_UNUSED void
  dumpResult(const MachineOperand *MOP, const KnownBits &Known, unsigned Depth) const;
  LLVM_ATTRIBUTE_UNUSED void dumpKnownBits(const KnownBits &Known, unsigned Depth) const;

protected:
  unsigned getMaxDepth() const { return MaxDepth; }
};

/// To use KnownBitsInfo analysis in a pass,
/// PhysKnownBitsAnalysis &KB = getAnalysis<KnownBitsAnalysisWrapper>().get(MF);

class PhysKnownBitsAnalysisWrapper : public MachineFunctionPass {
  std::unique_ptr<PhysKnownBitsAnalysis> Info;
  MachineLoopInfo *MLI;
  ScalarEvolution *SE;

public:
  static char ID;
  PhysKnownBitsAnalysisWrapper() : MachineFunctionPass(ID) {
    initializePhysKnownBitsAnalysisWrapperPass(*PassRegistry::getPassRegistry());
  }
  PhysKnownBitsAnalysis &get(MachineFunction &MF) {
    if (!Info)
      Info = std::make_unique<PhysKnownBitsAnalysis>(MF, *MLI, *SE);
    return *Info.get();
  }
  void getAnalysisUsage(AnalysisUsage &AU) const override;
  bool runOnMachineFunction(MachineFunction &MF) override;
  void releaseMemory() override { Info.reset(); }
};
} // namespace llvm

#endif // LLVM_CODEGEN_PHYSKNOWNBITSANALYSIS_H
