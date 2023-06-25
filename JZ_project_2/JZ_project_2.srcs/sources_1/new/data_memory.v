`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/24 16:30:49
// Design Name: 
// Module Name: data_memory
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


module DATA_MEMORY(
    input                   clk             ,
    input       [15:0]      addr            ,//alu单元运算结果就是地址
    input                   MemWr           ,
    input       [31:0]      write_mem_data  ,//输入数据就是RF的输出信号rD2

    output      [31:0]      read_mem_data
    );

    data_memory_ip DRAM (
      .a(addr[9 : 0]),      // input wire [9 : 0] a     //这里可能有问题
      .d(write_mem_data),      // input wire [31 : 0] d
      .clk(clk),  // input wire clk
      .we(MemWr),    // input wire we
      .spo(read_mem_data)  // output wire [31 : 0] spo
    );
endmodule
