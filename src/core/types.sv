// ALU operation types
`define ALU_SEL_SIZE 4
`define ALU_AND 4'b0000    // Logical AND
`define ALU_OR 4'b0001    // Logical OR
`define ALU_XOR 4'b0010    // Logical XOR
`define ALU_SLT 4'b0011    // Set Less Than (signed)
`define ALU_SLTU 4'b0100    // Set Less Than (unsigned)
`define ALU_ADD 4'b0101    // Addition
`define ALU_SUB 4'b0110    // Subtraction
`define ALU_SRL 4'b0111    // Logical Shift Right
`define ALU_SLL 4'b1000    // Logical Shift Left
`define ALU_SRA 4'b1001    // Arithmetic Shift Right
`define ALU_CMP 4'b1010    // compare operation for branching 
`define ALU_NOP 4'b1011    // No Operation
`define ALU_INVALID 4'b1111    // Invalid operation

// Control FSM states
`define FETCH 4'b0000  // Fetch instruction
`define DECODE 4'b0001  // Decode instruction
`define JMP 4'b0010  // Jump
`define JMPI 4'b0011  // Jump indirect
`define ADD_EX 4'b0100  // Execute addition
`define ADD_RR 4'b0101  // Register write-back for addition
`define ADI_EX 4'b0110  // Execute addition immediate
`define ADI_RR 4'b0111  // Register write-back for addition immediate
`define BR 4'b1000  // Branch
`define LD_ST 4'b1001  // Load/store decision
`define LD_MEM 4'b1010  // Memory read for load
`define LD_RR 4'b1011  // Register write-back for load
`define ST_MEM 4'b1100  // Memory write for store

// Opcodes for the FSM states
`define OP_JMP 7'b1101111  // JAL (Jump and Link)
`define OP_JMPI 7'b1100111  // JALR (Jump and Link Register)
`define OP_LD 7'b0000011  // Load (LB, LH, LW)
`define OP_ST 7'b0100011  // Store (SB, SH, SW)
`define OP_ALU 7'b0110011  // R-type ALU operations (ADD, SUB, etc.)
`define OP_ALUI 7'b0010011  // I-type ALU operations (ADDI, ANDI, ORI, etc.)
`define OP_BR 7'b1100011  // Branch instructions (BEQ, BNE, BLT, etc.)

// Other reusable constants to configure various aspects of the processor
`define DATA_WIDTH 32
`define DMEM_ADDR_WIDTH 10
`define IMEM_ADDR_WIDTH 10
`define MEM_ADDR_WIDTH 10
`define REG_ADDR_WIDTH 5


`define OPCODE_WIDTH 7
