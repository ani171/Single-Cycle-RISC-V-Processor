`timescale 1ns / 1ps

module mem_data #(
    parameter DM_ADDRESS = 9,
    parameter DATA_W = 32
)(
    input logic clk,
    input logic MemRead,
    input logic MemWrite,
    input logic [DM_ADDRESS-1:0] a,
    input logic [DATA_W-1:0] wd,
    output logic [DATA_W-1:0] rd
);

    logic [DATA_W-1:0] mem [(2**DM_ADDRESS)-1:0];

    integer i;

    // Initialize data memory
    initial begin
        for (i = 0; i < (2**DM_ADDRESS); i = i + 1)
            mem[i] = '0;
    end

    // Asynchronous read
    always_comb begin
        if (MemRead)
            rd = mem[a];
        else
            rd = '0;
    end

    // Synchronous write
    always @(posedge clk) begin
        if (MemWrite)
            mem[a] <= wd;
    end

endmodule
