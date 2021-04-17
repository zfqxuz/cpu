module control(input wire [5:0] op,output wire [9:0] CTR);
reg[9:0] ctr;
reg [4:0] sig;
    always@(op) begin
        sig[4]=(~op[5]&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0]));
        sig[3]=(op[5]&(~op[4])&(~op[3])&(~op[2])&(op[1])&(op[0]));
        sig[2]=(op[5]&(~op[4])&(op[3])&(~op[2])&(op[1])&(op[0]));
        sig[1]=(~op[5]&(~op[4])&(~op[3])&(op[2])&(~op[1])&(~op[0]));
        sig[0]=(~op[5]&(~op[4])&(~op[3])&(~op[2])&(op[1])&(~op[0]));

//        assign ctr[9]=sig[4];//regdst
//        ctr[8]=sig[3]|sig[2];//alusrc
//        ctr[7]=sig[4];//aluop[1]
//        ctr[6]=sig[1];//aluop[0]
//        ctr[5]=sig[1];//branch
//        ctr[4]=sig[0];//jump
//        ctr[3]=sig[3];//memeread
//        ctr[2]=sig[2];//memwrite
//        ctr[1]=sig[4]|sig[3];//regwrite
//        ctr[0]=sig[3];//memtoreg
        ctr[9]=sig[4];//regdst
        ctr[8]=sig[3]|sig[2];//alusrc
        ctr[7]=sig[4];//aluop[1]
        ctr[6]=sig[1];//aluop[0]
        ctr[5]=sig[1];//branch
        ctr[4]=sig[0];//jump
        ctr[3]=sig[3];//memeread
        ctr[2]=sig[2];//memwrite
        ctr[1]=sig[4]|sig[3];//regwrite
        ctr[0]=sig[3];//memtoreg
    end
    assign CTR[9:0]=ctr;
endmodule

module Regfile(
    input [31:0]busW,
    input [4:0]RA,
    input [4:0]RB,
    input [4:0]RW,
    input CLK,
    input write_enable,
    output [31:0] busA,
    output [31:0] busB
);
reg[1023:0] body;
integer i;
reg [31:0] DA,DB,DW;

    initial begin
        body=1024'b0;
    end
    always@(posedge CLK) begin

    end
    assign busA=DA;
    assign busB=DB;
    assign busW=DW;

endmodule

module ID(input [63:0] IFID,input[31:0] busW,input [4:0] RW,input write_enable,input CLK,output [147:0]idex);
    reg [5:0] op,func;
    reg[4:0]RA,RB,shamt;
    reg [15:0] imm;
    reg [147:0] IDEX;
    inout wire [31:0] temp1,temp2;
    inout wire [9:0]temp0;
    control CTR(op,temp0);//IDEX[147:138]);
    Regfile regs(busW,RA,RB,RW,CLK,write_enable,temp1,temp2);

    //IDEX[137:106],IDEX[105:74]);

    always@(posedge CLK) begin
        $display("dosth")
        op=IFID[31:26];
        func=IFID[5:0];
        RA=IFID[25:21];
        RB=IFID[20:16];
        shamt=IFID[15:11];
        imm=IFID[15:0];

        IDEX[73:69]=RB;
        IDEX[68:64]=RA;
        IDEX[47:32]=shamt;
        IDEX[63:48]={64{1'b1}};
        IDEX[31:0]=IFID[63:32];


    end


    assign idex=IDEX;
endmodule