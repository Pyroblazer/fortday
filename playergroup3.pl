/* win(X) menyatakan status kemenangan */

:- use_module(library(random)).
:- dynamic(deadzone/1,isdeadzone/2,kills/1 ,win/1, player_pos/2, item/2, inarea_contain/4, ingamestate/1, bag/1, health/1, weapon/1, armor/1, enemypower/2, countstep/1, countzuko/1, countaang/1, countkatara/1).

/*Inisialisasi game
* 0 = belum mulai permainan atau udah mati, 1 = hidup atau sedang bermain
*/
ingamestate(0).

/* Deklarasi Fakta */
area(0, emptyarea).
area(1, emptyarea).
area(2, negaraapi).
area(3, negaratanah).
area(4, emptyarea).
area(5, hutan).
area(6, unknownarea).
area(7, negaraair).
enemies(azula).
enemies(rajaapi).
isweapon(zuko).
isweapon(aang).
isweapon(katara).
isammo_of(fire,zuko).
isammo_of(air,aang).
isammo_of(water,katara).
isammo(fire).
isammo(air).
isammo(water).
isarmor(appa).
isarmor(momo).
ismedicine(medicine).
ismedicine(potion).

/*locationName
* Perhitungan : x mod 5 = 0<=a<=4 , y mod 4 = 0<=b<=3,0<= a+b <=7
* Misal ->  a+b = 1 (emptyarea), ikuti fakta yang diatas
*/
locationName(X, Y, Place) :- A is X mod 5, B is Y mod 4, N is A+B, area(N, Place).

/* Game loop */
command_input   :- ingamestate(1),
			repeat,
			write('>>> '),
			read(X),
			run(X),
			(checkWinner ; X==quit), !, halt.

/* Path (from - to)*/
path(Xa,Ya,east,Xb,Yb) :- Xa < 10, Xb is Xa + 1, Yb is Ya,!.
path(Xa,Ya,west,Xb,Yb) :- Xa >= 1, Xb is Xa - 1, Yb is Ya,!.
path(Xa,Ya,north,Xb,Yb) :- Ya >= 1 , Yb is Ya - 1, Xb is Xa,!.
path(Xa,Ya,south,Xb,Yb) :- Ya < 20 , Yb is Ya + 1, Xb is Xa,!.

/* Basic rules */
checkWinner :- kills(X), X == 10, writeln('You won. hehe :)'),!,halt.
checkWinner :- win(X), X == 0, writeln('U dai...'),!.
checkWinner :- win(X), X == 1, writeln('You won. hehe :)'),!,halt.
writeifenemynearby([]) :- true,!.
writeifenemynearby(List) :- isEnemy(List), write(' careful....').
isdefined(X,Y) :- X>=0, X<11, Y>=0, Y<21.
islistkosong([]).
isEnemy([]):- fail.
isEnemy([H|T]) :- enemies(H),!.
konso(X,L,[X|L]).
writelist([]):- nl.
writelist([H|T]):- write('> '), write(H),nl,writelist(T).
writeln(X) :- write(X), nl.
isMember(X, [Y|T]) :- X=Y; isMember(X,T).
delElmt(_,[],[]).
delElmt(X,[X|Xs],Xs).
delElmt(X,[Y|Xs],[Y|Ys]) :- X\==Y, delElmt(X,Xs,Ys).
isLocation(X) :- list(location, List), isMember(X, List).
objectLoc(X, Y) :- list(Y, List), isMember(X, List).
count([],0).
count([_|Tail], N) :- count(Tail, N1), N is N1 + 1.
isEven(X) :- 0 is mod(X, 2).

/***** Implementasi run command from input *****/
run(n) :- north, nl,!.
run(e) :- east, nl,!.
run(s) :- south, nl,!.
run(w) :- west, nl,!.
run(look) :- look, nl, !. /* predikat untuk melihat posisi sekitar */
run(help) :- help, nl, !. /* predikat yang memberikan petunjuk game*/
run(quit) :- quit, nl, !. /* predikat yang menyebabkan game berakhir */
run(maps) :- maps, nl,!.
run(take(Obj)) :- take(Obj), nl, !.
run(drop(Obj)) :- drop(Obj), nl, !.
run(use(Obj)) :- use(Obj), nl, !.
run(start) :- start, nl,  !.
run(attack) :- attack, nl, !.
run(status) :- status, nl, !.
run(save(FileName)) :- save(FileName), nl, !.
run(loads(FileName)) :- loads(FileName), nl, !.



