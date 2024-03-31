module top(
);
    import uvm_pkg::*;
    import my_pkg::*;

    bit clk;
    intf in1 (clk);

    initial begin
        uvm_config_db#(virtual intf)::set(null,"uvm_test_top","my_vif",in1);
        run_test("My_test");
    end

    Mem #(4,32) memory_inst(
        .clk(clk),
        .rst(in1.rst),
        .W_en(in1.W_en),
        .Address(in1.Address),
        .Data_in(in1.Data_in),
        .Data_out(in1.Data_out),
        .Valid_out(in1.Valid_out)
    );

    // Clock Signal
    always #5 clk = ~clk;

endmodule
