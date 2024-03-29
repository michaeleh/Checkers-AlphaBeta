:-consult('possible_states.pl').

/**
 * heuristic_calc_for_pos(State, Val):-
 * 
 * Calculates the Heuristics values for a given state.
 * Uses heuristic_calc_for_player.
 * The final result is the sub between the two player's values
 */ 
heuristic_calc_for_pos(state(Player, game(ListOfPieces, settings(_, Rows))), Val):-
    % convert from min/max to player color
    color(Player, CurrentPlayer),
    % get rival color
    otherColor(CurrentPlayer, RivalColor),
    % calculate heuristic value for current player
    heuristic_calc_for_player(CurrentPlayer, ListOfPieces, Rows, CurrPlayerVal),
    % calculate heuristic value for rival player
    heuristic_calc_for_player(RivalColor, ListOfPieces, Rows, RivalPlayerVal),
    % the heuristic value is the sub of the two
    Val is CurrPlayerVal - RivalPlayerVal.


/**
 * heuristic_calc_for_player(Player, ListOfPieces, NumberOfRows, Val)- 
 * 
 * Calculates and returns the following heuristics:
 * 
 * 1. Number of pawns;
 * 2. Number of queens;
 * 3. Number of safe pawns (i.e. adjacent to the edge of the board);
 * 4. Number of safe queens;
 * 5. Number of moveable pawns (i.e. able to perform a move other than capturing).
 * 6. Number of moveable queens. Parameters 5 and 6 are calculated taking no notice of
        capturing priority;
 * 7. Aggregated distance of the pawns to promotion line;
 * 8. Number of unoccupied fields on promotion line.
 * 
 */ 
heuristic_calc_for_player(Player, ListOfPieces, NumberOfRows, Val):-
    numberOfPawns(Player, ListOfPieces, Pawns),
    numberOfQueens(Player, ListOfPieces, Queens),
    numberOfSafePawns(Player, ListOfPieces, NumberOfRows, SafePawns),
    numberOfSafeQueens(Player, ListOfPieces, NumberOfRows, SafeQueens),
    numberOfMoveablePawns(Player, ListOfPieces, NumberOfRows, MoveablePawns),
    numberOfMoveableQueens(Player, ListOfPieces, NumberOfRows, MoveableQueens),
    aggregatedDistanceOfPawnsToPromotionLine(Player, ListOfPieces, NumberOfRows, AggregatedDistancePawns),
    numberOfUnoccupiedFieldsOnPromotionLine(Player, ListOfPieces, NumberOfRows, UnoccupiedFields),
    Val is (
    Pawns + 
    Queens * 3 + 
    SafePawns * 2 +
    SafeQueens * 4 +
    MoveablePawns * 2 +
    MoveableQueens * 4 +
    AggregatedDistancePawns * 2 +
    UnoccupiedFields
    ).

/**
 * get rival color
 */
otherColor(black, white).
otherColor(white, black).    


/**
 * promotionLine(Color, NumberOfRows, PromotionLine):-
 * 
 * returns the promotion line index based on the color of the player and the settings
 */ 
promotionLine(white, NumberOfRows, PromotionLine):-
    PromotionLine is NumberOfRows - 1.
promotionLine(black, _, 0).

/**
 * absSub(X, Y, Sum) - 
 * 
 * sub the two numbers and return the absolute value 

 */ 
absSub(X, Y, Sum):-
    % if X is bigger the Y
    X > Y, !, 
    % absolute value is only sub
    Sum is X - Y.
absSub(X, Y, Sum):-
    % At this point we know that: Y >= X, so return Y - X
    Sum is Y - X.


/**
 * numberOfUnoccupiedFieldsOnPromotionLine(Turn, ListOfPieces, NumberOfRows, Sum) - 
 * 
 * Sums the number of unoccupied fields on promotion line for TurnPlayer - (uses numberOfOccupiedFieldsOnPromotionLine)
 */
