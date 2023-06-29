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
// Adder PC
wire    [31:0]      Add_PC_out;
// MUX_PCSrc
wire    [31:0]      MUX_PCSrc_out;
// Instruction Memory
wire    [31:0]      instruction_memory_out;
// ID Pipeline Reg
wire    [31:0]      ID_PReg_instr_out;
wire    [31:0]      ID_PReg_PC_out;
// Adder Branch addr
wire    [31:0]      Branch_addr_out;
// Register
wire    [31:0]      reg_data_out_1;
wire    [31:0]      reg_data_out_2;
// Control
wire    [1:0]       control_aluop_out;
wire                control_alusrc_out;
wire                control_regwrite_out;
wire                control_MemtoReg_out;
wire                control_MemRead_out;
wire                control_MemWrite_out;
wire                control_Branch_out;

// Flush Control
wire                Flush_and_Hop_out;

// Hazrad Detection
wire                Hazard_PC_write_out;
wire                Hazard_IF_ID_write_out;
wire                Hazard_NoOp_out;
// sign extension
wire    [31:0]      sign_extend_out;
// EX Pipeline Reg
wire                EX_PReg_RegWrite_out;
wire                EX_PReg_MemtoReg_out;
wire                EX_PReg_MemRead_out;
wire                EX_PReg_MemWrite_out;
wire    [1:0]       EX_PReg_ALUOp_out;
wire                EX_PReg_ALUSrc_out;
wire    [31:0]      EX_PReg_data1_out;
wire    [31:0]      EX_PReg_data2_out;
wire    [31:0]      EX_PReg_immi_out;
wire    [9:0]       EX_PReg_funct_out;
wire    [4:0]       EX_PReg_Rs1_out;
wire    [4:0]       EX_PReg_Rs2_out;
wire    [4:0]       EX_PReg_Rd_out;
// 2-bit MUX 
wire    [31:0]      MUX_ForwardA_data_out;
wire    [31:0]      MUX_ForwardB_data_out;
// MUX ALUSrc
wire    [31:0]      MUX_ALUSrc_data_out;
// ALU_control
wire    [3:0]       alu_control_out;
// ALU
wire    [31:0]      alu_res_out;
// wire                alu_zero_out;

// Forwarding Unit
wire    [1:0]       forward_A_out;
wire    [1:0]       forward_B_out;
// MEM Pipeline Reg
wire                MEM_PReg_RegWrite_out;
wire                MEM_PReg_MemtoReg_out;
wire                MEM_PReg_MemRead_out;
wire                MEM_PReg_MemWrite_out;
wire    [31:0]      MEM_PReg_ALU_result_out;
wire    [31:0]      MEM_PReg_data_2_out;
wire    [4:0]       MEM_PReg_Rd_out;
// Data Mem
wire    [31:0]      data_memory_out;
// WB Pipeline Reg
wire                WB_PReg_RegWrite_out;
wire                WB_PReg_MemtoReg_out;
wire    [31:0]      WB_PReg_data_ALU_out;
wire    [31:0]      WB_PReg_data_mem_out;
wire    [4:0]       WB_PReg_Rd_out;
// MUX WB
wire    [31:0]      MUX_WB_out;

// TODO:
PC PC(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .PCWrite_i      (Hazard_PC_write_out),
    .pc_i           (MUX_PCSrc_out),
    .pc_o           (pc_out)
);

// Add_PC Add_PC(
//     .previous_pc    (pc_out),
//     .next_pc        (Add_PC_out)
// );

