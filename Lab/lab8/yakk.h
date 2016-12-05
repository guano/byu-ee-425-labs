#ifndef YAKK_H
#define YAKK_H

// A .h file for kernel code, not modified by the user.
// It should include declarations such as TCB, YKSEM, and YKW,
// as well as prototypes for the kernel functions.
// Global variables shared by kernel and application code should be declared
// as extern in this file


#define NULL 0
#define MAXTASKS 9	// count of user tasks
#define MAXSEMAPHORES 19 
#define MAXQUEUES 2
#define MAXEVENTS 2 

#define EVENT_WAIT_ANY 0
#define EVENT_WAIT_ALL 1

// ----------------------
// Also- global variables
extern unsigned int YKCtxSwCount;	// incremented every context switch
extern unsigned int YKIdleCount;	// incremented by idle task in while(1) loop
extern unsigned int YKTickNum;		// incremented by tick handler

// End global variables
// ----------------------

typedef struct YKEVENT
{
    int alive;
    unsigned flags;
} YKEVENT;



/***************************************************************/

typedef struct YKSEM 
{
    int value;    // if value == 1, then semaphore is ready for taking
    int alive;    // if alive == 0, then semaphore slot is uninitialized 
} YKSEM;


typedef struct YKQ{
	void ** baseptr;	// Will also tell us if we are alive (if !0)
	int length;

	// These are indexes into the ** baseptr array
	int oldest;
	int next_slot;

	// This is how many things are in the queue.
	// If count == 0 -> empty, if count == length -1 -> full
	int count;
} YKQ;
/***************************************************************/

typedef struct taskblock *TCBptr;
typedef struct taskblock
{				/* the TCB struct definition */
	// Why is this a void pointer? I think it would be better to be int
    //void *stackptr;		/* pointer to current top of stack */
	int *stackptr;
	int *ss;			// Our variable for SS
	// May need another variable for SS.
    int state;			/* current state */
    int priority;		/* current priority */
    int delay;			/* #ticks yet to wait */
    TCBptr next;		/* forward ptr for dbl linked list */
    TCBptr prev;		/* backward ptr for dbl linked list */
    //semaphore pointer holding the address of semaphore
    YKSEM *sem; //this is the semaphore we'd wait on in pend
    YKQ* queue;
    YKEVENT *event;
    unsigned eventMask;
    int waitMode;
    
}  TCB;
/***************************************************************/

extern TCBptr YKRdyList;		/* a list of TCBs of all ready tasks
				   in order of decreasing priority */ 
extern TCBptr YKSuspList;		/* tasks delayed or suspended */
extern TCBptr YKSemaphoreWaitingList;   /* tasks that are pending on a semaphore */
extern TCBptr YKAvailTCBList;		/* a list of available TCBs */
extern TCB    YKTCBArray[MAXTASKS+1];	/* array to allocate all needed TCBs
				   (extra one is for the idle task) */

// Initializes everything
void YKInitialize(void);

// Turns off interrupts
void YKEnterMutex(void);

// Turns on interrupts
void YKExitMutex(void);

// Just idles when we have nothing better to do
void YKIdleTask(void);

// Makes a new task
void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority);

// This tells the kernel to begin execution of the tasks in the application code
void YKRun(void);

// Delays a task for a specified number of clock ticks
void YKDelayTask(unsigned count);

// Called at the beginning of an ISR. Increments ISR call depth
void YKEnterISR(void);

// Called at the end of an ISR. Decrements ISR call depth
void YKExitISR(void);

// Determines the highest priority ready task, then calls dispatcher on it
void YKScheduler_old(void);

// Scheduler that will cause the dispatcher to save the context if needed
void YKScheduler(int need_to_save_context);

// Causes the execution of the task identified by the scheduler
// NOTE: we might want a parameter in this.
void YKDispatcher(void);

// This is a dispatcher that should save the context properly
void YKDispatcher_save_context(int need_to_save_context, int ** save_sp, int ** save_ss, 
		int * restore_sp, int * restore_ss);

// Called from the Tick ISR each time it runs. Responsible for waking delayed tasks
void YKTickHandler(void);

// Creates and initializes a semaphore; called once per semaphore
YKSEM* YKSemCreate(int initialValue);

// Tests the value of the indicated semaphore then decraments it
void YKSemPend(YKSEM *semaphore);

// Increments the value of the indicated semaphore
void YKSemPost(YKSEM *semaphore);

// Creates and inits a message queue; returns a pointer to it.
YKQ *YKQCreate(void **start, unsigned size);

// Removes the oldest message from the indicated message queue
void *YKQPend(YKQ *queue);

// Places a message in the message queue
int YKQPost(YKQ *queue, void *msg);



/*************************** LAB 7 FUNCTIONS *******************************/
// Creates and inis an event flags group, returns pointer to it
YKEVENT *YKEventCreate(unsigned initialValue);

// Tests the value of the given event flags group against the mask and node in parameters
unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode);

// similar to POST, causes all bits set in mask to be set in event flags group
void YKEventSet(YKEVENT *event, unsigned eventMask);

// causes all bits set in eventMask to be reset in the given event flags group
void YKEventReset(YKEVENT *event, unsigned eventMask);

#endif // YAKK_H

