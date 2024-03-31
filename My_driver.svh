class My_driver extends uvm_driver #(My_sequence_item);
        `uvm_component_utils(My_driver)

        virtual intf config_virtual;
        My_sequence_item sequence_item;

        function new(string name = "My_driver", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //$display("In build phase of driver");
            uvm_config_db#(virtual intf)::get(this,"","my_vif",config_virtual);
            //sequence_item = My_sequence_item::type_id::create("sequence_item");
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //$display("In connect phase of driver");
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            //$display("In run phase of driver");
            forever begin
                seq_item_port.get_next_item(sequence_item);
                config_virtual.cb_driver.rst <= sequence_item.rst;
                config_virtual.cb_driver.W_en <= sequence_item.W_en;
                config_virtual.cb_driver.Address <= sequence_item.Address;
                config_virtual.cb_driver.Data_in <= sequence_item.Data_in;
                $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
                //$display("DRIVER: At time = %0p: Drove the virtual interface with the data:\nAddress = %0d, Input Data = %0d, Write Enable = %0d",$realtime(), config_virtual.Address, config_virtual.Data_in, config_virtual.W_en);
                `uvm_info("DRIVER", $sformatf("Drove the virtual interface with the data:\nReset = %0d, Address = %0d, Input Data = %0d, Write Enable = %0d", sequence_item.rst, sequence_item.Address, sequence_item.Data_in, sequence_item.W_en), UVM_MEDIUM)
                $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
                @(config_virtual.cb_driver)
                seq_item_port.item_done();
            //     $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
            //     //$display("DRIVER: At time = %0p: Drove the virtual interface with the data:\nAddress = %0d, Input Data = %0d, Write Enable = %0d",$realtime(), config_virtual.Address, config_virtual.Data_in, config_virtual.W_en);
            //     `uvm_info("DRIVER", $sformatf("Drove the virtual interface with the data:\nAddress = %0d, Input Data = %0d, Write Enable = %0d",config_virtual.Address, config_virtual.Data_in, config_virtual.W_en), UVM_MEDIUM)
            //     $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
            end
        endtask

        function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            //$display("In check phase of driver");
        endfunction
endclass