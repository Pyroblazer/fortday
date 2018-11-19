:- dynamic(player/6).

/* The default of the status after start */
default_health(100).
default_armor(65).
%default_currentweapon(hand,0).
default_maxinventories(50).
default_inventorieslist([]).

random_location(X, Y) :-
    repeat,
    random(1, 11, A), random(1, 21, B),
    X is A, Y is B.

init_player:-
    default_health(Health),
    default_armor(Armor),
    default_maxinventories(MaxInventories),
    default_inventorieslist(InventoriesList),
    random_location(X,Y),
    asserta(player(X,Y,Health,Armor,MaxInventories,InventoriesList)), !.

% Health
increase_health(Delta):-
    player(X,Y,Health,Armor,MaxInventories,InventoriesList),
    Result is Health+Delta,
    Result > 150,
    retract(player(X,Y,Health,Armor,MaxInventories,InventoriesList)),
    asserta(player(X,Y,150,Armor,MaxInventories,InventoriesList)).
increase_health(Delta):-
    player(X,Y,Health,Armor,MaxInventories,InventoriesList),
    Result is Health+Delta,
    retract(player(X,Y,Health,Armor,MaxInventories,InventoriesList)),
    asserta(player(X,Y,Result,Armor,MaxInventories,InventoriesList)).

decrease_health(Delta):-
    retract(player(X,Y,Health,Armor,MaxInventories,InventoriesList)),
    Result is Health-Delta,
    asserta(player(X,Y,Result,Armor,MaxInventories,InventoriesList)).

get_health(Health):-
    player(_,_,Health,_,_,_).

% Armor
increase_armor(Delta):-
    player(X,Y,Health,Armor,MaxInventories,InventoriesList),
    Result is Armor+Delta,
    Result > 100,
    retract(player(X,Y,Health,Armor,MaxInventories,InventoriesList)),
    asserta(player(X,Y,Health,100,MaxInventories,InventoriesList)), !.
increase_armor(Delta):-
    player(X,Y,Health,Armor,MaxInventories,InventoriesList),
    Result is Armor+Delta,
    retract(player(X,Y,Health,Armor,MaxInventories,InventoriesList)),
    asserta(player(X,Y,Health,Result,MaxInventories,InventoriesList)).

decrease_armor(Delta):-
    retract(player(X,Y,Health,Armor,MaxInventories,InventoriesList)),
    Result is Hunger-Delta,
    asserta(player(X,Y,Health,Result,MaxInventories,InventoriesList)).

get_armor(Armor):-
    player(_,_,_,Armor,_,_).
