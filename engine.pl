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

% Module: engine.pl
% --------
%
% This module contains the inference engine of the system. This constitute 
% the core of nephrodoctor

:- ensure_loaded(knowledge).
:- ensure_loaded(explanation).
:- ensure_loaded(history).
:- ensure_loaded(list_utils).
:- ensure_loaded(questions).
:- ensure_loaded(uncertainty).
:- ensure_loaded(file_utils).
:- ensure_loaded(glossary).

:- dynamic open/1.
:- dynamic closed/1.


open([]).
closed([]).


% Engine core
% --------
run :-
	conflictSet,
	getFirstRule(RuleID-Sal),
	fire(RuleID-Sal),
	setClosedRule(RuleID),
	!,
	run.


run :-
    findall(Diag,fact(diagnosi(Diag,0.0)), Diagnosis),
    length(Diagnosis,6),
    write('Non sono riuscito a trovare una diagnosi'),
    nl,
    reExecute,
    !.


run :-
    getStatus,
    reExecute,
    !.


activable(RuleID) :-
	closed(L),
	not(member(RuleID,L)).


conflictSet :-
    findall(ID-Sal,(call(rule ID:LHS ==> _ with salience = Sal),activable(ID),not(ready(ID)),matchConditions(LHS)),Rules),
    updateOpen(Rules).
        

findFact([]) :- !.
findFact([LHSPrem|LHSRest]) :-
    fact(LHSPrem),
    findFact(LHSRest).


findFact([_|LHSRest]) :-
    findFact(LHSRest),
    !.


fire(RuleID-Sal) :-
	call(rule RuleID: LHS ==> RHS with salience = Sal),
	findFact(LHS),     
	process(RuleID,RHS).    


getFirstRule(RuleID-Sal) :-
	retract(open([RuleID-Sal|Rest])),
	assert(open(Rest)).


getStatus :-
     write('Il sistema è eseguito in modalità '),
     fact(modalita(Mode)),
     write(Mode),
     nl,
     write('Sono arrivato alle seguenti diagnosi:'),
     nl,
     findall(Diag-CF,(fact(diagnosi(Diag,CF)), CF > 0.0),Diagnosis),
     sortDiagnosis(Diagnosis,Sorted),
     forall((member(D-C,Sorted),C > 0),explain(D,C)).


matchConditions([]) :- !.
matchConditions([Prem|Rest]) :-
	(fact(Prem);
	 test(Prem)),
	matchConditions(Rest),
	!.


modifyAnswer(Quest) :-
    (fact(sintomo(Quest,Val)) ; fact(valore(Quest,Val))),
    write('Risposta precedente: '),
    getUncertainty(Ans,Val),
    write(Ans),
    nl,
    retract(closed(Closed)),
    retract(open(_)),
    getAssociatedRules(Quest,AssociatedRules),
    findall(RuleID,(member(RuleID,Closed),member(RuleID,AssociatedRules)),Rules),
    findall(DiagID,(member(DiagID,Closed),DiagID >= 100, DiagID < 999),DiagRules),
    recoverState(Rules),         
    recoverState(DiagRules),
    difference(Closed,Rules,TempClosed),
    difference(TempClosed,DiagRules,UpdatedClosed),
    assert(closed(UpdatedClosed)),
    assert(open([])),
    run,
    !.


modifyFlow(Answ) :-
    retract(closed(Closed)),
    retract(open(_)),
    question([ID|_],Answ,_,_),
    extractSubList(Closed,ID,NewClosed),
    recoverState(NewClosed),
    difference(Closed,NewClosed,UpdatedClosed),
    assert(closed(UpdatedClosed)),
    assert(open([])),
    !.


process(_,[]) :- !.
process(RuleID,[Action|Rest]) :-
	take(Action),
	saveAction(RuleID,Action),   
	process(RuleID,Rest).
	

ready(RuleID) :-
	open(L),
	memberRule(RuleID,L).


reExecute :- 
    write('Vuoi far ripartire il sistema da una domanda specifica o modificare una risposta data? (domande/glossario/modifica/riparti/termina)'),
    nl,
    read(X),
    (
    X == glossario,
    glossary,
    reExecute
    ;
    X == domande,
    getAllQuestions,
    reExecute
    ;
    X == riparti,
    write('Da quale domanda vuoi ripartire?'),
    read(Quest),
    nl,
    modifyFlow(Quest),
    run
    ;
    X == modifica,
    write('Quale risposta vuoi modificare?'),
    read(Quest),
    nl,
    modifyAnswer(Quest),
    run
    ;
    X == termina,
    createFileName(Filename),
    writeResultsOnFile(Filename),
    write('Arrivederci...'),
    nl,
    fail
    ).


