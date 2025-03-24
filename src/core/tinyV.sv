`default_nettype none
`include "types.sv"

module tinyV (
    input wire clk,
    input wire reset,

    // Data memory interface (RAM)
    output logic [31:0] d_address,
    input  wire  [31:0] d_data_read,
    output logic [31:0] d_data_write,
    output logic [ 3:0] d_data_wstrb,
    output logic        d_write_enable,
    input  wire         d_data_valid,

    // Instruction memory interface (ROM)
    output logic [31:0] i_address,
    input  wire  [31:0] i_data_read,
    input  wire         i_data_valid
);

  // Internal control signals
  logic                     pc_write_enable;
  logic                     reg_write_enable;
  logic [              1:0] pc_src;
  logic                     alu_src_b;
  logic [              1:0] result_src;
  logic [`ALU_SEL_SIZE-1:0] alu_control;
  logic                     mem_write;
  logic [              2:0] funct3;

  // Decoded instruction fields
  logic [              6:0] opcode;
  logic [              2:0] func3;
  logic [              6:0] func7;

  // Branch result
  logic                     branch_taken;

  // Instantiate the datapath
  dataPath dp (
      .clk  (clk),
      .reset(reset),

      // Memory interfaces
      .d_address(d_address),
      .d_data_read(d_data_read),
      .d_data_write(d_data_write),
      .d_data_wstrb(d_data_wstrb),
      .d_write_enable(d_write_enable),
      .d_data_valid(d_data_valid),
      .i_address(i_address),
      .i_data_read(i_data_read),
      .i_data_valid(i_data_valid),

      // Control signals
      .pc_write_enable(pc_write_enable),
      .reg_write_enable(reg_write_enable),
      .pc_src(pc_src),
      .alu_src_b(alu_src_b),
      .result_src(result_src),
      .alu_control(alu_control),
      .mem_write(mem_write),
      .funct3(funct3),
      .branch_taken(branch_taken),

      // Decoded instruction fields
      .opcode(opcode),
      .func3 (func3),
      .func7 (func7)
  );

  // Instantiate the control unit
  controlUnit cu (
      .clk  (clk),
      .reset(reset),

      // Instruction fields
      .opcode(opcode),
      .func3 (func3),
      .func7 (func7),

      // Status signals
      .branch_taken(branch_taken),
      .i_data_valid(i_data_valid),
      .d_data_valid(d_data_valid),

      // Control outputs
      .pc_write_enable(pc_write_enable),
      .reg_write_enable(reg_write_enable),
      .pc_src(pc_src),
      .alu_src_b(alu_src_b),
      .result_src(result_src),
      .alu_control(alu_control),
      .mem_write(mem_write),
      .funct3(funct3)
  );

endmodule
