class My_agent extends uvm_agent;

        `uvm_component_utils(My_agent)

        virtual intf config_virtual;
        My_driver driver;
        My_monitor monitor;
        My_sequencer sequencer;
        //uvm_analysis_port#(My_sequence_item) My_analysis_port;

        function new(string name = "My_agent", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //$display("In build phase of agent");
            driver = My_driver::type_id::create("driver",this);
            monitor = My_monitor::type_id::create("monitor",this);
            sequencer = My_sequencer::type_id::create("sequencer",this);
            
            if(!uvm_config_db#(virtual intf)::get(this,"","my_vif",config_virtual)) `uvm_fatal(get_full_name(),"Error!");
            uvm_config_db#(virtual intf)::set(this,"driver","my_vif",config_virtual);
            uvm_config_db#(virtual intf)::set(this,"monitor","my_vif",config_virtual);
            //My_analysis_port = new("My_analysis_port",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //$display("In connect phase of agent");
            //monitor.My_analysis_port.connect(My_analysis_port);
            driver.seq_item_port.connect(sequencer.seq_item_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            //$display("In run phase of agent");
        endtask

        function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            //$display("In check phase of agent");
        endfunction

    endclass