module baud_rate #(
    parameter s_clk = 5000000;                //System CLK
    parameter tx_max = s_clk / 9600;          //sampling for TX
    parameter rx_max = s_clk / ( 9600 * 16);  //oversampling for RX

    parameter tx_wid = $clog2(tx_max);        //find tx_max width
    parameter rx_wid = $clog2(rx_max);        //find rx_max width
);

    // PORTS DECLARATION
(
    input s_clk,                              //SYSTEM CLK
    output tx_en,                             //TRANSMIETR ENABLE
    output rx_en                              //RECEIVEUARTR ENABLE
);
    reg [tx_wid - 1 : 0] tx_count = 0;        //TRANSMITTER COUNTER
    reg [rx_wid - 1 : 0] rx_count = 0;        //RECEIVER COUNTER

    // BAUD RATE GENERATION FOR TX
    always @(posedge clk) begin
        if (tx_count == tx_max) begin         //IF CONDITION SATISFY TRANSMITTER COUNTER GO TO "0"
            tx_count <= 0;
        end else begin
            tx_count <= tx_count + 1;
        end
    end

    // BAUD RATE GENERATION FOR RX
    always @(posedge clk) begin
        if (rx_count == rx_max) begin         //SAME CONDITION FOR RECEIVER
            rx_count <= 0;
        end else begin
            rx_count <= rx_count + 1;
        end
    end

    assign tx_en = (tx_count == 0);           //WHEN TX_COUNTER "0" -> TX_EN "1"
    assign rx_en = (rx_count == 0);           //WHEN RX_COUNTER "0" -> RX_EN "1"
endmodule

//Design By MURUGAVEL
