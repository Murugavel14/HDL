module receiver 
#(
    parameter rx_start = 2'b00;
    parameter rx_data = 2'b01;
    parameter rx_stop = 2'b10;

    reg [1:0] state = rx_start;
    reg [7:0] temp = 0;
    reg [2:0] rx_count = 0;
    reg [3:0] sample;

);

    // PORTS    |
(
    input rx,
    input s_clk,
    input clken,
    input rx_en,
    input ready_clr,
    output reg ready,
    output reg [7:0] data
);
    // reg flag;
    always @(posedge s_clk ) begin
        if (ready_clr) begin
            ready <= 1'b1;
        end
        // rx <= 8'hf;
        if (clken && ~rx_en) begin
        case (state)
            rx_start: begin
                if (!rx_en || sample != 0) begin
                    // rx <= 8'd0;
                    // state <= rx_data;
                    sample <= sample + 1;
                    if (smaple == 15) begin
                        state <= rx_data;
                        rx_count <= 0;
                        sample <= 0;
                        temp <= 0;
                    end
                end
            end
            rx_data: begin
                sample <= sample + 1;
                if (sample == 8) begin
                    temp[rx_count[2:0]] <= rx; //**important**
                    rx_count <= rx_count + 1;
                end
                    // if (flag) begin
                    //     rx <= temp;
                    // end
                    if (rx_count == 8 && rx_count == 15) begin
                        state <= rx_stop;
                    end
                end
            rx_stop:
                if (sample == 15 || (sample >= 8 && !rx)) begin
                    state <= rx_start
                    data <= temp;
                    ready <= 1'b1;
                    sample = 0;
                end
                else sample <= sample + 1;
            default: begin

                state <= rx_start;
                rx <= 1'b1;
            end
        endcase
    end
    end
endmodule
