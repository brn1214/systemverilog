class generator;	
	
    // TODO: declare mailbox parameterized with 'transaction' type and 'mbx' name
    mailbox #(transaction) mbx;

    // TODO: declare 'conf' field with 'cfg' type
    cfg conf;


    // TODO: declare 'data' field with 'transaction' type
    transaction data;

    // TODO: create virtual 'run()' task
    // Task must call 'gen()' 'conf.amount' times
    // Use 'repeat'
    virtual task run();
        repeat(conf.amount) begin
            gen();
        end
    endtask

	// This task generates a sequence of transactions with varying values to interact with the DUT.
	
	virtual task gen();
	    // Set mode with a random value, then read the default.
	    generate_transaction(2'b00, $random() & 2'b11, 1'b1); // Set mode to a random value.
	    generate_transaction(2'b00, 2'b00, 1'b0);             // Read the value.
	
	    // Write a random value to operand A, then read it.
	    generate_transaction(2'b01, $random() & 16'hFFFF, 1'b1); // Write random value to operand A.
	    generate_transaction(2'b01, 32'd0, 1'b0);                // Read operand A.
	
	    // Write a random value to operand B, then read it.
	    generate_transaction(2'b10, $random() & 16'hFFFF, 1'b1); // Write random value to operand B.
	    generate_transaction(2'b10, 32'd0, 1'b0);                // Read operand B.
	
	    // Trigger operation and read the result.
	    generate_transaction(2'b11, 32'd0, 1'b1); // Trigger operation.
	    generate_transaction(2'b11, 32'd0, 1'b0); // Read the result.			  
	endtask
	
	// Helper method to generate and send a transaction.
	virtual task generate_transaction(bit [1:0] addr, bit [31:0] wdata, bit wr);
	    data = new();
	    data.addr = addr;   // Set the address field of the transaction.
	    data.wdata = wdata; // Set the write data field of the transaction.
	    data.wr = wr;       // Set the write/read control bit.
	    mbx.put(data);      // Send the transaction through the mailbox.
	endtask
		

endclass	  



