`timescale 1ns / 1ps
`include "cpu_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/24 15:24:50
// Design Name: 
// Module Name: extend
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


module EXTEND(
    input [31:7]                    inst_imm    ,//对立即数进行符号位扩展
    input [`EXT_OP_LENGTH  - 1:0]   ExtOp   ,

    output  reg [31:0]              ext_imm      //扩展后的立即数
    );

    always @(*)
    begin
            case(ExtOp)
            `EXT_OP_DEFAULT:         ext_imm = 32'b0;
            //符号位扩展
            `EXT_OP_I_12:
                if(inst_imm[31]) ext_imm = {20'h0fffff, inst_imm[31:20]};   //31为符号位
                else         ext_imm = {20'h000000, inst_imm[31:20]};
            `EXT_OP_I_6:
                //shamt[5]=0时，指令才有效
                if(inst_imm[21]) ext_imm = 32'h0;
                else         ext_imm = {26'h0, inst_imm[25:20]};
            `EXT_OP_S:
                if(inst_imm[11]) ext_imm = {20'h0fffff, inst_imm[11:7], inst_imm[31:25]};
                else         ext_imm = {20'h000000, inst_imm[11:7], inst_imm[31:25]};
            `EXT_OP_U_20:
                if(inst_imm[31]) ext_imm = {12'hfff, inst_imm[31:12]};
                else         ext_imm = {12'h000, inst_imm[31:12]};
            `EXT_OP_J:
                if(inst_imm[30]) ext_imm = {12'hfff, inst_imm[30:21], inst_imm[20], inst_imm[19:12], inst_imm[31]};
                else         ext_imm = {12'h000, inst_imm[30:21], inst_imm[20], inst_imm[19:12], inst_imm[31]};
            endcase
    end
endmodule


