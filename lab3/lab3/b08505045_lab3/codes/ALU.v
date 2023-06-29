module ALU #(parameter Width = 32)
(
    data_1,
    data_2,
    alu_control,
    zero,
    data_o,
);

// Interface
input   signed  [31:0]          data_1;
input   signed  [31:0]          data_2;
input           [3:0]           alu_control;
output                          zero;
output  signed  [31:0]          data_o;

reg                             zero;
reg     signed  [31:0]          data_o;
// reg                             Zero;
// reg             [31:0]          minus;

always@(*) begin
    // initialize 0 to assume not branch
    zero = 1'b0;
    // calculate result
    case (alu_control)
        4'b0000 : data_o = data_1 & data_2;    // and
        4'b0111 : data_o = data_1 ^ data_2;    // xor
        4'b0101 : data_o = data_1 << data_2;   // sll
        4'b0010 : data_o = data_1 + data_2;    // add, addi, lw, sw
        4'b0110 : data_o = data_1 - data_2;    // sub
        4'b0011 : data_o = data_1 * data_2;    // mul
        4'b0001 : data_o = data_1 >>> data_2;  // srai
        4'b1110 : zero = ((data_1 - data_2) == 0) ? 1'b1 : 1'b0; // beq
    endcase
    // // calculate Zero
    // minus = data_1 - data_2;
    // Zero = (minus == 32'b0);
end

endmodule