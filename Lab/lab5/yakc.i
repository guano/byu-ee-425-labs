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



typedef struct YKSEM
{
    int value;
    int alive;
} YKSEM;

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

    YKSEM *sem;

} TCB;

extern TCBptr YKRdyList;

extern TCBptr YKSuspList;
extern TCBptr YKSemaphoreWaitingList;
extern TCBptr YKAvailTCBList;
extern TCB YKTCBArray[4 +1];



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
# 6 "yakc.c" 2




int idleStack[256];

unsigned int YKCtxSwCount;
unsigned int YKIdleCount;
unsigned int YKTickNum;
unsigned int YKISRCallDepth;

TCBptr YKRdyList;
TCBptr YKSuspList;
TCBptr YKAvailTCBList;
TCB YKTCBArray[4 +1];
YKSEM YKSEMArray[4];

TCBptr YKSemaphoreWaitingList;

TCBptr YKCurrentlyExecuting;



char started_running = 0;

void YKInitialize(void){
 int i;


 YKCtxSwCount = 0;
 YKIdleCount = 0;
 YKCurrentlyExecuting = 0;
 YKISRCallDepth = 0;






 YKEnterMutex();
    YKAvailTCBList = &(YKTCBArray[0]);
    for (i = 0; i < 4; i++)
 YKTCBArray[i].next = &(YKTCBArray[i+1]);
    YKTCBArray[4].next = 0;


    for (i = 0; i < 4; i++)
    {
 YKSEMArray[i].alive = 0;
    }



 YKNewTask(YKIdleTask, (void *)&idleStack[256], 100);
}

void YKIdleTask(void) {

 while(1){

  YKIdleCount = YKIdleCount+1;
  YKExitMutex();
 }

}
# 79 "yakc.c"
void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority){



 TCBptr tmp, tmp2;






 tmp = YKAvailTCBList;
 YKAvailTCBList = tmp->next;



 tmp->delay = 0;






 tmp->priority = priority;

YKEnterMutex();




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
YKExitMutex();
# 135 "yakc.c"
 tmp->stackptr = taskStack;
 printString("Address for new task's SP is ");
 printInt((int) &(tmp->stackptr));
 printString("\n");
 tmp->ss = 0;


 tmp->stackptr = tmp->stackptr - 11;
 *(tmp->stackptr+11) = 0x200;
 *(tmp->stackptr+10) = 0;
 *(tmp->stackptr+9) = (int)task;
 *(tmp->stackptr+8) = 0;
 *(tmp->stackptr+7) = 0;
 *(tmp->stackptr+6) = 0;
 *(tmp->stackptr+5) = 0;
 *(tmp->stackptr+4) = 0;
 *(tmp->stackptr+3) = 0;
 *(tmp->stackptr+2) = 0;
 *(tmp->stackptr+1) = 0;
 *(tmp->stackptr+0) = 0;




 YKScheduler(1);
}





void YKRun(void) {
 printString("run called. Calling the scheduler\n");
 started_running = 1;
 YKScheduler(0);
}







void YKScheduler_old(void) {

 TCBptr highest_priority_task = YKRdyList;

 printString("THIS SHOULD NEVER HAPPEN\nTHIS SHOULD NEVER HAPPEN\n");
 printString("scheduler here. dispatcher will load ");
 printInt((int)highest_priority_task);
 printString(" which has stack ");
 printInt((int)highest_priority_task->stackptr);
 printString("\n");
# 207 "yakc.c"
 if(started_running){
  if(YKCurrentlyExecuting == highest_priority_task){
   return;
  }

  YKCtxSwCount = YKCtxSwCount + 1;
  YKCurrentlyExecuting = highest_priority_task;

  YKDispatcher();
 }
}

