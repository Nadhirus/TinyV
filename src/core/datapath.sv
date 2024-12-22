`default_nettype none
`include "types.sv"
// `include "alu.sv"
// `include "register_file.sv"
// `include "mux3x1.sv"
// `include "../memory/dmem.sv"
// `include "../memory/imem.sv"
// `include "../memory/mem.sv"

module datapath (
  input logic clk,

  input logic [1:0] pcWrSel,
  input logic pcCtrl,

  input logic memAdrSel,
  input logic memWrCtl,

  input logic [`ALU_SEL_SIZE-1:0] aluOp,
  input logic aluASel,
  input logic [1:0] aluBSel,

  input logic regWCtl,
  input logic regDataSel,
  input logic [1:0] regWSel,

  output logic [`OPCODE_WIDTH -1 : 0] codop  // Create a type definition for this in types.sv
);

  // Registers for internal datapath operations
  reg   [`MEM_ADDR_WIDTH-1 : 0] pc;  // Program Counter (PC) Register  
  reg   [    `DATA_WIDTH-1 : 0] ir;  // Instruction Register (IR)
  reg   [    `DATA_WIDTH-1 : 0] dm;  // Data Register (DM)

  reg   [    `DATA_WIDTH-1 : 0] a_register;  // A Register (ALU Operand)
  reg   [    `DATA_WIDTH-1 : 0] b_register;  // B Register (ALU Operand)

  reg   [    `DATA_WIDTH-1 : 0] d_register;  // D Register (ALU Result)

  // internal signals for dataflow in the processor 
  logic [    `DATA_WIDTH-1 : 0] pc_write_wire;  // PC Write Wire
  logic [    `DATA_WIDTH-1 : 0] rs1_data;  // PC Write Wire
  logic [    `DATA_WIDTH-1 : 0] rs2_data;  // PC Write Wire
  logic [    `DATA_WIDTH-1 : 0] d_register_write_wire;  // PC Write Wire

  logic [`MEM_ADDR_WIDTH-1 : 0] memory_address;  // Memory Address Input Wire
  logic [    `DATA_WIDTH-1 : 0] memory_output;  // Memory Output Signal
  logic [    `DATA_WIDTH-1 : 0] registerfile_input;  // Register Input Signal
  logic [    `REG_ADDR_WIDTH-1 : 0] registerfile_write_address;  // ADDED FIX 


  logic [    `DATA_WIDTH-1 : 0] alu_operand_a;  // ALU Operand A
  logic [    `DATA_WIDTH-1 : 0] alu_operand_b;  // ALU Operand B
  logic [    `DATA_WIDTH-1 : 0] alu_output;  // ALU Output

  logic                         pc_write_enable;  // Internal PC write signal

  // PC Connection Description:
  // The PC write signal is controlled by `pcCtrl` or by the ALU output (if ALU result is non-zero).
  assign pc_write_enable = (pcCtrl | alu_output == `DATA_WIDTH'd1);
  always_ff @(posedge clk) begin
    if (pc_write_enable) begin
      pc <= pc_write_wire;  // Update the PC with the value from the mux
    end
  end

  // Memory Connection Description:
  // The memory address is selected from either the PC or the Data Register based on the `memAdrSel` signal.
  assign memory_address = memAdrSel ? d_register : pc;

  // Memory module instantiation with descriptive port names
  memory #(
    .DATA_WIDTH(`DATA_WIDTH),  // Define the data width for memory
    .ADDR_WIDTH(`DMEM_ADDR_WIDTH)  // Define the address width for memory
  ) memory_instance (
    .write_data_input(b_register),  // Data to be written to memory (from Register B)
    .memory_address(memory_address),   // Memory address input (from PC multiplexer or other control logic)
    .memory_write_enable(memWrCtl),  // Write enable signal for memory operation (control signal)
    .clk(clk),  // System clock driving the memory operations
    .memory_read_data(memory_output)  // Data read from memory, connected to `memory_output`
  );

  always_ff @(posedge clk) begin : update_ir
    ir <= memory_output;
  end

  always_ff @(posedge clk) begin : update_dm
    dm <= memory_output;
  end

  // Register file module instantiation with descriptive port names
  assign registerfile_input = regDataSel ? d_register : dm;

  mux3x1 #(
    .DATA_WIDTH(`REG_ADDR_WIDTH)
  ) registerWriteSelection (
    .A(ir[21:17]),
    .B(ir[26:22]),
    .C(`REG_ADDR_WIDTH'b11111),
    .sel(regWSel),
    .result(registerfile_write_address)
  );

  registerFile registerFileInstance (
    .clk(clk),
    .writeEnable(regWCtl),
    .addr_rs1(ir[31:27]),
    .addr_rs2(ir[26:22]),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .addr_write(registerfile_write_address),
    .write_data(registerfile_input)
  );

  always_ff @(posedge clk) begin : connection_registre_a
    a_register <= rs1_data;
    b_register <= rs2_data;
  end

  assign alu_operand_a = aluASel ? a_register : pc;
  mux3x1 #(
    .DATA_WIDTH(`DATA_WIDTH)
  ) aluBOperandselection (
    .A(b_register),
    .B(`DATA_WIDTH'h0004),
    .C({{16{ir[21]}}, ir[21:6]}),
    .sel(aluBSel),
    .result(alu_operand_b)
  );

  ALU #(
    .DATA_WIDTH(`DATA_WIDTH)
  ) aluInstance (
    .a(alu_operand_a),
    .b(alu_operand_b),
    .alu_sel(aluOp),
    .result(d_register_write_wire)
  );

  always_ff @(posedge clk) begin : connection_registre_d
    d_register <= d_register_write_wire;
  end

logic [`DATA_WIDTH -1 :0] CPortpcSelection;
assign CPortpcSelection = {alu_operand_a[31:28], (ir[31:6] << 2)};
  mux3x1 #(
    .DATA_WIDTH(`DATA_WIDTH)
  ) pcSelection (
    .A(d_register_write_wire),
    .B(d_register),
    .C(CPortpcSelection),
    .sel(pcWrSel),
    .result(pc_write_wire)
  );



  assign codop = ir[`OPCODE_WIDTH-1:0];
endmodule
