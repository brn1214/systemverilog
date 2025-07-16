class driver;
    // Define a mailbox parameterized with 'transaction' type. 
    mailbox #(transaction) mbx;

	 // Declare a configuration object 'conf' of type 'cfg'.
    cfg conf;

    // Declare a 'data' object of type 'transaction'.
    transaction data;

    // Declare a virtual interface of type 'sum_if'.
    virtual sum_if vif;

    // Define a virtual task 'run'.
    // This task is responsible for the continuous operation of the driver.
    virtual task run();
        forever begin
            // Wait for the positive edge of the clock signal in the interface.
            @(posedge vif.clk);
            // Repeat the action for 'latency - 1' number of clock cycles.
            // This introduces a delay based on the configured latency.
            repeat(conf.latency - 1) @(posedge vif.clk);
            // Call the 'drive' task to drive a transaction.
            drive(); 

        end
    endtask

    // Define a task 'drive' to fetch a transaction from the mailbox 
    // and drive it onto the interface.
    virtual task automatic drive();
        // Retrieve a transaction from the mailbox.
        mbx.get(data);
        // Drive the transaction signals onto the interface.
        // The address, write data, and write enable signals are set
        // according to the transaction data.
        vif.addr <= data.addr;
        vif.wdata <= data.wdata;
        vif.wr <= data.wr;

        // Wait for a clock cycle to simulate the write/read operation in the DUT.
        @(posedge vif.clk);
    endtask

endclass
