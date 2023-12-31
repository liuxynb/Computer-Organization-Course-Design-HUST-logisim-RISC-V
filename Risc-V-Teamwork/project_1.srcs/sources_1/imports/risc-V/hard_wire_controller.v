//hardwire controller
module hard_wire_controller(Funct,OpCode,IR21,ALUOP,MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,uret);
    input[4:0] Funct;
    input[4:0] OpCode;
    input IR21;
    output MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,uret;
    output [3:0]ALUOP;
    //accord Funct to Funct7 and Funct3
    wire [6:0] Funct7;
    wire [2:0] Funct3;
    assign Funct3=Funct[2:0];
    assign Funct7={1'b0,Funct[4],4'b0000,Funct[3]};
    //use
    arithmetic_controller controller1(.Funct7(Funct7),.Funct3(Funct3),.OpCode(OpCode),.ALUOP(ALUOP));
    control_signal_controller controller2(.Funct7(Funct7),.Funct3(Funct3),.OpCode(OpCode),.IR21(IR21),
    .MemtoReg(MemtoReg),.MemWrite(MemWrite),.ALU_Src(ALU_Src),.RegWrite(RegWrite),.ecall(ecall),
    .S_Type(S_Type),.BEQ(BEQ),.BNE(BNE),.jal(jal),.jalr(jalr),.uret(uret));
endmodule

//ALUOP controller
module arithmetic_controller(Funct7,Funct3,OpCode,ALUOP);
    input[6:0] Funct7;
    input[2:0] Funct3;
    input[4:0] OpCode;
    output [3:0] ALUOP;
    assign ALUOP =(Funct7 == 7'b0000000 && Funct3 == 3'b000 && OpCode == 5'b01100) ? 4'b0101 : // add
        (Funct7 == 7'b0100000 && Funct3 == 3'b000 && OpCode == 5'b01100) ? 4'b0110 : // sub
        (Funct7 == 7'b0000000 && Funct3 == 3'b111 && OpCode == 5'b01100) ? 4'b0111 : // and
        (Funct7 == 7'b0000000 && Funct3 == 3'b110 && OpCode == 5'b01100) ? 4'b1000 : // or
        (Funct7 == 7'b0000000 && Funct3 == 3'b010 && OpCode == 5'b01100) ? 4'b1011 : // slt
        (Funct7 == 7'b0000000 && Funct3 == 3'b011 && OpCode == 5'b01100) ? 4'b1100 : // sltu
        (Funct3 == 3'b000 && OpCode == 5'b00100) ? 4'b0101 : // addi
        (Funct3 == 3'b111 && OpCode == 5'b00100) ? 4'b0111 : // andi
        (Funct3 == 3'b110 && OpCode == 5'b00100) ? 4'b1000 : // ori
        (Funct3 == 3'b100 && OpCode == 5'b00100) ? 4'b1001 : // xori
        (Funct3 == 3'b010 && OpCode == 5'b00100) ? 4'b1011 : // slti
        (Funct7 == 7'b0000000 && Funct3 == 3'b001 && OpCode == 5'b00100) ? 4'b0000 : // slli
        (Funct7 == 7'b0000000 && Funct3 == 3'b101 && OpCode == 5'b00100) ? 4'b0010 : // srli
        (Funct7 == 7'b0100000 && Funct3 == 3'b101 && OpCode == 5'b00100) ? 4'b0001 : // srai
        (Funct3 == 3'b010 && OpCode == 5'b00000) ? 4'b0101 : // lw
        (Funct3 == 3'b010 && OpCode == 5'b01000) ? 4'b0101 : // sw
        (Funct3 == 3'b000 && OpCode == 5'b11000) ? 4'b1011 : // beq
        (Funct3 == 3'b001 && OpCode == 5'b11000) ? 4'b1011 : // bne
        (OpCode == 5'b11011) ? 4'b0101 : // jal
        (Funct3 == 3'b000 && OpCode == 5'b11001) ? 4'b0101 : // jalr
        4'b0000; //default
endmodule

//signal controller
module control_signal_controller(Funct7,Funct3,OpCode,IR21,MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,uret);
    input[6:0] Funct7;
    input[2:0] Funct3;
    input[4:0] OpCode;
    input IR21;  
    output MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,uret;
    assign {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,uret} = (Funct7==7'b0000000 && Funct3==3'b000 && OpCode==5'b01100)?11'b00010000000: //add
        (Funct7==7'b0100000 && Funct3==3'b000 && OpCode==5'b01100)?11'b00010000000: //sub
        (Funct7==7'b0000000 && Funct3==3'b111 && OpCode==5'b01100)?11'b00010000000://and
        (Funct7==7'b0000000 && Funct3==3'b110 && OpCode==5'b01100)?11'b00010000000://or
        (Funct7==7'b0000000 && Funct3==3'b010 && OpCode==5'b01100)?11'b00010000000://slt
        (Funct7==7'b0000000 && Funct3==3'b011 && OpCode==5'b01100)?11'b00010000000://sltu
        (Funct3==3'b000 && OpCode==5'b00100)?11'b00110000000://addi
        (Funct3==3'b111 && OpCode==5'b00100)?11'b00110000000://andi
        (Funct3==3'b110 && OpCode==5'b00100)?11'b00110000000://ori
        (Funct3==3'b100 && OpCode==5'b00100)?11'b00110000000://xori
        (Funct3==3'b010 && OpCode==5'b00100)?11'b00110000000://slti
        (Funct7==7'b0000000 && Funct3==3'b001 && OpCode==5'b00100)?11'b00110000000://slli
        (Funct7==7'b0000000 && Funct3==3'b101 && OpCode==5'b00100)?11'b00110000000://srli
        (Funct7==7'b0100000 && Funct3==3'b101 && OpCode==5'b00100)?11'b00110000000://srai
        (Funct3==3'b010 && OpCode==5'b00000)?11'b10110000000://lw
        (Funct3==3'b010 && OpCode==5'b01000)?11'b01100100000://sw
        (Funct3==3'b000 && OpCode==5'b11100 && IR21==0)?11'b00001000000://ecall
        (Funct3==3'b000 && OpCode==5'b11000)?11'b00000010000://beq
        (Funct3==3'b001 && OpCode==5'b11000)?11'b00000001000://bne
        (OpCode==5'b11011)?11'b00010000100://jal
        (Funct3 == 3'b000 && OpCode==5'b11001)?11'b00110000010://jalr
        (Funct3==3'b000 && OpCode==5'b11100 && IR21==1)?11'b00000000001://uret
        11'b00000000000;//default
endmodule
