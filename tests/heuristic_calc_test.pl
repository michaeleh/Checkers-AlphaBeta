:- consult('alphabeta/heuristic_calc.pl'). % import possible states impl.

run:-
    % test numberOfPawns

    numberOfPawns(white, [piece(3,3,black,false),piece(4,4,black,false)], 0),
    numberOfPawns(white, [piece(3,3,white,false),piece(4,4,black,false)], 1),
    numberOfPawns(white, [piece(3,3,white,false),piece(4,4,white,true)], 1),
    numberOfPawns(white, [piece(3,3,white,true),piece(4,4,white,true)], 0),
    writeln('numberOfPawns - done!'),

    numberOfQueens(white, [piece(3,3,black,false),piece(4,4,black,true)], 0),
    numberOfQueens(white, [piece(3,3,white,false),piece(4,4,white,false)], 0),
    numberOfQueens(white, [piece(3,3,white,false),piece(4,4,white,true)], 1),
    numberOfQueens(white, [piece(3,3,white,true),piece(4,4,white,true)], 2),
    writeln('numberOfQueens - done!'),

    numberOfSafePawns(white, [piece(3,3,white,false),piece(5,4,black,true)], 6, 0),
    numberOfSafePawns(white, [piece(0,0,white,false),piece(5,4,white,false)], 6, 2),
    numberOfSafePawns(white, [piece(0,0,white,false),piece(4,4,white,false)], 5, 2),
    numberOfSafePawns(white, [piece(0,0,white,false),piece(4,4,white,true)], 5, 1),
    writeln('numberOfSafePawns - done!'),

    numberOfSafeQueens(white, [piece(0,0,black,false),piece(5,4,black,true)], 6, 0),
    numberOfSafeQueens(white, [piece(0,0,white,true),piece(5,4,white,false)], 6, 1),
    numberOfSafeQueens(white, [piece(0,0,white,true),piece(4,4,white,true)], 5, 2),
    numberOfSafeQueens(white, [piece(0,0,white,false),piece(4,4,white,true)], 5, 1),
    writeln('numberOfSafeQueens - done!'),

    aggregatedDistanceOfPawnsToPromotionLine(white, [piece(0,0,white,false),piece(2,2,white,true)], 5, 4),
    aggregatedDistanceOfPawnsToPromotionLine(white, [piece(0,0,white,false),piece(1,0,white,false), piece(2,2,white,true)], 5, 7),
    aggregatedDistanceOfPawnsToPromotionLine(black, [piece(4,4,black,false),piece(2,2,black,true)], 5, 4),
    aggregatedDistanceOfPawnsToPromotionLine(white, [piece(0,0,white,true),piece(4,4,white,true)], 5, 0),

    writeln('aggregatedDistanceOfPawnsToPromotionLine - done!'),

    numberOfUnoccupiedFieldsOnPromotionLine(white, [piece(4,0,white,false),piece(4,2,white,true)], 4, 2),
    numberOfUnoccupiedFieldsOnPromotionLine(black, [piece(0,4,black,false),piece(0,2,black,true)], 4, 0),
    numberOfUnoccupiedFieldsOnPromotionLine(black, [piece(1,4,black,false), piece(2,1,black,false)], 4, 2),
    numberOfUnoccupiedFieldsOnPromotionLine(black, 
        [piece(0,4,white,false), piece(0,4,white,false), piece(0,4,white,false),piece(0,2,black,true)]
        , 8, 0),
    numberOfUnoccupiedFieldsOnPromotionLine(white, 
            [piece(7,4,black,false), piece(7,2,black,false), piece(6,4,white,false),piece(7,2,black,true)]
            , 8, 1),
    numberOfUnoccupiedFieldsOnPromotionLine(white, 
        [piece(7,1,black,false), piece(7,3,black,false), piece(7,5,black,false),piece(7,6,black,true)]
        , 8, 0),

    writeln('numberOfUnoccupiedFieldsOnPromotionLine - done!'),

    PiecesList = [piece(0,1,white,false),piece(2,1,white,true)],
    numberOfMoveablePieces(white, PiecesList, PiecesList, false, 8, 1),
    numberOfMoveablePieces(white, PiecesList, PiecesList, true, 8, 1),
    numberOfMoveablePieces(black, PiecesList, PiecesList, true, 8, 0),

    writeln('numberOfMoveablePieces - done!').

