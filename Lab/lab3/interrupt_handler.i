# 1 "interrupt_handler.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "interrupt_handler.c"
# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 2 "interrupt_handler.c" 2


extern int KeyBuffer;


void delay();





void c_isr_reset(){

 exit(0);
}

void c_isr_tick(){
 static int tick_number = 0;

 printString("\nTICK ");
 printInt(tick_number++);
 printNewLine();
}

void c_isr_keypress(){

 char c = (char) KeyBuffer;

 if(c == 'd'){
  printString("\nDELAY KEY PRESSED\n");
  delay();
  printString("\nDELAY COMPLETE\n");
 } else{
  printString("\nKEYPRESS (");
  printChar(c);
  printString(") IGNORED\n");
 }
}


void delay(){
 int i = 0;
 for(i=0; i<5000; i++){
  ;
 }
}
