module Flush_Control(
    input           Branch,
    input   [31:0]  data_1,
    input   [31:0]  data_2,
    output  Flush_and_Hop
);

assign Flush_and_Hop = ((data_1 ^ data_2) == 32'b0 && Branch == 1) ? 1 : 0;

endmodule