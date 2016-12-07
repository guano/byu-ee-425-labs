# 1 "lab8app.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "lab8app.c"







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
# 9 "lab8app.c" 2
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
# 10 "lab8app.c" 2
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
# 11 "lab8app.c" 2
# 1 "simptris.h" 1


void SlidePiece(int ID, int direction);
void RotatePiece(int ID, int direction);
void SeedSimptris(long seed);
void StartSimptris(void);
# 12 "lab8app.c" 2







int movePieceTaskStk[512];
int newPieceTaskStk[512];

struct newPiece newPieceArray[20];
void * newPieceQueue[10];
YKQ * newPieceQueuePTR;

struct pieceMove movePieceArray[40];
int movePieceArrayIndex;
void * movePieceQueue[20];
YKQ * movePieceQueuePTR;


YKEVENT * pieceMoveEvent;
# 54 "lab8app.c"
unsigned screen0;
unsigned screen1;
unsigned screen2;


unsigned screen3;
unsigned screen4;
unsigned screen5;
# 72 "lab8app.c"
int getMovePieceQueueArrayIndex(void){
 if(movePieceArrayIndex == 40 ){
  movePieceArrayIndex = 0;
 }

 return movePieceArrayIndex ++;
}


int getLowerBucket(void){
 int left = 0;
 int right = 0;
 int screen0Temp = screen0;
 int screen3Temp = screen3;


 while(screen0Temp){
  left = left + 1;
  screen0Temp = screen0Temp << 1;
 }


 while(screen3Temp){
  right = right +1;
  screen3Temp = screen3Temp << 1;
 }

 return right > left;
}



int isBucketFlat(int bucket){

 int columnLeft;
 int columnRight;


 if(bucket){
  columnLeft = screen3;
  columnRight = screen5;
 } else {
  columnLeft = screen0;
  columnRight = screen2;
 }


 while(columnLeft && columnRight){
  columnLeft << 1;
  columnRight << 1;
 }



 return columnLeft == columnRight;
}

int getLowestSpace(int column){
 int space = 0;
 int screenCopy;

 switch(column){
  case 0:
   screenCopy = screen0;
   break;
  case 1:
   screenCopy = screen1;
   break;
  case 2:
   screenCopy = screen2;
   break;
  case 3:
   screenCopy = screen3;
   break;
  case 4:
   screenCopy = screen4;
   break;
  case 5:
   screenCopy = screen5;
   break;
  default:
   printString("You really want a column not 0-5???\n");
   break;
 }

 while(screenCopy){
  space = space + 1;
  screenCopy = screenCopy << 1;
 }

}

void tryToClearLine(int row){
 if(screen0 & (1<<row) &&
  screen1 & (1<<row) &&
  screen2 & (1<<row) &&
  screen3 & (1<<row) &&
  screen4 & (1<<row) &&
  screen5 & (1<<row) ){


  if(row == 0){
   screen0 = screen0 << 1;
   screen1 = screen1 << 1;
   screen2 = screen2 << 1;
   screen3 = screen3 << 1;
   screen4 = screen4 << 1;
   screen5 = screen5 << 1;
  }
  else {
   printString("CODE NOT WRITTEN :'(");
  }
 }
}

