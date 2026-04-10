//==- BECReliabilityModule.cpp - Module to access BEC Analysis FIResMap --==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// BECReliabilityModule class
// Attribute to store FIResMap
// Function to run BEC pass to generate FIResMap and store it in a fixed file path
// Function to read FIResMap from fixed file path
// Function to calculate unique fault indices given machine operand

// For Reliability-Aware Register Allocation
// Import this module in CalcSpillWeights.cpp (FIResMap has the operands for an entire machine function)
// Use it in weightCalcHelper()

//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/BECReliabilityModule.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/CodeGen/LiveInterval.h"
#include "llvm/CodeGen/LiveIntervals.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/StackMaps.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/CodeGen/VirtRegMap.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/MemoryBuffer.h"
#include <set>

using namespace llvm;

#define DEBUG_TYPE "becreliabilitymodule"

unsigned BECReliabilityModule::BitFaultMap::countUniqueIDs() const {
    std::set<unsigned> UniqueIDs;
    for (unsigned id : BitIndices) {
        UniqueIDs.insert(id);
    }
    return UniqueIDs.size();
}

bool BECReliabilityModule::loadMap(StringRef FilePath) {
    // 1. Read the file into a buffer
    auto BufferOrErr = MemoryBuffer::getFile(FilePath);
    if (!BufferOrErr) return false;

    StringRef Content = BufferOrErr.get()->getBuffer();
    
    // 2. TODO: Implement your parsing logic here 
    // You will iterate through 'Content' line by line, 
    // find the Function name, Instruction, and LSB/MSB indices.
    
    return true;
}

float BECReliabilityModule::getReliabilityFactor(const MachineInstr &MI, unsigned OpIdx) const {
    // 3. Logic to match the 'MI' to your internal Map
    // You'll likely use the instruction's position or SlotIndex
    return 1.0f; // Default multiplier
}

