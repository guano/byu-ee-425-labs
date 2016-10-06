# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "yakc.c"



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
# 5 "yakc.c" 2
# 1 "yakk.h" 1
# 16 "yakk.h"
extern unsigned int YKCtxSwCount;
extern unsigned int YKIdleCount;
unsigned int YKTickNum;



typedef struct taskblock *TCBptr;
typedef struct taskblock
{
    void *stackptr;
 void *address;
    int state;
    int priority;
    int delay;
    TCBptr next;
    TCBptr prev;
} TCB;

TCBptr YKRdyList;

TCBptr YKSuspList;
TCBptr YKAvailTCBList;
TCB YKTCBArray[3 +1];




void YKInitialize(void);


void YKEnterMutex(void);


void YKExitMutex(void);


void YKIdleTask(void);


void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority);


void YKRun(void);
# 73 "yakk.h"
void YKScheduler(void);



void YKDispatcher(void);
# 6 "yakc.c" 2

YKCtxSwCount = 0;
YKIdleCount = 0;

void YKInitialize(void){
   int i;

    YKIdleTask();





    YKAvailTCBList = &(YKTCBArray[0]);
    for (i = 0; i < 3; i++)
 YKTCBArray[i].next = &(YKTCBArray[i+1]);
    YKTCBArray[3].next = 0;

}
void YKIdleTask(void) {

    while(1){
      YKIdlecount++;
    }

}
# 40 "yakc.c"
void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority) {




 TCBptr tmp, tmp2;

    tmp = YKAvailTCBList;
    YKAvailTCBList = tmp->next;




    if (YKRdyList == 0) {
  YKRdyList = tmp;
  tmp->next = 0;
  tmp->prev = 0;
    } else {
  tmp2 = YKRdyList;
  while (tmp2->priority < tmp->priority)
   tmp2 = tmp2->next;
  if (tmp2->prev == 0)
   YKRdyList = tmp;
  else
   tmp2->prev->next = tmp;
  tmp->prev = tmp2->prev;
  tmp->next = tmp2;
  tmp2->prev = tmp;
    }




 tmp->stackptr = taskStack;


 tmp->delay = 0;


 tmp->address = task;


 tmp->priority = priority;



 YKScheduler();
}





void YKRun(void) {
}







void YKScheduler(void) {

 TCBptr highest_priority_task = YKRdyList;
# 122 "yakc.c"
}







void YKDispatcher(void) {
    YKCtxSwCount ++;
}
