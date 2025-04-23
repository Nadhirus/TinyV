`default_nettype none
`include "types.sv"

module immediateGenerator (
    input  wire [31:0] instruction,
    output reg  [31:0] imm
  );

  logic [6:0] opcode;
  assign opcode = instruction[6:0];

  logic [31:0] i_imm;
  logic [31:0] s_imm;
  logic [31:0] b_imm;
  logic [31:0] u_imm;
  logic [31:0] j_imm;

  assign i_imm = {{21{instruction[31]}}, instruction[30:20]};
  assign s_imm = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};
  assign b_imm = {
           {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0
         };
  assign u_imm = {instruction[31:12], 12'b0};
  assign j_imm = {
           {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0
         };

  assign imm =
         (opcode == `JALR || opcode == `LOAD || opcode == `ALUI) ? i_imm :
         (opcode == `STORE) ? s_imm :
         (opcode == `BRANCH) ? b_imm :
         (opcode == `LUI || opcode == `AUIPC) ? u_imm :
         (opcode == `JAL) ? j_imm :
         32'b0; // Default case
endmodule
