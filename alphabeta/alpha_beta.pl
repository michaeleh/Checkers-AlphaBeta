/**
* Figure 22.5  An implementation of the alpha-beta algorithm.
* from http://media.pearsoncmg.com/intl/ema/ema_uk_he_bratko_prolog_3/prolog/ch22/fig22_5.txt
* improving alpha beta algorithm with db saving
* TODO: remeber to sort position tree from best to worst for max pruninng
* */
:- consult('heuristic_static_values.pl'). % import staticval impl.
:- consult('possible_states.pl'). % import possible states impl.
:- consult('../levels.pl'). % import levels impl.
?- assert(saved_value(0,0)). % dummy value for compiler.

/** given a position find best next move for computer **/
best_move(CurrentPosition, MaxLevel, GoodPos):-
    % TODO, check max and min values of the hueristic function
    alphabeta(0,MaxLevel,state(max,CurrentPosition),-9999,9999,GoodPos,_), % find good pos
    retractall(saved_value(_,_)).% delete db

alphabeta(CurrentLevel, MaxLevel, Pos, Alpha, Beta, GoodPos, Val)  :-
    saved_value(Pos, Val),!; % if position already explored.
    NextLevel is CurrentLevel + 1,
    NextLevel =< MaxLevel,
    moves( Pos, PosList), !,
    boundedbest(NextLevel, MaxLevel, PosList, Alpha, Beta, GoodPos, Val),
    assert(saved_value(Pos,Val)); % save explored solution.
    staticval( Pos, Val). % Static value of Pos 
    
boundedbest(CurrentLevel, MaxLevel, [Pos | PosList], Alpha, Beta, GoodPos, GoodVal)  :-
    alphabeta(CurrentLevel, MaxLevel, Pos, Alpha, Beta, _, Val),
    goodenough(CurrentLevel, MaxLevel, PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal).
      
goodenough(_,_, [], _, _, Pos, Val, Pos, Val)  :-  !.% No other candidate
    
goodenough(_,_,_, Alpha, Beta, Pos, Val, Pos, Val)  :-
    min_to_move( Pos), Val > Beta, ! % Maximizer attained upper bound
    ;
    max_to_move( Pos), Val < Alpha, !. % Minimizer attained lower bound
      
goodenough(CurrentLevel, MaxLevel, PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal)  :-
    newbounds( Alpha, Beta, Pos, Val, NewAlpha, NewBeta), % Refine bounds  
    boundedbest(CurrentLevel, MaxLevel, PosList, NewAlpha, NewBeta, Pos1, Val1),
    betterof( Pos, Val, Pos1, Val1, GoodPos, GoodVal).
      
newbounds( Alpha, Beta, Pos, Val, Val, Beta)  :-
    min_to_move( Pos), Val > Alpha, !. % Maximizer increased lower bound 
      
newbounds( Alpha, Beta, Pos, Val, Alpha, Val)  :-
    max_to_move( Pos), Val < Beta, !. % Minimizer decreased upper bound 
      
newbounds( Alpha, Beta, _, _, Alpha, Beta). % Otherwise bounds unchanged 
      
betterof( Pos, Val, _, Val1, Pos, Val)  :- % Pos better than Pos1 
    min_to_move( Pos), Val > Val1, !
    ;
    max_to_move( Pos), Val < Val1, !.
      
betterof( _, _, Pos1, Val1, Pos1, Val1). % Otherwise Pos1 better
      