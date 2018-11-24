:- dynamic(player/7).

/* The default of the status after start */
default_health(100).
default_hunger(50).
default_thirst(50).
default_weapon(osjur).
default_item_list([radar, nasi_korea, aqua, uts_100]).

random_location(X, Y) :-
    repeat,
    random(1, 11, A), random(1, 21, B),
    grid(A, B, Loc),
    Loc \== blank,
    X is A, Y is B.

init_player:-
    default_health(Health),
    default_hunger(Hunger),
    default_thirst(Thirst),
    default_weapon(Weapon),
    default_item_list(ItemList),
    random_location(X,Y),
    % FYI, assert buat masukin ke database
    asserta(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)), !.

% Health
increase_health(Amount):-
    player(X,Y,Health,Hunger,Thirst,Weapon,ItemList),
    ResultHealth is Health+Amount,
    ResultHealth > 150,
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,150,Hunger,Thirst,Weapon,ItemList)).
increase_health(Amount):-
    player(X,Y,Health,Hunger,Thirst,Weapon,ItemList),
    ResultHealth is Health+Amount,
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,ResultHealth,Hunger,Thirst,Weapon,ItemList)).

decrease_health(Amount):-
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    ResultHealth is Health-Amount,
    asserta(player(X,Y,ResultHealth,Hunger,Thirst,Weapon,ItemList)).

get_health(Health):-
    player(_,_,Health,_,_,_,_).

% Hunger
increase_hunger(Amount):-
    player(X,Y,Health,Hunger,Thirst,Weapon,ItemList),
    ResultHunger is Hunger+Amount,
    ResultHunger > 100,
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,Health,100,Thirst,Weapon,ItemList)), !.
increase_hunger(Amount):-
    player(X,Y,Health,Hunger,Thirst,Weapon,ItemList),
    ResultHunger is Hunger+Amount,
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,Health,ResultHunger,Thirst,Weapon,ItemList)).

decrease_hunger(Amount):-
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    ResultHunger is Hunger-Amount,
    asserta(player(X,Y,Health,ResultHunger,Thirst,Weapon,ItemList)).

get_hunger(Hunger):-
    player(_,_,_,Hunger,_,_,_).

% Thirst
increase_thirst(Amount):-
    player(X,Y,Health,Hunger,Thirst,Weapon,ItemList),
    ResultThirst is Thirst+Amount,
    ResultThirst > 100,
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,Health,Hunger,100,Weapon,ItemList)), !.
increase_thirst(Amount):-
    player(X,Y,Health,Hunger,Thirst,Weapon,ItemList),
    ResultThirst is Thirst+Amount,
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,Health,Hunger,ResultThirst,Weapon,ItemList)).

decrease_thirst(Amount):-
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    ResultThirst is Thirst-Amount,
    asserta(player(X,Y,Health,Hunger,ResultThirst,Weapon,ItemList)).

get_thirst(Thirst):-
    player(_,_,_,_,Thirst,_,_).

% Weapon
set_weapon(Weapon):-
    retract(player(X,Y,Health,Hunger,Thirst,CurrentWeapon,ItemList)),
    asserta(location(X, Y, CurrentWeapon)),
    asserta(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)).

get_weapon(Weapon):-
    player(_,_,_,_,_,Weapon,_).

% Item List
add_item(Item):-
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    append([Item],ItemList,NewItemList),
    asserta(player(X,Y,Health,Hunger,Thirst,Weapon,NewItemList)).

del_item(Item):-
    retract(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    delete_one(Item,ItemList,NewItemList),
    asserta(player(X,Y,Health,Hunger,Thirst,Weapon,NewItemList)).

/* Command for delete one item */
delete_one(_, [], []).
delete_one(Term, [Term|Tail], Tail) :- !.
delete_one(Term, [Head|Tail], [Head|Result]) :-
    delete_one(Term, Tail, Result).

/* Get the list of item */
get_item_list(ItemList):-
    player(_,_,_,_,_,_,ItemList).

% Position
get_position(X,Y):-
    player(X,Y,_,_,_,_,_).

set_position(X,Y):-
    retract(player(CurrentX,CurrentY,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,Health,Hunger,Thirst,Weapon,NewItemList)).

step_up:-
    player(X,CurrentY,Health,Hunger,Thirst,Weapon,ItemList),
    CurrentY > 0,
    Y is CurrentY-1,
    grid(X, Y, Loc), Loc \== blank,
    retract(player(X,CurrentY,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)).

step_down:-
    player(X,CurrentY,Health,Hunger,Thirst,Weapon,ItemList),
    CurrentY < 19,
    Y is CurrentY+1,
    grid(X, Y, Loc), Loc \== blank,
    retract(player(X,CurrentY,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)).

step_left:-
    player(CurrentX,Y,Health,Hunger,Thirst,Weapon,ItemList),
    CurrentX > 0,
    X is CurrentX-1,
    grid(X, Y, Loc), Loc \== blank,
    retract(player(CurrentX,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)).

step_right:-
    player(CurrentX,Y,Health,Hunger,Thirst,Weapon,ItemList),
    CurrentX < 9,
    X is CurrentX+1,
    grid(X, Y, Loc), Loc \== blank,
    retract(player(CurrentX,Y,Health,Hunger,Thirst,Weapon,ItemList)),
    asserta(player(X,Y,Health,Hunger,Thirst,Weapon,ItemList)).
