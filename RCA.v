
module full_adder(A,B,Cin,Cout,s);
    input A,B,Cin;
    output Cout,s;
    assign s= A^B^Cin;
    assign Cout = (A&B)|(A&Cin)|(B&Cin);
endmodule

module RCA#(parameter DATA_WIDTH = 32)(A,B,Cin,Cout,res);
    input [DATA_WIDTH-1:0] A,B;
    input Cin;
    output [DATA_WIDTH-1:0] res;
    output Cout;
	wire [DATA_WIDTH:0] cin;

	assign cin[0] = Cin;
	assign Cout = cin[DATA_WIDTH];
	generate
	   genvar i;
	   for(i=0;i<DATA_WIDTH;i = i+1)
	   begin: stage
	       full_adder FA (A[i],B[i],cin[i],cin[i+1],res[i]);
	   end
	   endgenerate
endmodule

