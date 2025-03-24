`default_nettype none
`include "types.sv"

module mux3x1 #(
    parameter int DATA_WIDTH = `DATA_WIDTH
) (
    input wire [DATA_WIDTH-1 : 0] A,
    input wire [DATA_WIDTH-1 : 0] B,
    input wire [DATA_WIDTH-1 : 0] C,
    input wire [1:0] sel,
    output reg [DATA_WIDTH-1 : 0] result
);

  always @(A, B, C, sel) begin
    case (sel)
      2'b00:   result = A;
      2'b01:   result = B;
      2'b10:   result = C;
      default: result = '0;
    endcase
  end

endmodule






