class transaction;
    // Define transaction variables to simulate interactions with the DUT (Device Under Test).

    bit [1:0] addr;   // 2-bit address or operation mode.
    bit [31:0] wdata; // 32-bit data for write operations.
    bit wr;           // 1-bit write enable signal.

    bit [31:0] rdata; // 32-bit data for read operations.
    bit rvalid;       // Read valid signal indicating if read data is valid.

    // Method to print detailed information about the transaction.
    function void display_transaction(string c);
        $display("Transaction %s - Addr: %0b, Wdata: %0d, Wr: %0b, Rdata: %0d, rvalid: %0b Time: %t", c, addr, wdata, wr, rdata, rvalid, $time());
    endfunction
     
endclass
 