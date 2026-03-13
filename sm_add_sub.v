
// Sign-Magnitude Adder/Subtractor
// Parameter N: total bit-width including sign (default 8)
// Inputs:
//   op      - 0 = Add (A + B), 1 = Subtract (A - B)
//   sign_a  - sign of A
//   mag_a   - magnitude of A  (N-1 bits)
//   sign_b  - sign of B
//   mag_b   - magnitude of B  (N-1 bits)
// Outputs:
//   sign_r  - sign of result
//   mag_r   - magnitude of result (N bits, extra bit for overflow)
//   overflow- result exceeded (N-1)-bit magnitude range

module sm_add_sub #(
    parameter N = 28                  // total width (1 sign + N-1 magnitude)
)(
    input  wire            op,       // 0 = add, 1 = subtract
    input  wire [N-1:0]   A,
    input  wire [N-1:0]   B,
    output   [N-1:0]   R,
    output reg             overflow
);
    
    wire sign_a,sign_b;
    reg sign_r;
    wire [N-2:0] mag_a,mag_b;
    reg[N-2:0] mag_r;
    
    assign sign_a = A[N-1];
    assign sign_b = B[N-1];
    assign R[N-1] =overflow ;
    assign mag_a = A[N-2:0];
    assign mag_b = B[N-2:0];
    assign R[N-2:0] =mag_r ;
    
    // Effective sign of B after applying the operation
    // Subtraction flips B's sign: A - B = A + (-B)
    wire eff_sign_b = sign_b ^ op;

    // Extended magnitudes to N bits to catch carry
    wire [N-1:0] ext_a = {1'b0, mag_a};
    wire [N-1:0] ext_b = {1'b0, mag_b};

    // Comparison
    wire a_gte_b = (ext_a >= ext_b);
    reg [N-1:0] sum;
    always @(*) begin
        overflow = 1'b0;

        if (sign_a == eff_sign_b) begin
            // -----------------------------------------------
            // Same effective sign → ADD magnitudes
            // Result sign = sign of A (same as B)
            // -----------------------------------------------
            
            sum     = ext_a + ext_b;
            sign_r  = sign_a;
            mag_r   = sum[N-2:0];
            overflow= sum[N-1];      // carry out = overflow
        end
        else begin
            // -----------------------------------------------
            // Different effective signs → SUBTRACT magnitudes
            // Result sign follows the larger magnitude
            // -----------------------------------------------
            if (a_gte_b) begin
                mag_r  = (ext_a - ext_b);
                sign_r = (mag_r == 0) ? 1'b0 : sign_a; // +0 not -0
            end
            else begin
                mag_r  = (ext_b - ext_a);
                sign_r = (mag_r == 0) ? 1'b0 : eff_sign_b;
            end
        end
    end

endmodule

