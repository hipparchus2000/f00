//F00 simulator version 0.01
#include <stdio.h>


/* DEFINES ========================================================== */
#define LOAD 0
#define STORE 1
#define MOVE 2
#define SUPERSWAP 3
#define JUMPREL 4
#define JUMPABS 5
#define JUMPRIMM 6
#define JUMPRIMMC 7
#define JUMPRIMMZ 8
#define JUMPRIMMO 9
#define LOADIMM 16
#define AND 32
#define OR 33
#define NOT 34
#define SHIFTL 35
#define SHIFTR 36
#define ROTATEL 37
#define ROTATER 38
#define SHIFTLC 39
#define SHIFTRC 40
#define ROTATELC 41
#define ROTATERC 42
#define ADD 43
#define SUB 44
#define SYSCALL 48 





FILE *RomFile;
unsigned int carryflag;
unsigned int shortimm;
unsigned int opcode;
unsigned int superflag;
unsigned int zeroflag;
unsigned int softintflag;
unsigned int intenableflag;
unsigned int freezeflag;
unsigned int illegalflag;
unsigned int pc;
unsigned int operand1;
unsigned int operand2;
unsigned int temp;
unsigned int value;
unsigned int address;
unsigned int reg[32];
unsigned int goflag;
unsigned int  pc;
unsigned int  usr; //user status reg
unsigned int  sr[5]; //supervisor registers - sr[0] is supervisor status register
unsigned int  mmu[512]; //mmu table, partitioned into two halves, above 256=user data, 
unsigned int  debugmode;
unsigned int  tracemode;
unsigned int  jumpdone;
		  //below=user code

//rom in physical address 0-ffff
unsigned int  rom[32768];

//ram in physical address 10000-1ffff 
unsigned int ram[32768];

//memory mapped io consists of char in,  and char out through
//a sort of virtual uart at 32767



main(int argc,char *argv[])
{
int x;
int io;
unsigned int  value;
int goflag=1;
debugmode=0;
tracemode=0;
jumpdone=0;

//unsigned int  defined somewhere as 16 bit value depending on compiler

//any more than one argument and forget it
if (argc!=2) {
  printf("fcpu-sim requires, and only takes one argument, (the name of the rom file) \n");
  return(0);
};

//get argument (ignore any but first)
RomFile=fopen(argv[1],"r");


x=0;

//start run from instruction 0
pc=0;
//sr[0]=0b'0000000000010000';
sr[0]=0x0010;


//read in romfile
while(feof(RomFile)==0)
{
  //each line is two 16 bit value expressed as a decimal number
  io=fscanf(RomFile,"%ld %ld",&address, &value);
  rom[address]=value;
  x++;
};

fclose(RomFile);

//writing a 1 to the supervisor status register in bit "freeze" will
//cause goflag=0
while(goflag==1)
{
  process();
};


};

unsigned int  writemem(unsigned int  address, unsigned int  data, unsigned int superflag, unsigned int codeflag) {

unsigned int  logaddress;
unsigned int  page;

if (superflag==0) {
//	page=(address/4096)+(256*
//	logaddress=address
};
 
};


unsigned int  readmem(unsigned int  address, unsigned int superflag, unsigned int codeflag) {

};

//============= the 'readphysmemory' function =================
unsigned int  readphysmem(unsigned int  address)
{
  if(tracemode==1) printf("Memory Read To %d\n",address);


  if(address<32767)
  {
    //rom being read
    return(rom[address & 32767]);
  };

  if(address>32767)
  {
    //ram being read
    return(ram[address & 32767]);
  };

  //the only other thing in physical space is the virtual 'in' uart
  //at location 32767!
  return (getchar());

};

//============= the 'writephysmemory' function =================
int writephysmem(unsigned int  address,unsigned int  wrdata)
{
  if(tracemode==1) printf("Memory Write To %d Value %d\n",address,wrdata);


  if(address<32767)
  {
    //rom cannot be written
    return(0);
  };

  if(address<32767)
  {
    //ram being written
    ram[address & 32767]=wrdata;
    return(0);
  };

  //the only other thing in physical space is the virtual 'out' uart
  printf("%c",wrdata & 255);

};