Adder Add_PC(
    .data_1         (pc_out),
    .data_2         (32'b00000000000000000000000000000100),
    .data_out       (Add_PC_out)
);

Adder Adder_Branch_addr(
    .data_1         (sign_extend_out << 1),
    .data_2         (ID_PReg_PC_out),
    .data_out       (Branch_addr_out)
);

MUX_1bit MUX_PCSrc(
    .data_1         (Add_PC_out),
    .data_2         (Branch_addr_out),
    .Control        (Flush_and_Hop_out),
    .data_out       (MUX_PCSrc_out)
);

Instruction_Memory Instruction_Memory(
    .addr_i         (pc_out),
    .instr_o        (instruction_memory_out)
);

ID_Pipeline_Reg ID_Pipeline_Reg(
    .clk            (clk_i),
    .rst            (rst_i),
    .Write          (Hazard_IF_ID_write_out),
    .Flush          (Flush_and_Hop_out),
    .instr_in       (instruction_memory_out),
    .PC_in          (pc_out),
    .instr_out      (ID_PReg_instr_out),
    .PC_out         (ID_PReg_PC_out)
);

Registers Registers(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .RS1addr_i      (ID_PReg_instr_out[19:15]),
    .RS2addr_i      (ID_PReg_instr_out[24:20]),
    .RDaddr_i       (WB_PReg_Rd_out),
    .RDdata_i       (MUX_WB_out),
    // .RDdata_i       (32'b00000000000000000000000000000100),
    .RegWrite_i     (WB_PReg_RegWrite_out),
    .RS1data_o      (reg_data_out_1),
    .RS2data_o      (reg_data_out_2)
);

Control Control(
    .NoOp           (Hazard_NoOp_out),
    .instr_i        (ID_PReg_instr_out[6:0]),
    .ALUOp          (control_aluop_out),
    .ALUSrc         (control_alusrc_out),
    .RegWrite       (control_regwrite_out),
    .MemtoReg       (control_MemtoReg_out),
    .MemRead        (control_MemRead_out),
    .MemWrite       (control_MemWrite_out),
    .Branch         (control_Branch_out)
);

Flush_Control Flush_Control(
    .Branch         (control_Branch_out),
    .data_1         (reg_data_out_1),
    .data_2         (reg_data_out_2),
    .Flush_and_Hop  (Flush_and_Hop_out)
);

Hazard_Detection_Unit Hazard_Detection_Unit(
    .EX_MemRead     (EX_PReg_MemRead_out),
    .EX_Rd          (EX_PReg_Rd_out),
    .ID_Rs1         (ID_PReg_instr_out[19:15]),
    .ID_Rs2         (ID_PReg_instr_out[24:20]),
    .PC_write       (Hazard_PC_write_out),
    .IF_ID_write    (Hazard_IF_ID_write_out),
    .NoOp           (Hazard_NoOp_out)
);

Sign_Extend Sign_Extend(
    .funct3         (ID_PReg_instr_out[14:12]),
    .opcode         (ID_PReg_instr_out[6:0]),
    .immi_1         (ID_PReg_instr_out[31:20]),
    .immi_2         (ID_PReg_instr_out[11:7]),
    .extend_immi    (sign_extend_out)  
);

EX_Pipeline_Reg EX_Pipeline_Reg(
    .clk                (clk_i),         
    .rst                (rst_i),
    .RegWrite_in        (control_regwrite_out),
    .MemtoReg_in        (control_MemtoReg_out),
    .MemRead_in         (control_MemRead_out),
    .MemWrite_in        (control_MemWrite_out),
    .ALUOp_in           (control_aluop_out),
    .ALUSrc_in          (control_alusrc_out),
    .data1_in           (reg_data_out_1),
    .data2_in           (reg_data_out_2),
    .immi_in            (sign_extend_out),
    .funct7_in          (ID_PReg_instr_out[31:25]),
    .funct3_in          (ID_PReg_instr_out[14:12]),
    .Rs1_in             (ID_PReg_instr_out[19:15]),
    .Rs2_in             (ID_PReg_instr_out[24:20]),
    .Rd_in              (ID_PReg_instr_out[11:7]),

    .RegWrite_out       (EX_PReg_RegWrite_out),
    .MemtoReg_out       (EX_PReg_MemtoReg_out),
    .MemRead_out        (EX_PReg_MemRead_out),
    .MemWrite_out       (EX_PReg_MemWrite_out),
    .ALUOp_out          (EX_PReg_ALUOp_out),
    .ALUSrc_out         (EX_PReg_ALUSrc_out),
    .data1_out          (EX_PReg_data1_out),
    .data2_out          (EX_PReg_data2_out),
    .immi_out           (EX_PReg_immi_out),
    .funct_out          (EX_PReg_funct_out),
    .Rs1_out            (EX_PReg_Rs1_out),
    .Rs2_out            (EX_PReg_Rs2_out),
    .Rd_out             (EX_PReg_Rd_out)
);

MUX_2bit MUX_ForwardA(
    .Control        (forward_A_out),
    .data_1         (EX_PReg_data1_out),
    .data_2         (MUX_WB_out),
    .data_3         (MEM_PReg_ALU_result_out),
    .data_out       (MUX_ForwardA_data_out)
);

MUX_2bit MUX_ForwardB(
    .Control        (forward_B_out),
    .data_1         (EX_PReg_data2_out),
    .data_2         (MUX_WB_out),
    .data_3         (MEM_PReg_ALU_result_out),
    .data_out       (MUX_ForwardB_data_out)
);

MUX_1bit MUX_ALUSrc(
    .Control        (EX_PReg_ALUSrc_out),
    .data_1         (MUX_ForwardB_data_out),
    .data_2         (EX_PReg_immi_out),
    .data_out       (MUX_ALUSrc_data_out)
);

ALU_Control ALU_Control(
    .ALUOp          (EX_PReg_ALUOp_out),
    .funct3         (EX_PReg_funct_out[2:0]),
    .funct7         (EX_PReg_funct_out[9:3]),
    .alu_control    (alu_control_out)
);

Forwarding_Unit Forwarding_Unit(
    .EX_Rs1          (EX_PReg_Rs1_out),
    .EX_Rs2          (EX_PReg_Rs2_out),
    .MEM_Rd          (MEM_PReg_Rd_out),
    .WB_Rd           (WB_PReg_Rd_out),
    .MEM_RegWrite    (MEM_PReg_RegWrite_out),
    .WB_RegWrtie     (WB_PReg_RegWrite_out),
    .forward_A       (forward_A_out),
    .forward_B       (forward_B_out)
);

ALU ALU(
    .data_1         (MUX_ForwardA_data_out),
    .data_2         (MUX_ALUSrc_data_out),
    .alu_control    (alu_control_out),
    // .Zero (alu_zero_out),
    .result         (alu_res_out)
);

MEM_Pipeline_Reg MEM_Pipeline_Reg(
    .clk            (clk_i),        
    .rst            (rst_i),
    .RegWrite_in    (EX_PReg_RegWrite_out),
    .MemtoReg_in    (EX_PReg_MemtoReg_out),
    .MemRead_in     (EX_PReg_MemRead_out),
    .MemWrite_in    (EX_PReg_MemWrite_out),
    .ALU_result_in  (alu_res_out),
    .data_2_in      (MUX_ForwardB_data_out),
    .Rd_in          (EX_PReg_Rd_out),

    .RegWrite_out   (MEM_PReg_RegWrite_out),
    .MemtoReg_out   (MEM_PReg_MemtoReg_out),
    .MemRead_out    (MEM_PReg_MemRead_out),
    .MemWrite_out   (MEM_PReg_MemWrite_out),
    .ALU_result_out (MEM_PReg_ALU_result_out),
    .data_2_out     (MEM_PReg_data_2_out),
    .Rd_out         (MEM_PReg_Rd_out)
);

Data_Memory Data_Memory(
    .clk_i          (clk_i),
    .addr_i         (MEM_PReg_ALU_result_out),
    .MemRead_i      (MEM_PReg_MemRead_out),
    .MemWrite_i     (MEM_PReg_MemWrite_out),
    .data_i         (MEM_PReg_data_2_out),
    .data_o         (data_memory_out)
);

WB_Pipeline_Reg WB_Pipeline_Reg(
    .clk            (clk_i),         
    .rst            (rst_i),
    .RegWrite_in    (MEM_PReg_RegWrite_out),
    .MemtoReg_in    (MEM_PReg_MemtoReg_out),
    .data_ALU_in    (MEM_PReg_ALU_result_out),
    .data_mem_in    (data_memory_out),
    .Rd_in          (MEM_PReg_Rd_out),

    .RegWrite_out   (WB_PReg_RegWrite_out),
    .MemtoReg_out   (WB_PReg_MemtoReg_out),
    .data_ALU_out   (WB_PReg_data_ALU_out),
    .data_mem_out   (WB_PReg_data_mem_out),
    .Rd_out         (WB_PReg_Rd_out)
);

MUX_1bit MUX_WB(
    .Control        (WB_PReg_MemtoReg_out),
    .data_1         (WB_PReg_data_ALU_out),
    .data_2         (WB_PReg_data_mem_out),
    .data_out       (MUX_WB_out)
);

endmodule

