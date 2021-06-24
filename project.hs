convertAddress :: (Integral b1, Integral b2) => b1 -> b2 -> p -> (b1, b1)
convertAddress binAddress 0 "fullyAssoc" = (binAddress, 0)