// Opcode definitions for instruction decoding
`define LUI      7'b0110111  // Load Upper Immediate
`define AUIPC    7'b0010111  // Add Upper Immediate to PC
`define JAL      7'b1101111  // Jump and Link
`define JALR     7'b1100111  // Jump and Link Register
`define BRANCH   7'b1100011  // Branch instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
`define LOAD     7'b0000011  // Load instructions (LB, LH, LW, LBU, LHU)
`define STORE    7'b0100011  // Store instructions (SB, SH, SW)
`define ALUI     7'b0010011  // Immediate ALU operations (ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI)
`define ALU      7'b0110011  // Register-register ALU operations (ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND)
`define FENCE    7'b0001111  // Fence instructions
`define SYSTEM   7'b1110011  // System instructions (ECALL, EBREAK, etc.)

// func3 of ALU operation types 
`define func3_ADD 3'b000    // Addition
`define func3_SLT 3'b010    // Set Less Than (signed)
`define func3_SLTU 3'b011    // Set Less Than (unsigned)
`define func3_XOR 3'b100    // Logical XOR
`define func3_OR 3'b110    // Logical OR
`define func3_AND 3'b111    // Logical AND
`define func3_SLL 3'b001    // Logical Shift Left
`define func3_SR 3'b101    // Shift Right



// Other reusable constants to configure various aspects of the processor
`define DATA_WIDTH 32
`define DMEM_ADDR_WIDTH 10
`define IMEM_ADDR_WIDTH 10
`define MEM_ADDR_WIDTH 10
`define REG_ADDR_WIDTH 5


`define OPCODE_WIDTH 7
