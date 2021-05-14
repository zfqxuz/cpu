`include "alu.v"
module EX(input [180:0] IDEX,output [140:0]exmem,input CLK);
    reg [140:0]EXMEM;
    reg [4:0] rg0,rg1;
    reg [5:0] FUNC;

    reg regdist,alusrc,sign;
    reg zerobit=0;
    reg [1:0] ALUOP;
    reg [2:0] ALUCTR;
    wire [2:0] flags;
    reg[31:0] rega,busb,imm,regb;
    wire[31:0] alurst;
    integer count=-2;
//    function automatic[2:0] aluctr;
//    input reg [5:0]func;
//    input reg [1:0] aluop;
//
//    begin
//        $display("op %b, func %b",aluop,func);
//        if (aluop==2'b00) aluctr=3'b010;
//        else if ((aluop==2'b11)||(aluop==2'b01)) aluctr=3'b110;
//        else
//            begin
//                case(func[3:0])
//                    4'b0000:
//                    begin aluctr=3'b010; end
//                    4'b0010:
//                    begin aluctr=3'b110; end
//                    4'b0100:
//                    begin aluctr=3'b000; end
//                    4'b0101:
//                    begin aluctr=3'b001; end
//                    4'b1010:
//                    begin aluctr=3'b111; end
//                endcase
//            end
//        $display("aluctr %b",aluctr);
//    end
//    endfunction
//
//    task alu(
//    input reg sign,
//    input reg[2:0] aluctr,
//    input reg [31:0] regA,regB,
//    output reg[31:0] result,
//    output reg zero);
//        begin
//        zero=0;
//            case(aluctr)
//                3'b010:
//                begin
//                    result[31:0]=regA+regB;
//                    if(sign&&(result[31]!=regA[31])&&(result[31]!=regB[31])) zero=1;
//                end
//                3'b110:
//                begin
//                    result[31:0]=regA-regB;
//                    if(sign&&(result[31]!=regA[31])&&(result[31]!=regB[31])) zero=1;
//                end
//                3'b000:
//                begin
//                    result[31:0]=regA&regB;
//                end
//                3'b001:
//                begin
//                    result[31:0]=regA|regB;
//                end
//                3'b111:
//                begin
//                    zero=$signed(regA-regB)<0;
//                end
//            endcase
//        end
//    endtask

    function automatic[31:0] mux1;
        input [31:0]in1,in2;
        input signal;
        begin
            if (signal==1)begin
                mux1=in2;
            end else begin
                mux1=in1;
            end
        end
    endfunction

    function automatic[4:0] mux2;
        input [4:0]in1,in2;
        input signal;
        begin
            if (signal==1)begin
                mux2=in2;
            end else begin
                mux2=in1;
            end
        end
    endfunction

    alu ALU(.clk(CLK),.regA(rega),.regB(regb),.RESULT(alurst),.FLAGS(flags),.instruction(IDEX[180:149]));
    always@(posedge CLK) begin
                $display("Current EX: line %d",count);
                count=count+1;

    //$display("IDFIN %b",IDEX[148]);
        rg0[4:0]=IDEX[73:69];
        rg1[4:0]=IDEX[68:64];
        regdist=IDEX[147];
        busb=IDEX[105:74];
        //$display("IDEX%b",IDEX);
        rega=IDEX[137:106];
        imm=IDEX[63:32];
        alusrc=IDEX[146];
        regb=mux1(imm,busb,alusrc);
        ALUOP=IDEX[145:144];
        //FUNC=IDEX[15:10];
        //sign=FUNC[0];
        //$display("judge%d",FUNC[3:0]==4'b0101);
        //if (FUNC[3:0]!=4'b0101) FUNC[0]=1'b0;
        //ALUCTR[2:0]=aluctr(FUNC,ALUOP);
        //alu(sign,ALUCTR,rega,regb,alurst,zerobit);
        //$display("alurst %b busb %b",alurst,busb);
        EXMEM[31:0]=IDEX[31:0]+(IDEX[63:32]<<2);
        EXMEM[36:32]=mux2(rg0,rg1,regdist);
        EXMEM[68:37]=IDEX[105:74];
        EXMEM[100:69]=alurst;
        EXMEM[101]=flags[2];
        EXMEM[107:102]=IDEX[143:138];
        EXMEM[108]=IDEX[148];
        EXMEM[140:109]=IDEX[180:149];
        //$display("%b,%b,%b,%b,%b,%b",EXMEM[107:102],EXMEM[101:70],EXMEM[69],EXMEM[68:37],EXMEM[36:5],EXMEM[4:0]);
        //$display("1xm1m[105]%b,1d1x[141]%b",EXMEM[105],IDEX[141]);
    end

    assign exmem=EXMEM;
endmodule