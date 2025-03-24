`default_nettype none
`include "types.sv"
// `include "alu.sv"
// `include "register_file.sv"
// `include "mux3x1.sv"
// `include "../memory/dmem.sv"
// `include "../memory/imem.sv"
// `include "../memory/mem.sv"

module dataPath (
    input wire clk,
    input wire reset,

    // RAM contenant les données
    output logic [31:0] d_address,
    input  wire  [31:0] d_data_read,
    output logic [31:0] d_data_write,
    output logic [ 3:0] d_data_wstrb,
    output logic        d_write_enable,
    input  wire         d_data_valid,

    // ROM contenant les instructions
    output logic [31:0] i_address,
    input  wire  [31:0] i_data_read,
    input  wire         i_data_valid,

    // Control signals from control FSM
    input  wire                     pc_write_enable,
    input  wire                     reg_write_enable,
    input  wire [              1:0] pc_src,            // 00: PC+4, 01: Branch, 10: Jump
    input  wire                     alu_src_b,         // 0: rs2, 1: immediate
    input  wire [              1:0] result_src,        // 00: ALU, 01: Memory, 10: PC+4
    input  wire [`ALU_SEL_SIZE-1:0] alu_control,
    input  wire                     mem_write,
    input  wire [              2:0] funct3,            // For store and load operations
    output wire                     branch_taken,      // 1 if branch condition is met
    output wire [              6:0] opcode,            // Opcode from the instruction
    output wire [              2:0] func3,             // func3 from the instruction
    output wire [              6:0] func7              // func7 from the instruction
);

  // Program Counter logic
  logic [31:0] pc_current;
  logic [31:0] pc_next;
  logic [31:0] pc_plus_4;
  logic [31:0] branch_target;
  logic [31:0] jump_target;

  // Register File signals
  logic [4:0] rs1_addr;
  logic [4:0] rs2_addr;
  logic [4:0] rd_addr;
  logic [31:0] rs1_data;
  logic [31:0] rs2_data;
  logic [31:0] write_data;

  // ALU signals
  logic [31:0] alu_operand_a;
  logic [31:0] alu_operand_b;
  logic [31:0] alu_result;

  // Immediate generation
  logic [31:0] immediate;

  // Current instruction
  logic [31:0] instruction;

  // Internal connections
  logic branch_condition;

  // Program Counter Register
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      pc_current <= 32'h00000000;
    end else if (pc_write_enable) begin
      pc_current <= pc_next;
    end
  end

  // PC+4 calculation
  assign pc_plus_4   = pc_current + 32'd4;

  // Connect PC to instruction memory address
  assign i_address   = pc_current;

  // Fetch instruction
  assign instruction = i_data_read;

  // Instruction Decoder instantiation
  instructionDecoder decoder (
      .instruction(instruction),
      .opcode(opcode),
      .func3(func3),
      .func7(func7),
      .rs1(rs1_addr),
      .rs2(rs2_addr),
      .rd(rd_addr),
      .immediate(immediate)
  );

  // Register File instantiation
  registerFile regFile (
      .clk(clk),
      .reset(reset),
      .writeEnable(reg_write_enable),
      .addr_rs1(rs1_addr),
      .rs1_data(rs1_data),
      .addr_rs2(rs2_addr),
      .rs2_data(rs2_data),
      .addr_write(rd_addr),
      .write_data(write_data)
  );

  // ALU instantiation
  ALU alu (
      .a(rs1_data),
      .b(alu_operand_b),
      .alu_sel(alu_control),
      .result(alu_result)
  );

  // ALU source B multiplexer (reg or immediate)
  assign alu_operand_b = alu_src_b ? immediate : rs2_data;

  // Branch target calculation
  assign branch_target = pc_current + immediate;

  // Jump target calculation (used for JAL and JALR)
  // For JALR: rs1 + immediate
  // For JAL: pc + immediate
  assign jump_target   = (opcode == 7'b1100111) ? (rs1_data + immediate) : branch_target;

  // Branch condition check based on func3
  always_comb begin
    case (func3)
      3'b000:  branch_condition = (rs1_data == rs2_data);  // BEQ
      3'b001:  branch_condition = (rs1_data != rs2_data);  // BNE
      3'b100:  branch_condition = ($signed(rs1_data) < $signed(rs2_data));  // BLT
      3'b101:  branch_condition = ($signed(rs1_data) >= $signed(rs2_data));  // BGE
      3'b110:  branch_condition = (rs1_data < rs2_data);  // BLTU
      3'b111:  branch_condition = (rs1_data >= rs2_data);  // BGEU
      default: branch_condition = 1'b0;
    endcase
  end

  // Branch taken signal - only in branch instructions (opcode == 1100011)
  assign branch_taken = (opcode == 7'b1100011) & branch_condition;

  // PC source multiplexer
  always_comb begin
    case (pc_src)
      2'b00:   pc_next = pc_plus_4;
      2'b01:   pc_next = branch_taken ? branch_target : pc_plus_4;
      2'b10:   pc_next = jump_target;
      default: pc_next = pc_plus_4;
    endcase
  end

  // Memory access logic
  assign d_address = alu_result;
  assign d_data_write = rs2_data;
  assign d_write_enable = mem_write;

  // Generate write strobe based on funct3 for store operations
  always_comb begin
    if (mem_write) begin
      case (funct3)
        3'b000:  d_data_wstrb = 4'b0001;  // SB
        3'b001:  d_data_wstrb = 4'b0011;  // SH
        3'b010:  d_data_wstrb = 4'b1111;  // SW
        default: d_data_wstrb = 4'b0000;
      endcase
    end else begin
      d_data_wstrb = 4'b0000;
    end
  end

  // Data memory read result processing based on funct3 for load operations
  logic [31:0] load_data;
  always_comb begin
    case (funct3)
      3'b000:  load_data = {{24{d_data_read[7]}}, d_data_read[7:0]};  // LB
      3'b001:  load_data = {{16{d_data_read[15]}}, d_data_read[15:0]};  // LH
      3'b010:  load_data = d_data_read;  // LW
      3'b100:  load_data = {24'b0, d_data_read[7:0]};  // LBU
      3'b101:  load_data = {16'b0, d_data_read[15:0]};  // LHU
      default: load_data = d_data_read;
    endcase
  end

  // Result source multiplexer for register write back
  always_comb begin
    case (result_src)
      2'b00:   write_data = alu_result;
      2'b01:   write_data = load_data;
      2'b10:   write_data = pc_plus_4;
      default: write_data = alu_result;
    endcase
  end

endmodule
