`timescale 1ns / 1ps	   

module opDUT (
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

always @ (posedge clk or negedge rstn)
begin
  if (!rstn)
	  begin
	  	modereg <= 2'b0;
	  	rdata <= 32'd0;
	  	rvalid <= 1'b0; 
	  end
  else

	begin
		//$display("Entra en el dut");	
	  	case (addr)
	
		  2'b00 :	//Set mode/ Read mode
			if (wr) 
				modereg <= wdata [1:0];
			else 
		  		rdata <= {30'd0,modereg[1:0]};
		
		  2'b01 :	//Write/Read Operand A
			if (wr) 
				operandA <= {16'd0, wdata [15:0]};
			else 
		  		rdata <= {16'd0, operandA[15:0]};
				  
		  2'b10 :	//Write/Read Operand B
			if (wr) 
				operandB <= {16'd0, wdata [15:0]};
			else 
		  		rdata <= {16'd0, operandB[15:0]};
				  
		  2'b11 :	//Read result
			if (wr) 
						result <= operation (operandA, operandB, wdata [1:0], modereg);
			else 
				rdata <= result;
		
		endcase	   
		
			
  		rvalid <= (!wr)? 1'b1 : 1'b0;	//read data is ready			
  
  	end
end

endmodule
