`include "types.sv"
`default_nettype none
module controlUnit (
  output logic clk,
  input  logic reset, // Reset signal

  output logic [1:0] pcWrSel,
  output logic pcCtrl,

  output logic memAdrSel,
  output logic memWrCtl,

  output logic [`ALU_SEL_SIZE-1:0] aluOp,
  output logic aluASel,
  output logic [1:0] aluBSel,

  output logic regWCtl,
  output logic regDataSel,
  output logic [1:0] regWSel,

  input logic [`OPCODE_WIDTH -1 : 0] codop  // Create a type definition for this in types.sv
);


  // State and next state variables
  logic [3:0] current_state, next_state;

  // State transition logic
  always_ff @(posedge clk or posedge reset) begin
    if (reset) current_state <= `FETCH;
    else current_state <= next_state;
  end

  // Next state and output logic
  always_comb begin
    // Default outputs
    pcWrSel = 2'b00;
    pcCtrl = 0;
    memAdrSel = 0;
    memWrCtl = 0;
    aluOp = 0;
    aluASel = 0;
    aluBSel = 2'b00;
    regWCtl = 0;
    regDataSel = 0;
    regWSel = 2'b00;

    // Default next state
    next_state = current_state;

    case (current_state)
      `FETCH: begin
        pcWrSel = 2'b00;
        pcCtrl = 1;
        memAdrSel = 0;
        aluOp = `ALU_ADD;
        aluASel = 0;
        aluBSel = 2'b00;


        next_state = `DECODE;
      end

      `DECODE: begin
        aluOp   = `ALU_ADD;
        aluASel = 0;
        aluBSel = 2'b10;


        // Decode the instruction and transition based on `codop`
        case (codop)
          `OP_JMP: next_state = `JMP;  // Jump
          `OP_JMPI: next_state = `JMPI;  // Jump indirect
          `OP_ALU: next_state = `ADD_EX;  // ALU operation
          `OP_ALUI: next_state = `ADI_EX;  // ALU immediate operation
          `OP_BR: next_state = `BR;  // Branch
          `OP_LD: next_state = `LD_ST;  // Load memory
          `OP_ST: next_state = `LD_ST;  // Store memory
          default:
          next_state = `FETCH;  // Default to FETCH of the opcode is not recognized which means we just skip the instructions 
        endcase
      end


      `JMP: begin
        pcWrSel = 2'b10;
        pcCtrl = 1;

        next_state = `FETCH;
      end


      `JMPI: begin
        pcWrSel = 2'b00;
        pcCtrl = 1;

        next_state = `FETCH;
      end

      `ADD_EX: begin
        aluOp = `ALU_ADD;
        aluASel = 1;
        aluBSel = 2'b00;

        next_state = `ADD_RR;
      end

      `ADD_RR: begin
        regWCtl = 1;
        regDataSel = 1;
        regWSel = 2'b00;

        next_state = `FETCH;
      end

      `ADI_EX: begin
        aluOp = `ALU_ADD;
        aluASel = 1;
        aluBSel = 2'b00;

        next_state = `ADI_RR;
      end

      `ADI_RR: begin
        regWCtl = 1;
        regDataSel = 1;
        regWSel = 2'b01;

        next_state = `FETCH;
      end

      `BR: begin
        pcWrSel = 2'b01;
        pcCtrl = 0;
        aluOp = `ALU_CMP;
        aluASel = 1;
        aluBSel = 2'b00;

        next_state = `FETCH;
      end

      `LD_ST: begin
        aluOp   = `ALU_ADD;
        aluASel = 1;
        aluBSel = 2'b10;

        // Determine load or store based on `codop`
        case (codop)
          `OP_ST:  next_state = `ST_MEM;
          `OP_LD:  next_state = `LD_MEM;
          default: next_state = `FETCH;
        endcase

      end

      `LD_MEM: begin
        memAdrSel = 1;

        next_state = `LD_RR;
      end

      `LD_RR: begin
        regWCtl = 1;
        regDataSel = 0;
        regWSel = 2'b01;

        next_state = `FETCH;
      end

      `ST_MEM: begin
        memAdrSel = 1;
        memWrCtl = 1;

        next_state = `FETCH;
      end

      default: next_state = `FETCH;
    endcase
  end

endmodule
