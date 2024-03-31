interface intf(input bit clk);
    bit rst;
    bit W_en;
    bit [3:0] Address;
    bit [31:0] Data_in;
    bit [31:0] Data_out;
    bit Valid_out;

    // initial begin
    //     forever #5 clk = ~clk;
    // end

    clocking cb_driver @(posedge clk);
        default input #1step output negedge;
        input Data_out, Valid_out;
        output rst, W_en, Address, Data_in;
    endclocking

    clocking cb_monitor @(posedge clk);
        default input #1step output negedge;
        input Data_out, Valid_out, rst, W_en, Address, Data_in;
    endclocking
endinterface //intf
