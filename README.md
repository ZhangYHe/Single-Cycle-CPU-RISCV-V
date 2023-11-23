# Single-Cycle-CPU-RISCV-V
Single Cycle CPU RISCV-V

2023 北京理工大学 计算机组成与体系结构 课程大作业 : Lab 2

实验二：单周期CPU设计

## CPU Data Path

<img src="./Single Cycle CPU Data Path.png" alt="CPU Data Path"  />

## 实验目的

1. 掌握RISCV指令格式与编码，掌握RISC-V汇编转换成机器代码的方法。

2. 掌握单周期CPU的数据通路与控制器设计方法。

3. 掌握硬件描述语言与EDA工具。

4. 掌握基本测试与调试方法。

## 实验环境

1. 硬件描述语言Verilog HDL

2. Vivado版本：2019.2

3. 代码编辑器 Visual Studio code

4. RISC-V仿真器：RARS下载地址<https://github.com/TheThirdOne/rars>

5. RARS需要配置Java环境，java版本：16.0.2

6. 操作系统：windows 10。

## 实验内容

1. 设计并实现单周期处理器，支持包含RISC-V
    RV32I整数指令（LW，SW，ADD，SUB， ORI，BEQ）在内的指令子集等。

2. 测试程序：完成2后在该cpu上实现对5个整数的排序，仿真测试结果与RARS中运行结果对比正确。

3. 乐学提交实验报告、工程源代码和测试程序。

## 实验过程及步骤

### 确定指令功能及数目

首先确定指令集指令条数、指令格式及编码。本次实验中共使用11条RISC-V指令.

### 设计数据通路

按照模块化方式设计数据通路，数据通路如图所示。本次实验设计的单周期CPU共分为12个模块，分别为PC,NPC,Instruction
Memory,Control Unit,Instruction Decoder,Extend Unit,Register
File,ALU,Data Memory和三个MUX模块。

### 设计控制信号

根据数据通路设计结果，设计控制信号。ALUASrc为多路选择器选择信号，1选择pc作为输出，0选择寄存器1数据作为输出。ALUBSrc为多路选择器选择信号，1选择扩展立即数作为输出，0选择寄存器2数据作为输出。MemtoReg为多路选择器选择信号，选择ALU、内存数据、扩展立即数作为输出。RegWr为寄存器堆写使能信号。MemWrite为内存写使能信号。nPC_sel为NPC控制信号，选择下一条指令的地址为pc+4或xrs1+imm或pc+imm。ExtOP为符号位扩展模块选择信号。ALUctr为ALU运算指令选择信号。

### 模块设计

#### top

top.v中为顶层控制模块，负责连接CPU各个模块，将输出送入相应模块。

    module top(
    input wire clk,
    input wire rst
    );

#### Control Unit

Control
Unit负责生成控制信号。CU根据输入的操作码、指令类型等，生成控制信号。共有八种控制信号，分别为nPC_sel、RegWr、ExtOp、ALUASrc、ALUBSrc、ALUctr、MemWr、MemtoReg。

CU模块部分代码如下所示。

     case(opcode)
    `INST_R:  //add、sub
    begin
    nPC_sel     = `NPC_NEXT;
    //RegDst      = 0;
    RegWr       = 1;
    ExtOp       = `EXT_OP_DEFAULT;  
    ALUAsrc     = 0; 
    ALUBsrc     = 0;  
    MemWr       = 0;   
    MemtoReg    = `MemtoReg_ALU;

    case(fun3)
    //add sub
    3'b000:     
    case(fun7)
    1'b0:   ALUctr = `ALU_CTR_ADD;
    1'b1:   ALUctr = `ALU_CTR_SUB;
    endcase
    endcase
    end

#### PC

PC模块负责根据NPC模块输出，生成下一条指令。

PC模块部分代码如下所示。

    always @(posedge clk, posedge rst)
    begin
    //if(rst)     pc <= 32'h0ffff_fffc;   //方便复位之后的第一个pc+4将为全0
    if(rst)     pc <= 32'h0000_0000;
    else        pc <= npc;			    //不复位时将npc作为pc的新值
    end

#### NPC

NPC模块负责根据nPC_sel生成下一条指令。nPC_sel为00时下一条指令为pc+4；nPC_sel为为10时下一条指令为pc +
imm立即数；nPC_sel为11时下一条指令为reg1_data + imm立即数。

