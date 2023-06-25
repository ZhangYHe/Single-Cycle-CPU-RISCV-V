`timescale 1ns / 1ps
`include "cpu_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/24 15:58:12
// Design Name: 
// Module Name: alu
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


module ALU(
    input                    [31:0]  alu_in_1     ,
    input                    [31:0]  alu_in_2     ,
  
    input  [`ALU_CTR_LENGTH  - 1:0]  ALUctr       ,

    output               reg [ 1:0]  zero         ,
    output               reg [31:0]  alu_result	    //ALU运算结果
    );

    always @(*)
    begin
        case(ALUctr)

        `ALU_CTR_ADD:
        begin
            //[x]补+[y]补=[x+y]补
            alu_result = alu_in_1 + alu_in_2;
            zero = `ZERO_NONE;
        end

        `ALU_CTR_SUB:
        begin
            //[x-y]补=[x]补-[y]补=[x]补+[-y]补
            //[-y补]=~[y]补+1
            alu_result = alu_in_1 - alu_in_2;
            if(alu_result==0)   zero = `ZERO_EQU;
            else                zero = (alu_in_1 < alu_in_2) ? `ZERO_LESS : `ZERO_GREATER;
        end
        
        `ALU_CTR_SLLI:
        begin
            alu_result = alu_in_1 << alu_in_2;
            zero = `ZERO_NONE;
        end

        `ALU_CTR_PC4:
        begin
            //PC+4
            alu_result = alu_in_1 + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
            zero = `ZERO_NONE;
        end
        endcase
    end
endmodule

