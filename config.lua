lib.locale()
Config = {
    Debug = false,
    TargetDistance = 5.0,
    CheckTimes = {
        horn = 5, -- in seconds
        lights = 5,
        neon = 5,
        door = 15, -- in seconds
        engine = 5,
        tires = 5,
    },
    IllegalHorns = {
        [1] = true,  -- HORN_POLICE
        [2] = false,  -- HORN_CLOWN
        [3] = false,  -- HORN_MUSICAL1
        [4] = false,  -- HORN_MUSICAL2
        [5] = false,  -- HORN_MUSICAL3
        [6] = false,  -- HORN_MUSICAL4
        [7] = false,  -- HORN_MUSICAL5
        [8] = false,  -- HORN_SADTROMBONE
        [9] = false,  -- HORN_CALSSICAL1
        [10] = false, -- HORN_CALSSICAL2
        [11] = false, -- HORN_CALSSICAL3
        [12] = false, -- HORN_CALSSICAL4
        [13] = false, -- HORN_CALSSICAL5
        [14] = false, -- HORN_CALSSICAL6
        [15] = false, -- HORN_CALSSICAL7
        [16] = false, -- HORN_SCALEDO
        [17] = false, -- HORN_SCALERE
        [18] = false, -- HORN_SCALEMI
        [19] = false, -- HORN_SCALEFA
        [20] = false, -- HORN_SCALESOL
        [21] = false, -- HORN_SCALELA
        [22] = false, -- HORN_SCALETI
        [23] = false, -- HORN_SCALEDO_HIGH
        [24] = false, -- HORN_JAZZ1
        [25] = false, -- HORN_JAZZ2
        [26] = false, -- HORN_JAZZ3
        [27] = false, -- HORN_JAZZLOOP
        [28] = false, -- HORN_STARSPANGBAN1
        [29] = false, -- HORN_STARSPANGBAN2
        [30] = false, -- HORN_STARSPANGBAN3
        [31] = false, -- HORN_STARSPANGBAN4
        [32] = false, -- HORN_CLASSICALLOOP1
        [33] = false, -- HORN_CLASSICAL8
        [34] = false, -- HORN_CLASSICALLOOP2
    },
    Neon = {
        CheckPositions = {
            [0] = true, -- Back neon
            [1] = false, -- Right neon
            [2] = false, -- Left neon
            [3] = true, -- Front neon
        },
        Colors = {
            { r = 255, g = 0,   b = 0,   illegal = true }, -- Red
            { r = 222, g = 222, b = 255, illegal = false }, -- White
            { r = 2,   g = 21,  b = 255, illegal = false }, -- Blue
            { r = 3,   g = 83,  b = 255, illegal = false }, -- Electric Blue
            { r = 0,   g = 255, b = 140, illegal = false }, -- Mint Green
            { r = 94,  g = 255, b = 1,   illegal = false }, -- Lime Green
            { r = 255, g = 255, b = 0,   illegal = false }, -- Yellow
            { r = 255, g = 150, b = 0,   illegal = false }, -- Golden Shower
            { r = 255, g = 62,  b = 0,   illegal = false }, -- Orange
            { r = 255, g = 50,  b = 100, illegal = false }, -- Pony Pink
            { r = 255, g = 5,   b = 190, illegal = false }, -- Hot Pink
            { r = 35,  g = 1,   b = 255, illegal = false }, -- Purple
            { r = 15,  g = 3,   b = 255, illegal = false } -- Blacklight
        }
    },
    AllowedHornsHeadLights = {
        [0] = true, -- White
        [255] = true, -- Default
    },
    Tire = {
        CheckTypes = {
            [0] = false, -- "Sport",
            [1] = false, -- "Muscle",
            [2] = false, -- "Lowrider",
            [3] = false, -- "SUV",
            [4] = true, -- "Offroad",
            [5] = false, -- "Tuner",
            [6] = false, -- "Motorcycle",
            [7] = false, -- "High End"
        },
        AllowedClasses = {
            [0] = false, -- "Compacts",
            [1] = false, -- "Sedans",
            [2] = true, -- "SUVs",
            [3] = false, -- "Coupes",
            [4] = false, -- "Muscle",
            [5] = false, -- "Sports Classics",
            [6] = false, -- "Sports",
            [7] = false, -- "Super",
            [8] = false, -- "Motorcycles",
            [9] = true, -- "Off-road",
            [10] = false, -- "Industrial",
            [11] = false, -- "Utility",
            [12] = false, -- "Vans",
            [13] = false, -- "Cycles",
        },
        AllowedModels = {
            `bmx`, -- BMX
        },
    },
    MinBodyHelthToPass = 900,
    MinEngineHelthToPass = 900,
    ItemName = "mot",
    Zones = {
        {
            name = "Bennys",
            coords = vec3(-194.0822, -1327.2191, 31.3005),
            size = vec3(7.0, 7.0, 6.0),
			rotation = 0,
            groups = {['bennys'] = 0},
        },
        {
            name = "East",
            coords = vec3(894.53, -2114.67, 30.0),
            size = vec3(36.0, 44.0, 7.0),
			rotation = 85.0,
            groups = {['gcp'] = 0},
        },
        {
            name = "LSC",
            coords = vec3(-328.57, -142.46, 39.0),
            size = vec3(36.0, 53.0, 7.0),
            rotation = 340.0,
            groups = {['lsc'] = 0},
        },
        {
            name = "Under",
            coords = vec3(731.0, -1077.0, 22.0),
            size = vec3(15.0, 33.0, 7.0),
            rotation = 0.0,
            groups = {['under'] = 0},
        },
        {
            name = "Tuner",
            coords = vec3(930.0, -966.0, 40.0),
            size = vec3(54.0, 44.0, 7.0),
            rotation = 8.0,
            groups = {['tuner'] = 0},
        },
        {
            name = "paletotuner",
            coords = vec3(160.29, 6377.72, 31.0),
            size = vec3(33.0, 27.5, 7.0),
            rotation = 27.5,
            groups = {['paletotuner'] = 0},
        },
    }
}