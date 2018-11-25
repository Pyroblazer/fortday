/* win(X) menyatakan status kemenangan */

:- use_module(library(random)).
:- dynamic(deadzone/1,isdeadzone/2,kills/1 ,win/1, player_pos/2, item/2, insidethisplace/4, ingamestate/1, bag/1, health/1, weapon/1, armor/1, enemypower/2, countstep/1, countaxe/1, counthoe/1, countspear/1).

/*Inisialisasi game
* 0 = belum mulai permainan atau udah mati, 1 = hidup atau sedang bermain
*/
ingamestate(0).

/*
countaxe(1).
counthoe(0).
countspear(0).
countsword(0).*/

/* Deklarasi Fakta */
place(0, openfield).
place(1, openfield).
place(2, garden).
place(3, armory).
place(4, openfield).
place(5, forest).
place(6, cave).
place(7, lake).
zombie(kipepo).
zombie(majiniundead).
isfood(meat).
isfood(banana).
isfood(pig).
isdrink(waterpouch).
isdrink(honey).
isweapon(axe).
isweapon(hoe).
isweapon(spear).
isammo_of(fire,axe).
isammo_of(air,hoe).
isammo_of(water,spear).
isammo(fire).
isammo(air).
isammo(water).
isarmor(shield).
isarmor(iron).
ismedicine(medicine).
ismedicine(bandage).

/*locationName
* Perhitungan : x mod 5 = 0<=a<=4 , y mod 4 = 0<=b<=3,0<= a+b <=7
* Misal ->  a+b = 1 (openfield), ikuti fakta yang diatas
*/
locationName(X, Y, Place) :- A is X mod 5, B is Y mod 4, N is A+B, place(N, Place).

/* Game loop */
game_loop   :- ingamestate(1),
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
checkWinner :- win(X), X == 0, writeln('U ded :('),!.
checkWinner :- win(X), X == 1, writeln('You won. hehe :)'),!,halt.
writeifenemynearby([]) :- true,!.
writeifenemynearby(List) :- isEnemy(List), write(' careful......').
isdefined(X,Y) :- X>=0, X<11, Y>=0, Y<21.
islistkosong([]).
isEnemy([]):- fail.
isEnemy([H|T]) :- zombie(H),!.
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
run(north) :- north, nl,!.
run(east) :- east, nl,!.
run(south) :- south, nl,!.
run(west) :- west, nl,!.
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
init_zombies :-
							random(0, 10, Xa), /* random ZOMB1 (position) */
							random(0, 20, Ya),
							random(0, 10, Xb), /* random ZOMB2 (position) */
							random(0, 20, Yb),
							retract(insidethisplace(Xa,Ya,_,Lista)),
							retract(insidethisplace(Xb,Yb,_,Listb)),
							append([majiniundead],Lista,RLista), /*Zombie2*/
							append([kipepo],Listb,RListb),
							asserta(insidethisplace(Xa,Ya,_,RLista)),
							asserta(insidethisplace(Xb,Yb,_,RListb)).

init_dynamic_facts(X,Y) :-
									X == 11, Y >= 0, true.

init_dynamic_facts(X,Y) :-
									X < 11, Y < 20,
									locationName(X,Y,Place),
									item(Place, List),
									asserta(insidethisplace(X,Y,List,[])),
									M is X,
									N is Y + 1,
									init_dynamic_facts(M,N).

init_dynamic_facts(X,Y) :-
									X < 11, Y == 20,
									locationName(X,Y,Place),
									item(Place, List),
									asserta(insidethisplace(X,Y,List,[])),
									M is X + 1,
									N is 0,
									init_dynamic_facts(M,N).

