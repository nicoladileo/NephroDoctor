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

% Module: uncertainty.pl
% --------
%
% This module implements the functionalities to treat uncertainty
% 

certainty(no,-1.0).
certainty(certamenteno,-0.8).
certainty(probabilmenteno,-0.6).
certainty(forseno,-0.4).
certainty(nonso,0).
certainty(forse,0.4).
certainty(probabilmente,0.6).
certainty(certamente,0.8).
certainty(si,1.0).


getUncertainty(Label,Value) :-
    certainty(Label,Value).


computeCFAndConditions(Factors,RuleCF,CH) :-
    min_list(Factors,Min),
    CH is RuleCF * Min.


computeCFOrConditions(Factors,RuleCF,CH) :-
    max_list(Factors,Max),
    CH is RuleCF * Max.


computeCFCombination(Previous,RuleCF,CH) :-
    Temp is 1 - Previous,
    CH is Previous + RuleCF * Temp.
