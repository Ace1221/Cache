data Item a = It Tag (Data a) Bool Int | NotPresent deriving (Show, Eq)
data Tag = T Int deriving (Show, Eq)
data Data a = D a deriving (Show, Eq)
data Output a = Out (a, Int) | NoOutput deriving (Show, Eq)

getDataFromCache:: (Integral b, Eq a) =>[Char] -> [Item a] -> [Char] -> b -> Output a
convertAddress :: (Integral b1, Integral b2) => b1 -> b2 -> p -> (b1, b1)
-- | ---------------------------------------------------------------convertBinToDec----------------------------------------------------------- -- |
convertBinToDec :: Integral a => a -> a
convertBinToDec a = convertBinToDecHelper a  0 
convertBinToDecHelper 0 _ = 0
convertBinToDecHelper num n = (2^n)*x + convertBinToDecHelper xs (n+1) 
                                 where
								 x = mod num 10
								 xs = div num 10
								 
-- | ---------------------------------------------------------------replaceIthItem----------------------------------------------------------- -- |
replaceIthItem :: t -> [t] -> Int -> [t]
replaceIthItem item (x:xs) num | num == 0 = (item:xs)
                               | otherwise = [x] ++ replaceIthItem item xs (num-1)
							   
-- | ---------------------------------------------------------------splitEvery--------------------------------------------------------------- -- |
splitEvery :: Int -> [a] -> [[a]]
splitEvery num (x:xs) = splitEveryHelper num (x:xs) [] 0
splitEveryHelper _ [] acc _ = [acc]
splitEveryHelper num (x:xs) acc ctr | num == ctr = [acc] ++ splitEveryHelper num (x:xs) [] 0
                                    | otherwise = splitEveryHelper num xs (acc ++ [x]) (ctr+1)
									
-- | ---------------------------------------------------------------logBase2----------------------------------------------------------------- -- |
logBase2 :: Floating a => a -> a
logBase2 num =  (log num) / (log 2)
-- | ---------------------------------------------------------------getNumBits--------------------------------------------------------------- -- |
getNumBits :: (Integral a, RealFloat a1) => a1 -> [Char] -> [c] -> a
getNumBits _ "fullyAssoc" _ =  0
getNumBits _ "directMap" cache = round (logBase2 (fromIntegral (length cache) ))
getNumBits numSets "setAssoc" _ = round (logBase2 numSets)

-- | ---------------------------------------------------------------fillZeros---------------------------------------------------------------- -- |
fillZeros :: [Char] -> Int -> [Char]

fillZeros s 0 = s
fillZeros s num = ['0'] ++ fillZeros s (num-1) 

-- | -------------------------------------------------------------getDataFromCache------------------------------------------------------------ -- |
toInt :: String -> Int
toInt a = read a

getDataFromCache stringAddress cache dataType bitsNum =  if (t == tag && valid == True && dataType == "fullyAssoc") then Out (datta, (convertBinToDec tag)) else NoOutput
                                                           where
																tag = toInt stringAddress
																It (T t) (D datta) valid order = (cache !! (convertBinToDec tag))	
																
getDataFromCache stringAddress cache dataType bitsNum =  if (t == tag && valid == True && dataType == "directMap") then Out (datta, 0) else NoOutput
                                                           where
																(tag,idx) = convertAddress (toInt stringAddress) bitsNum dataType
																It (T t) (D datta) valid order = (cache !! (convertBinToDec idx))
																
														  

-- | -------------------------------------------------------------convertAddress------------------------------------------------------------ -- |
convertAddress binAddress bitsNum dataType = convertAddressHelper binAddress bitsNum 0 0 "directMap"
convertAddress binAddress bitsNum dataType = convertAddressHelper binAddress 0 0 0 "fullyAssoc"
convertAddressHelper binAddress bitsNum counter idxAcc dataType | bitsNum == counter = (binAddress,idxAcc)
                                                                | otherwise = convertAddressHelper (div binAddress 10) bitsNum (counter+1) 
																              (idxAcc + ((10^counter) * (mod binAddress 10))) "directMap"
																         