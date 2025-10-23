
module avg_fifo #(
    parameter data_width = 4,
    parameter fifo_width = 8
)
//PORTS
(
    input [data_width - 1:0] data_in1,
    input [data_width - 1:0] data_in2,
    input clk, rst_n,
    input wr_en, rd_en,
    output empty_1, empty_2, empty_3,
    output full,
    output reg [data_width - 1:0] data_out

);
    //FIFO_DESIGN_HERE
    reg [data_width - 1:0] data_load;
    localparam fifo_dep_log = $clog2(fifo_width);
    reg [data_width - 1:0] fifo [0: fifo_dep_log - 1];
    reg [data_width - 1:0] wrptr;
    reg [data_width - 1:0] rdptr;  
    
    //AVERAGE_OERATION_LOGIC_HERE
    //wire [ data_width :0] sum;
    reg [ data_width - 1:0] avg;

    always@(*) begin 
        if (!empty_1 & !empty_2 & !full) begin //I'm additionaly adding !full condition because, this condition has holdin avg operation
            //assign sum = (data_in1 + data_in2);
            avg = (data_in1 + data_in2) >> 2; //it's a averaging 2 input value (>> is this specificaly using for divide by 2)
        end else begin
            avg = 4'b0; //ALL BITS ZERO(0000)
        end
    end

    //FINAL_OUTPUT_HERE_(FIFO)
    //WRITE_OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            wrptr <= 4'b0; //ALL BITS ZERO(0000)

        end else if (wr_en && !full) begin
            fifo [ wrptr [ fifo_dep_log - 1:0]] <= avg;
            wrptr <= wrptr + 1'b1;
        end
        
    end

    //READ_OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            rdptr <= 4'b0; //ALL BITS  ZERO(0000)
        end else if (rd_en && !empty_3) begin
            data_out <= fifo [ rdptr [ fifo_dep_log - 1:0]];
            rdptr <= rdptr + 1'b1;
        end
        
    end

    assign empty_3 = (wrptr == rdptr);
    assign full = ({~wrptr[fifo_dep_log], wrptr[fifo_dep_log - 1:0]} == rdptr);

endmodule


//Design by Murugavel
