module Sign_Extend
(
    funct3,
    opcode,
    immi_1,     // instr[31:20]
    immi_2,     // instr[11:7]
    extend_immi
);

// Interface
input          [2:0]       funct3;
input          [6:0]       opcode;
input   signed [11:0]      immi_1;
input   signed [4:0]       immi_2;
output  signed [31:0]      extend_immi;

reg     signed [31:0]      extend_immi;

always@(*) begin
    // addi or lw
    if ((funct3 == 3'b000 && opcode == 7'b0010011) || opcode == 7'b0000011) begin
        extend_immi = {{20{immi_1[11]}}, immi_1};
    end
    // srai
    else if (funct3 == 3'b101) begin
        extend_immi = {{27{immi_1[4]}}, immi_1[4:0]};
    end
    // sw
    else if (opcode == 7'b0100011) begin
        extend_immi = {{20{immi_1[11]}}, immi_1[11:5], immi_2};
    end
    // beq
    else if (opcode == 7'b1100011) begin
        extend_immi = {{20{immi_1[11]}}, immi_1[11], immi_2[0], immi_1[10:5], immi_2[4:1]};
    end
end

endmodule
