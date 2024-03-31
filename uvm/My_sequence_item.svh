class My_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(My_sequence_item)

        function new(string name = "My_sequence_item");
            super.new(name);
        endfunction

        bit clk;
        bit rst;
        bit W_en;
        rand bit [3:0] Address;
        rand bit [31:0] Data_in;;
        bit [31:0] Data_out;
        bit Valid_out;

        rand int n_of_Read_Trans;
        rand int n_of_Write_Trans;

        constraint cons1{Data_in inside {[0:100]};}
        constraint cons2{(Address < 10)->(Data_in < 50);}
        constraint cons3{n_of_Read_Trans inside {[1:6]};}
        constraint cons4{n_of_Write_Trans inside {[1:6]};}
    endclass