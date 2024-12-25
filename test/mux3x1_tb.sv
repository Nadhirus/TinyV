`timescale 1ns / 1ps
`default_nettype none
`include "../src/core/types.sv"

module mux3x1_tb;

  // Parameters
  parameter DATA_WIDTH = `DATA_WIDTH;

  // Testbench signals
  logic [DATA_WIDTH-1:0] A, B, C;
  logic [1:0] sel;
  logic [DATA_WIDTH-1:0] result;

  // Instantiate the DUT (Device Under Test)
  mux3x1 #(
    .DATA_WIDTH(DATA_WIDTH)
  ) dut (
    .A(A),
    .B(B),
    .C(C),
    .sel(sel),
    .result(result)
  );

  // Testbench stimulus
  initial begin
    // Initialize inputs
    A = 'hAAAA;
    B = 'hBBBB;
    C = 'hCCCC;
    sel = 2'b00;

    // Apply test vectors
    #10 sel = 2'b00; // Expect result = A
    #10 sel = 2'b01; // Expect result = B
    #10 sel = 2'b10; // Expect result = C
    #10 sel = 2'b11; // Expect result = 0 (default case)

    // Finish simulation
    #10 $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time: %0t | sel: %b | A: %h, B: %h, C: %h | result: %h", 
             $time, sel, A, B, C, result);
  end

endmodule
