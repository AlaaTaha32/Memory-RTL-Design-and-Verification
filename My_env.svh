  class My_env extends uvm_env;

        `uvm_component_utils(My_env)

        virtual intf config_virtual;
        My_agent agent;
        My_subscriber subscriber;
        My_scoreboard scoreboard;

        function new(string name = "My_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //$display("In build phase of env");
            agent = My_agent::type_id::create("agent",this);
            subscriber = My_subscriber::type_id::create("subscriber",this);
            scoreboard = My_scoreboard::type_id::create("scoreboard",this);
            if(!uvm_config_db#(virtual intf)::get(this,"","my_vif",config_virtual)) `uvm_fatal(get_full_name(),"Error!");
            uvm_config_db#(virtual intf)::set(this,"agent","my_vif",config_virtual);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //$display("In connect phase of env");
            agent.monitor.My_analysis_port.connect(subscriber.analysis_export);
            agent.monitor.My_analysis_port.connect(scoreboard.My_analysis_imp); 
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            //$display("In run phase of env");
        endtask

        function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            //$display("In check phase of env");
        endfunction

    endclass