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
# 3 "myinth.c" 2
# 1 "lab8defs.h" 1


extern YKQ * movePieceQueuePTR;
extern YKQ * newPieceQueuePTR;
extern YKEVENT * pieceMoveEvent;
# 21 "lab8defs.h"
struct newPiece
{

 unsigned id;


 unsigned type;
# 37 "lab8defs.h"
 unsigned orientation;


 unsigned column;
};



struct pieceMove
{

 unsigned id;





 void (*functionPtr)(int,int);


 int direction;

};
# 4 "myinth.c" 2





extern int KeyBuffer;


extern unsigned NewPieceID;
extern unsigned NewPieceType;
extern unsigned NewPieceOrientation;
extern unsigned NewPieceColumn;

extern YKQ *newPieceQueuePTR;
extern struct newPiece newPieceArray[];
# 30 "myinth.c"
extern YKQ *MsgQPtr;
extern struct msg MsgArray[];




extern YKEVENT * charEvent;
extern YKEVENT * numEvent;


void c_isr_reset(){

 exit(0);
}



void c_isr_tick(void)
{



 YKTickHandler();
# 66 "myinth.c"
}

void c_isr_keypress(void)
{

    char c;
    c = KeyBuffer;
# 82 "myinth.c"
      print("\nKEYPRESS (", 11);
      printChar(c);
      print(") IGNORED\n", 10);

}

void c_isr_game_over(void)
{
    printString("\nGAME OVER\n");
    exit(0);
}

void c_isr_new_piece(void)
{
    unsigned t = NewPieceType;
    unsigned orient = NewPieceOrientation;
    unsigned id = NewPieceID;
    unsigned col = NewPieceColumn;


    static int next = 0;
    printString("\n*****new piece appeared on board*****\n");

    newPieceArray[next].id = id;
    newPieceArray[next].type = t;
    newPieceArray[next].orientation = orient;
    newPieceArray[next].column = col;


    YKQPost(newPieceQueuePTR, (void *) &(newPieceArray[next]));
    next = next + 1;
    if(next == 40)
    {
 next = 0;
    }
}

void c_isr_received(void)
{

    YKEventSet(pieceMoveEvent, 1);

}
