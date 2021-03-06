%------------------------------------------------------------------------  General  -------------------------------------------------------------------------%
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
					 ResC is Res1 / Res2,
					 Res is ceiling(ResC).
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
getNumBits(_,fullyAssoc,_,0).

getNumBits(NumSets,setAssoc,_,NumBits):-
											 logBase2(NumSets,NumBits).

getNumBits(_,directMap,Cache,NumBits):-
                                             length(Cache,N),
											 logBase2(N,NumBits).
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
fillZeros(S,0,S).

fillZeros(S,N,R):-
                     N > 0,
                     N1 is N - 1,
                     fillZeros(S,N1,R1),
                     string_concat("0",R1,R).
%--------------------------------------------------------------------------------------------------------------------------------------------------------%


%-----------------------------------------------------------------      Direct Map       ----------------------------------------------------------------%
getDataFromCache(StringAddress
,Cache,Data,0,directMap,BitsNum):-
										     getNumBits(_,directMap,Cache,BitsNum),
											 number_string(NumAddress,StringAddress),
											 convertAddress(NumAddress,BitsNum,TagNum,IdxNum,directMap),
											 convertBinToDec(IdxNum,Target),
											 nth0(Target,Cache,Result),
											 Result = item(tag(Tag),data(Data),1,_),
											 number_string(TagNum, Tag).
											 
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
convertAddress(Bin,BitsNum,Tag,Idx,directMap):-
                                                 number_string(Bin,BinString),
                                                 string_length(BinString,N),
												 Len is 6 - N,
												 fillZeros(BinString,Len,BinString1),
                                                 string_concat(Tag1,Idx1,BinString1),
												 string_length(Idx1,BitsNum),
												 number_string(Tag,Tag1),
												 number_string(Idx,Idx1).
												 
%--------------------------------------------------------------------------------------------------------------------------------------------------------%

%-----------------------------------------------------------------   Fully Associative   ----------------------------------------------------------------%
getDataFromCache(StringAddress,Cache
,Data,HopsNum,fullyAssoc,0):-
                                     nth0(HopsNum,Cache,item(tag(StringAddress),data(Data),1,_)).

%--------------------------------------------------------------------------------------------------------------------------------------------------------%

convertAddress(Bin,BitsNum,Bin,Idx,fullyAssoc).
													 
%--------------------------------------------------------------------------------------------------------------------------------------------------------%


%------------------------------------------------------------------   Set Associative    ----------------------------------------------------------------%


getDataFromCache(StringAddress,
Cache,Data,HopsNum,setAssoc,SetsNum):-
                                         number_string(NumAddress, StringAddress),
										 convertAddress(NumAddress, SetsNum, TagNum, IdxNum, setAssoc),
										 length(Cache,L),
										 Split is L / SetsNum ,
										 splitEvery(Split,Cache,CacheSet),
										 convertBinToDec(IdxNum,Location),
										 nth0(Location,CacheSet,CacheLocation),
										 number_string(TagNum,TagString),
										 string_length(TagString,TagLength),
										 getNumBits(SetsNum,setAssoc,_,IdxBits),
										 RequiredLength is 6 - IdxBits,
										 Fill is RequiredLength - TagLength,
										 fillZeros(TagString,Fill,TagString1),
										 Res = item(tag(TagString1),data(Data),1,_),
										 nth0(HopsNum,CacheLocation,Res).
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
convertAddress(Bin,1,Bin,0,setAssoc).

convertAddress(Bin,SetsNum,Tag,Idx,setAssoc):-
                                                 getNumBits(SetsNum,setAssoc,_,IdxBits),
												 number_string(Bin,BinString),
												 string_length(BinString,N),
												 Fill is 6-N,
												 fillZeros(BinString,Fill,BinString1),
                                                 string_concat(Tag1,Idx1,BinString1),
												 string_length(Idx1,IdxBits),
                                                 number_string(Tag,Tag1),
                                                 number_string(Idx,Idx1).

                               
%---------------------------------------------------------------- Replacing Blocks ----------------------------------------------------------------------%

replaceInCache(Tag,Idx,Mem,OldCache
,NewCache,ItemData,directMap,BitsNum):-
                                         number_string(Tag,TagString),
										 string_length(TagString,N),
										 N1 is 6 - BitsNum,
										 Ndiff is N1 - N,
										 fillZeros(TagString,Ndiff,TagString1),
										 number_string(Idx,IdxString),
										 string_length(IdxString,Ni),
										 NiDiff is BitsNum-Ni,
										 fillZeros(IdxString,NiDiff,IdxString1),
                                         string_concat(TagString1,IdxString1,StringMemAddress),
										 number_string(NumMemAddress, StringMemAddress),
										 convertBinToDec(NumMemAddress,NumMemIndex),
										 nth0(NumMemIndex,Mem,ItemData),
										 convertBinToDec(Idx,NumCacheIndex),
										 replaceIthItem(item(tag(TagString1),data(ItemData),1,0),OldCache,NumCacheIndex,NewCache).
%--------------------------------------------------------------------------------------------------------------------------------------------------------%
										 
replaceInCache(Tag,_,Mem,OldCache
,NewCache,ItemData,fullyAssoc,_):-
                                          number_string(Tag,TagString),
										  string_length(TagString,L),
										  Fill is 6 - L,
										  fillZeros(TagString,Fill,TagStringFilled),
										  convertBinToDec(Tag,TagDec),
										  nth0(TagDec,Mem,ItemData),
										  replaceHelper(OldCache,OldCacheIncremented),
										  replaceGetInvalidBit(OldCacheIncremented,0,IdxReplace),
										  replaceIthItem(item(tag(TagStringFilled),data(ItemData),1,0),OldCacheIncremented,IdxReplace,NewCache).
										  