numberOfUnoccupiedFieldsOnPromotionLine(Turn, ListOfPieces, NumberOfRows, Sum):-
    % get number of occupied fields by rival on promotion line
    numberOfOccupiedFieldsOnPromotionLine(Turn, ListOfPieces, NumberOfRows, RivalOnPromotionLine),
    % sub total reachable places on promotion line and occupied fields
    Sum is (NumberOfRows // 2) - RivalOnPromotionLine.

/**
 * numberOfOccupiedFieldsOnPromotionLine(Turn, ListOfPieces, NumberOfRows, Sum) - 
 * 
 * Sums the number of occupied fields on promotion line.
 */ 
numberOfOccupiedFieldsOnPromotionLine(_, [], _, 0):- !.  % finished the list
numberOfOccupiedFieldsOnPromotionLine(Turn, [piece(Row, _, _, _) | Tail], NumberOfRows, Sum):-
    promotionLine(Turn, NumberOfRows, Row), !, % get the promotion line for current player
    % at this point, we know that it's the rival piece, and it is on the promotion line
    numberOfOccupiedFieldsOnPromotionLine(Turn, Tail, NumberOfRows, SumTail),
    % add 1 to recursion sum
    Sum is SumTail + 1.
numberOfOccupiedFieldsOnPromotionLine(Turn, [piece(_, _, _, _) | Tail], NumberOfRows, Sum):-
     % otherwise -> don't sum, move to next piece
    numberOfOccupiedFieldsOnPromotionLine(Turn, Tail, NumberOfRows, Sum).



/**
 * aggregatedDistanceOfPawnsToPromotionLine(Turn, ListOfPieces, NumberOfRows, Sum) - 
 * 
 * Sums distance of the pawns to promotion line for Turn player.
 */ 
aggregatedDistanceOfPawnsToPromotionLine(_, [], _, 0):- !.  % finished the list
aggregatedDistanceOfPawnsToPromotionLine(Turn, [piece(Row, _, Turn, false) | Tail], NumberOfRows, Sum):-
    !, 
    aggregatedDistanceOfPawnsToPromotionLine(Turn, Tail, NumberOfRows, SumTail), % recursive sum
    promotionLine(Turn, NumberOfRows, PromotionLine),
    absSub(Row, PromotionLine, DistanceToPromotionLine), % calc distance 
    Sum is SumTail + DistanceToPromotionLine. % add recursive sum to current piece distance
aggregatedDistanceOfPawnsToPromotionLine(Turn, [piece(_, _, _, _) | Tail], NumberOfRows, Sum):-
    % piece isn't suitable -> check the next piece
    aggregatedDistanceOfPawnsToPromotionLine(Turn, Tail, NumberOfRows, Sum). 

/**
 * numberOfMoveablePawns(Turn, ListOfPieces, NumberOfRows, Sum) - 
 * 
 * Sums the number of movable pawns for Turn player.
 * Uses numberOfMoveablePieces.
 */ 
numberOfMoveablePawns(Turn, ListOfPieces, NumberOfRows, Sum):- 
    numberOfMoveablePieces(Turn, ListOfPieces, ListOfPieces, false, NumberOfRows, Sum).

/**
 * numberOfMoveableQueens(Turn, ListOfPieces, NumberOfRows, Sum) - 
 * 
 * Sums the number of movable queens for Turn player.
 * Uses numberOfMoveablePieces.
 */ 
numberOfMoveableQueens(Turn, ListOfPieces, NumberOfRows, Sum):- 
    numberOfMoveablePieces(Turn, ListOfPieces, ListOfPieces, true, NumberOfRows, Sum).

/**
 * numberOfMoveablePieces(Turn, ListOfPiecesLeftToCheck, OriginalListOfPieces, IsQueen,NumberOfRows, Sum) - 
 * 
 * Sums the number of movable pieces (pawns or queen) for Turn player. 
 * (Taking no notice of capturing priority)
 * Uses canMoveTo(Piece,SubPieces,Rows,NewPieces) from possible_states.pl
 */ 
numberOfMoveablePieces(_, [], _,  _,_, 0):- !. % finished the list
numberOfMoveablePieces(Turn, [piece(Row, Col, Turn, IsQueen) | Tail], OriginalListOfPieces,  IsQueen, NumberOfRows, Sum):-
    canMoveTo(piece(Row, Col, Turn, IsQueen), OriginalListOfPieces, NumberOfRows, _), !, % check that the piece can move anywhere
    % recursive call 
    numberOfMoveablePieces(Turn, Tail, OriginalListOfPieces, IsQueen, NumberOfRows, SumTail),
    % sum 
    Sum is SumTail + 1.
numberOfMoveablePieces(Turn, [piece(_, _, _, _) | Tail], OriginalListOfPieces,  IsQueen, NumberOfRows, Sum):-
      % piece isn't suitable -> check the next piece
    numberOfMoveablePieces(Turn, Tail, OriginalListOfPieces, IsQueen, NumberOfRows, Sum).


/**
 * numberOfSafePawns(Turn, ListOfPieces, NumberOfRows, Sum) - 
 * 
 * Sums the number of "safe" pieces pawns for Turn player.
 * Uses numberOfSafePiece
 */ 
numberOfSafePawns(Turn, ListOfPieces, NumberOfRows, Sum):- 
    numberOfSafePiece(Turn, ListOfPieces, false, NumberOfRows, Sum).

/**
 * numberOfSafeQueens(Turn, ListOfPieces, NumberOfRows, Sum) - 
 * 
 * Sums the number of "safe" queens pawns for Turn player.
 * Uses numberOfSafePiece
 */ 
numberOfSafeQueens(Turn, ListOfPieces, NumberOfRows, Sum):- 
    numberOfSafePiece(Turn, ListOfPieces, true, NumberOfRows, Sum).


/**
 * numberOfSafePiece(Turn, ListOfPieces, IsQueen,NumberOfRows, Sum) - 
 * 
 * Sums the number of "safe" pieces (pawns or queen) for Turn player.
 * Safe means that the piece is on the edge of the board (first or last row/column)
 */ 
numberOfSafePiece(_, [], _, _, 0):- !. % finished the list
numberOfSafePiece(Turn, [piece(0, _, Turn, IsQueen) | Tail], IsQueen,NumberOfRows, Sum):-
    % first line is safe
    !, numberOfSafePiece(Turn, Tail, IsQueen, NumberOfRows, SumTail), 
    Sum is SumTail + 1.
numberOfSafePiece(Turn, [piece(Row, _, Turn, IsQueen) | Tail], IsQueen,NumberOfRows, Sum):-
    % final line is safe
    Row is NumberOfRows - 1, !, 
    numberOfSafePiece(Turn, Tail, IsQueen, NumberOfRows, SumTail),
    Sum is SumTail + 1.
numberOfSafePiece(Turn, [piece(Row, 0, Turn, IsQueen) | Tail], IsQueen,NumberOfRows, Sum):-
    % first col is safe (check for double summing index(0, 0))
    Row \= 0, !, 
    numberOfSafePiece(Turn, Tail, IsQueen, NumberOfRows, SumTail),
    Sum is SumTail + 1.
numberOfSafePiece(Turn, [piece(Row, Col, Turn, IsQueen) | Tail], IsQueen,NumberOfRows, Sum):-
    % last col is safe (check for double summing index(NumberOfRows - 1, NumberOfRows - 1))
    Row \= 0, Col is NumberOfRows - 1, !,
    numberOfSafePiece(Turn, Tail, IsQueen, NumberOfRows, SumTail),
    Sum is SumTail + 1.
numberOfSafePiece(Turn, [piece(_, _, _, _) | Tail], IsQueen,NumberOfRows, Sum):-
    % otherwise -> piece isn't safe
    numberOfSafePiece(Turn, Tail, IsQueen, NumberOfRows, Sum).

/**
 * numberOfPawns(Turn, ListOfPieces, Sum) - 
 * 
 * Sums the number of pawns for Turn player.
 * Uses numberOfPiece.
 */ 
numberOfPawns(Turn, PosList, Sum):-
    numberOfPiece(Turn, PosList, Sum, false).
/**
 * numberOfQueens(Turn, ListOfPieces, Sum) - 
 * 
 * Sums the number of queens for Turn player.
 * Uses numberOfPiece.
 */ 
numberOfQueens(Turn, PosList, Sum):-
    numberOfPiece(Turn, PosList, Sum, true).


/**
 * numberOfPiece(Turn, ListOfPieces, Sum, IsQueen) - 
 * 
 * Sums the number of pieces (pawns or queen) for Turn player.
 */ 
numberOfPiece(_, [], 0, _):- !. % stop recursive search
numberOfPiece(Turn, [piece(_,_,Turn , IsQueen) | T], Sum, IsQueen):-
    !, numberOfPiece(Turn, T, SumTail, IsQueen),
    % add 1 to sum
    Sum is SumTail + 1.
numberOfPiece(Turn, [piece(_,_,_, _) | T], Sum, IsQueen):-
    % piece isn't suitable
    numberOfPiece(Turn, T, Sum, IsQueen).



