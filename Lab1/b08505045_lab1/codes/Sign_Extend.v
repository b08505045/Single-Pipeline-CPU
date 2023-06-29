module Sign_Extend
(
    funct3,
    immi,
    extend_immi
);

// Interface
input          [2:0]       funct3;
input   signed [11:0]      immi;
output  signed [31:0]      extend_immi;

reg     signed [31:0]      extend_immi;

always@(*) begin
    // addi
    if (funct3 == 3'b000) begin
        extend_immi = {{20{immi[11]}}, immi};
    end
    // srai
    else if (funct3 == 3'b101) begin
        extend_immi = {{20{immi[4]}}, immi[4:0]};
    end
end

endmodule
