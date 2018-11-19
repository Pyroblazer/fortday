/* map.pl */

/* This is the map for the game*/
grid(X, Y, Building) :- X > -1, X < 2, Y > 11, Y =< 19, Building = kantin_borju, !.
grid(X, Y, Building) :- X > -1, X < 4, Y > -1, Y =< 3, Building = kandom, !.
grid(X, Y, Building) :- X >= 4, X =< 7, Y >= 0, Y =< 3, Building = intel, !.
grid(X, Y, Building) :- X >= 8, X =< 9, Y >= 0, Y =< 12, Building = ruang_rektor, !.
grid(X, Y, Building) :- X >= 0, X =< 1, Y >= 4, Y =< 11, Building = labtek_v, !.
grid(X, Y, Building) :- X >= 2, X =< 6, Y >= 7, Y =< 15, Building = ruang_ujian, !.
grid(X, Y, Building) :- X >= 3, X =< 5, Y >= 18, Y =< 19, Building = sadikin, !.
grid(X, Y, Building) :- X is 5, Y >=16, Y=< 17, Building = sadikin, !.
grid(X, Y, Building) :- X >= 7, X =< 9, Y >= 17, Y =< 19, Building = perpustakaan, !.
grid(X, Y, Building) :- X is 2, Y is 19, Building = sacred_path, !.
grid(X, Y, Building) :- X is 7, Y is 7, Building = secret_path, !.
grid(_, _, Building) :- Building = blank.

/* Location effect */
effect_location :-
    get_position(X,Y),
    grid(X,Y,sacred_path),
    increase_health(150),
    increase_hunger(100),
    increase_thirst(100),
    print_sacred_effect.

effect_location :-
    get_position(X,Y),
    grid(X,Y,secret_path),
    increase_health(150),
    increase_hunger(100),
    increase_thirst(100),
    print_secret_effect.

effect_location:-
    get_position(X,Y),
    grid(X,Y,sadikin),
    increase_health(10),
    print_sadikin_effect.

effect_location:-
    get_position(X,Y),
    grid(X,Y,ruang_ujian),
    decrease_health(2),
    print_ruang_ujian_effect.

effect_location:-
    get_position(X,Y),
    grid(X,Y,kandom),
    decrease_health(5),
    print_kandom_effect.

effect_location:-
    get_position(X,Y),
    grid(X,Y,kantin_borju),
    increase_hunger(2),
    increase_thirst(2),
    print_kantin_borju_effect.

effect_location:-!.
