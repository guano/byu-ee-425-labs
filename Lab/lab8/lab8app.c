/*
 * Lab8.
 * Taylor Cowley and Brittany Stark
 * SIMPTRIS :)
 * 
 */

#include "clib.h"
#include "yakk.h"
#include "lab8defs.h"
#include "simptris.h"

#define TASK_STACK_SIZE 512			// Don't know what a good stack size is
#define PIECE_QUEUE_SIZE 10			// this is kinda big
#define MOVE_QUEUE_SIZE 20			// 20 moves to make?


int STaskStk[TASK_STACK_SIZE];
int testintbog;
int test2;
int movePieceTaskStk[TASK_STACK_SIZE];
int test3;
int test4;
int newPieceTaskStk[TASK_STACK_SIZE];
int test5;
int test6 ;

struct newPiece newPieceArray[PIECE_QUEUE_STRUCT_ARRAY_SIZE];
void * newPieceQueue[PIECE_QUEUE_SIZE];
YKQ * newPieceQueuePTR;

struct pieceMove movePieceArray[MOVE_QUEUE_STRUCT_ARRAY_SIZE];
int movePieceArrayIndex;
void * movePieceQueue[MOVE_QUEUE_SIZE];
YKQ * movePieceQueuePTR;

// now to make the event
YKEVENT * pieceMoveEvent;


/*	LSB				012345
 *					012345
 *					012345
 *	The numbers		012345
 *	represent		012345
 *	which of the	012345
 *	variables		012345
 *	correspond		012345
 *	to where on		012345
 *	the board		012345
 *					012345
 *					012345
 *					012345
 *					012345
 *					012345
 *	MSB				012345
 */

// Left bucket
unsigned screen0;
unsigned screen1;
unsigned screen2;

// right bucket
unsigned screen3;
unsigned screen4;
unsigned screen5;


// TODO: I am initializing a whole bunch of variables in the middle of functions.
// TODO: Should probably not do that anymore
// TODO: I bet it messes things up.



// The index points at the next space ready.
// If it is pointing off the array, the next ready space is 0
int getMovePieceQueueArrayIndex(void){
	if(movePieceArrayIndex == MOVE_QUEUE_STRUCT_ARRAY_SIZE ){
		movePieceArrayIndex = 0;
	}

	return movePieceArrayIndex ++;
}

// Returns 0 if left bucket, 1 if right bucket
int getLowerBucket(void){
	int left = 0;
	int right = 0;
	int screen0Temp = screen0;
	int screen3Temp = screen3;

	// this counts the number of rows to the highest one on left bucket
	while(screen0Temp){
		left = left + 1;
		screen0Temp = screen0Temp << 1;
	}

	// And now to count eht number of rows to the highest one on the right bucket
	while(screen3Temp){
		right = right +1;
		screen3Temp = screen3Temp << 1;
	}
	
	return right > left;
}

