//  ---------          ----------          ---------          ---------  
// | TX_IDLE | ---->> | TX_START | ---->> | TX_DATA | ---->> | TX_STOP |
//  ---------          ----------          ---------          ---------

module transmitter (
    input [7:0] data,               //ACTUAL DATA
    input       s_clk,              //CLK
    input       clken,              //CLK_ENABLE  (BAUD RATE GENERATE -> tx_en pin)
    input       tx_en,              //TX_EN
    output      tx_busy,            //BUSY FOR PERFORMING TRANSMITTING
    output reg   tx                 //ACTUAL DATA OUT PIN
);
    parameter tx_idle  = 2'b00;
    parameter tx_start = 2'b01;
    parameter tx_data  = 2'b10;
    parameter tx_stop  = 2'b11;

    parameter wid = $clog2(data);   //FIND WIDTH FOR BIT POSITION COUNTING

    reg [7:0] temp = 0;             //TEMPORARY DATA STORAGE
    reg [wid - 1 : 0] bit_pos = 0;  //BIT POSITION
    reg [1:0] state = tx_idle;      

    always @(posedge s_clk) begin
        // if (!tx_en) begin
        //     bit_pos <= 0;
        //     tx = 1'b0;
        // end
        //else begin
            case (state)
                tx_idle: 
                begin
                    if (!tx_en) begin
                        bit_pos <= 0;
                        temp <= data;
                        state <= tx_idle;
                    end
                end
                tx_start:
                begin
                    if(clken) begin
                        tx    <= 1'b0;              //FRAME START
                        state <= tx_data;
                    end
                end
                tx_data: begin
                    if (clken) begin
                        tx      <= temp[bit_pos];   //INPUT STREAM THROUGH TX PIN 
                        bit_pos <= bit_pos + 1;     //BIT POSITION COUNTING FOR LAST BIT STREAM
                        if (bit_pos == 7) begin
                            state   <= tx_stop;
                            //bit_pos <= 0;
                        end
                    end
                end
                tx_stop: begin
                    if (clken) begin
                        state <= tx_idle;
                        tx    <= 1'b1;              //FRAME STOP
                    end
                end
                default: begin
                    tx    <= 1'b1;
                    state <= tx_idle;
                end
            endcase
        end
    //end
    assign  tx_busy = (state != tx_idle);           //IT'S INDICADITING TX PIN HAS BUSY...
endmodule

//Design By MURUGAVEL