NPC模块部分代码如下所示。

    module NPC(
    input   [31:0]                    ext_imm ,//符号扩展结果
    input   [31:0]                    reg1_data    ,//寄存器的第一输出
    input   [`NPC_OP_LENGTH  - 1:0]   nPC_sel ,//来自CU单元，用于分支和跳转指令
    input   [31:0]                    pc      ,

    output  [31:0]                    npc
    );

    //00时pc+4，10时pc + imm，11时pc = reg1_data + imm
    assign npc= nPC_sel[0] ? (nPC_sel[1] ? reg1_data + ext_imm : pc + ext_imm) : pc + 4;

    endmodule

#### INST_MEMORY

INST_MEMORY为指令存储器，存储程序的指令。编写RISC-V代码，使用RARS生成二进制指令文件。使用vivado中的Block
Memory Generator IP核作为指令存储器，将二进制文件导入IP核中完成初始化。

INST_MEMORY模块部分代码如下所示。

    module INST_MEMORY(
    input   [15:2]  addr,//是pc信号的部分截取
    input           clk,
    output  [31:0]  inst //32位risv-v架构的指令

    );

    //IROM
    instruction_memory_ip IROM (
    .clka(clk),    // input wire clka
    .addra(addr[15:2]),  // input wire [15:2] addra
    .douta(inst)  // output wire [31 : 0] douta
    );

    endmodule

#### Register_File

Register_File为寄存器堆，可以进行寄存器读写。RISC-V有32个整数寄存器，用二维信号定义了寄存器堆，实际上只有31个，x0恒为0不需要定义。

Register_File模块部分代码如下所示。

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

#### EXTEND

EXTEND为立即数扩展模块。在CU中根据指令类型生成立即数扩展信号ExtOp，EXTEND模块根据ExtOp，输出符号位扩展后的32位立即数。

EXTEND模块部分代码如下所示。

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

#### ALU_MUX

ALU_MUX有ALUA_MUX、ALUB_MUX两种多路选择器，分别对ALU的两个输入数据进行选择。ALUA_MUX选择pc或busA的数据，ALUB_MUX选择扩展后的立即数或者busB的数据。

ALU_MUX模块部分代码如下所示。

    //ALUA
    assign  alu_in_1 = ALUAsrc ? pc : busA; //1：pc，0：busA
    //ALUB
    assign  alu_in_2 = ALUBsrc ? ext_imm : busB; //1：ext_imm，0：busB

#### DATA_MEMORY

DATA_MEMORY为内存模块，使用vivado中的Distributed Memory Generator
IP核，作为随机读写存储器可读可写。

DATA_MEMORY模块部分代码如下所示。

    data_memory_ip DRAM (
    .a(addr[9 : 0]),      // input wire [9 : 0] a     //这里可能有问题
    .d(write_mem_data),      // input wire [31 : 0] d
    .clk(clk),  // input wire clk
    .we(MemWr),    // input wire we
    .spo(read_mem_data)  // output wire [31 : 0] spo
    );

#### WB_MUX

WB_MUX为写回多路选择器，选择写入的数据为ALU计算结果或内存数据或扩展后的立即数，默认值为0。

WB_MUX模块部分代码如下所示。

    always @(*)  
    begin
    case(MemtoReg)
    `MemtoReg_ALU:      write_data = alu_result;
    `MemtoReg_MEM:      write_data = read_mem_data;
    `MemtoReg_EXT:      write_data = ext_imm;
    `MemtoReg_DEFAULT:  write_data = 32'h0  ;
    endcase
    end

### 编写测试程序

使用RISC-V编写汇编代码，完成对5个整数进行冒泡排序的功能。汇编代码如下所示。

    .data
    v:   
    .word 8,3,6,9,1

    .text
    sort:
    addi sp,sp,-20
    sw   ra,16(sp)
    sw   s7,12(sp)
    sw   s6,8(sp)
    sw   s4,4(sp)
    sw   s3,0(sp)
    addi a1,x0,5     #n=5
    addi s3,x0,0     #i=0
    la   a0,v        #a0=v的address
    mv   s5,a0       #s5=v   
    mv   s6,a1       #s6=n
    loop1:
    bge  s3,s6,exit1 #i>=n,goto exit1
    addi s4,s3,-1    #else,j=i-1
    loop2:
    blt  s4,x0,exit2 #j<0,goto exit2
    slli t0,s4,2     #t0=j*4,word
    add  t0,s5,t0    #t0=v+j*4
    lw   t1,0(t0)    #t1=v[j]
    lw   t2,4(t0)    #t2=v[j+1]
    ble  t1,t2,exit2 #if v[j]<=v[j+1].goto exit2
    mv   a0,s5       #else,a0=v,用于swap
    mv   a1,s4       #a1=j,用于swap
    jal  ra,swap
    addi s4,s4,-1    #j=j-1
    j    loop2
    exit2:
    addi s3,s3,1     #i=i+1
    j    loop1
    exit1:
    lw   s3,0(sp)
    lw   s4,4(sp)
    lw   s6,8(sp) 
    lw   s7,12(sp)  
    lw   ra,16(sp) 
    addi sp,sp,20   
    jal  x0,exit
    swap:
    slli t0,a1,2
    add  t0,a0,t0   #v+k
    lw   t1,0(t0)  #t1=v[k]
    lw   t2,4(t0)  #t2=v[k+1]
    sw   t2,0(t0)  #v[k]=t2
    sw   t1,4(t0)  #v[k+1]=t0
    jalr  x0,0(ra) #回去
    exit:

配置Java环境，使用RISC-V仿真器RARS对汇编代码进行测试。从地址0x10010000开始依次存放5个从小到大排序后的整数。代码运行结果正确，符合预期效果。

### 仿真测试

#### testbench

编写testbench进行仿真测试，以ns为时间尺度进行仿真测试。由于有顶层top模块对所有模块进行控制，只需生成时钟clk信号和复位rst信号。

testbench部分代码如下所示。

    module testbench();

    reg clk;
    reg rst;
    top My_top(.clk(clk), .rst(rst));

    initial begin
    rst = 1;
    clk = 0;

    #30 rst = 0;

    //#500 $stop;
    end

    always
    #20 clk = ~clk;

    endmodule