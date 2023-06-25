`timescale 1ns / 1ps
`include "cpu_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/21 14:49:37
// Design Name: 
// Module Name: control_unit
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


module CU(    
           input wire[6:0]                    opcode,   // Instruction opcode, inst[6:0]
           input                              fun7,     //inst[30]
           input wire[2:0]                    fun3,     //inst[14:12]
           input                       [1:0]  zero,     // For instruction BEQ, determining the result of rs - rt

           // Control signals
           output reg[`NPC_OP_LENGTH  - 1:0]  nPC_sel,  //决定下一指令地址NPC，00:PC + 4，10:pc+imm,11:rD1+imm
           //output reg                         RegDst,   //写入寄存器rd 0,rt 1二选一  //感觉可以省略
           output reg                         RegWr,    //写寄存器使能信号
           output reg[`EXT_OP_LENGTH  - 1:0]  ExtOp,    //Extend 模块控制信号源
           output reg                         ALUAsrc,   //选择 ALU 源操作数来自0:reg1_data 或1:pc
           output reg                         ALUBsrc,   //选择 ALU 源操作数来自寄存器或符号扩展的立即数
           output reg[`ALU_CTR_LENGTH  - 1:0] ALUctr,   //ALU 控制信号（区分算术指令，比如 ADD、SUB 等）
           output reg                         MemWr,    //写数据存储器使能信号
           output reg[`MemtoReg_LENGTH - 1:0] MemtoReg  //写回模块选择信号，选择将00:ALU 计算结果、01:数据存储器输出、10:Extend 模块输出写入寄存器
    );
    always @(*)
    begin
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

        `INST_I_AL:
        begin
            nPC_sel     = `NPC_NEXT;
            //RegDst      = 0;
            RegWr       = 1;
            ALUAsrc     = 0; 
            ALUBsrc     = 1;            //在ExtOp中计算立即数
            MemWr       = 0;   
            MemtoReg    = `MemtoReg_ALU;
            
            case(fun3)
            //addi
            3'b000:    
            begin
                ALUctr = `ALU_CTR_ADD;
                ExtOp  = `EXT_OP_I_12;  
            end
            //slli
            //ALU a为rs,b为ExtOp结果
            3'b001:     
            begin
                ALUctr = `ALU_CTR_SLLI;
                ExtOp  = `EXT_OP_I_6;  
            end
            endcase
        end

        `INST_I_LOAD:
        begin
            nPC_sel     = `NPC_NEXT;
            //RegDst      = 0;
            RegWr       = 1;
            ALUAsrc     = 0; 
            ALUBsrc     = 1;            //在ExtOp中计算立即数
            MemWr       = 0;   
            MemtoReg    = `MemtoReg_MEM;        //在Mem中加载数据
            ALUctr      = `ALU_CTR_ADD;
            case(fun3)
            //lw
            3'b010: ExtOp  = `EXT_OP_I_12; 
            endcase
        end

        `INST_I_JALR:
        begin
            nPC_sel     = `NPC_R_IMM;        //rs1+imm
            //RegDst      = 0;
            RegWr       = 1;
            //在NPC中计算rs1+imm
            //在ALU中计算pc+4
            ALUAsrc     = 1;            //PC
            ALUBsrc     = 0;            
            MemWr       = 0;   
            MemtoReg    = `MemtoReg_ALU;        //PC+4 ->f[rd]
            ALUctr      = `ALU_CTR_PC4;
            ExtOp       = `EXT_OP_I_12; 
        end

        `INST_S:
        begin
            nPC_sel     = `NPC_NEXT;       
            //RegDst      = 0;
            RegWr       = 0;
            ALUAsrc     = 0;            
            ALUBsrc     = 1;            //在ExtOp中计算立即数
            MemWr       = 1;   
            MemtoReg    = `MemtoReg_DEFAULT;        
            ALUctr      = `ALU_CTR_ADD;
            ExtOp       = `EXT_OP_S; 
        end

        `INST_U_AUIPC:
        begin
            nPC_sel     = `NPC_NEXT;        
            //RegDst      = 0;
            RegWr       = 1;
            ALUAsrc     = 1;            //pc+imm->rd
            ALUBsrc     = 1;            //在ExtOp中计算立即数
            MemWr       = 0;   
            MemtoReg    = `MemtoReg_ALU;        
            ALUctr      = `ALU_CTR_ADD;
            ExtOp       = `EXT_OP_U_20; 
        end

        //使用zero信号判断
        `INST_B:
        begin
            //RegDst      = 0;
            RegWr       = 0;
            ALUAsrc     = 0;           
            ALUBsrc     = 0;            
            MemWr       = 0;   
            MemtoReg    = `MemtoReg_ALU;        
            ALUctr      = `ALU_CTR_SUB;
            ExtOp       = `EXT_OP_DEFAULT;

            case(fun3)
            //bge 大于等于
            3'b101:    
            begin
                case(zero)
                `ZERO_EQU: nPC_sel = `NPC_IMM;
                `ZERO_GREATER: nPC_sel = `NPC_IMM;
                `ZERO_LESS: nPC_sel = `NPC_NEXT;
                endcase
            end
            //blt 小于
            3'b100:     
            begin
                case(zero)
                `ZERO_EQU: nPC_sel = `NPC_NEXT;
                `ZERO_GREATER: nPC_sel = `NPC_NEXT;
                `ZERO_LESS: nPC_sel = `NPC_IMM;
                endcase
            end
            endcase
        end

        //pc+4 -> rd ; pc = pc+imm
         `INST_J_JAL:
        begin
            //在NPC中计算pc+imm
            //在ALU中计算pc+4
            nPC_sel     = `NPC_IMM;        
            //RegDst      = 0;
            RegWr       = 1;
            ALUAsrc     = 1;            //pc+4->rd
            ALUBsrc     = 0;            
            MemWr       = 0;   
            MemtoReg    = `MemtoReg_ALU;        
            ALUctr      = `ALU_CTR_PC4;
            ExtOp       = `EXT_OP_J; 
        end

        // end
        default:
        begin
        end
        endcase

    end


endmodule
