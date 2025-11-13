 module sync_fifo#(
    parameter  fifo_depth = 8,
    parameter  data_width  = 4
) (
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input [data_width - 1:0] data_in,
    output reg [data_width - 1:0] data_out,
    output full,
    output empty
);
    //FIFO DESIGN
    localparam fifo_depth_log = $clog2(fifo_depth);
    reg [data_width - 1:0] fifo [0: fifo_depth_log - 1];
    reg [data_width - 1:0] wrptr;
    reg [data_width - 1:0] rdptr;

    //WRITE OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            wrptr <= '0; //MEANS ALL BITS GETING ZERO(0000)

        end else if (wr_en && !full)) begin
            fifo [wrptr[fifo_depth_log-1:0]] <= data_in;
            wrptr <= wrptr + 1'b1;
        end
        
    end

    //READ OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            rdptr <= '0; //MEANS ALL BITS GETING ZERO(0000)

        end else if (rd_en && !empty) begin
            data_out <= fifo [rdptr[fifo_depth_log-1:0]];
            rdptr <= rdptr + 1'b1;
        end
        
    end

    assign empty = (wrptr == rdptr);
   assign full  = ({~wrptr[fifo_depth_log],wrptr[fifo_depth_log-1:0]} == rdptr);

endmodule
//Design By Murugavel
