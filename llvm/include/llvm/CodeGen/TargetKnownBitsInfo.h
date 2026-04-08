//===- llvm/CodeGen/TargetKnownBitsInfo.h - Target KnownBits Info - C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file provides target-dependent wrapper for KnownBits analysis on
/// physical registers after register allocation.
///
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_CODEGEN_TARGETKNOWNBITS_H
#define LLVM_CODEGEN_TARGETKNOWNBITS_H

#include "llvm/ADT/APInt.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/CodeGen/Register.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/KnownBits.h"

namespace llvm {

struct KnownBits;
class PhysKnownBitsAnalysis;
class TargetMachine;
class MachineInstr;
class MachineOperand;
class MachineRegisterInfo;

class TargetKnownBitsInfo {
private:
  const TargetMachine &TM;

public:
  TargetKnownBitsInfo(const TargetKnownBitsInfo &) = delete;
  TargetKnownBitsInfo &operator=(const TargetKnownBitsInfo &) = delete;

  TargetKnownBitsInfo(const TargetMachine &TM) : TM(TM) {}

  /// Analyze which of the bits of registers are known or not, and return the
  /// results in the KnownZero/KnownOne bitsets. The DemandedElts argument
  /// allows us to only collect the known bits that are shared by the
  /// requested vector elements.

 // for physical regs
  virtual void computeKnownBitsForPhysReg(PhysKnownBitsAnalysis &AA,
                                          MachineOperand* MOP, KnownBits &Known,
                                          const APInt &DemandedElts,
                                          const MachineRegisterInfo &MRI,
                                          unsigned Depth = 0) const;

  virtual void getComputeKnownBitsCacheInit(DenseMap<Register, KnownBits> &cacheInitMap, const MachineRegisterInfo &MRI) const;
};

} // end namespace llvm

#endif // LLVM_CODEGEN_TARGETKNOWNBITS_H
