//Kernel routines written in C. Global variables
//used by kernel code or shared by kernel and application
//code should also be defined in this file
#include "clib.h"
#include "yakk.h"

#define FLAGS_INTERRUPT_ONLY 0x200

#define IDLESTACKSIZE 256
int idleStack[IDLESTACKSIZE];           /* Space for each task's stack */

unsigned int YKCtxSwCount;	// incremented every context switch
unsigned int YKIdleCount;	// incremented by idle task in while(1) loop
unsigned int YKTickNum;		// incremented by tick handler
unsigned int YKISRCallDepth;    // incremented/decremented by the ISR enter/exit 

TCBptr YKRdyList;// a list of TCBs of all ready tasks in order of decreasing priority
TCBptr YKSuspList;		/* tasks delayed or suspended */
TCBptr YKAvailTCBList;		/* a list of available TCBs */
TCB    YKTCBArray[MAXTASKS+1];	// array to allocate all needed TCBs extra for idle task
YKSEM  YKSEMArray[MAXSEMAPHORES];    //array to allocate all needed semaphores

TCBptr YKSemaphoreWaitingList; 
// When the scheduler dispatches a task, it sets this to that task.
TCBptr YKCurrentlyExecuting; // Starts at 0 because nothing is executing at start

// Gets set by YKRun.
// Scheduler does not call dispatcher unless it is set
char started_running = 0;

void YKInitialize(void){
	int i;

	// Initialize them in initialize. That makes sense.
	YKCtxSwCount = 0;
	YKIdleCount = 0;
	YKCurrentlyExecuting = 0; // Starts at 0 because nothing is executing at start
	YKISRCallDepth = 0;
//	printString("Initializing!\n");

	/* Allocate stack space */
	//*******************************************use the #DEFINE IN HEADER FILE
    /* code to construct singly linked available TCB list from initial
       array */ 
	YKEnterMutex();
    YKAvailTCBList = &(YKTCBArray[0]);
    for (i = 0; i < MAXTASKS; i++)
		YKTCBArray[i].next = &(YKTCBArray[i+1]);
    YKTCBArray[MAXTASKS].next = NULL;
    
/*	initializing all the semaphores to zero for starters	*/
    for (i = 0; i < MAXSEMAPHORES; i++)
    {
		YKSEMArray[i].alive = 0;
		YKSEMArray[i].value = -10;
    }


 	/* Create idle task by calling YKIdleTask() */
	YKNewTask(YKIdleTask, (void *)&idleStack[IDLESTACKSIZE], 100);	// Give it a priority of 100 for some reason
}

void YKIdleTask(void) {
	//Kernel's idle task
	while(1){
	//	printString("IDLE TASK EXECUTING\n");
		YKIdleCount = YKIdleCount+1; 
		YKExitMutex();
	}
	//after disassembly, ensure while(1) loop is at least 4 instructions per iteration (including jmp instruction)  
}

/*
   !! make new TCB entry for task					DONE
   !! store name and priority in TCB				DONE
   !! store proper stack pointer in TCB for task	DONE
   !! store PC in TCB								DONE
   !! 0 ticks to delay stored in TCB				DONE
   */
