/*print map*/
print_map(0,10):- !.
print_map(9,Y):-
    Y2 is Y+1, print_format(9,Y), nl,
    print_map(0,Y2),!.
/* print_map(X,Y):-
    Y = -1,X2 is X+1 ,print_border,!,
    print_map(X2,Y).
print_map(X,Y):-
    Y = 10,X2 is X+1, print_border,!,
    print_map(X2,Y).
print_map(X,Y):-
    X = -1,X2 is X+1, print_border,!,
    print_map(X2,Y).
print_map(X,Y):-
    X=10,X2 is X+1, print_border,!,
    print_map(X2,Y). */
print_map(X,Y):-
    X2 is X+1, print_format(X,Y),!,
    print_map(X2,Y).

/*print format*/
print_format(X,Y):-
    player(X,Y,_,_,_,_,_),
    print_player.
print_format(X,Y) :-
    grid(X,Y,_,Z),
    Z = deadzone,
    print_deadzone.
print_format(X,Y):-
    grid(X,Y,_,Z),
    Z \== deadzone,
    enemy(_,X,Y,_,_),
    print_enemy.
print_format(X,Y):-
    grid(X,Y,_,Z),
    Z \== deadzone,
    location(X,Y,Item),
    weapon_id(_,Item),
    print_weapon.
print_format(X,Y):-
    grid(X,Y,_,Z),
    Z \== deadzone,
    location(X,Y,Item),
    type_item(medicine,Item),
    print_medicine.
print_format(X,Y):-
    grid(X,Y,_,Z),
    Z \== deadzone,
    location(X,Y,Item),
    type_item(ammo,Item),
    print_ammo.
print_format(X,Y):-
    grid(X,Y,_,Z),
    Z \== deadzone,
    location(X,Y,Item),
    type_item(armor,Item),
    print_armor.
/* print_format(X,_):-
    grid(X,_,_,Z),
    X < 0,
    print_border.
print_format(X,_):-
    grid(X,_,_,Z),
    X > 9,
    print_border.
print_format(_,Y):-
    grid(_,Y,_,Z),
    Y < 0,
    print_border.
print_format(_,Y):-
    grid(_,Y,_,Z),
    Y > 9,
    print_border. */
print_format(X,Y):-
  grid(X,Y,_,Z),
  Z = blank,
  print_inaccessible.
print_format(_,_):- print_accessible.

/* Print logo in the game */
print_logo :-
  nl,
  write('___________            __      .___             '), nl,
  write('\\_   _____/___________/  |_  __| _/____  ___.__.'), nl,
  write(' |    __)/  _ \\_  __ \\   __\\/ __ |\\__  \\<   |  |'), nl,
  write(' |     \\(  <_> )  | \\/|  | / /_/ | / __ \\\\___  |'), nl,
  write(' \\___  / \\____/|__|   |__| \\____ |(____  / ____|'), nl,
  write('     \\/                         \\/     \\/\\/     '), nl.

/* Print welcome_info */
welcome_info :-
  print_logo, nl,
  write('Welcome to Fortday!'), nl,
  write('You have been sent to a giant battlefield by Tayo, the battle bus.'), nl,
  write('Be the last one standing and you will be declared the winner. '), nl,
  print_start_help,
  print_legend,
  nl.

/* Print available commend before start */
print_start_help :-
  write('---------------------------AVAILABLE COMMANDS---------------------------'),nl,
  nl,
  write('-- start.                  | '),write('Start the game. '),nl,
  print_command_list.

  /* Print available commands if player inputs help */
  print_help :-
      nl, write('---------------------------AVAILABLE COMMANDS---------------------------'),nl,
      nl,
      print_command_list.

