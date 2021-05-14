`include "ID.v"
`include "EX.v"
`include  "MEM.v"
`include "IF.v"
`include "WB.v"
//`include "InstructionRAM.v"
`timescale 100ms/100ms
module cpu;
integer count;
reg[31:0] WBIFnow,WBIFresult;
wire [64:0] IFIDNOW;
wire [64:0] IFIDRESULT;
reg[64:0] IFIDnow,IFIDresult;
wire[180:0] IDEXNOW;
wire [180:0] IDEXRESULT;
reg [180:0]IDEXnow,IDEXresult;
wire [140:0] EXMEMNOW,EXMEMRESULT;
reg[140:0] EXMEMnow,EXMEMresult;
reg [104:0] MEMWBnow,MEMWBresult;
wire[104:0] MEMWBNOW,MEMWBRESULT;
wire Branch,regwriteW;
wire[31:0] previous_pc_plus_4,Jaddr,WBIFNOW,WBIFRESULT;
wire[4:0] regwrite;
wire [31:0] regwritedta;

reg a;
reg clk;
parameter clock_period=10;
    assign IFIDNOW=IFIDnow;
    assign IDEXNOW=IDEXnow;
    assign EXMEMNOW=EXMEMnow;
    assign MEMWBNOW=MEMWBnow;
    IF inst_fetch(.CLK(clk),.pc(WBIFNOW),.ifid(IFIDRESULT),.nextpc(previous_pc_plus_4));
    ID id(.IFID(IFIDNOW),.write_data(regwritedta),.rw(regwrite),.write_enable(regwriteW),.CLK(clk),.idex(IDEXRESULT));
    EX ex(.IDEX(IDEXNOW),.exmem(EXMEMRESULT),.CLK(clk));
    MEM mem(.EXMEM(EXMEMNOW),.memwb(MEMWBRESULT),.CLK(clk),.branch(Branch),.jaddr(Jaddr));
    WB wb(.CLK(clk),.MEMWB(MEMWBNOW),.data(regwritedta),.regwriteW(regwriteW),.regwrite(regwrite),.nextpc(WBIFRESULT),.shifted(Jaddr),.prev_pc_plus_4(previous_pc_plus_4));
    initial begin

        count=0;
        IFIDnow[64]=0;
        IDEXnow[148]=0;
        EXMEMnow[108]=0;
        MEMWBnow[72]=0;
        clk=1;
        $dumpfile("tst.vcd");
        $dumpvars;
        $dumpon;
        #1000 $dumpoff;
        $finish;
    end

    always
    #(clock_period/2) clk=~clk;

    always@(negedge clk) begin
    $display("Round %d",count);
    count=count+1;
    //$display("fetch address%d, instruction fetched %b",IFIDRESULT[63:32],IFIDRESULT[31:0]);
    //$display("IDEX%b",IDEXRESULT);
    //$display("EXMEM%b",EXMEMRESULT);
    //$display("MEMWB%b",MEMWBRESULT);
    $display("______________________________________________________________________________________________________");
    ///$monitor("idyikes%b",IDEX);
    IFIDresult<=IFIDRESULT;
    IDEXresult<=IDEXRESULT;
    EXMEMresult<=EXMEMRESULT;
    MEMWBresult<=MEMWBRESULT;
    WBIFresult<=WBIFRESULT;
    end
    always@(posedge clk) begin
    IFIDnow=IFIDresult;
    IDEXnow=IDEXresult;
    EXMEMnow=EXMEMresult;
    MEMWBnow=MEMWBresult;
    WBIFnow=WBIFresult;
    end



endmodule