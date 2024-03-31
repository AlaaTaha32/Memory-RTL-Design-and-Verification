module Mem
#(parameter Addr_Width = 4, Data_Width = 32)(
    input clk,
    input rst, // Asynchronous active-low reset
    input W_en,
    input [Addr_Width-1 : 0] Address,
    input [Data_Width-1: 0] Data_in,
    output [Data_Width-1 : 0] Data_out,
    output Valid_out
);

reg [Data_Width-1 : 0] Memory [0 : (2**Addr_Width)-1];
integer i;

// Synchronous write operation
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        for (i = 0; i < (2**Addr_Width); i = i+1) begin
            Memory[i] <= {(Data_Width){1'b0}}; // Erasing all the data in memory
        end
    end
    else if (W_en) begin
        Memory[Address] <= Data_in;
    end
end

// Asynchronous read operation
assign Data_out = rst? Memory[Address] : {(Data_Width){1'b0}};
assign Valid_out = rst? (W_en? 1'b0 : 1'b1) : 1'b0;  // During write operation, output data is invalid 

endmodule

