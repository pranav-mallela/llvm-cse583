//==- TestBECReliabilityModule.cpp - Test Script to debug BECReliabilityModule capabilities --==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// #include "llvm/CodeGen/BECReliabilityModule.h"
// #include "llvm/Support/FileSystem.h"
// #include "llvm/Support/raw_ostream.h"
// #include <iostream>

// using namespace llvm;

// Helper to create a dummy map file for testing
// void createDummyMap(const std::string &Path) {
//   std::error_code EC;
//   raw_fd_ostream OS(Path, EC, sys::fs::OF_None);
//   if (EC) {
//     errs() << "Could not create test file: " << EC.message() << "\n";
//     return;
//   }

//   // Format: BEC_DATA:mbb,mi,mop|bit:val,bit:val,
//   OS << "BEC_DATA:0,1,0|0:10,32:11,63:11,\n"; // 2 unique IDs (10 and 11)
//   OS << "BEC_DATA:0,1,1|0:5,10:6,20:7,30:8,\n"; // 4 unique IDs
//   OS << "BEC_DATA:1,10,2|0:100,63:100,\n";      // 1 unique ID
//   OS.flush();
// }

// int main() {
//   std::string TestFile = "test_fault_map.txt";
  
//   outs() << "--- Starting BECReliabilityModule Test ---\n";
  
//   // 1. Create dummy data
//   createDummyMap(TestFile);
//   outs() << "[1/4] Created dummy map file: " << TestFile << "\n";

//   // 2. Initialize Module
//   BECReliabilityModule BECMod(TestFile);
  
//   // 3. Test loadMap
//   if (BECMod.loadMap()) {
//     outs() << "[2/4] Successfully loaded map.\n";
//   } else {
//     errs() << "[ERROR] Failed to load map.\n";
//     return 1;
//   }

//   // 4. Verify specific entries
//   // Test Case A: Operand with 2 unique IDs
//   unsigned CountA = BECMod.getUniqueBitIDCount(0, 1, 0);
//   float FactorA = BECMod.getReliabilityFactor(0, 1, 0);
//   outs() << "[3/4] Testing BB:0, MI:1, MOP:0 -> Expecting 2 IDs\n";
//   outs() << "      Found: " << CountA << " IDs, Factor: " << FactorA << "\n";

//   // Test Case B: Operand with 4 unique IDs
//   unsigned CountB = BECMod.getUniqueBitIDCount(0, 1, 1);
//   outs() << "[4/4] Testing BB:0, MI:1, MOP:1 -> Expecting 4 IDs\n";
//   outs() << "      Found: " << CountB << " IDs\n";

//   // Test Case C: Missing entry
//   unsigned CountC = BECMod.getUniqueBitIDCount(99, 99, 99);
//   outs() << "Checking missing entry (99,99,99) -> Expecting 0: " << CountC << "\n";

//   if (CountA == 2 && CountB == 4 && CountC == 0) {
//     outs() << "\n*** TEST PASSED ***\n";
//   } else {
//     errs() << "\n*** TEST FAILED ***\n";
//   }

//   // Cleanup
//   sys::fs::remove(TestFile);
  
//   return 0;
// }