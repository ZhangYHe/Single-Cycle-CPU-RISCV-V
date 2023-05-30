`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/23 20:07:18
// Design Name: 
// Module Name: inst_memory
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


module INST_MEMORY(
    input   [15:2]  addr,//是pc信号的部分截取
    output  [31:0]  inst //32位risv-v架构的指令

    );

    //IROM
    instruction_memory_ip IROM (
      //.clka(clka),    // input wire clka
      .addra(addr[15:2]),  // input wire [15:2] addra
      .douta(inst)  // output wire [31 : 0] douta
    );

endmodule
