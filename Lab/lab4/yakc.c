//Kernel routines written in C. Global variables
//used by kernel code or shared by kernel and application
//code should also be defined in this file
#include "clib.h"
#include "yakk.h"

YKCtxSwCount = 0;
YKIdleCount = 0;

void YKInitialize(void){
   int i;
  /* Create idle task by calling YKIdleTask() */
    YKIdleTask();
  /* Allocate stack space */
   //************************************************************use the #DEFINE IN HEADER FILE
       /* code to construct singly linked available TCB list from initial
       array */ 

    YKAvailTCBList = &(YKTCBArray[0]);
    for (i = 0; i < MAXTASKS; i++)
	YKTCBArray[i].next = &(YKTCBArray[i+1]);
    YKTCBArray[MAXTASKS].next = NULL;
 
}
void YKIdleTask(void) {
    //Kernel's idle task
    while(1){
      YKIdlecount++; 
    } 
    //after disassembly, ensure while(1) loop is at least 4 instructions per iteration (including jmp instruction)  
}

void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority)
    TCBptr tmp, tmp2;

    // grabs an unused TCB from the available list

    tmp = YKAvailTCBList;
    YKAvailTCBList = tmp->next;

    /* code to insert an entry in doubly linked ready list sorted by
       priority numbers (lowest number first).  tmp points to TCB
       to be inserted */ 

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

	// Save the stack pointer
	tmp->stackptr = taskStack;

	// 0 ticks to delay in TCB
	tmp->delay = 0;

	// Store PC in TCB
	tmp->address = task;

	// Store priority in TCB
	tmp->priority = priority;
/*
	!! make new TCB entry for task					DONE
	!! store name and priority in TCB				DONE
	!! store proper stack pointer in TCB for task	DONE
	!! store PC in TCB								DONE
	!! 0 ticks to delay stored in TCB				DONE
*/

	// Now instead of returning we need to jump to the scheduler. How to do this?
}


void YKRun(void) { /* starts the kernel */
	!! run();
}
void YKScheduler(void) {
	!!For each in TCB
		!! find highest-priority ready task
	!! call dispatcher
	
}
void YKDispatcher(void) {
	!! restore SP
	!! pop the context into every register
	!! restore PC with iret
    YKCtxSwCount ++;
}

void main(void){

}


