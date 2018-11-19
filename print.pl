/*print map*/
print_map(11,20):- !.
print_map(11,Y):-
    Y2 is Y+1,nl,
    print_map(-1,Y2),!.
print_map(X,Y):-
    Y= -1, X2 is X+1 ,print_border,!,
    print_map(X2,Y).
print_map(X,Y):-
    Y=20,X2 is X+1, print_border,!,
    print_map(X2,Y).
print_map(X,Y):-
    X= -1,X2 is X+1, print_border,!,
    print_map(X2,Y).
print_map(X,Y):-
    X=10,X2 is X+1, print_border,!,
    print_map(X2,Y).
print_map(X,Y):-
    X2 is X+1, print_format(X,Y),!,
    print_map(X2,Y).

/*print format*/
print_format(X,Y):-
    player(X,Y,_,_,_,_,_),
    print_player.
print_format(X,Y):-
    enemy(_,X,Y,_,_),
    print_enemy.
print_format(X,Y):-
    location(X,Y,Item),
    type_item(special,Item),
    print_radar.
print_format(X,Y):-
    location(X,Y,Item),
    weapon_id(_,Item),
    print_weapon.
print_format(X,Y):-
    location(X,Y,Item),
    type_item(medicine,Item),
    print_medicine.
print_format(X,Y):-
    location(X,Y,Item),
    type_item(food,Item),
    print_food.
print_format(X,Y):-
    location(X,Y,Item),
    type_item(drink,Item),
    print_water.
print_format(X,_):-
    X < 0,
    print_border.
print_format(X,_):-
    X > 9,
    print_border.
print_format(_,Y):-
    Y < 0,
    print_border.
print_format(_,Y):-
    Y > 19,
    print_border.
print_format(X,Y):-
  grid(X,Y,Z),
  Z = blank,
  print_inaccessible.
print_format(_,_):-print_accessible.

print_logo :-
    nl,
    write('_____oooo_oooooooo_ooooooo___oo____________oo____oo________________________________________________oooo_______________________________________'), nl,
    write('______oo_____oo____oo____oo__oo__oooo______oo____oo_oo____o_oo_ooo___oooo____ooooo__oo_ooo_______oo____oo__ooooo__oo_oo_oo___ooooo___oooo_____'), nl,
    write('______oo_____oo____oooooooo_oo__oo___o_____oo____oo_oo____o_ooo___o_oo__oo__oo____o_ooo___o_____oo________oo___oo_ooo_oo__o_oo____o_oo___o____'), nl,
    write('______oo_____oo____oo____oo_______oo_______oooooooo_oo____o_oo____o_oo___o__ooooooo_oo__________oo____ooo_oo___oo_oo__oo__o_ooooooo___oo______'), nl,
    write('______oo_____oo____oo____oo_____o___oo_____oo____oo_ooo___o_oo____o__oooooo_oo______oo___________oo____oo_oo___oo_oo__oo__o_oo______o___oo____'), nl,
    write('_____oooo____oo____ooooooo_______oooo______oo____oo_oo_ooo__oo____o_o____oo__ooooo__oo_____________oooo____oooo_o_oo______o__ooooo___oooo_____'), nl,
    write('_____________________________________________________________________ooooo____________________________________________________________________'), nl.

welcome_info :-
    print_logo, nl,
    write('                                                Welcome to the ITB\'s Hunger Games!!'), nl,
    write('                                            You have been chosen as our students here... '), nl,
    write('                         So.. Please gradute from here with your best shot and try not to dropout from here~\n'), nl,
    print_start_help,
    print_legend,
    nl.

/* This is for the command list for the start */
print_start_help :-
    write('---------------------------AVAILABLE COMMANDS---------------------------'),nl,
    nl,
    write('-- start.                  | '),write('Start the game. '),nl,
    print_command_list.

/* This is for the command list when user input help */
print_help :-
    nl, write('--------------------------------COMMAND LIST--------------------------------'),nl,
    nl,
    print_command_list.

/* All the commands avaliable right now */
print_command_list :-
    write('-- help.                   | '), write('Show available commands.'),nl,
    write('-- quit.                   | '), write('Quit the game.'),nl,
    write('-- look.                   | '), write('Look around you.'),nl,
    write('-- n.                      | '), write('Move north.'),nl,
    write('-- s.                      | '), write('Move south.'),nl,
    write('-- e.                      | '), write('Move east.'),nl,
    write('-- w.                      | '), write('Move west.'),nl,
    write('-- map.                    | '), write('Look at the map (needs RADAR).'),nl,
    write('-- take(Object).           | '), write('Pick up an object.'),nl,
    write('-- drop(Object).           | '), write('Drop an object from the inventory.'),nl,
    write('-- use(Object).            | '), write('Use an object from the inventory.'),nl,
    write('-- attack.                 | '), write('Attack enemy.'),nl,
    write('-- status.                 | '), write('Show your status.'),nl,
    write('-- save.                   | '), write('Save the game with the given file name.'),nl,
    write('-- load.                   | '), write('Load the game from the given file name.'),nl,
    write('-- tugas_besar.            | '), write('It\'s your magic.'), nl.

