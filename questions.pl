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

% Module: questions.pl
% --------
%
% This module contains the questions that the system prompt to the user
% 


question([0,21,22],eta,medico,'Inserire età paziente').
question([0,21,22],eta,paziente,'Inserisci la tua età').

question([1],ematuria,medico,'Il paziente presenta ematuria?').
question([1],ematuria,paziente,'Sono visibili evidenti tracce di sangue nelle urine?').

question([2],esamiurine,_,'Sono disponibili gli esami delle urine?').
question([3],esamisangue,_,'Sono disponibili gli esami del sangue?').

question([4],proteinuria,medico,'Inserire valore proteinuria (mg/giornalieri):').
question([5,6],azotemia,medico,'Inserire valore azotemia (mg/dl):').
question([8,9],creatinina,medico,'Inserire valore creatinina (mg/dl):').
question([6,7],dietaproteica,medico,'Il paziente segue un regime alimentare ricco di proteine?').
question([9,10],massamuscolare,medico,'Il paziente presenta ipertrofia muscolare?').

question([11],colesterolo,medico,'Il paziente è affetto da ipercolesterolemia?').
question([11],colesterolo,paziente,'Hai il colesterolo alto?').

question([12],edemi,medico,'Il paziente presenta edemi?').
question([12],edemi,paziente,'Avverti gonfiore alle gambe o in altre parti del corpo?').

question([13],dolore,medico,'Il paziente avverte dolore ai fianchi?').
question([13],dolore,paziente,'Avverti dolori ai fianchi?').

question([14,16,17],consumoacqua,medico,'Quanti bicchieri di acqua consuma al giorno il paziente?').
question([14,16,17],consumoacqua,paziente,'Quanti bicchieri di acqua consumi al giorno?').

question([15,16,17],diarrea,medico,'Il paziente ha avuto recentemente problemi di diarrea?').
question([15,16,17],diarrea,paziente,'Hai avuto recentemente problemi di diarrea?').

question([18],esposizione,medico,'Il paziente è stato esposto a sostanze tossiche?').
question([18],esposizione,paziente,'Sei stato esposto a sostanze tossiche?').

question([19,20],farmaci,medico,'Il paziente ha assunto farmaci recentemente?').
question([19,20],farmaci,paziente,'Hai assunto farmaci recentemente?').

question([20],abusofarmaci,medico,'Il paziente ha abusato di farmaci nefrotossici?').
question([20],abusofarmaci,paziente,'Hai fatto abuso di farmaci antibiotici/antidolorifici?').

question([21],infezioneurinaria,medico,'Il paziente ha sofferto in passato o soffre di infezioni delle vie urinarie?').
question([21],infezioneurinaria,paziente,'Hai sofferto in passato o soffri di infezioni delle vie urinarie?').

question([23],febbre,medico,'Il paziente ha la febbre?').
question([23],febbre,paziente,'Hai la febbre?').

question([24],bruciore,medico,'Il paziente è affetto da disuria?').
question([24],bruciore,paziente,'Avverti bruciore mentre urini?').

question([25],frequenzaminzione,medico,'Con che frequenza avviene la minzione? (numero di volte)').
question([25],frequenzaminzione,paziente,'Quante volte al giorno urini?').

question([26],difficoltaminzione,medico,'Il paziente avverte ostruzione durante la minzione?').
question([26],difficoltaminzione,paziente,'Hai difficoltà a urinare?').

question([27],ereditarieta,medico,'Il paziente ha avuto casi in famiglia di patologie nefrologiche?').
question([27],ereditarieta,paziente,'Hai avuto parenti che hanno sofferto di patologie a carico dei reni?').

question([28],difettigenetici,medico,'Il paziente soffre di malformazioni genetiche a livello renale?').
question([28],difettigenetici,paziente,'Hai malformazioni genetiche a livello dei reni?').

question([29,30,31],ipertensione,medico,'Il paziente soffre di ipertensione?').
question([29,30,31],ipertensione,paziente,'Soffri di ipertensione?').

question([30,31],consumosodio,medico,'Il paziente segue una alimentazione ricca di sodio?').
question([30,31],consumosodio,paziente,'Segui una alimentazione ricca di cibi salati?').


getAllQuestions :-
    fact(modalita(Mode)),
    forall(question([ID|_],Question,Mode,_),(write('Domanda '),write(ID),write(':'),write(Question),nl)),
    !.


getAssociatedRules(Question,Rules) :-
    question(Rules,Question,_,_),
    !.


getQuestion(Question,Mode,Text) :-
    question(_,Question,Mode,Text),
    !.



