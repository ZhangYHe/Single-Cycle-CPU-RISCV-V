`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/26 15:18:26
// Design Name: 
// Module Name: testbench
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


module testbench();

reg clk;
reg rst;
top My_top(.clk(clk), .rst(rst));

initial begin
    rst = 1;
    clk = 0;

    #30 rst = 0;

    //#50000 $stop;
end

always
    #20 clk = ~clk;

endmodule
