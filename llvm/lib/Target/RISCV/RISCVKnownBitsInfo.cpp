//===-- RISCVKnownBitsInfo.cpp - RISCV KnownBitsInfo Impl -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the interfaces that RISCV uses for KnownBitsAnalysis
// analysis.
//
//===----------------------------------------------------------------------===//

#include "RISCVKnownBitsInfo.h"
#include "RISCV.h"
#include "RISCVSubtarget.h"
#include "RISCVTargetMachine.h"
#include "llvm/CodeGen/PhysKnownBitsAnalysis.h"
#include "llvm/Support/KnownBits.h"

using namespace llvm;

#define LOCAL_LLVM_DEBUG(x){}
#define DEBUG_TYPE "riscv-knownbitsinfo"

RISCVKnownBitsInfo::RISCVKnownBitsInfo(const TargetMachine &TM,
                                       const RISCVSubtarget &STI)
    : TargetKnownBitsInfo(TM), Subtarget(STI), TRI(*STI.getRegisterInfo()) {}

void RISCVKnownBitsInfo::computeKnownBitsForPhysReg(PhysKnownBitsAnalysis &AA,
    MachineOperand* MOP, KnownBits &Known, const APInt &DemandedElts,
    const MachineRegisterInfo &MRI, unsigned Depth) const {
  unsigned BitWidth = TRI.getRegSizeInBits(MOP->getReg(), MRI);

  MachineInstr &defMI = *MOP->getParent();
  unsigned Opcode = defMI.getOpcode();
  KnownBits Known2;

  // Set the KnownBits for the src regs.
  switch (Opcode) {
  default:
    break;
  case TargetOpcode::COPY: {
    if (defMI.getOperand(1).isReg())
      AA.computeKnownBitsImpl(&defMI.getOperand(1), Known, DemandedElts, Depth);
    else if (defMI.getOperand(1).isImm())
      getKnownBitsImm(defMI, 1, BitWidth, Known);
    else
      Known = KnownBits(BitWidth);
    break;
  }
  case RISCV::SUB:
  case RISCV::XOR:
  case RISCV::ADD:
  case RISCV::AND:
  case RISCV::OR:
  case RISCV::MUL:
  case RISCV::SLT:
  case RISCV::SLTU:
  case RISCV::SLL:
  case RISCV::SRL:
  case RISCV::SRA: {
    if (defMI.getOperand(2).isReg())
      AA.computeKnownBitsImpl(&defMI.getOperand(2), Known2, DemandedElts,
                           Depth + 1);
    else
      Known2 = KnownBits(BitWidth);

    if (defMI.getOperand(1).isReg())
      AA.computeKnownBitsImpl(&defMI.getOperand(1), Known, DemandedElts,
                           Depth + 1);
    else
      Known = KnownBits(BitWidth);
    break;
  }
  case RISCV::XORI:
  case RISCV::ADDI:
  case RISCV::ANDI:
  case RISCV::ORI:
  case RISCV::SLTI:
  case RISCV::SLTIU:
  case RISCV::SLLI:
  case RISCV::SRLI:
  case RISCV::SRAI: {
    if (defMI.getOperand(1).isReg())
      AA.computeKnownBitsImpl(&defMI.getOperand(1), Known, DemandedElts,
                           Depth + 1);
    else
      Known = KnownBits(BitWidth);
    getKnownBitsImm(defMI, 2, BitWidth, Known2);
    break;
  }
  }

  // In case of binary operators, compute KnownBits of the right-hand operand
  // first, as it seems the analyzer canonicalize simpler expressions to the
  // right-hand operand.
  switch (Opcode) {
  default:
    LOCAL_LLVM_DEBUG(dbgs() << "RISCVKnownBitsInfo: Unidentified Opcode\n";
               defMI.dump());
    break;
  case RISCV::SUB: {
    Known = KnownBits::computeForAddSub(/*Add*/ false, /*NSW*/ false, Known,
                                        Known2);
    break;
  }
  case RISCV::XOR: {
    Known ^= Known2;
    break;
  }
  case RISCV::XORI: {
    Known ^= Known2;
    break;
  }
  case RISCV::ADD: {
    Known =
        KnownBits::computeForAddSub(/*Add*/ true, /*NSW*/ false, Known, Known2);
    break;
  }
  case RISCV::ADDI: {
    Known =
        KnownBits::computeForAddSub(/*Add*/ true, /*NSW*/ false, Known, Known2);
    break;
  }
  case RISCV::AND: {
    Known &= Known2;
    break;
  }
  case RISCV::ANDI: {
    Known &= Known2;
    break;
  }
  case RISCV::OR: {
    Known |= Known2;
    break;
  }
  case RISCV::ORI: {
    Known |= Known2;
    break;
  }
  case RISCV::MUL: {
    Known = KnownBits::mul(Known, Known2);
    break;
  }
  case RISCV::SLT: {
    if (KnownBits::slt(Known, Known2))
      Known = KnownBits::makeConstant(APInt(BitWidth, 1));
    else if (KnownBits::sge(Known, Known2))
      Known = KnownBits::makeConstant(APInt(BitWidth, 0));
    else {
      Known.setAllZero();
      Known.setUnknown(0);
    }
    break;
  }
  case RISCV::SLTU: {
    if (KnownBits::ult(Known, Known2))
      Known = KnownBits::makeConstant(APInt(BitWidth, 1));
    else if (KnownBits::uge(Known, Known2))
      Known = KnownBits::makeConstant(APInt(BitWidth, 0));
    else {
      Known.setAllZero();
      Known.setUnknown(0);
    }
    break;
  }
  case RISCV::SLTI: {
    if (KnownBits::slt(Known, Known2))
      Known = KnownBits::makeConstant(APInt(BitWidth, 1));
    else if (KnownBits::sge(Known, Known2))
      Known = KnownBits::makeConstant(APInt(BitWidth, 0));
    else {
      Known.setAllZero();
      Known.setUnknown(0);
    }
    break;
  }
  case RISCV::SLTIU: {
    if (KnownBits::ult(Known, Known2))
      Known = KnownBits::makeConstant(APInt(BitWidth, 1));
    else if (KnownBits::uge(Known, Known2))
      Known = KnownBits::makeConstant(APInt(BitWidth, 0));
    else {
      Known.setAllZero();
      Known.setUnknown(0);
    }
    break;
  }
  case RISCV::SLL: {
    Known = KnownBits::shl(Known, Known2);
    break;
  }
  case RISCV::SLLI: {
    Known = KnownBits::shl(Known, Known2);
    break;
  }
  case RISCV::SRL: {
    Known = KnownBits::lshr(Known, Known2);
    break;
  }
  case RISCV::SRLI: {
    Known = KnownBits::lshr(Known, Known2);
    break;
  }
  case RISCV::SRA: {
    Known = KnownBits::ashr(Known, Known2);
    break;
  }
  case RISCV::SRAI: {
    Known = KnownBits::ashr(Known, Known2);
    break;
  }
  case RISCV::LUI: {
    if (defMI.getOperand(1).isImm()) {
      int64_t C = defMI.getOperand(1).getImm() << 12;
      APInt APC = APInt(BitWidth, std::abs(C));
      if (C  < 0)
        APC.negate();
      Known = KnownBits::makeConstant(APC);
    } else {
      LOCAL_LLVM_DEBUG(dbgs() << "++ Not an imm: "; defMI.getOperand(1).dump());
      Known = KnownBits(BitWidth);
      Known.resetAll();
    }
    break;
  }
  case RISCV::PseudoLI: {
    getKnownBitsImm(defMI, 1, BitWidth, Known);
    break;
  }
  // mem load instructions.
  case RISCV::LD:
  case RISCV::LB:
  case RISCV::LH:
  case RISCV::LW:
  case RISCV::LBU:
  case RISCV::LHU:
  case RISCV::LWU:
  case RISCV::PseudoLB:
  case RISCV::PseudoLBU:
  case RISCV::PseudoLH:
  case RISCV::PseudoLHU:
  case RISCV::PseudoLW:
  {
    // All bits unknown.
    Known.resetAll();
    break;
  }
  case RISCV::SB:
  case RISCV::SH:
  case RISCV::SW:
  case RISCV::SD:
  case RISCV::PseudoSB:
  case RISCV::PseudoSH:
  case RISCV::PseudoSW:
  {
    break;
  }
  // Branch instructions.
  case RISCV::BEQ:
  case RISCV::BNE:
  case RISCV::BGE:
  case RISCV::BGEU:
  case RISCV::BLT:
  case RISCV::BLTU:
  {
    break;
  }
  // Instructions with no data update.
  case RISCV::URET:
  case RISCV::SRET:
  case RISCV::MRET:
  case RISCV::DRET:
  {
    break;
  }
  // FIXME: could be improved?
  // FIXME: are these reachable?
  case RISCV::AUIPC:
  case RISCV::PseudoLLA:
  case RISCV::PseudoLA:
  case RISCV::PseudoLA_TLS_IE:
  case RISCV::PseudoLA_TLS_GD:
  case RISCV::JAL:
  case RISCV::JALR:
  {
    // All bits unknown.
    Known.resetAll();
    break;
  }
  // FIXME: could be improved?
  case RISCV::CSRRW:
  case RISCV::CSRRS:
  case RISCV::CSRRC:
  case RISCV::CSRRWI:
  case RISCV::CSRRSI:
  case RISCV::CSRRCI:
  {
    // All bits unknown.
    Known.resetAll();
    break;
  }
  // FIXME: 64-bit instrs
  case RISCV::ADDIW:
  case RISCV::SLLIW:
  case RISCV::SRLIW:
  case RISCV::SRAIW:
  case RISCV::ADDW:
  case RISCV::SUBW:
  case RISCV::SLLW:
  case RISCV::SRLW:
  case RISCV::SRAW:
  case RISCV::PseudoLWU:
  case RISCV::PseudoLD:
  case RISCV::PseudoSD:
  {
    // All bits unknown.
    Known.resetAll();
    break;
  }
  }
}

void RISCVKnownBitsInfo::getComputeKnownBitsCacheInit(
    DenseMap<Register, KnownBits> &cacheInitMap,
    const MachineRegisterInfo &MRI) const {
  KnownBits K = KnownBits(TRI.getRegSizeInBits(RISCV::X0, MRI));
  K.setAllZero();
  cacheInitMap[RISCV::X0] = K;
}

void RISCVKnownBitsInfo::getKnownBitsImm(const MachineInstr &MI,
    unsigned OpIdx, unsigned BitWidth, KnownBits &Known) const {
  if (!MI.getOperand(OpIdx).isImm()) {
    LOCAL_LLVM_DEBUG(dbgs() << "RISCVKnownBitsInfo::Not an imm: ";
               MI.getOperand(OpIdx).dump());
    Known = KnownBits(BitWidth);
    Known.resetAll();
    return;
  }
  int64_t C = MI.getOperand(OpIdx).getImm();
  APInt APC = APInt(BitWidth, std::abs(C));
  if (C  < 0)
    APC.negate();
  Known = KnownBits::makeConstant(APC);
}