/***** Commands *****/
init_enemies :-
							random(0, 10, Xa), /* random ZOMB1 (position) */
							random(0, 20, Ya),
							random(0, 10, Xb), /* random ZOMB2 (position) */
							random(0, 20, Yb),
							retract(inarea_contain(Xa,Ya,_,Lista)),
							retract(inarea_contain(Xb,Yb,_,Listb)),
							append([rajaapi],Lista,RLista),
							append([azula],Listb,RListb),
							asserta(inarea_contain(Xa,Ya,_,RLista)),
							asserta(inarea_contain(Xb,Yb,_,RListb)).

init_dynamic_facts(X,Y) :-
									X == 11, Y >= 0, true.

init_dynamic_facts(X,Y) :-
									X < 11, Y < 20,
									locationName(X,Y,Place),
									item(Place, List),
									asserta(inarea_contain(X,Y,List,[])),
									M is X,
									N is Y + 1,
									init_dynamic_facts(M,N).

init_dynamic_facts(X,Y) :-
									X < 11, Y == 20,
									locationName(X,Y,Place),
									item(Place, List),
									asserta(inarea_contain(X,Y,List,[])),
									M is X + 1,
									N is 0,
									init_dynamic_facts(M,N).

start:- 
  write('___________            __      .___             '), nl,
  write('\\_   _____/___________/  |_  __| _/____  ___.__.'), nl,
  write(' |    __)/  _ \\_  __ \\   __\\/ __ |\\__  \\<   |  |'), nl,
  write(' |     \\(  <_> )  | \\/|  | / /_/ | / __ \\\\___  |'), nl,
  write(' \\___  / \\____/|__|   |__| \\____ |(____  / ____|'), nl,
  write('     \\/                         \\/     \\/\\/     '), nl,
  write('Welcome to Fortday!'), nl,
  write('You have been sent to a giant battlefield by Tayo, the battle bus.'), nl,
  write('Be the last one standing and you will be declared the winner. '), nl,
		help,
		restartgame,
		random(0, 10, X), /*random Alice (X position)*/
 		random(0, 20, Y), /*random Alice (Y position)*/
		asserta(player_pos(X,Y)),
		asserta(health(100)),
		asserta(win(-1)),
		asserta(countstep(0)),
		asserta(deadzone(0)),
		asserta(ingamestate(1)),
		asserta(powerzuko(20)),
		asserta(poweraang(35)),
		asserta(powerkatara(50)),
		asserta(enemyitem(rajaapi,[aang])),
		asserta(enemyitem(azula,[katara])),
		asserta(armor(10)),
		asserta(weapon([])),
		asserta(bag([zuko,fire])),
		asserta(item(negaraair,[water,air, appa])),
		asserta(item(emptyarea,[])),
		asserta(item(negaratanah,[fire, medicine])),
		asserta(item(negaraapi,[air,momo])),
		asserta(item(hutan,[appa,momo])),
		asserta(item(unknownarea,[potion,water])),
		init_dynamic_facts(0,0),
		init_enemies,
		asserta(kills(0)),
		retract(inarea_contain(X,Y,_AddRadar,_EL)),
		append([radar], _AddRadar, _AddRadar2),
		asserta(inarea_contain(X,Y,_AddRadar2,_EL)),
		retract(ingamestate(_)),
		asserta(ingamestate(1)),
		asserta(countzuko(0)),
		asserta(countaang(0)),
		asserta(countkatara(0)),
		command_input.

powerweapon(zuko,Power):- powerzuko(Power).
powerweapon(aang,Power):- poweraang(Power).
powerweapon(katara,Power):- powerkatara(Power).

enemypower(H,Power):-
	enemies(H),
	enemyitem(H,[Weapon|_]),
	powerweapon(Weapon,Power).

restartgame :-
		retract(kills(_P)),
		retract(enemypower(_YY,_TT)),
		retract(ingamestate(_A)),
		asserta(ingamestate(0)),
		retract(inarea_contain(_R,_T,_U,_V)),
		retract(player_pos(_X,_Y)),
		retract(bag(_C)),
		retract(win(_M)),
		retract(countstep(_S)),
		retract(health(_K)),
		retract(hunger(_E)),
		retract(thirsty(_F)),
		retract(weapon(_G)), !.
		restartgame.

isdeadzone(X,Y) :- deadzone(W), (X<(0+W); X>(11-W); Y<(0+W); Y>=(21-W)).

prio(X,Y) :- \+isdefined(X,Y),
							write('#'),!.
prio(X,Y) :- isdeadzone(X,Y), write('X'),!.
prio(X,Y) :- inarea_contain(X,Y,_,EList), EList \= [],
   						write('E'),!.
