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
    ( member(piece(I,J,_,_),SubPieces), % if occupied then eat
    eat(Piece,piece(I,J,Color,IsQ),SubPieces,Rows,NewPieces); % eat the peice and update
    not(member(piece(I,J,_,_),SubPieces)), NewPieces = [piece(I,J,Color,IsQ)|SubPieces]). % if empty place then procees

/**
 * new possible indexes to walk to
 * */    
newIndex(piece(I,J,Color,IsQ),Row,piece(NewI,NewJ,Color,IsQ)):-
    newI(piece(I,J,Color,IsQ),NewI), (NewJ is J+1 ; NewJ is J-1), % progress the rows and move left or right collumn
    inRange(NewI,Row), inRange(NewJ,Row). % check if the new piece is in range


newI(piece(I,_,_,true),NewI):-  NewI is I-1; NewI is I+1.
newI(piece(I,_,white,false),NewI):-   NewI is I+1.
newI(piece(I,_,black,false),NewI):-   NewI is I-1.
/**
 * if the peices is on the board
 * */
inRange(Index,Row):-
    Index >= 0, Index < Row.

/**
 * Eating logic
 * check if can eat then update the board
 * */
eat(OldPiece,NewPiece, SubPieces, Rows, EatenList):-
    NewPiece = piece(I,J,Color,IsQ),
    not(member(piece(I,J,Color,_),SubPieces)), % not with the same color
    doubleIndex(OldPiece,NewPiece,AfterEatPiece,Rows), % get indexes after eating
    AfterEatPiece = piece(EatI,EatJ,_,_),
    not(member(piece(EatI,EatJ,_,_),SubPieces)), % check if the place is empty
    delete(SubPieces, piece(I,J,_,_), EatenList1),  % delete the eaten piece.
    (EatenList = [AfterEatPiece|EatenList1]; % eat once
    % check if can eat again
    (newIndex(AfterEatPiece,Rows,piece(NewI,NewJ,Color,IsQ)); % new indexes for the piece
    drawBack(piece(EatI,_,Color,_),BackI), newIndex(piece(BackI,EatJ,Color,IsQ),Rows,piece(NewI,NewJ,Color,IsQ))), % eat backwards, move the I index back twice and use forward move to mock backward move
    member(piece(NewI,NewJ,_,_),EatenList1),!, % if occupied then eat
    eat(AfterEatPiece,piece(NewI,NewJ,Color,IsQ),EatenList1,Rows,EatenList)). % check if can eat again

drawBack(piece(I,_,Color,_),NewI):-
    Color=black,!, newI(piece(I,_,white,_),NewI1),newI(piece(NewI1,_,white,_),NewI);
    newI(piece(I,_,black,_),NewI1),newI(piece(NewI1,_,black,_),NewI).
/**
 * in case of eating
 * compute the diagonal path of the piece after eating a rival
 * */
doubleIndex(piece(I,J,Color,IsQ),piece(NewI,NewJ,Color,IsQ),piece(EatI,EatJ,Color,IsQ),Rows):-
    EatI is I + 2*(NewI-I), % move up 
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