`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/24 16:52:15
// Design Name: 
// Module Name: alub_mux
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


module  ALUB_MUX(
    input             ALUBsrc  ,
    input     [31:0]  busB     ,
    input     [31:0]  ext_imm  ,

    output    [31:0]  alu_in_2     
    );

    assign  alu_in_2 = ALUBsrc ? ext_imm : busB; //1：ext_imm，0：busB

endmodule
