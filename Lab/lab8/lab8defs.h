#include "yakk.h"

extern YKQ * movePieceQueuePTR;
extern YKQ * newPieceQueuePTR;
extern YKEVENT * pieceMoveEvent;

#define PIECE_QUEUE_STRUCT_ARRAY_SIZE 40
#define MOVE_QUEUE_STRUCT_ARRAY_SIZE 40

#define PIECE_TYPE_STRAIGHT 1
#define PIECE_TYPE_CORNER 0

#define DIRECTION_RIGHT 1
#define DIRECTION_LEFT 0
#define DIRECTION_CLOCKWISE 1
#define DIRECTION_COUNTER_CLOCKWISE 0

#define MOVEPIECEEVENT_READY_FOR_MOVE 1
#define MOVEPIECEEVENT_NOT_READY 0

struct newPiece
{
	// Just the number of the piece
	unsigned id;

	// defines for this up at the top
	unsigned type;

	// Orientation cheat sheet
	// 0	1	2	3
	// *	 *	**	**
	// **	**	 *	*
	//
	// ***	*
	//		*
	//		*
	unsigned orientation;
	
	// column of the center/corner block
	unsigned column;
};



struct pieceMove
{
	// id of the piece we want to move
	unsigned id;

	// which function we want to call
	// either 
	// void SlidePiece(int ID, int direction)
	// void RotatePiece(int ID, int direction)
	void (*functionPtr)(int,int);
	
	// defines for these at the top
	int direction;
	
};
