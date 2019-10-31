:- consult('../alphabeta/possible_states.pl'). % import possible states impl.

run:-
    % One in the corner with only 1 way to move
    moves(state(max,game([piece(7,7,black,false)],settings(9,8))),
    [state(min, game([piece(6, 6, black, false)], settings(9, 8)))]),
    
    % Dont have any pieces to move
    not(moves(state(min,game([piece(0,0,black,false)],settings(9,8))),_)),

    % One in the middle alone
    moves(state(max,game([piece(3,3,black,false)],settings(9,8))),
    [state(min, game([piece(2, 2, black, false)], settings(9, 8))),
    state(min, game([piece(2, 4, black, false)], settings(9, 8)))]),

    % One in the middle blocked by an ally
    moves(state(max,game([piece(3,3,black,false),piece(4,4,black,false)],settings(9,8))),
    [state(min, game([piece(2, 2, black, false), piece(4, 4, black, false)], settings(9, 8))),
    state(min, game([piece(2, 4, black, false), piece(4, 4, black, false)], settings(9, 8))),
    state(min, game([piece(3, 5, black, false), piece(3, 3, black, false)], settings(9, 8)))]),
    
    % One in the middle with somebody behind him
    moves(state(max,game([piece(3,3,black,false),piece(4,4,white,false)],settings(9,8))),
    [state(min, game([piece(2, 2, black, false), piece(4, 4, white, false)], settings(9, 8))),
    state(min, game([piece(2, 4, black, false), piece(4, 4, white, false)], settings(9, 8)))]),

    % One in the middle who can eat
    moves(state(min,game([piece(4,4,black,false),piece(3,3,white,false)],settings(9,8))),
    [state(max, game([piece(4, 2, white, false), piece(4, 4, black, false)], settings(9, 8))),
    state(max, game([piece(5, 5, white, false)], settings(9, 8)))]),

    % 2 black far away in the middle same color
    moves(state(max,game([piece(4,4,black,false),piece(6,6,black,false)],settings(9,8))),
    [state(min, game([piece(3, 3, black, false), piece(6, 6, black, false)], settings(9, 8))),
    state(min, game([piece(3, 5, black, false), piece(6, 6, black, false)], settings(9, 8))),
    state(min, game([piece(5, 5, black, false), piece(4, 4, black, false)], settings(9, 8))),
    state(min, game([piece(5, 7, black, false), piece(4, 4, black, false)], settings(9, 8)))]),

    % 2 white far away in the middle same color
    moves(state(min,game([piece(4,4,white,false),piece(2,2,white,false)],settings(9,8))),
    [state(max, game([piece(3, 1, white, false), piece(4, 4, white, false)], settings(9, 8))),
    state(max, game([piece(3, 3, white, false), piece(4, 4, white, false)], settings(9, 8))),
    state(max, game([piece(5, 3, white, false), piece(2, 2, white, false)], settings(9, 8))),
    state(max, game([piece(5, 5, white, false), piece(2, 2, white, false)], settings(9, 8)))]),

    % Double eating
    moves(state(max,game([piece(7,4,black,false),piece(6,3,white,false),piece(4,3,white,true)],settings(9,8))),
    [state(min, game([piece(3, 4, black, false)], settings(9, 8))),
    state(min, game([piece(5, 2, black, false), piece(4, 3, white, true)], settings(9, 8))),
    state(min, game([piece(6, 5, black, false), piece(6, 3, white, false), piece(4, 3, white, true)], settings(9, 8)))]),

    % Triple backward eating
    moves(state(max,game([piece(7,4,black,false),piece(6,3,white,false),piece(4,3,white,true),piece(4,5,white,false)],settings(9,8))),
    [state(min,game([piece(3,4,black,false),piece(4,5,white,false)],settings(9,8))),
    state(min,game([piece(5,2,black,false),piece(4,3,white,true),piece(4,5,white,false)],settings(9,8))),
    state(min,game([piece(5,6,black,false)],settings(9,8))),
    state(min,game([piece(6,5,black,false),piece(6,3,white,false),piece(4,3,white,true),piece(4,5,white,false)],settings(9,8)))]),

    % making a black queen
    moves(state(max,game([piece(1,4,black,false)],settings(9,8))),
    [state(min, game([piece(0, 3, black, true)], settings(9, 8))),
    state(min, game([piece(0, 5, black, true)], settings(9, 8)))]),

    % making a white queen
    moves(state(min,game([piece(6,4,white,false)],settings(9,8))),
    [state(max, game([piece(7, 3, white, true)], settings(9, 8))),
    state(max, game([piece(7, 5, white, true)], settings(9, 8)))]),

    
    % eating to become queen
    moves(state(max,game([piece(2,4,black,false),piece(1,3,white,true)],settings(9,8))),
    [state(min, game([piece(0, 2, black, true)], settings(9, 8))),
    state(min, game([piece(1, 5, black, false), piece(1, 3, white, true)], settings(9, 8)))]),

    % eating twise to not become queen
    moves(state(max,game([piece(2,2,black,false),piece(1,3,white,true),piece(1,5,white,false)],settings(9,8))),
    [state(min, game([piece(0, 4, black, true), piece(1, 5, white, false)], settings(9, 8))),
    state(min, game([piece(1, 1, black, false), piece(1, 3, white, true), piece(1, 5, white, false)], settings(9, 8))),
    state(min, game([piece(2, 6, black, false)], settings(9, 8)))]),

    % Queen in the middle
    moves(state(max,game([piece(4,4,black,true)],settings(9,8))),
    [state(min, game([piece(3, 3, black, true)], settings(9, 8))),
    state(min, game([piece(3, 5, black, true)], settings(9, 8))),
    state(min, game([piece(5, 3, black, true)], settings(9, 8))),
    state(min, game([piece(5, 5, black, true)], settings(9, 8)))]),

    % Queen only backward
    moves(state(max,game([piece(0,4,black,true)],settings(9,8))),
    [state(min, game([piece(1, 3, black, true)], settings(9, 8))),
    state(min, game([piece(1, 5, black, true)], settings(9, 8)))]),

    % Queen eating backwards
    moves(state(max,game([piece(0,4,black,true), piece(1,3,white,false)],settings(9,8))),
    [state(min, game([piece(1, 5, black, true), piece(1, 3, white, false)], settings(9, 8))),
    state(min, game([piece(2, 2, black, true)], settings(9, 8)))]),

    % Queen eating twice
    moves(state(max,game([piece(4,2,black,true), piece(5,3,white,false),piece(5,5,white,false)],settings(9,8))),
    [state(min,game([piece(3,1,black,true),piece(5,3,white,false),piece(5,5,white,false)],settings(9,8))),
    state(min,game([piece(3,3,black,true),piece(5,3,white,false),piece(5,5,white,false)],settings(9,8))),
    state(min,game([piece(4,6,black,true)],settings(9,8))),
    state(min,game([piece(5,1,black,true),piece(5,3,white,false),piece(5,5,white,false)],settings(9,8))),
    state(min,game([piece(6,4,black,true),piece(5,5,white,false)],settings(9,8)))]).


    