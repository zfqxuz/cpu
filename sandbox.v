module sdbx;
reg[5:0] op=6'b000000;
reg[8:0] ctr;
integer i;
reg [4:0] sig;

    initial begin
        sig[4]=(~op[5]&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0]));
        sig[3]=(op[5]&(~op[4])&(~op[3])&(~op[2])&(op[1])&(op[0]));
        sig[2]=(op[5]&(~op[4])&(op[3])&(~op[2])&(op[1])&(op[0]));
        sig[1]=(~op[5]&(~op[4])&(~op[3])&(op[2])&(~op[1])&(~op[0]));
        sig[0]=(~op[5]&(~op[4])&(~op[3])&(~op[2])&(op[1])&(~op[0]));
        $display("%b",sig);
        ctr[8]=sig[4]|sig[3];
        ctr[7]=sig[3]|sig[2];
        ctr[6:2]=sig[4:0];
        ctr[1]=sig[4];
        ctr[0]=sig[1];
        $display("%b",ctr);

    end
endmodule
