`timescale 1ns / 1ps

module RegFile #(
    parameter DATA_WIDTH    = 32,
    parameter ADDRESS_WIDTH = 5,
    parameter NUM_REGS      = 32
)(
    input logic clk,
    input logic rst,

    input logic rg_wrt_en,

    input logic [ADDRESS_WIDTH-1:0] rg_wrt_dest,
    input logic [ADDRESS_WIDTH-1:0] rg_rd_addr1,
    input logic [ADDRESS_WIDTH-1:0] rg_rd_addr2,

    input logic [DATA_WIDTH-1:0] rg_wrt_data,

    output logic [DATA_WIDTH-1:0] rg_rd_data1,
    output logic [DATA_WIDTH-1:0] rg_rd_data2
);

    integer i;

    logic [DATA_WIDTH-1:0] register_file [NUM_REGS-1:0];

    // Register write / reset
    // x0 (register 0) is hardwired to zero and cannot be written.
    always_ff @(negedge clk) begin

        if (rst) begin

            for (i = 0; i < NUM_REGS; i = i + 1) begin
                register_file[i] <= '0;
            end

        end
        else if (rg_wrt_en && (rg_wrt_dest != 5'd0)) begin

            register_file[rg_wrt_dest] <= rg_wrt_data;

        end

    end
    // Asynchronous register reads
    // x0 always returns zero.
    always_comb begin

        if (rg_rd_addr1 == 5'd0)
            rg_rd_data1 = '0;
        else
            rg_rd_data1 = register_file[rg_rd_addr1];

        if (rg_rd_addr2 == 5'd0)
            rg_rd_data2 = '0;
        else
            rg_rd_data2 = register_file[rg_rd_addr2];

    end

endmodule
