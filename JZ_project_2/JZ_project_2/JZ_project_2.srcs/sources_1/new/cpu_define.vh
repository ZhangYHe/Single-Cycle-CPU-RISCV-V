/* Module: Instruction Control Signals
 *
 * Define: LUI, ADDIU, ADD, LW, SW, BEQ, J, SUBU
 */

// Instruction Memory Capacity
`define IM_LENGTH       1023
// Data Memory Capacity
`define DM_LENGTH       1023
// Default register data (32 digits of 0)
`define INITIAL_VAL     32'h00000000

// R-Type instructions
`define INST_R_TYPE     6'b000000  // R-Type opcode, decode via function code
`define FUNC_ADD        6'b100000  // ADD func code
`define FUNC_SUBU       6'b100011  // SUBU func code

// I-Type instructions
`define INST_LUI        6'b001111  // LUI
`define INST_ADDIU      6'b001001  // ADDIU
`define INST_LW         6'b100011  // LW
`define INST_SW         6'b101011  // SW
`define INST_BEQ        6'b000100  // BEQ

// ALU Control Signals
// `define ALU_OP_LENGTH   3          // Bits of signal ALUOp
// `define ALU_OP_DEFAULT  3'b000     // ALUOp default value
// `define ALU_OP_ADD      3'b001     // ALUOp ADD
// `define ALU_OP_SUB      3'b010     // ALUOp SUB
`define ALU_CTR_LENGTH  4          //ALU 控制信号（区分算术指令，比如 ADD、SUB 等）
`define ALU_CTR_ADD     4'b0001     // ALUOp ADD
`define ALU_CTR_SUB     4'b0010     // ALUOp SUB
`define ALU_CTR_SLLI    4'b0011     // ALUOp SLLI,逻辑左移，低位补零
// RegDst Control Signals
`define REG_DST_RT      1'b0       // Register write destination: rt
`define REG_DST_RD      1'b1       // Register write destination: rd

// ALUSrc Control Signals
`define ALU_SRC_REG     1'b0       // ALU source: register file
`define ALU_SRC_IMM     1'b1       // ALU Source: immediate

// RegSrc Control Signals
`define MemtoReg_LENGTH  2          //写回模块选择信号，选择将 ALU 计算结果、数据存储器输出或 Extend 模块输出写入寄存器
`define MemtoReg_ALU     2'b00      
`define MemtoReg_MEM     2'b01      
`define MemtoReg_EXT     2'b10      
`define MemtoReg_DEFAULT 2'b11 

// ExtOp Control Signals
`define EXT_OP_LENGTH   3          //Extend 模块控制信号源
`define EXT_OP_DEFAULT  3'b000     // ExtOp default value
`define EXT_OP_I_12     3'b001     // I型指令，12位有符号补码
`define EXT_OP_I_6      3'b010     // I型指令，6位有符号补码,最高位为0有效，用于slli
`define EXT_OP_S        3'b011
`define EXT_OP_U_20     3'b100     //U型指令，20位扩展至32位
`define EXT_OP_J        3'b100     //pc+4 -> rd
// `define EXT_OP_DEFAULT  2'b00      // ExtOp default value
// `define EXT_OP_SFT16    2'b01      // LUI: Shift Left 16
// `define EXT_OP_SIGNED   2'b10      // ADDIU: `imm16` signed extended to 32 bit
// `define EXT_OP_UNSIGNED 2'b11      // LW, SW: `imm16` unsigned extended to 32 bit

// NPCOp Control Signals
`define NPC_OP_LENGTH   2          //决定下一指令地址NPC，或为PC + 4，或为pc+imm,或为rD1+imm
// `define NPC_OP_DEFAULT  3'b000     // NPCOp default value
// `define NPC_OP_NEXT     3'b001     // Next instruction: normal
// `define NPC_OP_JUMP     3'b010     // Next instruction: J
// `define NPC_OP_OFFSET   3'b011     // Next instruction: BEQ
`define NPC_NEXT        2'b00       //pc+4
`define NPC_IMM         2'b10       //pc+imm
`define NPC_R_IMM      2'b11       //rD1+imm

// opcode
`define INST_R          7'b0110011  // R
`define INST_I_AL       7'b0010011  // I 算数指令
`define INST_I_LOAD     7'b0000011  // I-load
`define INST_I_JALR     7'b1100111  // I-jalr
`define INST_S          7'b0100011  // S
`define INST_U_AUIPC    7'b0010111  // U-auipc
// `define INST_U_lui      7'b0110111  // U-lui
`define INST_B          7'b1100011  // B
`define INST_J_JAL      7'b1101111  // J-jal

`define ZERO_EQU        2'b00
`define ZERO_LESS       2'b01
`define ZERO_GREATER    2'b10
`define ZERO_NONE       2'b11       //非减法

