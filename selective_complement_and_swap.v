module selective_complement_and_swap#(parameter DATA_WIDTH =25) (mant_A_in,mant_B_in,sub,swap,allign,subtract_out);
    
    input [0:DATA_WIDTH-1] mant_A_in,mant_B_in;
    input sub,swap;
    output [0:DATA_WIDTH-1] allign,subtract_out;
    wire [0:DATA_WIDTH-1]mux1_out,mux2_out;
    MUX_2to1#(.DATA_WIDTH(DATA_WIDTH))mux1 (.in0(mant_A_in),.in1(mant_B_in),.s(~swap),.out(mux1_out));
    MUX_2to1#(.DATA_WIDTH(DATA_WIDTH))mux2 (.in0(mant_A_in),.in1(mant_B_in),.s(swap),.out(mux2_out));
    
    assign subtract_out = mux1_out;
    assign allign = mux2_out;
endmodule