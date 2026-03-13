
module tb_FP_adder_sub;

    reg         add_sub;
    reg  [31:0] A, B;
    wire [31:0] result;          // connect to your DUT output port
    wire zero_S,subnormal_S,infinity_S,NaN_S;
    // ?? Pass/Fail counters ????????????????????????????????????
    integer pass_count;
    integer fail_count;

    // ?? DUT instantiation ?????????????????????????????????????
    FP_adder_sub dut (
        .add_sub (add_sub),
        .A       (A),
        .B       (B),
        .S  (result),
	.zero_S(zero_S),
	.subnormal_S(subnormal_S),
	.infinity_S(infinity_S),
	.NaN_S(NaN_S)       // rename to match your port
    );

    // ?? Self-checking task ????????????????????????????????????
    task run_test;
        input [31:0]  t_A, t_B;
        input         t_op;       // 0=add, 1=sub
        input [255:0] label;

        reg  [31:0] expected;
        real        a_real, b_real, exp_real;
        real        res_real;
        begin
            // Apply inputs
            A       = t_A;
            B       = t_B;
            add_sub = t_op;
            #10;

            // Compute expected using real arithmetic
            a_real   = $bitstoshortreal(t_A);
            b_real   = $bitstoshortreal(t_B);
            exp_real = t_op ? (a_real - b_real) : (a_real + b_real);
            expected = $shortrealtobits(exp_real);
            res_real = $bitstoshortreal(result);

            // Display test info
            $display("------------------------------------------------------");
            $display(" Test : %s", label);
            $display(" Op   : %s", t_op ? "SUBTRACT (A - B)" : "ADD     (A + B)");
            $display(" A    : %b  (%f)", t_A, a_real);
            $display(" B    : %b  (%f)", t_B, b_real);
            $display(" Got  : %b  (%f)", result,   res_real);
            $display(" Exp  : %b  (%f)", expected, exp_real);

            // Compare and count
            if (result === expected) begin
                $display(" >>> PASS");
                pass_count = pass_count + 1;
            end else begin
                $display(" >>> FAIL  (bit mismatch)");
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("======================================================");
        $display("       FP Adder/Subtractor ? Self-Checking TB         ");
        $display("======================================================");

        // ?? ADDITION TESTS (add_sub = 0) ??????????????????????

        run_test(
            32'b11000010011000011101000101000001,  // -56.41...
            32'b01000000011000000000000000000000,  //  +3.5
            1'b0, "Test 01 | -56.41 + 3.5");

        run_test(
            32'b11000000011000000000000000000000,  //  -3.5
            32'b01000010011000011101000101000001,  // +56.41...
            1'b0, "Test 02 | -3.5 + 56.41");

        run_test(
            32'b01000010000101100011111100111010,  // +33.56...
            32'b01000010011000011101000101000001,  // +56.41...
            1'b0, "Test 03 | +33.56 + 56.41");

        run_test(
            32'b11000010000101100011111100111010,  // -33.56...
            32'b11000010011000011101000101000001,  // -56.41...
            1'b0, "Test 04 | -33.56 + (-56.41)");

        run_test(
            32'b01000010000101100011111100111010,  // +33.56...
            32'b11000010011000011101000101000001,  // -56.41...
            1'b0, "Test 05 | +33.56 + (-56.41)");

        run_test(
            32'b01000010110011101110110011000000,  // +103.46...
            32'b11000010011000011101000101000001,  // -56.41...
            1'b0, "Test 06 | +103.46 + (-56.41)");
	run_test(
            32'b01111111100000000000000000000000,  // inf
            32'b01111111100000000000000000000000,  // inf
            1'b0, "Test 13 | -103.46 - (-56.41)");
        run_test(
            32'b11111111100000000000000000000000,  // -inf
            32'b01111111110000000000000000000000,  // NaN
            1'b0, "Test 13 | -103.46 - (-56.41)");
        run_test(
            32'b01111111110000000000000000000000,  // NaN.
            32'b01000010011000011101000101000001,  // -56.41...
            1'b0, "Test 13 | -103.46 - (-56.41)");
	run_test(
            32'b01111111100000000000000000000000,  // inf.
            32'b01000010011000011101000101000001,  // -56.41...
            1'b0, "Test 13 | -103.46 - (-56.41)");

        // ?? SUBTRACTION TESTS (add_sub = 1) ???????????????????

        run_test(
            32'b01000010110011101110110011000000,  // +103.46...
            32'b01000010011000011101000101000001,  //  +56.41...
            1'b1, "Test 07 | +103.46 - (+56.41)");

        run_test(
            32'b01000000011000000000000000000000,  //  +3.5
            32'b01000010011000011101000101000001,  // +56.41...
            1'b1, "Test 08 | +3.5 - (+56.41)");

        run_test(
            32'b01000000011000000000000000000000,  //  +3.5
            32'b11000010011000011101000101000001,  // -56.41...
            1'b1, "Test 09 | +3.5 - (-56.41)");

        run_test(
            32'b11000000011000000000000000000000,  //  -3.5
            32'b01000010011000011101000101000001,  // +56.41...
            1'b1, "Test 10 | -3.5 - (+56.41)");

        run_test(
            32'b11000000011000000000000000000000,  //  -3.5
            32'b11000010011000011101000101000001,  // -56.41...
            1'b1, "Test 11 | -3.5 - (-56.41)");

        run_test(
            32'b01000010110011101110110011000000,  // +103.46...
            32'b11000010011000011101000101000001,  // -56.41...
            1'b1, "Test 12 | +103.46 - (-56.41)");

        run_test(
            32'b11000010110011101110110011000000,  // -103.46...
            32'b11000010011000011101000101000001,  // -56.41...
            1'b1, "Test 13 | -103.46 - (-56.41)");
	
        run_test(
            32'b11111111100000000000000000000000,  // -inf
            32'b01111111110000000000000000000000,  // NaN
            1'b1, "Test 13 | -103.46 - (-56.41)");
        run_test(
            32'b01111111110000000000000000000000,  // NaN.
            32'b01000010011000011101000101000001,  // -56.41...
            1'b1, "Test 13 | -103.46 - (-56.41)");
	run_test(
            32'b01111111100000000000000000000000,  // inf.
            32'b01000010011000011101000101000001,  // -56.41...
            1'b1, "Test 13 | -103.46 - (-56.41)");


        // ?? Final Summary ??????????????????????????????????????
        $display("======================================================");
        $display("                   SUMMARY                           ");
        $display("======================================================");
        $display(" Total  Tests  : %0d", pass_count + fail_count);
        $display(" Passed        : %0d", pass_count);
        $display(" Failed        : %0d", fail_count);
        $display("======================================================");
        $finish;
    end

endmodule