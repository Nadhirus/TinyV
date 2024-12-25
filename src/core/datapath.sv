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
  input logic reset,

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

  output logic [`OPCODE_WIDTH-1:0] codop  // Create a type definition for this in types.sv
);

  // Internal registers
  reg   [`MEM_ADDR_WIDTH-1:0] pc;  // Program Counter
  reg   [    `DATA_WIDTH-1:0] ir;  // Instruction Register (IR)
  reg   [    `DATA_WIDTH-1:0] dm;  // Data Register (DM)
  reg   [    `DATA_WIDTH-1:0] a_register;  // A Register (ALU Operand)
  reg   [    `DATA_WIDTH-1:0] b_register;  // B Register (ALU Operand)
  reg   [    `DATA_WIDTH-1:0] d_register;  // D Register (ALU Result)

  // Internal signals
  logic [    `DATA_WIDTH-1:0] pc_write_wire;  // PC Write Wire
  logic [    `DATA_WIDTH-1:0] rs1_data;  // Register RS1 Data
  logic [    `DATA_WIDTH-1:0] rs2_data;  // Register RS2 Data
  logic [    `DATA_WIDTH-1:0] d_register_write_wire;  // D Register Write Wire
  logic [`MEM_ADDR_WIDTH-1:0] memory_address;  // Memory Address
  logic [    `DATA_WIDTH-1:0] memory_output;  // Memory Output
  logic [    `DATA_WIDTH-1:0] registerfile_input;  // Register File Input
  logic [`REG_ADDR_WIDTH-1:0] registerfile_write_address;  // Register File Write Address

  logic [    `DATA_WIDTH-1:0] alu_operand_a;  // ALU Operand A
  logic [    `DATA_WIDTH-1:0] alu_operand_b;  // ALU Operand B
  logic [    `DATA_WIDTH-1:0] alu_output;  // ALU Output
  logic                       pc_write_enable;  // PC Write Enable Signal

  // Reset block
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      pc <= {`MEM_ADDR_WIDTH{1'b0}};
      ir <= {`DATA_WIDTH{1'b0}};
      dm <= {`DATA_WIDTH{1'b0}};
      a_register <= {`DATA_WIDTH{1'b0}};
      b_register <= {`DATA_WIDTH{1'b0}};
      d_register <= {`DATA_WIDTH{1'b0}};
      codop <= {`OPCODE_WIDTH{1'b0}};
    end else begin
      // Normal operation logic
      if (pc_write_enable) pc <= pc_write_wire;
      ir <= memory_output;
      codop <= ir[`OPCODE_WIDTH-1:0];
      dm <= memory_output;
      a_register <= rs1_data;
      b_register <= rs2_data;
      d_register <= d_register_write_wire;
    end
  end

  // PC Connection
  assign pc_write_enable = (pcCtrl | alu_output == `DATA_WIDTH'd1);

  // Memory Address Selection
  assign memory_address  = memAdrSel ? d_register : pc;

  // Memory Instance
  memory #(
    .DATA_WIDTH(`DATA_WIDTH),
    .ADDR_WIDTH(`DMEM_ADDR_WIDTH)
  ) memory_instance (
    .write_data_input(b_register),
    .memory_address(memory_address),
    .memory_write_enable(memWrCtl),
    .clk(clk),
    .memory_read_data(memory_output)
  );

  // Register File Input Selection
  assign registerfile_input = regDataSel ? d_register : dm;

  // Register Write Selection
  mux3x1 #(
    .DATA_WIDTH(`REG_ADDR_WIDTH)
  ) registerWriteSelection (
    .A(ir[21:17]),
    .B(ir[26:22]),
    .C(`REG_ADDR_WIDTH'b11111),
    .sel(regWSel),
    .result(registerfile_write_address)
  );

  // Register File Instance
  registerFile registerFileInstance (
    .clk(clk),
    .reset(reset),
    .writeEnable(regWCtl),
    .addr_rs1(ir[31:27]),
    .addr_rs2(ir[26:22]),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .addr_write(registerfile_write_address),
    .write_data(registerfile_input)
  );

  // ALU Operand A Selection
  assign alu_operand_a = aluASel ? a_register : pc;

  // ALU Operand B Selection
  mux3x1 #(
    .DATA_WIDTH(`DATA_WIDTH)
  ) aluBOperandselection (
    .A(b_register),
    .B(`DATA_WIDTH'h0004),
    .C({{16{ir[21]}}, ir[21:6]}),
    .sel(aluBSel),
    .result(alu_operand_b)
  );

  // ALU Instance
  ALU #(
    .DATA_WIDTH(`DATA_WIDTH)
  ) aluInstance (
    .a(alu_operand_a),
    .b(alu_operand_b),
    .alu_sel(aluOp),
    .result(d_register_write_wire)
  );

  // PC Selection Logic
  logic [`DATA_WIDTH-1:0] CPortpcSelection;
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

endmodule
