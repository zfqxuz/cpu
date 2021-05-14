`include "alu.v"
module EX(input [180:0] IDEX,output [140:0]exmem,input CLK);
    reg [140:0]EXMEM;
    reg [4:0] rg0,rg1;
    reg [5:0] FUNC;
    reg regdist,alusrc,sign;
    reg zerobit=0;
    reg [1:0] ALUOP;
    reg [2:0] ALUCTR;
    reg[31:0] rega,busb,imm,regb;
    reg[34:0] temp;
    integer count=-2;

    function automatic[34:0] ALU;
        input [31:0] regA,regB,instruction;
        reg [5:0] func,opcode,sa;
        reg [31:0]rs,rt,imm;
        reg [31:0] result;
        reg [2:0] flags;
        begin
            $display("Executing inst: %h",instruction);
            imm=instruction[15:0];
            imm[31:16]={16{imm[15]}};
            result=0;
            flags=0;
            rs=regA;
            rt=regB;

            opcode=instruction[31:26];
            func=instruction[5:0];
            sa=instruction[10:6];
            if (opcode==6'b000000) begin
                    case(func)
                        6'b100000://add
                            begin
                                $display("add:");
                                result=$signed(rs+rt);

                                if((result[31]!=rs[31])&&(result[31]!=rt[31]))
                                begin
                                    flags[2]=1;
                                end
                            end
                        6'b100001://addu
                            begin
                                $display("addu:");
                                result=$unsigned(rs+rt);
                            end
                        6'b100010://sub
                            begin
                                $display("sub:");
                                result=$signed(rs-rt);
                                if((result[31]!=rs[31])&&(result[31]!=rt[31]))
                                begin
                                    flags[2]=1;
                                end
                            end
                        6'b100011://subu
                            begin
                                $display("subu:");
                                result=$unsigned(rs-rt);
                            end
                        6'b100100://and
                            begin
                                $display("and:");
                                result=rs&rt;
                            end
                        6'b100101://or
                            begin
                                $display("or:");
                                result=rs|rt;
                            end
                        6'b100110://xor
                            begin
                                $display("xor:");
                                result=rs^rt;
                            end
                        6'b100111://nor
                            begin
                                $display("nor:");
                                result=~(rs|rt);
                            end
                        6'b101010://slt
                            begin
                                $display("slt:");

                                flags[1]=$signed(rs)-$signed (rt)<0;
                                result[0]=flags[1];


                            end
                        6'b101011://sltu
                            begin
                                $display("sltu:");

                                flags[1]=($unsigned (rs)-$unsigned (rt))>>31;
                            end
                        6'b000000://sll
                            begin
                                result=(rt<<sa);
                            end
                        6'b000010://srl
                            begin
                                result=(rt>>sa);
                            end
                        6'b000011://sra
                            begin
                                $display("sra:");
                                result=(rt>>sa);
                                while(count<sa)
                                begin
                                $display("rt %b,sa %b",rt,sa);
                                    result[31-count]=rt[31];
                                    count=count+1;
                                end
                            end
                        6'b000100://sllv
                            begin
                                $display("sllv:");
                                $display("here rt%b, rs%b",rt,rs);
                                result=(rt<<rs);
                            end
                        6'b000110://srlv
                            begin
                                $display("srlv:");
                                result=(rt>>rs);
                            end
                        6'b000111://srav
                            begin
                                $display("srav:");
                                if(rt[31]==1) begin
                                    count=$unsigned(-1)<<(32-rs);
                                end
                                result=(rt>>rs)|count;
                                count=0;

                            end
                    endcase
            end
            else begin
                    case(opcode)
                        6'b001000://addi
                            begin

                                $display("addi:");
                                result=$signed(rs+imm);

                                if((result[31]!=rs[31])&&(result[31]!=imm[31]))
                                begin
                                    flags[2]=1;
                                end
                            end
                        6'b001001://addiu
                            begin
                                $display("addiu:");
                                imm=imm[15:0];

                                result=$unsigned(rs+imm);

                            end
                        6'b001010://slti
                            begin
                                $display("slti:");
                                flags[1]=($signed (rs)-$signed (imm)<0);
                            end
                        6'b001011://sltiu
                            begin
                                imm=imm[15:0];
                                $display("sltiu:");
                                flags[1]=$signed ($unsigned (rs)-$unsigned (imm))<0;
                            end
                        6'b000101://bne
                            begin
                                $display("bne:");
                                flags[0]=(rs!=rt);

                            end
                        6'b000100://beq
                            begin
                                $display("beq:");
                                flags[0]=(rs==rt);

                            end
                        6'b100011://lw
                            begin
                                $display("lw:");
                                result=rs+(imm<<2);
                            end
                        6'b101011://sw
                            begin
                                $display("sw:");
                                result=rs+(imm<<2);
                            end
                        6'b001100://andi
                            begin
                                result=rs&imm;
                            end
                        6'b001101://ori
                            begin
                                result=rs|imm;
                            end
                        6'b001110://xori
                            begin
                                result=rs^imm;
                            end
                   endcase
                   imm=0;
            end
            ALU[31:0]=result;
            ALU[34:32]=flags;

        end

    endfunction
//
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

    always@(IDEX  or posedge CLK) begin

         count=count+1;

        rg0[4:0]=IDEX[73:69];
        rg1[4:0]=IDEX[68:64];
        regdist=IDEX[147];
        busb=IDEX[105:74];
        rega=IDEX[137:106];
        imm=IDEX[63:32];
        alusrc=IDEX[146];
        regb=mux1(busb,imm,alusrc);
        ALUOP=IDEX[145:144];
        EXMEM[31:0]=IDEX[31:0]+(IDEX[63:32]<<2);
        EXMEM[36:32]=mux2(rg0,rg1,regdist);
        EXMEM[68:37]=IDEX[105:74];
        temp=ALU(rega,regb,IDEX[180:149]);
        EXMEM[100:69]=temp[31:0];

        EXMEM[101]=temp[33];
        EXMEM[107:102]=IDEX[143:138];
        EXMEM[108]=IDEX[148];
        EXMEM[140:109]=IDEX[180:149];
        temp=EXMEM[100:69];


    end

    assign exmem=EXMEM;

endmodule
