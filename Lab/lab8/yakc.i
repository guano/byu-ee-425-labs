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
# 22 "yakk.h"
extern unsigned int YKCtxSwCount;
extern unsigned int YKIdleCount;
extern unsigned int YKTickNum;




typedef struct YKEVENT
{
    int alive;
    unsigned flags;
} YKEVENT;





typedef struct YKSEM
{
    int value;
    int alive;
} YKSEM;


typedef struct YKQ{
 void ** baseptr;
 int length;


 int oldest;
 int next_slot;



 int count;
} YKQ;


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
    YKQ* queue;
    YKEVENT *event;
    unsigned eventMask;
    int waitMode;

} TCB;


extern TCBptr YKRdyList;

extern TCBptr YKSuspList;
extern TCBptr YKSemaphoreWaitingList;
extern TCBptr YKAvailTCBList;
extern TCB YKTCBArray[9 +1];



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


YKQ *YKQCreate(void **start, unsigned size);


void *YKQPend(YKQ *queue);


int YKQPost(YKQ *queue, void *msg);





YKEVENT *YKEventCreate(unsigned initialValue);


unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode);


void YKEventSet(YKEVENT *event, unsigned eventMask);


void YKEventReset(YKEVENT *event, unsigned eventMask);
# 6 "yakc.c" 2




int idleStack[256];

unsigned int YKCtxSwCount;
unsigned int YKIdleCount;
unsigned int YKTickNum;
unsigned int YKISRCallDepth;

TCBptr YKRdyList;
TCBptr YKSuspList;
TCBptr YKAvailTCBList;
TCB YKTCBArray[9 +1];
YKSEM YKSEMArray[1];
YKQ YKQueueArray[4];
YKEVENT YKEVENTArray[2];


TCBptr YKSemaphoreWaitingList;
TCBptr YKQueueWaitingList;
TCBptr YKEventBlockingList;



TCBptr YKCurrentlyExecuting;



char started_running = 0;


void printQueue(YKQ * queue);


void YKInitialize(void){
 int i;


 YKCtxSwCount = 0;
 YKIdleCount = 0;
 YKCurrentlyExecuting = 0;
 YKISRCallDepth = 0;






 YKEnterMutex();
    YKAvailTCBList = &(YKTCBArray[0]);
    for (i = 0; i < 9; i++)
  YKTCBArray[i].next = &(YKTCBArray[i+1]);
    YKTCBArray[9].next = 0;


    for (i = 0; i < 1; i++)
    {
  YKSEMArray[i].alive = 0;
  YKSEMArray[i].value = -10;
    }

 for(i=0; i<4; i++){
  YKQueueArray[i].baseptr = 0;
  YKQueueArray[i].length = 0;
  YKQueueArray[i].oldest = 0;
  YKQueueArray[i].next_slot = 0;
  YKQueueArray[i].count = 0;
 }


 YKNewTask(YKIdleTask, (void *)&idleStack[256], 100);
}

void YKIdleTask(void) {

 while(1){

  YKEnterMutex();
  YKIdleCount = YKIdleCount+1;
  YKExitMutex();
 }

}
# 99 "yakc.c"
void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority){



 TCBptr tmp, tmp2;
# 112 "yakc.c"
 taskStack = ((int *)taskStack) - 1;


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
# 159 "yakc.c"
 tmp->stackptr = taskStack;



 tmp->ss = 0;
# 177 "yakc.c"
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

  YKDispatcher_save_context(0,(int **) 1, (int **)1,
    highest_priority_task->stackptr, highest_priority_task->ss);
 } else {




  YKDispatcher_save_context(need_to_save_context,
    &(currentlyExecuting->stackptr), &(currentlyExecuting->ss),
    highest_priority_task->stackptr, highest_priority_task->ss);
 }
}


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



