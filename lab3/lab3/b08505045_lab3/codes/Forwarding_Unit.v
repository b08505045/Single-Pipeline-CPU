module Forwarding_Unit
(
    input       [4:0]   EX_Rs1,
    input       [4:0]   EX_Rs2,
    input       [4:0]   MEM_Rd,
    input       [4:0]   WB_Rd,
    input               MEM_RegWrite,
    input               WB_RegWrtie,
    output  reg [1:0]   forward_A, 
    output  reg [1:0]   forward_B
);

always@(*) begin
    // EX hazard
    if (MEM_RegWrite && (MEM_Rd != 5'b0) && (MEM_Rd == EX_Rs1)) begin
        forward_A = 2'b10;
    end

    else if (WB_RegWrtie && (WB_Rd != 5'b0) && (WB_Rd == EX_Rs1)) begin
        forward_A = 2'b01;
    end

    else begin
        forward_A = 2'b00;
    end

    if (MEM_RegWrite && (MEM_Rd != 5'b0) && (MEM_Rd == EX_Rs2)) begin
        forward_B = 2'b10;
    end

    else if (WB_RegWrtie && (WB_Rd != 5'b0) && (WB_Rd == EX_Rs2)) begin
        forward_B = 2'b01;
    end
    else begin
        forward_B = 2'b00;
    end 
end

endmodule