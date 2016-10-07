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

TCBptr YKRdyList;// a list of TCBs of all ready tasks in order of decreasing priority
TCBptr YKSuspList;		/* tasks delayed or suspended */
TCBptr YKAvailTCBList;		/* a list of available TCBs */
TCB    YKTCBArray[MAXTASKS+1];	// array to allocate all needed TCBs extra for idle task

// Gets set by YKRun.
// Scheduler does not call dispatcher unless it is set
char started_running = 0;


void YKInitialize(void){
	int i;

	// Initialize them in initialize. That makes sense.
	YKCtxSwCount = 0;
	YKIdleCount = 0;


	/* Allocate stack space */
	//*******************************************use the #DEFINE IN HEADER FILE
    /* code to construct singly linked available TCB list from initial
       array */ 
    YKAvailTCBList = &(YKTCBArray[0]);
    for (i = 0; i < MAXTASKS; i++)
	YKTCBArray[i].next = &(YKTCBArray[i+1]);
    YKTCBArray[MAXTASKS].next = NULL;


 	/* Create idle task by calling YKIdleTask() */
	// I think that's dumb.
	// Let's create the idle task by calling YKNewTask on it
//	YKIdleTask();
	YKNewTask(YKIdleTask, (void *)&idleStack[IDLESTACKSIZE], 100);	// Give it a priority of 100 for some reason

}

void YKIdleTask(void) {
    //Kernel's idle task
    while(1){
		YKIdleCount++; 
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
    // grabs an unused TCB from the available list
    tmp = YKAvailTCBList;
    YKAvailTCBList = tmp->next;

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

	// Save the stack pointer
	tmp->stackptr = taskStack;
		// Now we need to store in this stack an entire "context" to restore from
		tmp->stackptr		= tmp->stackptr + 12;
		*(tmp->stackptr-12)	= FLAGS_INTERRUPT_ONLY;		// flags
		*(tmp->stackptr-11)	= 0;		// CS
		*(tmp->stackptr-10)	= (int)task;		// IP
		*(tmp->stackptr-9)	= 0;		// AX
		*(tmp->stackptr-8)	= 0;		// BX
		*(tmp->stackptr-7)	= 0;		// CX
		*(tmp->stackptr-6)	= 0;		// DX
		*(tmp->stackptr-5)	= 0;		// BP
		*(tmp->stackptr-4)	= 0;		// SI
		*(tmp->stackptr-3)	= 0;		// DI
		*(tmp->stackptr-2)	= 0;		// DS
		*(tmp->stackptr-1)	= 0;		// ES

	// 0 ticks to delay in TCB
	tmp->delay = 0;

	// Store PC in TCB
//	tmp->address = task;

	// Store priority in TCB
	tmp->priority = priority;
	
	// Now we need to call the scheduler. Which will decide what to call next.
	YKScheduler();
}

/*
 * Starts the kernel
 * !!run()
 */
void YKRun(void) { /* starts the kernel */
	started_running = 1;
	YKScheduler();			// Alright let's execute the first task!
}


/*
 * !!For each in TCB
 * !! find highest-priority ready task
 * !! call dispatcher
 */
void YKScheduler(void) {
	// highest-ready task to be called from TCB
	TCBptr highest_priority_task = YKRdyList;

/*
 *	Potentially, the address does not need to be stored in TCB.
 *	If it's the instruction pointer, then it gets taken care of by iret???
 *	That's the presumed word on the street based off of what others have
 *	interpreted their help from the TA Taylor
 *
 *
 *	other: decrement SP in Dispatcher...
 * */
	
	// which one is the current task??
	// See note in description...might need to pass in a parameter...

	//if current task is diff from highest_priority_task
	//then call dispatcher
	
	
	// I don't think we need to worry about ordering things just now
	// because we are only calling NewTask. Which puts itself in the proper order.
	if(started_running){	// Only call the dispatcher if we are running.
		YKDispatcher();
	}
}



/*	!! restore SP
 *	!! pop the context into every register
 *	!! restore PC with iret
 */
// Commented because we are coding this up in assembly
//void YKDispatcher(void) {
//    YKCtxSwCount ++;
//}

