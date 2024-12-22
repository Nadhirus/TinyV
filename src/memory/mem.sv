`include "../core/types.sv"

module memory #(
  parameter DATA_WIDTH = `DATA_WIDTH,
  parameter ADDR_WIDTH = `DMEM_ADDR_WIDTH,
  parameter IMEM_FILE  = "../imem_content/imem.hex"
) (
  input logic [(DATA_WIDTH-1):0] write_data_input,
  input logic [(ADDR_WIDTH-1):0] memory_address,
  input logic                    memory_write_enable,

  input  logic                    clk,
  output logic [(DATA_WIDTH-1):0] memory_read_data
);

  logic [DATA_WIDTH-1:0] memory_array[2**ADDR_WIDTH-1:0];

  logic [ADDR_WIDTH-1:0] address_reg;

// I'm avoiding this for this moments because of simulation errors
  // // fill the Imemory with bootloader or test code from a hex file
  // initial begin
  //   $readmemh(IMEM_FILE, memory_array, 0, 2 ** ADDR_WIDTH - 1);
  // end

// Instead I'm manually initializing the memory with hardwired values
initial begin
    memory_array[0] = 32'h00000093;  // andi x1, x0, 0
    memory_array[1] = 32'h00000113;  // andi x2, x0, 0
    memory_array[2] = 32'h000001B3;  // andi x3, x0, 0
    memory_array[3] = 32'h00500093;  // ori x1, x0, 5
    memory_array[4] = 32'h00A00113;  // ori x2, x0, 10
    memory_array[5] = 32'h002081B3;  // add x3, x1, x2
end


  always @(posedge clk) begin
    if (memory_write_enable) begin
      memory_array[memory_address] <= write_data_input;
    end

    address_reg <= memory_address;
  end

  assign memory_read_data = memory_array[address_reg];

endmodule
