    ______     _______     _____________     ______________     __________     ______________     ______
  ->|IDLE| --> |START| --> |ADDRESS_FSM| --> |ADDR_ACK_FSM| --> |DATA_FSM| --> |DATA_ACK_FSM| --> |STOP| --v
  | ------     -------     -------------     --------------     ----------     --------------     ------   |
  |                                                                                                        |
  --------------------------------------------------------------------------------------------------------<-
module i2c 
(
    input  clk,
    input  rst_n,
    input  start_bit,
    input  [6:0]addr,   //ADDRESSS
    input  [7:0]data,   //INPUT DATA
    input  rd_wr_en,    //READ AND WRITE ENABLE
    input  stop_bit,
    output reg error,       //ERROR SIGNAL
    output reg scl,     //SERIAL CLK
    inout  sda          //SERIAL DATA
);

#(
    parameter idle         = 3'd0;
    parameter start        = 3'd1;
    parameter addr_fsm     = 3'd2;
    parameter addr_ack_fsm  = 3'd3;
    parameter data_fsm     = 3'd4;
    parameter data_ack_fsm = 3'd5;
    parameter stop         = 3'd6;
) 

    reg [7:0] addr_temp  = 0;
    reg [7:0] data_temp  = 0;
    reg [2:0] addr_count = 3'd7;
    reg [2:0] data_count = 3'd7;
    reg [2:0] state      = idle;
    reg sda_en;   //FOR SDA INOUT PORT
    reg sda_out;  //MASKING SDA OUTPUT
    reg i_scl;
    
   
    always @(posedge clk) begin
        if (start_bit & ~(stop_bit) & !error) begin
            i_scl <=  clk;
        end
        else if (~(start_bit) & stop_bit & !error) begin
            i_scl <=  1'b1;
        end
        else begin
            i_scl <=  1'b1;
        end
   end
// --------------------- | MASTER TO SLAVE | ----------------------------------

    always @(posedge i_scl or negedge rst_n) begin
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
                    if (start_bit & ~(stop_bit)) begin  
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
                            state <= addr_ack_fsm;
                        end
                    end
                end
                addr_ack_fsm: begin
                    if (sda) begin              //REQUIRED SLAVE ACK ADDRESS
                        state <= start_bit;              
                    end
                    else begin
                        state <= data_fsm;
                    end
                end
                data_fsm: begin
                    if (!rd_wr_en  & data_count != 0) begin
                        data_count <= data_count - 1;
                        sda_out <= data_temp[data_count]; //PARALLEL TO SERIAL TRANSFORMAION FOR DATA
                    end
                    else begin
                        if (data_count == 3'd7) begin
                            data_count <= 3'd0;
                            state <= data_ack_fsm;
                        end
                    end
                end
                data_ack_fsm: begin
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

    // ------------------ | END | -------------------------------------
    
    
// ---------------------- | SLAVE TO MASTER | ---------------------------------

    always @(negedge i_scl or posedge rst_n) begin
        if (!rst_n) begin
            sda_en <= 1'b0;
        end
        else begin
            case (state)
                start: begin
                    if ((sda == 1'b0) & (sda_en == 1'b0) & (!start_bit)) begin
                        sda_en <= 1'b1;
                        state <= addr_fsm;
                        addr_count <= 3'd0;
                        data_count <= 3'd0;
                    end
                    else begin
                        state <= start;
                        sda_en <= 1'b0;
                    end
                end
                addr_fsm: begin
                    if (addr_count != 3'd7) begin
                        addr_count <= addr_count + 1;
                        addr_temp[addr_count] <= sda;
                    end 
                    else begin
                        if (addr_temp[3'd7] == 1'b1 & addr_count == 3'd7) begin
                            state <= adr_ack_fsm;
                            addr_count <= 3'd7;
                        end
                        else begin
                            state <= addr_fsm;
                        end
                    end
                end
                addr_ack: begin
                    if (sda == 1'b0) begin
                            state <= data_fsm;
                        end
                        else begin
                            state <= addr_fsm;
                    end
                end
                data_fsm: begin
                    if (data_count != 3'd7) begin
                        data_count <= data_count + 1;
                        data_temp[data_count] <= sda;
                    end 
                    else begin
                        if (data_count == 3'd7) begin
                            data_count <= 3'd0;
                            state <= data_ack_fsm;
                        end
                    end
                end
                data_ack_fsm: begin
                    if (sda == 1'b0) begin
                            state <= stop;
                        end
                        else begin
                            state <= start;
                    end
                end
                stop: begin
                    if (sda == 1'b1) begin
                            state <= start;
                    end
                end
                default: begin
                    state <= start
                    sda_out <= 1'b1;
                    sda_en <= 1'b0;
                end
            endcase
        end
    end

    // ------------------ | END | -------------------------------------

    assign sda = (sda_en)? sda_out : 1'bz;   //SDA FOR IN CONTINOUS ASSIGNMENT

    // ---------------------- | ERROR SIGNAL | ---------------------------------
    always @(*) begin
        if (start_bit) begin
            if ((state == addr_fsm) |(state == addr_ack_fsm) | (state == data_fsm) | (state == data_ack_fsm)) begin
                error = 1b1;
            end
        end
        else begin
            error = 1'b0;
        end
    end

endmodule

//Design By MURUGAVEL
