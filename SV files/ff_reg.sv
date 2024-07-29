`timescale 1ns / 1ps

module ff_reg #(
    parameter WIDTH = 8
) (
    input logic clk,             // Clock input
    input logic reset,           // Synchronous reset input
    input logic [WIDTH-1:0] d,   // Data input
    output logic [WIDTH-1:0] q   // Data output
);

always_ff @(posedge clk) begin
    if (reset) 
        q <= 0;
    else 
        q <= d;
end

endmodule
