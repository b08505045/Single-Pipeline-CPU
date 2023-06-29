module ALU #(parameter Width = 32)
(
    data_1,
    data_2,
    alu_control,
    result,
    // Zero
);

// Interface
input   signed  [31:0]          data_1;
input   signed  [31:0]          data_2;
input           [3:0]           alu_control;
output  signed  [31:0]          result;
// output                          Zero;

reg     signed  [31:0]          result;
// reg                             Zero;
// reg             [31:0]          minus;

always@(*) begin
    // calculate result
    case (alu_control)
        4'b0000 : result = data_1 & data_2;    // and
        4'b0111 : result = data_1 ^ data_2;    // xor
        4'b0101 : result = data_1 << data_2;   // sll
        4'b0010 : result = data_1 + data_2;    // add, addi, lw, sw
        4'b0110 : result = data_1 - data_2;    // sub. beq
        4'b0011 : result = data_1 * data_2;    // mul
        4'b0001 : result = data_1 >>> data_2;  // srai
    endcase
    // // calculate Zero
    // minus = data_1 - data_2;
    // Zero = (minus == 32'b0);
end

endmodule