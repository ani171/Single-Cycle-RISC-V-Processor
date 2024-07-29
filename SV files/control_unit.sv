`timescale 1ns / 1ps

module control_unit_1(
    input logic [6:0] Opcode, // 7-bit opcode field from the instruction
    output logic ALUSrc, // 0: The second ALU operand comes from the second register file output; 1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg, // 0: The value fed to the register Write data input comes from the ALU; 1: The value fed to the register Write data input comes from the data memory.
    output logic RegtoMem, // 0: The value to be written into memory comes from the register file; 1: The value to be written into memory comes from some other source.
    output logic RegWrite, // The register on the Write register input is written with the value on the Write data input.
    output logic MemRead,  // Data memory contents designated by the address input are put on the Read data output.
    output logic MemWrite, // Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic Branch,   // Indicates if the instruction is a branch instruction.
    output logic [1:0] ALUOp, // ALU operation code specifying the operation type.
    output logic Con_Jal, // Control signal for JAL (jump and link) instruction.
    output logic Con_Jalr, // Control signal for JALR (jump and link register) instruction.
    output logic Mem, // Control signal for memory operations (load/store).
    output logic OpI, // Control signal for immediate operations.
    output logic Con_AUIPC, // Control signal for AUIPC (add upper immediate to PC) instruction.
    output logic Con_LUI // Control signal for LUI (load upper immediate) instruction.
);

localparam R_TYPE  = 7'b0110011;
localparam LW      = 7'b0000011;
localparam SW      = 7'b0100011;
localparam BR      = 7'b1100011;
localparam RTypeI  = 7'b0010011; // addi, ori, andi
localparam JAL     = 7'b1101111;
localparam JALR    = 7'b1100111;
localparam AUIPC   = 7'b0010111;
localparam LUI     = 7'b0110111;

assign Con_Jal   = (Opcode == JAL);  
assign Con_Jalr  = (Opcode == JALR);  
assign Branch    = (Opcode == BR);  
assign ALUSrc    = (Opcode == LW || Opcode == SW || Opcode == RTypeI);
assign MemtoReg  = (Opcode == LW);
assign RegtoMem  = (Opcode == SW);
assign RegWrite  = (Opcode == R_TYPE || Opcode == LW || Opcode == RTypeI || Opcode == JALR || Opcode == JAL);
assign Mem       = (Opcode == LW || Opcode == SW);
assign MemRead   = (Opcode == LW);
assign MemWrite  = (Opcode == SW || Opcode == JALR);
assign ALUOp[0]  = (Opcode == BR);
assign OpI       = (Opcode == RTypeI);
assign ALUOp[1]  = (Opcode == R_TYPE);
assign Con_AUIPC = (Opcode == AUIPC);
assign Con_LUI   = (Opcode == LUI);

endmodule
