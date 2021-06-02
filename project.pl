%--------------------------------------------------------------------------------------------------------------------------------------------------------%
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
									 
sum_list(L,X):-
                  sum_list(L,0,X).
				  
sum_list([],X,X).

sum_list([H|T], A, S) :-
                             A2 is A + H, 
							 sum_list(T,A2,S).
							 
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
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
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
replaceIthItem(Item,[_|T],0,[Item|T]).

replaceIthItem(Item,[H|T],I,[H|T1]):-
                                         I \= 0,
										 I1 is I - 1,
                                         replaceIthItem(Item,T,I1,T1).
%--------------------------------------------------------------------------------------------------------------------------------------------------------%		 
logBase2(N,Res):-
                     log10(N,Res1),
					 log10(2,Res2),
					 Res is Res1 / Res2.
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
getNumBits(_,fullyAssoc,_,0).

getNumBits(NumSets,setAssoc,_,NumBits):-
											 logBase2(NumSets,NumBits).

getNumBits(_,directMap,List,NumBits):-
                                             length(List,N),
											 logBase2(N,NumBits).
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
fillZeros(S,0,S).

fillZeros(S,N,R):-
                     N > 0,
                     N1 is N - 1,
                     fillZeros(S,N1,R1),
                     string_concat("0",R1,R).
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
%Your code here%
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,hit):-
                                                                                 getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
                                                                                 NewCache = OldCache.

getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,miss):-
                                                                                 \+getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
                                                                                 atom_number(StringAddress,Address),
                                                                                 convertAddress(Address,BitsNum,Tag,Idx,Type),
                                                                                 replaceInCache(Tag,Idx,Mem,OldCache,NewCache,Data,Type,BitsNum).
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
runProgram([],OldCache,_,OldCache,[],[],Type,_).
runProgram([Address|AdressList],OldCache,Mem,FinalCache,
[Data|OutputDataList],[Status|StatusList],Type,NumOfSets):-
                                                                 getNumBits(NumOfSets,Type,OldCache,BitsNum),
                                                                 getData(Address,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,Status),
                                                                 runProgram(AdressList,NewCache,Mem,FinalCache,OutputDataList,StatusList,
                                                                 Type,NumOfSets).