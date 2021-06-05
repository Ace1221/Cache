getDataFromCache(StringAddress, [item(tag(StringAddress),data(Data),HopsNum,_)|_], Data, HopsNum, fullyAssoc, BitsNum).
getDataFromCache(StringAddress,[item(tag(X),data(_),_,_)|T],Data,HopsNum,fullyAssoc,BitsNum):-
    \+(X == StringAddress),
    getDataFromCache(StringAddress,T,Data,HopsNum,fullyAssoc,BitsNum).


convertAddress(Bin,BitsNum,Tag,Idx,fullyAssoc):-
    atom_number(Tag1, Bin),
    atom_number(Tag1, Tag).

    




getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,hit):-
                                                                                 getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
                                                                                 NewCache = OldCache.

getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,miss):-
                                                                                 \+getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
                                                                                 atom_number(StringAddress,Address),
                                                                                 convertAddress(Address,BitsNum,Tag,Idx,Type),
                                                                                 replaceInCache(Tag,Idx,Mem,OldCache,NewCache,Data,Type,BitsNum).


