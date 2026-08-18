`timescale 1ns / 1ps

module alucontrol (

    // Inputs
    input logic [1:0] ALUOp,
    input logic [6:0] Funct7,
    input logic [2:0] Funct3,

    input logic Branch,
    input logic Mem,
    input logic OpI,
    input logic AUIPC,


    // Outputs

    output logic [3:0] Operation,

    // Branch instruction identification
    output logic Con_beq,
    output logic Con_bnq,
    output logic Con_blt,
    output logic Con_bgt

);


    // Branch instruction decoding

    // RV32I branch funct3:
    // 000 -> BEQ
    // 001 -> BNE
    // 100 -> BLT
    // 101 -> BGE
    // 110 -> BLTU
    // 111 -> BGEU

    // The existing datapath uses:
    //   Con_blt -> less-than branch
    //   Con_bgt -> greater/equal branch

    always_comb begin

        // Defaults
        Con_beq = 1'b0;
        Con_bnq = 1'b0;
        Con_blt = 1'b0;
        Con_bgt = 1'b0;

        if (Branch) begin

            case (Funct3)

                3'b000: begin
                    // BEQ
                    Con_beq = 1'b1;
                end

                3'b001: begin
                    // BNE
                    Con_bnq = 1'b1;
                end

                3'b100: begin
                    // BLT
                    Con_blt = 1'b1;
                end

                3'b101: begin
                    // BGE
                    Con_bgt = 1'b1;
                end

                3'b110: begin
                    // BLTU
                    Con_blt = 1'b1;
                end

                3'b111: begin
                    // BGEU
                    Con_bgt = 1'b1;
                end

                default: begin
                    Con_beq = 1'b0;
                    Con_bnq = 1'b0;
                    Con_blt = 1'b0;
                    Con_bgt = 1'b0;
                end

            endcase

        end

    end

    // ALU operation decoding
    // Existing ALU operation encoding:
    // 0000 -> AND
    // 0001 -> OR
    // 0010 -> ADD
    // 0011 -> XOR
    // 0100 -> SLL
    // 0101 -> SLTU
    // 0110 -> SUB
    // 0111 -> unsigned branch comparison
    // 1000 -> SRL
    // 1010 -> SLT
    // 1100 -> SRA

    always_comb begin

        // Default
        Operation = 4'b0010;   // ADD

        case (ALUOp)
            // ALUOp = 00
            // Load/store and immediate operations.
            2'b00: begin

                if (Mem) begin

                    // LW / SW: Effective address: rs1 + immediate
                    Operation = 4'b0010;

                end
                else if (OpI) begin

                    // I-type ALU instructions
                    case (Funct3)

                        3'b000: begin
                            // ADDI
                            Operation = 4'b0010;
                        end

                        3'b010: begin
                            // SLTI
                            Operation = 4'b1010;
                        end

                        3'b011: begin
                            // SLTIU
                            Operation = 4'b0101;
                        end

                        3'b100: begin
                            // XORI
                            Operation = 4'b0011;
                        end

                        3'b110: begin
                            // ORI
                            Operation = 4'b0001;
                        end

                        3'b111: begin
                            // ANDI
                            Operation = 4'b0000;
                        end

                        3'b001: begin
                            // SLLI
                            Operation = 4'b0100;
                        end

                        3'b101: begin
                            if (Funct7 == 7'b0100000)
                                Operation = 4'b1100; // SRAI
                            else
                                Operation = 4'b1000; // SRLI

                        end

                        default: begin
                            Operation = 4'b0010;
                        end

                    endcase

                end
                else begin

                    // JAL / JALR / AUIPC and other operations
                    Operation = 4'b0010;

                end

            end

            // ALUOp = 01
            // Branch instructions
            2'b01: begin

                case (Funct3)

                    3'b000: begin
                        // BEQ
                        Operation = 4'b0110;
                    end
                    3'b001: begin
                        // BNE
                        Operation = 4'b0110;
                    end
                    3'b100: begin
                        // BLT
                        Operation = 4'b1010;
                    end
                    3'b101: begin
                        // BGE
                        Operation = 4'b1010;
                    end
                    3'b110: begin
                        // BLTU
                        Operation = 4'b0111;
                    end
                    3'b111: begin
                        // BGEU
                        Operation = 4'b0111;
                    end
                    default: begin
                        Operation = 4'b0110;
                    end
                endcase

            end
            // ALUOp = 10
            // R-type instructions
            2'b10: begin
                case (Funct3)
                    3'b000: begin
                        // ADD or SUB
                        // ADD: funct7 = 0000000
                        // SUB: funct7 = 0100000

                        if (Funct7 == 7'b0100000)
                            Operation = 4'b0110; // SUB
                        else
                            Operation = 4'b0010; // ADD

                    end
                    3'b001: begin
                        // SLL
                        Operation = 4'b0100;
                    end
                    3'b010: begin
                        // SLT
                        Operation = 4'b1010;
                    end
                    3'b011: begin
                        // SLTU
                        Operation = 4'b0101;
                    end
                    3'b100: begin
                        // XOR
                        Operation = 4'b0011;
                    end
                    3'b101: begin
                        // SRL or SRA
                        // SRL: funct7 = 0000000
                        // SRA: funct7 = 0100000

                        if (Funct7 == 7'b0100000)
                            Operation = 4'b1100; // SRA
                        else
                            Operation = 4'b1000; // SRL

                    end
                    3'b110: begin
                        // OR
                        Operation = 4'b0001;
                    end
                    3'b111: begin
                        // AND
                        Operation = 4'b0000;
                    end
                    default: begin
                        Operation = 4'b0010;
                    end

                endcase

            end
            // Default
            default: begin
                Operation = 4'b0010;
            end

        endcase

    end

endmodule
