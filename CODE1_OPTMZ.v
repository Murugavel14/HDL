module code1(
    input [3:0] in,
   output reg [3:0]out
);
 wire [2:0] num;
  assign num = in[0]+ in[1] + in[2] + in[3] ;

always @(*) begin
  case(num)
           3'd0 : out = 4'b0000;
           3'd1 : out = 4'b1000;
           3'd2 : out = 4'b1100;
           3'd3 : out = 4'b1110;
           3'd4 : out = 4'b1111;
           default: out = 4'b0000;
      endcase 
end 
endmodule 
