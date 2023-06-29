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
output  [3:0]       alu_control;    // currently total 8 instructions => 3 control bits

reg     [3:0]       alu_control;

always@(*) begin
    case(ALUOp)
        // r-type
        2'b10 : case(funct7)
            7'b0000000 : case(funct3)
                3'b111 : alu_control = 4'b0000;      // and
                3'b100 : alu_control = 4'b0111;      // xor
                3'b001 : alu_control = 4'b0101;      // sll
                3'b000 : alu_control = 4'b0010;      // add
            endcase
            7'b0100000 : alu_control = 4'b0110;      // sub
            7'b0000001 : alu_control = 4'b0011;      // mul
        endcase
        // i-type, lw, sw
        2'b00 : 
            // srai
            if (funct3 == 3'b101) begin
                alu_control = 4'b0001;
            end
            // addi, lw, sw
            else begin 
                alu_control = 4'b0010;  // add
            end
        // beq
        2'b01 : alu_control = 4'b1110;  // beq
    endcase
end

endmodule
