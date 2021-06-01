%-------------------------------------------------------------------------------------------------------------------------------------------%
sum_list(L,X):-
                  sum_list(L,0,X).
sum_list([],X,X).
sum_list([H|T], A, S) :-
                             A2 is A + H, 
							 sum_list(T,A2,S).
convertBinToDec(Bin,Dec):-
                             convertBinToDec(Bin,0,[],Dec).
							 
convertBinToDec(0,_,List,Dec):- 
                                     sum_list(List,Dec).
convertBinToDec(Bin,Pos,List,Dec):-
                                     Bin \= 0,
                                     Num is (Bin mod 10),
									 Rest is (Bin // 10),
									 In is ((Num) * (2**Pos)),
									 append(List,[In],List1),
									 Pos1 is Pos+1,
									 convertBinToDec(Rest,Pos1,List1,Dec).
%-------------------------------------------------------------------------------------------------------------------------------------------%
splitEvery(Num, List, Res):-
                                                 splitEvery(Num,0,[],List,Res).
splitEvery(_,_,AccList,[],[AccList]).
splitEvery(Num,Num,AccList,List,[ResH|ResT]):-
                                                 List \= [],
                                                 ResH = AccList,
                                                 splitEvery(Num,0,[],List,ResT).
splitEvery(Num,Acc,AccList,[H|T],Res):-
                                                 Num \= Acc,
                                                 append(AccList,[H],AccList1),
								                 Acc1 is Acc+1,
								                 splitEvery(Num,Acc1,AccList1,T,Res).
%-------------------------------------------------------------------------------------------------------------------------------------------%
replaceIthItem(Item,[_|T],0,[Item|T]).
replaceIthItem(Item,[H|T],I,[H|T1]):-
                                         I \= 0,
										 I1 is I - 1,
                                         replaceIthItem(Item,T,I1,T1).
%-------------------------------------------------------------------------------------------------------------------------------------------%			 
logBase2(1,0).
logBase2(N,Res):-
                     N > 1,
                     N1 is N // 2,
                     logBase2(N1,Res1),
                     Res is Res1 + 1.
%-------------------------------------------------------------------------------------------------------------------------------------------%
getNumBits(_,fullyAssoc,_,0).

getNumBits(NumSets,setAssoc,List,NumBits):-
                                             length(List,N),
											 N1 is N/NumSets,
											 logBase2(N1,NumBits).
getNumBits(_,directMap,List,NumBits):-
                                             length(List,N),
											 logBase2(N,NumBits).
%-------------------------------------------------------------------------------------------------------------------------------------------%
fillZeros(S,0,S).
fillZeros(S,N,R):-
                     N > 0,
                     N1 is N - 1,
                     fillZeros(S,N1,R1),
                     string_concat("0",R1,R).
%-------------------------------------------------------------------------------------------------------------------------------------------%
