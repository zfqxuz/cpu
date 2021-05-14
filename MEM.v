`include "MainMemory.v"
module MEM(input [140:0]EXMEM, input CLK,output[104:0]memwb,output branch,output[31:0] jaddr);
    reg[104:0]MEMWB;
    wire [64:0] edit;
    wire [31:0] dta;
    assign edit={EXMEM[104],EXMEM[100:37]};
    integer count=-3;
    MainMemory mem(.CLOCK(CLK),.ENABLE(EXMEM[104]),.RESET(EXMEM[108]),.FETCH_ADDRESS(EXMEM[68:37]),.EDIT_SERIAL(edit),.DATA(dta));
    always@(posedge CLK) begin
    //$display("EXFIN %b",EXMEM);
            $display("Current MEM: line %d",count);
            count=count+1;
        MEMWB[4:0]=EXMEM[36:32];
        MEMWB[36:5]=dta;
        MEMWB [68:37]=EXMEM[100:69];
        MEMWB [70:69]=EXMEM[103:102];
        MEMWB [71]=EXMEM[106];
        MEMWB[72]=EXMEM[108];
        MEMWB[104:73]=EXMEM[140:109];
    end
    assign memwb=MEMWB;
    assign jaddr=EXMEM[101:70];
    assign branch=EXMEM[107];
endmodule