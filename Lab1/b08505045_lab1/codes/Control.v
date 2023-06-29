module Control
(
    instr_i,
    ALUOp,
    ALUSrc,
    RegWrite
);

input   [6:0]   instr_i;
output  [1:0]   ALUOp;
output          ALUSrc;
output          RegWrite;

reg             ALUOp;
reg             ALUSrc;
reg             RegWrite;

always@(*) begin
    // r-type
    if (instr_i == 7'b0110011) begin
        ALUOp = 2'b10;
        ALUSrc = 1'b0;
        RegWrite = 1'b1;
    end
    // i-type
    else if (instr_i == 7'b0010011) begin
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        RegWrite = 1'b1;        // only addi, srai
    end
end

endmodule