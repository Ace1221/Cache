fillZeros(String,0,String).
fillZeros(String,N,R):-
    N >= 0,
    N1 is N - 1,
    fillZeros(String,N1,R1),
    string_concat(0,R1,R).