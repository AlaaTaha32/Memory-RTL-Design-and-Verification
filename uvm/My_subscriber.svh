class My_subscriber extends uvm_subscriber #(My_sequence_item);
        `uvm_component_utils(My_subscriber)

        My_sequence_item sequence_item;

        covergroup group_1;
            Input_Data: coverpoint sequence_item.Data_in {
                bins Input_Data[5] = {[0:20], [21:40], [41:60], [61:80], [81:100]};
                }

            Address: coverpoint sequence_item.Address {
                bins Address[] = {[0:15]};
            }

            Write_Read: coverpoint sequence_item.W_en{
                bins Write[] = {0,1};
            }

            Address_Write: cross Address, Write_Read;
        endgroup
        
        function new(string name = "My_subscriber", uvm_component parent = null);
            super.new(name,parent);
            group_1 = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //$display("In build phase of subscriber");
            sequence_item = My_sequence_item::type_id::create("sequence_item"); // Can be redundant
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //$display("In connect phase of subscriber");
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            //$display("In run phase of subscriber");
        endtask

        function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            //$display("In check phase of subscriber");
        endfunction

        function void write(My_sequence_item t);
            sequence_item = t;
            group_1.sample();
            // $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
            // `uvm_info("SUBSCRIBER", $sformatf("Detected the following data: \nAddress = %0d, Input Data = %0d, Output Data = %0d, Valid_Out = %0d", t.Address, t.Data_in, t.Data_out, t.Valid_out), UVM_MEDIUM)
            // $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
        endfunction

    endclass