#include "clib.h"
#include "yakk.h" //this is mostly for defining YKSEM
#include "lab6defs.h"

// Commented out because not needed for lab6
/*
// This is so we can access which key was pressed
extern int KeyBuffer;
//extern typedef struct YKSEM YKSEM;
extern YKSEM *NSemPtr;
extern void YKSemPost(YKSEM *semaphore);

// this will delay stuff
void delay();

extern void YKTickHandler(void);
#define DELAY_NUM 5000
*/

extern YKQ *MsgQPtr;
extern struct msg MsgArray[];
extern int GlobalFlag;



// This is called by the reset ISR and it kills the program.
void c_isr_reset(){
//	printString("\nRESETING THE PROGRAM\n");
	exit(0);
}


//inserted for lab6
void c_isr_tick(void)
{
    static int next = 0;
    static int data = 0;

	YKTickHandler();
    /* create a message with tick (sequence #) and pseudo-random data */
    MsgArray[next].tick = YKTickNum;
    data = (data + 89) % 100;
    MsgArray[next].data = data;
    if (YKQPost(MsgQPtr, (void *) &(MsgArray[next])) == 0)
		printString("  TickISR: queue overflow! \n");
    else if (++next >= MSGARRAYSIZE){
//		printString("successfull post and rollover\n");
		next = 0;
	}else{
//		printString("successfull post\n");
	}

}	       
// Also inserted for lab 6
void c_isr_keypress(void)
{
    GlobalFlag = 1;
}


// Commented all out because not needed for lab 6
/*
void c_isr_tick(){
	static int tick_number = 0;
	// print stuff on the screen
	printString("\nTICK ");
	printInt(tick_number++);
	printNewLine();
	YKTickHandler();
}

void c_isr_keypress(){
	// This should be the key that was pressed
	char c = (char) KeyBuffer;

	if(c == 'd'){
		printString("\nDELAY KEY PRESSED\n");
		delay();
		printString("\nDELAY COMPLETE\n");
	}
	else if(c == 'p'){
		//printString("\n************THIS IS WHERE WE NEED TO DO SEMAPHORE***********\n");
		YKSemPost(NSemPtr);
	}
	else{
		printString("\nKEYPRESS (");
		printChar(c);
		printString(") IGNORED\n");
	}
}

// A simple delay function. Counts to DELAY_NUM
void delay(){
	int i = 0;
	for(i=0; i<DELAY_NUM; i++){
		;
	}
}

*/
