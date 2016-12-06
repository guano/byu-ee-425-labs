/*
 * Lab8.
 * Taylor Cowley and Brittany Stark
 * SIMPTRIS :)
 * 
 */

#include "clib.h"
#include "yakk.h"
#include "lab8defs.h"

#define TASK_STACK_SIZE 512		// Don't know what a good stack size is
#define PIECE_QUEUE_SIZE 10		// this is kinda big
#define MOVE_QUEUE_SIZE 20		// 20 moves to make?

#define MOVEPIECEEVENT_READY_FOR_MOVE 1
#define MOVEPIECEEVENT_NOT_READY 0

int theTaskStk[TASK_STACK_SIZE];

void * newPieceQueue[PIECE_QUEUE_SIZE];
YKQ * newPieceQueuePTR;

void * movePieceQueue[MOVE_QUEUE_SIZE];
YKQ * movePieceQueuePTR;

// now to make the event
YKEVENT * pieceMoveEvent;


int newPieceTask(void)
{

	while(1)
	{
		// We will wait until we receive a new piece
		struct newPiece * message = (struct newPiece *) YKQPend(newPieceQueuePTR);
		
		// We have received a new piece! Time to do stuff
		//
		// TODO: calculate necessary moves
		//
		// TODO: store calculated moves in the move piece queue
		// It will look a little like this:
		struct pieceMove * demo_move;
		YKQPost(movePieceQueuePtr, pieceMove);
	}
}

int movePieceTask(void)
{
	while(1)
	{
		// Wait for it to be ready to receive a move 
		YKEventPend(pieceMoveEvent, MOVEPIECEEVENT_READY_FOR_MOVE , EVENT_WAIT_ALL);
		// Clear it until simptris is ready again
		YKEventReset(pieceMoveEvent, MOVEPIECEEVENT_READY_FOR_MOVE);

					print("piece move event. getting move now\n");

		// We will wait to receive a move to make
		struct pieceMove * message = (struct pieceMove *) YKQPend(movePieceQueuePTR);
		
					print("got a piece. ID ");
					printInt(pieceMove->id);
					print("\n");

		// We have a move to make! now to make it.
		// I hope I am calling this function properly?
		pieceMove->functionPtr(pieceMove->id, pieceMove->direction);
	}
	
}


void main(void)
{
	YKInitialize();
	
	newPieceQueuePTR = YKQCreate(newPieceQueue, PIECE_QUEUE_SIZE);
	movePieceQueuePTR= YKQCreate(movePieceQueue,MOVE_QUEUE_SIZE);
	pieceMoveEvent = YKEventCreate(MOVEPIECEEVENT_READY_FOR_MOVE);
	
	YKNewTask(theTask, (void *) &theTaskStk[TASK_STACK_SIZE], 0);
	YKRun();
}





