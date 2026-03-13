module Normalize_round(number,normalized,shift_amount,zero_flag);
    
    input [0:24] number;
    output reg [0:24] normalized;
    output reg shift_amount;
    output zero_flag;
    
    assign zero_flag = ~(|number);
    always@(*)begin
        if(number[0] == 1)begin
            normalized = number >>1;
            shift_amount=1;
        end
        else
        begin
            normalized = number;
            shift_amount=0;
        end
    end
    
    
endmodule