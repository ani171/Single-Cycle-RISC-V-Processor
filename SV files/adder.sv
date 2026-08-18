module adder
    #(parameter WIDTH = 32)
    (
        input logic [WIDTH-1:0] a,
        input logic [WIDTH-1:0] b,
        input logic [1:0] select,
        output logic [WIDTH-1:0] sum
    );

    always_comb
    begin
        case(select)
            2'b00: sum = a + b;
            2'b01: sum = a + b;
            default: sum = 0;
        endcase
    end

endmodule
