module MEM_Pipeline_Reg
(   input                   clk,
    input                   rst,
    input                   RegWrite_in,
    input                   MemtoReg_in,
    input                   MemRead_in,
    input                   MemWrite_in,
    input           [31:0]  ALU_result_in,
    input           [31:0]  data_2_in,
    input           [4:0]   Rd_in,

    output  reg             RegWrite_out,
    output  reg             MemtoReg_out,
    output  reg             MemRead_out,
    output  reg             MemWrite_out,
    output  reg     [31:0]  ALU_result_out,
    output  reg     [31:0]  data_2_out,
    output  reg     [4:0]   Rd_out
);  // output data

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        RegWrite_out        <= 1'h0;
        MemtoReg_out        <= 1'h0;
        MemRead_out         <= 1'h0;
        MemWrite_out        <= 1'h0;
        ALU_result_out      <= 32'h0;
        data_2_out          <= 32'h0;
        Rd_out              <= 32'h0;
    end 
    else begin
        RegWrite_out        <= RegWrite_in;
        MemtoReg_out        <= MemtoReg_in;
        MemRead_out         <= MemRead_in;
        MemWrite_out        <= MemWrite_in;
        ALU_result_out      <= ALU_result_in;
        data_2_out          <= data_2_in;
        Rd_out              <= Rd_in;
    end
end

endmodule