module MUX_2bit
(
    Control,
    data_1,
    data_2,
    data_3,
    data_out
);

// Interface
input       [1:0]       Control;
input       [31:0]      data_1;
input       [31:0]      data_2;
input       [31:0]      data_3;
output  reg [31:0]      data_out;

always@(*) begin
    case (Control)
        2'b00 : data_out = data_1;
        2'b01 : data_out = data_2;
        2'b10 : data_out = data_3;
    endcase
end

endmodule