prio(X,Y) :-inarea_contain(X,Y,List,_) , islistkosong(List), player_pos(M,N),
							M == X, N == Y,
							write('A'),!.
prio(X,Y) :-inarea_contain(X,Y,List,_) , islistkosong(List),
							write('-'),!.
prio(X,Y) :-inarea_contain(X,Y,List,_),
						isMember(medicine,List),
						write('M'),!.
prio(X,Y) :-inarea_contain(X,Y,List,_),
							isMember(potion,List),
						write('M'),!.
prio(X,Y) :- inarea_contain(X,Y,List,_),
							isMember(zuko,List),
						write('W'),!.
prio(X,Y) :- inarea_contain(X,Y,List,_),
						isMember(katara,List),
						write('W'),!.
prio(X,Y) :- inarea_contain(X,Y,List,_),
							isMember(appa,List),
						write('R'),!.
prio(X,Y) :- inarea_contain(X,Y,List,_),
						isMember(momo,List),
						write('R'),!.
prio(X,Y) :- inarea_contain(X,Y,List,_),
						isMember(water,List),
						write('O'),!.
prio(X,Y) :- inarea_contain(X,Y,List,_),
						isMember(fire,List),
						write('O'),!.
prio(X,Y) :- inarea_contain(X,Y,List,_),
						isMember(air,List),
						write('O'),!.
prio(X,Y) :- player_pos(A,B),
						X==A,
						Y==B,
						write('A').

printmap(_,Y) :- Y == 21 , nl, player_pos(R,T), write('Current location is ('), write(R), write(',') , write(T), writeln(').'), true.

printmap(X,Y) :- X < 11, Y < 21,
						write(' '), prio(X,Y), write(' '),
						M is X+1,
						N is Y,
						printmap(M,N).
printmap(X,Y) :-
						X == 10, Y < 21,
						write(' '), prio(X,Y) , nl,
						M is 0,
						N is Y+1,
						printmap(M,N).

/* Skala prioritas penampilan peta: Enemy > Medicine > Food > Water > Weapon > Player. */
look :- ingamestate(1),
		player_pos(X, Y),
		locationName(X, Y, Place),
		inarea_contain(X,Y,List,EList),
		A is X - 1,
		B is X,
		C is X + 1,
		D is Y - 1,
		E is Y,
		F is Y + 1,
		write('  '), prio(A,D),
		write('  '), prio(B,D),
		write('  '), prio(C,D),nl,
		write('  '), prio(A,E),
		write('  '), prio(B,E),
		write('  '), prio(C,E),nl,
		write('  '), prio(A,F),
		write('  '), prio(B,F),
		write('  '), prio(C,F),nl,
		write('You are now in '), write(Place), writeifenemynearby(EList), nl,
		writeln('Items in this area is/are '), writelist(List),!.

help :- writeln('-----------------------------------------------------------------------'),
        writeln('This is a game!!'),
        writeln('-----------------------------------------------------------------------'),
        writeln('These are the available commands:'),
        writeln('- start.          = start game.'),
        writeln('- n. w. s. e.     = move'),
        writeln('- look.           = look around'),
        writeln('- help.           = see this help menu'),
        writeln('- maps.           = show map'),
        writeln('- take(Obj).      = take object'),
        writeln('- drop(Obj).      = drop object.'),
        writeln('- use(Obj)        = use object.'),
        writeln('- attack.         = attack enemy'),
        writeln('- status.         = display status'),
        writeln('- save(FileName). = save game.'),
        writeln('- loads(FileName).= load game.'),
        writeln('- quit.           = quit game.'),
        writeln('What you see...'),
        writeln('M = Medicine'),
        writeln('W = Weapon'),
        writeln('A = YOU'),
        writeln('E = Enemy'),
        writeln('X = Inaccesible'),
        writeln('- = Accesible').

maps :-	ingamestate(1),bag(ListItem), isMember(radar, ListItem),printmap(0,0),!.
maps :- ingamestate(1),bag(ListItem),\+isMember(radar,ListItem),writeln('Use radar to see full maps'),!.

desc(Obj) :- Obj == medicine,
            writeln('When a doctor is not around, medicine is all you need...'),
            writeln('Restores 5 HP').

desc(Obj) :- Obj == bandage,
            writeln('No medicine? Use potion instead.'),
            writeln('Restores 5 HP').

desc(Obj) :- Obj == fire,
            writeln('Zuko needs fire'),
            writeln('Adds 1 fire element to Zuko :)').

