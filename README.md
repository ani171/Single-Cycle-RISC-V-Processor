# Single-Cycle RISC-V Processor

This repository contains a single-cycle RISC-V processor implemented in SystemVerilog as part of a 5th-semester academic project. The processor implements a selected subset of the RV32I instruction set and completes instruction fetch, decode, execution, memory access, and write-back within a single clock cycle.

![128730771-560da5b6-f33b-410c-bc03-2dc68f2c748e](https://github.com/user-attachments/assets/6f05702f-fb0e-48b6-b8b4-dbd9513c9c6d)

The design includes the processor datapath, control logic, ALU, register file, instruction memory, data memory, immediate generation, and simulation testbenches.

## Supported Instruction Classes
The implementation includes support for selected:

- R-type instructions
- I-type arithmetic and logical instructions
- Load and store instructions
- Conditional branch instructions
- JAL and JALR
- LUI and AUIPC
- Shift and comparison instructions

## Datapath

The processor consists of the following major components:

- Program Counter
- Instruction Memory
- Control Unit
- Immediate Generator
- Register File
- ALU Control
- ALU
- Data Memory
- Next-PC selection logic
- Write-back multiplexers

All of these components operate as part of a single-cycle datapath.

## Instruction Fetch

- The Program Counter supplies the address to the instruction memory.
- The fetched 32-bit instruction is then decoded to generate the required control signals and operands.

The next PC can be selected from:
- PC + 4 for sequential execution
- Branch target
- JAL target
- JALR target

## Instruction Decode

- The instruction fields are divided into opcode, funct3, funct7, register addresses, and immediate fields.
- The control unit generates the control signals required by the datapath, while the immediate generator produces sign-extended or appropriately formatted immediate values for the different instruction formats.

## Execute

- The ALU performs arithmetic, logical, shift, and comparison operations.
- Depending on the instruction, the second ALU operand is selected from either the register file or the generated immediate value.
- The ALU is also used to calculate memory addresses for load/store instructions and to evaluate branch conditions.

## Memory Access

The data memory supports load and store operations.

- For load instructions, data is read from the calculated memory address.
- For store instructions, register data is written to the calculated address on the clock edge.

## Write Back

The result written to the register file can originate from:
- ALU result
- Loaded memory data
- PC + 4 for JAL/JALR
- Immediate/PC-derived values for LUI/AUIPC

The register file contains 32 general-purpose 32-bit registers.

## Project Structure

```text
├── SV files/
│   ├── riscv.sv                  # Top-level processor module
│   ├── Datapath.sv               # Main processor datapath
│   ├── control_unit_1.sv         # Main control unit
│   ├── alucontrol.sv             # ALU control logic
│   ├── alu.sv                    # Arithmetic Logic Unit
│   ├── immediate_generator.sv    # Immediate value generation
│   ├── RegFile.sv                # 32 × 32-bit register file
│   ├── instructionmemory.sv      # Instruction memory
│   ├── mem_data.sv               # Data memory
│   ├── instr_decode.sv           # Load/store data extraction
│   ├── adder.sv                  # Adder
│   ├── mux2to1.sv                # 2-to-1 multiplexer
│   ├── mux3to1.sv                # 3-to-1 multiplexer
│   └── ff_reg.sv                 # Flip-flop register
├── testbench/
│   └── riscv_tb_1.sv                
│   └── riscv_tb.sv  
