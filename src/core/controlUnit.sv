`default_nettype none
`include "types.sv"

module controlUnit (
    input wire       clk,
    input wire       reset,
    input wire [6:0] opcode,        // Opcode from instruction
    input wire [2:0] func3,         // func3 field from instruction
    input wire [6:0] func7,         // func7 field from instruction
    input wire       branch_taken,  // Branch condition result from datapath
    input wire       i_data_valid,  // Instruction memory data valid
    input wire       d_data_valid,  // Data memory data valid

    // Control signals to datapath
    output logic                     pc_write_enable,
    output logic                     reg_write_enable,
    output logic [              1:0] pc_src,            // 00: PC+4, 01: Branch, 10: Jump
    output logic                     alu_src_b,         // 0: rs2, 1: immediate
    output logic [              1:0] result_src,        // 00: ALU, 01: Memory, 10: PC+4
    output logic [`ALU_SEL_SIZE-1:0] alu_control,
    output logic                     mem_write,
    output logic [              2:0] funct3             // Passed through to datapath for load/store
);

  // FSM state definition
  typedef enum logic [2:0] {
    FETCH,
    DECODE,
    EXECUTE,
    MEMORY,
    WRITEBACK,
    STALL
  } state_t;

  state_t current_state, next_state;

  // Internal control signals
  logic is_branch, is_jump, is_load, is_store, is_r_type, is_i_type, is_u_type, is_j_type;

  // Instruction type decoding based on opcode
  always_comb begin
    is_r_type = (opcode == 7'b0110011);  // R-type (reg-reg)
    is_i_type = (opcode == 7'b0010011) || (opcode == 7'b0000011)  // I-type arithmetic or load
    || (opcode == 7'b1100111);  // JALR
    is_store = (opcode == 7'b0100011);  // S-type (store)
    is_branch = (opcode == 7'b1100011);  // B-type (branch)
    is_u_type = (opcode == 7'b0110111) || (opcode == 7'b0010111);  // U-type (LUI, AUIPC)
    is_j_type = (opcode == 7'b1101111);  // J-type (JAL)
    is_load = (opcode == 7'b0000011);  // Load instructions
    is_jump = is_j_type || (opcode == 7'b1100111);  // JAL or JALR
  end

  // ALU control logic
  always_comb begin
    if (is_r_type) begin
      // R-type instruction ALU control
      case ({
        func7[5], func3
      })
        4'b0000: alu_control = `ALU_ADD;  // ADD
        4'b1000: alu_control = `ALU_SUB;  // SUB
        4'b0001: alu_control = `ALU_SLL;  // SLL
        4'b0010: alu_control = `ALU_SLT;  // SLT
        4'b0011: alu_control = `ALU_SLTU;  // SLTU
        4'b0100: alu_control = `ALU_XOR;  // XOR
        4'b0101: alu_control = `ALU_SRL;  // SRL
        4'b1101: alu_control = `ALU_SRA;  // SRA
        4'b0110: alu_control = `ALU_OR;  // OR
        4'b0111: alu_control = `ALU_AND;  // AND
        default: alu_control = `ALU_INVALID;
      endcase
    end else if (is_i_type && opcode == 7'b0010011) begin
      // I-type ALU instructions
      case (func3)
        3'b000:  alu_control = `ALU_ADD;  // ADDI
        3'b001:  alu_control = `ALU_SLL;  // SLLI
        3'b010:  alu_control = `ALU_SLT;  // SLTI
        3'b011:  alu_control = `ALU_SLTU;  // SLTIU
        3'b100:  alu_control = `ALU_XOR;  // XORI
        3'b101:  alu_control = (func7[5]) ? `ALU_SRA : `ALU_SRL;  // SRAI / SRLI
        3'b110:  alu_control = `ALU_OR;  // ORI
        3'b111:  alu_control = `ALU_AND;  // ANDI
        default: alu_control = `ALU_INVALID;
      endcase
    end else if (is_load || is_store) begin
      // Load/Store - use addition for address calculation
      alu_control = `ALU_ADD;
    end else if (is_branch) begin
      // Branch instructions - use subtraction for comparison
      alu_control = `ALU_SUB;
    end else if (opcode == 7'b0110111) begin
      // LUI - pass immediate to output
      alu_control = `ALU_ADD;  // Will add 0 + immediate
    end else if (opcode == 7'b0010111) begin
      // AUIPC - add immediate to PC
      alu_control = `ALU_ADD;
    end else if (is_jump) begin
      // Jump instructions - no ALU operation needed
      alu_control = `ALU_ADD;  // Placeholder
    end else begin
      alu_control = `ALU_INVALID;
    end
  end

  // FSM state register
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= FETCH;
    end else begin
      current_state <= next_state;
    end
  end

  // Pass funct3 to datapath for load/store operations
  assign funct3 = func3;

  // Next state logic
  always_comb begin
    next_state = current_state;  // Default: stay in current state

    case (current_state)
      FETCH: begin
        if (i_data_valid) begin
          next_state = DECODE;
        end else begin
          next_state = STALL;
        end
      end

      STALL: begin
        if (i_data_valid) begin
          next_state = DECODE;
        end
      end

      DECODE: begin
        next_state = EXECUTE;
      end

      EXECUTE: begin
        if (is_load || is_store) begin
          next_state = MEMORY;
        end else begin
          next_state = WRITEBACK;
        end
      end

      MEMORY: begin
        if (d_data_valid) begin
          next_state = WRITEBACK;
        end else begin
          next_state = MEMORY;  // Wait for memory
        end
      end

      WRITEBACK: begin
        next_state = FETCH;
      end

      default: begin
        next_state = FETCH;
      end
    endcase
  end

  // Output logic - control signals based on current state and instruction type
  always_comb begin
    // Default values
    pc_write_enable  = 1'b0;
    reg_write_enable = 1'b0;
    pc_src           = 2'b00;  // PC+4
    alu_src_b        = 1'b0;  // rs2
    result_src       = 2'b00;  // ALU result
    mem_write        = 1'b0;

    case (current_state)
      FETCH: begin
        // No control signals asserted during fetch
      end

      DECODE: begin
        // Decode stage has no control signal changes
      end

      EXECUTE: begin
        // Set ALU source based on instruction type
        if (is_r_type) begin
          alu_src_b = 1'b0;  // Use rs2
        end else begin
          alu_src_b = 1'b1;  // Use immediate
        end
      end

      MEMORY: begin
        // For store instructions, enable memory write
        if (is_store) begin
          mem_write = 1'b1;
        end
      end

      WRITEBACK: begin
        // Update PC for all instructions
        pc_write_enable = 1'b1;

        // Select PC source
        if (is_branch) begin
          pc_src = 2'b01;  // Branch target if condition met
        end else if (is_jump) begin
          pc_src = 2'b10;  // Jump target
        end else begin
          pc_src = 2'b00;  // PC+4
        end

        // Register write enable for all except branches and stores
        if (!is_branch && !is_store) begin
          reg_write_enable = 1'b1;
        end

        // Select result source for register writeback
        if (is_load) begin
          result_src = 2'b01;  // Memory data
        end else if (is_jump) begin
          result_src = 2'b10;  // PC+4 (for return address)
        end else begin
          result_src = 2'b00;  // ALU result
        end
      end

      default: begin
        // Default values already set
      end
    endcase
  end

endmodule
