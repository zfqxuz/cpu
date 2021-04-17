`include "ID.v"
//`include "InstructionRAM.v"
module cpu;
reg[31:0] WBIF;
reg [63:0] IFID;
inout wire[147:0] IDEX;
reg [104:0] EXMEM;
reg [71:0] MEMWB;
reg clk;
    initial begin
        clk=0;
        ///test
        IFID={64{1'b0}};
        forever  #10 clk=~clk;
        $monitor(IDEX);
    end
    always@(posedge clk)begin
        $display("hjmly");
    end

    ID id(IFID,32'b1,5'b10,1'b1,clk,IDEX);

endmodule