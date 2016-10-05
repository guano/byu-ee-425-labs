#ifndef YAKK_H
#define YAKK_H

// A .h file for kernel code, not modified by the user.
// It should include declarations such as TCB, YKSEM, and YKW,
// as well as prototypes for the kernel functions.
// Global variables shared by kernel and application code should be declared
// as extern in this file

#define IDLE_TASK_SIZE
#define NULL 0

// TODO: write all the declarations for the kernel functions in here

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
// NOT REQUIRED FOR LAB4B
void YKDelayTask(unsigned count);

// Called at the beginning of an ISR. Increments ISR call depth
// NOT REQUIRED FOR LAB4B
void YKEnterISR(void);

// Called at the end of an ISR. Decrements ISR call depth
// NOT REQUIRED FOR LAB4B
void YKExitISR(void);

// Determines the highest priority ready task, then calls dispatcher on it
void YKScheduler(void);

// Causes the execution of the task identified by the scheduler
// NOTE: we might want a parameter in this.
void YKDispatcher(void);

// Called from the Tick ISR each time it runs. Responsible for waking delayed tasks
// NOT REQUIRED FOR LAB4B
void YKTickHandler(void);

// Creates and initializes a semaphore; called once per semaphore
// NOT REQUIRED FOR LAB4B
YKSEM* YKSemCreate(int initialValue);

// Tests the value of the indicated semaphore then decraments it
// NOT REQUIRED FOR LAB4B
void YKSemPend(YKSEM *semaphore);

// Increments the value of the indicated semaphore
// NOT REQUIRED FOR LAB4B
void YKSemPost(YKSEM *semaphore);

// Creates and inits a message queue; returns a pointer to it.
// NOT REQUIRED FOR LAB4B
YKQ *YKQCreate(void **start, unsigned size);

// Removes the oldest message from the indicated message queue
// NOT REQUIRED FOR LAB4B
void *YKQPend(YKQ *queue);

// Places a message in the message queue
// NOT REQUIRED FOR LAB4B
int YKQPost(YKQ *queue, void *msg);

// Creates and inis an event flags group, returns pointer to it
// NOT REQUIRED FOR LAB4B
YKEVENT *YKEventCreate(unsigned initialValue);

// Tests the value of the given event flags group against the mask and node in parameters
// NOT REQUIRED FOR LAB4B
unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode);

// similar to POST, causes all bits set in mask to be set in event flags group
// NOT REQUIRED FOR LAB4B
void YKEventSet(YKEVENT *event, unsigned eventMask);

// causes all bits set in eventMask to be reset in the given event flags group
// NOT REQUIRED FOR LAB4B
void YKEventReset(YKEVENT *event, unsigned eventMask);


// ----------------------
// Also- global variables
unsigned int YKCtxSwCount;	// incremented every context switch
unsigned int YKIdleCount;	// incremented by idle task in while(1) loop
unsigned int YKTickNum;		// incremented by tick handler
// End global variables
// ----------------------




#endif // YAKK_H

