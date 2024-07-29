module adder
    #(parameter WIDTH = 32)
    (
        input logic [WIDTH-1:0] a,   // Input operand 1
        input logic [WIDTH-1:0] b,   // Input operand 2
        input logic [1:0] select,    // Control signal to select operation
        output logic [WIDTH-1:0] sum // Output result
    );

    always_comb
    begin
        case(select)
            2'b00: sum = a + b;   // Add for branch target or PC increment
            2'b01: sum = a + b;   // Another operation, if needed
            // Add additional cases if other operations are needed
            default: sum = 0;
        endcase
    end

endmodule
