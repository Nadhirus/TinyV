// `default_nettype none
`timescale 1us/100ns

module tb_ALU;
    // Declare inputs and outputs
    reg [31:0] a, b;
    reg [3:0] alu_sel;
    wire [31:0] result;
    reg clk, reset;

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
        #15 reset = 0;  // Deassert reset after 15ns
    end

    // Stimulus generation
    initial begin
        // Apply test cases for ALU operations
        a = 32'h0; b = 32'h0; alu_sel = ALU_ADD; #10;
        a = 32'h5; b = 32'h3; alu_sel = ALU_AND; #10;
        a = 32'h7; b = 32'h2; alu_sel = ALU_OR; #10;
        a = 32'hF; b = 32'h4; alu_sel = ALU_XOR; #10;
        a = 32'h8; b = 32'h3; alu_sel = ALU_SLT; #10;
        a = 32'h8; b = 32'h3; alu_sel = ALU_SLTU; #10;
        a = 32'h100; b = 32'h7F; alu_sel = ALU_SUB; #10;
        a = 32'h10; b = 32'h2; alu_sel = ALU_SRL; #10;
        a = 32'h10; b = 32'h2; alu_sel = ALU_SLL; #10;
        a = 32'h10; b = 32'h2; alu_sel = ALU_SRA; #10;
        a = 32'h0; b = 32'h0; alu_sel = ALU_NOP; #10;
        a = 32'h0; b = 32'h0; alu_sel = ALU_INVALID; #10;
    end

    // Assert properties (formal verification)
    // Define sequences and assertions for ALU operations

    

    
endmodule