/* List of available commands after start */
print_command_list :-
  write('-- help.                   | '), write('Show available commands.'),nl,
  write('-- quit.                   | '), write('Quit the game.'),nl,
  write('-- look.                   | '), write('Look around you.'),nl,
  write('-- n.                      | '), write('Move north.'),nl,
  write('-- s.                      | '), write('Move south.'),nl,
  write('-- e.                      | '), write('Move east.'),nl,
  write('-- w.                      | '), write('Move west.'),nl,
  write('-- map.                    | '), write('Look at the map and detect enemies.'),nl,
  write('-- take(Object).           | '), write('Pick up an object.'),nl,
  write('-- drop(Object).           | '), write('Drop an object from the inventory.'),nl,
  write('-- use(Object).            | '), write('Use an object from the inventory.'),nl,
  write('-- attack.                 | '), write('Attack the enemy that crosses your path.'),nl,
  write('-- status.                 | '), write('Show your status.'),nl,
  write('-- save(Filename).         | '), write('Save the game with the given file name.'),nl,
  write('-- load(Filename).         | '), write('Load the game from the given file name.'),nl.

  /* Print legends in the game */
  print_legend :-
      nl, write('---------LEGENDS---------'),nl, nl,
      print_weapon, write(' : Weapon'),nl,
      print_armor, write(' : Armor'),nl,
      print_medicine, write(' : Medicine'),nl,
      print_ammo, write(' : Ammo'),nl,
      print_player, write(' : Player'),nl,
      print_enemy, write(' : Enemy'),nl,
      print_accessible, write(' : Accessible'),nl,
      print_inaccessible, write(' : Inaccessible'), nl.

/* Print map elements in the game*/
print_border:- write('~~~~~').
print_deadzone:- write('  D  ').
print_weapon:- write('  W  ').
print_armor:- write('  A  ').
print_medicine:- write('  M  ').
print_ammo:- write('  O  ').
print_player:- write('  P  ').
print_enemy:- write('  E  ').
print_accessible:- write('  -  ').
print_inaccessible:- write('  X  ').

/* print status of the user */
print_status :-
    get_health(Health),
    get_armor(Armor),
    get_weapon(Weapon),
    get_position(X,Y),
    get_item_list(Items), nl,
    write('Health     : '), write(Health), nl,
    write('Armor     : '), write(Armor), nl,
    write('Weapon     : '), write(Weapon), weapon_atk(Weapon,AP), format(' | ~w AP',[AP]), nl,
    write('Position   : '), format('(~d,~d) ',[X,Y]), nl,
    nl,
    write('Items'),nl,
    write(Items).

  /* print current player location */
    print_player_nearby :-
        get_position(X,Y), print_player_loc(X,Y), !.

    print_player_loc(X,Y) :-
        check_enemy_nearby,
        grid(X, Y,_, Loc), nl,
        print_loc(Loc), write('You have spotted the enemy'), nl, !.
    print_player_loc(X,Y) :-
        grid(X,Y,_,Loc), nl,
        print_loc(Loc), !.

/* Locations in the game */
    print_loc(pleasure_park):-
      write('You are in Pleasure Park!'), nl, !.
    print_loc(jester_junkyard):-
      write('You are in Jester Junkyard!'), nl, !.
    print_loc(misty_mire):-
      write('You are in Misty Mire!'), nl, !.
    print_loc(rusty_retail):-
      write('You are in Rusty Retail!'), nl, !.
    print_loc(gunners_grove):-
      write('You are in Gunners Grove!'), nl, !.
    print_loc(freaky_forest):-
      write('You are in Freaky Forest!'), nl, !.
    print_loc(anarchy_arcade):-
      write('You are in Anarchy Arcade!'), nl, !.
    print_loc(lucky_lake):-
      write('You are in Lucky Lake!'), nl, !.
    print_loc(twisted_towers):-
      write('You are in Twisted Towers!'), nl, !.


/* Print Items in current location */
  print_items_loc(X, Y) :-
    location(X, Y, _),
    print_item_loc(X, Y), !.
  print_items_loc(_, _) :-
    write('There are no items here!'), nl.

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
        format('You see an empty weapon,  ~w, lying on the path', [Item]),!.
    print_type_item(medicine, Item) :-
        format('You see a medicine, ~w, lying on the path', [Item]), !.
    print_type_item(armor, Item) :-
        format('You see something that can increase your armor, ~w, lying on the path', [Item]), !.
    print_type_item(ammo, Item) :-
        format('You see a type of ammo, ~w, lying on the path', [Item]), !.

