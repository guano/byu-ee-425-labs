//Kernel routines written in C. Global variables
//used by kernel code or shared by kernel and application
//code should also be defined in this file
#include "clib.h"
#include "yakk.h"

YKCtxSwCount = 0;
YKIdleCount = 0;

void YKInitialize(void){
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

void main(void){

}


