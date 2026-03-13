module MUX_4to1#(parameter DATA_WIDTH=32) (in0,in1,in2,in3,s,out);
    
    input [1:0]s;
    input [DATA_WIDTH -1:0] in0,in1,in2,in3;
    output reg [DATA_WIDTH -1:0] out;
    
    always @(*)begin
        case (s)
            2'b00:out = in0;
            2'b01:out = in1;
            2'b10:out = in2;
            2'b11:out = in3;
            default: out = in0;
        endcase
    end
    
endmodule 