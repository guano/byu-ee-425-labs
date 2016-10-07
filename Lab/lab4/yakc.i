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
extern unsigned int YKTickNum;



typedef struct taskblock *TCBptr;
typedef struct taskblock
{


 int *stackptr;

    int state;
    int priority;
    int delay;
    TCBptr next;
    TCBptr prev;
} TCB;

extern TCBptr YKRdyList;

extern TCBptr YKSuspList;
extern TCBptr YKAvailTCBList;
extern TCB YKTCBArray[3 +1];




void YKInitialize(void);


void YKEnterMutex(void);


void YKExitMutex(void);


void YKIdleTask(void);


void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority);


void YKRun(void);
# 75 "yakk.h"
void YKScheduler(void);



void YKDispatcher(void);
# 6 "yakc.c" 2




int idleStack[256];

unsigned int YKCtxSwCount;
unsigned int YKIdleCount;
unsigned int YKTickNum;

TCBptr YKRdyList;
TCBptr YKSuspList;
TCBptr YKAvailTCBList;
TCB YKTCBArray[3 +1];



char started_running = 0;


void YKInitialize(void){
 int i;


 YKCtxSwCount = 0;
 YKIdleCount = 0;






    YKAvailTCBList = &(YKTCBArray[0]);
    for (i = 0; i < 3; i++)
 YKTCBArray[i].next = &(YKTCBArray[i+1]);
    YKTCBArray[3].next = 0;






 YKNewTask(YKIdleTask, (void *)&idleStack[256], 100);

}

void YKIdleTask(void) {

    while(1){
  YKIdleCount++;
    }

}
# 67 "yakc.c"
void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority){



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

  tmp->stackptr = tmp->stackptr + 12;
  *(tmp->stackptr-12) = 0;
  *(tmp->stackptr-11) = 0;
  *(tmp->stackptr-10) = (int)task;
  *(tmp->stackptr-9) = 0;
  *(tmp->stackptr-8) = 0;
  *(tmp->stackptr-7) = 0;
  *(tmp->stackptr-6) = 0;
  *(tmp->stackptr-5) = 0;
  *(tmp->stackptr-4) = 0;
  *(tmp->stackptr-3) = 0;
  *(tmp->stackptr-2) = 0;
  *(tmp->stackptr-1) = 0;


 tmp->delay = 0;





 tmp->priority = priority;


 YKScheduler();
}





void YKRun(void) {
 started_running = 1;
 YKScheduler();
}







void YKScheduler(void) {

 TCBptr highest_priority_task = YKRdyList;
# 166 "yakc.c"
 if(started_running){
  YKDispatcher();
 }
}
