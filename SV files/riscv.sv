`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32
    )(
    input logic clk, 
    input logic reset, // clock and reset signals
    output logic [31:0] WB_Data // The ALU_Result
    );

    logic [6:0] opcode;
    logic ALUSrc, MemtoReg, RegtoMem, RegWrite, MemRead, MemWrite, Con_Jalr;
    logic Con_beq, Con_bnq, Con_bgt, Con_blt, Con_Jal, Branch, Mem, OpI, AUIPC, LUI;

    logic [1:0] ALUop;
    logic [6:0] Funct7;
    logic [2:0] Funct3;
    logic [3:0] Operation;

    // Instantiate the control unit
    control_unit cu (
        .Opcode(opcode), 
        .ALUSrc(ALUSrc), 
        .MemtoReg(MemtoReg), 
        .RegtoMem(RegtoMem), 
        .RegWrite(RegWrite), 
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .Branch(Branch), 
        .ALUOp(ALUop), 
        .Con_Jal(Con_Jal), 
        .Con_Jalr(Con_Jalr), 
        .Mem(Mem), 
        .OpI(OpI), 
        .Con_AUIPC(AUIPC), 
        .Con_LUI(LUI)
    );

    // Instantiate the ALU control unit
    alucontrol ac (
        .ALUOp(ALUop), 
        .Funct7(Funct7), 
        .Funct3(Funct3), 
        .Branch(Branch), 
        .Mem(Mem), 
        .OpI(OpI), 
        .AUIPC(AUIPC), 
        .Operation(Operation), 
        .Con_beq(Con_beq), 
        .Con_bnq(Con_bnq), 
        .Con_blt(Con_blt), 
        .Con_bgt(Con_bgt)
    );

    // Instantiate the datapath
    Datapath dp (
        .clk(clk), 
        .reset(reset), 
        .RegWrite(RegWrite), 
        .MemtoReg(MemtoReg), 
        .RegtoMem(RegtoMem), 
        .ALUsrc(ALUSrc), 
        .MemWrite(MemWrite), 
        .MemRead(MemRead), 
        .Con_beq(Con_beq), 
        .Con_bnq(Con_bnq), 
        .Con_bgt(Con_bgt), 
        .Con_blt(Con_blt), 
        .Con_Jalr(Con_Jalr), 
        .Jal(Con_Jal), 
        .AUIPC(AUIPC), 
        .LUI(LUI), 
        .ALU_CC(Operation), 
        .opcode(opcode), 
        .Funct7(Funct7), 
        .Funct3(Funct3), 
        .ALU_Result(WB_Data)
    );

endmodule
