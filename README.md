# Memory RTL Design and Verification

The plan is intended to test the functionality and performance of a memory array with 16 words, each having 32 bits.

The RAM RTL is designed using Verilog, and is tested by implementing class-based and UVM-based verification environments in System-Verilog using constrained randomization approach. The functional coverage of the design is explored in a subscriber class.

# Input/Output Ports
•	Input ports:
1.	Data_in (32 bits): specifies the input word to be written in an address-specified row inside the memory.
2.	Address (4 bits): specifies the row to be written in by Data_in, or to be read in Data_out. The 4 bits have 16 possible combinations, each corresponding to one row.
3.	W_en (1 bit): enables the write operation if high.
4.	Clk (1 bit): the global clock with a positive active edge.
5.	Rst (1 bit): an asynchronous active-low reset signal. When enabled, it resets all the memory content, and Data_out to zeros.

•	Output Ports:
1.	Data_out (32 bits): the data read from the address-specified inside the memory.
2.	Valid_out (1 bit): determine the validity of the Data_out. If the operation is read, Data_out is valid (high signal). While if the operation is write (W_en activated), Data_out is invalid (low signal).

# Test Sequences
In the UVM environment, the main sequence consists of reset, read, and write sequences sent sequentially and repeated multiple times. At each read or write sequence, the number of sent transactions is randomized between 1 to 6. Simulation ends when either all sequences are processed through the UVM hierarchy, or the scoreboard detects 20 outputs matching with the reference data during read operations.

While in the class-based environment, a single sequence is defined, in which 33 transactions are injected to the DUT. The first one is a reset transaction, followed by 16 write transactions during which all addresses are filled with random data. Finally, all addresses are read during the following 16 read transactions, and output data is compared with the reference data.
