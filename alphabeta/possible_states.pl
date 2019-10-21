
/**
 * In this file we will implement the code to generate all possible next states
 *  given a current one.
**/

/** Given a position Pos, return all posible position after a move **/
moves(state(Turn, Pos) , PosList ):-
    switchTurn(Turn,NextTurn), % switch turn
    setof(state(NextTurn,NextPos),movePiece(Pos, NextPos),PosList). % all positions

switchTurn(min,max). % switch turn
switchTurn(max,min). % switch turn

movePiece(_Pos,_NextPos). % TODO: impl move piece to generate next possible move.

max_to_move(state(max,_)). % max turn to move
min_to_move(state(min,_)). % min turn to move