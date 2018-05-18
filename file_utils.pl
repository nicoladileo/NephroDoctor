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

% Module: file_utils.pl
% --------
%
% This module contains the utility to read and write contents on file


createFileName(Filename) :-
     get_time(T),
     stamp_date_time(T,Date,'UTC'),
     arg(1,Date,Year),
     arg(2,Date,Month),
     arg(3,Date,Day),
     arg(4,Date,Hour),
     arg(5,Date,Minute),
     atomic_list_concat(['Diagnosis_',Year,Month,Day,Hour,Minute,'.txt'],Filename).


writeResultsOnFile(Filename) :-
     open(Filename,write,Stream),
     write(Stream,'===================================='),
     nl(Stream),
     write(Stream,'Risultati Nephrodoctor'),
     nl(Stream),
     fact(modalita(Mode)),
     write(Stream,'===================================='),
     nl(Stream),
     nl(Stream),
     write(Stream,'Sistema eseguito in modalità '),
     write(Stream,Mode),
     nl(Stream),
     nl(Stream),
     write(Stream,'Diagnosi raggiunte'),
     nl(Stream),
     nl(Stream),
     writeDiagnosisOnFile(Stream),
     close(Stream).


writeDiagnosisOnFile(Stream) :-
    findall(Diag-CF,(fact(diagnosi(Diag,CF)), CF > 0.0),Diagnosis),
    sortDiagnosis(Diagnosis,Sorted),
    forall(member(Diag-CF,Sorted),
	   (upcase_atom(Diag,Up),write(Stream,Up),write(Stream,' con certezza '),write(Stream,CF),
	    write(Stream,'. Sintomi riscontrati'),nl(Stream),writeSymptomsOnFile(Stream,Diag))).


writeSymptomsOnFile(Stream,Diag) :-
    findall(Symp-CF,(rule _:[diagnosi(Diag,_),sintomo(Symp,_)] ==> _ with salience = _,fact(sintomo(Symp,CF)),CF > 0),Symptoms),
    findall(Val-Meas,(rule _:[diagnosi(Diag,_),valore(Val,Meas),_] ==> _ with salience = _,fact(valore(Val,Meas))),Measures),
    forall(member(Symp-CF,Symptoms),(write(Stream,' -'),write(Stream,Symp),write(Stream,' certezza '),write(Stream,CF),nl(Stream))),
    forall(member(Val-Meas,Measures),(write(Stream,' -'),write(Stream,Val),write(Stream,' valore '),write(Stream,Meas),nl(Stream))),
    nl(Stream).
    
