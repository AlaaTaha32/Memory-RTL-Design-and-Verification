class My_test extends uvm_test;

        `uvm_component_utils(My_test)
        
        virtual intf config_virtual;
        My_env env;
        My_sequence sequence_inst;
        Reset_Seq reset_seq;
        Write_sequence Write_seq;
        Read_sequence Read_seq;
        

        function new(string name = "My_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //$display("In build phase of test");
            env = My_env::type_id::create("env",this);
            sequence_inst = My_sequence::type_id::create("sequence_inst");
            reset_seq = Reset_Seq::type_id::create("Reset_Seq");
            Write_seq = Write_sequence::type_id::create("Write_Seq");
            Read_seq = Read_sequence::type_id::create("Read_Seq");
            if(!uvm_config_db#(virtual intf)::get(this,"","my_vif",config_virtual)) `uvm_fatal(get_full_name(),"Error!");
            uvm_config_db#(virtual intf)::set(this,"env","my_vif",config_virtual);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //$display("In connect phase of test");
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            //$display("In run phase of test");
            phase.raise_objection(this,"Starting Sequences");
            // reset_seq.start(env.agent.sequencer);
            sequence_inst.start(env.agent.sequencer);
            // reset_seq.start(env.agent.sequencer);
            // repeat(4) begin
            //     Write_seq.start(env.agent.sequencer);
            //     Read_seq.start(env.agent.sequencer);
            // end
            // reset_seq.start(env.agent.sequencer);
            // Write_seq.start(env.agent.sequencer);
            // Read_seq.start(env.agent.sequencer);
            // repeat(4) begin
            //     reset_seq.start(env.agent.sequencer);
            //     Write_seq.start(env.agent.sequencer);
            //     Read_seq.start(env.agent.sequencer);
            // end
            phase.drop_objection(this,"Finished Sequences");
        endtask

        function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            //$display("In check phase of test");
        endfunction

    endclass