/*
 * -----------------------------------------------------------------------------
 *   This FIFO module is heavily commented on purpose. Some parts of the code 
 *   may look different from common RTL styles, but that decision is  made 
 *   intentionally to simplify the design and make it easier to understand — 
 *   especially for beginners or for revisiting the logic later.
 * 
 *   Key things to note:
 *   - One extra bit is used in the read/write pointers to help detect full vs empty.
 *   - Full detection uses the MSB flip trick.
 *   - The module avoids unnecessary complexity to focus on clarity.
 *
 *   Feel free to remove or condense comments once you're comfortable with the logic.
 * -----------------------------------------------------------------------------
 */

module fifo #(
    parameter depth = 8,
    parameter width = 8
) (
    input [width-1 : 0] data_in,
    input clk, rst,rd, wr,
    output reg [width-1:0] data_out, 
    output full, empty
);
    // Main memory block of the FIFO — it's just a simple register file not the actual module.
    // you can choose to tgive it some other name as well
    // Each entry is 'width' bits wide, and we have 'depth' entries.
    reg [width-1 : 0] fifo [0 : depth-1];


    // We're using one extra bit in the read and write pointers.
    // This helps us distinguish between full and empty states.
    // Without this extra MSB, wr_ptr == rd_ptr would always look like 'empty',
    // but with the extra bit, we can tell when the FIFO has wrapped around.  
    reg [$clog2(depth) : 0] wr_ptr, rd_ptr;


    // This defines the memory depth in terms of address width.
    // We'll use this everywhere instead of writing $clog2(depth) multiple times.
    localparam ptr_depth = $clog2(depth); 

    // Write happens on the rising edge of the clock.
    // Only write if 'wr' is high and the FIFO is not full.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
        end else begin
            if (wr && !full) begin
                fifo[wr_ptr[ptr_depth-1 : 0]] <= data_in;
                wr_ptr <= wr_ptr + 1'b1; // dont forget  to increment the pointer
            end 
        end
    end


    // Read happens on the rising edge of the clock.
    // Only read if 'rd' is high and FIFO is not empty.
    // If reset is active, clear the data_out and reset the read pointer.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
            rd_ptr <= 0;
        end else begin
            if (rd && !empty) begin
                data_out <= fifo[rd_ptr[ptr_depth-1:0]];
                rd_ptr <= rd_ptr +1'b1; // dont forget  to increment the pointer
            end else begin
               data_out <= 'bz; 
            end
        end
    end

    // Full condition:
    // This checks if the write pointer has wrapped around and caught up to the read pointer.
    // We flip the MSB of the write pointer and compare it with the read pointer.
    assign full = rd_ptr == { ~wr_ptr[ptr_depth], wr_ptr[ptr_depth-1 : 0]};

    // Empty condition:
    // If the read and write pointers are equal, then the FIFO is empty.
    assign empty = rd_ptr == wr_ptr;
endmodule