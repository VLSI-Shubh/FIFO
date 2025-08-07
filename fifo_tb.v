`timescale 1ns/1ns
`include "fifo.v"

module fifo_tb;

    parameter WIDTH = 8;

    reg clk, rst, wr, rd;
    reg [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;
    wire full, empty;


    fifo #( .depth(8), .width(WIDTH) ) uut (
        .clk(clk),
        .rst(rst),
        .wr(wr),
        .rd(rd),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_tb);
    end

    initial begin
        // Initialize signals
        rst = 1; wr = 0; rd = 0; data_in = 8'd0;

        #13 rst = 0;            // Deassert reset
    
        // Write 3 values
        #10 wr = 1; data_in = 8'd10;
        #10 wr = 1; data_in = 8'd20;
        #10 wr = 1; data_in = 8'd30;
        #10 wr = 0;             // Stop writing

        // Read 3 values
        #10 rd = 1;
        #10 rd = 1;
        #10 rd = 1;
        #10 rd = 0;             // Stop reading

        // Write until full (write 5 more times, adjust as needed)
        #10 wr = 1; data_in = 8'd40;
        #10 wr = 1; data_in = 8'd50;
        #10 wr = 1; data_in = 8'd60;
        #10 wr = 1; data_in = 8'd70;
        #10 wr = 1; data_in = 8'd80;
        #10 wr = 0;             // Stop writing

     // Read until empty (read 5 times)
        #10 rd = 1;
        #10 rd = 1;
        #10 rd = 1;
        #10 rd = 1;
        #10 rd = 1;
        #10 rd = 0;             // Stop reading

        #20 $finish;
    end


    initial begin
        $monitor("Time=%0t | rst=%b | wr=%b | rd=%b | data_in=%h | data_out=%h | full=%b | empty=%b",
                 $time, rst, wr, rd, data_in, data_out, full, empty);
    end

endmodule
