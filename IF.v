`include "InstructionRAM.v"
module IF(input CLK, input[31:0] pc, output[64:0] ifid,output[31:0] nextpc);
    reg[64:0]IFID;

    reg[31:0]pc_plus_4,PC;
    wire[31:0]inst;
    integer count=0;
    InstructionRAM instruction(.CLOCK(CLK),.ENABLE(1'b1),.RESET(1'b0),.FETCH_ADDRESS(pc_plus_4>>2),.DATA(inst));


    initial begin
        PC=0;
        pc_plus_4=0;
        IFID[31:0]=0;
    end
    always@(posedge CLK)begin
            $display("Current IF: line %d",count);
            count=count+1;
            pc_plus_4=pc_plus_4+4;
            IFID[63:32]=pc_plus_4;
            IFID[31:0]=inst;
            IFID[64]=0;
            if (inst==32'b11111111111111111111111111111111) IFID[64]=1;
            $display("fa %d, inst %h",pc>>2,inst);
            //$display("IST %b",inst==32'b11111111111111111111111111111111);
            //$display("AIF %b",IFID);
    end
    assign ifid=IFID;
    assign nextpc=pc_plus_4;
    assign pc=PC;


endmodule