/* this is to print legend in game */
print_legend :-
    nl, write('---------LEGENDS---------'),nl, nl,
    print_medicine, write(' : Medicine'),nl,
    print_food, write(' : Food'),nl,
    print_water, write(' : Water'),nl,
    print_weapon, write(' : Weapon'),nl,
    print_player, write(' : Player'),nl,
    print_enemy, write(' : Enemy'),nl,
    print_accessible, write(' : Accessible'),nl,
    print_inaccessible, write(' : Inaccessible'), nl.

/*print map elements*/
print_border:- write('~~~~~').
print_medicine:- write('  M  ').
print_food:- write('  F  ').
print_water:- write('  W  ').
print_weapon:- write('  #  ').
print_player:- write('  P  ').
print_radar:- write('  R  ').
print_enemy:- write('  E  ').
print_accessible:- write('  -  ').
print_inaccessible:- write('XXXXX').

/* print status of the user */
print_status :-
    get_health(Health),
    get_hunger(Hunger),
    get_thirst(Thirst),
    get_weapon(Weapon),
    get_position(X,Y),
    get_item_list(Items), nl,
    write('Health     : '), write(Health), nl,
    write('Hunger     : '), write(Hunger), nl,
    write('Thirst     : '), write(Thirst), nl,
    write('Weapon     : '), write(Weapon), weapon_atk(Weapon,AP), format(' | ~w AP',[AP]), nl,
    write('Position   : '), format('(~d,~d) ',[X,Y]), nl,
    nl,
    write('Items'),nl,
    write(Items).

/* print location player right now */
print_player_nearby :-
    get_position(X,Y), print_player_loc(X,Y), !.

print_player_loc(X,Y) :-
    check_enemy_nearby,
    grid(X, Y, Loc), nl,
    print_loc(Loc), write('You also sense that there\'s enemy nearby..'), nl, !.
print_player_loc(X,Y) :-
    grid(X,Y,Loc), nl,
    print_loc(Loc), !.

print_loc(kantin_borju):-
    write('You are in Kantin Borju right now.. It is such a good place to eat but more expensive thant the others..'), nl, !.
print_loc(kandom) :-
    write('You are in Kandang Domba.. This place is very dangerous.. It is used to agitate AngMud :('), nl, !.
print_loc(intel) :-
    write('You are in Indonesia Tenggelam... It is very ferocious place.. You see flood everywhere...'), nl, !.
print_loc(ruang_rektor) :-
    write('You are in Ruang Rektor... Dude what have you done?'), nl, !.
print_loc(labtek_v) :-
    write('You are in Labtek V... This is your building for 3 years in ITB..'), nl, !.
print_loc(ruang_ujian) :-
    write('You are in Test Room right now.. Don\'t try to cheat~'), nl, !.
print_loc(sadikin) :-
    write('Tadaaa! You are in Sadikin! It is said to be the heaven for ITB student (who don\'t have money)~'), nl, !.
print_loc(perpustakaan) :-
    write('You are in library... Why are you so ambis?'), nl, !.
print_loc(sacred_path) :-
    write('You are in Sacred Path.. Do you know where this path is going to?'), nl,
    write('As you walk, you see something in the wall, You must pray to God... sem09A_M4pr3s'), nl, !.
print_loc(secret_path) :-
    write('Secret Path??? For what actually... (Really this is not the easter eggs!)'), nl,
    write('Wait... you see something.... You see the code : aku_g4_b4s49'), nl, !.

/* print items in your location right now */
print_items_loc(X, Y) :-
    location(X, Y, _),
    print_item_loc(X, Y), !.
print_items_loc(_, _) :-
    write('In your place right now... You can\'t find any items.. Sad..'), nl.

print_item_loc(X, Y) :-
    location(X, Y, Item),
    print_item(Item), nl,
    fail.
print_item_loc(_, _) :- !.

print_item(Item) :-
    type_item(Type, Item), print_type_item(Type, Item),!.
print_item(Item) :-
    print_item_weapon(Item), !.

print_item_weapon(Item) :-
    format('In the ground, you see the weapon.. You see the codename is ~w', [Item]),!.
print_type_item(food, Item) :-
    format('In the ground, you see the food.. You see the codename is ~w', [Item]), !.
print_type_item(drink, Item) :-
    format('In the ground, you see the drink.. You see the codename is ~w', [Item]), !.
print_type_item(medicine, Item) :-
    format('In the ground, you see the medicine. You see the codename is ~w', [Item]), !.
print_type_item(special, Item) :-
    format('In the ground, you see special item. You see the codename is ~w. How lucky of you!', [Item]), !.
print_type_item(special_eggs, Item) :-
    format('In the ground, you see photo. You see the codename is ~w. What is that?', [Item]).

/* print nearby location */
print_north(X,Y) :-
    grid(X,Y,Loc), print_nearby_loc(north, Loc).
print_south(X,Y) :-
    grid(X,Y,Loc), print_nearby_loc(south, Loc).
