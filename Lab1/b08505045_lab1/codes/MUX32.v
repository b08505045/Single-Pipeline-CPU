module MUX32
(
    data_1,
    data_2,
    Control,
    data_out
);

// Interface
input   [31:0]      data_1;
input   [31:0]      data_2;
input               Control;
output  [31:0]      data_out;

reg     [31:0]      data_out;

always@(*) begin
    case (Control)
        1'b0 : data_out = data_1;
        1'b1 : data_out = data_2;
    endcase
end

endmodule
