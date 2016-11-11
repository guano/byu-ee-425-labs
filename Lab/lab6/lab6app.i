# 1 "lab6app.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "lab6app.c"






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
# 8 "lab6app.c" 2
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
# 9 "lab6app.c" 2
# 1 "lab6defs.h" 1
# 9 "lab6defs.h"
struct msg
{
    int tick;
    int data;
};
# 10 "lab6app.c" 2




struct msg MsgArray[20];

int ATaskStk[512];
int BTaskStk[512];
int STaskStk[512];

int GlobalFlag;

void *MsgQ[10];
YKQ *MsgQPtr;

void ATask(void)
{
    struct msg *tmp;
    int min, max, count;

    min = 100;
    max = 0;
    count = 0;

    while (1)
    {
        tmp = (struct msg *) YKQPend(MsgQPtr);


        if (tmp->tick != count+1)
        {
            print("! Dropped msgs: tick ", 21);
            if (tmp->tick - (count+1) > 1) {
                printInt(count+1);
                printChar('-');
                printInt(tmp->tick-1);
                printNewLine();
            }
            else {
                printInt(tmp->tick-1);
                printNewLine();
            }
        }


        count = tmp->tick;


        if (tmp->data < min)
            min = tmp->data;
        if (tmp->data > max)
            max = tmp->data;


        print("Ticks: ", 7);
        printInt(count);
        print("\t", 1);
        print("Min: ", 5);
        printInt(min);
        print("\t", 1);
        print("Max: ", 5);
        printInt(max);
        printNewLine();
    }
}

void BTask(void)
{
    int busycount, curval, j, flag, chcount;
    unsigned tickNum;

    curval = 1001;
    chcount = 0;

    while (1)
    {
        YKDelayTask(2);

        if (GlobalFlag == 1)
        {
            YKEnterMutex();
            busycount = YKTickNum;
            YKExitMutex();

            while (1)
            {
                YKEnterMutex();
                tickNum = YKTickNum;
                YKExitMutex();
                if(tickNum >= busycount + 5) break;

                curval += 2;
                flag = 0;
                for (j = 3; (j*j) < curval; j += 2)
                {
                    if (curval % j == 0)
                    {
                        flag = 1;
                        break;
                    }
                }
                if (!flag)
                {
                    printChar('.');
                    if (++chcount > 75)
                    {
                        printNewLine();
                        chcount = 0;
                    }
                }
            }
            printNewLine();
            chcount = 0;
            GlobalFlag = 0;
        }
    }
}

void STask(void)
{
    unsigned max, switchCount, idleCount;
    int tmp;

    YKDelayTask(1);
    printString("Welcome to the YAK kernel\r\n");
    printString("Determining CPU capacity\r\n");
    YKDelayTask(1);
    YKIdleCount = 0;
    YKDelayTask(5);
    max = YKIdleCount / 25;
    YKIdleCount = 0;

    YKNewTask(BTask, (void *) &BTaskStk[512], 10);
    YKNewTask(ATask, (void *) &ATaskStk[512], 20);

    while (1)
    {
        YKDelayTask(20);

        YKEnterMutex();
        switchCount = YKCtxSwCount;
        idleCount = YKIdleCount;
        YKExitMutex();

        printString("<<<<< Context switches: ");
        printInt((int)switchCount);
        printString(", CPU usage: ");
        tmp = (int) (idleCount/max);
        printInt(100-tmp);
        printString("% >>>>>\r\n");

        YKEnterMutex();
        YKCtxSwCount = 0;
        YKIdleCount = 0;
        YKExitMutex();
    }
}

void main(void)
{
    YKInitialize();


    GlobalFlag = 0;
    MsgQPtr = YKQCreate(MsgQ, 10);
    YKNewTask(STask, (void *) &STaskStk[512], 30);

    YKRun();
}
