module i2c_ctrl 
(
    input [7:0] data,
    input [7:0] addr,
    input rd_wr_en,
    input clk, rst_n,
    output scl,
    inout reg sda 
);
#(
    parameter start     = 3'b000;
    parameter addr_sda  = 3'b001;
    parameter rd_wr_sda = 3'b010;
    parameter addr_ack  = 3'b011;
    parameter data_sda  = 3'b100;
    parameter data_ack  = 3'b101;
    parameter stop      = 3'b101;

    reg [2:0] data_count = 0;
    reg [2:0] addr_count = 3'd7;
    reg [7:0] temp = 0;
    reg [7:0] addr_temp = 0;
    reg addr_ack_en, data_ack_en;
    reg state = start;

     
) 
    assign scl = clk;

    //if (!rd_wr_en) begin
        always @(posedge clk or negedge rst_n) begin
            sda <= 1'b1;
            case (state)
                start: begin
                    if (!rd_wr_en) begin
                        sda       <= 1'b0;
                        state     <= addr_sda;
                        addr_temp <= addr;
                    end
                end
                addr_sda: begin
                    if ((!rd_wr_en && addr_count == 3'd7)) begin
                        if (addr_count != 0) begin
                            addr_count <= addr_count - 3'd1;
                            sda <= addr_temp[addr_count];
                        end else begin
                            addr_count <= 3'd7;
                        end
                    end
                    else begin
                        if (rd_wr_en && (data_count != 3'd7)) begin
                            data_count <= data_count + 3'd1;
                            temp[data_count] <= sda;
                        end
                        else begin
                            state <= rd_wr_sda;
                            data_count <= 0;
                        end
                    end
                end
                rd_wr_sda: begin
                    if (!rd_wr_en) begin
                            state <= addr_ack;
                    end
                    else state <= addr_ack;
                end
                addr_ack: begin
                    if (sda && rd_wr_en) begin
                        state <= start;
                    end
                    else begin
                        state <= data_sda;
                    end
                end
                data_sda: begin
                    if (!rd_wr_en) begin
                        addr_count <= addr_count - 3'd1;
                        sda <= temp[addr_count];
                        if (addr_count == 0) begin
                            addr_count = 3'd7;
                            state <= data_ack;
                        end
                    end else begin
                        if (data_count != 7) begin
                            data_count <= data_count + 3'd1;
                            temp[data_count] <= sda;
                        end
                        else begin
                            state <= data_ack;
                            data_count <= 3'd0;
                        end
                    end
                end
                data_ack: begin
                    if (!sda && !rd_wr_en) begin
                        state <= stop;
                    end
                    else begin
                        state <= data_sda;
                    end
                end
                stop: begin
                    state <= start;
                    sda <= 1'b1;
                end
                default: begin
                    state <= start;
                    sda   <= 1'b1;
                end
            endcase
        end
    //end
endmodule


// Design By MURUGAVEL
