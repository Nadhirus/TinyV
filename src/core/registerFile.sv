`default_nettype none
`include "types.sv"

module registerFile (
    input wire clk,
    input wire reset,
    input wire writeEnable,

    input wire [`REG_ADDR_WIDTH - 1:0] addr_rs1,
    output reg [`DATA_WIDTH - 1:0] rs1_data,

    input wire [`REG_ADDR_WIDTH - 1:0] addr_rs2,
    output reg [`DATA_WIDTH - 1:0] rs2_data,

    input wire [`REG_ADDR_WIDTH - 1:0] addr_write,
    input wire [`DATA_WIDTH - 1:0] write_data
);

  // Register file array: 32 registers, each 32 bits wide
  logic [`DATA_WIDTH - 1:0] registerArray[0:31];

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      integer i;
      for (i = 0; i < 32; i = i + 1) begin
        registerArray[i] <= `DATA_WIDTH'b0;  // Clear all registers
      end
    end else if (writeEnable && (addr_write != 5'b00000)) begin
      registerArray[addr_write] <= write_data;  // Write to register if not x0
    end
  end

  assign rs1_data = (addr_rs1 == `REG_ADDR_WIDTH'b00000) ? `DATA_WIDTH'b0 : registerArray[addr_rs1];
  assign rs2_data = (addr_rs2 == `REG_ADDR_WIDTH'b00000) ? `DATA_WIDTH'b0 : registerArray[addr_rs2];

endmodule
