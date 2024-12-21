`include "../core/types.sv"

module dmem #(
  parameter DATA_WIDTH = `DATA_WIDTH,     
  parameter ADDR_WIDTH = `DMEM_ADDR_WIDTH 
) (
  input  logic [(DATA_WIDTH-1):0] write_data,     
  input  logic [(ADDR_WIDTH-1):0] address,         
  input  logic                    write_enable,    
  input  logic                    clk,            
  output logic [(DATA_WIDTH-1):0] read_data,       
  output logic                    read_data_valid 
);


  logic [DATA_WIDTH-1:0] dmem[2**ADDR_WIDTH-1:0];

  logic [ADDR_WIDTH-1:0] address_reg;

  always @(posedge clk) begin
    if (write_enable) begin
      dmem[address] <= write_data;
    end

    address_reg <= address;
  end

  assign read_data = dmem[address_reg];

  assign read_data_valid = 1'b1;

endmodule

