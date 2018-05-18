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

% Module: knowledge.pl
% --------
%
% This module contains the rules that constitutes the knowledge of
% the expert system and the functionality to update Knowledge Base 

:- op(230, xfx, ==>).
:- op(32, xfy, :).
:- op(250, fx, rule).
:- op(400, xfy, with).
:- op(400, xfy, salience).
:- op(400, xfy, =).

:- dynamic fact/1.


%% Initialize system
rule 2000:
[]
==>
[print('Benvenuto in Nephrodoctor, il sistema esperto per la diagnosi di nefropatie'),
 print('Durante l\'esecuzione digita stato o perchè per ricevere aiuto. Digita glossario per ottenere informazioni sui termini sconosciuti'),
 assert(diagnosi('insufficienza renale',0.0)),
 assert(diagnosi('sindrome nefrosica',0.0)),
 assert(diagnosi('rene policistico',0.0)),
 assert(diagnosi(pielonefrite,0.0)),
 assert(diagnosi(glomerulonefrite,0.0)),
 assert(diagnosi('nefropatia interstiziale',0.0))
]
with salience = -200.


rule 1000:
[]
==>
[print('L\'utente è un medico o un paziente?'),read(X),assert(modalita(X))]
with salience = -100.


rule 0:
[]
==>
[readInput(eta,X,number),assert(eta(X))]
with salience = 10.


rule 1:
[]
==>
[readInput(ematuria,X,multiple),getUncertainty(X,Val),assert(sintomo(ematuria,Val))]
with salience = 10.


rule 2:
[modalita(medico)]
==>
[readInput(esamiurine,X),assert(esamiurine(X))]
with salience = 10.


rule 3:
[modalita(medico)]
==>
[readInput(esamisangue,X),assert(esamisangue(X))]
with salience = 10.


rule 4:
[modalita(medico),esamiurine(si)]
==>
[readInput(proteinuria,X,number),assert(valore(proteinuria,X))]
with salience = 5.


rule 5:
[modalita(medico),esamisangue(si)]
==>
[readInput(azotemia,X,number),assert(valore(azotemia,X))]
with salience = 5.


rule 6:
[valore(azotemia,A), A > 45]
==>
[readInput(dietaproteica,X,multiple),getUncertainty(X,Val),assert(dietaproteica(Val))]
with salience = 0.


rule 7:
[dietaproteica(Val),Val > 0.6]
==>
[retract(valore(azotemia,_)),assert(valore(azotemia,0.2))]
with salience = 0.


rule 8:
[modalita(medico),esamisangue(si)]
==>
[readInput(creatinina,X,number),assert(valore(creatinina,X))]
with salience = 5.


rule 9:
[valore(creatinina,C), C > 1]
==>
[readInput(massamuscolare,X,multiple),getUncertainty(X,Val),assert(massamuscolare(Val))]
with salience = 0.


rule 10:
[massamuscolare(Val),Val > 0.6]
==>
[retract(valore(creatinina,_)),assert(valore(creatinina,0.2))]
with salience = 0.


rule 11:
[]
==>
[readInput(colesterolo,X,multiple),getUncertainty(X,Val),assert(sintomo(colesterolo,Val))]
with salience = 10.


rule 12:
[]
==>
[readInput(edemi,X,multiple),getUncertainty(X,Val),assert(sintomo(edemi,Val))]
with salience = 10.


rule 13:
[]
==>
[readInput(dolore,X,multiple),getUncertainty(X,Val),assert(sintomo(dolore,Val))]
with salience = 10.


rule 14:
[]
==>
[readInput(consumoacqua,X,number),assert(consumoacqua(X))]
with salience = 10.


rule 15:
[]
==>
[readInput(diarrea,X,multiple),getUncertainty(X,Val),assert(sintomo(diarrea,Val))]
with salience = 10.


rule 16:
[consumoacqua(X), X < 9, sintomo(diarrea,Val), Val > 0.6]
==>
[diff(8.1,X,H),div(H,8.1,CF),assert(sintomo(disidratazione,CF))]
with salience = 5.


rule 17:
[consumoacqua(X), X < 9, sintomo(diarrea,Val), Val =< 0.6]
==>
[diff(8.1,X,H),div(H,8.1,CF),mul(CF,0.7,CF1),assert(sintomo(disidratazione,CF1))]
with salience = 5.


rule 18:
[]
==>
[readInput(esposizione,X,multiple),getUncertainty(X,Val),assert(sintomo(esposizione,Val))]
with salience = 10.


rule 19:
[]
==>
[readInput(farmaci,X),assert(farmaci(X))]
with salience = 10.


