module ALU_Control
(
    ALUOp,
    funct3,
    funct7,
    alu_control
);

// Interface
input   [1:0]       ALUOp;
input   [6:0]       funct7;
input   [2:0]       funct3;
output  [2:0]       alu_control;    // currently total 8 instructions => 3 control bits

reg     [2:0]       alu_control;

always@(*) begin
    case(ALUOp)
        // r-type
        2'b10 : case(funct7)
            7'b0000000 : case(funct3)
                3'b111 : alu_control = 3'b000;      // and
                3'b100 : alu_control = 3'b111;      // xor
                3'b001 : alu_control = 3'b101;      // sll
                3'b000 : alu_control = 3'b010;      // add
            endcase
            7'b0100000 : alu_control = 3'b110;      // sub
            7'b0000001 : alu_control = 3'b011;      // mul
        endcase
        // i-type
        2'b00 : case(funct3)
            3'b000 : alu_control = 3'b100;          // addi
            3'b101 : alu_control = 3'b001;          // srai
        endcase
    endcase
end

endmodule
