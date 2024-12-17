`default_nettype none
`timescale 1us/100ns
`include "types.sv"

module tb_ALU;
    // Declare inputs and outputs
    wire clk;
    wire reset;
    reg [31:0] a, b;
    reg [3:0] alu_sel;
    wire [31:0] result;

    // Instantiate the DUT (Design Under Test)
    ALU DUT (
        .a(a), 
        .b(b), 
        .alu_sel(alu_sel), 
        .result(result)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 10ns clock period
    end

    // Reset generation
    initial begin
        reset = 1;
        #15 reset = 0;  
        alu_sel = `ALU_ADD;
    end

    // Input constraints and assumptions
    initial begin
        assume(a >= 0);  
        assume(b >= 0); 
    end


    // Assert properties (formal verification)
    always @(posedge clk) begin
        assert ((a + b) == result);
    end

endmodule