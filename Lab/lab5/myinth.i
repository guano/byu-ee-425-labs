# 1 "myinth.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "myinth.c"
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
# 2 "myinth.c" 2
# 1 "yakk.h" 1
# 16 "yakk.h"
extern unsigned int YKCtxSwCount;
extern unsigned int YKIdleCount;
extern unsigned int YKTickNum;




typedef struct taskblock *TCBptr;
typedef struct taskblock
{


 int *stackptr;
 int *ss;

    int state;
    int priority;
    int delay;
    TCBptr next;
    TCBptr prev;
} TCB;

extern TCBptr YKRdyList;

extern TCBptr YKSuspList;
extern TCBptr YKSemaphoreWaitingList;
extern TCBptr YKAvailTCBList;
extern TCB YKTCBArray[4 +1];

typedef struct YKSEM
{
    int value;
    int alive;
} YKSEM;



void YKInitialize(void);


void YKEnterMutex(void);


void YKExitMutex(void);


void YKIdleTask(void);


void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority);


void YKRun(void);


void YKDelayTask(unsigned count);


void YKEnterISR(void);


void YKExitISR(void);


void YKScheduler_old(void);


void YKScheduler(int need_to_save_context);



void YKDispatcher(void);


void YKDispatcher_save_context(int need_to_save_context, int ** save_sp, int ** save_ss,
  int * restore_sp, int * restore_ss);


void YKTickHandler(void);


YKSEM* YKSemCreate(int initialValue);


void YKSemPend(YKSEM *semaphore);


void YKSemPost(YKSEM *semaphore);
# 3 "myinth.c" 2

extern int KeyBuffer;

extern YKSEM *NSemPtr;
extern void YKSemPost(YKSEM *semaphore);

void delay();
extern void YKTickHandler(void);





void c_isr_reset(){

 exit(0);
}

void c_isr_tick(){
 static int tick_number = 0;

 printString("\nTICK ");
 printInt(tick_number++);
 printNewLine();
 YKTickHandler();
}

void c_isr_keypress(){

 char c = (char) KeyBuffer;

 if(c == 'd'){
  printString("\nDELAY KEY PRESSED\n");
  delay();
  printString("\nDELAY COMPLETE\n");
 }
 else if(c == 'p'){

  YKSemPost(NSemPtr);
 }
 else{
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
