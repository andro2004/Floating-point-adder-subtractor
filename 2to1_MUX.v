module MUX_2to1#(parameter DATA_WIDTH=32) (in0,in1,s,out);
    
    input s;
    input [DATA_WIDTH -1:0] in0,in1;
    output reg [DATA_WIDTH -1:0] out;
    
    always @(*)begin
        if(s==0)
            out = in0;
        else
            out = in1;
    end
    
endmodule 