:- use_module(library(clpfd)).
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