											//------------------------------------
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
