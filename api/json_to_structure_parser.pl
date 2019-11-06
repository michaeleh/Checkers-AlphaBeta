/**
 * This file contains parsers from json to a prolog structure
 * */

%defining the json structure for response
:- json_object
      piece(i:integer, j:integer, color:atom, isQueen:atom).


/**
* receives a json dict and convert it to a structure
**/
parse_game(Dict,game(State,settings(Level,Rows))):-
    Level = Dict.settings.level,
    Rows = Dict.settings.rows,
    Pieces = Dict.state,
    pieces_list(Pieces, State). % parse the json array to structure as well

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