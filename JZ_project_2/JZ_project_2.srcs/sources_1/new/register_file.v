`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/23 20:43:15
// Design Name: 
// Module Name: register_file
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


module RF(
    input               clk         ,
    input               rst         ,
    input       [ 4:0]  reg1_addr   ,//寄存器堆第一输出的地址
    input       [ 4:0]  reg2_addr   ,//寄存器堆第二输出的地址
    input       [ 4:0]  wr_reg_addr ,//写寄存器堆的寄存器号
    input               RegWr       ,//写寄存器控制信号
    input       [31:0]  write_data  ,//写寄存器堆的写回数据
    
    output  reg [31:0]  reg1_data   ,//寄存器堆第一输出的数据
    output  reg [31:0]  reg2_data    //寄存器堆第二输出的数据
    );

    reg     [31:0]  rf [1:31];	//用二维信号定义了寄存器堆，实际上只有31个，x0恒为0不需要定义
    
    //读
    always @(*)
    begin
        reg1_data <= reg1_addr ? rf[reg1_addr] : 32'h0;
        reg2_data <= reg2_addr ? rf[reg2_addr] : 32'h0;
    end
    
    //写
    always @(posedge clk, posedge rst)
    begin
        if(rst)
        begin
            /*...全部置零操作*/
        end
        else if(RegWr)
        begin
            rf[wr_reg_addr] <= wr_reg_addr ? write_data : 32'h0;
        end
        else;
    end
endmodule
