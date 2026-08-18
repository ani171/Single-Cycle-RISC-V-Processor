`timescale 1ns / 1ps

module Datapath #(
    parameter PC_W       = 9,   // Program Counter width
    parameter INS_W      = 32,  // Instruction width
    parameter RF_ADDRESS = 5,   // Register File address width
    parameter DATA_W     = 32,  // Data width
    parameter DM_ADDRESS = 9,   // Data Memory address width
    parameter ALU_CC_W   = 4    // ALU Control Code width
)(
    input  logic clk,
    input  logic reset,

    // Register file / memory control
    input  logic RegWrite,
    input  logic MemtoReg,
    input  logic RegtoMem,
    input  logic ALUsrc,
    input  logic MemWrite,
    input  logic MemRead,

    // Branch / jump control
    input  logic Con_beq,
    input  logic Con_bnq,
    input  logic Con_bgt,
    input  logic Con_blt,
    input  logic Con_Jalr,
    input  logic Jal,

    // Special instructions
    input  logic AUIPC,
    input  logic LUI,

    // ALU control
    input  logic [ALU_CC_W-1:0] ALU_CC,

    // Instruction fields sent to control units
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,

    // Final write-back result
    output logic [DATA_W-1:0] ALU_Result
);


    // Program counter
    logic [PC_W-1:0] PC;
    logic [PC_W-1:0] PCPlus4;
    logic [PC_W-1:0] PCValue;
    logic [PC_W-1:0] BranchPC;

    // Instruction
    logic [INS_W-1:0] Instr;

    // Register file
    logic [DATA_W-1:0] Reg1;
    logic [DATA_W-1:0] Reg2;

    // Immediate
    logic [DATA_W-1:0] ExtImm;

    // PC converted to data width
    logic [DATA_W-1:0] PC_unsign_extend;

    // PC-relative / JALR targets
    logic [DATA_W-1:0] PCPlusImm;
    logic [DATA_W-1:0] PCJalr;

    // ALU
    logic [DATA_W-1:0] SrcB;
    logic [DATA_W-1:0] ALUResult;

    // Data memory
    logic [DATA_W-1:0] ReadData;
    logic [DATA_W-1:0] LD;
    logic [DATA_W-1:0] ST;
    logic [DATA_W-1:0] Store_data;

    // Write-back
    logic [DATA_W-1:0] Read_Alu_Result;
    logic [DATA_W-1:0] Jal_test;
    logic [DATA_W-1:0] aui_data;
    logic [DATA_W-1:0] Result;

    // ALU comparison outputs
    logic zero;
    logic Con_BLT;
    logic Con_BGT;

    // Branch decision
    logic Branch;


    assign opcode = Instr[6:0];
    assign Funct7 = Instr[31:25];
    assign Funct3 = Instr[14:12];


    // Immediate Generator
    // Supports: I-type, S-type, B-type, U-type, J-type

    always_comb begin

        // Default
        ExtImm = '0;

        case (opcode)
            7'b0010011, 7'b0000011, 7'b1100111: begin
                ExtImm = {
                    {20{Instr[31]}},
                    Instr[31:20]
                };

            end
            7'b0100011: begin
                ExtImm = {
                    {20{Instr[31]}},
                    Instr[31:25],
                    Instr[11:7]
                };
            end
            7'b1100011: begin
                ExtImm = {
                    {19{Instr[31]}},
                    Instr[31],
                    Instr[7],
                    Instr[30:25],
                    Instr[11:8],
                    1'b0
                };
            end
            7'b0110111, 7'b0010111: begin
                ExtImm = {
                    Instr[31:12],
                    12'b0
                };
            end
            7'b1101111: begin
                ExtImm = {
                    {11{Instr[31]}},
                    Instr[31],
                    Instr[19:12],
                    Instr[20],
                    Instr[30:21],
                    1'b0
                };
            end
            // R-type and unsupported instructions
            default: begin
                ExtImm = '0;
            end
        endcase
    end
    // Extend PC from PC_W bits to DATA_W bits
    assign PC_unsign_extend = {{(DATA_W-PC_W){1'b0}}, PC};
    // PC calculation
    // PC + 4
    adder #(PC_W) pc_add_1 (
        PC,
        {{(PC_W-3){1'b0}}, 3'b100},
        PCPlus4
    );


    // PC + immediate
    // Used by:
    // - branches
    // - JAL
    // - AUIPC
    adder #(DATA_W) pc_add_2 (
        PC_unsign_extend,
        ExtImm,
        PCPlusImm
    );
    // JALR target = rs1 + immediate
    adder #(DATA_W) pc_add_3 (
        Reg1,
        ExtImm,
        PCJalr
    );
    // Branch decision logic
    // The ALU produces:
    // zero    -> equality
    // Con_BLT -> less-than
    // Con_BGT -> greater-than
    always_comb begin

        Branch = 1'b0;
        // BEQ
        if (Con_beq && zero)
            Branch = 1'b1;
        // BNE
        if (Con_bnq && !zero)
            Branch = 1'b1;
        // BLT
        if (Con_blt && Con_BLT)
            Branch = 1'b1;
        // BGT / BGE depending on the control-unit definition
        if (Con_bgt && Con_BGT)
            Branch = 1'b1;
    end

    // Next-PC multiplexers
    // Select:
    // 0 -> PC + 4
    // 1 -> Branch/JAL target
    mux2to1 #(PC_W) next_pc1 (
        PCPlus4,
        PCPlusImm[PC_W-1:0],
        Branch,
        BranchPC
    );


    // Select:
    // 0 -> normal/branch PC
    // 1 -> JALR target
    mux2to1 #(PC_W) next_pc2 (
        BranchPC,
        {PCJalr[PC_W-1:1], 1'b0},
        Con_Jalr,
        PCValue
    );

    // Program Counter register

    ff_reg #(PC_W) pcreg (
        clk,
        reset,
        PCValue,
        PC
    );


    // Instruction memory

    instructionmemory instr_mem (
        PC,
        Instr
    );


    // Register File

    RegFile rf (
        clk,
        reset,
        RegWrite,

        // rd
        Instr[11:7],

        // rs1
        Instr[19:15],

        // rs2
        Instr[24:20],

        // Write-back data
        Result,

        // Read data 1
        Reg1,

        // Read data 2
        Reg2
    );

    // Store data generation   
    instr_decode store_data_ex (
        Instr,
        Reg2,
        ST
    );


    // Store data MUX
    // RegtoMem = 0 -> normal register value
    // RegtoMem = 1 -> formatted store value
    mux2to1 #(DATA_W) resmux_store (
        Reg2,
        ST,
        RegtoMem,
        Store_data
    );
    // ALU source-B multiplexer
    // Normal R-type: SrcB = Reg2
    // I-type / memory: SrcB = immediate
    // JAL/JALR: immediate is also selected
    mux2to1 #(DATA_W) srcbmux (
        Reg2,
        ExtImm,
        (ALUsrc || Jal || Con_Jalr),
        SrcB
    );
    // ALU
    alu alu_module (
        Reg1,
        SrcB,
        ALU_CC,
        ALUResult,
        Con_BLT,
        Con_BGT,
        zero
    );

    // Data Memory
    // Load data formatting
    instr_decode load_data_ex (
        Instr,
        ReadData,
        LD
    );


    // Data memory
    // ALUResult = effective address
    mux2to1 #(DATA_W) resmux (
        ALUResult,
        LD,
        MemtoReg,
        Read_Alu_Result
    );


    mem_data data_mem (
        clk,
        MemRead,
        MemWrite,
        ALUResult[DM_ADDRESS-1:0],
        Store_data,
        ReadData
    );

    // JAL / JALR write-back
    // JAL/JALR: rd = PC + 4
    // Otherwise: rd = ALU result / load result
    mux2to1 #(DATA_W) resmux_jal (
        Read_Alu_Result,
        {{(DATA_W-PC_W){1'b0}}, PCPlus4},
        (Jal || Con_Jalr),
        Jal_test
    );

    // AUIPC
    // rd = PC + immediate

    mux2to1 #(DATA_W) resmux_auipc (
        Jal_test,
        PCPlusImm,
        AUIPC,
        aui_data
    );

    // LUI
    // rd = immediate
    mux2to1 #(DATA_W) resmux_lui (
        aui_data,
        ExtImm,
        LUI,
        Result
    );
    // Final write-back result
  

    assign ALU_Result = Result;

endmodule
