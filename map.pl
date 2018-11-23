/* This is the map for the game*/
grid(X,Y,Z,Building) :- deadzonesize(Z), X <= Z, Y <= Z, Building = deadzone, !.
grid(X,Y,Z,Building) :- deadzonesize(Z), X >= 9-Z, Y >= 9-Z, Building = deadzone, widen_deadzone(X,Y,Z,_), !.
grid(X, Y, _, Building) :- X >= 0, X =< 2, Y >= 0, Y =< 2, Building = pleasure_park, !.
grid(X, Y, _, Building) :- X >= 3, X =< 5, Y >= 0, Y =< 2, Building = jester_junkyard, !.
grid(X, Y, _, Building) :- X >= 6, X =< 9, Y >= 0, Y =< 2, Building = misty_mire, !.
grid(X, Y, _, Building) :- X >= 0, X =< 2, Y >= 3, Y =< 6, Building = rusty_retail, !.
grid(X, Y, _, Building) :- X >= 3, X =< 6, Y >= 3, Y =< 6, Building = gunners_grove, !.
grid(X, Y, _, Building) :- X >= 7, X =< 9, Y >= 3, Y =< 5, Building = freaky_forest, !.
grid(X, Y, _, Building) :- X >= 0, X =< 3, Y >= 7, Y =< 9, Building = anarchy_arcade, !.
grid(X, Y, _, Building) :- X >= 4, X =< 5, Y >= 7, Y =< 9, Building = lucky_lake, !.
grid(X, Y, _, Building) :- X >= 6, X =< 9, Y >= 6, Y =< 9, Building = twisted_towers, !.

/* Location effect */
effect_location :-
    get_position(X,Y),
    grid(X,Y,_,deadzone),
    decrease_health(100),
    print_deadzone_effect.

effect_location:-!.

/* Deadzone */

:- dynamic(steps/1).
:- dynamic(deadzonesize/1).

widen_deadzone(_,_,4,_) :- fail, !.
widen_deadzone(_,_,Z,X) :- steps(X), deadzonesize(Z), X =\= 0 , X mod 5 =:= 0, increment_deadzone, !.
widen_deadzone(_,_,_,X) :- steps(X), X is 0, fail, !.
widen_deadzone(_,_,_,X) :- steps(X), X mod 5 =\= 0, fail, !.

initialize_steps :- asserta(steps(0)).
initialize_deadzone :- asserta(deadzonesize(-1)).

increment_deadzone :- deadzonesize(X), Z is X + 1, asserta(deadzonesize(Z)).
increment_steps :- steps(X), Z is X + 1, asserta(steps(Z)).