void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority){
	// -----------------------------------------------
	// Make a new TCB entry for task (on ready list)
	//
	TCBptr tmp, tmp2;


	// This is a bugfix for a problem we found in lab 5. We didn't realize the spec says
	// " Note that the actual address passed is one word beyond the top of the stack;
	// this ensures that the first word actually used on the stack 
	// will be the word at the top of the stack."
	// We were actually using that address and overwriting whatever came after...
	// int casting so the compiler knows how big a word is. (it is an address, after all)
	taskStack = ((int *)taskStack) - 1;

	// grabs an unused TCB from the available list
	tmp = YKAvailTCBList;
	YKAvailTCBList = tmp->next;


	// 0 ticks to delay in TCB
	tmp->delay = 0;


	// Store PC in TCB
	//	tmp->address = task;

	// Store priority in TCB
	tmp->priority = priority;

YKEnterMutex();

	// code to insert an entry in doubly linked ready list sorted by
	// priority numbers (lowest number first).  tmp points to TCB
	// to be inserted
	if (YKRdyList == NULL) {	// is this first insertion?
		YKRdyList = tmp;
		tmp->next = NULL;
		tmp->prev = NULL;
	} else {			// not first insertion 
		tmp2 = YKRdyList;	/* insert in sorted ready list */
		while (tmp2->priority < tmp->priority)
			tmp2 = tmp2->next;	/* assumes idle task is at end */
		if (tmp2->prev == NULL)	/* insert in list before tmp2 */
			YKRdyList = tmp;
		else
			tmp2->prev->next = tmp;
		tmp->prev = tmp2->prev;
		tmp->next = tmp2;
		tmp2->prev = tmp;
	}
	// End making a new TCB entry for task
	// ----------------------------------------------

	//	printString("we have decided our new task's TCB is to be ");
	//	printInt((int)tmp);
	//	printString("\nand our new task's STACK is");
	//	printInt((int)taskStack);
	//	printString("\n");
	// Save the stack pointer
	tmp->stackptr = taskStack;
//	printString("Address for new task's SP is ");
//	printInt((int) &(tmp->stackptr));
//	printString("\n");
	tmp->ss = 0;				// just always make ss 0. is good idea?

//	printString("tmp's stackptr = ");
//	printInt((int) tmp->stackptr);
//	printString("\n");


//	printString("Trying to figure out where the 512 comes from\n");
//	printInt((int)task);
//	printString(" <- is the task address\n");
//	printInt((int) FLAGS_INTERRUPT_ONLY);
//	printString(" <- is FLAGS_INTERRUPT_ONLY\n");

	// Now we need to store in this stack an entire "context" to restore from
	tmp->stackptr		= tmp->stackptr - 11;
	*(tmp->stackptr+11)	= FLAGS_INTERRUPT_ONLY;		// flags
	*(tmp->stackptr+10)	= 0;		// CS
	*(tmp->stackptr+9)	= (int)task;		// IP
	*(tmp->stackptr+8)	= 0;		// AX
	*(tmp->stackptr+7)	= 0;		// BX
	*(tmp->stackptr+6)	= 0;		// CX
	*(tmp->stackptr+5)	= 0;		// DX
	*(tmp->stackptr+4)	= 0;		// BP
	*(tmp->stackptr+3)	= 0;		// SI
	*(tmp->stackptr+2)	= 0;		// DI
	*(tmp->stackptr+1)	= 0;		// DS
	*(tmp->stackptr+0)	= 0;		// ES


YKExitMutex();
	// Now we need to call the scheduler. Which will decide what to call next.
	//	printString("calling the scheduler\n");
	YKScheduler(1);	// We DO need to save context.
}

/*
 * Starts the kernel
 * !!run()
 */
void YKRun(void) { /* starts the kernel */
	printString("run called. Calling the scheduler\n");
	started_running = 1;
	YKScheduler(0);		//	Because no tasks running, do NOT save context.
}

void YKScheduler(int need_to_save_context){
	TCBptr highest_priority_task = YKRdyList;
	TCBptr currentlyExecuting = YKCurrentlyExecuting;

	// Only do things if we are running. Otherwise return
	if(!started_running){
		return;
	}
	if(YKCurrentlyExecuting == highest_priority_task){
		return;	// We do not need to dispatcher if go back to same task!
	}

	YKCtxSwCount = YKCtxSwCount + 1;	// Switching context one more time
	YKCurrentlyExecuting = highest_priority_task;

	// If we do not need to save context, it doesn't get an address to save it
	if(!need_to_save_context){
		YKDispatcher_save_context(0,(int **) 1, (int **)1,
				highest_priority_task->stackptr, highest_priority_task->ss);
	} else {
		// We DO need to save context
		// SP and SS of what we need to save
		// SP and SS that we need to restore
		YKDispatcher_save_context(need_to_save_context, 
				&(currentlyExecuting->stackptr), &(currentlyExecuting->ss),
				highest_priority_task->stackptr, highest_priority_task->ss);
	}
}

// Delays a task for a specified number of clock ticks
void YKDelayTask(unsigned count)
{
  TCBptr tmp;
  YKEnterMutex();
  //After taking care of all required bookkepping to mark change of
  //state for currently running task, call scheduler.
	//BOOKKEEPING TIME!!!!!!  
  //if count is zero, then don't delay. Just return
  if(count != 0)
  {
   /* code to remove an entry from the ready list and put in
       suspended list, which is not sorted.  (This only works for the
       current task, so the TCB of the task to be suspended is assumed
       to be the first entry in the ready list.)   */
    tmp = YKRdyList;		/* get ptr to TCB to change */
    YKRdyList = tmp->next;	/* remove from ready list */
    tmp->next->prev = NULL;	/* ready list is never empty */
    tmp->next = YKSuspList;	/* put at head of delayed list */
    YKSuspList = tmp;
    tmp->prev = NULL;
    if (tmp->next != NULL)	/* susp list may be empty */
	tmp->next->prev = tmp;
    tmp->delay = count;
  }
  else
  {
    YKExitMutex();
    return;
  }
  //at the very end, this function calls the scheduler
  YKScheduler(1);  // we DO need to save context
  YKExitMutex();
}


