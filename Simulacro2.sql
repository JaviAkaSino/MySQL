/*
ESQUEMA RELACIONAL

OPCIÓN A:
sujetos(pk(codsujeto), nomsujeto)
clientela(pk(codcliente), estadocivil, codsujeto*)
abogados(pk(codabogado), numcolegiado, codsujeto*)
tipocasos(pk(codtipocaso), destipocaso)
casos(pk(codtipocaso, codcaso*), nomcaso, codcliente*)
llevan(pk(codabogado*,[codtipocaso,codcaso]*, fenicidio), numdias)
*/