replaceInCache(Tag,_,Mem,OldCache
,NewCache,ItemData,fullyAssoc,_):-
                                          number_string(Tag,TagString),
										  string_length(TagString,L),
										  Fill is 6 - L,
										  fillZeros(TagString,Fill,TagStringFilled),
										  convertBinToDec(Tag,TagDec),
										  nth0(TagDec,Mem,ItemData),
										  replaceHelper(OldCache,OldCacheIncremented),
										  \+replaceGetInvalidBit(OldCacheIncremented,0,_),
										  length(OldCacheIncremented,L1),
										  BiggestOrder is L1,
										  nth0(IdxReplace,OldCacheIncremented,item(tag(_),data(_),1,BiggestOrder)),
										  replaceIthItem(item(tag(TagStringFilled),data(ItemData),1,0),OldCacheIncremented,IdxReplace,NewCache).

%--------------------------------------------------------------------------------------------------------------------------------------------------------%
replaceInCache(Tag,Idx,Mem,OldCache
,NewCache,ItemData,setAssoc,SetsNum):-
                                         number_string(Tag,TagString),
										 string_length(TagString,N),
										 getNumBits(SetsNum,setAssoc,_,BitsNum),
										 N1 is 6 - BitsNum,
										 Ndiff is N1 - N,
										 fillZeros(TagString,Ndiff,TagString1),
										 number_string(Idx,IdxString),
										 string_length(IdxString,Ni),
										 NiDiff is BitsNum-Ni,
										 fillZeros(IdxString,NiDiff,IdxString1),
                                         string_concat(TagString1,IdxString1,StringMemAddress),
										 number_string(NumMemAddress, StringMemAddress),
										 convertBinToDec(NumMemAddress,NumMemIndex),
										 nth0(NumMemIndex,Mem,ItemData),
										 length(OldCache,L),
										 convertBinToDec(Idx,IdxSubList),
										 Split is L / SetsNum ,
										 splitEvery(Split,OldCache,OldCacheRes),
										 nth0(IdxSubList,OldCacheRes,TargetList),
										 replaceHelper(TargetList,OldCacheIncremented),
										 replaceGetInvalidBit(OldCacheIncremented,0,IdxReplace),
										 replaceIthItem(item(tag(TagString1),data(ItemData),1,0),OldCacheIncremented,IdxReplace,NewCacheSubList),
										 replaceIthItem(NewCacheSubList,OldCacheRes,IdxSubList,NewCacheUnflattened),
										 flatten(NewCacheUnflattened,NewCache).
										 
replaceInCache(Tag,Idx,Mem,OldCache
,NewCache,ItemData,setAssoc,SetsNum):-
                                         number_string(Tag,TagString),
										 string_length(TagString,N),
										 getNumBits(SetsNum,setAssoc,_,BitsNum),
										 N1 is 6 - BitsNum,
										 Ndiff is N1 - N,
										 fillZeros(TagString,Ndiff,TagString1),
										 number_string(Idx,IdxString),
										 string_length(IdxString,Ni),
										 NiDiff is BitsNum-Ni,
										 fillZeros(IdxString,NiDiff,IdxString1),
                                         string_concat(TagString1,IdxString1,StringMemAddress),
										 number_string(NumMemAddress, StringMemAddress),
										 convertBinToDec(NumMemAddress,NumMemIndex),
										 nth0(NumMemIndex,Mem,ItemData),
										 length(OldCache,L),
										 convertBinToDec(Idx,IdxSubList),
										 Split is L / SetsNum ,
										 splitEvery(Split,OldCache,OldCacheRes),
										 nth0(IdxSubList,OldCacheRes,TargetList),
										 replaceHelper(TargetList,OldCacheIncremented),
										 \+replaceGetInvalidBit(OldCacheIncremented,0,_),
										 length(OldCacheIncremented,L1),
										 BiggestOrder is L1,
										 nth0(IdxReplace,OldCacheIncremented,item(tag(_),data(_),1,BiggestOrder)),
										 replaceIthItem(item(tag(TagString1),data(ItemData),1,0),OldCacheIncremented,IdxReplace,NewCachSublist),
										 replaceIthItem(NewCacheSubList,OldCacheRes,IdxSubList,NewCacheUnflattened),
										 flatten(NewCacheUnflattened,NewCache).
										 
%--------------------------------------------------------------------------------------------------------------------------------------------------------%

replaceGetInvalidBit([item(tag(_),data(_),0,_)|_],Acc,Acc).
replaceGetInvalidBit([item(tag(_),data(_),1,_)|T],Acc,N):-
                                                             Acc1 is Acc+1,
															 replaceGetInvalidBit(T,Acc1,N).
replaceHelper([],[]).

replaceHelper([item(tag(Tag),data(Data),1,Order)|T], 
[item(tag(Tag),data(Data),1,Order1)|T1]):-  
                                                     Order1 is Order+1,
                                                     replaceHelper(T,T1).
	
replaceHelper([item(tag(Tag),data(Data),0,Order)|T], 
[item(tag(Tag),data(Data),0,Order)|T1]):-  
                                                     replaceHelper(T,T1).													 
                                         
%--------------------------------------------------------------------------------------------------------------------------------------------------------%


%---------------------------------------------------------------- Main Predicates -----------------------------------------------------------------------%
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
                                                                 (Type = setAssoc, Num = NumOfSets; Type \= setAssoc, Num = BitsNum),
                                                                 getData(Address,OldCache,Mem,NewCache,Data,HopsNum,Type,Num,Status),
                                                                 runProgram(AdressList,NewCache,Mem,FinalCache,OutputDataList,StatusList,
                                                                 Type,NumOfSets).
