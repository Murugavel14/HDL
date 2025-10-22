//FIFO_1 HERE

module sync_fifo_1 #(
    parameter  fifo_depth_1 = 8,
    parameter  data_width_1  = 4
) (
    input clk,
    input rst_n,
    input wr_en_1,
    input rd_en_1,
    input [data_width_1 - 1:0] data_in_1,
    output reg [data_width_1 - 1:0] data_out_1,
    output full_1,
    output empty_1
);
    //FIFO_1 DESIGN
    localparam fifo_depth_log_1 = $clog2(fifo_depth_1);
    reg [data_width_1 - 1:0] fifo_1 [0: fifo_depth_log_1 - 1];
    reg [data_width_1 - 1:0] wrptr_1;
    reg [data_width_1 - 1:0] rdptr_1;

    //WRITE OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            wrptr_1 <= '0; //MEANS ALL BITS GETING ZERO(0000)

        end else if (wr_en_1 && !full_1) begin
            fifo_1 [wrptr_1[fifo_depth_log_1-1:0]] <= data_in_1;
            wrptr_1 <= wrptr_1 + 1'b1;
        end
        
    end

    //READ OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            rdptr_1 <= '0; //MEANS ALL BITS GETING ZERO(0000)

        end else if (rd_en_1 && !empty_1)) begin
            data_out_1 <= fifo_1 [rdptr_1[fifo_depth_log_1-1:0]];
            rdptr_1 <= rdptr_1 + 1'b1;
        end
        
    end

    assign empty_1 = (wrptr_1 == rdptr_1);
    assign full_1  = ({wrptr_1[fifo_depth_log_1],wrptr_1[fifo_depth_log_1-1:0]} == rdptr_1);

endmodule

//FIFO_2 HERE

 module sync_fifo_2 #(
    parameter  fifo_depth_2 = 8,
    parameter  data_width_2  = 4
) (
    input clk,
    input rst_n,
    input wr_en_2,
    input rd_en_2,
    input [data_width_2 - 1:0] data_in_2,
    output reg [data_width_2 - 1:0] data_out_2,
    output full_2,
    output empty_2
);
    //FIFO_2 DESIGN
    localparam fifo_depth_log_2 = $clog2(fifo_depth_2);
    reg [data_width_2 - 1:0] fifo_2 [0: fifo_depth_log_2 - 1];
    reg [data_width_2 - 1:0] wrptr_2;
    reg [data_width_2 - 1:0] rdptr_2;

    //WRITE OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            wrptr_2 <= '0; //MEANS ALL BITS GETING ZERO(0000)

        end else if (wr_en_2 && !full_2)) begin
            fifo_2 [wrptr_2[fifo_depth_log_2-1:0]] <= data_in_2;
            wrptr_2 <= wrptr_2 + 1'b1;
        end
        
    end

    //READ OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            rdptr_2 <= '0; //MEANS ALL BITS GETING ZERO(0000)

        end else if (rd_en_2 && !empty_2) begin
            data_out_2 <= fifo_2 [rdptr_2[fifo_depth_log_2-1:0]];
            rdptr_2 <= rdptr_2 + 1'b1;
        end
        
    end

    assign empty_2 = (wrptr_2 == rdptr_2);
    assign full_2  = ({wrptr_2[fifo_depth_log_2],wrptr_2[fifo_depth_log_2-1:0]} == rdptr_2);

endmodule

//LOGIC HERE (AVERAGE)
module average_out(
    input  [data_width_1 - 1:0] data_out_1,
    input  [data_width_2 - 1:0] data_out_2,
    output [data_width_1 - 1:0] avg
);
        wire [data_width_1 + 1:0] sum;
    always@(data_out_1, data_in_2) begin 
        if (empty_1 & empty_2) begin
            sum = (data_out_1 + data_in_2);
            avg = sum >> 2; //it's a averaging 2 input value (>> is this specificaly using for divide by 2)
        end else begin
            avg = '0; //MEANS ALL BITS GETING ZERO(0000)
        end
    end
endmodule


//FIFO_3 HERE (FINAL OUTPUT)

 module sync_fifo_3 #(
    parameter  fifo_depth_3 = 8,
    parameter  data_width_3  = 4
) (
    input clk,
    input rst_n,
    input wr_en_3,
    input rd_en_3,
    input [data_width_3 - 1:0] data_in_3,
    output reg [data_width_3 - 1:0] data_out_3,
    output full_3,
    output empty_3
);
    //FIFO_3 DESIGN
    localparam fifo_depth_log_3 = $clog2(fifo_depth_3);
    reg [data_width_3 - 1:0] fifo_3 [0: fifo_depth_log_3 - 1];
    reg [data_width_3 - 1:0] wrptr_3;
    reg [data_width_3 - 1:0] rdptr_3;

    //WRITE OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            wrptr_3 <= '0; //MEANS ALL BITS GETING ZERO(0000)

        end else if (wr_en_3 && !full_3)) begin
            fifo_3 [wrptr_3[fifo_depth_log_3-1:0]] <= data_in_3;
            wrptr_3 <= wrptr_3 + 1'b1;
        end
        
    end

    //READ OPERATION
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            rdptr_3 <= '0; //MEANS ALL BITS GETING ZERO(0000)

        end else if (rd_en_3 && !empty_3) begin
            data_out_3 <= fifo_3 [rdptr_3[fifo_depth_log_3-1:0]];
            rdptr_3 <= rdptr_3 + 1'b1;
        end
        
    end

    assign empty_3 = (wrptr_3 == rdptr_3);
    assign full_3  = ({wrptr_3[fifo_depth_log_3],wrptr_3[fifo_depth_log_3-1:0]} == rdptr_3);

endmodule

//Design by Murugavel
