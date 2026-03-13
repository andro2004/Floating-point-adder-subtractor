module Unpack(A,B,sign_A,sign_B,exp_A,exp_B,mant_A,mant_B,
zero_A,subnormal_A,infinity_A,NaN_A,zero_B,subnormal_B,infinity_B,NaN_B);

    input [31:0] A,B;
    output sign_A,sign_B;
    output [7:0] exp_A,exp_B;
    output [0:24] mant_A,mant_B;
    output   zero_A,subnormal_A,infinity_A,NaN_A;
    output   zero_B,subnormal_B,infinity_B,NaN_B;
    
    assign sign_A = A[31];
    assign sign_B = B[31];
    assign exp_A = A[30:23];
    assign exp_B = B[30:23];
    assign mant_A = {2'b01, A[22:0]};
    assign mant_B = {2'b01, B[22:0]};
    
    wire exp_zero_A  = (A[30:23] == 8'h00);
    wire exp_max_A   = (A[30:23] == 8'hFF);
    wire mant_zero_A = (A[22:0]  == 23'b0);


    assign zero_A      = exp_zero_A & mant_zero_A;
    assign subnormal_A = exp_zero_A & ~mant_zero_A;
    assign infinity_A  = exp_max_A  & mant_zero_A;
    assign NaN_A       = exp_max_A  & ~mant_zero_A;
    
    wire exp_zero_B  = (B[30:23] == 8'h00);
    wire exp_max_B   = (B[30:23] == 8'hFF);
    wire mant_zero_B = (B[22:0]  == 23'b0);


    assign zero_B      = exp_zero_B & mant_zero_B;
    assign subnormal_B = exp_zero_B & ~mant_zero_B;
    assign infinity_B  = exp_max_B  & mant_zero_B;
    assign NaN_B       = exp_max_B  & ~mant_zero_B;


endmodule 