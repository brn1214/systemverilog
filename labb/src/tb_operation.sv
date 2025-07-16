`include "interface.sv"

module tb_operation();

    // Including various SystemVerilog files containing definitions of configuration, 
    // transaction structures, driver, monitor, generator, scoreboard, environment, and test.
    `include "cfg.sv"
    `include "transaction.sv"
    `include "driver.sv"
    `include "monitor.sv"
    `include "generator.sv"
    `include "scoreboard.sv"
    `include "env.sv"
    `include "test.sv"

    // Declaration of the test class instance.
    test t0;

    // Clock signal declaration.
    reg clk;
    // Clock signal generation: toggling every 10 time units.
    always #10 clk = ~clk;

    // Instantiation of the interface 'sum_if' with the clock signal.
    sum_if sum_iff(clk);
    // Creation of a virtual interface pointing to the instantiated interface.
    virtual sum_if sum_vif = sum_iff;

    // Instantiation of the Design Under Test (DUT).
    // Uncomment 'opDUT dut' line for a different DUT instantiation.
		
	//opDUT_e dut ( 			// DUT with error 
	opDUT dut (			// DUT without error
        .clk(clk),
        .rstn(sum_iff.rstn),
        .addr(sum_iff.addr),
        .wdata(sum_iff.wdata),
        .wr(sum_iff.wr),
        .rdata(sum_iff.rdata),
        .rvalid(sum_iff.rvalid)
    );

    // Initial block for clock generation and test execution.
    initial begin
        clk = 1'b0; // Initial clock state.

        // Instantiate and run the test.
        t0 = new(sum_vif);
        t0.run();
    end
endmodule