rule 20:
[farmaci(si)]
==>
[readInput(abusofarmaci,X,multiple),getUncertainty(X,Val),assert(sintomo(abusofarmaci,Val))]
with salience = 5.


rule 21:
[eta(E),E > 18]
==>
[readInput(infezioneurinaria,X,multiple),getUncertainty(X,Val),assert(sintomo(infezioneurinaria,Val))]
with salience = 15.


rule 22:
[sintomo(infezioneurinaria,CF), CF > 0, eta(E), E < 12]
==>
[retract(sintomo(infezioneurinaria,CF)),diff(CF,0.2,CH),assert(sintomo(infezioneurinaria,CH))]
with salience = 5.


rule 23:
[sintomo(infezioneurinaria,_)]
==>
[readInput(febbre,X,multiple),getUncertainty(X,Val),assert(sintomo(febbre,Val))]
with salience = 5.


rule 24:
[]
==>
[readInput(bruciore,X,multiple),getUncertainty(X,Val),assert(sintomo(bruciore,Val))]
with salience = 15.


rule 25:
[]
==>
[readInput(frequenzaminzione,X,number),assert(sintomo(frequenzaminzione,X))]
with salience = 15.


rule 26:
[]
==>
[readInput(difficoltaminzione,X,multiple),getUncertainty(X,Val),assert(sintomo(difficoltaminzione,Val))]
with salience = 15.


rule 27:
[]
==>
[readInput(ereditarieta,X,multiple),getUncertainty(X,Val),assert(sintomo(ereditarieta,Val))]
with salience = 15.


rule 28:
[]
==>
[readInput(difettigenetici,X,multiple),getUncertainty(X,Val),assert(sintomo(difettigenetici,Val))]
with salience = 15.


rule 29:
[]
==>
[readInput(ipertensione,X,multiple),getUncertainty(X,Val),assert(sintomo(ipertensione,Val))]
with salience = 15.


rule 30:
[sintomo(ipertensione,_)]
==>
[readInput(consumosodio,X),assert(consumosodio(X))]
with salience = 5.


rule 31:
[sintomo(ipertensione,I), I < 1, consumosodio(si)]
==>
[retract(sintomo(ipertensione,I)),sum(I,0.2,CF),assert(sintomo(ipertensione,CF))]
with salience = 5.



%% Glomerulonefrite start
rule 100:
[diagnosi(glomerulonefrite,Previous),sintomo(colesterolo,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(glomerulonefrite,_)),assert(diagnosi(glomerulonefrite,CH))]
with salience = 0.


rule 101:
[diagnosi(glomerulonefrite,Previous),sintomo(ematuria,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(glomerulonefrite,_)),assert(diagnosi(glomerulonefrite,CH))]
with salience = 0.


rule 102:
[diagnosi(glomerulonefrite,Previous),valore(proteinuria,P),P > 3500]
==>
[computeCFCombination(Previous,0.9,CH),retract(diagnosi(glomerulonefrite,_)),assert(diagnosi(glomerulonefrite,CH))]
with salience = 0.


rule 103:
[diagnosi(glomerulonefrite,Previous),sintomo(edemi,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(glomerulonefrite,_)),assert(diagnosi(glomerulonefrite,CH))]
with salience = 0.


rule 104:
[diagnosi(glomerulonefrite,Previous),sintomo(brucioreminzione,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(glomerulonefrite,_)),assert(diagnosi(glomerulonefrite,CH))]
with salience = 0.


rule 105:
[diagnosi(glomerulonefrite,Previous),sintomo(frequenzaminzione,N), N > 10]
==>
[computeCFCombination(Previous,0.8,CH),retract(diagnosi(glomerulonefrite,_)),assert(diagnosi(glomerulonefrite,CH))]
with salience = 0.


rule 106:
[diagnosi(glomerulonefrite,Previous),sintomo(difficoltaminzione,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(glomerulonefrite,_)),assert(diagnosi(glomerulonefrite,CH))]
with salience = 0.


rule 107:
[diagnosi(glomerulonefrite,Previous),sintomo(ipertensione,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(glomerulonefrite,_)),assert(diagnosi(glomerulonefrite,CH))]
with salience = 0.
%% Glomerulonefrite end



%% Sindrome nefrosica start
rule 200:
[diagnosi('sindrome nefrosica',Previous),sintomo(colesterolo,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('sindrome nefrosica',_)),assert(diagnosi('sindrome nefrosica',CH))]
with salience = 0.


rule 201:
[diagnosi('sindrome nefrosica',Previous),sintomo(ematuria,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('sindrome nefrosica',_)),assert(diagnosi('sindrome nefrosica',CH))]
with salience = 0.


