module ID_EX
(   input                   clk,         
    input                   rst,
    input                   flush_i,          // Flush
    input                   RegWrite_in,
    input                   MemtoReg_in,
    input                   MemRead_in,
    input                   MemWrite_in,
    input           [1:0]   ALUOp_in,
    input                   ALUSrc_in,
    input                   Branch_in,      // branch predictor at EX stage
    input           [31:0]  addr_in,
    input           [31:0]  data1_in,
    input           [31:0]  data2_in,
    input           [31:0]  immi_in,
    input           [6:0]   funct7_in,
    input           [2:0]   funct3_in,
    input           [4:0]   Rs1_in,
    input           [4:0]   Rs2_in,
    input           [4:0]   Rd_in,

    output  reg             RegWrite_out,
    output  reg             MemtoReg_out,
    output  reg             MemRead_out,
    output  reg             MemWrite_out,
    output  reg     [1:0]   ALUOp_out,
    output  reg             ALUSrc_out, 
    output  reg             Branch_o,     // branch predictor at EX stage
    output  reg     [31:0]  addr_out,
    output  reg     [31:0]  data1_out,
    output  reg     [31:0]  data2_out,
    output  reg     [31:0]  immi_out,
    output  reg     [9:0]   funct_out,
    output  reg     [4:0]   Rs1_out,
    output  reg     [4:0]   Rs2_out,
    output  reg     [4:0]   Rd_out

);  // output data

always @(posedge clk or negedge rst) begin
    if (~rst || flush_i) begin
        RegWrite_out        <= 1'b0;
        MemtoReg_out        <= 1'b0;
        MemRead_out         <= 1'b0;
        MemWrite_out        <= 1'b0;
        ALUOp_out           <= 2'b0;
        ALUSrc_out          <= 1'b0;
        Branch_o            <= 1'b0;
        addr_out            <= 32'b0;
        data1_out           <= 32'b0;
        data2_out           <= 32'b0;
        immi_out            <= 32'b0;
        funct_out           <= 10'b0;
        Rs1_out             <= 5'b0;
        Rs2_out             <= 5'b0;
        Rd_out              <= 5'b0;
    end 
    else begin
        RegWrite_out        <= RegWrite_in;
        MemtoReg_out        <= MemtoReg_in;
        MemRead_out         <= MemRead_in;
        MemWrite_out        <= MemWrite_in;
        ALUOp_out           <= ALUOp_in;
        ALUSrc_out          <= ALUSrc_in;
        Branch_o            <= Branch_in;
        addr_out            <= addr_in;
        data1_out           <= data1_in;
        data2_out           <= data2_in;
        immi_out            <= immi_in;
        funct_out           <= {funct7_in, funct3_in};
        Rs1_out             <= Rs1_in;
        Rs2_out             <= Rs2_in;
        Rd_out              <= Rd_in;
    end
end

endmodule