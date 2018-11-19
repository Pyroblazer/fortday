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
  write('You have been sent to a giant battlefield by a battle bus.'), nl,
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
  write('-- load(Filename).         | '), write('Load the game from the given file name.'),nl,

  /* Print legends in the game */
  print_legend :-
      nl, write('---------LEGENDS---------'),nl, nl,
      print_weapon, write(' : Weapon'),nl,
      print_armor, write(' : Armor'),nl, //water -> armor
      print_medicine, write(' : Medicine'),nl,
      print_ammor, write(' : Ammo'),nl, //food -> ammo
      print_player, write(' : Player'),nl,
      print_enemy, write(' : Enemy'),nl,
      print_accessible, write(' : Accessible'),nl,
      print_inaccessible, write(' : Inaccessible'), nl.

/* Print map elements in the game*/
print_deadzone:- write('D').
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
    get_armor(armor),
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

/* Locations in the game */
    print_loc(pleasure_park):-
      write('You are in Pleasure Park!'), nl, !.
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
    print_type_armor(armor, Item) :-
        format('You see something that can increase your armor, ~w, lying on the path', [Item]), !.
    print_type_ammor(ammo, Item) :-
        format('You see an ammo magazine lying on the path'), !.

/* print nearby location */
  print_north(X,Y) :-
    grid(X,Y,Loc), print_nearby_loc(north, Loc).
  print_south(X,Y) :-
    grid(X,Y,Loc), print_nearby_loc(south, Loc).
  print_east(X,Y) :-
    grid(X,Y,Loc), print_nearby_loc(east, Loc).
  print_west(X,Y) :-
    grid(X,Y,Loc), print_nearby_loc(west, Loc).

print_nearby_loc(pleasure_park)
  format('In the ~w, you see Pleasure Park!', [Direction]), nl, !.
print_nearby_loc(twisted_towers)
  format('In the ~w, you see Twisted Towers!'), [Direction]), nl, !.
