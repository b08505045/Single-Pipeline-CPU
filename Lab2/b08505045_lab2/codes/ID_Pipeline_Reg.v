module ID_Pipeline_Reg
(   input               clk,                  
    input               rst,
    input               Write,
    input               Flush,               
    input       [31:0]  instr_in,   
    input       [31:0]  PC_in,      
    output  reg [31:0]  instr_out,
    output  reg [31:0]  PC_out
);  // output data

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        instr_out   <= 32'b0;  // reset the register to 0
        PC_out      <= 32'b0;
    end 
    else if (Write) begin
        instr_out   <= Flush? 32'b0 : instr_in;     // store the input data in the register
        PC_out      <= PC_in;
    end
end

endmodule