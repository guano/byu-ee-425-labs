/*
 * Lab8.
 * Taylor Cowley and Brittany Stark
 * SIMPTRIS :)
 * 
 */

#include "clib.h"
#include "yakk.h"

#define TASK_STACK_SIZE 512		// Don't know what a good stack size is

int theTaskStk[TASK_STACK_SIZE];

int theTask(void)
{
	
	
	
}


void main(void)
{
	YKInitialize();
	YKNewTask(theTask, (void *) &theTaskStk[TASK_STACK_SIZE], 0);
	YKRun();
}
