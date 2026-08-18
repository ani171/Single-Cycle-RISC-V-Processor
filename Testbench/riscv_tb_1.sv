`timescale 1ns / 1ps

module riscv_tb_1;

    // Signals
    logic        tb_clk;
    logic        reset;
    logic [31:0] tb_WB_Data;

    logic [31:0] expected_values [0:5];

    integer i;

    // Clock generation
    // 20 ns period = 50 MHz
    always #10 tb_clk = ~tb_clk;

    // DUT

    riscv riscV (
        .clk    (tb_clk),
        .reset  (reset),
        .WB_Data(tb_WB_Data)
    );


    // Expected values

    initial begin

        expected_values[0] = 32'h00000000; // and  r0,r0,r0
        expected_values[1] = 32'h00000001; // addi r1,r0,1
        expected_values[2] = 32'h00000002; // addi r2,r0,2
        expected_values[3] = 32'h00000004; // addi r3,r1,3
        expected_values[4] = 32'h00000005; // addi r4,r1,4
        expected_values[5] = 32'h00000007; // addi r5,r2,5

    end



    // Test
    initial begin

        // Initial state
        tb_clk = 1'b0;
        reset  = 1'b1;

        $display(" RISC-V SINGLE-CYCLE PROCESSOR TESTBENCH");
  

        // Keep processor in reset
        #25;

        // Release reset
        reset = 1'b0;

        $display("Reset released at %0t ns", $time);

        // Check first six instructions
        for (i = 0; i < 6; i = i + 1) begin

            // Wait for processor clock edge
            @(posedge tb_clk);

            // Allow combinational logic to settle
            #5;

            $display(
                "Instruction %0d | WB_Data = %h | Expected = %h",
                i,
                tb_WB_Data,
                expected_values[i]
            );

            if (tb_WB_Data !== expected_values[i]) begin

                $display(
                    "ERROR: Instruction %0d mismatch!",
                    i
                );

            end
            else begin

                $display(
                    "SUCCESS: Instruction %0d executed correctly.",
                    i
                );

            end

        end

        #100;
        $display(" SIMULATION COMPLETE");
        $finish;

    end
    // Continuous monitor
    initial begin

        $monitor(
            "Time=%0t | Reset=%b | PC=%h | Instr=%h | WB_Data=%h",
            $time,
            reset,
            riscV.dp.PC,
            riscV.dp.Instr,
            tb_WB_Data
        );

    end

endmodule
