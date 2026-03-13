module Sub#(parameter DATA_WIDTH =8)(A,B,S,sign);
    
    input [DATA_WIDTH-1:0] A,B;
    output [DATA_WIDTH-1:0] S;
    output sign;
    wire G;
    wire [DATA_WIDTH-1:0]mux1_out,mux2_out;
    assign G = (A>=B);
    MUX_2to1#(.DATA_WIDTH(DATA_WIDTH))mux1 (.in0(A),.in1(B),.s(~G),.out(mux1_out));
    MUX_2to1#(.DATA_WIDTH(DATA_WIDTH))mux2 (.in0(A),.in1(B),.s(G),.out(mux2_out));
    RCA#(.DATA_WIDTH(DATA_WIDTH)) subtractor(.A(mux1_out),.B(~mux2_out),.res(S),.Cin(1'b1));
    
    assign sign = ~G;
    
endmodule
 