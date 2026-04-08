//==-- RISCVKnownBitsInfo.h - RISCV KnownBitsAnalysis Interface -*- C++ -*--==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains KnownBits analyses for virtual and physical registers.
//   - computeKnownBitsForVReg: KnownBits analysis for virtual registers
//   - computeKnownBitsForPhysReg: KnownBits analysis for physical registers
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_RISCV_RISCVKNOWNBITSINFO_H
#define LLVM_LIB_TARGET_RISCV_RISCVKNOWNBITSINFO_H

#include "RISCV.h"
#include "llvm/CodeGen/TargetKnownBitsInfo.h"

namespace llvm {

class RISCVSubtarget;
class RISCVRegisterInfo;

class RISCVKnownBitsInfo: public TargetKnownBitsInfo {
  const RISCVSubtarget &Subtarget;
  const RISCVRegisterInfo &TRI;

public:
  explicit RISCVKnownBitsInfo(const TargetMachine &TM,
                              const RISCVSubtarget &STI);

  const RISCVSubtarget &getSubtarget() const { return Subtarget; }

  void computeKnownBitsForPhysReg(PhysKnownBitsAnalysis &AA,
                               MachineOperand* MOP, KnownBits &Known,
                               const APInt &DemandedElts,
                               const MachineRegisterInfo &MRI,
                               unsigned Depth = 0) const override;

  void getComputeKnownBitsCacheInit(DenseMap<Register, KnownBits> &cacheInitMap, const MachineRegisterInfo &MRI) const override;

  void getKnownBitsImm(const MachineInstr &MI, unsigned OpIdx, unsigned BitWidth,
                       KnownBits &Known) const;
};

} // end namespace llvm

#endif
