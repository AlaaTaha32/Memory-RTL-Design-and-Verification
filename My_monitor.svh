class My_monitor extends uvm_monitor;
        
        `uvm_component_utils(My_monitor)
        
        virtual intf config_virtual;
        //My_sequence_item sequence_item2;
        My_sequence_item sequence_item1; // To subscriber
        uvm_analysis_port#(My_sequence_item) My_analysis_port; 

        function new(string name = "My_monitor", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //$display("In build phase of monitor");
            uvm_config_db#(virtual intf)::get(this,"","my_vif",config_virtual);
            My_analysis_port = new("My_analysis_port",this);
            sequence_item1 = My_sequence_item::type_id::create("sequence_item1");
            //sequence_item2 = My_sequence_item::type_id::create("sequence_item2");
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //$display("In connect phase of monitor");
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            //$display("In run phase of monitor");
            forever begin
                @(config_virtual.cb_monitor)
                sequence_item1.rst = config_virtual.cb_monitor.rst;
                sequence_item1.W_en = config_virtual.cb_monitor.W_en;
                sequence_item1.Address = config_virtual.cb_monitor.Address;
                sequence_item1.Data_in = config_virtual.cb_monitor.Data_in;
                sequence_item1.Data_out = config_virtual.cb_monitor.Data_out;
                sequence_item1.Valid_out = config_virtual.cb_monitor.Valid_out;
                //$cast(sequence_item2, sequence_item1.clone());
                //phase.raise_objection(this);
                //phase.drop_objection(this);
                $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
                //$display("MONITOR: At time = %0p:Detected the following valid outputs: \nOutput Data = %0d, Valid_Out = %0d",$realtime(), config_virtual.Data_out, config_virtual.Valid_out);
                `uvm_info("MONITOR", $sformatf("Detected the following outputs: \nAddress = %0d, Output Data = %0d, Valid_Out = %0d", config_virtual.Address, config_virtual.Data_out, config_virtual.Valid_out), UVM_MEDIUM)
                $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
                My_analysis_port.write(sequence_item1);
            end
        endtask

        function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            //$display("In check phase of monitor");
        endfunction

    endclass