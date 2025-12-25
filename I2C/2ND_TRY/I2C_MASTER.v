    ______     _______     _____________     __________     __________     __________     ______
  ->|IDLE| --> |START| --> |ADDRESS_FSM| --> |ADDR_ACK| --> |DATA_FSM| --> |DATA_ACK| --> |STOP| --v
  | ------     -------     -------------     ----------     ----------     ----------     ------   |
  |                                                                                                |
  ----------------------------------------------------------------------------------------------- <-
module i2c 
(
    input  clk,
    input  rst_n,
    input  start_bit,
    input  [6:0]addr,   //ADDRESSS
    input  [7:0]data,   //INPUT DATA
    input  rd_wr_en,    //READ AND WRITE ENABLE
    input  stop_bit,
    output reg scl,     //SERIAL CLK
    inout  sda          //SERIAL DATA
);

#(
    parameter idle         = 3'd0;
    parameter start        = 3'd0;
    parameter addr_fsm     = 3'd0;
    parameter rd_wr_fsm    = 3'd0;
    parameter adr_ack_fsm  = 3'd0;
    parameter data_fsm     = 3'd0;
    parameter data_ack_fsm = 3'd0;
    parameter stop         = 3'd0;
) 

    reg [7:0] addr_temp  = 0;
    reg [7:0] data_temp  = 0;
    reg [2:0] addr_count = 3'd7;
    reg [2:0] data_count = 3'd0;
    reg [2:0] state      = idle;
    reg sda_en;   //FOR SDA INOUT PORT
    reg sda_out;  //MASKING SDA OUTPUT
    
   

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sda_en <= 1'b0;
        end
        else begin
            case (state)
                idle: begin 
                    if (start_bit) begin
                        state <= start; 
                        sda_en <= 1'b1;
                    end
                    else begin
                        state <= idle;
                        sda_en <= 1'b0;
                    end
                end
                start: begin                //FRAME START CONDITION
                    if (start_bit & ~s(top_bit)) begin  
                        sda_en    <= 1'b1;
                        sda_out   <= 1'b0;
                        addr_temp <= {addr,rd_wr_en};
                        data_temp <= data;
                        state     <= addr_fsm;
                    end
                    else begin
                        state  <= idle;
                        sda_en <= 1'b0;
                    end
                end
                addr_fsm: begin
                    if (!rd_wr_en & addr_count != 0) begin //| (start_bit & stop_bit)) begin
                        addr_count <= addr_count - 1;
                        sda_out <= addr_temp[addr_count]; //PARALLEL TO SERIAL TRANSFORMAION FOR ADDRESS
                    end
                    else begin
                        if (addr_count == 0) begin
                            addr_count <= 3'd7;
                            state <= addr_ack;
                        end
                    end
                end
                addr_ack: begin
                    if (sda) begin              //REQUIRED SLAVE ACK ADDRESS
                        state <= start_bit;              
                    end
                    else begin
                        state <= data_fsm;
                    end
                end
                data_fsm: begin
                    if (!rd_wr_en  & data_count != 0) begin
                        data_count <= data_count + 1;
                        sda_out <= data_temp[data_count]; //PARALLEL TO SERIAL TRANSFORMAION FOR DATA
                    end
                    else begin
                        if (data_count == 3'd7) begin
                            data_count <= 3'd0;
                            state <= data_ack;
                        end
                    end
                end
                data_ack: begin
                    if (sda) begin              //REQUIRED SLAVE ACK FOR DATA
                        state <= start_bit;
                    end
                    else state <= stop;
                end
                stop: begin
                    if (stop_bit & ~(start_bit)) begin  //FRAME STOP CONDITION
                        sda_en <= 1'b0;
                        state <= idle;
                    end
                    else begin
                        state <= start;
                        sda_en <= 1'b0;
                    end
                end
                default: begin
                    sda_en <= 1'b0;
                    state <= idle;
                end
            endcase
        end
    end

    assign sda = (sda_en)? sda_out : 1'bz;   //SDA FOR IN CONTINOUS ASSIGNMENT
endmodule

//Design By MURUGAVEL
