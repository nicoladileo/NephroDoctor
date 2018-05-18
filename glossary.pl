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

% Module: glossary.pl
% --------
%
% This module contains the glossary to explain unkown meanings of terms


concept('azotemia','È il tasso della quantità di azoto nel sangue ed indica con precisione la funzionalità dei reni; valori diversi da quelli di riferimento indicano una imperfetta depurazione del sangue da parte dei reni. Sono ritenuti normali valori da 10-45 mg/dl').

concept('colesterolo','È una molecola della famiglia degli steroli responsabile di diversi compiti nell\'organismo, principalmente durante la sintesi di componenti indispensabili per la digestione'). 

concept('creatinina','È un componente del sangue che viene eliminato con l\'urina; segnala la funzionalità del rene in quanto viene eliminata dai reni stessi attraverso l\'urina. Sono ritenuti normali valori da 0-1 mg/dl').

concept('ematuria','L\'emautria è definita come la presenza di sangue nelle urine').

concept('edema','L\'edema è un gonfiore derivante dall\'accumulo di liquido negli spazi interstiziali dell\'organismo').

concept('glomerulo','Il glomerulo renale è una fitta rete sferoidale di capillari arteriosi, deputata alla filtrazione del sangue.').

concept('glomerulonefrite','La glomerulonefrite è un\'infiammazione che interessa i reni e in particolare i glomeruli renali compromettendo la capacità filtrante dell\'organo stesso').

concept('insufficienza renale','L\'insufficienza renale rappresenta l\'impossibilità del rene di svolgere la sua naturale funzione filtrante. Può essere acuta se compare bruscamente o cronica se il suo decorso è lento e graduale').

concept('ipertensione','L\'ipertensione è una condizione clinica in cui la pressione del sangue nelle arterie è oltre i valori normali di 110/80').

concept('nefropatia interstiziale','La nefropatia interstiziale è un\'insufficienza renale acuta che interessa principalmente i tubuli renali e il tessuto interstiziale.').

concept('pelvi','La pelvi renale rappresenta l\'entità anatomica che accoglie l\'urina e la convoglia nell\'uretere').

concept('pielonefrite','La pielonefrite è una malattia infiammatoria, acuta o cronica, del rene e della pelvi renale.').

concept('proteinuria','È la quantità di proteine nelle urine. I reni non dovrebbero lasciare passare le proteine nell\'urina (vengono bloccate prima) in quanto sono sostanze molto importanti per l’organismo e non possono essere smaltite. Valori normali fino a 500 mg').

concept('rene policistico','Il rene policistico è una patologia genetica nella quale il normale tessuto renale viene sostituito da numerose cisti.').

concept('sindrome nefrosica','La sindrome nefrosica è una patologia causata da una alterazione dei glomeruli renali che comporta una perdita di proteine con le urine'). 

concept('tubulo renale','Il tubulo ha la funzione di modificare, tramite processi di riassorbimento e secrezione, la composizione dell\'ultrafiltrato prodotto dal glomerulo').


glossary :-
    forall(concept(Conc,Mean),(nl,upcase_atom(Conc,Up),write(Up),write(':'),write(Mean),nl)).
