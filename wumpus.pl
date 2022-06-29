%This code was inspired by the code of alexroque91 available on GitHub: https://github.com/alexroque91/wumpus-world-prolog/blob/master/main.pl

%The variables pit_location, wumpus_location, gold_location, agent_location are world parameters set at the start of every interation of the game
%The variables breeze and stench are dynamically asserted to the knowledge base.

:- dynamic ([breeze/1,
             stench/1,
             wumpus_location/1,
             pit_location/1,
             gold_location/1,
             agent_location/1]).


%returns true or false if room A is adjacent to room B or show all the adjacent rooms to room A
%It also limits the world of the game by creating a 4x4 grid.

adjacentTo([X,Y],L) :- (X<4)->  Xr is X+1, L=[Xr,Y].
adjacentTo([X,Y],L) :- (X>1)->  Xl is X-1, L=[Xl,Y].
adjacentTo([X,Y],L) :- (Y<4)->  Yt is Y+1, L=[X,Yt].
adjacentTo([X,Y],L) :- (Y>1)->  Yb is Y-1, L=[X,Yb].

%Instead of predicate Room(x,y), we used a list [x,y] to represent all rooms.


% It returns true or false if the room contains breeze or not.

breeze([X,Y]) :- (pit_location(PL),adjacentTo([X,Y],PL))->  format('There is a breeze in ~p~n',[[X,Y]]); format('There is no breeze in ~p~n',[[X,Y]]).



% It returns true or false if the room contains a pit or not, and it shows if there is a breeze in all adjacent rooms.

pit([X,Y]) :- forall(adjacentTo([X,Y],L), (breeze(L))), (pit_location([X,Y]))-> format('You fell in the pit!').



% It returns true or false if the room contains stench.

stench([X,Y]) :- (wumpus_location(L),adjacentTo([X,Y],L))->  format('there is a stench in ~p~n',[[X,Y]]); format('there is no stench in ~p~n',[[X,Y]]).



% It returns true or false if the room contains the wumpus or not, and it shows if there is a stench in all the adjacent rooms.

wumpus([X,Y]) :- forall(adjacentTo([X,Y],L), stench(L)),wumpus_location([X,Y]).



% It returns true if the room does not contains a pit or a wumpus, and returns false if it contains either of them.

safe([X,Y]):- \+ pit_location([X,Y]), \+ wumpus_location([X,Y]).



% It returns a statement showing that the gold is grabbed.

grabGold():- write('We have the gold!').



% It returns true or false if there is gold in the room or not.

gold([X,Y]):- (gold_location([X,Y]))->  format('There is gold in ~p~n',[[X,Y]]); format('There is no gold in ~p~n',[[X,Y]]).



% It returns statements depending on whether you shot the wumpus successfully or not.

shootwumpus([X,Y]):- (pit_location([X,Y]))-> format('You fell in a pit, and you missed your shot!'); (wumpus_location(L), adjacentTo([X,Y],L))-> format('Wumpus killed in ~p~n',[L]); (wumpus_location([X,Y]))->  format('Wumpus ate you. You failed.');format('Wumpus not found. You failed.').



% If you want to test the code, you need to write start, (your predicate/ question) to activitate the intelligent agent.

start:-
    init,
    write('Write menu if you want to know the rules of the game and the available questions.'),nl,
    assert(agent_location([1,1])).


% This predicate initialises the world of the wumpus.
% we change the configurations by chanigng the code in it 
init:-
    % scenario 5

    retractall(gold_location(_)),
    assert(gold_location([4,3])),
    retractall(wumpus_location(_)),
    assert(wumpus_location([3,2])),
    retractall(pit_location(_)),
    assert(pit_location([4,4])),
    assert(pit_location([4,1])),
    assert(pit_location([3,3])),
    assert(pit_location([2,3])),
    assert(pit_location([2,1])),
    assert(pit_location([1,2])),
    retractall(agent_location(_)).
    
    % Scenario 4
    
    %retractall(gold_location(_)),
    %assert(gold_location([1,2])),
    %retractall(wumpus_location(_)),
    %assert(wumpus_location([1,4])),
    %retractall(pit_location(_)),
    %assert(pit_location([2,3])),
    %assert(pit_location([2,1])),
    %retractall(agent_location(_)).

    % Scenario 3

    %retractall(gold_location(_)),
    %assert(gold_location([3,4])),
    %retractall(wumpus_location(_)),
    %assert(wumpus_location([1,2])),
    %retractall(pit_location(_)),
    %assert(pit_location([3,2])),
    %assert(pit_location([3,1])),
    %assert(pit_location([2,4])),
    %assert(pit_location([1,3])),
    %retractall(agent_location(_)).

    % Scenario 2

    %retractall(gold_location(_)),
    %assert(gold_location([2,1])),
    %retractall(wumpus_location(_)),
    %assert(wumpus_location([1,3])),
    %retractall(pit_location(_)),
    %assert(pit_location([4,3])),
    %assert(pit_location([1,2])),
    %assert(pit_location([4,1])),
    %retractall(agent_location(_)).

    % Scenario 1

    %retractall(gold_location(_)),
    %assert(gold_location([3,2])),
    %retractall(wumpus_location(_)),
    %assert(wumpus_location([1,4])),
    %retractall(pit_location(_)),
    %assert(pit_location([3,1])),
    %assert(pit_location([3,3])),
    %assert(pit_location([4,4])),
    %retractall(agent_location(_)).

menu:- 
    write('This is the Wumpus game.'),nl,
    write('Your goal is to kill the wumpus from an adjacent room.'),nl,
	write('You will explore the world with our agent who can answer the following questions:'),nl,
    write('adjacentTo([X,Y], L): will give all the adjacent rooms to your room [X,Y]'),nl,
    write('breeze([X,Y]): will tell you if there is breeze in room [X,Y]'),nl,
    write('pit([X,Y]): will tell if there is a breeze in any adjacent rooms and if room [X,Y] has a pit'),nl,
    write('stench([X,Y]): will tell you if room [X,Y] has a stench'),nl,
    write('wumpus([X,Y]): will tell you the adjacent rooms that have a stench and if the wumpus is in room [X,Y]'),nl,
    write('safe([X,Y]): will tell you if room [X,Y] has no pit nor wumpus.'),nl,
    write('gold([X,Y]): will tell you if room [X,Y] has gold.'),nl,
    write('grabGold(): will tell you that you took the gold.'),nl,
    write('shootwumpus([X,Y]): will tell you if you succeeded in killing the wumpus or not'),nl.
