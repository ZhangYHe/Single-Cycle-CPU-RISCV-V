`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/24 16:49:06
// Design Name: 
// Module Name: alua_mux
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


module  ALUA_MUX(
    input             ALUAsrc  ,
    input     [31:0]  busA     ,
    input     [31:0]  pc       ,

    output    [31:0]  alu_in_1     
    );

    assign  alu_in_1 = ALUAsrc ? pc : busA; //1：pc，0：busA

endmodule
