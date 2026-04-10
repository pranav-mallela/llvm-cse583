#ifndef LLVM_CODEGEN_BECRELIABILITYMODULE_H
#define LLVM_CODEGEN_BECRELIABILITYMODULE_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/StringRef.h"
#include <vector>

namespace llvm {

class MachineInstr;

class BECReliabilityModule {
public:
    // A simple structure to store the fault index for each bit (0-63)
    struct BitFaultMap {
        unsigned BitIndices[64];
        
        // Helper to count how many unique IDs exist in this register
        unsigned countUniqueIDs() const;
    };

private:
    // Key: Instruction "Address" or Index from your file
    // Value: The bit-level fault data
    DenseMap<unsigned, BitFaultMap> InstructionMap;
    
    // Since you might have multiple functions, you might need a map of maps
    // or clear it per function.
    StringMap<DenseMap<unsigned, BitFaultMap>> FunctionGrids;

public:
    BECReliabilityModule() = default;

    // The core functions you'll call from CalcSpillWeights
    bool loadMap(StringRef FilePath);
    float getReliabilityFactor(const MachineInstr &MI, unsigned OpIdx) const;
    
    // Helper to clear data between functions if necessary
    void clear() { FunctionGrids.clear(); }
};

} // end namespace llvm

#endif // LLVM_CODEGEN_BECRELIABILITYMODULE_H