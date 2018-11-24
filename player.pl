:- dynamic(player/7).

/* The default of the status after start */
default_health(100).
default_ammo(50).
default_armor(50).
default_weapon(hand).
default_item_list([]).

random_location(X, Y) :-
    repeat,
    random(1, 11, A), random(1, 11, B),
    grid(A, B, _, Loc),
    Loc \== blank,
    X is A, Y is B.

init_player:-
    default_health(Health),
    default_ammo(Ammo),
    default_armor(Armor),
    default_weapon(Weapon),
    default_item_list(ItemList),
    random_location(X,Y),
    % FYI, assert buat masukin ke database
    asserta(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)), !.

% Health
increase_health(Amount):-
    player(X,Y,Health,Ammo,Armor,Weapon,ItemList),
    ResultHealth is Health+Amount,
    ResultHealth > 150,
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,150,Ammo,Armor,Weapon,ItemList)).
increase_health(Amount):-
    player(X,Y,Health,Ammo,Armor,Weapon,ItemList),
    ResultHealth is Health+Amount,
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,ResultHealth,Ammo,Armor,Weapon,ItemList)).

decrease_health(Amount):-
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    ResultHealth is Health-Amount,
    asserta(player(X,Y,ResultHealth,Ammo,Armor,Weapon,ItemList)).

get_health(Health):-
    player(_,_,Health,_,_,_,_).

% Ammo
increase_ammo(Amount):-
    player(X,Y,Health,Ammo,Armor,Weapon,ItemList),
    ResultAmmo is Ammo+Amount,
    ResultAmmo > 100,
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,Health,100,Armor,Weapon,ItemList)), !.
increase_ammo(Amount):-
    player(X,Y,Health,Ammo,Armor,Weapon,ItemList),
    ResultAmmo is Ammo+Amount,
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,Health,ResultAmmo,Armor,Weapon,ItemList)).

decrease_ammo(Amount):-
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    ResultAmmo is Ammo-Amount,
    asserta(player(X,Y,Health,ResultAmmo,Armor,Weapon,ItemList)).

get_ammo(Ammo):-
    player(_,_,_,Ammo,_,_,_).

% Armor
increase_armor(Amount):-
    player(X,Y,Health,Ammo,Armor,Weapon,ItemList),
    ResultArmor is Armor+Amount,
    ResultArmor > 100,
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,Health,Ammo,100,Weapon,ItemList)), !.
increase_armor(Amount):-
    player(X,Y,Health,Ammo,Armor,Weapon,ItemList),
    ResultArmor is Armor+Amount,
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,Health,Ammo,ResultArmor,Weapon,ItemList)).

decrease_armor(Amount):-
    player(X,Y,Health,Ammo,Armor,Weapon,ItemList),
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    ResultArmor is Armor-Amount,
    asserta(player(X,Y,Health,Armor,ResultArmor,Weapon,ItemList)).

get_armor(Armor):-
    player(_,_,_,_,Armor,_,_).

% Weapon
set_weapon(Weapon):-
    retract(player(X,Y,Health,Ammo,Armor,CurrentWeapon,ItemList)),
    asserta(location(X, Y, CurrentWeapon)),
    asserta(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)).

get_weapon(Weapon):-
    player(_,_,_,_,_,Weapon,_).

% Item List
add_item(Item):-
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    append([Item],ItemList,NewItemList),
    asserta(player(X,Y,Health,Ammo,Armor,Weapon,NewItemList)).

del_item(Item):-
    retract(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)),
    delete_one(Item,ItemList,NewItemList),
    asserta(player(X,Y,Health,Ammo,Armor,Weapon,NewItemList)).

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
    retract(player(CurrentX,CurrentY,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,Health,Ammo,Armor,Weapon,NewItemList)).

step_up:-
    player(X,CurrentY,Health,Ammo,Armor,Weapon,ItemList),
    CurrentY > 0,
    Y is CurrentY-1,
    grid(X, Y,_, Loc), Loc \== blank,
    retract(player(X,CurrentY,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)).

step_down:-
    player(X,CurrentY,Health,Ammo,Armor,Weapon,ItemList),
    CurrentY < 19,
    Y is CurrentY+1,
    grid(X, Y,_, Loc), Loc \== blank,
    retract(player(X,CurrentY,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)).

step_left:-
    player(CurrentX,Y,Health,Ammo,Armor,Weapon,ItemList),
    CurrentX > 0,
    X is CurrentX-1,
    grid(X, Y,_, Loc), Loc \== blank,
    retract(player(CurrentX,Y,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)).

step_right:-
    player(CurrentX,Y,Health,Ammo,Armor,Weapon,ItemList),
    CurrentX < 9,
    X is CurrentX+1,
    grid(X, Y,_, Loc), Loc \== blank,
    retract(player(CurrentX,Y,Health,Ammo,Armor,Weapon,ItemList)),
    asserta(player(X,Y,Health,Ammo,Armor,Weapon,ItemList)).
