`timescale 1ns / 1ps

module RegFile #(
      parameter DATA_WIDTH   = 32,  // number of bits in each register
      parameter ADDRESS_WIDTH = 5,  // number of registers = 2^ADDRESS_WIDTH
      parameter NUM_REGS = 32
   )
   (
   input logic clk,                     // Clock
   input logic rst,                     // Synchronous reset; if asserted (rst=1), all registers are reset to 0
   input logic rg_wrt_en,               // Write enable signal
   input logic [ADDRESS_WIDTH-1:0] rg_wrt_dest, // Address of the register to be written into
   input logic [ADDRESS_WIDTH-1:0] rg_rd_addr1, // Address of the first register to be read from
   input logic [ADDRESS_WIDTH-1:0] rg_rd_addr2, // Address of the second register to be read from
   input logic [DATA_WIDTH-1:0] rg_wrt_data,    // Data to be written into the register file
   output logic [DATA_WIDTH-1:0] rg_rd_data1, // Content of reg_file[rg_rd_addr1] is loaded into
   output logic [DATA_WIDTH-1:0] rg_rd_data2  // Content of reg_file[rg_rd_addr2] is loaded into
   );

integer i;

logic [DATA_WIDTH-1:0] register_file [NUM_REGS-1:0];

// Synchronous reset and write operations
always @(negedge clk) begin
   if (rst == 1'b1) begin
      for (i = 0; i < NUM_REGS; i = i + 1) begin
          register_file[i] <= 0;
      end
   end else if (rg_wrt_en == 1'b1) begin
      register_file[rg_wrt_dest] <= rg_wrt_data;
   end
end

// Read operations
assign rg_rd_data1 = register_file[rg_rd_addr1];
assign rg_rd_data2 = register_file[rg_rd_addr2];

endmodule
