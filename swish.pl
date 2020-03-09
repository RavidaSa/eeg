% Checks if the point is in the game field
valid(X, Y) :- between(0, 20, X), between(0, 20, Y).

% Testing positions
h(0, 6).
h(0, 3).
o(2, 2).
t(1, 6).

% Up
transition((X, Y),  (X, Y1), 1, Price) :-
    Y1 is Y-1,
    valid(X, Y1),
    \+ o(X,Y1),
    (   h(X, Y1)->  Price is 0;   Price is 1).

% Right
transition((X, Y),  (X1, Y), 2, Price) :-
    X1 is X+1,
    valid(X1, Y),
    \+ o(X1,Y),
    (   h(X1, Y)->  Price is 0;   Price is 1).

% Down
transition((X, Y),  (X, Y1), 3, Price) :-
    Y1 is Y+1,
    valid(X, Y1),
    \+ o(X,Y1),
    (   h(X, Y1)->  Price is 0;   Price is 1).

 % Left
transition((X, Y),  (X1, Y), 4, Price) :-
    X1 is X-1,
    valid(X1, Y),
    \+ o(X1,Y),
    (   h(X1, Y)->  Price is 0;   Price is 1).

% Pass Up
transition((X, Y),  (X, Y1), 5, 1) :- trace_verticaly((X, Y),  (X, Y1),-1).

% Pass Down
transition((X,Y),(X,Y1),9,1) :- trace_verticaly((X,Y),(X,Y1),1).

% Pass Right
transition((X, Y),  (X1, Y), 7, 1) :- trace_horizontaly((X, Y),  (X1, Y),1).

% Pass Left
transition((X, Y),  (X1, Y), 11, 1) :- trace_horizontaly((X, Y),  (X1, Y),-1).

% Pass Main Diagonal Up
transition((X, Y),  (X1, Y1), 12, 1) :- trace_MD((X, Y),  (X1, Y1),-1).

% Pass Main Diagonal Down
transition((X, Y),  (X1, Y1), 8, 1) :- trace_MD((X, Y),  (X1, Y1),1).

% Pass Side Diagonal Up
transition((X, Y),  (X1, Y1), 6, 1) :- trace_SD((X, Y),  (X1, Y1),1).

% Pass Side Diagonal Down
transition((X, Y),  (X1, Y1), 10, 1) :- trace_MD((X, Y),  (X1, Y1),-1).


trace_MD((X, Y), (X1, Y1), Direction) :-
    X1 is X + Direction,
    Y1 is Y + Direction,
    h(X1, Y1).

trace_MD((X, Y), (X1,Y1), Direction) :-
    Xm is X + Direction,
    Ym is Y + Direction,
    valid(Xm, Ym),
    \+ o(Xm, Ym),
    trace_MD((Xm, Ym), (X1, Y1), Direction).

trace_SD((X, Y), (X1, Y1), Direction) :-
    X1 is X + Direction,
    Y1 is Y - Direction,
    h(X1, Y1).

trace_SD((X, Y), (X1, Y1), Direction) :-
    Xm is X + Direction,
    Ym is Y - Direction,
    valid(Xm, Ym),
    \+ o(Xm, Ym),
    trace_SD((Xm, Ym), (X1, Y1), Direction).

trace_horizontaly((X,Y),(X1,Y),Direction) :- X1 is X + Direction, h(X1,Y).
trace_horizontaly((X,Y),(X1,Y), Direction) :- 
								X2 is X + Direction,
								valid(X2,Y),
								\+ o(X2,Y),
								trace_horizontaly((X2,Y),(X1,Y),Direction).
trace_verticaly((X,Y),(X,Y1),Direction) :- Y1 is Y + Direction, h(X,Y1).
trace_verticaly((X,Y),(X,Y1), Direction) :- 
								Y2 is Y + Direction,
								valid(X,Y2),
								\+ o(X,Y2),
								trace_verticaly((X,Y2),(X,Y1),Direction).



random_steps((_, _), Steps, Cost, 0) :- print(Steps), nl, print(Cost).


random_steps((Xc, Yc), Steps, Cost, Remains) :-
    random_between(1, 4, Command),
    transition((Xc, Yc),  (Xn, Yn), Command, Price),
    Remains1 is Remains - 1,
    Cost1 is Cost + Price,
    append(Steps,  [(Xn, Yn)], Steps1),
    random_steps((Xn, Yn), Steps1, Cost1, Remains1).