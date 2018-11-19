:- dynamic(location/3).

/* All items added as facts */

/* Id of weapon */
weapon_id(0, nothing).
weapon_id(1, webtoon).
weapon_id(2, anime).
weapon_id(3, dota).
weapon_id(4, begadang).
weapon_id(5, osjur).
weapon_id(6, mapres).

/* Attack of weapon */
weapon_atk(webtoon, 10).
weapon_atk(anime, 20).
weapon_atk(dota, 30).
weapon_atk(begadang, 50).
weapon_atk(osjur, 70).
weapon_atk(nothing, 0).
weapon_atk(mapres, 100).

/* Type of item */
type_item(food, nasi_korea).
type_item(food, nasi_jepang).
type_item(food, danusan).
type_item(food, geprek).
type_item(food, uncle_bro).
type_item(drink, aqua).
type_item(drink, go_milk).
type_item(drink, thai_tea).
type_item(drink, chocolate_changer).
type_item(drink, coffee).
type_item(medicine, uts_100).
type_item(medicine, kuis_100).
type_item(medicine, angbis).
type_item(special, radar).
type_item(special_eggs, foto_odi).
type_item(special_eggs, foto_fahmi).

/* Food hunger rate */
food_rate(1, nasi_korea, 35).
food_rate(2, nasi_jepang, 40).
food_rate(3, danusan, 10).
food_rate(4, geprek, 50).
food_rate(5, uncle_bro, 20).

/* drink thirst rate */
drink_rate(1, aqua, 20).
drink_rate(2, go_milk, 30).
drink_rate(3, thai_tea, 40).
drink_rate(4, chocolate_changer, 25).
drink_rate(5, coffee, 50).

/* medicine heal rate */
medicine_rate(1, uts_100, 50).
medicine_rate(2, kuis_100, 10).
medicine_rate(3, angbis, 30).

/* This is the rules */
/* Initialize map with everything */

init_every_item :-
	init_all_weapon, init_all_drink, init_all_food, init_all_medicine, init_special, !.

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
	random(0, 10, X), random(0, 20, Y),
	grid(X, Y, Loc),
	Loc \== blank,
	asserta(location(X, Y, A)).

random_weapon_forge :-
	random(1, 6, N), weapon_id(N, A),
	random(7, 10, X), random(17, 20, Y),
	asserta(location(X, Y, A)).

/* Initialize map with drink */
init_all_drink :-
	init_drink(20).

init_drink(0) :- !.
init_drink(N) :- random_drink, M is N -1, init_drink(M).

random_drink :-
	repeat,
	random(1, 6, N), drink_rate(N, A, _),
	random(0, 10, X), random(0, 20, Y),
	grid(X, Y, Loc),
	Loc \== blank,
	asserta(location(X, Y, A)).

/* Initialize map with food */
init_all_food :-
	init_food(20).

init_food(0) :- !.
init_food(N) :- random_food, M is N -1, init_food(M).

random_food :-
	repeat,
	random(1, 6, N), food_rate(N, A, _),
	random(0, 10, X), random(0, 20, Y),
	grid(X, Y, Loc),
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
	random(0, 10, X), random(0, 20, Y),
	grid(X, Y, Loc),
	Loc \== blank,
	asserta(location(X, Y, A)).

/* Initialize map with one radar */
init_special :-
	random_special(radar), random_special(foto_odi), random_special(foto_fahmi), !.

random_special(Special) :-
	repeat,
	random(0, 10, X), random(0, 20, Y),
	grid(X, Y, Loc),
	Loc \== blank,
	asserta(location(X, Y, Special)).