rule 202:
[diagnosi('sindrome nefrosica',Previous),valore(proteinuria,P),P > 3500]
==>
[computeCFCombination(Previous,0.9,CH),retract(diagnosi('sindrome nefrosica',_)),assert(diagnosi('sindrome nefrosica',CH))]
with salience = 0.


rule 203:
[diagnosi('sindrome nefrosica',Previous),sintomo(edemi,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('sindrome nefrosica',_)),assert(diagnosi('sindrome nefrosica',CH))]
with salience = 0.
%% Sindrome nefrosica end



%% Insufficienza renale start
rule 300:
[diagnosi('insufficienza renale',Previous),sintomo(dolore,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('insufficienza renale',_)),assert(diagnosi('insufficienza renale',CH))]
with salience = 0.


rule 301:
[diagnosi('insufficienza renale',Previous),sintomo(ematuria,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('insufficienza renale',_)),assert(diagnosi('insufficienza renale',CH))]
with salience = 0.


rule 302:
[diagnosi('insufficienza renale',Previous),valore(proteinuria,P), P > 3500]
==>
[computeCFCombination(Previous,0.9,CH),retract(diagnosi('insufficienza renale',_)),assert(diagnosi('insufficienza renale',CH))]
with salience = 0.


rule 303:
[diagnosi('insufficienza renale',Previous),sintomo(disidratazione,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('insufficienza renale',_)),assert(diagnosi('insufficienza renale',CH))]
with salience = 0.


rule 304:
[diagnosi('insufficienza renale',Previous),valore(azotemia,A),A > 65]
==>
[computeCFCombination(Previous,0.8,CH),retract(diagnosi('insufficienza renale',_)),assert(diagnosi('insufficienza renale',CH))]
with salience = 0.


rule 305:
[diagnosi('insufficienza renale',Previous),valore(creatinina,C),C > 1]
==>
[computeCFCombination(Previous,0.8,CH),retract(diagnosi('insufficienza renale',_)),assert(diagnosi('insufficienza renale',CH))]
with salience = 0.
%% Insufficienza renale end



%% Nefropatia interstiziale start
rule 400:
[diagnosi('nefropatia interstiziale',Previous),sintomo(esposizione,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('nefropatia interstiziale',_)),assert(diagnosi('nefropatia interstiziale',CH))]
with salience = 0.


rule 401:
[diagnosi('nefropatia interstiziale',Previous),sintomo(abusofarmaci,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('nefropatia interstiziale',_)),assert(diagnosi('nefropatia interstiziale',CH))]
with salience = 0.
%% Nefropatia interstiziale end



%% Rene policistico start
rule 500:
[diagnosi('rene policistico',Previous),sintomo(difettigenetici,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('rene policistico',_)),assert(diagnosi('rene policistico',CH))]
with salience = 0.


rule 501:
[diagnosi('rene policistico',Previous),sintomo(ereditarieta,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('rene policistico',_)),assert(diagnosi('rene policistico',CH))]
with salience = 0.


rule 502:
[diagnosi('rene policistico',Previous),sintomo(infezioneurinaria,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi('rene policistico',_)),assert(diagnosi('rene policistico',CH))]
with salience = 0.
%% Rene policistico end



%% Pielonefrite start
rule 600:
[diagnosi(pielonefrite,Previous),sintomo(febbre,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(pielonefrite,_)),assert(diagnosi(pielonefrite,CH))]
with salience = 0.


rule 601:
[diagnosi(pielonefrite,Previous),sintomo(difettigenetici,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(pielonefrite,_)),assert(diagnosi(pielonefrite,CH))]
with salience = 0.


rule 602:
[diagnosi(pielonefrite,Previous),sintomo(bruciore,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(pielonefrite,_)),assert(diagnosi(pielonefrite,CH))]
with salience = 0.


rule 603:
[diagnosi(pielonefrite,Previous),sintomo(difficoltaminzione,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(pielonefrite,_)),assert(diagnosi(pielonefrite,CH))]
with salience = 0.


rule 604:
[diagnosi(pielonefrite,Previous),sintomo(infezioneurinaria,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(pielonefrite,_)),assert(diagnosi(pielonefrite,CH))]
with salience = 0.


rule 605:
[diagnosi(pielonefrite,Previous),sintomo(dolore,CF)]
==>
[computeCFCombination(Previous,CF,CH),retract(diagnosi(pielonefrite,_)),assert(diagnosi(pielonefrite,CH))]
with salience = 0.
%% Pielonefrite end


