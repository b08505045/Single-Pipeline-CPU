module Adder
(
    data_1,
    data_2,
    data_out
);

// Interface    
input   [31:0]      data_1;
input   [31:0]      data_2;
output  [31:0]      data_out;

// Instruction memory
// assign next_pc = previous_pc + 32'b00000000000000000000000000000100; 
assign data_out = data_1 + data_2;

endmodule