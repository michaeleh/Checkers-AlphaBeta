/**
 * In this file we will implement all the code
 * for calculating static values for a position
 * using a heuristic predicates
 * */
:- consult('alphabeta/heuristic_calc.pl'). % import possible states impl.
?- assert(saved_value(0,0)). % dummy value for compiler.

staticval(Pos, Val):-
    % value is already in db
    saved_value(Pos,Val).

staticval(Pos, Val):-
    % (value isn't in db)
    heuristic_calc_for_pos(Pos, Val), !, % calc value
    assert(saved_value(Pos, Val)). % add it to db

        