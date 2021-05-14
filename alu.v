module alu(
input wire[31:0] regA,regB,instruction,
input clk,
output [31:0] RESULT,
output [2:0] FLAGS
);
reg [5:0] func,opcode,sa;
reg[31:0]rs,rt,imm;
reg [31:0] result;
reg [2:0] flags;
integer count=0;
assign FLAGS=flags;
assign RESULT=result;
always @(instruction)
begin
    imm=instruction[15:0];
    imm[31:16]={16{imm[15]}};
    result=0;
    flags=0;

    rs=regA;
    rt=regB;

    opcode=instruction[31:26];
    func=instruction[5:0];
    sa=instruction[10:6];
        if (opcode==6'b000000)begin
            case(func)
                6'b100000://add
                    begin
                        $display("add:");
                        result<=$signed(rs+rt);
                        if((result[31]!=rs[31])&&(result[31]!=rt[31]))
                        begin
                            flags[2]<=1;
                        end
                    end
                6'b100001://addu
                    begin
                        $display("addu:");
                        result<=$unsigned(rs+rt);
                    end
                6'b100010://sub
                    begin
                        $display("sub:");
                        result<=$signed(rs-rt);
                        if((result[31]!=rs[31])&&(result[31]!=rt[31]))
                        begin
                            flags[2]<=1;
                        end
                    end
                6'b100011://subu
                    begin
                        $display("subu:");
                        result<=$unsigned(rs-rt);
                    end
                6'b100100://and
                    begin
                        $display("and:");
                        result<=rs&rt;
                    end
                6'b100101://or
                    begin
                        $display("or:");
                        result<=rs|rt;
                    end
                6'b100110://xor
                    begin
                        $display("xor:");
                        result<=rs^rt;
                    end
                6'b100111://nor
                    begin
                        $display("nor:");
                        result<=~(rs|rt);
                    end
                6'b101010://slt
                    begin
                        $display("slt:");

                        flags[1]<=$signed(rs)-$signed (rt)<0;
                    end
                6'b101011://sltu
                    begin

                        $display("sltu:");

                        flags[1]=($unsigned (rs)-$unsigned (rt))>>31;
                    end
                6'b000000://sll
                    begin



                        result<=(rt<<sa);
                    end
                6'b000010://srl
                    begin

                        result<=(rt>>sa);
                    end
                6'b000011://sra
                    begin
                        $display("sra:");


                        result<=(rt>>sa);
                        while(count<sa)
                        begin
                        $display("rt %b,sa %b",rt,sa);
                            result[31-count]<=rt[31];
                            count=count+1;
                        end
                    end
                6'b000100://sllv
                    begin
                        $display("sllv:");
                        result<=(rt<<rs);
                    end
                6'b000110://srlv
                    begin
                        $display("srlv:");
                        result<=(rt>>rs);
                    end
                6'b000111://srav
                    begin
                        $display("srav:");
                        if(rt[31]==1) begin
                            count=$unsigned(-1)<<(32-rs);
                        end
                        result<=(rt>>rs)|count;
                        count=0;

                    end
            endcase
        end else begin

            case(opcode)
                6'b001000://addi
                    begin
                        $display("addi:");
                        result<=$signed(rs+imm);
                        if((result[31]!=rs[31])&&(result[31]!=imm[31]))
                        begin
                            flags[2]<=1;
                        end
                    end
                6'b001001://addiu
                    begin
                        $display("addiu:");
                        imm=imm[15:0];
                        result<=$unsigned(rs+imm);
                    end
                6'b001010://slti
                    begin
                        $display("slti:");
                        flags[1]<=($signed (rs)-$signed (imm)<0);
                    end
                6'b001011://sltiu
                    begin
                        imm=imm[15:0];
                        $display("sltiu:");
                        flags[1]<=$signed ($unsigned (rs)-$unsigned (imm))<0;
                    end
                6'b000101://bne
                    begin
                        $display("bne:");
                        flags[0]<=(rs!=rt);
                    end
                6'b000100://beq
                    begin
                        $display("beq:");
                        flags[0]<=(rs==rt);
                    end
                6'b100011://lw
                    begin
                        $display("lw:");
                        result<=rs+(imm<<2);
                    end
                6'b101011://sw
                    begin
                        $display("sw:");
                        result<=rs+(imm<<2);
                    end
           endcase
           imm=0;

        end
        //$display("regA %b, regB %b, result %b, flags %b",regA,regB,result,flags);
    end
endmodule