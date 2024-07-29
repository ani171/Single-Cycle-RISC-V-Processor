# RISC-V Top Module
![image](https://github.com/user-attachments/assets/ee9b39a0-d539-4499-b393-e7938ab97b6c)
* This is the top-level module for a RISC-V processor implementation.
* It integrates the control unit, ALU control unit, and datapath to form a complete processor. The module coordinates the operations of various submodules to execute RISC-V instructions, handle memory operations, and perform arithmetic and logical computations. 

## Datapath 
![image](https://github.com/user-attachments/assets/1565c000-fa3d-431f-a8bc-82fd2d79f97c)
* The Datapath module is responsible for implementing the core data flow of the processor. 
* It manages the Program Counter (PC), performs arithmetic and logical operations, handles instructions and memory operations, and coordinates between registers, ALU, and memory. 

## Control Unit
![image](https://github.com/user-attachments/assets/b71bb337-e441-4a47-911d-fbf95a343619)
* The control_unit module generates control signals for various operations in the processor.
* Based on the opcode from the instruction, it produces signals to control the ALU operation, memory access, register writes, and branching. This module ensures that the processor performs the correct operations by directing data flow and controlling execution paths.

## ALU Control
![image](https://github.com/user-attachments/assets/b71948fc-5df9-430d-8729-f362699312d6)
* Determines which operation the ALU should perform based on the instruction.
* Interfaces between the instruction decode logic and the ALU.
* Produces control signals to configure the ALU for the required operation.
