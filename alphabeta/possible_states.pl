/**
 * In this file we will implement the code to generate all possible next states
 *  given a current one.
**/

/** Given a position Pos, return all posible position after a move **/
moves(state(Turn, Pos) , PosList ):-
    switchTurn(Turn,NextTurn), % switch turn
    color(NextTurn,Color), % touch only pieces of your color
    setof(state(NextTurn,NextPos),possibleMoves(Color,Pos,Pos, NextPos),PosList). % all positions

switchTurn(min,max). % switch turn
switchTurn(max,min). % switch turn

/**
 * generate a sset of possible moves given your color
 * return the next position of the game after your move
 * */
possibleMoves(Color,game([Piece|Pieces],settings(Level,Rows)),Pos,NextPos):-
    Piece = piece(_,_,Color,_), movePiece(Piece,Pos,NextPos); % move the piece
    possibleMoves(Color,game(Pieces,settings(Level,Rows)),Pos,NextPos). % move a different piece 

/**
 * generate all legal ways you can move a peice
 * */
movePiece(Piece,game(Pieces,settings(Level,Rows)),game(NewPieces,settings(Level,Rows))):-
    delete(Pieces, Piece, SubPieces), % remove your old piece from the board
    canMoveTo(Piece,SubPieces,Rows,NewPieces).  % all places you can move to

/**
 * Given a piece and a board with pieces
 * check to which indexes on that board your piece can move
 * */
canMoveTo(Piece,SubPieces,Rows,NewPieces):-
    newIndex(Piece,Rows,piece(I,J,Color,IsQ)), % new indexes for the piece
    ( member(piece(I,J,_,_),SubPieces),!, % if occupied than eat
    eat(Piece,piece(I,J,Color,IsQ),SubPieces,Rows,NewPieces); % eat the peice and update
    NewPieces = [piece(I,J,Color,IsQ)|SubPieces]). % if empty place then procees

/**
 * new possible indexes to walk to
 * */    
newIndex(piece(I,J,Color,false),Row,piece(NewI,NewJ,Color,false)):-
    NewI is I + 1, (NewJ is J+1 ; NewJ is J-1), % progress the rows and move left or right collumn
    inRange(NewI,Row), inRange(NewJ,Row). % check if the new piece is in range

/**
 * if the peices is on the board
 * */
inRange(Index,Row):-
    Index >= 0, Index < Row.

/**
 * Eating logic
 * check if can eat then update the board
 * */
eat(OldPiece,NewPiece, SubPieces, Rows, [AfterEatPiece|EatenList]):-
    NewPiece = piece(I,J,Color,_),
    not(member(piece(I,J,Color,_),SubPieces)), % not with the same color
    doubleIndex(OldPiece,NewPiece,AfterEatPiece,Rows), % get indexes after eating
    AfterEatPiece = piece(EatI,EatJ,_,_),
    not(member(piece(EatI,EatJ,_,_),SubPieces)), % check if the place is empty
    delete(SubPieces, piece(I,J,_,_), EatenList). % delete the eaten piece.

/**
 * in case of eating
 * compute the diagonal path of the piece after eating a rival
 * */
doubleIndex(piece(_,J,Color,IsQ),piece(NewI,NewJ,Color,IsQ),piece(EatI,EatJ,Color,IsQ),Rows):-
    EatI is NewI + 1, % move up 
    EatJ is J + 2*(NewJ-J), % move in the diagonal direction twice
    inRange(EatJ,Rows), % check if still in range
    inRange(EatI,Rows). % check if still in range

max_to_move(state(max,_)). % max turn to move
min_to_move(state(min,_)). % min turn to move

/**
 * color to control
 * max - computer is white
 * min - player is black
 * */
color(min,black).
color(max,white).