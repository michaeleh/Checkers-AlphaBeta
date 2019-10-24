
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_header)).
:- http_handler(root(.),handle_request,[]).

start:-
   http_server(http_dispatch,[port(3000)]).

handle_request(Request) :-
    http_read_json_dict(Request, DictIn),
    handle_json(DictIn,Response),
    reply_json(Response).

handle_json(Json,Response):-
    format(user_output,"Received Play~n",[]),
    parse_game(Json, Game),
    format(user_output," ~p~n",[Game]),

    Response=Json.

parse_game(Dict,game(State,settings(Level,Rows))):-
    Level = Dict.settings.level,
    Rows = Dict.settings.rows,
    Pieces = Dict.state,
    pieces_list(Pieces, State).

pieces_list([],[]).
pieces_list([JsonObj|JsonArray], PiecesList):-
    pieces_list(JsonArray,SubList),
    I = JsonObj.i,
    J = JsonObj.j,
    Color = JsonObj.color,
    IsQueen = JsonObj.isQueen,
    PiecesList = [piece(I,J,Color,IsQueen)| SubList].



