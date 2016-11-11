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
# 18 "yakk.h"
extern unsigned int YKCtxSwCount;
extern unsigned int YKIdleCount;
extern unsigned int YKTickNum;



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
# 3 "myinth.c" 2
# 1 "lab6defs.h" 1
# 9 "lab6defs.h"
struct msg
{
    int tick;
    int data;
};
# 4 "myinth.c" 2
# 20 "myinth.c"
extern YKQ *MsgQPtr;
extern struct msg MsgArray[];
extern int GlobalFlag;




void c_isr_reset(){

 exit(0);
}



void c_isr_tick(void)
{
    static int next = 0;
    static int data = 0;

 YKTickHandler();

    MsgArray[next].tick = YKTickNum;
    data = (data + 89) % 100;
    MsgArray[next].data = data;
    if (YKQPost(MsgQPtr, (void *) &(MsgArray[next])) == 0)
  printString("  TickISR: queue overflow! \n");
    else if (++next >= 20){

  next = 0;
 }else{

 }

}

void c_isr_keypress(void)
{
    GlobalFlag = 1;
}
