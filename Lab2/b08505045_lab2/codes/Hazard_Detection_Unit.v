module Hazard_Detection_Unit
(
    input          EX_MemRead,
    input   [4:0]  EX_Rd,
    input   [4:0]  ID_Rs1,
    input   [4:0]  ID_Rs2,
    output  reg    PC_write,
    output  reg    IF_ID_write,
    output  reg    NoOp
);

always@(*) begin
    // hazard
    if (EX_MemRead && EX_Rd != 5'b0 && (EX_Rd == ID_Rs1 || EX_Rd == ID_Rs2)) begin
        PC_write = 1'b0;
        IF_ID_write = 1'b0;
        NoOp = 1'b1; 
    end
    // normal
    else begin
        PC_write = 1'b1;
        IF_ID_write = 1'b1;
        NoOp = 1'b0; 
    end
end

endmodule