void YKTickHandler(void)
{
  TCBptr tmp, tmp2,tmp_next;




  tmp = YKSuspList;
  YKEnterMutex();
  YKTickNum = YKTickNum +1;

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







YKEVENT *YKEventCreate(unsigned initialValue)
{

    int i;
    YKEnterMutex();

    i = 0;

    while(YKEVENTArray[i].alive) {
        i++;
    }


    YKEVENTArray[i].flags = initialValue;
    YKEVENTArray[i].alive = 1;

    return &(YKEVENTArray[i]);
}


unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode)
{
    TCBptr tmp;
    unsigned tmp1;




    YKEnterMutex();
    if(waitMode == 0)
    {
  if((event->flags & eventMask) > 0)
  {
   tmp1 = event->flags;
   YKExitMutex();
   return tmp1;
  }
    }
    else
    {
      if(event->flags & eventMask == eventMask)
      {
 tmp1 = event->flags;
 YKExitMutex();
 return tmp1;
      }
    }






    tmp = YKRdyList;
    YKRdyList = tmp->next;
    tmp->next->prev = 0;
    tmp->next = YKEventBlockingList;
    YKEventBlockingList = tmp;
    tmp->prev = 0;
    if (tmp->next != 0)
       tmp->next->prev = tmp;
    tmp->event = event;
 tmp->eventMask = eventMask;
 tmp->waitMode = waitMode;

    YKScheduler(1);
    tmp1 = event->flags;
    YKExitMutex();
    return tmp1;
}


void YKEventSet(YKEVENT *event, unsigned eventMask)
{
 TCBptr tmp, tmp2, tmp_next, task_to_unblock;


 YKEnterMutex();
 tmp = YKEventBlockingList;

 event->flags = event->flags | eventMask;

 if(tmp == 0){
  YKExitMutex();
  return;
 }

 while(tmp != 0){
     tmp_next = tmp->next;
     if(tmp->event != event)
     {
   tmp = tmp_next;
   continue;
     }

     if(tmp->waitMode == 0)
     {
   if((event->flags & tmp->eventMask) > 0)
   {


       task_to_unblock = tmp;
   }
   else
   {
    task_to_unblock = 0;
   }
     }
     else
     {
   if((event->flags & tmp->eventMask) == tmp->eventMask)
   {
    task_to_unblock = tmp;
   }
   else
   {
    task_to_unblock = 0;
   }
     }

  if(task_to_unblock != 0)
  {




   if (task_to_unblock->prev == 0)
    YKEventBlockingList = task_to_unblock->next;
   else
    task_to_unblock->prev->next = task_to_unblock->next;
   if (task_to_unblock->next != 0)
    task_to_unblock->next->prev = task_to_unblock->prev;
   tmp2 = YKRdyList;
   while (tmp2->priority < task_to_unblock->priority)
    tmp2 = tmp2->next;
   if (tmp2->prev == 0)
    YKRdyList = task_to_unblock;
   else
    tmp2->prev->next = task_to_unblock;
   task_to_unblock->prev = tmp2->prev;
   task_to_unblock->next = tmp2;
   tmp2->prev = task_to_unblock;

   task_to_unblock->event = 0;
  }


  tmp = tmp_next;
 }
 if(YKISRCallDepth == 0){
  YKScheduler(1);
 }
 YKExitMutex();
 return;
}


void YKEventReset(YKEVENT *event, unsigned eventMask)
{

   event->flags = ~eventMask & event->flags;







}



