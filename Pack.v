module Pack(sign,exp,mant,S,add_sub,
sign_A,zero_A,subnormal_A,infinity_A,NaN_A,sign_B,zero_B,subnormal_B,infinity_B,NaN_B,
zero_S,subnormal_S,infinity_S,NaN_S);
    
    input sign,add_sub;
    input [7:0] exp;
    input [0:24] mant;
    
    output reg[31:0] S;
    input sign_A,zero_A,subnormal_A,infinity_A,NaN_A,sign_B,zero_B,subnormal_B,infinity_B,NaN_B;
    output zero_S,subnormal_S,infinity_S,NaN_S;
    
    wire exp_zero_S  = (S[30:23] == 8'h00);
    wire exp_max_S   = (S[30:23] == 8'hFF);
    wire mant_zero_S = (S[22:0]  == 23'b0);

    
    assign zero_S      = exp_zero_S & mant_zero_S;
    assign subnormal_S = exp_zero_S & ~mant_zero_S;
    assign infinity_S  = exp_max_S  & mant_zero_S;
    assign NaN_S       = exp_max_S  & ~mant_zero_S;
    
    always @(*)begin
        S = 32'b0;
        casex ({zero_A,subnormal_A,infinity_A,NaN_A,zero_B,subnormal_B,infinity_B,NaN_B})
        8'bx000x000: S = {sign,exp,mant[2:24]};
        8'b10001000: S = 32'b0;//zero,zero-->zero
        8'b0001xxxx: S = 32'b01111111110000000000000000000000;//NaN,anything-->NaN
        8'bxxxx0001: S = 32'b01111111110000000000000000000000;//anything,NaN -->NaN
        8'b00100010: //infinity,infinity-->infinity 
        begin
            case({add_sub,sign_A,sign_B})
                3'b000:S = 32'b01111111100000000000000000000000;
                3'b001:S = 32'b01111111110000000000000000000000;
                3'b010:S = 32'b01111111110000000000000000000000;
                3'b011:S = 32'b11111111100000000000000000000000;
                
                3'b100:S = 32'b01111111110000000000000000000000;
                3'b101:S = 32'b01111111100000000000000000000000;
                3'b110:S = 32'b11111111100000000000000000000000;
                3'b111:S = 32'b01111111110000000000000000000000;
            endcase     
        end
        8'b0010xxx0: S = {sign_A,31'b1111111100000000000000000000000};//infinity,number or zero-->infinity
        8'bxxx00010: S = {sign_B,31'b1111111100000000000000000000000};//number or zero,infinity-->infinity
        8'b01001000: S = 32'b0;//subnormal,zero-->
        8'b10000100: S = 32'b0;//zero,subnormal-->
        8'b01000100: S = 32'b0;//subnormal,subnormal-->
        endcase 
        
        
    end
endmodule