<cfabort><cfset lCategoryID="31,33,320,322,324,330,615,616,626,627,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,651,652,653,654,655,656,657,658,659,660,661,662,667,668,669,670,671,672,673,674,676,677,678,685,686,687,688,689,691,692,696,705,706,707,708,709,711,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,733,734,737,739,740,741,743,1031,1032,1034,1035,1036,1037,1038,1041,1042,1043,1044,1045,1046,1047,1049,1050,1051,1052,1053,1058,1059,1060,1061,1062,1064,1065,1066,1067,1068,1069,1070,1071,1072,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1091,1092,1093,1094,1095,1097,1098,1099,1100,1101,1102,1103,1104,1105,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1120,1121,1122,1123,1124,1125,1126,1127,1132,1139,1141,1145,1146,1147,1152,1157,1158,1160,1161,1163,1165,1166,1170,1174,1175,1177,1178,1180,1181,1182,1184,1186,1192,1194,1207,1218,1219,1221,1222,1223,1225,1234,1237,1241,1242,1244,1245,1247,1248,1256,1258,1264,1266,1280,1284,1287,1290,1291,1292,1294,1307,1320,1323,1326,1610,1611,1613,1614,1618,1620,1622,1631,1633,1636,1643,1647,1648,1650,1651,1653,1654,1656,1657,1658,1660,1661,1662,1663,1665,1670,1671,1672,1674,1676,1678,1680,1682,1683,1684,1685,1686,1687,1688,1689,1692,1698,1701,1703,1706,1707,1708,1709,1711,1712,1713,1714,1716,1719,1725,1728,1730,1738,1741,1742,1744,1745,1748,1751,1752,1761,1762,1763,1764,1766,1767,1768,1769,1770,1771,1772,1773,1774,1775,1776,1777,1778,1779,1780,1781,1782,1783,1788,1789,1790,1791,1792,1793,1794,1795,1796,1797,1798,1799,1800,1801,1802,1804,1805,1806,1807,1809,1811,1823,1824,1825,1850,1851,1852,1853,1854,1855,1856,1857,1858,1860,1861,1865,1869,1871,1874,1878,1879,1880,1882,1883,2186,2188,2192,2196,2198,2200,2206,2207,2208,2209,2215,2216,2218,2222,2223,2225,2227,2241,2247,2249,2251,2253,2255,2266,2268,2274,2276,2277,2282,2283,2285,2286,2288,2289,2291,2292,2293,2294,2296,2300,2301,2303,2304,2306,2307,2315,2317,2319,2337,2340,2341,2342,2343,2345,2347,2349,2351,2353,2357,2359,2362,2364,2370,2372,2374,2376,2383,2385,2394,2395,2396,2397,2399,2411,2412,2414,2415,2417,2418,2420,2421,2422,2423,2425,2427,2429,2433,2434,2436,2437,2439,2440,2444,2448,2450,2452,2454,2456,2740,2741,2743,2747,2748,2750,2752,2826,2832,2834,2837,2842,2845,2846,2847,2849,2850,2855,2859,2860,2861,2862,2863,2864,2867,2868,2869,2870,2871,2872,2874,2886,2887,2889,2891,2892,2911,2912,2918,2923,2937,2941,2950,2951,2952,2957,2959,2968,2971,2972,2981,2982,3015,3098,3751,3777,3782,3796,3900,3921,3922,3923,3934,4038,4288,4381,4919,5425,5455,5456,5471,5542,5705">

<cfloop index="ThisCategoryID" list="#lCategoryID#">
	<cfset MyProduct=CreateObject("component","com.Product.Product")>
	<cfset MyProduct.Constructor(Val(ThisCategoryID),100)>
	<cfset MyProduct.SaveToProduction(APPLICATION.WebrootPath,1)>
</cfloop>