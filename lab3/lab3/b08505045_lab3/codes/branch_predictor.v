module branch_predictor
(
    clk_i, 
    rst_i,
    is_branch,
    result,         // result = 1 if taken (alu.zero = 1, namely data_1 == data_2)
    addr_1,         // current addr
    addr_2,         // branch addr
    predict_o,
    reserved_addr
); 

input           clk_i, rst_i, is_branch, result;
input   [31:0]  addr_1;
input   [31:0]  addr_2;

reg     [1:0]   state;

output          predict_o;
output  [31:0]  reserved_addr;
// TODO

always@(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        state <= 2'b11;
    end  
    else if (is_branch) begin
        // branch taken
        if (result == 1'b1) begin
            state <= (state == 2'b11) ? state : state + 1;
        end
        else begin
            state <= (state == 2'b00) ? state : state - 1;
        end
    end
end

assign predict_o = (state == 2'b00 || state == 2'b01) ? 0 : 1;
// not taken : reserved_addr = branch addr
assign reserved_addr = (state == 2'b00 || state == 2'b01) ? addr_2 : addr_1 + 32'b00000000000000000000000000000100;

endmodule
