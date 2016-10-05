//Kernel routines written in C. Global variables
//used by kernel code or shared by kernel and application
//code should also be defined in this file
#include "clib.h"
#include "yakk.h"

void YKInitialize(void){
  /* Create idle task by calling YKIdleTask() */
    YKIdleTask();
  /* Allocate stack space */
    
}
void YKEnterMutex(void) {
	(assembly) cli
}
void YKExitMutex(void) {
	(assembly) sti
}
void YKIdleTask(void) {
    //Kernel's idle task
}

void YKNewTask(void) {
	!! make new TCB entry for task
	!! store name and priority in TCB
	!! store proper stack pointer in TCB for task
	!! store PC in TCB
	!! 0 ticks to delay stored in TCB
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




//uint YKCtxSwCount = 0; - Global variable tracking context switches
//uint YKIdleCount = 0; -idle counter. Does nothing.


