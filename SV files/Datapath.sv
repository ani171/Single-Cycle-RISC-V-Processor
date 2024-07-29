`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
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

module Datapath #(
    parameter PC_W = 9, // Program Counter width
    parameter INS_W = 32, // Instruction width
    parameter RF_ADDRESS = 5, // Register File address width
    parameter DATA_W = 32, // Data width
    parameter DM_ADDRESS = 9, // Data Memory address width
    parameter ALU_CC_W = 4 // ALU Control Code width
    )(
    input logic clk, 
    input logic reset, // global reset
    input logic RegWrite, 
    input logic MemtoReg, 
    input logic RegtoMem, // R-file writing enable // Memory or ALU MUX
    input logic ALUsrc, 
    input logic MemWrite, // R-file or Immediate MUX // Memory writing enable
    input logic MemRead, // Memory reading enable
    input logic Con_beq, 
    input logic Con_bnq, 
    input logic Con_bgt, 
    input logic Con_blt,
    input logic Con_Jalr,
    input logic Jal,
    input logic AUIPC, 
    input logic LUI, 
    input logic [ALU_CC_W-1:0] ALU_CC, // ALU Control Code
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,
    output logic [31:0] ALU_Result
    );

    logic [8:0] PC, PCPlus4, PCValue, BranchPC;
    logic [31:0] Instr, PCPlusImm, PCJalr, LD, ST, Store_data;
    logic [31:0] Result;
    logic [31:0] Reg1, Reg2;
    logic [31:0] ReadData;
    logic [31:0] SrcB, ALUResult;
    logic [31:0] ExtImm;
    logic [31:0] PC_unsign_extend;
    logic [31:0] Read_Alu_Result, Jal_test, aui_data, lui_data;
    logic [1:0] PCSel;
    logic zero, Con_BLT, Con_BGT, Jalr, Branch; 

    // Adder instantiation
    adder #(9) pc_add_1(PC, 9'b100, PCPlus4); // PC + 4
    adder #(32) pc_add_2(PC_unsign_extend, ExtImm, PCPlusImm); // PC + Immediate
    adder #(32) pc_add_3(ExtImm, Reg1, PCJalr); // Immediate + Register for JALR

    // MUX instantiations
    mux2to1 #(9) next_pc1(PCPlus4, PCPlusImm[8:0], Branch, BranchPC); // Branch or Next PC
    mux2to1 #(9) next_pc2(BranchPC, PCJalr[8:0], Con_Jalr, PCValue); // JALR or Branch
    mux2to1 #(32) resmux_store(Reg2, ST, RegtoMem, Store_data); // Store Data MUX
    mux2to1 #(32) resmux(ALUResult, LD, MemtoReg, Read_Alu_Result); // ALU or Load Data MUX
    mux2to1 #(32) resmux_jal(Read_Alu_Result, {23'b0, PCPlus4}, (Jal || Con_Jalr), Jal_test); // JAL or ALU/PC
    mux2to1 #(32) resmux_auipc(Jal_test, PCPlusImm, AUIPC, aui_data); // AUIPC MUX
    mux2to1 #(32) resmux_lui(aui_data, ExtImm, LUI, Result); // LUI MUX

    // Register PC
    ff_reg #(9) pcreg(clk, reset, PCValue, PC);

    // Instruction memory
    instructionmemory instr_mem(PC, Instr);
    
    // Assign opcode and function fields
    assign opcode = Instr[6:0];
    assign Funct7 = Instr[31:25];
    assign Funct3 = Instr[14:12];

    // Register File
    instr_decode store_data_ex(Instr, Reg2, ST);
    RegFile rf(clk, reset, RegWrite, Instr[11:7], Instr[19:15], Instr[24:20], Result, Reg1, Reg2);
    
    // ALU
    mux2to1 #(32) srcbmux(Reg2, ExtImm, (ALUsrc || Jal || Con_Jalr), SrcB); // ALU source B MUX
    alu alu_module(Reg1, SrcB, ALU_CC, ALUResult, Con_BLT, Con_BGT, zero); // ALU operations // ALU operations

    // Data memory
    instr_decode load_data_ex(Instr, ReadData, LD);
    mem_data data_mem(clk, MemRead, MemWrite, ALUResult[8:0], Store_data, ReadData);   

    // Assign final ALU result
    assign ALU_Result = Result;

endmodule