// @param: bucket - 0 for left bucket, 1 for right bucket
// @returns: 1 for is flat, 0 for is NOT flat
int isBucketFlat(int bucket){
	// left and right columns of the bucket
	int columnLeft;
	int columnRight;

	// Are we doing right or left bucket?
	if(bucket){	// right
		columnLeft = screen3;
		columnRight = screen5;
	} else {	// left
		columnLeft = screen0;
		columnRight = screen2;
	}
	
	// Bit shift them until one of them becomes zero
	while(columnLeft && columnRight){
		columnLeft << 1;
		columnRight << 1;
	}

	// If they are the same (both zero) then they are flat.
	// Otherwise, they are not flat.
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
		screen5 & (1<<row) 	){

		// We have a line to clear!!!
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
	while(1)
	{
		// We will wait until we receive a new piece
		message = (struct newPiece *) YKQPend(newPieceQueuePTR);

		// We have received a new piece! Time to do stuff
		//
		// TODO: record our move onto our screen

		
printString("received a message!\nID: ");
printInt(message->id);
printString("\ntype: ");
printInt(message->type);
printString("\norientation: ");
printInt(message->orientation);
printString("\ncolumn: ");
printInt(message->column);
printString("\n");
		if(message->type == PIECE_TYPE_STRAIGHT){


printString("Straight piece received!\n");
			// get the lowest bucket and put there.
			lowerBucket = getLowerBucket();
			pieceColumn = message->column;


			// ----------------------------------------------
			// This is to update our bitmap
			rowAffected = getLowestSpace(lowerBucket?3:0);
			bucketAffected = lowerBucket;
			// End bitmap updating variables
			// ----------------------------------------------


			// If right bucket, needs to go column 4
			// else, needs to go column 1
			lowerBucket = lowerBucket ? 4 : 1 ;

			// --------------------------------------------------
			// Need to add moves to send it to the right column
			while(pieceColumn < lowerBucket){		// Need to go right
printString("Moving Straight piece right\n");
				tempIndex = getMovePieceQueueArrayIndex();
				
				movePieceArray[tempIndex].id = message->id;
				movePieceArray[tempIndex].direction = DIRECTION_RIGHT;
				movePieceArray[tempIndex].functionPtr = SlidePiece;
				pieceColumn = pieceColumn + 1;
				YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
			}
			while(pieceColumn > lowerBucket){		// Need to go left
printString("moving straight piece left\n");
				tempIndex = getMovePieceQueueArrayIndex();

				movePieceArray[tempIndex].id = message->id;
				movePieceArray[tempIndex].direction = DIRECTION_LEFT;
				movePieceArray[tempIndex].functionPtr = SlidePiece;
				pieceColumn = pieceColumn - 1;
				YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
			}
			// ---------------------------------------------------
			// End of moves to send the bar to the correct column
			
			// If we are tall, we need to go flat.
			if(message->orientation){
printString("rotating straight piece\n");
				tempIndex = getMovePieceQueueArrayIndex();
				
				movePieceArray[tempIndex].id = message->id;
				movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;

				// RotatePiece being the function to rotate a piece
				movePieceArray[tempIndex].functionPtr = RotatePiece;

				YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);	// move now on queue!	
			}




			// Now to update our bitmaps.
			if(!bucketAffected){	// left bucket
				screen0 = screen0 | (1 << rowAffected);
				screen1 = screen1 | (1 << rowAffected);
				screen2 = screen2 | (1 << rowAffected);
			}
			tryToClearLine(rowAffected);
		}
		else {// End move calculation for straight piece
			// START of move calculation for corner piece
printString("oops. it is a corner piece\n");
			lowerBucket = getLowerBucket();
			pieceColumn = message->column;

			// Oh no! the lower bucket is flat!
			if(isBucketFlat(lowerBucket)){			// lower bucket is flat!
				if(isBucketFlat(!lowerBucket)){		// upper bucket is also flat
					// just go to left of lower bucket
					
					// If right bucket, move then rotate
					if(lowerBucket){
						lowerBucket = 3;

						// Move first
						while(pieceColumn < lowerBucket){	// move right
							tempIndex = getMovePieceQueueArrayIndex();
							
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_RIGHT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn + 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						while(pieceColumn > lowerBucket){	// maybe move left
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_LEFT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn - 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}

						// Now to rotate
						if(message->orientation == 3){		// only counterclockwise case
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_COUNTER_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 2){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 2 || message->orientation == 1){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
					}
					else {	// left bucket
						// Worst case: up against left (or right) and need to turn
						if(pieceColumn == 0 && message->orientation != 0){
							// Simply move right one then move on
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_RIGHT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn + 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						} else if(pieceColumn == 5 && message->orientation != 0){
							// Simply move LEFT one then move on
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_LEFT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn - 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}	

						// Now to rotate
						if(message->orientation == 3){		// only counterclockwise case
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_COUNTER_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 2){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 2 || message->orientation == 1){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}

						// Now to move left to go up against left side
						while(pieceColumn > lowerBucket){	// maybe move left
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_LEFT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn - 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
					}

				} 
				else {
					// higher bucket needs to be flattened
					lowerBucket = !lowerBucket;
					// lowerBucket is now the correct one
					
					lowerBucket = lowerBucket ? 5 : 2;


					if(lowerBucket == 5){
						// Worst case: up against left (or right) and need to turn
						if(pieceColumn == 0 && message->orientation != 2){
							// Simply move right one then move on
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_RIGHT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn + 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						} else if(pieceColumn == 5 && message->orientation != 2){
							// Simply move LEFT one then move on
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_LEFT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn - 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						
						// Now to rotate
						if(message->orientation == 1){		// only counterclockwise case
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_COUNTER_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 0){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 0 || message->orientation == 3){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}

						// Now to move right to go up against right side
						while(pieceColumn < lowerBucket){	// maybe move left
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_RIGHT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn + 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}	
					}
					else{	// lowerBucket == 2
						// We can move then rotate.

						// Move first
						while(pieceColumn < lowerBucket){	// move right
							tempIndex = getMovePieceQueueArrayIndex();
							
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_RIGHT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn + 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						while(pieceColumn > lowerBucket){	// maybe move left
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_LEFT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn - 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}

						// Now to rotate
						if(message->orientation == 1){		// only counterclockwise case
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_COUNTER_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 0){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 0 || message->orientation == 3){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
					}					
				}
			} 
			else {	
				// lower bucket needs to be flattened
				lowerBucket = lowerBucket ? 5 : 2;

					if(lowerBucket == 5){
						// Worst case: up against left (or right) and need to turn
						if(pieceColumn == 0 && message->orientation != 2){
							// Simply move right one then move on
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_RIGHT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn + 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						} else if(pieceColumn == 5 && message->orientation != 2){
							// Simply move LEFT one then move on
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_LEFT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn - 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						
						// Now to rotate
						if(message->orientation == 1){		// only counterclockwise case
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_COUNTER_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 0){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 0 || message->orientation == 3){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}

						// Now to move right to go up against right side
						while(pieceColumn < lowerBucket){	// maybe move left
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_RIGHT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn + 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}	
					}
					else{	// lowerBucket == 2
						// We can move then rotate.

						// Move first
						while(pieceColumn < lowerBucket){	// move right
							tempIndex = getMovePieceQueueArrayIndex();
							
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_RIGHT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn + 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						while(pieceColumn > lowerBucket){	// maybe move left
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_LEFT;
							movePieceArray[tempIndex].functionPtr = SlidePiece;
							pieceColumn = pieceColumn - 1;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}

						// Now to rotate
						if(message->orientation == 1){		// only counterclockwise case
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_COUNTER_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 0){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
						if(message->orientation == 0 || message->orientation == 3){
							tempIndex = getMovePieceQueueArrayIndex();
							movePieceArray[tempIndex].id = message->id;
							movePieceArray[tempIndex].direction = DIRECTION_CLOCKWISE;
							movePieceArray[tempIndex].functionPtr = RotatePiece;
							YKQPost(movePieceQueuePTR, &movePieceArray[tempIndex]);
						}
					}					
			}
		}
		printString("Thank you for playing newPieceTask. The while loop will now cycle to the beginning\n");
	}
}

int movePieceTask(void)
{
	struct pieceMove * message;
	printString("movePieceTask moving!\n");
	while(1)
	{
		printString("Wait for event!\n");
		// Wait for it to be ready to receive a move 
		YKEventPend(pieceMoveEvent, MOVEPIECEEVENT_READY_FOR_MOVE , EVENT_WAIT_ALL);
		// Clear it until simptris is ready again
		YKEventReset(pieceMoveEvent, MOVEPIECEEVENT_READY_FOR_MOVE);

					printString("piece move event. getting move now\n");

		// We will wait to receive a move to make
		message = (struct pieceMove *) YKQPend(movePieceQueuePTR);
		
					printString("got a piece. ID ");
					printInt(message->id);
					printString("\n");

		// We have a move to make! now to make it.
		// I hope I am calling this function properly?
		message->functionPtr(message->id, message->direction);
		printString("called the function!\n");
	}
	
}

void STask(void)           /* tracks statistics */
{
    unsigned max, switchCount, idleCount;
    int tmp;

    YKDelayTask(1);
    printString("Welcome to the YAK kernel\r\n");
    printString("Determining CPU capacity\r\n");
    YKDelayTask(1);
    YKIdleCount = 0;
    YKDelayTask(5);
    max = YKIdleCount / 25;
    YKIdleCount = 0;

	SeedSimptris(1251);


	YKNewTask(newPieceTask, (void *) &newPieceTaskStk[TASK_STACK_SIZE], 5);
	YKNewTask(movePieceTask, (void *) &movePieceTaskStk[TASK_STACK_SIZE],3);
    
	StartSimptris();

    while (1)
    {
        YKDelayTask(20);
        
        YKEnterMutex();
        switchCount = YKCtxSwCount;
        idleCount = YKIdleCount;
        YKExitMutex();
        
        printString("<<<<< Context switches: ");
        printInt((int)switchCount);
        printString(", CPU usage: ");
        tmp = (int) (idleCount/max);
        printInt(100-tmp);
        printString("% >>>>>\r\n");
        
        YKEnterMutex();
        YKCtxSwCount = 0;
        YKIdleCount = 0;
        YKExitMutex();
    }
}   


void main(void)
{
	YKInitialize();
	
	newPieceQueuePTR = YKQCreate(newPieceQueue, PIECE_QUEUE_SIZE);
	movePieceQueuePTR= YKQCreate(movePieceQueue,MOVE_QUEUE_SIZE);
	pieceMoveEvent = YKEventCreate(MOVEPIECEEVENT_READY_FOR_MOVE);
	
	
	YKNewTask(STask, (void *) &STaskStk[TASK_STACK_SIZE], 0);
	YKRun();
}