void YKScheduler(int need_to_save_context){
 TCBptr highest_priority_task = YKRdyList;
 TCBptr currentlyExecuting = YKCurrentlyExecuting;







 if(!started_running){

  return;
 }
 if(YKCurrentlyExecuting == highest_priority_task){

  return;
 }

 YKCtxSwCount = YKCtxSwCount + 1;
 YKCurrentlyExecuting = highest_priority_task;


 if(!need_to_save_context){
# 251 "yakc.c"
  YKDispatcher_save_context(0,(int **) 1, (int **)1,
    highest_priority_task->stackptr, highest_priority_task->ss);
 } else {
# 268 "yakc.c"
  YKDispatcher_save_context(need_to_save_context,
    &(currentlyExecuting->stackptr), &(currentlyExecuting->ss),
    highest_priority_task->stackptr, highest_priority_task->ss);
 }
}
# 286 "yakc.c"
void YKDelayTask(unsigned count)
{
  TCBptr tmp;
  YKEnterMutex();




  if(count != 0)
  {




    tmp = YKRdyList;
    YKRdyList = tmp->next;
    tmp->next->prev = 0;
    tmp->next = YKSuspList;
    YKSuspList = tmp;
    tmp->prev = 0;
    if (tmp->next != 0)
 tmp->next->prev = tmp;
    tmp->delay = count;
  }
  else
  {
    YKExitMutex();
    return;
  }

  YKScheduler(1);
  YKExitMutex();
}
# 334 "yakc.c"
void YKTickHandler(void)
{
  TCBptr tmp, tmp2,tmp_next;




  tmp = YKSuspList;
  YKEnterMutex();

  while(tmp != 0)
  {

    tmp_next = tmp->next;
    tmp->delay = tmp->delay - 1;
    if(tmp->delay == 0)
    {




      if (tmp->prev == 0)
 YKSuspList = tmp->next;
      else
 tmp->prev->next = tmp->next;
      if (tmp->next != 0)
 tmp->next->prev = tmp->prev;

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
    tmp = tmp_next;
  }
  YKExitMutex();
}

void YKEnterISR(void)
{
  YKISRCallDepth = YKISRCallDepth+1;
}

void YKExitISR(void)
{
 YKISRCallDepth = YKISRCallDepth-1;


  if(YKISRCallDepth == 0)
  {

    YKScheduler(0);
  }






}


YKSEM* YKSemCreate(int initialValue)
{
    int i;


    i = 0;

    while(YKSEMArray[i].alive)
    {
        i++;
    }


    YKSEMArray[i].value = initialValue;


    return &(YKSEMArray[i]);
}
# 430 "yakc.c"
void YKSemPend(YKSEM *semaphore)
{
    TCBptr tmp;
    YKEnterMutex();
    semaphore->value = semaphore->value - 1;
    YKExitMutex();
    if(semaphore->value >= 0){
   return;
    }
# 450 "yakc.c"
  YKEnterMutex();
# 459 "yakc.c"
    tmp = YKRdyList;
    YKRdyList = tmp->next;
    tmp->next->prev = 0;
    tmp->next = YKSemaphoreWaitingList;
    YKSemaphoreWaitingList = tmp;
    tmp->prev = 0;
    if (tmp->next != 0)
 tmp->next->prev = tmp;
    tmp->sem = semaphore;


    YKScheduler(1);
    YKExitMutex();
}
# 487 "yakc.c"
void YKSemPost(YKSEM *semaphore)
{

  TCBptr tmp, tmp2,tmp_next;
  tmp = YKSemaphoreWaitingList;

  YKEnterMutex();

  semaphore->value = semaphore->value + 1;

  while(tmp != 0)
  {
    tmp_next = tmp->next;

    if(tmp->sem == semaphore)
    {



      if (tmp->prev == 0)
 YKSemaphoreWaitingList = tmp->next;
      else
 tmp->prev->next = tmp->next;
      if (tmp->next != 0)
 tmp->next->prev = tmp->prev;

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
    tmp = tmp_next;
  }
  if (YKISRCallDepth == 0)
  {
     YKScheduler(1);
  }


  YKExitMutex();

}
