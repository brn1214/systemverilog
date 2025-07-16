// Interface definition 'sum_if' for communication with the DUT (Device Under Test).
interface sum_if(input logic clk); 

    // Interface signals
    logic [1:0] addr;   // 2-bit address signal
    logic [31:0] wdata; // 32-bit data signal for write the operand.
    logic wr;           // Write enable signal, indicating a write operation when high.
    logic [31:0] rdata; // 32-bit data signal for read the operand.
    logic rvalid;       // Read valid signal, indicating valid data available at 'rdata'.
    logic rstn;         // Active low reset signal.

endinterface
