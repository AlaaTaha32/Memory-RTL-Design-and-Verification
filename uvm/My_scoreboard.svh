 class My_scoreboard extends uvm_scoreboard;

        `uvm_component_utils(My_scoreboard)

        //My_sequence_item item_queue[$];
        uvm_analysis_imp#(My_sequence_item,My_scoreboard) My_analysis_imp;
        int Ref_data [int];
        int Match, Mismatch;

        function new(string name = "My_scoreboard", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //$display("In build phase of scoreboard");
            My_analysis_imp = new("My_analysis_imp",this);
        endfunction

        function void write(My_sequence_item t);
            if(t.rst==0) begin // Reset operation
                    foreach (Ref_data[i]) begin // empty the reference data
                        Ref_data[i] = 0;
                    end 
                    $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
                    `uvm_info("SCOREBOARD", $sformatf("Reference data is deleted due to reset operation"), UVM_MEDIUM)
                    $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
                end
            else if (t.Valid_out == 0) begin // Write operation
                    Ref_data[t.Address] = t.Data_in;
                    $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
                    //$display("SCOREBOARD: Reference data: Address = %-d, Data = %-d",t.Address, Ref_data[t.Address]);
                    `uvm_info("SCOREBOARD", $sformatf("Reference data: Address = %-d, Data = %-d",t.Address, Ref_data[t.Address]), UVM_MEDIUM) 
                    $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
            end else begin  // Read operation
                if(Ref_data[t.Address] == t.Data_out) begin
                    Match++;
                    $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
                    //$display("SCOREBOARD: Output data is matching correctly with reference data in Scoreboard");
                    `uvm_info("SCOREBOARD", $sformatf("Output data is matching correctly with reference data in Scoreboard"), UVM_MEDIUM)
                    $display("Output data = %-d, Reference data = %-d", t.Data_out, Ref_data[t.Address]);
                    $display("Number of Matches = %-d, Number of Mismatches = %-d",Match,Mismatch);
                    $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
                end
                else begin
                    Mismatch++;
                    $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
                    //$display("SCOREBOARD: Output data is NOT matching correctly with reference data in Scoreboard");
                    `uvm_info("SCOREBOARD", $sformatf("Output data is NOT matching correctly with reference data in Scoreboard"), UVM_MEDIUM)
                    $display("Output data = %-d, Reference data = %-d", t.Data_out, Ref_data[t.Address]);
                    $display("Number of Matches = %-d, Number of Mismatches = %-d",Match,Mismatch);
                    $display("--------------------------------------------------------------------------------------------------------------------------------------------------\n");
                end
            end
            if((Match+Mismatch)==20) begin // End of the 20 iterations of Read
                $display("Testing is done\nNumber of Matches = %-d, Number of Mismatches = %-d\n",Match,Mismatch);
                $finish;
            end
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //$display("In connect phase of scoreboard");
        endfunction

        task run_phase(uvm_phase phase);
            //My_sequence_item item_pop;
            super.run_phase(phase);
            /*forever begin
                wait(item_queue.size()>0);
                if(item_queue.size()>0) begin
                    item_pop = item_queue.pop_front();
                    if (item_pop.Valid_out == 0) begin // Write operation
                        Ref_data[item_pop.Address] = item_pop.Data_in;
                        $display("Reference data in Scoreboard: Address = %-d, Data = %-d",item_pop.Address, Ref_data[item_pop.Address]);   
                    end else begin  // Read operation
                        if(Ref_data[item_pop.Address] == item_pop.Data_out) begin
                            Match++;
                            $display("Output data is matching correctly with reference data in Scoreboard");
                        end
                        else begin
                            Mismatch++;
                            $display("Output data is NOT matching correctly with reference data in Scoreboard");
                            $display("Output data = %-d, Reference data = %-d", item_pop.Data_out, Ref_data[item_pop.Address]);
                        end
                    end
                    if((Match+Mismatch)==16) begin // End of the 16 iterations of Read
                        $display("Testing is done\nNumber of Matches = %-d, Number of Mismatches = %-d",Match,Mismatch);
                    end
                end
            end*/
        endtask

        function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            //$display("In check phase of scoreboard");
        endfunction

    endclass