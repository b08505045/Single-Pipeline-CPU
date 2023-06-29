module ALU #(parameter Width = 32)
(
    data_1,
    data_2,
    alu_control,
    result,
    Zero
);

// Interface
input   [31:0]          data_1;
input   [31:0]          data_2;
input   [2:0]           alu_control;
output  signed [31:0]   result;
output                  Zero;

reg     signed [31:0]   result;
reg                     Zero;

reg     [31:0]          minus;

always@(*) begin
    // calculate result
    case (alu_control)
        3'b000 : result = data_1 & data_2;    // and
        3'b111 : result = data_1 ^ data_2;    // xor
        3'b101 : result = data_1 << data_2;   // sll
        3'b010 : result = data_1 + data_2;    // add
        3'b110 : result = data_1 - data_2;    // sub
        3'b011 : result = data_1 * data_2;    // mul
        3'b100 : result = data_1 + data_2;    // addi
        3'b001 : result = data_1 >>> data_2;  // srai
    endcase
    // calculate Zero
    minus = data_1 - data_2;
    Zero = (minus == 32'b0);
end

endmodule