setClosedRule(RuleID) :-
	retract(closed(Rules)),
	assert(closed([RuleID|Rules])).


take(assert(X)) :-
	assert(fact(X)),
	!.


take(asserta(X)) :-
	asserta(fact(X)),
	!.


take(assertz(X)) :-
	assertz(fact(X)),
	!.


take(retract(X)) :-
	retract(fact(X)),
	!.
    

take(reloadall(X)) :-
	retract(open(_)),
	retract(closed(_)),
	assert(open([])),
	assert(closed([])),
	abolish(fact/1),
	reconsult(X).


take(getUncertainty(X,Val)) :-
    getUncertainty(X,Val).


take(computeCFCombination(Prev,CF,CH)) :-
    computeCFCombination(Prev,CF,CH).


take(print(X)) :-
	write(X),
	nl,
	!.


take(printQuestion(X)) :-
	fact(modalita(Mode)),
	question(_,X,Mode,Text),
	write(Text),
	nl,
	!.


take(printQuestion(X,multiple)) :-
	fact(modalita(Mode)),
	question(_,X,Mode,Text),
	write(Text),
	write(' (no/certamenteno/probabilementeno/forseno/nonso/forse/probabilmente/certamente/si)'),
	nl,
	!.


take(read(X)) :-
    read(X),
    nl,
    !.


take(readInput(Question,Answer,multiple)) :-
    fact(modalita(Mode)),
    getQuestion(Question,Mode,Text),
    write(Text),
    write(' (no/certamenteno/probabilementeno/forseno/nonso/forse/probabilmente/certamente/si)'),
    read(X),
    (
    X == glossario,
    glossary,
    take(readInput(Question,Answer,multiple))
    ;
    X == stato,
    getStatus,
    take(readInput(Question,Answer,multiple))
    ;
    X \= perchè, X \= stato, X \= glossario,
    nl,
    Answer = X
    ;
    X == perchè,
    explainQuestion(Question,Expl),
    write(Expl),
    nl,
    take(readInput(Question,Answer,multiple))
    ).


take(readInput(Question,Answer)) :-
    fact(modalita(Mode)),
    getQuestion(Question,Mode,Text),
    write(Text),
    write(' (no/nonso/si)'),
    read(X),
    (
    X == glossario,
    glossary,
    take(readInput(Question,Answer))
    ;
    X == stato,
    getStatus,
    take(readInput(Question,Answer))
    ;
    X \= perchè, X \= stato, X \= glossario,
    nl,
    Answer = X
    ;
    X == perchè,
    explainQuestion(Question,Expl),
    write(Expl),
    nl,
    take(readInput(Question,Answer))
    ).


take(readInput(Question,Answer,number)) :-
    fact(modalita(Mode)),
    getQuestion(Question,Mode,Text),
    write(Text),
    write(' (nonso)'),
    read(X),
    (
    X == glossario,
    glossary,
    take(readInput(Question,Answer,number))
    ;
    X == stato,
    getStatus,
    take(readInput(Question,Answer,number))
    ;
    X \= perchè, X == nonso,
    nl,
    Answer = 0
    ;
    X \= perchè, X \= nonso, X \= stato, X \= glossario,
    nl,
    Answer = X
    ;
    X == perchè,
    explainQuestion(Question,Expl),
    write(Expl),
    nl,
    take(readInput(Question,Answer,number))
    ).     


% Arithmetic operators
% --------
take(sum(X,Y,Z)) :-
    Z is X + Y,
    !.


take(diff(X,Y,Z)) :-
    Z is X - Y,
    !.


take(mul(X,Y,Z)) :-
    Z is X * Y,
    !.


take(div(X,Y,Z)) :-
    Z is X / Y,
    !.


test(not(X)) :-
    not(fact(X)),
    !.


% Boolean tests
% --------
test(X < Y) :-
	X < Y,
	!.


test(X > Y) :-
	X > Y,
	!.


test(X >= Y) :-
    X >= Y,
    !.


test(X =< Y) :-
    X =< Y,
    !.


test(X == Y) :-
	X == Y,
	!.


updateOpen(Rules) :-
        forall(member(ID-Sal,Rules),(retract(open(Old)),insertRule(ID-Sal,Old,New),assert(open(New)))).