// Called from the Tick ISR each time it runs. Responsible for waking delayed tasks
void YKTickHandler(void)
{
  TCBptr tmp, tmp2,tmp_next;
//  printString("called YKTickHandler() currently within it\n");  
//bookkeeping required to support timely reawakening of delayed tasks.
  
  //may also call user tick handler if user code requires actions to be taken on each clock tick...what's that even mean?!?
  tmp = YKSuspList;
  YKEnterMutex();

  while(tmp != NULL)
  {
//    printString("Tick Handler Loop\n");
    tmp_next = tmp->next;
    tmp->delay = tmp->delay - 1; //decrement the delay of this one in the list 
    if(tmp->delay == 0)//if specified number of clock ticks has ocurred, a delayed task is made ready.
    {
//	printString("A DELAYED TASK IS NOW READY :)\n");
     /* code to remove an entry from the suspended list and insert it
       in the (sorted) ready list.  tmp points to the TCB that is to
       be moved. */
      if (tmp->prev == NULL)	/* fix up suspended list */
	YKSuspList = tmp->next;
      else
	tmp->prev->next = tmp->next;
      if (tmp->next != NULL)
	tmp->next->prev = tmp->prev;

      tmp2 = YKRdyList;		/* put in ready list (idle task always
				 at end) */
      while (tmp2->priority < tmp->priority)
	tmp2 = tmp2->next;
      if (tmp2->prev == NULL)	/* insert before TCB pointed to by tmp2 */
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

  //decrements the counter representing ISR call depth
  if(YKISRCallDepth == 0)
  {
	  // DO NOT SAVE CONTEXT :)
    YKScheduler(0);	//calls scheduler if counteris zero
  }
    //I'm pretty sure YKScheduler() should handle the following situations:
	//in case of nested interrupts, counter is zero only when exiting last ISR, so it indicates
	//when control will return to task code rather than another ISR.
	//If it is last ISR then control should return to highest priority ready task.
	//This may not be the task that was interrupted by this ISR if the actions of interrrupt
	//handler made a higher priority task ready
}

// Creates and initializes a semaphore; called once per semaphore
YKSEM* YKSemCreate(int initialValue)
{
    int i;
	YKEnterMutex();

    i = 0;
    // increment i until we find a semaphore that is not alive
    while(YKSEMArray[i].alive)
    {
        i++;
    }

    // Initialize the semaphore value
    YKSEMArray[i].value = initialValue;
	YKSEMArray[i].alive = 1;

//	printString("Sem Create. index = ");
//	printInt(i);
//	printString(" and semaphore pointer = ");
//	printInt((int) &(YKSEMArray[i]));
//	printString(" initial value = ");
//	printInt(initialValue);
//	printString("\n");


	YKExitMutex();
    // Return a pointer to the semaphore
    return &(YKSEMArray[i]);
}


/*This function tests the value of the indicated semaphore then decrements it.
 * If the value before decrementing was greater than zero, the code returns to
 * the caller. If the value before decrementing was less than or equal to zero,
 * the calling task is suspended by the kernel until the semaphore is available,
 * and the scheduler is called. This function is called only by tasks, and never
 * by ISRs or interrupt handlers.
 * */ 
void YKSemPend(YKSEM *semaphore)
{
    TCBptr tmp;
    YKEnterMutex(); 
//	printString("SemPend. on ");
//	printInt((int) semaphore);
//	printString(" Value before decrement: ");
//	printInt(semaphore->value);
    semaphore->value = semaphore->value - 1;    //decrement the semaphore value to make it un-take-able
//	printString(" Value after decrement: ");
//	printInt(semaphore->value);
//	printString("\n");
    YKExitMutex();
    if(semaphore->value >= 0){
//		printString("Semaphore available, returning\n");
  	return;
    }

    //suspend calling task using YKSemaphoreWaitingList

	YKEnterMutex();
	//After taking care of all required bookkepping to mark change of
	////state for currently running task, call scheduler.
	//BOOKKEEPING TIME!!!!!!  

   /* code to remove an entry from the ready list and put in
       suspended list, which is not sorted.  (This only works for the
       current task, so the TCB of the task to be suspended is assumed
       to be the first entry in the ready list.)   */
    tmp = YKRdyList;		/* get ptr to TCB to change */
    YKRdyList = tmp->next;	/* remove from ready list */
    tmp->next->prev = NULL;	/* ready list is never empty */
    tmp->next = YKSemaphoreWaitingList;	/* put at head of YKSemaphoreWaitingList list */
    YKSemaphoreWaitingList = tmp;
    tmp->prev = NULL;
    if (tmp->next != NULL)	/* YKSemaphoreWaitingList list may be empty */
		tmp->next->prev = tmp;
    tmp->sem = semaphore;  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!! we might need to put something in the TCB that tells what semaphore it is waiting on!
    //at the very end, this function calls the scheduler

    YKScheduler(1);  // we DO need to save context
    YKExitMutex();
}



/* This function increments the value of the indicated semaphore.
 * If any suspended tasks are waiting for this semaphore, the waiting task with the highest
 * priority is made ready. Unlike YKSemPend, this function may be called from both task code
 * and interrupt handlers.
 * If called from task code (easily determined by the value of the ISR call depth counter) then the
 * function should call the scheduler so that newly awakened high-priority tasks can resume
 * right away.
 * If the function is called from an interrupt handler, the scheduler should not
 * be called within the function. It will be called shortly in YKExitISR after all ISR actions
 * are completed.
 * */ 
void YKSemPost(YKSEM *semaphore)
{
	TCBptr tmp, tmp2,tmp_next, task_to_unblock;
	task_to_unblock = NULL;
	tmp = YKSemaphoreWaitingList;

	YKEnterMutex();

	semaphore->value = semaphore->value + 1; //increment value of the indicated semaphore.

	// This code goes through the YKSemaphoreWaitingList and finds the task
	// with the highest priority that wants the semaphore
	while(tmp != NULL){
		if(tmp->sem == semaphore){
			// The task we have found wants the semaphore!
			if(task_to_unblock == NULL){
				// Give it to it if we haven't found another task to give it to yet
				task_to_unblock = tmp;
			} else if(tmp->priority < task_to_unblock->priority) {
				// Or if the new one has a higher priority
				task_to_unblock = tmp;
			}
		}
		tmp = tmp->next;
	}

	// If there are no tasks wanting the semaphore, break.
	if(task_to_unblock == NULL){
		if (YKISRCallDepth == 0) // Only call the scheduler if we are called from task code.
		{
//		printString("\nsempost, no new task to unblock. Calling scheduler\n");
			YKScheduler(1);
		}
//	  printString("\ncalled from interrupt or switching task back.\n");
		YKExitMutex();
		return;
	}

	/* code to remove an entry from the YKSemaphoreWaitingList and insert it
	* in the (sorted) ready list.  tmp points to the TCB that is to
	* be moved. */
	if (task_to_unblock->prev == NULL)	/* fix up suspended list */
		YKSemaphoreWaitingList = task_to_unblock->next;
	else
		task_to_unblock->prev->next = task_to_unblock->next;
	if (task_to_unblock->next != NULL)
		task_to_unblock->next->prev = task_to_unblock->prev;
	tmp2 = YKRdyList;		/* put in ready list (idle task always at end) */
	while (tmp2->priority < task_to_unblock->priority)
		tmp2 = tmp2->next;
	if (tmp2->prev == NULL)	/* insert before TCB pointed to by tmp2 */
		YKRdyList = task_to_unblock;
	else
		tmp2->prev->next = task_to_unblock;
	task_to_unblock->prev = tmp2->prev;
	task_to_unblock->next = tmp2;
	tmp2->prev = task_to_unblock;

	task_to_unblock->sem = NULL;
  
	if (YKISRCallDepth == 0) // Only call the scheduler if we are called from task code.
	{
//	  printString("\nsempost, new task unblocked! calling scheduler\n");
	  YKScheduler(1);
	}

//  printString("\ncalled by an interrupt or switching task back, and new task unblocked.\n");
	YKExitMutex();
	return;
}
