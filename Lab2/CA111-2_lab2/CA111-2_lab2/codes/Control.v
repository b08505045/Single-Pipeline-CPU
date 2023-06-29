module Control
(
    NoOp,
    instr_i,
    ALUOp,
    ALUSrc,
    RegWrite,
    MemtoReg,
    MemRead,
    MemWrite,
    Branch
);

input           NoOp;
input   [6:0]   instr_i;
output  [1:0]   ALUOp;
output          ALUSrc;
output          RegWrite;
output          MemtoReg;
output          MemRead;
output          MemWrite;
output          Branch;

reg  [1:0]      ALUOp;
reg             ALUSrc;
reg             RegWrite;
reg             MemtoReg;
reg             MemRead;
reg             MemWrite;
reg             Branch;

always@(*) begin
    // no instruction
    if (instr_i == 7'b0) begin
        ALUOp = 2'b00;
        ALUSrc = 1'b0;
        RegWrite = 1'b0;
        MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
    end
    // NoOp
    if (NoOp == 1'b1) begin
        ALUOp = 2'b00;
        ALUSrc = 1'b0;
        RegWrite = 1'b0;
        MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
    end
    // r-type
    else if (instr_i == 7'b0110011) begin
        ALUOp = 2'b10;
        ALUSrc = 1'b0;
        RegWrite = 1'b1;
        MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
    end
    // immediate
    else if (instr_i == 7'b0010011) begin
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        RegWrite = 1'b1;        // only addi, srai
        MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
    end
    // lw
    else if (instr_i == 7'b0000011) begin
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        RegWrite = 1'b1;
        MemtoReg = 1'b1;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        Branch = 1'b0;
    end
    // sw
    else if (instr_i == 7'b0100011) begin
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        RegWrite = 1'b0;
        // MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b1;
        Branch = 1'b0;
    end
    // beq
    else if (instr_i == 7'b1100011) begin
        ALUOp = 2'b01;
        ALUSrc = 1'b0;
        RegWrite = 1'b0;
        // MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b1;
    end
end

endmodule