//==- BECReliabilityModule.cpp - Module to access BEC Analysis FIResMap --==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/BECReliabilityModule.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Debug.h"   // For LLVM_DEBUG and dbgs()
#include <set>

using namespace llvm;

#define DEBUG_TYPE "becreliabilitymodule"

BECReliabilityModule::BECReliabilityModule(std::string Path)
    : FaultIndexMapPath(std::move(Path)) {}

bool BECReliabilityModule::loadMap() {
  // 1. Read the file into a buffer
  auto BufferOrErr = MemoryBuffer::getFile(FaultIndexMapPath);
  if (!BufferOrErr) {
    LLVM_DEBUG(dbgs() << "BEC Module: Could not open " << FaultIndexMapPath << "\n");
    return false;
  }

  StringRef Content = BufferOrErr.get()->getBuffer();
  SmallVector<StringRef, 16> Lines;
  Content.split(Lines, '\n');

  for (StringRef Line : Lines) {
    Line = Line.trim();
    if (Line.empty() || !Line.startswith("BEC_DATA:"))
      continue;

    // Line format: BEC_DATA:mbb,mi,mop|bit:val,bit:val,
    // Split key and values
    auto MainSplit = Line.drop_front(9).split('|');
    StringRef Key = MainSplit.first;    // "0,5,2"
    StringRef Values = MainSplit.second; // "0:1,63:64,"

    FIResTy Entries;
    SmallVector<StringRef, 8> PairStrings;
    Values.split(PairStrings, ',', -1, false);

    for (StringRef PairStr : PairStrings) {
      if (PairStr.empty()) continue;
      
      auto BitVal = PairStr.split(':');
      unsigned BitPos, FaultIdx;
      
      if (!BitVal.first.getAsInteger(10, BitPos) && 
          !BitVal.second.getAsInteger(10, FaultIdx)) {
        Entries.push_back({(uint8_t)BitPos, (uint32_t)FaultIdx});
      }
    }

    ReliabilityMap[Key] = Entries;
  }

  LLVM_DEBUG(dbgs() << "BEC Module: Loaded " << ReliabilityMap.size() << " entries.\n");
  return true;
}

unsigned BECReliabilityModule::getUniqueBitIDCount(unsigned BB, unsigned MI, unsigned MOP) const {
  // Construct the key: "BB,MI,MOP"
  std::string Key = std::to_string(BB) + "," + std::to_string(MI) + "," + std::to_string(MOP);
  
  auto It = ReliabilityMap.find(Key);
  if (It == ReliabilityMap.end())
    return 0;

  const FIResTy &Entries = It->second;
  if (Entries.empty())
    return 0;

  // Use a set to count unique fault indices across the register bits
  std::set<uint32_t> UniqueIDs;
  for (const auto &Pair : Entries) {
    UniqueIDs.insert(Pair.second);
  }
  
  return UniqueIDs.size();
}

float BECReliabilityModule::getReliabilityFactor(unsigned BB, unsigned MI, unsigned MOP) const {
  unsigned UniqueIDs = getUniqueBitIDCount(BB, MI, MOP);
  
  if (UniqueIDs == 0)
    return 0.0f;

  // Example heuristic: Modify weight based on how many unique fault regions 
  // are packed into this register. More unique IDs = higher vulnerability = lesser spill weight.
  // We try to spill high vulnerability variables as they are safer in memory.
  // 1.0 - (UniqueIDs / 64.0) gives a scale between 0.0 and 1.0 for a 64-bit reg.
  return 1.0f - (static_cast<float>(UniqueIDs) / 64.0f);
}