`timescale 1ns / 1ps

module control_unit (
    input  logic [6:0] Opcode,

    output logic ALUSrc,
    output logic MemtoReg,
    output logic RegtoMem,
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic Branch,
    output logic [1:0] ALUOp,

    output logic Con_Jal,
    output logic Con_Jalr,

    output logic Mem,
    output logic OpI,
    output logic Con_AUIPC,
    output logic Con_LUI
);

    // RISC-V RV32I opcodes
 
    localparam R_TYPE = 7'b0110011;
    localparam LOAD   = 7'b0000011;
    localparam STORE  = 7'b0100011;
    localparam BR     = 7'b1100011;
    localparam OP_IMM = 7'b0010011;
    localparam JAL    = 7'b1101111;
    localparam JALR   = 7'b1100111;
    localparam AUIPC  = 7'b0010111;
    localparam LUI    = 7'b0110111;

    // Instruction type detection

    assign Con_Jal  = (Opcode == JAL);
    assign Con_Jalr = (Opcode == JALR);

    // Indicates that the current instruction is a branch
    // instruction. The actual branch condition is determined
    // using funct3 / ALU comparison results.
    assign Branch = (Opcode == BR);

    // ALU source selection
    // 0 -> Register rs2
    // 1 -> Immediate
    // Load/store and OP-IMM instructions use an immediate.
    assign ALUSrc =
        (Opcode == LOAD)   ||
        (Opcode == STORE)  ||
        (Opcode == OP_IMM);
    
    // Write-back source
    // 0 -> ALU result
    // 1 -> Data memory result
    assign MemtoReg = (Opcode == LOAD);


    // Store-data selection
    assign RegtoMem = (Opcode == STORE);

    // Register-file write enable
    // R-type      -> ALU result
    // LOAD        -> memory data
    // OP-IMM      -> ALU result
    // JAL         -> PC + 4
    // JALR        -> PC + 4
    // AUIPC       -> PC + immediate
    // LUI         -> immediate

    assign RegWrite =
        (Opcode == R_TYPE) ||
        (Opcode == LOAD)   ||
        (Opcode == OP_IMM) ||
        (Opcode == JAL)    ||
        (Opcode == JALR)   ||
        (Opcode == AUIPC)  ||
        (Opcode == LUI);


    // Memory control
    assign Mem = 
        (Opcode == LOAD) ||
        (Opcode == STORE);

    assign MemRead =
        (Opcode == LOAD);

    // JALR must NOT write to data memory
    assign MemWrite =
        (Opcode == STORE);


    // ALU operation type
    // ALUOp = 10 -> R-type
    // ALUOp = 01 -> Branch
    // ALUOp = 00 -> Other instructions

    assign ALUOp[1] = (Opcode == R_TYPE);
    assign ALUOp[0] = (Opcode == BR);

    // Immediate ALU operation
    assign OpI = (Opcode == OP_IMM);


    // Special instructions
    assign Con_AUIPC = (Opcode == AUIPC);
    assign Con_LUI   = (Opcode == LUI);

endmodule
