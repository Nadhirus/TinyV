`include "../core/types.sv"

module memory #(
  parameter DATA_WIDTH = `DATA_WIDTH,     
  parameter ADDR_WIDTH = `DMEM_ADDR_WIDTH 
) (
  input  logic [(DATA_WIDTH-1):0] write_data_input,     
  input  logic [(ADDR_WIDTH-1):0] memory_address,         
  input  logic                    memory_write_enable,    

  input  logic                    clk,            
  output logic [(DATA_WIDTH-1):0] memory_read_data        
);

  logic [DATA_WIDTH-1:0] memory_array[2**ADDR_WIDTH-1:0];

  logic [ADDR_WIDTH-1:0] address_reg;

  always @(posedge system_clock) begin
    if (memory_write_enable) begin
      memory_array[memory_address] <= write_data_input;
    end

    address_reg <= memory_address;
  end

  assign memory_read_data = memory_array[address_reg];

endmodule
