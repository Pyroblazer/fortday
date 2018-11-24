:- include('command_list.pl').
:- include('enemy.pl').
:- include('items.pl').
:- include('map.pl').
:- include('player.pl').
:- include('print.pl').

/* Hentikan semua kegilaan ini */
/* This is command to start the game */
start :- g_read(started, X), X = 1, write('Game has already started'), nl, fail, !.
start :-
	g_read(started, X), X = 0, !,
	g_assign(started, 1),
	set_seed(50), randomize,
	init_everything,
	main_loop.

/* Main loop of the program */
main_loop :-
	welcome_info, print_player_nearby,
	repeat,
		set_seed(50), randomize,
		write('\nDo something > '),
		read(Input),
		%is_input(Input),
		call(Input),
	is_turn(Input), is_finished(Input), !.

/* Init everything when game started without load */
init_everything :-
	init_every_item,
	init_player,
	initialize_steps,
	initialize_deadzone,
	init_enemy(10).

/* Check if input is valid */
%is_input(listing) :-
% 	nl, write('...'), nl, !, fail.
%is_input(look):-!.
%is_input(save):-!.
%is_input(help):-!.
%is_input(attack):-!.
%is_input(map):-!.
%is_input(n):-!.
%is_input(e):-!.
%is_input(s):-!.
%is_input(w):-!.
%is_input(quit):-!.
%is_input(status):-!.
%is_input(take(_)):-!.
%is_input(use(_)):-!.
%is_input(load):-!.
%is_input(_):- write('Wrong input.'),nl,fail,!.

/* Check for command which not make a turn */

/* for save status look map, the player dont make a turn */
is_turn(load) :- !.
is_turn(save) :- !.
is_turn(status) :- !.
is_turn(look) :- !.
is_turn(help) :- !.
is_turn(map) :- !.

/* make a turn */
is_turn(attack):-
	generate_random_move(10),
	decrease_ammo(2),
	decrease_armor(2),
	effect_location,!.
is_turn(n) :-
	enemy_attack,
	generate_random_move(10),
	increment_steps,
	steps(X),
	deadzonesize(Z),
	widen_deadzone(Z,X),
	effect_location,!.
is_turn(e) :-
	enemy_attack,
	generate_random_move(10),
	increment_steps,
	steps(X),
	deadzonesize(Z),
	widen_deadzone(Z,X),
	effect_location,!.
is_turn(w) :-
	enemy_attack,
	generate_random_move(10),
	increment_steps,
	steps(X),
	deadzonesize(Z),
	widen_deadzone(Z,X),
	effect_location,!.
is_turn(s) :-
	enemy_attack,
	generate_random_move(10),
	increment_steps,
	steps(X),
	deadzonesize(Z),
	widen_deadzone(Z,X),
	effect_location,!.
is_turn(_) :-
	generate_random_move(10),
	enemy_attack,
	effect_location,!.
is_turn(_) :- effect_location,!.

/* check if the game is finished */
is_finished(Input) :-
	Input = quit, !.
is_finished(_) :-
	\+ enemy(_,_,_,_,_), nl,
	write('You have won the game!'), nl, quit, !.
is_finished(_) :-
	get_health(Health),
	Health =< 0, nl,
	write('You died.'), nl, quit,!.
