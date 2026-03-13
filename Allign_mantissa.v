module Allign_mantissa(mant_A_in,mant_B_in,exp_sub,mant_A_out,mant_B_out);

    input [0:24] mant_A_in,mant_B_in;
    input [7:0] exp_sub;
    output [0:27] mant_A_out,mant_B_out;
    reg [4:0] shift_amount;
    reg [0:49] extend_B,shifted_B;
    wire stiky_bit;
    assign stiky_bit = |shifted_B[27:49];
    
    assign mant_A_out = {mant_A_in,3'b000};
    assign mant_B_out = {shifted_B[0:26],stiky_bit};

    always @(*) begin
        if (exp_sub >= 5'b10111)
            shift_amount = 5'b10111;
        else 
            shift_amount = exp_sub;
        
        extend_B = {mant_B_in,25'b0};
        shifted_B = extend_B >> shift_amount;
    end

endmodule