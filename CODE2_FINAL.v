module code2_final (
    input [7:0]in,
    output  reg [2:0]first_out,
    output reg [2:0]sec_out
);
reg [7:0]temp;
  always@(*) begin
    temp = in;
    casez (in)
        8'b00000001: begin first_out =  3'd0; temp[0] = 1'b0; end
        8'b0000001z: begin first_out =  3'd1; temp[1] = 1'b0; end
        8'b000001zz: begin first_out =  3'd2; temp[2] = 1'b0; end
        8'b00001zzz: begin first_out =  3'd3; temp[3] = 1'b0; end

        8'b0001zzzz: begin first_out =  3'd4; temp[4] = 1'b0; end
        8'b001zzzzz: begin first_out =  3'd5; temp[5] = 1'b0; end
        8'b01zzzzzz: begin first_out =  3'd6; temp[6] = 1'b0; end
        8'b1zzzzzzz: begin first_out =  3'd7; temp[7] = 1'b0; end
        default : first_out = 3'dx;
    endcase

    casez (temp)
        8'b00000001: sec_out =  3'd0;
        8'b0000001z: sec_out =  3'd1;
        8'b000001zz: sec_out =  3'd2;
        8'b00001zzz: sec_out =  3'd3;

        8'b0001zzzz: sec_out =  3'd4;
        8'b001zzzzz: sec_out =  3'd5;
        8'b01zzzzzz: sec_out =  3'd6;
        8'b1zzzzzzz: sec_out =  3'd7;
        default : sec_out = 3'dx;
    endcase
  end  
endmodule

//Design by Murugavel
