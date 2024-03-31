class My_sequencer extends uvm_sequencer #(My_sequence_item);
        `uvm_component_utils(My_sequencer)

        function new(string name = "My_sequencer", uvm_component parent = null);
            super.new(name,parent);
        endfunction
    endclass
