`timescale 1ns / 1ps
`include "cpu_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/24 16:54:37
// Design Name: 
// Module Name: write_back_mux
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


module WB_MUX(
    input   [31:0]                   alu_result         ,
    input   [31:0]                   read_mem_data      ,
    input   [31:0]                   ext_imm            ,
    input   [`MemtoReg_LENGTH - 1:0] MemtoReg           ,

    output  reg [31:0]  write_data
    );

    always @(*)  
    begin
        case(MemtoReg)
        `MemtoReg_ALU:      write_data = alu_result;
        `MemtoReg_MEM:      write_data = read_mem_data;
        `MemtoReg_EXT:      write_data = ext_imm;
        `MemtoReg_DEFAULT:  write_data = 32'h0  ;
        endcase
    end

endmodule
