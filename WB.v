`timescale 100ms/100ms
module WB(output special,input CLK,input branch,input [104:0] MEMWB,input[31:0] prev_pc,input[31:0] shifted, output [31:0] data,output [31:0] nextpc,output[4:0] regwrite, output regwriteW);
    reg [31:0]write_data;
    parameter clock_period=10;
    reg[31:0] PREVPC,NEXTPC,temp0,temp1,temp2;
    integer count=0;
    reg finished;
    initial begin
        PREVPC=0;
        NEXTPC=4;

        end
    always@(MEMWB) begin
    $display("branch in WB at count= %d is %d",count,branch);

        if (MEMWB[69]==0) begin
            write_data=MEMWB[68:37];
        end else begin
            write_data=MEMWB[36:5];
        end
        if (MEMWB[72]==1) assign finished=1;
    end
    assign nextpc=NEXTPC;

    always#(clock_period) begin
    count=count+1;
    PREVPC=NEXTPC;
    NEXTPC=PREVPC+4;


    if (branch) begin  $display("goof");NEXTPC=shifted+4; $display("JUDGE%d",NEXTPC==shifted);end

    end

    assign prev_pc=PREVPC;
    assign regwrite=MEMWB[4:0];
    assign regwriteW=MEMWB[70];
    assign special=finished;
    assign data=write_data;

endmodule