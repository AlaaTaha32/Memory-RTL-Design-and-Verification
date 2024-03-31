
interface RAM_intf;
    parameter Addr_Width = 4;
    parameter Data_Width = 32;

    bit clk;
    bit rst;
    bit W_en;
    bit [Addr_Width-1:0] Address;
    bit [Data_Width-1:0] Data_in;
    bit Valid_out;
    bit [Data_Width-1:0] Data_out;
endinterface //RAM_intf

package pack1;
    class Transaction;
        parameter Addr_Width = 4;
        parameter Data_Width = 32;

        bit clk;
        bit rst;
        bit W_en;
        randc bit [Addr_Width-1:0] Address;
        rand bit [Data_Width-1:0] Data_in;
        bit Valid_out;
        bit [Data_Width-1:0] Data_out;
        constraint cons1{Data_in inside {[0:100]};}
        constraint cons2{(Address < 10)->(Data_in < 50);}

        task Write(string s);
            string k;
            if(s=="Transaction") k = "randomized";
            else if(s=="Driver") k = "drived the interface with";
            else if (s=="Monitor" || s=="Scoreboard" || s=="Subscriber") k = "detected"; 
            $display("\n---------------------------------------------------------------------------------------------------------------------");
            $display("In time %0t: \t %0s class has %0s the following transaction:",$realtime(),s,k);
            $display("Reset = %0d, Write Enable = %0d, Input Data = %0d, Address = %0d, Output Data = %0d, Valid_Out = %0d",rst,W_en,Data_in,Address,Data_out,Valid_out);
            $display("---------------------------------------------------------------------------------------------------------------------\n");
        endtask 
    endclass //Transaction  

    class Sequencer;
        Transaction t1;
        mailbox seq2driv;

        function new();
            this.seq2driv = new(1);
        endfunction

        task In_Seq;
            for (int i = 0; i<33; i++) begin
                t1 = new();
                if(i==0) t1.rst = 0;
                else begin
                    t1.rst = 1;
                    void'(t1.randomize());
                    if(i<17) t1.W_en = 1;
                    else t1.W_en = 0;
                end
                seq2driv.put(t1);
                t1.Write("Transaction");
            end
        endtask
    endclass //Sequencer

    class Driver;
        Transaction t1;
        //mailbox seq2driv;
        function new;
            //seq2driv = new(1);
        endfunction
        task Drive(virtual RAM_intf k1, mailbox seq2driv);
            forever begin
                seq2driv.get(t1);
                @(posedge k1.clk)
                k1.rst = t1.rst;
                k1.W_en = t1.W_en;
                k1.Address = t1.Address;
                k1.Data_in = t1.Data_in;
                t1.Write("Driver");
            end
        endtask
    endclass //Driver

    class Monitor;
        Transaction t1;
        mailbox Monitor_box;
        mailbox Monitor_box2; // To scoreboard

        function new();
            this.Monitor_box = new(1);
            this.Monitor_box2 = new(1);
        endfunction

        task Detect(virtual RAM_intf k1);
            forever begin
                t1 = new();
                @(negedge k1.clk)
                t1.Valid_out = k1.Valid_out;
                t1.Data_out = k1.Data_out;
                t1.rst = k1.rst;
                t1.W_en = k1.W_en;
                t1.Address = k1.Address;
                t1.Data_in = k1.Data_in;
                Monitor_box.put(t1);
                Monitor_box2.put(t1);
                //if(t1.Valid_out) t1.Write("Monitor");
                t1.Write("Monitor");
            end
        endtask
    endclass //Monitor

    class Subscriber; // Coverage collection
        Transaction t1;
        //mailbox Subscriber_box;

        covergroup group_1;
            Input_Data: coverpoint t1.Data_in {
                bins Input_Data[5] = {[0:20], [21:40], [41:60], [61:80], [81:100]};
                }

            Adddress: coverpoint t1.Address {
                bins Address[] = {[0:15]};
            }
        endgroup
        
        function new();
            //this.Subscriber_box = new(1);
            group_1 = new();
        endfunction

        task Coverage(mailbox Mon2sub);
            forever begin
                Mon2sub.get(t1);
                //$display("At time = %0p: subscriber recieved the following data:\nAddress = %0d, Input Data = %0d, Write Enable = %0d", $realtime(),T1.Address, T1.Data_in, T1.W_en);
                group_1.sample();
                t1.Write("Subscriber");
            end
        endtask

    endclass //Subscriber

    class Scoreboard;
        Transaction T_out;
        //mailbox Mon2Score_box;
        int Ref_data [int];
        int Match, Mismatch;

        function new();
            //this.Mon2Score_box = new(1);
        endfunction

        task Comp(mailbox Mon2Score_box);
            forever begin
                Mon2Score_box.get(T_out);
                if (T_out.Valid_out == 0) begin // Write operation
                    Ref_data[T_out.Address] = T_out.Data_in;
                    //$display("Reference data in Scoreboard: Address = %-d, Data = %-d",T_out.Address, Ref_data[T_out.Address]);   
                end else begin  // Read operation
                    $display("\n---------------------------------------------------------------------------------------------------------------------");
                    $display("Reference data in Scoreboard: Address = %-d, Data = %-d",T_out.Address, Ref_data[T_out.Address]); 
                    if(Ref_data[T_out.Address] == T_out.Data_out) begin
                        Match++;
                        $display("Output data is matching correctly with reference data in Scoreboard");
                    end
                    else begin
                        Mismatch++;
                        $display("Output data is NOT matching correctly with reference data in Scoreboard");
                        $display("Output data = %-d, Reference data = %-d", T_out.Data_out, Ref_data[T_out.Address]);
                    end
                    $display("---------------------------------------------------------------------------------------------------------------------\n");
                end

                if((Match+Mismatch)==16) begin // End of the 16 iterations of Read
                    $display("Testing is done\nNumber of Matches = %-d, Number of Mismatches = %-d",Match,Mismatch);
                    $finish;
                end
            end
        endtask
    endclass

    class Env;
        Sequencer S1;
        Driver D1;
        Monitor M1;
        Subscriber Sub1;
        Scoreboard SB1;

        function new;
            S1= new();
            D1 = new();
            M1 = new();
            Sub1 = new();
            SB1 = new();
        endfunction

        task Operate(virtual RAM_intf k2);
            //D1.Driver_box = S1.Sequence_box;
            //S1.Sequence_event = D1.Driver_event;
            //SB1.Mon2Score_box = M1.Monitor_box2;
            //Sub1.Subscriber_box = M1.Monitor_box;
            //S1.reset();
            fork
                D1.Drive(k2,S1.seq2driv);
                S1.In_Seq();
                M1.Detect(k2);
                Sub1.Coverage(M1.Monitor_box);
                SB1.Comp(M1.Monitor_box2);
            join_none
            //#10; $finish;
        endtask 
    endclass //Env 

endpackage

module tb(
);
    import pack1::*;
    RAM_intf intf1();
    //virtual RAM_intf vif;
    Env env1;

    Mem #(4,32) memory_inst(
        .clk(intf1.clk),
        .rst(intf1.rst),
        .W_en(intf1.W_en),
        .Address(intf1.Address),
        .Data_in(intf1.Data_in),
        .Data_out(intf1.Data_out),
        .Valid_out(intf1.Valid_out)
    );

    // Clock Signal
    always #5 intf1.clk = ~intf1.clk;
    
    initial begin
        //vif = intf1;
        env1 = new();
        env1.Operate(intf1);
    end
endmodule
