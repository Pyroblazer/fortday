use_module(command_list).
use_module(enemy).
use_module(items).
use_module(map).
use_module(player).
use_module(print).

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
	init_enemy(10).

/* Check if input is valid */
%is_input(listing) :-
% 	nl, write('Yo dude don\'t cheat..\n'), nl, !, fail.
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
%is_input(pray):-!.
%is_input(_):- write('Wrong input. Please try again.'),nl,fail,!.

/* Check for command which not make a turn */

/* for save status look map, the player dont make a turn */
is_turn(load) :- !.
is_turn(save) :- !.
is_turn(status) :- !.
is_turn(look) :- !.
is_turn(help) :- !.
is_turn(map) :- !.
is_turn(listing) :- !.
is_turn(pray) :- !.

/* make a turn */
is_turn(attack):-
	generate_random_move(10),
	decrease_hunger(2),
	decrease_thirst(2),
	effect_location,!.
is_turn(n) :-
	enemy_attack,
	generate_random_move(10),
	decrease_hunger(2),
	decrease_thirst(2),
	effect_location,!.
is_turn(e) :-
	enemy_attack,
	generate_random_move(10),
	decrease_hunger(2),
	decrease_thirst(2),
	effect_location,!.
is_turn(w) :-
	enemy_attack,
	generate_random_move(10),
	decrease_hunger(2),
	decrease_thirst(2),
	effect_location,!.
is_turn(s) :-
	enemy_attack,
	generate_random_move(10),
	decrease_hunger(2),
	decrease_thirst(2),
	effect_location,!.
is_turn(_) :-
	generate_random_move(10),
	enemy_attack,
	decrease_hunger(2),
	decrease_thirst(2),
	effect_location,!.
is_turn(_) :- effect_location,!.

/* check if the game is finished */
is_finished(Input) :-
	Input = quit, !.
is_finished(_) :-
	\+ enemy(_,_,_,_,_), nl,
	write('You have won the game! Congrats!'), nl, quit, !.
is_finished(_) :-
	get_health(Health),
	Health =< 0, nl,
	write('You feel that you can\'t continue your study in ITB... You\'re very tired.. It feel sucks...'), nl,
	write('So you choose to quit from ITB and become a neet...'), nl, quit,!.
is_finished(_) :-
	get_hunger(Hunger),
	Hunger =< 0, nl,
	write('You\'re too tired of the food near ITB... You choose to quit from ITB and try the other universities'), nl,
	write('.'), nl, write('.'), nl, write('.'), nl,
	write('JUST FOR FOOD!'), nl, quit,!.
is_finished(_) :-
	get_thirst(Thirst),
	Thirst =< 0, nl,
	write('You\'re very thirsty... You feel that if you continue study in ITB.. You will die from dehydration..'), nl,
	write('So you choose to quit from ITB.. How weak!'), nl, quit,!.
