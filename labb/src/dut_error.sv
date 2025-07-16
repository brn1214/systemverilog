`timescale 1ns / 1ps	   

module opDUT_e (
	clk,
	rstn,
	addr,
	wdata,
	wr,
	rdata,
	rvalid
	);

input clk;
input rstn;
input [1:0] addr;
input [31:0] wdata;
input wr;
output reg [31:0] rdata;
output reg rvalid;

reg [1:0] modereg;
reg [31:0] operandA, operandB, result;		
bit random_bit;


`include "operation.sv"

/*//------------------------------------
function bit [31:0] operation;

input bit [31:0] opA, opB;
input bit [1:0] opcode;
input bit [1:0] mode;
reg [31:0] result;

	case (opcode) 
		2'b00: 	 result = opA+opB;
		default: result = 32'b0;
	endcase	
	
	return result;

endfunction

//-------------------------------------
*/

always @ (posedge clk or negedge rstn) begin
    if (!rstn) begin
        // Reset logic: setting default values when reset is low.
        modereg <= 2'b0;
        rdata <= 32'd0;
        rvalid <= 1'b0; 
    end 
	else begin
        // Random bit generation to simulate DUT malfunction.
        random_bit = $urandom_range(2); 

        case (addr)
            2'b00 : // Set mode / Read mode operation
                if (wr) 
                    modereg <= wdata[1:0] + random_bit; // Write with error introduced by random_bit.
                else 
                    rdata <= {30'd0, modereg[1:0]}; // Read mode register.

            2'b01 : // Write/Read Operand A
                if (wr) 
                    operandA <= {16'd0, wdata[15:0] + random_bit}; // Write operand A with error.
                else 
                    rdata <= {16'd0, operandA[15:0]}; // Read operand A.

            2'b10 : // Write/Read Operand B
                if (wr) 
                    operandB <= {16'd0, wdata[15:0] + random_bit}; // Write operand B with error.
                else 
                    rdata <= {16'd0, operandB[15:0]}; // Read operand B.

            2'b11 : // Read result operation
                if (wr) 
                    result <= operation(operandA, operandB, wdata[1:0], modereg); // Perform operation.
                else 
                    rdata <= result; // Read operation result.
        endcase

        // Set read valid signal based on write/read operation.
        rvalid <= (!wr)? 1'b1 : 1'b0; 
    end
end


endmodule
