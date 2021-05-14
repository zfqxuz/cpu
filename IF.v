`include "InstructionRAM.v"
module IF(input CLK, input[31:0] pc, output[64:0] ifid,output[31:0] prev_pc);
    reg[64:0]IFID;

    reg[31:0]prevPC,PC;
    wire[31:0]inst;
    integer count=0;
    InstructionRAM instruction(.CLOCK(CLK),.ENABLE(1'b1),.RESET(1'b0),.FETCH_ADDRESS(pc>>2),.DATA(inst));
    initial begin
        PC=0;
        prevPC=0;
        IFID[31:0]=0;
    end
    always@(posedge CLK)begin
            count=count+1;
//            PC<=pc;
            prevPC=PC;
            if (count>1) PC=PC+4;
            IFID[63:32]=PC;
            IFID[31:0]=inst;
            IFID[64]=0;
            if (inst==32'b11111111111111111111111111111111) IFID[64]=1;


    end
    assign ifid=IFID;
    assign prev_pc=prevPC;
    assign pc=PC;




endmodule