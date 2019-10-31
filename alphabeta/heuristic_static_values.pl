/**
 * In this file we will implement all the code
 * for calculating static values for a position
 * using a heuristic predicates
 * */
:- consult('heuristic_calc.pl'). % import possible states impl.
% TODO, check max and min values of the hueristic function to use as parameters in alpha beta
?- assert(saved_value(0,0)). % dummy value for compiler.

 % TODO: impl heuristic_static_values for start/middle and endgame.
staticval(Pos, Val):-
    % value us already in db
    retract(saved_value(Pos, Val)), ! % remove from db
    assert(saved_value(Pos, Val)).  % add it again 

staticval(Pos, Val):-
    heuristic_calc_for_pos(Pos, Val), !,
    assert(saved_value(Pos, Val)).

        