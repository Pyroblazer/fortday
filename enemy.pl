:- dynamic(enemy/5).

/* Enemy(EnemyID, EnemyX, EnemyY, EnemyHealth, EnemyAtk) */
init_enemy(0) :- !.
init_enemy(N) :- generate_enemy(N), M is N-1, init_enemy(M).

generate_enemy(EnemyID) :-
	repeat,
	random(1, 11, X), random(1, 21, Y),
	random(20, 45, Health), random(5, 12, Atk),
	grid(X, Y, Loc),
	Loc \== blank,
	asserta(enemy(EnemyID, X, Y, Health, Atk)).

% Health
decrease_enemy_health(EnemyID, Amount):-
	enemy(EnemyID, X, Y, Health, Atk),
 	ResultHealth is Health-Amount,
	ResultHealth > 0,
 	print_fail_kill,
 	retract(enemy(EnemyID, X, Y, Health, Atk)),
	asserta(enemy(EnemyID, X, Y, ResultHealth, Atk)), !.

% enemy dead
decrease_enemy_health(EnemyID, Amount):-
	enemy(EnemyID, X, Y, Health, Atk),
	ResultHealth is Health-Amount,
	ResultHealth =< 0,
	print_enemy_kill,
	print_drop_item,
	drop_item(X,Y),
	retract(enemy(EnemyID, X, Y, Health, Atk)).


% Position
get_enemy_position(EnemyID, X, Y):-
	enemy(EnemyID, X, Y, _, _).

/* Generate all random move for enemy */
generate_random_move(0) :- !.
generate_random_move(N) :- random_move(N), M is N-1, generate_random_move(M).

 /* Make random move for an enemy until enemy can move*/
random_move(EnemyID) :-
	get_position(X,Y), is_enemy_same(X,Y), !.
random_move(EnemyID) :-
	random(1, 6, X),
	select_step(EnemyID, X), !.
random_move(_) :- !.

/* This his how the enemy move */
select_step(EnemyID, 1) :-
	step_e_up(EnemyID), !.
select_step(EnemyID, 2) :-
	step_e_down(EnemyID), !.
select_step(EnemyID, 3) :-
	step_e_left(EnemyID), !.
select_step(EnemyID, 4) :-
	step_e_right(EnemyID), !.
select_step(EnemyID, 5) :- !.

step_e_up(EnemyID):-
	enemy(EnemyID, X, CurrentY, Health, Atk),
	CurrentY > 0,
	Y is CurrentY-1,
	grid(X, Y, Loc), Loc \== blank,
	retract(enemy(EnemyID, X, CurrentY, Health, Atk)),
	asserta(enemy(EnemyID, X, Y, Health, Atk)).

step_e_down(EnemyID):-
	enemy(EnemyID, X, CurrentY, Health, Atk),
	CurrentY < 19,
	Y is CurrentY+1,
	grid(X, Y, Loc), Loc \== blank,
	retract(enemy(EnemyID, X, CurrentY, Health, Atk)),
	asserta(enemy(EnemyID, X, Y, Health, Atk)).

step_e_left(EnemyID):-
	enemy(EnemyID, CurrentX, Y, Health, Atk),
	CurrentX > 0,
	X is CurrentX-1,
	grid(X, Y, Loc), Loc \== blank,
	retract(enemy(EnemyID, CurrentX, Y, Health, Atk)),
	asserta(enemy(EnemyID, X, Y, Health, Atk)).

step_e_right(EnemyID):-
	enemy(EnemyID, CurrentX, Y, Health, Atk),
	CurrentX < 9,
	X is CurrentX+1,
	grid(X, Y, Loc), Loc \== blank,
	retract(enemy(EnemyID, CurrentX, Y, Health, Atk)),
	asserta(enemy(EnemyID, X, Y, Health, Atk)).

/* Check if enemy is nearby */
/* Enemy nearby : from -1 -> +1 (X,Y) for player */
check_enemy_nearby :-
	player(X,Y,_,_,_,_,_),
	is_enemy_nearby(X,Y).

is_enemy_nearby(X, Y) :-
	A is X, B is Y,
	enemy(_, A, B, _, _), !.
is_enemy_nearby(X, Y) :-
	A is X-1, B is Y-1,
	enemy(_, A, B, _, _), !.
is_enemy_nearby(X, Y) :-
	A is X, B is Y-1,
	enemy(_, A, B, _, _), !.
is_enemy_nearby(X, Y) :-
	A is X+1, B is Y-1,
	enemy(_, A, B, _, _), !.
is_enemy_nearby(X, Y) :-
	A is X-1, B is Y,
	enemy(_, A, B, _, _), !.
is_enemy_nearby(X, Y) :-
	A is X+1, B is Y,
	enemy(_, A, B, _, _), !.
is_enemy_nearby(X, Y) :-
	A is X-1, B is Y+1,
	enemy(_, A, B, _, _), !.
is_enemy_nearby(X, Y) :-
	A is X, B is Y+1,
	enemy(_, A, B, _, _), !.
is_enemy_nearby(X, Y) :-
	A is X+1, B is Y+1,
	enemy(_, A, B, _, _), !.

/* check enemy same place */
check_enemy_same :-
	player(X,Y,_,_,_,_,_),
	is_enemy_same(X, Y),
	write('There\'s enemy in your sight'), nl, !.

is_enemy_same(X, Y) :-
	enemy(_, A, B, _, _),
	A =:= X, B =:= Y, !.


% Drop random item
drop_item(X,Y):-
	random(1,5,Rand),
	Rand is 1,
	drop_food(X,Y),!.

drop_item(X,Y):-
	random(1,5,Rand),
	Rand is 2,
	drop_drink(X,Y),!.

drop_item(X,Y):-
	random(1,5,Rand),
	Rand is 3,
	drop_medicine(X,Y),!.

drop_item(X,Y):-
	random(1,5,Rand),
	Rand is 4,
	drop_weapon(X,Y),!.

drop_food(X,Y):-
	random(1, 6, N),
	food_rate(N,A,_),
	asserta(location(X,Y,A)).

drop_drink(X,Y):-
	random(1, 6, N),
	drink_rate(N,A,_),
	asserta(location(X,Y,A)).

drop_medicine(X,Y):-
	random(1, 6, N),
	drink_rate(N,A,_),
	asserta(location(X,Y,A)).

drop_weapon(X,Y):-
	random(1,6,N),
	weapon_id(N,A),
	asserta(location(X,Y,A)).
