`include "PC.v"
`include "Instruction_Memory.v"
`include "Registers.v"
`include "Control.v"
`include "Add_PC.v"
`include "MUX32.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "ALU_Control.v"

module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

// PC
wire    [31:0]      pc_out;
// Instruction Memory
wire    [31:0]      instruction_memory_out;
// Register
wire    [31:0]      reg_data_out_1;
wire    [31:0]      reg_data_out_2;
// Control
wire    [1:0]       control_aluop_out;
wire                control_alusrc_out;
wire                control_regwrite_out;
// ALU_control
wire    [2:0]       alu_control_out;
// ALU
wire    [31:0]      alu_res_out;
wire                alu_zero_out; 
// adder
wire    [31:0]      Add_PC_out;
// sign extension
wire    [31:0]      sign_extend_out;  
// mux 
wire    [31:0]      MUX32_out;

// TODO:
PC PC(
    .clk_i (clk_i),
    .rst_i (rst_i),
    .pc_i (Add_PC_out),
    .pc_o (pc_out)
);

Add_PC Add_PC(
    .previous_pc (pc_out),
    .next_pc (Add_PC_out)
);

Instruction_Memory Instruction_Memory(
    .addr_i (pc_out),
    .instr_o (instruction_memory_out)
);

Registers Registers(
    .clk_i (clk_i),
    .rst_i (rst_i),
    .RS1addr_i (instruction_memory_out[19:15]),
    .RS2addr_i (instruction_memory_out[24:20]),
    .RDaddr_i (instruction_memory_out[11:7]),
    .RDdata_i (alu_res_out),
    .RegWrite_i(control_regwrite_out),
    .RS1data_o (reg_data_out_1),
    .RS2data_o (reg_data_out_2)
);

Control Control(
    .instr_i (instruction_memory_out[6:0]),
    .ALUOp (control_aluop_out),
    .ALUSrc (control_alusrc_out),
    .RegWrite (control_regwrite_out)
);

ALU_Control ALU_Control(
    .ALUOp (control_aluop_out),
    .funct3 (instruction_memory_out[14:12]),
    .funct7 (instruction_memory_out[31:25]),
    .alu_control (alu_control_out)
);

ALU ALU(
    .data_1 (reg_data_out_1),
    .data_2 (MUX32_out),
    .alu_control (alu_control_out),
    .Zero (alu_zero_out),
    .result (alu_res_out)
);

MUX32 MUX_ALUSrc(
    .data_1 (reg_data_out_2),
    .data_2 (sign_extend_out),
    .Control (control_alusrc_out),
    .data_out (MUX32_out)
);

Sign_Extend Sign_Extend(
    .funct3 (instruction_memory_out[14:12]),
    .immi (instruction_memory_out[31:20]),
    .extend_immi (sign_extend_out)  
);

endmodule

