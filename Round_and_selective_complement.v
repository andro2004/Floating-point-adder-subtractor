module Round_and_selective_complement(number,rounded_number);
    
    input [0:27] number;
    output [0:24] rounded_number;
    wire ULP,G,R,S;
    reg round_up;

    assign  {ULP,G,R,S} = number[24:27];
    assign rounded_number = number[0:24] + {24'b0,round_up};
    always @(*)begin
        if (G == 0)
            round_up = 0;
        else begin
            case ({R,S})
                2'b00:round_up = ULP;
                2'b01:round_up = 1;
                2'b10:round_up = 1;
                2'b11:round_up = 1;
            endcase 
        end
            
    end
    
endmodule