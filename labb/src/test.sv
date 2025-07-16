class test;

    // TODO: declare 'conf' field with 'cfg' type
    // TODO: declare 'environment' variable with 'env' type
    cfg conf;
    env environment; 
	int num = 10;

    // Contructor will create configuration
    // and create environment

    function new(virtual sum_if vif);
        create_conf();
        environment = new(conf, vif);
		
    endfunction

    // Create configuration

    virtual function void create_conf();
        conf = new();
        conf.latency = 1;
        conf.amount = (num*16)+1;
    endfunction

    // Run environment and wait for test done

    // Task to run the environment and wait for the test to complete.
    virtual task run();
        environment.run(); // Start running the environment.
        wait(environment.scb.done); // Wait until the scoreboard signals that it's done.

        // Display the simulation results.
        $display("\n***SIMULATION COMPLETE***");
        $display("Total number of scoreboard matches: %d", environment.scb.match);
        $display("Total number of scoreboard errors: %d", environment.scb.error);
        $finish; // End the simulation.
    endtask

endclass

 