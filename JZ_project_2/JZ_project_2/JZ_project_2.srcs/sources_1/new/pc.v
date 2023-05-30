`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/22 20:49:41
// Design Name: 
// Module Name: pc
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


module PC(
    input                   clk     ,//CPU时钟
    input                   rst     ,//复位信号，高电平有效
    input           [31:0]  npc     ,//NPC模块的npc值
    
    output  reg     [31:0]  pc		 //PC模块的输出值pc
    );
    always @(posedge clk, posedge rst)
    begin
        if(rst)     pc <= 32'h0ffff_fffc;   //方便复位之后的第一个pc+4将为全0
        else        pc <= npc;			    //不复位时将npc作为pc的新值
    end
endmodule

