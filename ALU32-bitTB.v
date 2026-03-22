module msrv32_alu_tb;

    reg [31:0] OP_1_in, OP_2_in;
    reg [3:0] Opcode_in;
    wire [31:0] result_out;

    msrv32_alu ALU (
        .OP_1_in(OP_1_in),
        .OP_2_in(OP_2_in),
        .Opcode_in(Opcode_in),
        .result_out(result_out)
    );

    integer i, j;

    // Test operands
    reg [31:0] test_ops1 [0:6];
    reg [31:0] test_ops2 [0:6];
    reg [3:0]  test_opcodes [0:8];

    initial begin
        // Enable waveform dumping
        $dumpfile("alu_waveform.vcd");
        $dumpvars(0, msrv32_alu_tb);

        // Edge case operands (signed/unsigned)
        test_ops1[0] = 32'd10;
        test_ops1[1] = 32'd100;
        test_ops1[2] = 32'd4294967295; // -1 in 2's complement
        test_ops1[3] = 32'd0;
        test_ops1[4] = 32'd2147483647; // max signed
        test_ops1[5] = 32'd2147483648; // min signed
        test_ops1[6] = 32'd50;

        test_ops2[0] = 32'd5;
        test_ops2[1] = 32'd150;
        test_ops2[2] = 32'd1;
        test_ops2[3] = 32'd0;
        test_ops2[4] = 32'd1;
        test_ops2[5] = 32'd4294967295; // -1
        test_ops2[6] = 32'd100;

        // Opcodes: ADD=0, SUB=8 (Opcode_in[3]=1), SLL=1, SLT=2, SLTU=3, XOR=4, SRL=5, OR=6, AND=7
        test_opcodes[0] = 4'b0000; // ADD
        test_opcodes[1] = 4'b1000; // SUB
        test_opcodes[2] = 4'b0001; // SLL
        test_opcodes[3] = 4'b0010; // SLT
        test_opcodes[4] = 4'b0011; // SLTU
        test_opcodes[5] = 4'b0100; // XOR
        test_opcodes[6] = 4'b0101; // SRL
        test_opcodes[7] = 4'b0110; // OR
        test_opcodes[8] = 4'b0111; // AND

        $display("=== 32-bit RISC-V ALU Test ===");

        // Loop through operands and opcodes
        for (i = 0; i < 7; i = i + 1) begin
            for (j = 0; j < 9; j = j + 1) begin
                OP_1_in = test_ops1[i];
                OP_2_in = test_ops2[i];
                Opcode_in = test_opcodes[j];
                #5; // allow combinational outputs to settle
                $display("OP1=%0d, OP2=%0d, Opcode=%b => Result=%0d", 
                         $signed(OP_1_in), $signed(OP_2_in), Opcode_in, $signed(result_out));
            end
        end

        // Pause simulation to inspect waveforms
        $stop;
    end

endmodule