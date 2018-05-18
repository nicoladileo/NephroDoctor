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

% Module: history.pl
% --------
%
% This module provide the utility for store the execution's history and
% backup the system to a previous point

:- dynamic recovery/2.


recoverState([]) :- !.
recoverState([Rule|Rules]) :-
    undoRule(Rule),
    recoverState(Rules).


saveAction(RuleID,assert(X)) :-
    retract(recovery(RuleID,Hist)),
    assert(recovery(RuleID,[retract(fact(X))|Hist])),
    !.


saveAction(RuleID,assert(X)) :-
    assert(recovery(RuleID,[retract(fact(X))])),
    !.


saveAction(RuleID,asserta(X)) :-
    retract(recovery(RuleID,Hist)),
    assert(recovery(RuleID,[retract(fact(X))|Hist])),
    !.


saveAction(RuleID,asserta(X)) :-
    assert(recovery(RuleID,[retract(fact(X))])),
    !.


saveAction(RuleID,assertz(X)) :-
    retract(recovery(RuleID,Hist)),
    assert(recovery(RuleID,[retract(fact(X))|Hist])),
    !.


saveAction(RuleID,assertz(X)) :-
    assert(recovery(RuleID,[retract(fact(X))])),
    !.


saveAction(RuleID,retract(X)) :-
    retract(recovery(RuleID,Hist)),
    assert(recovery(RuleID,[assert(fact(X))|Hist])),
    !.


saveAction(RuleID,retract(X)) :-
    assert(recovery(RuleID,[assert(fact(X))])),
    !.


saveAction(_,_) :- !.


undoRule(Rule) :-
    %Recupero le azioni da disfare
    retract(recovery(Rule,Actions)),
    forall(member(Action,Actions),Action).
