// `default_nettype none
`timescale 1us/100ns
`include "ALU.sv"

// Testbench module
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

    // AND operation check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_AND) |-> (result == (a & b)));

    // OR operation check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_OR) |-> (result == (a | b)));

    // XOR operation check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_XOR) |-> (result == (a ^ b)));

    // Signed less than check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SLT) |-> (result == (($signed(a) < $signed(b)) ? 32'd1 : 32'd0)));

    // Unsigned less than check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SLTU) |-> (result == ((a < b) ? 32'd1 : 32'd0)));

    // Addition operation check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_ADD) |-> (result == (a + b)));

    // Subtraction operation check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SUB) |-> (result == (a - b)));

    // Shift right logical check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SRL) |-> (result == (a >> b[4:0])));

    // Shift left logical check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SLL) |-> (result == (a << b[4:0])));

    // Shift right arithmetic check
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SRA) |-> (result == $signed(a) >>> b[4:0]));

    // ALU_NOP should return zero
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_NOP) |-> (result == 32'd0));

    // ALU_INVALID should return a known error code
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_INVALID) |-> (result == 32'hDEADBEEF));

    // Default case: any unknown operation should return ALU_INVALID result
    assert property (@(posedge clk) disable iff (reset) (alu_sel != ALU_NOP && alu_sel != ALU_INVALID && 
                                                         alu_sel != ALU_AND && alu_sel != ALU_OR &&
                                                         alu_sel != ALU_XOR && alu_sel != ALU_SLT && 
                                                         alu_sel != ALU_SLTU && alu_sel != ALU_ADD && 
                                                         alu_sel != ALU_SUB && alu_sel != ALU_SRL &&
                                                         alu_sel != ALU_SLL && alu_sel != ALU_SRA) 
                     |-> (result == 32'hDEADBEEF));

    // Overflow handling for addition (ALU_ADD)
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_ADD) 
      |-> (a[31] == b[31] ? result[31] == a[31] : 1'b1));

    // Overflow handling for subtraction (ALU_SUB)
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SUB) 
      |-> (a[31] == ~b[31] ? result[31] == a[31] : 1'b1));

    // Shift left logical behavior when shifting by zero
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SLL && b == 5'd0) |-> (result == a));

    // Shift right logical behavior when shifting by zero
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SRL && b == 5'd0) |-> (result == a));

    // Shift right arithmetic behavior when shifting by zero
    assert property (@(posedge clk) disable iff (reset) (alu_sel == ALU_SRA && b == 5'd0) |-> (result == a));

    // ALU_INVALID result should never be 32'hDEADBEEF unless ALU_INVALID is selected
    assert property (@(posedge clk) disable iff (reset) 
      (result == 32'hDEADBEEF) |-> (alu_sel == ALU_INVALID));
    
endmodule