start:- writeln('Welcome boizzz.'),
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
		asserta(poweraxe(20)),
		asserta(powerhoe(35)),
		asserta(powerspear(50)),
		asserta(enemyitem(majiniundead,[hoe])),
		asserta(enemyitem(kipepo,[spear])),
		asserta(armor(10)),
		asserta(weapon([])),
		asserta(bag([axe,fire])),
		asserta(item(lake,[water,air, shield])),
		asserta(item(openfield,[])),
		asserta(item(armory,[fire, medicine])),
		asserta(item(garden,[air,iron])),
		asserta(item(forest,[shield,iron])),
		asserta(item(cave,[bandage,water])),
		init_dynamic_facts(0,0),
		init_zombies,
		asserta(kills(0)),
		retract(insidethisplace(X,Y,_AddRadar,_EL)),
		append([radar], _AddRadar, _AddRadar2),
		asserta(insidethisplace(X,Y,_AddRadar2,_EL)),
		retract(ingamestate(_)),
		asserta(ingamestate(1)),
		asserta(countaxe(0)),
		asserta(counthoe(0)),
		asserta(countspear(0)),
		game_loop.

powerweapon(axe,Power):- poweraxe(Power).
powerweapon(hoe,Power):- powerhoe(Power).
powerweapon(spear,Power):- powerspear(Power).

enemypower(H,Power):-
	zombie(H),
	enemyitem(H,[Weapon|_]),
	powerweapon(Weapon,Power).

restartgame :-
		retract(kills(_P)),
		retract(enemypower(_YY,_TT)),
		retract(ingamestate(_A)),
		asserta(ingamestate(0)),
		retract(insidethisplace(_R,_T,_U,_V)),
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
prio(X,Y) :- insidethisplace(X,Y,_,EList), EList \= [],
   						write('E'),!.
prio(X,Y) :-insidethisplace(X,Y,List,_) , islistkosong(List), player_pos(M,N),
							M == X, N == Y,
							write('A'),!.
prio(X,Y) :-insidethisplace(X,Y,List,_) , islistkosong(List),
							write('-'),!.
prio(X,Y) :-insidethisplace(X,Y,List,_),
						isMember(medicine,List),
						write('M'),!.
