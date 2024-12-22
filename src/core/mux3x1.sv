`default_nettype none
`include "types.sv"

module mux3x1 #(
  parameter DATA_WIDTH = `DATA_WIDTH
)(
  input logic [DATA_WIDTH-1 : 0] A,
  input logic [DATA_WIDTH-1 : 0] B,
  input logic [DATA_WIDTH-1 : 0] C,
  input logic [1:0] sel, 
  output logic [DATA_WIDTH-1 : 0] result
);

  always_comb begin
    case (sel)
      2'b00: result = A;
      2'b01: result = B;
      2'b10: result = C;
      default: result = '0;
    endcase
  end

endmodule