desc(Obj) :- Obj == water,
            writeln('Katara needs water'),
            writeln('Adds 1 water element to Katara :)').

desc(Obj) :- Obj == air,
            writeln('Aang needs air'),
            writeln('Adds 1 air element to Aang :)').

desc(Obj) :- Obj == zuko,
            writeln('The legendary fire prince, you are now ZUKO!!'),
            writeln('Fire bending is acquired!').

desc(Obj) :- Obj == katara,
            writeln('Beautiful lady from the water village deep in the glacier, you are now KATARA!!'),
            writeln('Water bending is acquired!').

desc(Obj) :- Obj == appa,
            writeln('Appa here for the rescue'),
            writeln('Adds 2 armor').

desc(Obj) :- Obj == momo,
            writeln('Momo here for the rescue'),
            writeln('Adds 2 armor').

desc(Obj) :- Obj == aang,
            writeln('Being in the ice for 1000000 years is not so nice, you are now AANG!!'),
            writeln('Air bending is acquired!').

desc(Obj) :- Obj == radar,
            writeln('See full map dongs').

/* 	Menghitung damage yang diterima saat otomatis diserang musuh
	karena berada dalam petak yang sama */
countPower([],0).
countPower([H|T],X) :- enemies(H), enemypower(H,ATK),
                        countPower(T,X1),
                        X is X1 + ATK.

isAttacked(EList) :- \+isEnemy(EList),!.

isAttacked(EList) :- isEnemy(EList),
						countPower(EList,Dmg),
						armor(Z),
						health(_HP),
						Dmg\=0,
						Factor is (100-Z)/100 *Dmg,
						_newHP is _HP - Factor,
						_newHP > 0,
						retract(health(_)),
						asserta(health(_newHP)),
						write('Enemy hits you for '),write(Factor),write(' damage.'),!,nl.

isAttacked(EList) :- isEnemy(EList),
						countPower(EList,Dmg),
						armor(Z),
						health(_HP),
						Factor is (100-Z)/100*Dmg,
						_newHP is _HP - Factor,
						_newHP < 1,
						retract(win(_)),
						asserta(win(0)),!.

/* membuat enemy bergerak random */

moverand(0,1,0).
moverand(1,0,1).
moverand(2,-1,0).
moverand(3,0,-1).
moverand(4,1,0).
moverand(5,0,1).
moverand(6,-1,0).
moverand(7,0,-1).

/* jika dikotak tidak ada enemy maka di skip */
randomEnemy(X,Y) :- inarea_contain(X,Y,_,EList),
						EList == [],
						X < 11, Y < 21,
						M is X + 1, N is Y,
						randomEnemy(M,N).

randomEnemy(X,Y) :- inarea_contain(X,Y,_,EList),
						EList == [],
						X == 10, Y < 21,
						M is 0, N is Y + 1,
						randomEnemy(M,N).

/* jika enemy berada dalam petak yang sama dengan pemain, maka tidak di random */
randomEnemy(X,Y) :- player_pos(X,Y),
						inarea_contain(X,Y,List,EList),
						X < 11, Y < 21,
						M is X + 1, N is Y,
						retract(inarea_contain(X,Y,List,EList)),
						asserta(inarea_contain(X,Y,List,EList)),
						randomEnemy(M,N).

randomEnemy(X,Y) :- player_pos(X,Y),
						inarea_contain(X,Y,List,EList),
						X == 10, Y < 21,
						M is 0, N is Y + 1,
						retract(inarea_contain(X,Y,List,EList)),
						asserta(inarea_contain(X,Y,List,EList)),
						randomEnemy(M,N).

/* RANDOM! (jika di petak ada enemy, dan tidak satu petak dengan player)*/
randomEnemy(X,Y) :- inarea_contain(X,Y,_,EList),
						EList \= [],
						X < 11, Y < 21,
						M is X + 1, N is Y,
						A is X mod 5, B is Y mod 4, N is A+B,
						moverand(N,X1,Y1),
						X2 is X1 + X, Y2 is Y1 + Y,
						X2 > -1, X2 < 11, Y2 > -1, Y2 < 21,
						inarea_contain(X2,Y2,_,EL),
						append(EList,EL,ELNew),
						retract(inarea_contain(X,Y,_,_)),
						retract(inarea_contain(X2,Y2,_,_)),
						asserta(inarea_contain(X,Y,_,[])),
						asserta(inarea_contain(X2,Y2,_,ELNew)),
						randomEnemy(M,N).

