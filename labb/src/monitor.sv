class monitor;
    // Mailbox parameterized with 'transaction' type for communication with other components.
    mailbox #(transaction) mbx;

    // 'data' field of type 'transaction' to hold the monitored transaction data.
    transaction data;

    // Virtual interface of type 'sum_if' to monitor the signals in the DUT.
    virtual sum_if vif;	

    // Virtual 'run' task to continuously monitor the interface signals.
    virtual task run();
        forever @(posedge vif.clk) begin  
            collect(); // Call 'collect' task at every positive clock edge.

        end
    endtask

    // Task to collect transaction data from the interface and pass it to the mailbox.
    virtual task automatic collect();
        data = new(); // Instantiate a new transaction object.
        // Collect data from the interface signals.
        data.addr = vif.addr;
        data.wdata = vif.wdata;
        data.wr = vif.wr;
        data.rdata = vif.rdata;
        data.rvalid = vif.rvalid;
        mbx.put(data); // Send the transaction data to the mailbox.
 
    endtask
endclass
