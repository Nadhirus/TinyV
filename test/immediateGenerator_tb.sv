`default_nettype none
`timescale 1ns / 1ps

module tb_immediateGenerator ();

  // Testbench Signals
  logic [31:0] instruction;
  logic [31:0] imm;

  // Instantiate the DUT
  immediateGenerator uut (
    .instruction(instruction),
    .imm(imm)
  );

  // Task to check results and print pass/fail
  task check_result;
    input [31:0] instr;
    input [31:0] expected_imm;
    input string imm_type;
    begin
      if (imm === expected_imm) begin
        $display("[%s] Test Passed!", imm_type);
      end else begin
        $display("[%s] Test Failed. Expected: %h, Got: %h", imm_type, expected_imm, imm);
      end
    end
  endtask

  // Testbench Logic
  initial begin
    $display("Starting Testbench for immediateGenerator...");

    // Test Case 1: I-Type
    instruction = 32'b1111_1110_0000_0001_0000_0011_1001_0011;  // I-Type
    #10;
    check_result(instruction, 32'hFFFFFFE0, "I-Type");

    // Test Case 2: S-Type
    instruction = 32'b1111_1110_0001_0001_1000_0011_0010_0011;  // S-Type
    //1111_1111_1111_1111_1111_1111_1110_0110;
    #10;
    check_result(instruction, 32'b1111_1111_1111_1111_1111_1111_1110_0110, "S-Type");

    // Test Case 3: B-Type
    instruction = 32'b1111_1110_0001_0001_1000_0001_0110_0011;  // B-Type
    // 1111_1111_1111_1111_1111_0111_1110_0010
    #10;
    check_result(instruction, 32'b1111_1111_1111_1111_1111_0111_1110_0010, "B-Type");

    // Test Case 4: U-Type
    instruction = 32'b0001_0010_0011_0100_0101_00101_0110111;  // U-Type
    // 1111_1111_1111_1111_1111_0000_0000_0000
    #10;
    check_result(instruction, 32'b0001_0010_0011_0100_0101_0000_0000_0000, "U-Type");

    // Test Case 5: J-Type
    instruction = 32'b1111_1110_0000_0001_1000_0000_1110_1111;  // J-Type
    // 1111_1111_1111_0001_1000_0111_1110_0000
    #10;
    check_result(instruction, 32'b1111_1111_1111_0001_1000_0111_1110_0000, "J-Type");

    // Test Case 6: Default Case
    instruction = 32'b00000000000000000000000000000000;  // Default
    #10;
    check_result(instruction, 32'b0, "Default");

    $display("Testbench complete.");
    $finish;
  end
endmodule
