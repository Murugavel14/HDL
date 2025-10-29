module code_2 (
    input  [7:0] in,
    output reg [2:0] high_out,
    output reg [1:0] low_out
);

wire [3:0] in1 = in[7:4];
wire [3:0] in2 = in[3:0];

always @(*) begin
    casez (in1)
        4'b1???: high_out = 3'd7; 
        4'b01??: high_out = 3'd6; 
        4'b001?: high_out = 3'd5;
        4'b0001: high_out = 3'd4; 
        default: high_out = 3'dx; 
    endcase
end

always @(*) begin
    casez (in2)
        4'b1???: low_out = 2'd3; 
        4'b01??: low_out = 2'd2; 
        4'b001?: low_out = 2'd1; 
        4'b0001: low_out = 2'd0; 
        default: low_out = 2'dx; 
    endcase
end

endmodule

//Design by Murugavel
