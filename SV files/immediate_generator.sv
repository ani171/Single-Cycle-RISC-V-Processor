`timescale 1ns / 1ps

module immediate_generator(
    input logic [31:0] inst_code,
    output logic [31:0] Imm_out
);

    logic [4:0] srai;

    assign srai = inst_code[24:20];

    always_comb begin

        case (inst_code[6:0])

            // I-type load: LW, LH, LB, LHU, LBU
            7'b0000011:
                Imm_out = {
                    {20{inst_code[31]}},
                    inst_code[31:20]
                };

            // I-type ALU: ADDI, ANDI, ORI, XORI, SLTI, SLTIU,
            // SLLI, SRLI, SRAI
            7'b0010011:
                begin
                    if ((inst_code[31:25] == 7'b0100000 &&
                         inst_code[14:12] == 3'b101) ||
                        (inst_code[14:12] == 3'b001) ||
                        (inst_code[14:12] == 3'b101))

                        // Shift amount
                        Imm_out = {
                            {27{srai[4]}},
                            srai
                        };

                    else

                        // Normal I-type immediate
                        Imm_out = {
                            {20{inst_code[31]}},
                            inst_code[31:20]
                        };
                end

            // S-type: SB, SH, SW
            7'b0100011:
                Imm_out = {
                    {20{inst_code[31]}},
                    inst_code[31:25],
                    inst_code[11:7]
                };

            // B-type: BEQ, BNE, BLT, BGE, BLTU, BGEU
            7'b1100011:
                Imm_out = {
                    {19{inst_code[31]}},
                    inst_code[31],
                    inst_code[7],
                    inst_code[30:25],
                    inst_code[11:8],
                    1'b0
                };

            // JALR: I-type immediate
            7'b1100111:
                Imm_out = {
                    {20{inst_code[31]}},
                    inst_code[31:20]
                };

            // AUIPC: U-type
            7'b0010111:
                Imm_out = {
                    inst_code[31:12],
                    12'b0
                };

            // LUI: U-type
            7'b0110111:
                Imm_out = {
                    inst_code[31:12],
                    12'b0
                };

            // JAL: J-type
            7'b1101111:
                Imm_out = {
                    {11{inst_code[31]}},
                    inst_code[31],
                    inst_code[19:12],
                    inst_code[20],
                    inst_code[30:21],
                    1'b0
                };

            default:
                Imm_out = 32'b0;

        endcase

    end

endmodule
