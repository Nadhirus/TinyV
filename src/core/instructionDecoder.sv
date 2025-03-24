`default_nettype none
`include "immediateGenerator.sv"
`include "types.sv"


module instructionDecoder (
    input  wire [31:0] instruction,  // Input instruction (32-bit)
    output wire [ 6:0] opcode,       // Opcode (bits [6:0])
    output wire [ 2:0] func3,        // func3 (bits [14:12])
    output wire [ 6:0] func7,        // func7 (bits [31:25])
    output wire [ 4:0] rs1,          // Source register 1 (bits [19:15])
    output wire [ 4:0] rs2,          // Source register 2 (bits [24:20])
    output wire [ 4:0] rd,           // Destination register (bits [11:7])
    output wire [31:0] immediate
  );

  // Extract fields from the instruction
  assign opcode = instruction[6:0];  // Opcode
  assign func3  = instruction[14:12];  // func3
  assign func7  = instruction[31:25];  // func7
  assign rs1    = instruction[19:15];  // rs1
  assign rs2    = instruction[24:20];  // rs2
  assign rd     = instruction[11:7];  // rd

  immediateGenerator immGen (
                       .instruction(instruction),
                       .imm(immediate)
                     );

endmodule
