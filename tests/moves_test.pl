:- consult('../alphabeta/possible_states.pl'). % import possible states impl.

% אחד שיכול להיות מלכה
% אחד שאוכל כפול ולא נהיה מלכה 
% מלכה שהולכת לכל כיוון באמצע
% מלכה שהולכת אחרוה בשורה האחרונה
% מלכה שאוכלת אחורה
% מלכה שאוכלת אחורה כפול
run(X):-
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

    % 2 black far away in the middle same color
    moves(state(min,game([piece(4,4,white,false),piece(6,6,white,false)],settings(9,8))),
    [state(max, game([piece(5, 3, white, false), piece(6, 6, white, false)], settings(9, 8))),
    state(max, game([piece(5, 5, white, false), piece(6, 6, white, false)], settings(9, 8))),
    state(max, game([piece(7, 5, white, false), piece(4, 4, white, false)], settings(9, 8))),
    state(max, game([piece(7, 7, white, false), piece(4, 4, white, false)], settings(9, 8)))]),

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
    state(min,game([piece(6,5,black,false),piece(6,3,white,false),piece(4,3,white,true),piece(4,5,white,false)],settings(9,8)))]).