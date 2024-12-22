`include "../core/types.sv"

module imem #(
  parameter DATA_WIDTH = `DATA_WIDTH,
  parameter ADDR_WIDTH = `IMEM_ADDR_WIDTH,
  parameter IMEM_FILE  = "../imem_content/imem.hex"
) (
  input  logic [(ADDR_WIDTH-1):0] address,
  input  logic                    clk,
  output logic [(DATA_WIDTH-1):0] read_data,
  output logic                    read_data_valid
);


  logic [DATA_WIDTH-1:0] imem[2**ADDR_WIDTH-1:0];

  // fill the Imemory with bootloader or test code from a hex file
  initial begin
    $readmemh(IMEM_FILE, imem, 0, 2 ** ADDR_WIDTH - 1);
  end
  always @(posedge clk) begin
    read_data <= imem[address];
  end

  assign read_data_valid = 1'b1;

endmodule
