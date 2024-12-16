package alu_types;

    // ALU operation types
    typedef enum logic [3:0] {
        ALU_AND     = 4'b0000,    // Logical AND
        ALU_OR      = 4'b0001,    // Logical OR
        ALU_XOR     = 4'b0010,    // Logical XOR
        ALU_SLT     = 4'b0011,    // Set Less Than (signed)
        ALU_SLTU    = 4'b0100,    // Set Less Than (unsigned)
        ALU_ADD     = 4'b0101,    // Addition
        ALU_SUB     = 4'b0110,    // Subtraction
        ALU_SRL     = 4'b0111,    // Logical Shift Right
        ALU_SLL     = 4'b1000,    // Logical Shift Left
        ALU_SRA     = 4'b1001,    // Arithmetic Shift Right
        ALU_NOP     = 4'b1010,    // No Operation
        ALU_INVALID = 4'b1111     // Invalid operation
    } alu_op_t;

    // Processor states
    typedef enum logic [1:0] {
        STATE_FETCH    = 2'b00,
        STATE_DECODE   = 2'b01,
        STATE_EXECUTE  = 2'b10,
        STATE_WRITEBACK= 2'b11
    } proc_state_t;

    // Other reusable constants
    parameter int DATA_WIDTH = 32;

endpackage : alu_types
