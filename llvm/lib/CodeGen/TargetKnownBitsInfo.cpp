//===-- TargetKnownBitsInfo.cpp - Implement the TargetKnownBitsInfo class -===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This implements the TargetKnownBitsInfo class.
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/TargetKnownBitsInfo.h"
#include "llvm/Support/KnownBits.h"
#include "llvm/ADT/DenseMap.h"

using namespace llvm;

void TargetKnownBitsInfo::computeKnownBitsForPhysReg(PhysKnownBitsAnalysis &AA,
    MachineOperand* MOP, KnownBits &Known, const APInt &DemandedElts,
    const MachineRegisterInfo &MRI, unsigned Depth) const {
  Known.resetAll();
}

void TargetKnownBitsInfo::getComputeKnownBitsCacheInit(
    DenseMap<Register, KnownBits> &cacheInitMap,
    const MachineRegisterInfo &MRI) const {}
