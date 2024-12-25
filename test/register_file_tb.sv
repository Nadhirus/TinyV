`timescale 1ns / 1ps `default_nettype none
`include "../src/core/types.sv"

module register_file_tb;

  // Testbench signals
  logic clk;
  logic reset;
  logic writeEnable;
  logic [`REG_ADDR_WIDTH - 1:0] addr_rs1;
  logic [`DATA_WIDTH - 1:0] rs1_data;
  logic [`REG_ADDR_WIDTH - 1:0] addr_rs2;
  logic [`DATA_WIDTH - 1:0] rs2_data;
  logic [`REG_ADDR_WIDTH - 1:0] addr_write;
  logic [`DATA_WIDTH - 1:0] write_data;

  // Instantiate the core
  registerFile uut (
    .clk        (clk),
    .reset      (reset),
    .writeEnable(writeEnable),
    .addr_rs1   (addr_rs1),
    .rs1_data   (rs1_data),
    .addr_rs2   (addr_rs2),
    .rs2_data   (rs2_data),
    .addr_write (addr_write),
    .write_data (write_data)
  );

  // Clock generation using an always block (no # delay operator)
  initial begin
    clk = 0;  // Ensure it starts at a defined value
    forever #5 clk = ~clk;  // Toggle clock every 5 time units
  end

  // Initialize signals
  initial begin
    writeEnable = 0;
    addr_rs1 = 0;
    addr_rs2 = 0;
    addr_write = 0;
    write_data = 0;
  end

  // Reset logic
  initial begin
    reset = 1;
    #10 reset = 0;  // De-assert reset after 20 time units
  end

  // Testbench stimulus
  initial begin
    // Wait for reset
    #10;

    // Test case 1: Write to register 1 and read from it
    writeEnable = 1;
    addr_write  = 1;
    write_data  = 32'hA5A5A5A5;
    #10;
    writeEnable = 0;
    addr_rs1 = 1;
    #10;
    if (rs1_data !== 32'hA5A5A5A5) $error("Test case 1 failed");

    // Test case 2: Write to register 2 and read from it
    writeEnable = 1;
    addr_write  = 2;
    write_data  = 32'h5A5A5A5A;
    #10;
    writeEnable = 0;
    addr_rs2 = 2;
    #10;
    if (rs2_data !== 32'h5A5A5A5A) $error("Test case 2 failed");

    // Test case 3: Write to register 3 and read from it
    writeEnable = 1;
    addr_write  = 3;
    write_data  = 32'h12345678;
    #10;
    writeEnable = 0;
    addr_rs1 = 3;
    #10;
    if (rs1_data !== 32'h12345678) $error("Test case 3 failed");

    // Test case 4: Write to register 4 and read from it
    writeEnable = 1;
    addr_write  = 4;
    write_data  = 32'h87654321;
    #10;
    writeEnable = 0;
    addr_rs2 = 4;
    #10;
    if (rs2_data !== 32'h87654321) $error("Test case 4 failed");

    // Test case 5: Ensure writes to register 0 are ignored
    writeEnable = 1;
    addr_write  = 0;
    write_data  = 32'hDEADBEEF;
    #10;
    writeEnable = 0;
    addr_rs1 = 0;
    #10;
    if (rs1_data !== 32'h0) $error("Test case 5 failed: Register 0 should remain 0");

    // Test case 6: Read from uninitialized register (e.g., addr = 5)
    addr_rs1 = 5;
    #10;
    if (rs1_data !== 32'h0)
      $error("Test case 6 failed: Uninitialized registers should read as 0 or default value");

    // Test case 7: Simultaneous write to addr=6 and read from addr=6
    addr_write = 6;
    write_data = 32'hCAFEBABE;
    writeEnable = 1;
    addr_rs1 = 6;  // Reading from the same address being written
    #10;
    writeEnable = 0;
    #10;
    if (rs1_data !== 32'hCAFEBABE) $error("Test case 7 failed: Simultaneous write/read issue");

    // Test case 8: Test maximum address boundary
    addr_write  = 31;
    write_data  = 32'hFFFFFFFF;
    writeEnable = 1;
    #10;
    writeEnable = 0;
    addr_rs2 = 31;
    #10;
    if (rs2_data !== 32'hFFFFFFFF) $error("Test case 8 failed: Maximum address boundary issue");


    // Finish simulation
    $finish;
  end

  // Dump waveforms to a VCD file for GTKWave
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, register_file_tb);  // Captures the entire top module
    // $dumpvars(1, uut.registerArray);
  end

  // Monitor outputs
  initial begin
    $monitor(
      "Time: %0t | writeEnable: %b | addr_rs1: %h | rs1_data: %h | addr_rs2: %h | rs2_data: %h",
      $time, writeEnable, addr_rs1, rs1_data, addr_rs2, rs2_data);
  end

endmodule
