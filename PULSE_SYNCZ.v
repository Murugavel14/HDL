module pulse_syncz (
    input signal_a,                 //DOMAIN_A INPUT SIGNAL
    input clk_a, arstn_a,           //DOMAIN_A CLOCK AND RESET SIGNAL
    input clk_b, arstn_b,           //DOMAIN_B CLOCK AND RESET SIGNAL
    output out                      //OUTPUT IN DOMAIN_B
);
    reg d_in, d_meta, d_out;       
    reg ff_a;                       //DOMAIN_A FLIP-FLOP (INPUT)
    always@(posedge clk_a or negedge arstn_a) begin
        if (!arstn_a) begin
            ff_a <= 1'b0;
        end
        else begin
            ff_a <= signal_a;
        end
    end

    always@(posedge clk_b or negedge arstn_b) begin
        if (!arstn_b) begin
           d_out  <= 1'b0;
           d_in   <= 1'b0;
           d_meta <= 1'b0;

        end
        else begin
            d_in   <= ff_a;
            d_meta <= d_in;
            d_out  <= d_meta;
        end
    end

    assign out = (~d_out)&(d_meta);     //ACTUAL OUTPUT OF THE SYNCHRONIZER
    
endmodule


//Design By MURUGAVEL