prio(X,Y) :-insidethisplace(X,Y,List,_),
							isMember(bandage,List),
						write('M'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
							isMember(axe,List),
						write('W'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(spear,List),
						write('W'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
							isMember(shield,List),
						write('R'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(iron,List),
						write('R'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(water,List),
						write('O'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(fire,List),
						write('O'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(air,List),
						write('O'),!.
prio(X,Y) :- player_pos(A,B),
						X==A,
						Y==B,
						write('A').

printmap(_,Y) :- Y == 21 , nl, player_pos(R,T), write('Current location: ('), write(R), write(',') , write(T), writeln(').'), true.

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
		insidethisplace(X,Y,List,EList),
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
		write('You are in '), write(Place), writeifenemynearby(EList), nl,
		writeln('Items in this place is/are '), writelist(List),!.

help :- writeln('-----------------------------------------------------------------------'),
		writeln('This is a game!!'),
		writeln('-----------------------------------------------------------------------'),
		writeln('These are the available commands:'),
		writeln('- start.          = start game.'),
		writeln('- n. w. s. e.	   = move'),
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
maps :- ingamestate(1),bag(ListItem),\+isMember(radar,ListItem),writeln('User radar to see full maps'),!.

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
countPower([H|T],X) :- zombie(H), enemypower(H,ATK),
                        countPower(T,X1),
                        X is X1 + ATK.

/* 	Jika tidak melakukan pergerakan atau attack, dan di dalam kotak yang sama
	dengan sebuah atau beberapa zombie, maka akan mendapatkan serangan */
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
randomEnemy(X,Y) :- insidethisplace(X,Y,_,EList),
						EList == [],
						X < 11, Y < 21,
						M is X + 1, N is Y,
						randomEnemy(M,N).

randomEnemy(X,Y) :- insidethisplace(X,Y,_,EList),
						EList == [],
						X == 10, Y < 21,
						M is 0, N is Y + 1,
						randomEnemy(M,N).

/* jika enemy berada dalam petak yang sama dengan pemain, maka tidak di random */
randomEnemy(X,Y) :- player_pos(X,Y),
						insidethisplace(X,Y,List,EList),
						X < 11, Y < 21,
						M is X + 1, N is Y,
						retract(insidethisplace(X,Y,List,EList)),
						asserta(insidethisplace(X,Y,List,EList)),
						randomEnemy(M,N).

randomEnemy(X,Y) :- player_pos(X,Y),
						insidethisplace(X,Y,List,EList),
						X == 10, Y < 21,
						M is 0, N is Y + 1,
						retract(insidethisplace(X,Y,List,EList)),
						asserta(insidethisplace(X,Y,List,EList)),
						randomEnemy(M,N).

/* RANDOM! (jika di petak ada enemy, dan tidak satu petak dengan player)*/
randomEnemy(X,Y) :- insidethisplace(X,Y,_,EList),
						EList \= [],
						X < 11, Y < 21,
						M is X + 1, N is Y,
						A is X mod 5, B is Y mod 4, N is A+B,
						moverand(N,X1,Y1),
						X2 is X1 + X, Y2 is Y1 + Y,
						X2 > -1, X2 < 11, Y2 > -1, Y2 < 21,
						insidethisplace(X2,Y2,_,EL),
						append(EList,EL,ELNew),
						retract(insidethisplace(X,Y,_,_)),
						retract(insidethisplace(X2,Y2,_,_)),
						asserta(insidethisplace(X,Y,_,[])),
						asserta(insidethisplace(X2,Y2,_,ELNew)),
						randomEnemy(M,N).

randomEnemy(X,Y) :- insidethisplace(X,Y,_ListN,EList),
						EList \= [],
						X == 10, Y < 21,
						M is 0, N is Y + 1,
						A is X mod 5, B is Y mod 4, N is A+B,
						moverand(N,X1,Y1),
						X2 is X1 + X, Y2 is Y1 + Y,
						X2 > -1, X2 < 11, Y2 > -1, Y2 < 21,
						insidethisplace(X2,Y2,_ListB,EL),
						append(EList,EL,ELNew),
						retract(insidethisplace(X,Y,_,_)),
						retract(insidethisplace(X2,Y2,_,_)),
						asserta(insidethisplace(X,Y,_ListN,[])),
						asserta(insidethisplace(X2,Y2,_ListB,ELNew)),
						randomEnemy(M,N).

randomEnemy(_,Y) :- Y == 21, nl, break,
						write('Enemy moved').

/* Take object from where you are, and put it in backpack, max item in backpack = 4 */
setcountweapon(X,Num):-
	X==axe,!,
	retract(countaxe(_)),asserta(countaxe(Num));

	X==hoe,!,
	retract(counthoe(_)),asserta(counthoe(Num));

	X==spear,!,
	retract(countspear(_)),asserta(countspear(Num));

	X==sword,!,
	retract(countsword(_)),asserta(countsword(Num)).

getcountweapon(X,Num):-
	X==axe,!,countaxe(A),Num is A;

	X==hoe,!,counthoe(A),Num is A;

	X==spear,!,countspear(A),Num is A;

	X==sword,!,countsword(A),Num is A.

/*for medicine and etc.*/
take(Obj) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total < 4,
						player_pos(X, Y),
						insidethisplace(X,Y,List,EList),
						isMember(Obj,List),
						retract(insidethisplace(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,List,ListNew),
						append([Obj],BagList,BagListNew),nl,
						asserta(bag(BagListNew)),
						asserta(insidethisplace(X,Y,ListNew,EList)),
						\+isweapon(Obj),
						write('You took '), write(Obj) , nl,
						desc(Obj),
						isAttacked(EList),!.

take(Obj) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total < 4,
						player_pos(X, Y),
						insidethisplace(X,Y,List,EList),
						isMember(Obj,List),
						retract(insidethisplace(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,List,ListNew),
						append([Obj],BagList,BagListNew),nl,
						asserta(bag(BagListNew)),
						asserta(insidethisplace(X,Y,ListNew,EList)),
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
						insidethisplace(X,Y,List,EList),
						isMember(Obj,List),
						retract(insidethisplace(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,List,ListNew),
						append([Obj],BagList,BagListNew),nl,
						asserta(bag(BagListNew)),
						asserta(insidethisplace(X,Y,ListNew,EList)),
						\+isweapon(Obj),
						write('You took '), write(Obj) , nl,
						desc(Obj),
						isAttacked(EList),!.

take(Obj) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total < 4,
						player_pos(X, Y),
						insidethisplace(X,Y,List,EList),
						isMember(Obj,List),
						retract(insidethisplace(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,List,ListNew),
						append([Obj],BagList,BagListNew),nl,
						asserta(bag(BagListNew)),
						asserta(insidethisplace(X,Y,ListNew,EList)),
						isweapon(Obj),
						write('You took '), write(Obj),
						getcountweapon(Obj,Z),
						write(', element number: '), write(Z),nl,
						desc(Obj),
						isAttacked(EList),!.


/*else if not found in area or bag capacity is full*/
take(Obj) :- ingamestate(1),
						player_pos(X, Y),
						insidethisplace(X,Y,List,EList),
						\+isMember(Obj,List), nl,
						writeln('No element here'),
						isAttacked(EList),!.

take(_) :- ingamestate(1),
						player_pos(X,Y),
						insidethisplace(X,Y,_,EList),
						bag(BagList),
						count(BagList,Total),
						Total==4,
						write('Bag space not enough.'), nl,
						isAttacked(EList),!.

/* Drop object from your backpack to the place */
/*medicine and armor*/
drop(Obj) :- ingamestate(1),
						bag(BagList),
						isMember(Obj,BagList),
						count(BagList,Total),
						Total > 0,
						player_pos(X, Y),
						insidethisplace(X,Y,List,EList),
						retract(insidethisplace(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,BagList,BagListNew),
						append([Obj],List,ListNew),nl,
						\+isweapon(Obj),
						write('You dropped '), write(Obj) , nl,
						isAttacked(EList),
						asserta(bag(BagListNew)),
						asserta(insidethisplace(X,Y,ListNew,EList)),!.

drop(Obj) :- ingamestate(1),
						bag(BagList),
						isMember(Obj,BagList),
						count(BagList,Total),
						Total > 0,
						player_pos(X, Y),
						insidethisplace(X,Y,List,EList),
						retract(insidethisplace(X,Y,List,EList)),
						retract(bag(BagList)),
						delElmt(Obj,BagList,BagListNew),
						append([Obj],List,ListNew),nl,
						isweapon(Obj),
						write('You dropped '), write(Obj) ,
						getcountweapon(Obj,Num),
						write(' with '), write(Num), write(' element number'), nl,
						isAttacked(EList),
						asserta(bag(BagListNew)),
						asserta(insidethisplace(X,Y,ListNew,EList)),!.

/*Not found in the bag*/
drop(Obj) :- ingamestate(1),
						player_pos(X,Y),
						insidethisplace(X,Y,_,EList),
						bag(BagList),
						count(BagList,Total),
						Total>0,
						\+isMember(Obj,BagList), nl,
						writeln('No such element'),nl,
						isAttacked(EList),!.

drop(_) :- ingamestate(1),
						player_pos(X,Y),
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
						isAttacked(EList),!.


/*Health*/
use(Obj) :- bag(BagList),
						ismedicine(Obj),
						isMember(Obj, BagList),
						health(H),
						H == 100,nl,
						writeln('Still strong enuffff'),
						player_pos(X,Y),
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
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
						write('Using '), write(Obj),
						player_pos(X,Y),
						insidethisplace(X,Y,_,EList),
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
						insidethisplace(X,Y,_,EList),
						isAttacked(EList),!.

use(Obj) :- bag(BagList),
						\+isMember(Obj, BagList),nl,
					write(Obj), writeln(' not found in bag'),
					player_pos(X,Y),
					insidethisplace(X,Y,_,EList),
					isAttacked(EList),!.

/*attack*/
attack	:- ingamestate(1),
					 player_pos(X,Y),
					 insidethisplace(X,Y,_,EList),
					 isEnemy(EList),
					 calcbyzombiename(EList),!,
					 randomEnemy(0,0).

attack :- ingamestate(1),
					player_pos(X,Y),
					insidethisplace(X,Y,_,EList),
					\+isEnemy(EList),
					weapon(Weapon),
					islistkosong(Weapon),
					writeln('No enemy found'),!,
					randomEnemy(0,0).

attack :- ingamestate(1),
					player_pos(X,Y),
					insidethisplace(X,Y,_,EList),
					\+isEnemy(EList),
					weapon(Weapon),
					\+islistkosong(Weapon),
					weapon([W|_]),
					getcountweapon(W,Count), Count==0,
					writeln('No enemy found'),!,
					randomEnemy(0,0).

attack :- ingamestate(1),
					player_pos(X,Y),
					insidethisplace(X,Y,_,EList),
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
				listing(hunger), listing(thirsty), listing(insidethisplace), told.

loads(FileName) :- retractall(player_pos(_,_)), retractall(bag(_)), retractall(health(_)),
				retractall(hunger(_)), retractall(thirsty(_)), retractall(insidethisplace(_,_,_,_)), [FileName].

quit :- write('You dai...'), halt.

/* Kalkulasi serangan (zombie) */
calcbyzombiename([_H|_]) :- weapon(W),
														islistkosong(W),
														writeln('Not a bender, cannot attack'),
														isAttacked(EList),!.

calcbyzombiename([_H|_]) :- weapon(W),
														\+islistkosong(W),
														weapon([Obj|_]),
														getcountweapon(Obj, Count), Count==0,
														writeln('Not a bender, cannot attack'),
														isAttacked(EList),!.


calcbyzombiename([H|_]) :- zombie(H), enemypower(H, Atk),
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
						 retract(insidethisplace(X,Y,Listt,_E)),
						 getcountweapon(W,Count),
						 setcountweapon(W,Count-1),
						 enemyitem(H,Item),
						 enemyitem(H,[F|_]),
						 writeln('Enemy ded '), write(F), write(' fell from '), write(H), nl,
						 append(Item,Listt,ListNew),
						 asserta(insidethisplace(X,Y,ListNew,[])),
						 write('Current HP: '), writeln(_NewHP),
						 retract(health(_HP)),
						 retract(kills(_K)),
						 NewK is K + 1,
						 asserta(kills(NewK)),
						 asserta(health(_NewHP)), !.

calcbyzombiename([H|_]) :-  zombie(H), enemypower(H, Atk),
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

go(Direction) :-
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

go(Direction) :-
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

go(Direction) :-
			ingamestate(1),
			player_pos(Xa,Ya),
			\+path(Xa,Ya, Direction,_,__),
			write('Cannot go there'),!.

go(_) :-
			ingamestate(1),
			hunger(H),
			H == 1,
			retract(win(_X)),
			asserta(win(0)),!.

go(_) :-
			ingamestate(1),
			thirsty(T),
			countstep(_S),
			_S == 2,
			T == 1,
			retract(win(_X)),
			asserta(win(0)),!.


go(_) :- ingamestate(1),
			writeln('Wrong input'),!.

go(_) :- ingamestate(0),
			writeln('Start game first!').

north :- go(north).
south :- go(south).
west :- go(west).
east :- go(east).