print_east(X,Y) :-
    grid(X,Y,Loc), print_nearby_loc(east, Loc).
print_west(X,Y) :-
    grid(X,Y,Loc), print_nearby_loc(west, Loc).

print_nearby_loc(Direction, kantin_borju):-
    format('In the ~w, you see Kantin Borju', [Direction]), nl, !.
print_nearby_loc(Direction, kandom):-
    format('In the ~w, you see Kandang Domba', [Direction]), nl, !.
print_nearby_loc(Direction, intel):-
    format('In the ~w, you see Indonesia Tenggelam', [Direction]), nl, !.
print_nearby_loc(Direction, ruang_rektor):-
    format('In the ~w, you see Ruang Rektor', [Direction]), nl, !.
print_nearby_loc(Direction, labtek_v):-
    format('In the ~w, you see Labtek V', [Direction]), nl, !.
print_nearby_loc(Direction, ruang_ujian):-
    format('In the ~w, you see Test Room', [Direction]), nl, !.
print_nearby_loc(Direction, sadikin):-
    format('In the ~w, you see Sadikin', [Direction]), nl, !.
print_nearby_loc(Direction, perpustakaan):-
    format('In the ~w, you see Library', [Direction]), nl, !.
print_nearby_loc(Direction, sacred_path):-
    format('In the ~w, you see something...', [Direction]), nl, !.
print_nearby_loc(Direction, secret_path):-
    format('In the ~w, you see... Wait.. What is that place?', [Direction]), nl, !.
print_nearby_loc(Direction, blank):-
    format('In the ~w, there\'s restricted place.. You can\'t go there!', [Direction]), nl, !.

/*Location effect*/
print_sadikin_effect:-
    write('You are in the most favorable place for ITB Students! Sadikin! Your health increased.'),nl,!.

print_ruang_ujian_effect:-
    write('The pressure in Ruang Ujian is so tense.... You can\'t bear it. Your health is decreased by 2.'),nl,!.

print_kandom_effect:-
    write('You are being agitated by seniors on Kandom! Your health is decreased by 5.'),nl,!.

print_kantin_borju_effect:-
    write('Yummy! Kantin Borju increased your hunger and thirst by 2 points!'),nl,!.

print_sacred_effect:-
    write('You are in sacred place, all your status are increased drastically!'), nl, !.

print_secret_effect:-
    write('You are in secret place, all your status are healed!'), nl, !.

/* print movement */
print_move_north :-
    nl, write('From your place, you move to the north...'), nl.

print_move_south :-
    nl, write('From your place, you move to the south...'), nl.

print_move_east :-
    nl, write('From your place, you move to the east...'), nl.

print_move_west :-
    nl, write('From your place, you move to the west...'), nl.

/* print fail attack */
fail_attack :-
    nl, write('There\'s no enemy in your sight !'), nl.

/* print fail move */
fail_move :-
    nl, write('You can\'t move!'), nl.

/* print for player */
print_increase_health(Object, Rate) :-
    nl, format('As you use ~w... ', [Object]), format('You feel the power of the medicine.. Your Health is increased by ~w!', [Rate]), nl,
    player(_,_,Health,_,_,_,_), format('Your Health now is ~w', [Health]), nl.

print_increase_hunger(Object, Rate) :-
    nl, format('As you eat ~w... ', [Object]), format('You don\'t feel hungry anymore.. Your Hunger is increased by ~w!', [Rate]), nl,
    player(_,_,_,Hunger,_,_,_), format('Your Hunger now is ~w', [Hunger]), nl.

print_increase_thirst(Object, Rate) :-
    nl, format('As you drink ~w... ', [Object]), format('You don\'t feel thirsty anymore.. Your Thirst is increased by ~w!', [Rate]), nl,
    player(_,_,_,_,Thirst,_,_), format('Your Thirst now is ~w', [Thirst]), nl.

print_decrease_health(Amount) :-
    format('You took ~w damage from your enemy... Urgh it\'s hurt!', [Amount]), nl,
    player(_,_,Health,_,_,_,_), format('Your Health now is ~w', [Health]), nl.

print_inflict_damage(Amount):-
    format('You deal ~w damage to the enemy!', [Amount]),nl.

/* print for enemy */
print_fail_kill :-
    write('You failed to make him dropout from ITB.. Now he\'s trying to attack you too!'), nl.

print_enemy_kill :-
    write('You laugh hilariously as you see your enemy dropout from ITB.. How cruel of you!'), nl.

print_drop_item :-
    write('The enemy dropped an item!'),nl.
/*********** BONUS ***********/
/* print for pray */
print_good_kid :- write('Because you are a good kid, God answers your prayer... '), nl.

print_give_radar :-
    write('God gives you a Radar so you can see you map!'), nl.

print_give_ult_weapon :-
    write('God gives you a ultimate weapon (mapres) so you can kill all your enemies!'), nl.

/* print tugas besar */
print_tugas_besar :-
    write('As you call tugas besar, your health decreased by 20.. But it makes your nearby enemies dropout from ITB!'), nl.