/* print nearby location */
  print_north(X,Y) :-
    grid(X,Y,_,Loc), print_nearby_loc(north, Loc).
  print_south(X,Y) :-
    grid(X,Y,_,Loc), print_nearby_loc(south, Loc).
  print_east(X,Y) :-
    grid(X,Y,_,Loc), print_nearby_loc(east, Loc).
  print_west(X,Y) :-
    grid(X,Y,_,Loc), print_nearby_loc(west, Loc).

print_nearby_loc(Direction, pleasure_park) :-
  format('In the ~w, you see Pleasure Park!', [Direction]), nl, !.
print_nearby_loc(Direction, twisted_towers) :-
  format('In the ~w, you see Twisted Towers!', [Direction]), nl, !.
print_nearby_loc(Direction, deadzone) :-
  format('In the ~w, you see the Deadzone!', [Direction]), nl, !.
print_nearby_loc(Direction, jester_junkyard) :-
  format('In the ~w, you see Jester Junkyard!', [Direction]), nl, !.
print_nearby_loc(Direction, misty_mire) :-
  format('In the ~w, you see Misty Mire!', [Direction]), nl, !.
print_nearby_loc(Direction, rusty_retail) :-
  format('In the ~w, you see Rusty Retail!', [Direction]), nl, !.
print_nearby_loc(Direction, gunners_grove) :-
  format('In the ~w, you see Gunners Grove!', [Direction]), nl, !.
print_nearby_loc(Direction, freaky_forest) :-
  format('In the ~w, you see Freaky Forest!', [Direction]), nl, !.
print_nearby_loc(Direction, anarchy_arcade) :-
  format('In the ~w, you see Anarchy Arcade!', [Direction]), nl, !.
print_nearby_loc(Direction, lucky_lake) :-
  format('In the ~w, you see Lucky Lake!', [Direction]), nl, !.

/* Deadzone size */
print_deadzone_increase :-
  write('The deadzone area has been increased'), nl, !.

/* Location Effect */
print_deadzone_effect :-
  write('You are in the deadzone! Your health is decreased!'), nl, !.

/* print movement */
print_move_north :-
    nl, write('You have moved north'), nl.

print_move_south :-
    nl, write('You have moved south.'), nl.

print_move_east :-
    nl, write('You have moved east.'), nl.

print_move_west :-
    nl, write('You have moved west.'), nl.

/* print fail attack */
  fail_attack :-
    nl, write('There\'s no enemy in your sight !'), nl.

/* print fail move */
  fail_move :-
    nl, write('You can\'t move!'), nl.

/* print for player */
print_increase_health(Object, Rate) :-
  nl, format('You have used ~w!', [Object]), format('Your Health is increased by ~w!', [Rate]), nl,
  player(_,_,Health,_,_,_,_), format('Your Health is now ~w', [Health]), nl.

print_decrease_health(Amount) :-
    format('You took ~w damage from your enemy!', [Amount]), nl,
    player(_,_,Health,_,_,_,_), format('Your Health is now ~w!', [Health]), nl.

print_inflict_damage(Amount):-
    format('You have inflicted ~w damage to the enemy!', [Amount]),nl.

print_increase_armor(Object, Rate) :-
    nl, format('You have used ~w! ', [Object]), format('Your Armor is increased by ~w!', [Rate]), nl,
    player(_,_,_,_,Armor,_,_), format('Your Armor is now ~w', [Armor]), nl.

print_increase_ammo(Object, Rate) :-
    nl, format('You have used ~w! ', [Object]), format('Your Ammo is increased by ~w!', [Rate]), nl,
    player(_,_,_,Ammo,_,_,_), format('Your Ammo is now ~w', [Ammo]), nl.

/* print for enemy */
print_fail_kill :-
    write('The enemy still survives!'), nl.

print_enemy_kill :-
    write('You have killed the enemy!'), nl.

print_drop_item :-
    write('The enemy dropped an item!'),nl.