randomEnemy(X,Y) :- inarea_contain(X,Y,_ListN,EList),
						EList \= [],
						X == 10, Y < 21,
						M is 0, N is Y + 1,
						A is X mod 5, B is Y mod 4, N is A+B,
						moverand(N,X1,Y1),
						X2 is X1 + X, Y2 is Y1 + Y,
						X2 > -1, X2 < 11, Y2 > -1, Y2 < 21,
						inarea_contain(X2,Y2,_ListB,EL),
						append(EList,EL,ELNew),
						retract(inarea_contain(X,Y,_,_)),
						retract(inarea_contain(X2,Y2,_,_)),
						asserta(inarea_contain(X,Y,_ListN,[])),
						asserta(inarea_contain(X2,Y2,_ListB,ELNew)),
						randomEnemy(M,N).

randomEnemy(_,Y) :- Y == 21, nl, break,
						write('Enemy moved').

/* Take object from where you are, and put it in backpack, max item in backpack = 4 */
setcountweapon(X,Num):-
	X==zuko,!,
	retract(countzuko(_)),asserta(countzuko(Num));

	X==aang,!,
	retract(countaang(_)),asserta(countaang(Num));

	X==katara,!,
	retract(countkatara(_)),asserta(countkatara(Num));

	X==sword,!,
	retract(countsword(_)),asserta(countsword(Num)).

getcountweapon(X,Num):-
	X==zuko,!,countzuko(A),Num is A;

	X==aang,!,countaang(A),Num is A;

	X==katara,!,countkatara(A),Num is A;

	X==sword,!,countsword(A),Num is A.

