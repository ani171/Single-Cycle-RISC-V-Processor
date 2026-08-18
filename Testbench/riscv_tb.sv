`timescale 1ns / 1ps

module riscv_tb;
    // Testbench Signals
    logic        tb_clk;
    logic        tb_reset;
    logic [31:0] tb_WB_Data;

    // Clock Generation
    // 20 ns period = 50 MHz
    always #10 tb_clk = ~tb_clk;

    // DUT: RISC-V Single-Cycle Processor
    riscv uut (
        .clk    (tb_clk),
        .reset  (tb_reset),
        .WB_Data(tb_WB_Data)
    );

    initial begin

        tb_clk   = 1'b0;
        tb_reset = 1'b1;

        $display("==============================================");
        $display("     RISC-V SINGLE-CYCLE PROCESSOR TEST");
        $display("==============================================");

        #25;
        tb_reset = 1'b0;

        $display("");
        $display("Reset released at time %0t ns", $time);
        $display("Simulation started...");
        $display("");
        #1300;

        $display("");
        $display("==============================================");
        $display("       FINAL REGISTER FILE CONTENTS");
        $display("==============================================");

        $display("x0  = %h", uut.dp.rf.register_file[0]);
        $display("x1  = %h", uut.dp.rf.register_file[1]);
        $display("x2  = %h", uut.dp.rf.register_file[2]);
        $display("x3  = %h", uut.dp.rf.register_file[3]);
        $display("x4  = %h", uut.dp.rf.register_file[4]);
        $display("x5  = %h", uut.dp.rf.register_file[5]);
        $display("x6  = %h", uut.dp.rf.register_file[6]);
        $display("x7  = %h", uut.dp.rf.register_file[7]);
        $display("x8  = %h", uut.dp.rf.register_file[8]);
        $display("x9  = %h", uut.dp.rf.register_file[9]);
        $display("x10 = %h", uut.dp.rf.register_file[10]);
        $display("x11 = %h", uut.dp.rf.register_file[11]);
        $display("x12 = %h", uut.dp.rf.register_file[12]);
        $display("x13 = %h", uut.dp.rf.register_file[13]);
        $display("x14 = %h", uut.dp.rf.register_file[14]);
        $display("x15 = %h", uut.dp.rf.register_file[15]);
        $display("x16 = %h", uut.dp.rf.register_file[16]);
        $display("x17 = %h", uut.dp.rf.register_file[17]);

        // Display final PC
        $display("FINAL PROCESSOR STATE");
        $display("PC      = %h", uut.dp.PC);
        $display("WB_Data = %h", tb_WB_Data);
      
        // Display selected memory locations
        $display("DATA MEMORY CONTENTS");
        $display("MEM[0]  = %h", uut.dp.data_mem.mem[0]);
        $display("MEM[2]  = %h", uut.dp.data_mem.mem[2]);
        $display("MEM[3]  = %h", uut.dp.data_mem.mem[3]);
        $display("MEM[5]  = %h", uut.dp.data_mem.mem[5]);
        $display("MEM[12] = %h", uut.dp.data_mem.mem[12]);

        // Finish simulation

        $display("SIMULATION COMPLETE");
        $finish;

    end
  
    initial begin

        $monitor(
            "Time=%0t ns | PC=%h | Instr=%h | WB_Data=%h",
            $time,
            uut.dp.PC,
            uut.dp.Instr,
            tb_WB_Data
        );

    end

    // Basic Register Checks

    initial begin

        // Wait until reset is released
        @(negedge tb_reset);

        // Allow instructions to execute
        #1300;

        $display("REGISTER CHECKS");

        // x0 must always remain zero
        if (uut.dp.rf.register_file[0] !== 32'h00000000)
            $error("FAIL: x0 is not zero. x0 = %h",
                   uut.dp.rf.register_file[0]);
        else
            $display("PASS: x0 = 00000000");

        // Expected values from the initial arithmetic instructions
        if (uut.dp.rf.register_file[1] !== 32'h00000001)
            $error("FAIL: x1 expected 00000001, got %h",
                   uut.dp.rf.register_file[1]);
        else
            $display("PASS: x1 = 00000001");

        if (uut.dp.rf.register_file[2] !== 32'h00000002)
            $error("FAIL: x2 expected 00000002, got %h",
                   uut.dp.rf.register_file[2]);
        else
            $display("PASS: x2 = 00000002");

        if (uut.dp.rf.register_file[3] !== 32'h00000004)
            $error("FAIL: x3 expected 00000004, got %h",
                   uut.dp.rf.register_file[3]);
        else
            $display("PASS: x3 = 00000004");

        if (uut.dp.rf.register_file[4] !== 32'h00000005)
            $error("FAIL: x4 expected 00000005, got %h",
                   uut.dp.rf.register_file[4]);
        else
            $display("PASS: x4 = 00000005");

        if (uut.dp.rf.register_file[5] !== 32'h00000007)
            $error("FAIL: x5 expected 00000007, got %h",
                   uut.dp.rf.register_file[5]);
        else
            $display("PASS: x5 = 00000007");

        if (uut.dp.rf.register_file[6] !== 32'h00000008)
            $error("FAIL: x6 expected 00000008, got %h",
                   uut.dp.rf.register_file[6]);
        else
            $display("PASS: x6 = 00000008");

        // x8 = x1 + x2 = 3
        if (uut.dp.rf.register_file[8] !== 32'h00000003)
            $error("FAIL: x8 expected 00000003, got %h",
                   uut.dp.rf.register_file[8]);
        else
            $display("PASS: x8 = 00000003");

        $display("");
        $display("Register verification completed.");

    end

endmodule
