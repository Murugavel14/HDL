module find (
    input  [7:0] in,
    output reg [2:0] high1_out,
    output reg [2:0] high2_out
);
    integer i;
    integer count;

    always @(*) begin
        high1_out = 3'd0;
        high2_out = 3'd0;
        count = 0;
        for (i=7; i >= 0;i = i -1) begin
            if(in[i]) begin
                count = count + 1;
                if(count == 1) begin
                high1_out = i[2:0];
                end
                else if (count == 2) begin
                    high2_out = i[2:0];
                end
            end
        end
    end
endmodule

//Prompt by AI