/*for medicine and etc.*/
take(Obj) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total < 4,
						player_pos(X, Y),
						inarea_contain(X,Y,List,EList),
						isMember(Obj,List),
						retract(inarea_contain(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,List,ListNew),
						append([Obj],BagList,BagListNew),nl,
						asserta(bag(BagListNew)),
						asserta(inarea_contain(X,Y,ListNew,EList)),
						\+isweapon(Obj),
						write('You took '), write(Obj) , nl,
						desc(Obj),
						isAttacked(EList),!.

take(Obj) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total < 4,
						player_pos(X, Y),
						inarea_contain(X,Y,List,EList),
						isMember(Obj,List),
						retract(inarea_contain(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,List,ListNew),
						append([Obj],BagList,BagListNew),nl,
						asserta(bag(BagListNew)),
						asserta(inarea_contain(X,Y,ListNew,EList)),
						isweapon(Obj),
						write('You took '), write(Obj),
                        getcountweapon(Obj,Z),
                        write(', element number: '), write(Z),nl,
						desc(Obj),
						isAttacked(EList),!.


/*else if not found in area or bag capacity is full*/
take(Obj) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total < 4,
						player_pos(X, Y),
						inarea_contain(X,Y,List,EList),
						isMember(Obj,List),
						retract(inarea_contain(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,List,ListNew),
						append([Obj],BagList,BagListNew),nl,
						asserta(bag(BagListNew)),
						asserta(inarea_contain(X,Y,ListNew,EList)),
						\+isweapon(Obj),
						write('You took '), write(Obj) , nl,
						desc(Obj),
						isAttacked(EList),!.

take(Obj) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total < 4,
						player_pos(X, Y),
						inarea_contain(X,Y,List,EList),
						isMember(Obj,List),
						retract(inarea_contain(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,List,ListNew),
						append([Obj],BagList,BagListNew),nl,
						asserta(bag(BagListNew)),
						asserta(inarea_contain(X,Y,ListNew,EList)),
						isweapon(Obj),
						write('You took '), write(Obj),
                        getcountweapon(Obj,Z),
                        write(', element number: '), write(Z),nl,
						desc(Obj),
						isAttacked(EList),!.


/*else if not found in area or bag capacity is full*/
take(Obj) :- ingamestate(1),
						player_pos(X, Y),
						inarea_contain(X,Y,List,EList),
						\+isMember(Obj,List), nl,
						writeln('No element here'),
						isAttacked(EList),!.

take(_) :- ingamestate(1),
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						bag(BagList),
						count(BagList,Total),
						Total==4,
						write('Bag space not enough.'), nl,
						isAttacked(EList),!.

/* Drop object from your backpack to the area */
/*medicine and armor*/
drop(Obj) :- ingamestate(1),
						bag(BagList),
						isMember(Obj,BagList),
						count(BagList,Total),
						Total > 0,
						player_pos(X, Y),
						inarea_contain(X,Y,List,EList),
						retract(inarea_contain(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,BagList,BagListNew),
						append([Obj],List,ListNew),nl,
						\+isweapon(Obj),
						write('You dropped '), write(Obj) , nl,
						isAttacked(EList),
						asserta(bag(BagListNew)),
						asserta(inarea_contain(X,Y,ListNew,EList)),!.

drop(Obj) :- ingamestate(1),
						bag(BagList),
						isMember(Obj,BagList),
						count(BagList,Total),
						Total > 0,
						player_pos(X, Y),
						inarea_contain(X,Y,List,EList),
						retract(inarea_contain(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,BagList,BagListNew),
						append([Obj],List,ListNew),nl,
						isweapon(Obj),
						write('You dropped '), write(Obj) ,
                        getcountweapon(Obj,Num),
                        write(' with '), write(Num), write(' element number'), nl,
						isAttacked(EList),
						asserta(bag(BagListNew)),
						asserta(inarea_contain(X,Y,ListNew,EList)),!.

/*Not found in the bag*/
drop(Obj) :- ingamestate(1),
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						bag(BagList),
						count(BagList,Total),
						Total>0,
						\+isMember(Obj,BagList), nl,
						writeln('No such element'),nl,
						isAttacked(EList),!.

drop(_) :- ingamestate(1),
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						bag(BagList),
						count(BagList,Total),
						Total==0,
						write('Bag empty'), nl, !,
						isAttacked(EList),!.

/*Use Procedure*/
use(Obj) :- bag(BagList),
						isarmor(Obj),
						isMember(Obj, BagList),
						armor(H),
						H == 100,nl,
						writeln('Max element number'),
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- bag(BagList),
						isarmor(Obj),
						isMember(Obj, BagList),
						armor(H),
						H < 100,
						NewH is H + 2,
						NewH > 100,
						delElmt(Obj, BagList, NBagList),
						retract(armor(_)),
						retract(bag(_)),
						asserta(bag(NBagList)),
						asserta(armor(100)),nl,
						write('You activated '), write(Obj), nl,
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- bag(BagList),
						isarmor(Obj),
						isMember(Obj, BagList),
						armor(H),
						H < 100,
						NewH is H + 2,
						delElmt(Obj, BagList, NBagList),
						retract(armor(_)),
						retract(bag(_)),
						asserta(bag(NBagList)),
						asserta(armor(NewH)),nl,
						write('You activated '), write(Obj), nl,
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

/*Ammo used*/
use(Obj) :- isammo(Obj),
						bag(BagList),
						isMember(Obj, BagList),
						weapon(Weapon),
						islistkosong(Weapon),nl,
						writeln('You did not transform to any of the benders'),
                        write('Thus you cannot use '), write(Obj),
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- isammo(Obj),
						bag(BagList),
						isMember(Obj, BagList),
						weapon(Weapon),
						weapon([W|_]),
						\+islistkosong(Weapon),
						getcountweapon(W,Z),
						Z>2,
						write('Cannot use '), write(Obj),
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- isammo(Obj),
						bag(BagList),
						isMember(Obj, BagList),
						weapon(Weapon),
						weapon([W|_]),
						\+islistkosong(Weapon),
						getcountweapon(W,Z),
						Z<3,
						\+isammo_of(Obj,W),
						write('Current bender '),write(W), write(' does not match this element'), nl,
                        write('Cannot use '), write(Obj),
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- isammo(Obj),
						bag(BagList),
						isMember(Obj, BagList),
						weapon(Weapon),
						weapon([W|_]),
						\+islistkosong(Weapon),
						getcountweapon(W,Z),
						Z<3,
						isammo_of(Obj,W),
						delElmt(Obj, BagList, NBagList),
						retract(bag(_)),
						asserta(bag(NBagList)),
						setcountweapon(W,Z+1),
						write('Using '), write(Obj), nl,
                        write('Element number of '), write(W), write(' goes up by one'),nl,
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.


/*Health*/
use(Obj) :- bag(BagList),
						ismedicine(Obj),
						isMember(Obj, BagList),
						health(H),
						H == 100,nl,
						writeln('Still strong enuffff'),
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- bag(BagList),
						ismedicine(Obj),
						isMember(Obj, BagList),
						health(H),
						H < 100,
						_NewH is 100,
						_NewH > 100,
						delElmt(Obj, BagList, NBagList),
						retract(health(_OldH)),
						retract(bag(_B)),
						asserta(bag(NBagList)),
						asserta(health(_NewH)),nl,
						write('Using '), write(Obj), nl,
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- bag(BagList),
						ismedicine(Obj),
						isMember(Obj, BagList),
						health(H),
						H < 100,
						_NewH is H + 4,
						delElmt(Obj, BagList, NBagList),
						retract(health(_OldH)),
						retract(bag(_B)),
						asserta(bag(NBagList)),
						asserta(health(_NewH)),nl,
						write('Using '), write(Obj), nl,
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

/*weapon*/
use(Obj) :- bag(BagList),
						isweapon(Obj),
						isMember(Obj, BagList),
						weapon(Weapon),
						islistkosong(Weapon),
						retract(weapon(_)),
						delElmt(Obj, BagList, NBagList),
						retract(bag(_B)),
						append([Obj], Weapon, _NewW),
						asserta(bag(NBagList)),
						asserta(weapon(_NewW)),nl,
						write('Using '), write(Obj), nl,
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- bag(BagList),
						isweapon(Obj),
						isMember(Obj, BagList),
						weapon(Weapon),
						\+islistkosong(Weapon),
						weapon([W|_]),nl,
						retract(weapon(_)),
						retract(bag(_)),
						delElmt(Obj, BagList, NBagList),
						append([W], NBagList, NBagL),
						delElmt(W, Weapon, NWeapon),
						append([Obj], NWeapon, NewW),
						asserta(bag(NBagL)),
						asserta(weapon(NewW)),nl,
						write(W), write(' kept in bag'),nl,
                        write('Using '), write(Obj),
						player_pos(X,Y),
						inarea_contain(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- bag(BagList),
						\+isMember(Obj, BagList),nl,
					write(Obj), writeln(' not found in bag'),
					player_pos(X,Y),
					inarea_contain(X,Y,_,EList),
					isAttacked(EList),!.

/*attack*/
attack	:- ingamestate(1),
					 player_pos(X,Y),
					 inarea_contain(X,Y,_,EList),
					 isEnemy(EList),
					 calcdecreased(EList),!,
					 randomEnemy(0,0).

attack :- ingamestate(1),
					player_pos(X,Y),
					inarea_contain(X,Y,_,EList),
					\+isEnemy(EList),
					weapon(Weapon),
					islistkosong(Weapon),
					writeln('No enemy found'),!,
					randomEnemy(0,0).

attack :- ingamestate(1),
					player_pos(X,Y),
					inarea_contain(X,Y,_,EList),
					\+isEnemy(EList),
					weapon(Weapon),
					\+islistkosong(Weapon),
					weapon([W|_]),
					getcountweapon(W,Count), Count==0,
					writeln('No enemy found'),!,
					randomEnemy(0,0).

attack :- ingamestate(1),
					player_pos(X,Y),
					inarea_contain(X,Y,_,EList),
					\+isEnemy(EList),
					weapon([W|_]),
					getcountweapon(W,Count), Count>0,
					setcountweapon(W,Count-1),
					writeln('No enemy found'),
                    write('But '), write(W), write(' element number -1 :('),nl,!,
					randomEnemy(0,0).


status :- ingamestate(1),
		weapon(WeaponList),
		islistkosong(WeaponList),
		health(Hp),
		armor(H),
		bag(BagList),
		write('Health    = '), writeln(Hp),
        write('Animal    = '), writeln(H),
        write('Bender    = '), writelist(WeaponList),
        writeln('Bag = '), writeInventoryList(BagList),!.

status :- ingamestate(1),
		weapon(WeaponList),
		\+islistkosong(WeaponList),
		weapon([W|_]),
		getcountweapon(W,Num),
		health(Hp),
		armor(H),
		bag(BagList),
		write('Health    = '), writeln(Hp),
        write('Animal    = '), writeln(H),
        write('Bender    = '), write(W), write(' with element number '), write(Num), nl,
        writeln('Bag = '), writeInventoryList(BagList),!.

writeInventoryList(Bag):-
	islistkosong(Bag),!.

writeInventoryList([Obj|T]):-
	\+isweapon(Obj),!,
	write('> '), write(Obj),nl,
	writeInventoryList(T);

	isweapon(Obj),!,
	getcountweapon(Obj,Count),
	write('> '),write(Obj),write(' with element number '),write(Count),nl,
	writeInventoryList(T).

save(FileName) :- tell(FileName), listing(player_pos), listing(bag), listing(health),
				listing(hunger), listing(thirsty), listing(inarea_contain), told.

loads(FileName) :- retractall(player_pos(_,_)), retractall(bag(_)), retractall(health(_)),
				retractall(hunger(_)), retractall(thirsty(_)), retractall(inarea_contain(_,_,_,_)), [FileName].

quit :- write('You dai...'), halt.

/* Kalkulasi serangan (zombie) */
calcdecreased([_H|_]) :- weapon(W),
														islistkosong(W),
														writeln('Not a bender, cannot attack'),
														isAttacked(EList),!.

calcdecreased([_H|_]) :- weapon(W),
														\+islistkosong(W),
														weapon([Obj|_]),
														getcountweapon(Obj, Count), Count==0,
														writeln('Not a bender, cannot attack'),
														isAttacked(EList),!.


calcdecreased([H|_]) :- enemies(H), enemypower(H, Atk),
						 weapon(A),
						 \+islistkosong(A),
						 weapon([W|_]),
						 armor(Z),
						 kills(K),
						 player_pos(X,Y),
						 health(HP),
						 Factor is (100-Z)/100 *Atk,
						 _NewHP is HP - Factor,
						 _NewHP > 0,nl,
						 write('Enemy hits you for '), write(Factor), write(' damage! Counter-attacking '), write(H),
						 retract(inarea_contain(X,Y,Listt,_E)),
						 getcountweapon(W,Count),
						 setcountweapon(W,Count-1),
						 enemyitem(H,Item),
						 enemyitem(H,[F|_]),
						 writeln('Enemy ded '), write(F), write(' fell from '), write(H), nl,
						 append(Item,Listt,ListNew),
						 asserta(inarea_contain(X,Y,ListNew,[])),
						 write('Current HP: '), writeln(_NewHP),
						 retract(health(_HP)),
						 retract(kills(_K)),
						 NewK is K + 1,
						 asserta(kills(NewK)),
						 asserta(health(_NewHP)), !.

calcdecreased([H|_]) :-  enemies(H), enemypower(H, Atk),
						 retract(health(_HP)),
						 Factor is (100-Z)/100 *Atk,
						 _NewHP is HP - Factor,
						 _NewHP < 1,
						 retract(win(_X)),
						 asserta(win(0)),!.

checkDeadZone(X) :-
	\+(0 is X mod 7), !.

checkDeadZone(X) :-
	0 is X mod 7,
	deadzone(W),
	NewW is W + 1,
	retract(deadzone(_)),
	asserta(deadzone(NewW)).

inDeadZone(X,Y) :-
	\+isdeadzone(X,Y), !.

inDeadZone(X,Y) :-
	isdeadzone(X,Y),
	retract(health(_)),
	asserta(health(0)),
	retract(win(_)),
	asserta(win(0)).

/*direction_to another area with direction, 1 step Hunger-=1 dan 3 step Thirsty -= 1*/
direction(Direction) :-
			ingamestate(1),
			player_pos(Xa,Ya),
			countstep(Step),
			\+isEven(Step),
			armor(H),
			H>0,
			path(Xa,Ya, Direction,Xb,Yb),nl,
			write('Moving to '), writeln(Direction),
			retract(player_pos(Xa,Ya)),
			retract(armor(_)),
			retract(countstep(_)),
			NewH is H-1,
			NewStep is Step + 1,
			asserta(countstep(NewStep)),
			checkDeadZone(NewStep),
			asserta(armor(NewH)),
			asserta(player_pos(Xb,Yb)),
			inDeadZone(Xb,Yb),
			look,!.

direction(Direction) :-
			ingamestate(1),
			player_pos(Xa,Ya),
			countstep(Step),
			path(Xa,Ya, Direction,Xb,Yb),nl,
			write('Moving to '), writeln(Direction),
			retract(player_pos(Xa,Ya)),
			retract(countstep(_)),
			NewStep is Step+1,
			asserta(countstep(NewStep)),
			checkDeadZone(NewStep),
			asserta(player_pos(Xb,Yb)),
			inDeadZone(Xb,Yb),
			look,!.

direction(Direction) :-
			ingamestate(1),
			player_pos(Xa,Ya),
			\+path(Xa,Ya, Direction,_,__),
			write('Cannot go there'),!.

direction(_) :-
			ingamestate(1),
			hunger(H),
			H == 1,
			retract(win(_X)),
			asserta(win(0)),!.

direction(_) :-
			ingamestate(1),
			thirsty(T),
			countstep(_S),
			_S == 2,
			T == 1,
			retract(win(_X)),
			asserta(win(0)),!.


direction(_) :- ingamestate(1),
			writeln('Wrong input'),!.

direction(_) :- ingamestate(0),
			writeln('Start game first!').

north :- direction(north).
south :- direction(south).
west :- direction(west).
east :- direction(east).