YKSEM* YKSemCreate(int initialValue)
{
    int i;
 YKEnterMutex();

    i = 0;

    while(YKSEMArray[i].alive) {
        i++;
    }


    YKSEMArray[i].value = initialValue;
 YKSEMArray[i].alive = 1;
# 550 "yakc.c"
    return &(YKSEMArray[i]);
}
# 561 "yakc.c"
void YKSemPend(YKSEM *semaphore)
{
    TCBptr tmp;
    YKEnterMutex();




    semaphore->value = semaphore->value - 1;



    YKExitMutex();
    if(semaphore->value >= 0){

   return;
    }



 YKEnterMutex();
# 590 "yakc.c"
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
# 618 "yakc.c"
void YKSemPost(YKSEM *semaphore)
{
 TCBptr tmp, tmp2,tmp_next, task_to_unblock;
 task_to_unblock = 0;
 tmp = YKSemaphoreWaitingList;

 YKEnterMutex();

 semaphore->value = semaphore->value + 1;



 while(tmp != 0){
  if(tmp->sem == semaphore){

   if(task_to_unblock == 0){

    task_to_unblock = tmp;
   } else if(tmp->priority < task_to_unblock->priority) {

    task_to_unblock = tmp;
   }
  }
  tmp = tmp->next;
 }


 if(task_to_unblock == 0){
# 658 "yakc.c"
  YKExitMutex();
  return;
 }




 if (task_to_unblock->prev == 0)
  YKSemaphoreWaitingList = task_to_unblock->next;
 else
  task_to_unblock->prev->next = task_to_unblock->next;
 if (task_to_unblock->next != 0)
  task_to_unblock->next->prev = task_to_unblock->prev;
 tmp2 = YKRdyList;
 while (tmp2->priority < task_to_unblock->priority)
  tmp2 = tmp2->next;
 if (tmp2->prev == 0)
  YKRdyList = task_to_unblock;
 else
  tmp2->prev->next = task_to_unblock;
 task_to_unblock->prev = tmp2->prev;
 task_to_unblock->next = tmp2;
 tmp2->prev = task_to_unblock;

 task_to_unblock->sem = 0;

 if (YKISRCallDepth == 0)
 {

   YKScheduler(1);
 }


 YKExitMutex();
 return;
}





YKQ *YKQCreate(void **start, unsigned size){
 int i;

 YKEnterMutex();






 i = 0;
 while(YKQueueArray[i].baseptr){
  i++;
 }






 YKQueueArray[i].baseptr = start;
 YKQueueArray[i].length = size;
 YKQueueArray[i].oldest = 0;
 YKQueueArray[i].next_slot = 0;
 YKQueueArray[i].count = 0;





 return &(YKQueueArray[i]);
}


void *YKQPend(YKQ *queue){
 TCBptr tmp;
 void * message;

 YKEnterMutex();







 if(queue->count == 0){




  tmp = YKRdyList;
  YKRdyList = tmp->next;
  tmp->next->prev = 0;
  tmp->next = YKQueueWaitingList;
  YKQueueWaitingList = tmp;
  tmp->prev = 0;
  if (tmp->next != 0)
   tmp->next->prev = tmp;
  tmp->queue = queue;





  YKScheduler(1);
 }





 message = *(queue->baseptr + queue->oldest);


 queue->count = queue->count - 1;


 queue->oldest = (queue->oldest + 1 < queue->length) ?
  queue->oldest + 1 : 0 ;


 YKExitMutex();
 return message;
}


int YKQPost(YKQ *queue, void *msg){
 TCBptr tmp, task_to_unblock;

 YKEnterMutex();
# 799 "yakc.c"
 if(queue->count == queue->length -1){
  printString("think the queue is full?\n");
  return 0;
 }

 task_to_unblock = 0;
 tmp = YKQueueWaitingList;


 *(queue->baseptr + queue->next_slot) = msg;


 queue->count = queue->count + 1;


 queue->next_slot = (queue->next_slot + 1 < queue->length) ?
  queue->next_slot + 1 : 0 ;






 while(tmp != 0){
  if(tmp->queue == queue){

   if(!task_to_unblock){

    task_to_unblock = tmp;
   } else if(tmp->priority < task_to_unblock->priority) {

    task_to_unblock = tmp;
   }
  }
  tmp = tmp->next;
 }



 if(task_to_unblock == 0){
  YKExitMutex();

  return 1;
 }





 if (task_to_unblock->prev == 0)
  YKQueueWaitingList = task_to_unblock->next;
 else
  task_to_unblock->prev->next = task_to_unblock->next;
 if (task_to_unblock->next != 0)
  task_to_unblock->next->prev = task_to_unblock->prev;
 tmp = YKRdyList;
 while (tmp->priority < task_to_unblock->priority)
  tmp = tmp->next;
 if (tmp->prev == 0)
  YKRdyList = task_to_unblock;
 else
  tmp->prev->next = task_to_unblock;
 task_to_unblock->prev = tmp->prev;
 task_to_unblock->next = tmp;
 tmp->prev = task_to_unblock;

 task_to_unblock->queue = 0;
# 875 "yakc.c"
 if (YKISRCallDepth == 0){

  YKScheduler(1);
 }

 YKExitMutex();
 return 1;
}


void printQueue(YKQ * queue){
 int i;
 YKEnterMutex();
 printString("printing queue ");
 printInt((int) queue);


 printString("\tlength= ");
 printInt((int) queue->length);
 printString("\toldest= ");
 printInt((int) queue->oldest);
 printString("\tnext_slot= ");
 printInt((int) queue->next_slot);
 printString("\tcount= ");
 printInt((int) queue->count);
# 908 "yakc.c"
 printString("\n");

 YKExitMutex();
}