int newPieceTask(void)
{
 struct newPiece * message;
 int lowerBucket;
 int pieceColumn;
 int tempIndex;
 int rowAffected;
 int bucketAffected;

 printString("newPieceTask moving!\n");
 StartSimptris();
 while(1)
 {

  message = (struct newPiece *) YKQPend(newPieceQueuePTR);





  if(message->type == 1){

   lowerBucket = getLowerBucket();
   pieceColumn = message->column;




   rowAffected = getLowestSpace(lowerBucket?3:0);
   bucketAffected = lowerBucket;






   lowerBucket = lowerBucket ? 4 : 1 ;



   while(pieceColumn < lowerBucket){
    tempIndex = getMovePieceQueueArrayIndex();

    movePieceArray[tempIndex].id = message->id;
    movePieceArray[tempIndex].direction = 1;
    movePieceArray[tempIndex].functionPtr = SlidePiece;
    pieceColumn = pieceColumn + 1;
    YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
   }
   while(pieceColumn > lowerBucket){
    tempIndex = getMovePieceQueueArrayIndex();

    movePieceArray[tempIndex].id = message->id;
    movePieceArray[tempIndex].direction = 0;
    movePieceArray[tempIndex].functionPtr = SlidePiece;
    pieceColumn = pieceColumn - 1;
    YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
   }




   if(message->orientation){
    int tempIndex = getMovePieceQueueArrayIndex();

    movePieceArray[tempIndex].id = message->id;
    movePieceArray[tempIndex].direction = 1;


    movePieceArray[tempIndex].functionPtr = RotatePiece;

    YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
   }





   if(!bucketAffected){
    screen0 = screen0 | (1 << rowAffected);
    screen1 = screen1 | (1 << rowAffected);
    screen2 = screen2 | (1 << rowAffected);
   }
   tryToClearLine(rowAffected);
  }
  else {

   lowerBucket = getLowerBucket();
   pieceColumn = message->column;


   if(isBucketFlat(lowerBucket)){
    if(isBucketFlat(!lowerBucket)){



     if(lowerBucket){
      lowerBucket = 3;


      while(pieceColumn < lowerBucket){
       tempIndex = getMovePieceQueueArrayIndex();

       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn + 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      while(pieceColumn > lowerBucket){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn - 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }


      if(message->orientation == 3){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 2){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 2 || message->orientation == 1){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
     }
     else {

      if(pieceColumn == 0 && message->orientation != 0){

       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn + 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      } else if(pieceColumn == 5 && message->orientation != 0){

       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn - 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }


      if(message->orientation == 3){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 2){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 2 || message->orientation == 1){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }


      while(pieceColumn > lowerBucket){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn - 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
     }

    }
    else {

     lowerBucket = !lowerBucket;


     lowerBucket = lowerBucket ? 5 : 2;


     if(lowerBucket == 5){

      if(pieceColumn == 0 && message->orientation != 2){

       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn + 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      } else if(pieceColumn == 5 && message->orientation != 2){

       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn - 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }


      if(message->orientation == 1){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 0){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 0 || message->orientation == 3){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }


      while(pieceColumn < lowerBucket){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn + 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
     }
     else{



      while(pieceColumn < lowerBucket){
       tempIndex = getMovePieceQueueArrayIndex();

       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn + 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      while(pieceColumn > lowerBucket){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn - 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }


      if(message->orientation == 1){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 0){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 0 || message->orientation == 3){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
     }
    }
   }
   else {

    lowerBucket = lowerBucket ? 5 : 2;

     if(lowerBucket == 5){

      if(pieceColumn == 0 && message->orientation != 2){

       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn + 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      } else if(pieceColumn == 5 && message->orientation != 2){

       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn - 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }


      if(message->orientation == 1){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 0){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 0 || message->orientation == 3){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }


      while(pieceColumn < lowerBucket){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn + 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
     }
     else{



      while(pieceColumn < lowerBucket){
       tempIndex = getMovePieceQueueArrayIndex();

       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn + 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      while(pieceColumn > lowerBucket){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = SlidePiece;
       pieceColumn = pieceColumn - 1;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }


      if(message->orientation == 1){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 0;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 0){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
      if(message->orientation == 0 || message->orientation == 3){
       tempIndex = getMovePieceQueueArrayIndex();
       movePieceArray[tempIndex].id = message->id;
       movePieceArray[tempIndex].direction = 1;
       movePieceArray[tempIndex].functionPtr = RotatePiece;
       YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
      }
     }
   }
  }
 }
}

int movePieceTask(void)
{
 struct pieceMove * message;
 printString("movePieceTask moveing!\n");
 while(1)
 {

  YKEventPend(pieceMoveEvent, 1 , 1);

  YKEventReset(pieceMoveEvent, 1);

     printString("piece move event. getting move now\n");


  message = (struct pieceMove *) YKQPend(movePieceQueuePTR);

     printString("got a piece. ID ");
     printInt(message->id);
     printString("\n");



  message->functionPtr(message->id, message->direction);
 }

}


void main(void)
{
 YKInitialize();

 newPieceQueuePTR = YKQCreate(newPieceQueue, 10);
 movePieceQueuePTR= YKQCreate(movePieceQueue,20);
 pieceMoveEvent = YKEventCreate(1);

 SeedSimptris(191);

 YKNewTask(newPieceTask, (void *) &newPieceTaskStk[512], 2);
 YKNewTask(movePieceTask, (void *) &movePieceTaskStk[512],3);
 YKRun();
}
