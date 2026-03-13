module Normalize(number,normalized,shift_amount,zero_flag);
    
    input [0:27] number;
    output [0:27] normalized;
    output [4:0]shift_amount;
    output zero_flag;
    wire [27:0] unsigned_mant;
    LZC_28_bit lzc(.number(number),.z(shift_amount),.a(zero_flag));
    
    assign unsigned_mant = number<<shift_amount;
    assign normalized = {1'b0,unsigned_mant>>1};
    
    
endmodule


module LZC(number,z,a);
    
    input [3:0] number;
    output reg [1:0] z;
    output a;
    
    assign a = ~(|number);
    
    always @(*)begin
        
        casex (number)
            4'b1xxx:z=2'b00;
            4'b01xx:z=2'b01;
            4'b001x:z=2'b10;
            4'b0001:z=2'b11;
            default:z=2'b00;
        endcase
    end
endmodule
module LZE(a,q);
    
    input [3:0] a;
    output reg [1:0] q;
    
    always @(*)begin
        casex (a)
            4'b0xxx:q=2'b00;
            4'b10xx:q=2'b01;
            4'b110x:q=2'b10;
            4'b1110:q=2'b11;
            default:q=2'b00;
        endcase
    end
endmodule

module LZC_16_bit(number,z,a);

    input [15:0]number;
    output [3:0] z;
    output a;
    
    assign a = ~(|number);
    
    wire [3:0]LZC_a;
    wire [7:0]LZC_z;
    LZC lzc0(.number(number[15:12]),.z(LZC_z[7:6]),.a(LZC_a[3]));
    LZC lzc1(.number(number[11:8]),.z(LZC_z[5:4]),.a(LZC_a[2]));
    LZC lzc2(.number(number[7:4]),.z(LZC_z[3:2]),.a(LZC_a[1]));
    LZC lzc3(.number(number[3:0]),.z(LZC_z[1:0]),.a(LZC_a[0]));
    LZE lze(.a(LZC_a),.q(z[3:2]));
    MUX_4to1 #(.DATA_WIDTH(2)) MUX(.in0(LZC_z[7:6]),.in1(LZC_z[5:4]),.in2(LZC_z[3:2]),.in3(LZC_z[1:0]),.s(z[3:2]),.out(z[1:0]));
endmodule

module LZC_28_bit(number,z,a);

    input [27:0]number;
    output [4:0] z;
    output a;
    
    assign a = ~(|number);
    
    wire [3:0]LZC_a;
    wire [5:0]LZC_z_left;
    wire [3:0]LZC_z_right;
    wire [3:0]left_q;
    wire [4:0]right_and_left_q;
    LZC lzc0(.number(number[27:24]),.z(LZC_z_left[5:4]),.a(LZC_a[3]));
    LZC lzc1(.number(number[23:20]),.z(LZC_z_left[3:2]),.a(LZC_a[2]));
    LZC lzc2(.number(number[19:16]),.z(LZC_z_left[1:0]),.a(LZC_a[1]));
    LZC_16_bit lzc3(.number(number[15:0]),.z(LZC_z_right[3:0]),.a(LZC_a[0]));
    LZE lze(.a(LZC_a),.q(left_q[3:2]));
    MUX_4to1 #(.DATA_WIDTH(2)) Left_z_mux(.in0(LZC_z_left[5:4]),.in1(LZC_z_left[3:2]),.in2(LZC_z_left[1:0]),.in3(2'b00),.s(left_q[3:2]),.out(left_q[1:0]));
    assign right_and_left_q = left_q + LZC_z_right;
    MUX_2to1#(.DATA_WIDTH(5))final_mux (.in0({1'b0,left_q}),.in1(right_and_left_q),.s(&left_q[3:2]),.out(z));
endmodule 