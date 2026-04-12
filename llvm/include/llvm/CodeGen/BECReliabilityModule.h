#ifndef LLVM_CODEGEN_BECRELIABILITYMODULE_H
#define LLVM_CODEGEN_BECRELIABILITYMODULE_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/CommandLine.h"
#include <string>

namespace llvm {

class MachineInstr;

class BECReliabilityModule {
public:
  // Data type for bit-level fault information: <bit_position, fault_index>
  // SmallVector<..., 4> is optimized for the typical number of coalesced ranges
  using FIResTy = SmallVector<std::pair<uint8_t, uint32_t>, 4>;

private:
  // Map to store "MBB_ID,MI_ID,MOP_ID" -> list of <bit, fault_idx> pairs
  StringMap<FIResTy> ReliabilityMap;

  // Internal storage for the map file path
  std::string FaultIndexMapPath;

public:
  /**
   * Constructor
   * @param Path Path to the generated fault map file. 
   * Defaults to the relative path from the build directory.
   */
  BECReliabilityModule(std::string Path = "../fault_map/fault_map.txt");

  /**
   * Parses the BEC_DATA lines from the text file into the ReliabilityMap.
   * @return true if the file was loaded successfully, false otherwise.
   */
  bool loadMap();

  /**
   * Calculates a weight multiplier based on bit-level vulnerability.
   * @param BB Basic Block index
   * @param MI Instruction index (skipping debug instructions)
   * @param MOP Operand index
   * @return A float multiplier (e.g., 1.0 + (unique_bits / 64.0))
   */
  float getReliabilityFactor(unsigned BB, unsigned MI, unsigned MOP) const;

  /**
   * Helper to count unique fault indices for a specific operand.
   * Useful for the weight calculation logic.
   */
  unsigned getUniqueBitIDCount(unsigned BB, unsigned MI, unsigned MOP) const;

  // Clear the map (useful if processing multiple functions or re-loading)
  void clear() { ReliabilityMap.clear(); }

  // Check if the map is empty
  bool isEmpty() { return ReliabilityMap.empty(); }
};

} // end namespace llvm

#endif // LLVM_CODEGEN_BECRELIABILITYMODULE_H