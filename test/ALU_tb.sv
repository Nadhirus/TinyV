`default_nettype none
`include "../src/core/types.sv"

module ALU_tb;
    // Declare inputs and outputs
    reg [31:0] a, b;
    reg [3:0] alu_sel;
    wire [31:0] result;

    // Instantiate the DUT (Design Under Test)
    ALU DUT (
        .a(a),
        .b(b),
        .alu_sel(alu_sel),
        .result(result)
    );

    // Formal assumptions
    always_comb begin
        assume(a >= 0);
        assume(b >= 0);
    end

    // Formal assertions for all ALU operations
    always_comb begin
        case (alu_sel)
            `ALU_ADD:      assert (result == a + b); 
            `ALU_SUB:      assert (result == a - b); 
            `ALU_AND:      assert (result == (a & b)); 
            `ALU_OR:       assert (result == (a | b)); 
            `ALU_XOR:      assert (result == (a ^ b)); 
            `ALU_SLT:      assert (result == ($signed(a) < $signed(b) ? 32'd1 : 32'd0)); 
            `ALU_SLTU:     assert (result == (a < b ? 32'd1 : 32'd0)); 
            `ALU_SRL:      assert (result == (a >> b[4:0])); 
            `ALU_SLL:      assert (result == (a << b[4:0])); 
            //`ALU_SRA:      assert (result == ($signed(a) >>> b[4:0])); 
            `ALU_NOP:      assert (result == 32'd0); 
            `ALU_INVALID:  assert (result == 32'hDEADBEEF); 
        endcase
    end

endmodule
