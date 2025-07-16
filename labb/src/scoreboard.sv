class scoreboard;
    // Mailbox for receiving transactions from other components.
    mailbox #(transaction) mbx;

    // Configuration object to store settings relevant to the scoreboard.
    cfg conf;

    // Transaction objects for holding incoming (data_in) and expected (data_out) data.
    transaction data_in, data_out;

    // Flag to indicate when the scoreboard has completed its tasks.
    bit done;

    // Registers to store mode, operand values, and the expected result.
    reg [1:0] modereg;
    reg [31:0] operandA, operandB, result;	

    // Counters to track the number of matching transactions and errors.
    int match, error;

    // Task to compare transactions a specified number of times ('conf.amount') 
    // and then set the 'done' bit.
    virtual task run();
        repeat(conf.amount) begin	
            compare(); // Call 'compare' task for each transaction.
        end
        done = 1; // Set 'done' flag after all comparisons are complete.
    endtask
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
    // Task to fetch and compare transactions, handling one-cycle delay in the design.
    virtual task compare();
        mbx.get(data_out); // Get a transaction from the mailbox.

        case (data_out.addr)
            2'b00 : // Mode Register Read Operations
                if (data_out.wr && !data_out.rvalid)  
                    modereg = data_out.wdata [1:0]; // Read mode register.
                else if (!data_out.wr && data_out.rvalid)
                    compare_trans(modereg, "mod"); // Compare mode register data.
                    
            2'b01 : // Operand A Read/Write Operations
                if (data_out.wr && !data_out.rvalid)  
                    operandA = {16'd0, data_out.wdata [15:0]}; // Read operand A.
                else if (!data_out.wr && data_out.rvalid)
                    compare_trans(operandA, "opA"); // Compare operand A data.
                    
            2'b10 : // Operand B Read/Write Operations
                if (data_out.wr && !data_out.rvalid)  
                    operandB = {16'd0, data_out.wdata [15:0]}; // Read operand B.
                else if (!data_out.wr && data_out.rvalid)
                    compare_trans(operandB, "opB"); // Compare operand B data.
                    
            2'b11 : // Sum Operation
                if (data_out.wr && !data_out.rvalid)  
                    result = sum(operandA, operandB); // Calculate sum of operands A and B.
                else if (!data_out.wr && data_out.rvalid)
                    compare_trans(result, "*SUM*"); // Compare sum operation result.
        endcase
    endtask	

    // Function to compare transaction data and print the result.
    virtual function void compare_trans(bit [31:0] comp, string nom);
        if(data_out != null) begin
            if( data_out.rdata != comp ) begin
                // Print error message if the data doesn't match.
                $display("ERROR: %s Real: %0d != Expected: %0d, Time: %t",
                nom, data_out.rdata, comp, $time());
                error += 1;
            end
            else begin
                // Print success message if the data matches.
                $display("GOOD: %s Real: %0d == Expected: %0d, Time: %t",
                nom, data_out.rdata, comp, $time());
                match += 1;
            end
        end
    endfunction       

    // Function to calculate the sum of two operands.
    virtual function bit [31:0] sum(bit [31:0] operandA, bit [31:0] operandB);
        result = operandA + operandB; // Calculate the sum.
        return result; // Placeholder for the sum calculation.
    endfunction  
    
endclass
