`timescale 1ns / 1ps
`include "cpu_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/21 14:48:49
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input wire clk,
    input wire rst
    );

    wire[31:0] pc;
    wire[31:0] npc;
    wire[31:0] inst;

    //扩展立即数
    wire[31:0] ext_imm;      //扩展后的立即数

    //CU输入
    wire[6:0]  opcode;   // Instruction opcode, inst[6:0]
    wire       fun7;     //inst[30]
    wire[2:0]  fun3;     //inst[14:12]
    wire[1:0]  zero;     // For instruction BEQ, determining the result of rs - rt

    //控制信号
    wire[`NPC_OP_LENGTH  - 1:0]  nPC_sel;  //决定下一指令地址NPC，00:PC + 4，10:pc+imm,11:rD1+imm
    //wire                         RegDst;   //写入寄存器rd 0,rt 1二选一  //感觉可以省略
    wire                         RegWr;    //写寄存器使能信号
    wire[`EXT_OP_LENGTH  - 1:0]  ExtOp;    //Extend 模块控制信号源
    wire                         ALUAsrc;   //选择 ALU 源操作数来自0:reg1_data 或1:pc
    wire                         ALUBsrc;   //选择 ALU 源操作数来自寄存器或符号扩展的立即数
    wire[`ALU_CTR_LENGTH  - 1:0] ALUctr;   //ALU 控制信号（区分算术指令，比如 ADD、SUB 等）
    wire                         MemWr;    //写数据存储器使能信号
    wire[`MemtoReg_LENGTH - 1:0] MemtoReg;  //写回模块选择信号，选择将00:ALU 计算结果、01:数据存储器输出、10:Extend 模块输出写入寄存器

    //RF输入
    wire[ 4:0]  reg1_addr   ;//寄存器堆第一输出的地址
    wire[ 4:0]  reg2_addr   ;//寄存器堆第二输出的地址
    wire[ 4:0]  wr_reg_addr ;//写寄存器堆的寄存器号
    wire[31:0]  write_data  ;//写寄存器堆的写回数据
    wire[31:0]  reg1_data   ;//寄存器堆第一输出的数据
    wire[31:0]  reg2_data   ;//寄存器堆第二输出的数据

    //ALU
    wire[31:0]  alu_in_1;
    wire[31:0]  alu_in_2;
    wire[31:0]  alu_result;

    //DRAM
    wire[31:0]  read_men_data;

    //截取指令码
    assign opcode = inst[6:0];   
    assign fun7   = inst[30];     
    assign fun3   = inst[14:12];     

    PC My_PC(.clk(clk),
             .rst(rst),
             .npc(npc),
             .pc(pc));

    NPC My_NPC(.ext_imm(ext_imm),
               .reg1_data(reg1_data),
               .nPC_sel(nPC_sel),
               .pc(pc),
               .npc(npc));

    INST_MEMORY My_INST_MEMORY(.addr(pc[15:2]),
                               .clk(clk),
                               .inst(inst));
    
    CU My_CU(.opcode(opcode),
             .fun7(fun7),
             .fun3(fun3),
             .zero(zero),
             .nPC_sel(nPC_sel),
             //.RegDst(RegDst),  
             .RegWr(RegWr),   
             .ExtOp(ExtOp),    
             .ALUAsrc(ALUAsrc),  
             .ALUBsrc(ALUBsrc), 
             .ALUctr(ALUctr),  
             .MemWr(MemWr),    
             .MemtoReg(MemtoReg));

    RF My_RF(.clk(clk),
             .rst(rst),
             .reg1_addr(reg1_addr), 
             .reg2_addr(reg2_addr),
             .wr_reg_addr(wr_reg_addr),
             .RegWr(RegWr),
             .write_data(write_data),
             .reg1_data(reg1_data),
             .reg2_data(reg2_data));

    EXTEND My_EXTEND(.inst_imm(inst[31:7]),
                     .ExtOp(ExtOp),
                     .ext_imm(ext_imm));

    ALUA_MUX My_ALUA_MUX(.ALUAsrc(ALUAsrc),
                         .busA(reg1_data),
                         .pc(pc),
                         .alu_in_1(alu_in_1));

    ALUB_MUX My_ALUB_MUX(.ALUBsrc(ALUBsrc),
                         .busB(reg2_data),
                         .ext_imm(ext_imm),
                         .alu_in_2(alu_in_2));

    ALU My_ALU(.alu_in_1(alu_in_1),
               .alu_in_2(alu_in_2),
               .ALUctr(ALUctr),
               .zero(zero),
               .alu_result(alu_result));

    DATA_MEMORY My_DATA_MEMORY(.clk(clk),
                               .addr(alu_result),
                               .MemWr(MemWr),
                               .write_mem_data(reg2_data),
                               .read_mem_data(read_mem_data));

    WB_MUX My_WB_MUX(.alu_result(alu_result),
                     .read_mem_data(read_mem_data),
                     .ext_imm(ext_imm),
                     .MemtoReg(MemtoReg),
                     .write_data(write_data));
                     
endmodule
