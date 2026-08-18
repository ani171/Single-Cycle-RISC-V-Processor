`timescale 1ns / 1ps

module alu #(
    parameter DATA_WIDTH = 32,
    parameter OPCODE_LENGTH = 4
)(
    input  logic [DATA_WIDTH-1:0] SrcA,
    input  logic [DATA_WIDTH-1:0] SrcB,

    input logic [OPCODE_LENGTH-1:0] Operation,

    output logic [DATA_WIDTH-1:0] ALUResult,
    output logic Con_BLT,
    output logic Con_BGT,
    output logic zero
);

    always_comb begin

        // Default values
        ALUResult = '0;
        Con_BLT   = 1'b0;
        Con_BGT   = 1'b0;
        zero      = 1'b0;

        case (Operation)
            // Logical operations
            4'b0000: begin
                // AND
                ALUResult = SrcA & SrcB;
            end

            4'b0001: begin
                // OR
                ALUResult = SrcA | SrcB;
            end

            4'b0011: begin
                // XOR
                ALUResult = SrcA ^ SrcB;
            end

            // Arithmetic
            4'b0010: begin
                // ADD
                ALUResult = SrcA + SrcB;
            end

            4'b0110: begin
                // SUB
                ALUResult = SrcA - SrcB;

                zero = (SrcA == SrcB);

                // Signed comparison
                Con_BLT = ($signed(SrcA) < $signed(SrcB));
                Con_BGT = ($signed(SrcA) > $signed(SrcB));
            end

            // Shift operations
            4'b0100: begin
                // SLL
                ALUResult = SrcA << SrcB[4:0];
            end

            4'b1000: begin
                // SRL
                ALUResult = SrcA >> SrcB[4:0];
            end

            4'b1100: begin
                // SRA
                ALUResult = $signed(SrcA) >>> SrcB[4:0];
            end

            // Comparison
            4'b0101: begin
                // SLTU
                ALUResult =
                    ($unsigned(SrcA) < $unsigned(SrcB)) ? 32'd1 : 32'd0;
            end

            4'b1010: begin
                // SLT
                ALUResult =
                    ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;
            end

            // Unsigned branch comparison
            4'b0111: begin

                ALUResult = SrcA - SrcB;

                zero = (SrcA == SrcB);

                Con_BLT =
                    ($unsigned(SrcA) < $unsigned(SrcB));

                Con_BGT =
                    ($unsigned(SrcA) > $unsigned(SrcB));

            end

            // Unsupported operation
            default: begin
                ALUResult = '0;
                Con_BLT   = 1'b0;
                Con_BGT   = 1'b0;
                zero      = 1'b0;
            end

        endcase

    end

endmodule
