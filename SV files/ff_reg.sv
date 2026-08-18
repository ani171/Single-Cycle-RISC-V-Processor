`timescale 1ns / 1ps

module ff_reg #(
    parameter WIDTH = 32
)(
    input logic clk,
    input logic reset,
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    // Synchronous reset
    always_ff @(posedge clk) begin
        if (reset)
            q <= '0;
        else
            q <= d;
    end

endmodule
