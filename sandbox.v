module sdbx;
reg[5:0] op=6'b000001;
reg[8:0] ctr;
reg clk;
integer k;
reg [4:0] sig;
reg [10:0] i,q;
integer start;
integer fin;

    initial begin
        i=11'b0;
        k=op;
        clk=0;
        #10 clk=~clk;
        #10 clk=~clk;
        #10 clk=~clk;
    end

    task modify(input integer start,fin,output reg[10:0] q);

        begin
        q=i;
        end
    endtask

    always@(clk) begin

        $display("%b",4'b1100&4'b1010);
        $display("%b",{10*op[0],10*op[1]});
    end




endmodule
