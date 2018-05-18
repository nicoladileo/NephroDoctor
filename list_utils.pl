/* 
Copyright (C) 2015  Nicola Dileo, Tommaso Viterbo

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>

*/

% Module: list_utils.pl
% --------
%
% This module contains the predicate to manage a list. In this system 
% a list contains couple with rule identifier and rule salience

difference(L,[],L).
difference(L1,[H|L2],L3) :-
    not(member(H,L1)),
    difference(L1,L2,L3).


difference(L1,[H|L2],L3) :-
    member(H,L1),
    nth0(_,L1,H,L4),
    difference(L4,L2,L3).


extractSubList([],_,[]) :- !.
extractSubList([Item|_],Item,[Item]) :- !.
extractSubList([ItemX|Rest],Item,ListOut) :-
    extractSubList(Rest,Item,ListOutX),
    append([ItemX],ListOutX,ListOut),
    !.


insertRule(RuleID-Salience,[],[RuleID-Salience]) :- !.
insertRule(RuleID-Salience,[RuleIDX-SalienceX|Rest],[RuleID-Salience,RuleIDX-SalienceX|Rest]) :-
    Salience < SalienceX,
    !.


insertRule(RuleID-Salience,[RuleIDX-Salience|Rest],[RuleID-Salience,RuleIDX-Salience|Rest]) :-
    RuleID < RuleIDX,
    !.


insertRule(RuleID-Salience,[RuleIDX-SalienceX|Rest],[RuleIDX-SalienceX|Others]) :-
    insertRule(RuleID-Salience,Rest,Others).


memberRule(RuleID, [RuleID-_|_]) :- !.
memberRule(RuleID, [_-_|Rest]) :-
    memberRule(RuleID,Rest).


sortDiagnosis([],[]).
sortDiagnosis([Diag-CF|Rest],Sorted) :-
    partition(Rest,CF,Left,Right),
    sortDiagnosis(Left,LeftS),
    sortDiagnosis(Right,RightS),
    append(LeftS,[Diag-CF|RightS],Sorted).


partition([DiagX-CFX|Rest],CF,[DiagX-CFX|Ls],Rs) :-
    CFX > CF,
    partition(Rest,CF,Ls,Rs).


partition([],_,[],[]).
partition([DiagX-CFX|Rest],CF,Ls,[DiagX-CFX|Rs]) :-
    CFX =< CF,
    partition(Rest,CF,Ls,Rs).

    








  
