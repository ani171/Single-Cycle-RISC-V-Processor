`timescale 1ns / 1ps

module instructionmemory #(
    parameter INS_ADDRESS = 9,
    parameter INS_W       = 32
)(
    input  logic [INS_ADDRESS-1:0] ra,
    output logic [INS_W-1:0] rd
);

    localparam MEM_DEPTH = 2 ** (INS_ADDRESS - 2);

    logic [INS_W-1:0] Inst_mem [MEM_DEPTH-1:0];

    integer i;

    initial begin

        // Initialize unused memory locations to NOP
        for (i = 0; i < MEM_DEPTH; i = i + 1)
            Inst_mem[i] = 32'h00000013;

        Inst_mem[0]  = 32'h00007033;
        Inst_mem[1]  = 32'h00100093;
        Inst_mem[2]  = 32'h00200113;
        Inst_mem[3]  = 32'h00308193;
        Inst_mem[4]  = 32'h00408213;
        Inst_mem[5]  = 32'h00510293;
        Inst_mem[6]  = 32'h00610313;
        Inst_mem[7]  = 32'h00718393;
        Inst_mem[8]  = 32'h00208433;
        Inst_mem[9]  = 32'h404404b3;
        Inst_mem[10] = 32'h00317533;
        Inst_mem[11] = 32'h0041e5b3;

        Inst_mem[12] = 32'h02b20263;
        Inst_mem[13] = 32'h00108413;
        Inst_mem[14] = 32'h00419a63;
        Inst_mem[15] = 32'h00308413;
        Inst_mem[16] = 32'h0014c263;
        Inst_mem[17] = 32'h00408413;

        Inst_mem[18] = 32'h00b3da63;

        Inst_mem[19] = 32'h00208413;
        Inst_mem[20] = 32'hfe5166e3;
        Inst_mem[21] = 32'h00008413;
        Inst_mem[22] = 32'hfc74fee3;

        Inst_mem[23] = 32'h0083e6b3;
        Inst_mem[24] = 32'h018005ef;
        Inst_mem[25] = 32'h02a02823;
        Inst_mem[26] = 32'h16802023;
        Inst_mem[27] = 32'h03002603;
        Inst_mem[28] = 32'h00311733;
        Inst_mem[29] = 32'h00c50a63;

        Inst_mem[30] = 32'h0072c7b3;
        Inst_mem[31] = 32'h00235833;
        Inst_mem[32] = 32'h4034d8b3;
        Inst_mem[33] = 32'h000586e7;
        Inst_mem[34] = 32'h01614513;
        Inst_mem[35] = 32'h02e2e593;
        Inst_mem[36] = 32'h06f37613;
        Inst_mem[37] = 32'h00349693;
        Inst_mem[38] = 32'h00335713;
        Inst_mem[39] = 32'h4026d793;

        Inst_mem[40] = 32'h00a8a833;
        Inst_mem[41] = 32'h00a8b833;
        Inst_mem[42] = 32'h0028a813;
        Inst_mem[43] = 32'h0028b813;
        Inst_mem[44] = 32'hccccc837;
        Inst_mem[45] = 32'hccccc817;

        Inst_mem[46] = 32'h00902a23;
        Inst_mem[47] = 32'h00902023;
        Inst_mem[48] = 32'h00902603;
        Inst_mem[49] = 32'h00902223;
        Inst_mem[50] = 32'h00902423;

    end

    // Asynchronous instruction memory read.
    // PC is a byte address, therefore bits [1:0] are ignored.
    always_comb begin
        rd = Inst_mem[ra[INS_ADDRESS-1:2]];
    end

endmodule
