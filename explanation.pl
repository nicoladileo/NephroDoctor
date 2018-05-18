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

% Module: explanation.pl
% --------
%
% This module contains the explanation module of the system.

explainQuestion(eta,'Molte patologie nefrologiche sono caratteristiche di una determinata fascia di età.').
explainQuestion(ematuria,'Tracce di sangue nelle urine è uno dei primi sintomi di insufficienza renale.').
explainQuestion(esamiurine,'Sono necessarie le analisi delle urine per eseguire una diagnosi più approfondita.').
explainQuestion(esamisangue,'Sono necessarie le analisi del sangue per eseguire una diagnosi più approfondita.').
explainQuestion(proteinuria,'La proteinuria descrive una condizione in cui è presente una quantità anormale di proteine nelle urine.').
explainQuestion(azotemia,'L\' azotemia è un indicatore della corretta funzionalità renale.').
explainQuestion(creatinina,'La creatinina è un indicatore della corretta funzionalità renale.').
explainQuestion(dietaproteica,'Un alto valore dell\'azotemia può essere dovuto a una dieta iperproteica.').
explainQuestion(massamuscolare,'Un valore di creatinina alto può essere dovuto a un incremento della massa muscolare.').
explainQuestion(colesterolo,'Il colesterolo alto influisce sull\'insorgenza di patologie renali.').
explainQuestion(edemi,'Edemi diffusi nel corpo sono indicatori di patologie renali.').
explainQuestion(dolore,'Il dolore al fianco è il primo indicatore di insufficienza renale.').
explainQuestion(consumoacqua,'Consumare una quantità di acqua adeguata è fondamentale per il corretto funzionamento dei reni.').
explainQuestion(diarrea,'La diarrea può essere sintomo gastrointestinale di insufficienza renale.').
explainQuestion(esposizione,'L\'esposizione a sostanze tossiche può favorire l\'insorgenza di specifiche nefropatie.').
explainQuestion(farmaci,'L\'uso di farmaci costituisce la storia clinica del paziente.').
explainQuestion(abusofarmaci,'L\'abuso di farmaci può favorire l\'insorgenza di specifiche nefropatie.').
explainQuestion(infezioneurinaria,'Un\'infezione urinaria precedentemente non curata può favorire l\'insorgenza di pielonefrite').
explainQuestion(febbre,'Lo stato febbrile può essere associato a infezioni urinarie in atto.').
explainQuestion(bruciore,'Il bruciore avvertito durante la minzione può essere dovuto a infezioni urinarie in atto.').
explainQuestion(frequenzaminzione,'Una minzione frequente è sintomo di infezioni urinarie in atto.').
explainQuestion(difficoltaminzione,'L\'ostruzione delle vie urinerie può essere sintomo di infezioni in atto.').
explainQuestion(ereditarieta,'Molte patologie renali possono essere ereditate.').
explainQuestion(difettigenetici,'Molte patologie renali possono essere dovute a difetti genetici.').
explainQuestion(ipertensione,'L\'ipertensione arteriosa non trattata può essere causa di insufficienza renale.').
explainQuestion(consumosodio,'Il consumo di sodio potrebbe incidere sullo stato di ipertensione.').


explain(Diagnosis,DiagCF) :-
    findall(Symp-CF,(rule _:[diagnosi(Diagnosis,_),sintomo(Symp,_)] ==> _ with salience = _,fact(sintomo(Symp,CF)),CF > 0),Symptoms),
    findall(Val-Meas,(rule _:[diagnosi(Diagnosis,_),valore(Val,Meas),_] ==> _ with salience = _,fact(valore(Val,Meas))),Measures),
    write('Sono arrivato alla diagnosi '),
    upcase_atom(Diagnosis,Up),
    write(Up),
    write(' con certezza '),
    write(DiagCF),
    write(' perchè ho riscontrato:'),
    nl,
    showExplain(Symptoms),
    showExams(Measures).


showExplain([]) :- !.
showExplain([Sympt-CF|Rest]) :-
    write('  --> '),
    write(Sympt),
    write(' con certezza '),
    write(CF),
    nl,
    showExplain(Rest).


showExams([]) :- !.
showExams([Val-Meas|Rest]) :-
    write('  --> '),
    write(Val),
    write(' con valore '),
    write(Meas),
    nl,
    showExams(Rest).

