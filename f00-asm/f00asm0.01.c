 /* TITLE ========================================================== */
/* Jeff's Assembler for the Embedded F00 CPU
 derived from the F-CPU (Freedom CPU project).*/

 /* INFO ========================================================== */

/* Semantics:

label: opcode opand
       opcode opand
       opcode opand,opand

opand can be a register (eg R1), or a label, or constant.


; comment


pseudo op-codes include
       CODEORG xxxx         sets the codeorg pointer
       DATAORG xxxx         sets the dataorg pointer
label:  WORD xxxx           puts a word of data into Data space

     note in supervisor mode, both code and data point to the same area.
     in user mode, the code and data can be seperate areas.

*/


/* INCLUDES ========================================================== */

#include <stdio.h>
#include <errno.h>
#include <string.h>

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


int main(int argc,char *argv[])

{
 /* DEFINE VARIABLES ========================================================== */
  int debugmode;
  char *source_filename;
  char *output_filename;
  char *image_filename;
  FILE *sourcefile;
  FILE *outputfile;
  FILE *imagefile;
  char *linebuffer;
  int buflen;
  int numparams;
  char *p1;
  char *p2;
  char *p2a;
  char *p3;
  char *p4;
  char *p5;
  char *p6;
  char *pointername;
  unsigned int codepointer=0;
  unsigned int datapointer=0;
  unsigned int opcode;
  unsigned int opand1;
  unsigned int opand2;
  unsigned int numoperands;
  char *commapos="";
  unsigned int instruction;
  int PointerToThisObjectYN;

 /* INITIALISATION ========================================================== */

  debugmode=0;
  linebuffer=(char *)malloc(1024);
  pointername=(char *)malloc(512);
  p1=(char *)malloc(512);
  p2=(char *)malloc(512);
  p3=(char *)malloc(512);
  p4=(char *)malloc(512);
  p5=(char *)malloc(512);
  p6=(char *)malloc(512);


 /* START ========================================================== */


  printf("F00 Assembler 0.01 Jeff Davies 1.10.99 GPL\n");
  if ((argc<2)|(argc>4)) {
    printf("F00 Assembler takes one two or three arguments. Argument 1 is the name\n");
    printf("of the source file (eg: file1.asm) Argument 2 is the\n");
    printf("output executable (eg: file2.bin) and Argument 3 is the Data Image \n");
    printf("if required (eg: file3.img)\n");
    return(0);
  };

  source_filename=argv[1];
  output_filename="out.bin";
  image_filename="out.img";
  if (argc>2) {
    output_filename=argv[2];
  };
  if (argc>3) {
    image_filename=argv[3];
  };


   printf("Source from file: %s\n",source_filename);
   printf("Output to file: %s\n",output_filename);
   printf("Image Output to file: %s\n",image_filename);

//------------Open Source File ---------------
   sourcefile=fopen(source_filename,"r");
   if (errno==0) {
     printf("Source file opened ok.\n");
   } else {
     printf("Error %d opening source file.\n");
   };

//--------------Open Output File---------------

   outputfile=fopen(output_filename,"w");
   if (errno==0) {
     printf("Output file opened ok.\n");
   } else {
     printf("Error %d opening output file.\n");
   };

//--------------Open Image Output File---------------

   imagefile=fopen(image_filename,"w");
   if (errno==0) {
     printf("Image output file opened ok.\n");
   } else {
     printf("Error %d opening image output file.\n");
   };

 /* MAIN LOOP ========================================================== */


   while (!(feof(sourcefile))) {
     strcpy(linebuffer,"");
     strcpy(p1,"");
     strcpy(p2,"");
     strcpy(p3,"");
     strcpy(p4,"");

     PointerToThisObjectYN=0; //make sure this is zeroed each line that is read

     fgets(linebuffer,1024,sourcefile);
     printf("\n%s",linebuffer);
     buflen=strlen(linebuffer);
     if (debugmode==1) printf("length=%d\n",buflen);
     if (buflen>1){
       /* if the line isn't empty, then
       scanf the line into parameters */

       numparams=sscanf(linebuffer," %s %s %s %s",p1,p2,p3,p4);
       if (debugmode==1) printf("Number of terms in the line = %d\n",numparams);
       if (numparams>0) {
	 if (debugmode==1) printf("p1 = %s\n",p1);
	 if (numparams>1) if (debugmode==1) printf("p2 = %s\n",p2);
	 if (numparams>2) if (debugmode==1) printf("p3 = %s\n",p3);
	 if (numparams>3) if (debugmode==1) printf("p4 = %s\n",p4);

//3 open { at this point


 /* COMMENT ========================================================== */
	 /* check to see if the line is a comment */
	 if (strncmp(";",p1,1)) {
	 /* comment found - process the line as a comment */
	   
	 };
       
	 //empty pointername
	 strcpy(pointername,"");

 /* LABEL ========================================================== */

	 if (strstr(p1,":")) {
	   /* label found -store symbol and process rest of line */
	   strncpy(pointername,p1,strlen(p1)-1);

	   //pop the first parameter off and continue
	   strcpy(p1,p2);
	   strcpy(p2,p3);
	   strcpy(p3,p4);
	   strcpy(p4,"");
	   numparams=numparams--;

	   //This is to tell WORD or Instruction to store the data or
	   //code pointer
	   PointerToThisObjectYN=1;

	 };


 /* WORD  ========================================================== */

	 if(strcmp("WORD",p1)==0) {
		   
	   printf("Data Address %d, WORD %d",datapointer,atoi(p2));
	   fprintf(imagefile,"%d %d\n",datapointer,atoi(p2));

	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining data pointer %s (%d)\n",pointername,datapointer);
	     PointerToThisObjectYN=0;
	   };

	   //increment the data pointer
	   datapointer++;

	 };


 /* CODEORG  ========================================================== */

	 if(strcmp("CODEORG",p1)==0) {
    
	   //set the code pointer
           codepointer=atoi(p2);
	   printf("setting code pointer (%d)\n",codepointer); 


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   };
	 };


 /* DATAORG  ========================================================== */

	 if(strcmp("DATAORG",p1)==0) {
    
	   //set the code pointer
           datapointer=atoi(p2);
	   printf("setting data pointer (%d)\n",datapointer); 

	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining data pointer %s (%d)\n",pointername,datapointer);
	     PointerToThisObjectYN=0;

	   };
	 };


 /* Instruction LOAD ========================================================== */
//note destination not surrounded by brackets!!

	 if(strcmp("LOAD",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("LOAD op 1 = %s \n",p5);
           if (debugmode==1) printf("LOAD op 2 = %s \n",p6);

	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!


	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(LOAD*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   


	 };

 /* Instruction STORE ========================================================== */
//note destination not surrounded by brackets!!

	 if(strcmp("STORE",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("STORE op 1 = %s \n",p5);
           if (debugmode==1) printf("STORE op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!


	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(STORE*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction MOVE ========================================================== */

	 if(strcmp("MOVE",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("MOVE op 1 = %s \n",p5);
           if (debugmode==1) printf("MOVE op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!




	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(MOVE*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction SUPERSWAP ========================================================== */

	 if(strcmp("SUPERSWAP",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+3); //second string starts with SR
           if (debugmode==1) printf("SUPERSWAP op 1 = %s \n",p5);
           if (debugmode==1) printf("SUPERSWAP op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(SUPERSWAP*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction JUMPREL ========================================================== */

	 if(strcmp("JUMPREL",p1)==0) {
           /* operand in p2 */
	   if (debugmode==1) printf("p2 is %s\n",p2);
           if (debugmode==1) printf("JUMPREL op 1 = %s \n",p5);

	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(JUMPREL*1024)+(32*atoi(p2));
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction JUMPABS ========================================================== */

	 if(strcmp("JUMPABS",p1)==0) {
           /* operand in p2 */
	       printf("p2 = \n************",p2);   
           if (debugmode==1) printf("p2 is %s\n",p2);
           if (debugmode==1) printf("JUMPABS op 1 = %s \n",p5);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(JUMPABS*1024)+(32*atoi(p2+1));
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction JUMPRIMM ========================================================== */

	 if(strcmp("JUMPRIMM",p1)==0) {
           /* operand in p2 */
	   if (debugmode==1) printf("p2 is %s\n",p2);
           if (debugmode==1) printf("JUMPRIMM op 1 = %s \n",p5);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(JUMPRIMM*1024)+atoi(p2); //initially just accept numeric opand
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };
 

 /* Instruction JUMPRIMMC ========================================================== */

	 if(strcmp("JUMPRIMMC",p1)==0) {
           /* operand in p2 */
	   if (debugmode==1) printf("p2 is %s\n",p2);
           if (debugmode==1) printf("JUMPRIMMC op 1 = %s \n",p5);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(JUMPRIMMC*1024)+atoi(p2); //initially just accept numeric opand
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };
 
 /* Instruction JUMPRIMMZ ========================================================== */

	 if(strcmp("JUMPRIMMZ",p1)==0) {
           /* operand in p2 */
	   if (debugmode==1) printf("p2 is %s\n",p2);
           if (debugmode==1) printf("JUMPRIMMZ op 1 = %s \n",p5);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(JUMPRIMMZ*1024)+atoi(p2); //initially just accept numeric opand
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };
 
 /* Instruction JUMPRIMMO ========================================================== */
//overflow

	 if(strcmp("JUMPRIMMO",p1)==0) {
           /* operand in p2 */
	   if (debugmode==1) printf("p2 is %s\n",p2);
           if (debugmode==1) printf("JUMPRIMMO op 1 = %s \n",p5);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(JUMPRIMMO*1024)+atoi(p2); //initially just accept numeric opand
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction LOADIMM ========================================================== */
//overflow

	 if(strcmp("LOADIMM",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+1);
           if (debugmode==1) printf("AND op 1 = %s \n",p5);
           if (debugmode==1) printf("AND op 2 = %s \n",p6);

	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(LOADIMM*1024)+(atoi(p5)*32); //initially just accept numeric opand
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;

	   instruction=atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction AND ========================================================== */

	 if(strcmp("AND",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("AND op 1 = %s \n",p5);
           if (debugmode==1) printf("AND op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(AND*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction OR ========================================================== */

	 if(strcmp("OR",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("OR op 1 = %s \n",p5);
           if (debugmode==1) printf("OR op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(OR*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction NOT ========================================================== */

	 if(strcmp("NOT",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("NOT op 1 = %s \n",p5);
           if (debugmode==1) printf("NOT op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(NOT*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction SHIFTL ========================================================== */

	 if(strcmp("SHIFTL",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("SHIFTL op 1 = %s \n",p5);
           if (debugmode==1) printf("SHIFTL op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(SHIFTL*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction SHIFTR ========================================================== */

	 if(strcmp("SHIFTR",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("SHIFTR op 1 = %s \n",p5);
           if (debugmode==1) printf("SHIFTR op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(SHIFTR*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };


 /* Instruction ROTATEL ========================================================== */

	 if(strcmp("ROTATEL",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("ROTATEL op 1 = %s \n",p5);
           if (debugmode==1) printf("ROTATEL 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(ROTATEL*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction ROTATER ========================================================== */

	 if(strcmp("ROTATER",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("ROTATER op 1 = %s \n",p5);
           if (debugmode==1) printf("ROTATER op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(ROTATER*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction SHIFTLC ========================================================== */

	 if(strcmp("SHIFTLC",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("SHIFTLC op 1 = %s \n",p5);
           if (debugmode==1) printf("SHIFTLC op 2 = %s \n",p6);



	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(SHIFTLC*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };
 /* Instruction SHIFTRC ========================================================== */

	 if(strcmp("SHIFTRC",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("SHIFTRC op 1 = %s \n",p5);
           if (debugmode==1) printf("SHIFTRC op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(SHIFTRC*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };
 /* Instruction ROTATELC ========================================================== */

	 if(strcmp("ROTATELC",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("ROTATELC op 1 = %s \n",p5);
           if (debugmode==1) printf("ROTATELC op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(ROTATELC*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };
 /* Instruction ROTATERC ========================================================== */

	 if(strcmp("ROTATERC",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("ROTATERC op 1 = %s \n",p5);
           if (debugmode==1) printf("ROTATERC op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(ROTATERC*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };
 /* Instruction ADD ========================================================== */

	 if(strcmp("ADD",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("ADD op 1 = %s \n",p5);
           if (debugmode==1) printf("ADD op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(ADD*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 /* Instruction SUB ========================================================== */

	 if(strcmp("SUB",p1)==0) {
           /* operands in p2 seperated by comma */
	   if (debugmode==1) printf("p2 is %s\n",p2);
	   p2a=strstr(p2,",");
	   strncpy(p5,p2+1,(int)(p2a-p2-1));
	   strcpy(p6,p2a+2);
           if (debugmode==1) printf("SUB op 1 = %s \n",p5);
           if (debugmode==1) printf("SUB op 2 = %s \n",p6);


	   //if a label was in place for this line, then store the pointer
	   if (PointerToThisObjectYN==1) {
	     /* store name and process the line as normal  */
	     printf("defining code pointer %s (%d)\n",pointername,codepointer);
	     PointerToThisObjectYN=0;
	   }; //remember to do this before incrementing code pointer!



	   //now to convert these strings into operand numbers, then add to the core number.
	   instruction=(SUB*1024)+(32*atoi(p5))+atoi(p6);
	   printf("Address %d  Code %d\n",codepointer,instruction);
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
	   codepointer++;
	   
	 };

 
 /* Instruction SYSCALL ========================================================== */
	 
 	 if(strcmp("SYSCALL",p1)==0) { 

 	   //if a label was in place for this line, then store the pointer 
 	   if (PointerToThisObjectYN==1) { 
 	     // store name and process the line as normal 
 	     printf("defining code pointer %s (%d)\n",pointername,codepointer); 
 	     PointerToThisObjectYN=0; 
	   }; //remember to do this before incrementing code pointer! 



 	   instruction=(SYSCALL*1024); 
 	   printf("Address %d  Code %d\n",codepointer,instruction); 
	   fprintf(outputfile,"%d %d\n",codepointer,instruction);
 	   codepointer++; 
	   
 	 }; 


 /* End of Instructions  ========================================================== */

       }; //num of params

	 
     }; //buffer length


   }; //eof

   printf("\n");
   fclose(sourcefile);
   fclose(outputfile);
   fclose(imagefile);

}; //main


















































