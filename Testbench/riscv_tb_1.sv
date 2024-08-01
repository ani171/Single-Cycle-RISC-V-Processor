`timescale 1ns / 1ps

module riscv_tb_1();

// Clock and reset signal declaration
logic tb_clk, reset;
logic [31:0] tb_WB_Data;
logic [31:0] expected_data;
integer i;

// Clock generation
always #10 tb_clk = ~tb_clk;

// Reset generation
initial begin
    tb_clk = 0;
    reset = 1;
    #25 reset = 0;
end

// Instantiate the RISC-V module
riscv riscV (
    .clk(tb_clk),
    .reset(reset),
    .WB_Data(tb_WB_Data)
);

// Expected data array
logic [31:0] expected_values [0:5];
initial begin
    expected_values[0] = 32'h00000000; // and r0, r0, r0
    expected_values[1] = 32'h00000001; // addi r1, r0, 1
    expected_values[2] = 32'h00000002; // addi r2, r0, 2
    expected_values[3] = 32'h00000004; // addi r3, r1, 3
    expected_values[4] = 32'h00000005; // addi r4, r1, 4
    expected_values[5] = 32'h00000007; // addi r5, r2, 5
end

// Monitor signals and check results
initial begin
    $monitor("Time: %0t, Reset: %b, WB_Data: %h, Expected: %h", $time, reset, tb_WB_Data, expected_data);
    
    // Run the simulation and check the results
    for (i = 0; i < 6; i = i + 1) begin
        expected_data = expected_values[i];
        @(posedge tb_clk);
        #5; // small delay to allow for processing
        if (tb_WB_Data !== expected_data) begin
            $display("ERROR: Mismatch at instruction %0d. Got: %h, Expected: %h", i, tb_WB_Data, expected_data);
        end else begin
            $display("SUCCESS: Instruction %0d executed correctly. Got: %h, Expected: %h", i, tb_WB_Data, expected_data);
        end
    end
    
    #100;
    $finish;
end

endmodule
