module FP_adder_sub(A,B,add_sub,S,zero_S,subnormal_S,infinity_S,NaN_S);
    
    input add_sub;
    input [31:0] A,B;
    output [31:0] S;
    output zero_S,subnormal_S,infinity_S,NaN_S;
    
    wire num_G;
    fp_mag_comparator numbers_comparator(.A(A),.B(B),.G(num_G));
    
    wire sign_A,sign_B;
    wire [7:0] exp_A,exp_B;
    wire [24:0] mant_A,mant_B;
    wire zero_A,subnormal_A,infinity_A,NaN_A,zero_B,subnormal_B,infinity_B,NaN_B;
    
    Unpack unpack(.A(A),.B(B),.sign_A(sign_A),.sign_B(sign_B),
    .exp_A(exp_A),.exp_B(exp_B),.mant_A(mant_A),.mant_B(mant_B),
    .zero_A(zero_A),.subnormal_A(subnormal_A),.infinity_A(infinity_A),.NaN_A(NaN_A),
    .zero_B(zero_B),.subnormal_B(subnormal_B),.infinity_B(infinity_B),.NaN_B(NaN_B));
    
    wire [7:0] exp_difference;
    wire exp_subtractor_sign;
    Sub#(.DATA_WIDTH(8))exponents_subtractor(.A(exp_A),.B(exp_B),.S(exp_difference),.sign(exp_subtractor_sign));
    wire [7:0]exp_mux_out;
    MUX_2to1#(.DATA_WIDTH(8))exp_mux (.in0(exp_A),.in1(exp_B),.s(exp_subtractor_sign),.out(exp_mux_out));
    wire sub,swap;
    wire [24:0] align_A,sub_B;
    selective_complement_and_swap#(.DATA_WIDTH(25)) complement_and_swap (.mant_A_in(mant_A),.mant_B_in(mant_B),.sub(sub),.swap(swap),.allign(align_A),.subtract_out(sub_B));
    wire [27:0] operand_A,operand_B;
    Allign_mantissa allign_mantissa(.mant_A_in(sub_B),.mant_B_in(align_A),.exp_sub(exp_difference),.mant_A_out(operand_A),.mant_B_out(operand_B));
    wire Cin,Cout;
    wire [27:0] added_mant;
    sm_add_sub #(.N(28)) mant_adder (.op(Cin),.A(operand_A),.B(operand_B),.R(added_mant),.overflow(Cout));
    //Add#(.DATA_WIDTH(28))mant_adder(.A(operand_B),.B(operand_A),.cin(Cin),.cout(Cout),.s(added_mant));
    wire [27:0] norm1_out;
    wire [4:0] norm1_shift_amount;
    wire norm1_zero_flag;
    Normalize norm1(.number(added_mant),.normalized(norm1_out),.shift_amount(norm1_shift_amount),.zero_flag(norm1_zero_flag));
    wire [24:0] round_out;
    Round_and_selective_complement Round(.number(norm1_out),.rounded_number(round_out));
    wire [24:0] norm2_out;
    wire norm2_zero_flag;
    wire norm2_shift_amount;
    Normalize_round norm2(.number(round_out),.normalized(norm2_out),.shift_amount(norm2_shift_amount),.zero_flag(norm2_zero_flag));
    
    wire out_sign;
    wire [7:0] out_exp;
    Control_and_sign_logic control_unit(.add_sub(add_sub),.sign_A(sign_A),.sign_B(sign_B),
    .exp_G(exp_subtractor_sign),.Cout(Cout),
    .norm1_shift_amount(norm1_shift_amount),
    .norm1_zero_flag(norm1_zero_flag),
    .norm2_zero_flag(norm2_zero_flag),.norm2_shift_amount(norm2_shift_amount),
    .swap(swap),.sub(sub),.Cin(Cin),.out_sign(out_sign),.in_exp(exp_mux_out),.out_exp(out_exp),.num_G(num_G));
    
    Pack pack(.sign(out_sign),.exp(out_exp),.mant(norm2_out),.S(S),
    .zero_A(zero_A),.subnormal_A(subnormal_A),.infinity_A(infinity_A),.NaN_A(NaN_A),
    .zero_B(zero_B),.subnormal_B(subnormal_B),.infinity_B(infinity_B),.NaN_B(NaN_B),
    .zero_S(zero_S),.subnormal_S(subnormal_S),.infinity_S(infinity_S),.NaN_S(NaN_S),
    .sign_A(sign_A),.sign_B(sign_B),.add_sub(add_sub));
endmodule
