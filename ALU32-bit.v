module msrv32_alu(
    input  [31:0] OP_1_in,
    input  [31:0] OP_2_in,
    input  [3:0]  Opcode_in,    // [3] distinguishes ADD/SUB
    output reg [31:0] result_out
);

    // Signed operands for SLT
    wire signed [31:0] signed_OP1 = OP_1_in;
    wire signed [31:0] signed_OP2 = OP_2_in;

    // ADD/SUB
    wire [31:0] adder_OP2 = (Opcode_in[3] == 1'b1) ? (~OP_2_in + 1) : OP_2_in;

    // Shifts (mask to 5 bits for 32-bit width)
    wire [31:0] SLL_result = OP_1_in << OP_2_in[4:0];
    wire [31:0] SRL_result = OP_1_in >> OP_2_in[4:0];

    // Set-less-than
    wire SLT_result  = (signed_OP1 < signed_OP2);
    wire SLTU_result = (OP_1_in < OP_2_in);

    // Combinational ALU
    always @* begin
        case(Opcode_in[2:0])
            3'b000: result_out = OP_1_in + adder_OP2;       // ADD/SUB
            3'b001: result_out = SLL_result;                // SLL
            3'b010: result_out = SLT_result ? 32'd1 : 32'd0; // SLT
            3'b011: result_out = SLTU_result ? 32'd1 : 32'd0; // SLTU
            3'b100: result_out = OP_1_in ^ OP_2_in;        // XOR
            3'b101: result_out = SRL_result;               // SRL
            3'b110: result_out = OP_1_in | OP_2_in;       // OR
            3'b111: result_out = OP_1_in & OP_2_in;       // AND
            default: result_out = 32'd0;
        endcase
    end

endmodule