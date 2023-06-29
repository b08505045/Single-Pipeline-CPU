module WB_Pipeline_Reg
(   input                   clk,
    input                   rst,
    input                   RegWrite_in,
    input                   MemtoReg_in,
    input           [31:0]  data_ALU_in,
    input           [31:0]  data_mem_in,
    input           [4:0]   Rd_in,

    output  reg             RegWrite_out,
    output  reg             MemtoReg_out,
    output  reg     [31:0]  data_ALU_out,
    output  reg     [31:0]  data_mem_out,
    output  reg     [4:0]   Rd_out
);  // output data

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        RegWrite_out        <= 1'b0;
        MemtoReg_out        <= 1'b0;
        data_ALU_out        <= 32'b0;
        data_mem_out        <= 32'b0;
        Rd_out              <= 32'b0;
    end else begin
        RegWrite_out        <= RegWrite_in;
        MemtoReg_out        <= MemtoReg_in;
        data_ALU_out        <= data_ALU_in;
        data_mem_out        <= data_mem_in;
        Rd_out              <= Rd_in;
    end
end

endmodule