//============= the 'process' function ================
int process()
{
unsigned int  instructionfetched=readphysmem(pc);

if (tracemode==1) printf("PC: %d    Code: %d \n",pc,instructionfetched);

decode(instructionfetched);


//increment pc 
if (jumpdone==0) {
  pc=pc+1;
} else {
  jumpdone=0;
};


};


//============ the decode function =================
decode(unsigned int  instructionword)
{
if (debugmode==1) printf("Decode: %d\n",instructionword);

//opcode=instructionword & 0b1111110000000000/1024;
opcode=(instructionword & 0xfc00)/0x400;
//operand1=instructionword & 0b0000001111100000;
operand1=(instructionword & 0x03e0)/32;
//operand2=instructionword & 0b0000000000011111;
operand2=instructionword & 0x001f;
//shortimm=instructionword & 0b0000001111111111;
shortimm=instructionword & 0x03ff;
//carryflag=usr&0b0000000000000001;
carryflag=usr & 0001;
//zeroflag=(usr&0b0000000000000010)/2;
zeroflag=(usr&0x0002)/2;
//superflag=(sr[0]&0b0000000000010000)/16;
superflag=(sr[0]&0x0010)/16;
//softintlag=(sr[0]&0b0000000000001000)/8;
softintflag=(sr[0]&0x0008)/8;
//intenableflag=(sr[0]&0b0000000000000100)/4;
intenableflag=(sr[0]&0x0004)/4;
//freezeflag=(sr[0]&0b0000000000000010)/2;
freezeflag=(sr[0]&0x0002)/2;
//illegalflag=sr[0]&0b0000000000000001;
illegalflag=sr[0]&0x0001;

if (debugmode==1) printf("Opcode: %d   Opand1: %d  Opand 2:  %d",opcode,operand1,operand2);


if (shortimm>511) shortimm= -(1024-shortimm);

switch (opcode)  {

    case SYSCALL: //syscall
//           sr[0]=sr[0]||0b0000000000011000; //set super, set soft-int
//           sr[0]=sr[0]&0b1111111111111000; //reset int enable, freeze and ille           
	   if (tracemode==1) printf("SYSCALL\n");
	   sr[0]=sr[0]||0x0018; //set super, set soft-int
           sr[0]=sr[0]&0xfff8; //reset int enable, freeze and illegal
           superflag=1;
           softintflag=1;
           intenableflag=0;
           freezeflag=0;
           illegalflag=0;
           writemem(sr[1],pc,superflag,1); //data space irrelevant but set anyway
           pc=sr[2];
           break;
    case AND: //and
	   if (tracemode==1) printf("AND %d %d \n",operand1,operand2);
           reg[operand2]=reg[operand1] & reg[operand2];
           if (reg[operand2]==0) {
		zeroflag=1;
	} 
	else {
		zeroflag=0;
	};
           break;
    case OR: //or
	   if (tracemode==1) printf("OR %d %d \n",operand1,operand2);
           reg[operand2]=reg[operand1] || reg[operand2];
           if (reg[operand2]==0) {
		zeroflag=1;
	} 
	else {
		zeroflag=0;
	};
           break;         
    case NOT: //not
	   if (tracemode==1) printf("NOT %d %d \n",operand1,operand2);
           reg[operand2]=!(reg[operand1]);
           if (reg[operand2]==0) {
		zeroflag=1;
	} 
	else {
		zeroflag=0;
	};

           break;         
    case SHIFTL: //shiftl
           reg[operand2]=reg[operand1] << reg[operand2];
           if (reg[operand2]==0) {
		zeroflag=1;
	} 
	else {
		zeroflag=0;
	};
           break;         
    case SHIFTR: //shiftr
           reg[operand2]=reg[operand1] >> reg[operand2];
           if (reg[operand2]==0) {
		zeroflag=1;
	} 
	else {
		zeroflag=0;
	};
           break;         
    case ROTATEL: //rotatel
           printf("to be implemented - opcode %d\n",opcode);
           break;         
    case ROTATER: //rotater
           printf("to be implemented - opcode %d\n",opcode);
           break;         
    case SHIFTLC: //shiftlc
           printf("to be implemented - opcode %d\n",opcode);
           break;         
    case SHIFTRC: //shiftrc
           printf("to be implemented - opcode %d\n",opcode);
           break;         
    case ROTATELC: //rotatelc
           printf("to be implemented - opcode %d\n",opcode);
           break;         
    case ROTATERC: //rotaterc
           printf("to be implemented - opcode %d\n",opcode);
           break;         
    case ADD: //add
	   if (tracemode==1) printf("ADD %d %d \n",operand1,operand2);
           reg[operand2]=reg[operand1] + reg[operand2];
           break;     
    case SUB: //sub
           reg[operand2]=reg[operand1] + reg[operand2];
           break;         
    case LOADIMM: //loadimm
	   if (tracemode==1) printf("LOADIMM %d  \n",operand1);
           pc++;
           reg[operand1]=readphysmem(pc); // the ,0 indicates from the code space (user mode)
	   if (tracemode==1) printf("(loadimm const) %d  \n",reg[operand1]);
           break;  

    case MOVE: //move
	   if (tracemode==1) printf("MOVE %d %d \n",operand1,operand2);
	  reg[operand2]=reg[operand1];
           break;  
       
    case LOAD: //load
	   if (tracemode==1) printf("LOAD %d %d \n",operand1,operand2);
//           reg[operand2]=readphysmem(reg[operand1],superflag,1); //the ,1 indicates from the data
                                                                         //space (user mode)
           reg[operand2]=readphysmem(reg[operand1]); //the ,1 indicates from the data
                                                                         //space (user mode)
           break;         
    case STORE: //store
	   if (tracemode==1) printf("STORE %d %d \n",operand1,operand2);
//           writephysmem(reg[operand1],reg[operand2],superflag,1); //1 indicates data space
						          // (user mode)
           writephysmem(reg[operand2],reg[operand1]); //1 indicates data space
						          // (user mode)
           break;         
    case SUPERSWAP: //superswap
	   if (tracemode==1) printf("SUPERSWAP %d %d \n",operand1,operand2);
           if (superflag==1) {
           		temp=reg[operand2];
           		reg[operand2]=sr[operand1];
           		sr[operand1]=temp;
	}
	else {
	//illegal instruction
//           sr[0]=sr[0]||0b0000000000010001; //set super, set soft-int
//           sr[0]=sr[0]&0b1111111111111001; //reset int enable, freeze and illegal
           sr[0]=sr[0]||0x0011; //set super, set soft-int
           sr[0]=sr[0]&0xfff9; //reset int enable, freeze and illegal           superflag=1;
           softintflag=1;
           intenableflag=0;
           freezeflag=0;
           illegalflag=0;
           writemem(sr[1],pc,superflag,1); //data space irrelevant but set anyway
           pc=sr[2];
	}
           break;         
    case JUMPREL: //jumprel
	pc+=reg[operand1];
        jumpdone=1;
           break;         
    case JUMPABS: //jumpabs
	   if (tracemode==1) printf("JUMPABS %d  \n",operand1);
	   pc=reg[operand1];
        jumpdone=1;
           break;         
    case JUMPRIMM: //jumprimm
	pc+=shortimm;
        jumpdone=1;
           break;         
    case JUMPRIMMC: //jumprimmc
	if (carryflag==1) pc+=shortimm;
        jumpdone=1;
           break;         
    case JUMPRIMMZ: //jumprimmz
	if (zeroflag==1) pc+=shortimm;
        jumpdone=1;
           break;         
    default: //unknown instruction (illegal instruction)
	   printf("Illegal Instruction \n");
//           sr[0]=sr[0]||0b0000000000010001; //set super, set soft-int
//           sr[0]=sr[0]&0b1111111111111001; //reset int enable, freeze and illegal
           sr[0]=sr[0]||0x0011; //set super, set soft-int
           sr[0]=sr[0]&0xfff9; //reset int enable, freeze and illegal
           superflag=1;
           softintflag=1;
           intenableflag=0;
           freezeflag=0;
           illegalflag=0;
           writemem(sr[1],pc,superflag,1); //data space irrelevant but set anyway
           pc=sr[2];


} //end opcode

}




