/**
 *  http server to handle push requests of position
 * */
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_header)).
:- http_handler(root(.),handle_request,[]).
:- consult('json_to_structure_parser.pl').
:- consult('../alphabeta/alpha_beta.pl').


% start server at port 3000.
start:-
   http_server(http_dispatch,[port(3000)]).

% handle push request.
handle_request(Request) :-
    http_read_json_dict(Request, DictIn), % read json as dict
    handle_json(DictIn,Response), % handle request
    format(user_output,"Returning Play ~p~n ",[Response]),
    reply_json(Response). % reply best move

handle_json(Json,Response):-
    format(user_output,"Received Play ~n ",[]),
    parse_game(Json, Game), % parse as structure
    Game = game(_,settings(Level,_)), % get level
    best_move(Game,Level,NextMove), % get next move
    NextMove = state(_,game(PeicesList,_)), % get the pieces
    prolog_to_json(PeicesList, Response). % sending response

