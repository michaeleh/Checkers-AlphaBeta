/**
 * This file contains parsers from json to a prolog structure
 * */

%defining the json structure for response
:- json_object
      piece(i:integer, j:integer, color:atom, isQueen:atom).


/**
* receives a json dict and convert it to a structure
**/
parse_game(Dict,game(State,settings(Depth,Rows))):-
    atom_string(Level,Dict.settings.level),
    Rows = Dict.settings.rows,
    Pieces = Dict.state,
    pieces_list(Pieces, State), % parse the json array to structure as well
    alphabeta_depth(State,Level,Depth).

/**
 * if received an empty list then keep it empty 
 * */
pieces_list([],[]).
pieces_list([JsonObj|JsonArray], PiecesList):-
    pieces_list(JsonArray,SubList), % proceed to the end of the list
    I = JsonObj.i,
    J = JsonObj.j,
    atom_string(Color,JsonObj.color),% to atom
    atom_string(IsQueen,JsonObj.isQueen),% to atom
    PiecesList = [piece(I,J,Color,IsQueen)| SubList]. % add the piece as structure

/**
 * parsing to level based on game setup
 * receives atom of easy,medium,high and outputs a number
 * */
alphabeta_depth(Pieces,Level, Depth):-
    length(Pieces,NumPieces),% consider number of pieces
    D1 is 9 - NumPieces//5, % transform the number of peices to a depth using negative relation fomula
    factor(Level,Factor), % use factor for high medium low
    DepthFactor is D1/Factor,
    round(DepthFactor,DepthRound),
    max(1,DepthRound,Depth).
    
max(A,B,X):- A>B,!,X=A;X=B.
% to multyply by this factor to get the level 
factor(hard,1).
factor(medium,1.5).
factor(easy,3).