:- dynamic(location/3).

/* Item Facts */

/* Id of weapon */
weapon_id(0, hand).
weapon_id(1, handcannon). 
weapon_id(2, sixshooter).
weapon_id(3, quadlauncher).
weapon_id(4, chaingun).
weapon_id(5, fiendhuntercrossbow).
weapon_id(6, rocketlauncher).

/* Attack of weapon */
weapon_atk(hand, 5).
weapon_atk(handcannon, 20).
weapon_atk(sixshooter, 30).
weapon_atk(quadlauncher, 40).
weapon_atk(chaingun, 50).
weapon_atk(fiendhuntercrossbow, 60).
weapon_atk(rocketlauncher, 80).

/* Type of item */
type_item(ammo, large_magazine).
type_item(ammo, magazine).
type_item(armor, shieldpotion).
type_item(armor, mushroom).
type_item(armor, tactical_armor).
type_item(armor, battlesuit).
type_item(armor, knightarmor).
type_item(medicine, medkit).
type_item(medicine, apple).
type_item(medicine, chug_jug).
type_item(medicine, aspirine).
type_item(medicine, painkiller).

/* Ammo rate */
ammo_rate(1, magazine, 10).
ammo_rate(2, large_magazine, 20).

/* Armor rate */
armor_rate(1, shieldpotion, 25).
armor_rate(2, mushroom, 10).
armor_rate(3, tactical_armor, 40).
armor_rate(4, battlesuit, 70).
armor_rate(5, knightarmor, 50).

/* medicine heal rate */
medicine_rate(1, medkit, 70).
medicine_rate(2, apple, 10).
medicine_rate(3, chug_jug, 30).
medicine_rate(4, aspirine, 20).
medicine_rate(5, painkiller, 40).


/* Item Rules */

/* Initialize map with everything */

init_every_item :-
	init_all_weapon, init_all_armor, init_all_ammo, init_all_medicine, !.

/* Initialize map with weapons */
init_all_weapon :-
	init_weapon(20), init_weapon_forge(5).

init_weapon(0) :- !.
init_weapon(N) :-
	random_weapon,
	M is N -1,
	init_weapon(M).

init_weapon_forge(0) :- !.
init_weapon_forge(N) :-
	random_weapon_forge, M is N-1, init_weapon_forge(M).

random_weapon :-
	repeat,
	random(1, 6, N), weapon_id(N, A),
	random(0, 10, X), random(0, 10, Y),
	grid(X, Y, _, Loc),
	Loc \== blank,
	asserta(location(X, Y, A)).

random_weapon_forge :-
	random(1, 6, N), weapon_id(N, A),
	random(0, 10, X), random(0, 10, Y),
	asserta(location(X, Y, A)).

/* Initialize map with armor */
init_all_armor :-
	init_armor(20).

init_armor(0) :- !.
init_armor(N) :- random_armor, M is N -1, init_armor(M).

random_armor :-
	repeat,
	random(1, 6, N), armor_rate(N, A, _),
	random(0, 10, X), random(0, 10, Y),
	grid(X, Y, _, Loc),
	Loc \== blank,
	asserta(location(X, Y, A)).

/* Initialize map with ammo */
init_all_ammo :-
	init_ammo(20).

init_ammo(0) :- !.
init_ammo(N) :- random_ammo, M is N -1, init_ammo(M).

random_ammo :-
	repeat,
	random(1, 2, N), ammo_rate(N, A, _),
	random(0, 10, X), random(0, 10, Y),
	grid(X, Y, _, Loc),
	Loc \== blank,
	asserta(location(X, Y, A)).

/* Initialize map with medicine */
init_all_medicine :-
	init_medicine(10).

init_medicine(0) :- !.
init_medicine(N) :- random_medicine, M is N -1, init_medicine(M).

random_medicine :-
	repeat,
	random(1, 6, N), medicine_rate(N, A, _),
	random(0, 10, X), random(0, 10, Y),
	grid(X, Y, _, Loc),
	Loc \== blank,
	asserta(location(X, Y, A)).
