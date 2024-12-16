module alu (
    input [31:0] a, b,
    input [3:0] alu_sel,
    output reg [31:0] result
);

    // Import the package
    import alu_types::*;

    // Declare ALU operation signal
    alu_op_t alu_operation;

    // Cast the alu_sel input to the custom ALU type
    always @(*) begin
        alu_operation = alu_op_t'(alu_sel);
        case (alu_operation)
            ALU_AND:     result = a & b;
            ALU_OR:      result = a | b;
            ALU_XOR:     result = a ^ b;
            ALU_SLT:     result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            ALU_SLTU:    result = (a < b) ? 32'd1 : 32'd0;
            ALU_ADD:     result = a + b;
            ALU_SUB:     result = a - b;
            ALU_SRL:     result = a >> b[4:0];
            ALU_SLL:     result = a << b[4:0];
            ALU_SRA:     result = $signed(a) >>> b[4:0];
            ALU_NOP:     result = 32'd0;
            ALU_INVALID: result = 32'hDEADBEEF;
            default:     result = 32'hDEADBEEF;
        endcase
    end

endmodule
