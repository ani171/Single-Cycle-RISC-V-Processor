# Single-Cycle-RISC-V-Processor
This repository contains a single-cycle RISC-V processor designed in SystemVerilog for a 5th-semester project. It supports a subset of the RISC-V ISA and executes one instruction per clock cycle. The project includes SystemVerilog source files, testbenches, and documentation, providing a complete implementation ready for synthesis and simulation.

![128730771-560da5b6-f33b-410c-bc03-2dc68f2c748e](https://github.com/user-attachments/assets/6f05702f-fb0e-48b6-b8b4-dbd9513c9c6d)

## Instruction Fetch Stage
* Modules involved: instructionmemory, mux2
* Instruction Memory (instructionmemory):
  * Purpose: Stores the program instructions. When given a read address (program counter value), it outputs the corresponding instruction.
  * Position: The output instruction from the instruction memory is fed into the next stage (Instruction Decode).
  * Function: Fetches the instruction based on the program counter (PC) value.
* Multiplexer (mux2):
  * Purpose: Chooses between different inputs based on a select signal.
  * Position: Used to select the next PC value (incremented by 4 for sequential execution or a branch/jump address).
  * Function: In the IF stage, mux2 can choose between the current PC + 4 or a branch target address for the next instruction to be fetched.
## Instruction Decode Stage
* Modules involved: imm_Gen, data_extract
* Immediate Generator (immediate_generator):
  * Purpose: Extracts and sign-extends the immediate field from the instruction.
  * Position: Outputs the immediate value used in the Execute stage.
  * Function: Generates the immediate value based on the instruction type (I-type, S-type, B-type, etc.).
* Data Extractor (isntr_decode):
  * Purpose: Extract specific parts of data based on the instruction.
  * Position: Provides the correct data format (byte, half-word, word) based on the instruction type.
  * Function: Adjusts the data format according to load/store instructions.
## Execute (EX) Stage
* Modules involved: alu, adder, adder_32, mux3
* ALU (Arithmetic Logic Unit)
  * Purpose: The ALU is responsible for performing arithmetic and logical operations on the operands.
  * Position: It receives operands from the register file or the immediate generator and executes the specified operation.
  * Function: The ALU performs various operations including addition, subtraction, logical AND/OR, bit shifts, and comparisons. For instance, it might perform an addition to compute the result of an addi instruction or a logical AND operation for an and instruction.
* Adder (adder)
  * Purpose: The adder is responsible for performing arithmetic operations, specifically addition. It is used to compute addresses and results in the processor.
  * Position:The adder is positioned in the Execute (EX) stage of the processor pipeline. It receives inputs from various sources such as the current Program Counter (PC), branch offsets, and immediate values.
  * Function:The adder performs addition operations for different tasks:
* Multiplexer (mux3)
  * Purpose: The mux3 selects between multiple input sources based on control signals.
  * Position: It is positioned to select between different operands for the ALU operation.
  * Function:
      * Operand Selection: mux3 allows the selection of different operands for the ALU. For example, it might select between a value from the register file or an immediate value based on the instruction type.
      * Control Signals: The control signals determine which input is forwarded to the ALU. This enables the processor to execute various types of instructions, such as arithmetic operations or data manipulations, based on the instruction being executed.
