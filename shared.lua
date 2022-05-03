Config ={}

Config.StartLocation = vector3(180.01, -1637.56, 29.29) -- Start Location where you start the work
Config.MaxDeliveryTime = 10 * (60 * 1000) -- 10 Min (If someone goes afk delivery will end in 10min)
Config.MaxDeliveries = math.random(3, 8) -- Max Deliveries (Changes in every start of delivery)
Config.GiveBonusOnPolice = true
Config.DeliveryItems = {
    ["cokebaggy"] = math.random(1200, 1300),    
}

Config.DeliveryLocations = {    -- Add Locations to deliver (random), The more location the more it will be fun
    [1] =  vector3(54.6, -1873.2, 22.8),
    [2] =  vector3(-80.47, -1607.89, 31.48),
    [3] =  vector3(-32.35, -1446.21, 31.89),
    [4] =  vector3(26.12, -1409.38, 29.33),
    [5] =  vector3(15.69, -1032.12, 29.53),
    [6] =  vector3(343.35, -1081.93, 29.45),
    [7] =  vector3(351.55, -968.39, 29.43),
    [8] =  vector3(478.85, -106.68, 63.16),
    [9] =  vector3(329.55, -225.24, 54.22),
    [10] =  vector3(115.75, -271.24, 54.51),
    [11] =  vector3(111.09, -236.82, 55.24),
    [12] =  vector3(359.46, 356.43, 104.33),
    [13] =  vector3(-719.7, -410.81, 34.98),
    [14] =  vector3(970.81, -1143.97, 25.19),
    [15] =  vector3(1082.56, -787.45, 58.35),
    [16] =  vector3(1241.48, -417.19, 71.58),
    [17] =  vector3(815.0, -109.39, 80.6),
    [18] =  vector3(1233.78, 1876.32, 78.96),
    [19] =  vector3(802.96, 2174.82, 53.07),
    [20] =  vector3(382.84, 2576.51, 44.55),
    [21] =  vector3(2221.94, 5614.7, 54.9),
    [22] =  vector3(136.43, 6643.22, 31.81),
    [23] =  vector3(-358.66, 6061.74, 31.5),
    [24] =  vector3(-405.5, 6151.03, 31.68),
    [25] =  vector3(-560.59, 5282.77, 73.05),
    [26] =  vector3(-2193.3, 4290.13, 49.17),
    [27] =  vector3(1360.65, 3604.08, 34.96),
    [28] =  vector3(2545.27, 2592.13, 37.96),
    [29] =  vector3(1360.65, 3604.08, 34.96),
    [30] =  vector3(2545.27, 2592.13, 37.96),
}

