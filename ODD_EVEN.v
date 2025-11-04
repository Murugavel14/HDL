
module odd_even (
    input  clk,
    input  rst_n,
    input  data_in,       
    output reg odd_chan,
    output reg even_chan
);
    reg [1:0] count;  
    output reg [3:0] out;    

    always @(posedge clk or negedge rst_n) begin
        if (rst_n) begin
            out <= 4'b0;
            count <= 0;
        end else begin
            out <= {out[2:0], data_in};
            count <= count + 1;
            
            if (count == 2'd3) begin
                count <= 0;
                if (out[0] == 1'b1) begin
                    odd_chan <= 1'b1; 
                end else if (out[0] == 1'b0) begin
                    even_chan <= 1'b0;
                end
                else begin
                    odd_chan <= 1'b0;
                    even_chan <= 1'b0;
                end
            
            end 
        end
    end
endmodule

//Design by Murugavel
