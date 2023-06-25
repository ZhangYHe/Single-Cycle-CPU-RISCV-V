`timescale 1ns / 1ps
`include "cpu_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/22 21:05:41
// Design Name: 
// Module Name: npc
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


module NPC(
    input   [31:0]                    ext_imm ,//符号扩展结果
    input   [31:0]                    reg1_data    ,//寄存器的第一输出
    input   [`NPC_OP_LENGTH  - 1:0]   nPC_sel ,//来自CU单元，用于分支和跳转指令
    input   [31:0]                    pc      ,

    output  [31:0]                    npc
    );

    //!!!!!!cu中关于这里的逻辑有问题
    
    //00时pc+4，10时pc + imm，11时pc = reg1_data + imm
    assign npc= nPC_sel[0] ? (nPC_sel[1] ? reg1_data + ext_imm : pc + ext_imm) : pc + 4;
    
endmodule

