`timescale 1ns / 1ps

module riscv_tb;

// Clock and reset signal declaration
  logic tb_clk;
  logic tb_reset;
  logic [31:0] tb_WB_Data;

// Clock generation
  always #10 tb_clk = ~tb_clk;

// Reset generation
  initial begin
    tb_clk = 0;
    tb_reset = 1;
    #25 tb_reset = 0; // Release reset after 25 ns
  end

// Instantiate the riscv top module
  riscv uut (
    .clk(tb_clk),
    .reset(tb_reset),
    .WB_Data(tb_WB_Data)
  );

// Test procedure
  initial begin
    // Initialize signals
    tb_clk = 0;
    tb_reset = 1;

    // Apply reset
    #25 tb_reset = 0;

    // Run the simulation for a certain amount of time
    #1300;
    
    // End simulation
    $finish;
  end

// Monitor outputs
  initial begin
    $monitor("Time: %0t | WB_Data: %h", $time, tb_WB_Data);
  end

endmodule
