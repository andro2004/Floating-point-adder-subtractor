module Control_and_sign_logic(add_sub,sign_A,sign_B,exp_G,Cout,norm1_shift_amount,
norm1_zero_flag,norm2_zero_flag,norm2_shift_amount,
swap,sub,Cin,out_sign,in_exp,out_exp,num_G);

    input add_sub;
    input sign_A,sign_B,exp_G,Cout;
    input [4:0]norm1_shift_amount;
    input norm2_shift_amount;
    input [7:0] in_exp;
    input norm1_zero_flag,norm2_zero_flag;
    output swap,sub,Cin;
    output reg out_sign;
    output reg [7:0] out_exp;
    input num_G;
    /*
    swap done
    sub done
    Cin done
    out_sign 
    round 
    out_exp done
    */
    assign swap = ~exp_G;
    assign sub = sign_A^sign_B^add_sub;
    assign Cin = sub;
    
    reg[7:0] norm1_shift;
    
    always @(*)begin
        norm1_shift = 8'b00000000;
        if (norm1_zero_flag == 1'b0)
            norm1_shift = in_exp - norm1_shift_amount + 8'b00000001;
        else
            norm1_shift = in_exp;
            
        out_exp = norm1_shift + {7'b0,norm2_shift_amount};
        
       case({sign_A,sign_B,add_sub})
           3'b000: out_sign = 1'b0;//
           3'b001: out_sign = ~num_G;//
           3'b010: out_sign = ~num_G;//
           3'b011: out_sign = 1'b0;//
           3'b100: out_sign = num_G;//
           3'b101: out_sign = 1'b1;//
           3'b110: out_sign = 1'b1;//
           3'b111: out_sign = num_G;//
       endcase
    end
endmodule
