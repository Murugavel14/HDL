module final (
    input [7:0]in,
    output reg [2:0]out
);
  always@(*) begin
    casez (in)
        8'b00000001: out =  3'd0;
        8'b0000001z: out =  3'd1;
        8'b000001zz: out =  3'd2;
        8'b00001zzz: out =  3'd3;

        8'b0001zzzz: out =  3'd4;
        8'b001zzzzz: out =  3'd5;
        8'b01zzzzzz: out =  3'd6;
        8'b1zzzzzzz: out =  3'd7;
        //8'b1zzzzzzz: begin first_out =  3'd8;  = ~; end
        default : out = 3'dx;
    endcase
  end

endmodule

module final_extent (
    input [7:0]in,
    output reg [2:0] f_out,
    output reg [2:0] s_out
);
   // reg out = out; //WRAPPER BECOZ "OUT" IS A ANOTHER MODULE PORT.

    reg [7:0] temp;
    temp = in;
    final fin(.in(in), .out(f_out));    //INSTANCE_1(FIRST_OUT)
    final fin1(.in(temp), .out(s_out)); //INSTANCE_2(SEC_OUT)
    case (out);
      3'd0 : temp[0] = 1'b0;
      3'd1 : temp[1] = 1'b0;
      3'd2 : temp[2] = 1'b0;
      3'd3 : temp[3] = 1'b0;

      3'd4 : temp[4] = 1'b0;
      3'd5 : temp[5] = 1'b0;
      3'd6 : temp[6] = 1'b0;
      3'd7 : temp[7] = 1'b0;
      default : out = 3'dx;
    endcase
 

endmodule

//Design by Murugavel
