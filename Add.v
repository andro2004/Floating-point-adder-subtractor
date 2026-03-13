module Add#(parameter DATA_WIDTH = 28)(A,B,cin,cout,s);

    input [0:DATA_WIDTH-1] A,B;
    input cin;
    output [0:DATA_WIDTH-1] s;
    output cout;
    
    RCA#(.DATA_WIDTH(DATA_WIDTH)) adder(.A(A),.B(B),.res(s),.Cin(cin),.Cout(cout));
endmodule 
