module Add_PC
(
    previous_pc,
    next_pc
);

// Interface
input   [31:0]      previous_pc;
output  [31:0]      next_pc;

// Instruction memory
assign next_pc = previous_pc + 32'b00000000000000000000000000000100; 

endmodule
