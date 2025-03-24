`default_nettype none
`include "types.sv"
module ALU #(
    parameter int DATA_WIDTH = `DATA_WIDTH  // Use the DATA_WIDTH from defines
) (
    input  wire  [ DATA_WIDTH - 1:0] a,
    input  wire  [ DATA_WIDTH - 1:0] b,
    input  wire  [`ALU_SEL_SIZE-1:0] alu_sel,
    output logic [ DATA_WIDTH - 1:0] result
);

  // Cast the alu_sel input to match ALU operations
  always_comb begin : aluComb
    case (alu_sel)
      `ALU_AND: result = a & b;
      `ALU_OR: result = a | b;
      `ALU_XOR: result = a ^ b;
      `ALU_SLT: result = ($signed(a) < $signed(b)) ? `DATA_WIDTH'd1 : `DATA_WIDTH'd0;
      `ALU_SLTU: result = (a < b) ? `DATA_WIDTH'd1 : `DATA_WIDTH'd0;
      `ALU_ADD: result = a + b;
      `ALU_SUB: result = a - b;
      `ALU_SRL: result = a >> b[4:0];
      `ALU_SLL: result = a << b[4:0];
      `ALU_SRA: result = ($signed(a) >>> b[4:0]);
      `ALU_CMP: result = (a == b) ? `DATA_WIDTH'd1 : `DATA_WIDTH'd0;
      `ALU_NOP: result = `DATA_WIDTH'd0;
      `ALU_INVALID: result = `DATA_WIDTH'hDEADBEEF;
      default: result = `DATA_WIDTH'hDEADBEEF;
    endcase

  end

endmodule
