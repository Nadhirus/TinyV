`default_nettype none
`include "types.sv"

module ALU #(
  parameter DATA_WIDTH = `DATA_WIDTH  // Use the DATA_WIDTH from defines
) (
  input logic [DATA_WIDTH - 1:0] a,
  input logic [DATA_WIDTH - 1:0] b,
  input logic [3:0] alu_sel,
  output logic [DATA_WIDTH - 1:0] result
);

  // Cast the alu_sel input to match ALU operations
  always @(*) begin
    case (alu_sel)
      `ALU_AND:     result = a & b;
      `ALU_OR:      result = a | b;
      `ALU_XOR:     result = a ^ b;
      `ALU_SLT:     result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
      `ALU_SLTU:    result = (a < b) ? 32'd1 : 32'd0;
      `ALU_ADD:     result = a + b;
      `ALU_SUB:     result = a - b;
      `ALU_SRL:     result = a >> b[4:0];
      `ALU_SLL:     result = a << b[4:0];
      `ALU_SRA:     result = ($signed(a) >>> b[4:0]);
      `ALU_NOP:     result = 32'd0;
      `ALU_INVALID: result = 32'hDEADBEEF;
      default:      result = 32'hDEADBEEF;
    endcase
  end

endmodule
