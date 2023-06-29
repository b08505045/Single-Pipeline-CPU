module Flush_Control(
    input           IFID_branch,
    input           IDEX_branch,
    input           predict,
    input           result,
    output          IFID_flush,
    output          IDEX_flush
);

assign IFID_flush = (IFID_branch && predict) || (IDEX_branch && (predict != result));
assign IDEX_flush = (IDEX_branch && (predict != result));

endmodule