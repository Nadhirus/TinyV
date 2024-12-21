`default_nettype none
`include "types.sv"

module registerFile (
  input logic clk,
  input logic writeEnable,

  input logic [`REG_ADDR_WIDTH - 1:0] addr_rs1,
  output logic [`DATA_WIDTH - 1:0] rs1_data,

  input logic [`REG_ADDR_WIDTH - 1:0] addr_rs2,
  output logic [`DATA_WIDTH - 1:0] rs2_data,

  input logic [`REG_ADDR_WIDTH - 1:0] addr_write,
  input logic [`DATA_WIDTH - 1:0] write_data
);

  // Register file array: 32 registers, each 32 bits wide
  logic [`DATA_WIDTH - 1:0] registerArray[31:0];

  // Ensure register 0 is always 0
  initial begin
    registerArray[0] = 32'b0;
  end

  always @(posedge clk) begin
    if (writeEnable && addr_write != 5'b00000) begin
      registerArray[addr_write] <= write_data;
    end
    rs1_data <= registerArray[addr_rs1];
    rs2_data <= registerArray[addr_rs2];
  end


endmodule
