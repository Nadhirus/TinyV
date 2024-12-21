// ALU operation types
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
`define ALU_NOP 4'b1010    // No Operation
`define ALU_INVALID 4'b1111    // Invalid operation

// Processor states
`define STATE_FETCH 2'b00
`define STATE_DECODE 2'b01
`define STATE_EXECUTE 2'b10
`define STATE_WRITEBACK 2'b11

// Other reusable constants to configure various aspects of the processor
`define DATA_WIDTH 32
`define DMEM_ADDR_WIDTH 10
`define IMEM_ADDR_WIDTH 10
`define IMEM_ADDR_WIDTH 10
`define REG_ADDR_WIDTH 4

`define opALU_WIDTH 6