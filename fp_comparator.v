// =============================================================
// IEEE 754 Single-Precision Floating Point Magnitude Comparator
// Ignores sign bit - compares |A| vs |B|
//
// Output G = 1  if  |A| >= |B|
//        G = 0  if  |A|  < |B|
//
// Special cases: NaN → G=0, ±Inf handled correctly
// =============================================================

module fp_mag_comparator (
    input  wire [31:0] A,
    input  wire [31:0] B,
    output reg         G    // 1 = |A| >= |B|, 0 = |A| < |B|
);

    // ── Strip sign bit (take absolute value) ──────────────────
    wire [30:0] mag_a = A[30:0];
    wire [30:0] mag_b = B[30:0];

    // ── Unpack for special case detection ─────────────────────
    wire [7:0]  exp_a  = A[30:23];
    wire [22:0] mant_a = A[22:0];
    wire [7:0]  exp_b  = B[30:23];
    wire [22:0] mant_b = B[22:0];

    wire is_nan_a = (exp_a == 8'hFF) && (mant_a != 23'd0);
    wire is_nan_b = (exp_b == 8'hFF) && (mant_b != 23'd0);

    always @(*) begin
        if (is_nan_a || is_nan_b)
            G = 1'b0;               // NaN comparisons undefined → 0
        else
            G = (mag_a >= mag_b);   // simple unsigned compare of [30:0]
    end

endmodule