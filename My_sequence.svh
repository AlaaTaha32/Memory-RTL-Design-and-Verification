class Reset_Seq extends uvm_sequence #(My_sequence_item);
    `uvm_object_utils(Reset_Seq)
    My_sequence_item sequence_item;

    static int i;

        function new(string name = "Reset_Seq");
            super.new(name);
        endfunction

        task pre_body();
            sequence_item = My_sequence_item::type_id::create("sequence_item");
        endtask

        task body();
            $display("\n\n****************************************************************************************************************************************************************************");
            $display("\t\t\t\t\t\t\t\t\t Reset Transaction #%0d started", i+1);
            $display("****************************************************************************************************************************************************************************\n");
            start_item(sequence_item);
            i++;
            sequence_item.rst = 0;
            void'(sequence_item.randomize());
            `uvm_info("RESET SEQUENCE", $sformatf("Randomized data:\nReset = %0d, Address = %0d, Input Data = %0d, Write Enable = %0d", sequence_item.rst, sequence_item.Address, sequence_item.Data_in, sequence_item.W_en), UVM_MEDIUM)
            $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
            finish_item(sequence_item);
        endtask

endclass


class Read_sequence extends uvm_sequence #(My_sequence_item);
        `uvm_object_utils(Read_sequence)
        My_sequence_item sequence_item;
        static int R;


        function new(string name = "Read_sequence");
            super.new(name);
        endfunction

        task pre_body();
            sequence_item = My_sequence_item::type_id::create("sequence_item");
        endtask 

        task body();
            int k = 0;
            int num = 1;
            while(k<num) begin
                $display("\n\n****************************************************************************************************************************************************************************");
                $display("\t\t\t\t\t\t\t\t\t Read Transaction #%0d started", R+1);
                $display("****************************************************************************************************************************************************************************\n");
                start_item(sequence_item);
                sequence_item.rst = 1;
                sequence_item.W_en = 0;
                void'(sequence_item.randomize());
                if(k==0) num = sequence_item.n_of_Read_Trans;
                $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
                `uvm_info("READ SEQUENCE", $sformatf("Randomized data:\nReset = %0d, Address = %0d, Input Data = %0d, Write Enable = %0d", sequence_item.rst, sequence_item.Address, sequence_item.Data_in, sequence_item.W_en), UVM_MEDIUM)
                $display("\nRemaining Read sequences = %0d",num-k-1);
                $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
                finish_item(sequence_item);
                k++;
                R++;
            end
        endtask
endclass


class Write_sequence extends uvm_sequence #(My_sequence_item);
        `uvm_object_utils(Write_sequence)
        My_sequence_item sequence_item;
        static int W;


        function new(string name = "Write_sequence");
            super.new(name);
        endfunction

        task pre_body();
            sequence_item = My_sequence_item::type_id::create("sequence_item");
        endtask 

        task body();
            int k = 0;
            int num = 1;
            while(k<num) begin
                $display("\n\n****************************************************************************************************************************************************************************");
                $display("\t\t\t\t\t\t\t\t\t Write Transaction #%0d started", W+1);
                $display("****************************************************************************************************************************************************************************\n");
                start_item(sequence_item);
                sequence_item.rst = 1;
                sequence_item.W_en = 1;
                void'(sequence_item.randomize());
                if(k==0) num = sequence_item.n_of_Write_Trans;
                $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
                `uvm_info("Write SEQUENCE", $sformatf("Randomized data:\nReset = %0d, Address = %0d, Input Data = %0d, Write Enable = %0d", sequence_item.rst, sequence_item.Address, sequence_item.Data_in, sequence_item.W_en), UVM_MEDIUM)
                $display("\nRemaining Write sequences = %0d",num-k-1);
                $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
                finish_item(sequence_item);
                k++;
                W++;
            end
        endtask
endclass


class My_sequence extends uvm_sequence #(My_sequence_item);
        `uvm_object_utils(My_sequence)
        My_sequence_item sequence_item;
        Reset_Seq reset_seq;
        Write_sequence Write_seq;
        Read_sequence Read_seq;


        function new(string name = "My_sequence");
            super.new(name);
        endfunction

        task pre_body();
            sequence_item = My_sequence_item::type_id::create("sequence_item");
            reset_seq = Reset_Seq::type_id::create("Reset_Seq");
            Write_seq = Write_sequence::type_id::create("Write_Seq");
            Read_seq = Read_sequence::type_id::create("Read_Seq");
        endtask 

        task body();
            reset_seq.start(m_sequencer);
            repeat(4) begin
                Write_seq.start(m_sequencer);
                Read_seq.start(m_sequencer);
            end
            reset_seq.start(m_sequencer);
            Write_seq.start(m_sequencer);
            Read_seq.start(m_sequencer);
            repeat(4) begin
                reset_seq.start(m_sequencer);
                Write_seq.start(m_sequencer);
                Read_seq.start(m_sequencer);
            end
        endtask
endclass


// class My_sequence extends uvm_sequence #(My_sequence_item);
//         `uvm_object_utils(My_sequence)
//         My_sequence_item sequence_item;
//         // int k = Reset_Seq::i;


//         function new(string name = "My_sequence");
//             super.new(name);
//         endfunction

//         task pre_body();
//             sequence_item = My_sequence_item::type_id::create("sequence_item");
//         endtask 

//         task body();
//             for (int k=0; k<32; k++) begin
//                 $display("\n\n****************************************************************************************************************************************************************************");
//                 $display("\t\t\t\t\t\t\t\t\t Transaction #%0d started",k);
//                 $display("****************************************************************************************************************************************************************************\n");
//                 start_item(sequence_item);
//                 // if(i==0) begin
//                 //     sequence_item.rst = 0;
//                 //     $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
//                 //     //$display("SEQUENCE: At time = %0p, Reset signal",$realtime());
//                 //     `uvm_info("SEQUENCE", $sformatf("Reset signal"), UVM_MEDIUM)
//                 //     $display("Randomized data:\nAddress = %0d, Input Data = %0d, Write Enable = %0d", sequence_item.Address, sequence_item.Data_in, sequence_item.W_en);
//                 //     $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
//                 // end
//                 // else begin
//                     sequence_item.rst = 1;
//                     if(k<16) sequence_item.W_en = 1;
//                     else sequence_item.W_en = 0;
//                     void'(sequence_item.randomize());
//                     $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
//                     //$display("SEQUENCE: At time = %0p: Randomized data:\nAddress = %0d, Input Data = %0d, Write Enable = %0d, Iteration number = %0d", $realtime(),sequence_item.Address, sequence_item.Data_in, sequence_item.W_en, i);
//                     `uvm_info("SEQUENCE", $sformatf("Randomized data:\nReset = %0d, Address = %0d, Input Data = %0d, Write Enable = %0d", sequence_item.rst, sequence_item.Address, sequence_item.Data_in, sequence_item.W_en), UVM_MEDIUM)
//                     $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
//                 // end
//                 finish_item(sequence_item);
//             end
//         endtask
// endclass