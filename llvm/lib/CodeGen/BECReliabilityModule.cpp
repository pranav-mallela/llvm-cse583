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
  if (std::error_code EC = BufferOrErr.getError()) {
    llvm::errs() << "BEC Module Error (" << EC.value() << "): " << EC.message() << "\n";
    llvm::errs() << "Attempted path: " << FaultIndexMapPath << "\n";
    return false;
}

  StringRef Content = BufferOrErr.get()->getBuffer();
  SmallVector<StringRef, 16> Lines;
  Content.split(Lines, '\n');

  for (StringRef Line : Lines) {
    Line = Line.trim();
    if (Line.empty() || !Line.startswith("BEC_DATA:"))
      continue;

    // Line format: BEC_DATA:line,col|bit:val,bit:val,
    // Split key and values
    auto MainSplit = Line.drop_front(9).split('|');
    StringRef Key = MainSplit.first;    // "0,5"
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

    // Append to existing entries for the same key instead of overwriting
    ReliabilityMap[Key].insert(ReliabilityMap[Key].end(), 
                               Entries.begin(), Entries.end());
  }

  llvm::errs() << "BEC Module: Loaded " << ReliabilityMap.size() << " entries.\n";
  return true;
}

float BECReliabilityModule::getUniqueBitIDCountNormalized(unsigned Line, unsigned Col) const {
  // Construct the key: "line,column"
  std::string Key = std::to_string(Line) + "," + std::to_string(Col);

  
  auto It = ReliabilityMap.find(Key);
  if (It == ReliabilityMap.end())
    return -1; // Indicate no data available for this operand

  const FIResTy &Entries = It->second;
  if (Entries.empty())
    return -1; // Indicate no data available for this operand

  // Use a set to count unique fault indices across the register bits
  std::set<uint32_t> UniqueIDs;
  for (const auto &Pair : Entries) {
    UniqueIDs.insert(Pair.second);
  }
  
  unsigned totalValues = Entries.size();

  return static_cast<float>(UniqueIDs.size()) / static_cast<float>(totalValues);
}

float BECReliabilityModule::getReliabilityFactor(unsigned Line, unsigned Col) const {
  float normalized_UniqueIDs = getUniqueBitIDCountNormalized(Line, Col);
  llvm::errs() << "Calculating BEC Reliability Factor for Line: " << Line 
                    << ", Col: " << Col 
                    << "\n=> Normalized Unique IDs (0 - 1): " << normalized_UniqueIDs << "\n";
  if (normalized_UniqueIDs == -1)
    return 0.0f;

  // Example heuristic: Modify weight based on how many unique fault regions 
  // are packed into this register. More unique IDs = higher vulnerability = lesser spill weight.
  // We try to spill high vulnerability variables as they are safer in memory.
  // 1.0 - (UniqueIDs / 64.0) gives a scale between 0.0 and 1.0 for a 64-bit reg.
  return 1.0f - normalized_UniqueIDs;
}