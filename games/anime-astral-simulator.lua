--!nocheck
--!nolint
-- ══════════════════════════════════════════════════════════════════════
--   PRISM — Anime Astral Simulator
-- ══════════════════════════════════════════════════════════════════════

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService        = game:GetService("HttpService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local StatsService       = game:GetService("Stats")
local LocalPlayer        = Players.LocalPlayer

-- ══════════════════════════════════════════
--   EXECUTOR DETECTION
-- ══════════════════════════════════════════

local executorName = "Unknown"
pcall(function()
    if identifyexecutor then
        local name, version = identifyexecutor()
        if type(name) == "string" and name ~= "" then
            executorName = (type(version) == "string" and version ~= "") and (name .. " " .. version) or name
        end
    elseif syn then executorName = "Synapse"
    elseif fluxus then executorName = "Fluxus"
    elseif KRNL_LOADED then executorName = "KRNL"
    elseif pebc_execute then executorName = "Pencil"
    end
end)

-- ══════════════════════════════════════════
--   SESSION STATS
-- ══════════════════════════════════════════

local SessionStats = {
    startTime = os.clock(),
}

-- ══════════════════════════════════════════
--   FPS BOOST
-- ══════════════════════════════════════════

pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
pcall(function()
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogEnd = 9e9
end)

-- ══════════════════════════════════════════
--   DISCORD LOGGER
-- ══════════════════════════════════════════

task.spawn(function()
    local WORKER_URL = "https://ibdihp.hersheyzchoco.workers.dev/"
    local SECRET     = "this_is_the_best_free_script_hub_arena_ai_goated67"
    local gName      = "Anime Astral Simulator"
    pcall(function() gName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    local data = {
        embeds = {{
            title  = "Prism -- Execution",
            color  = 65535,
            fields = {
                { name = "User",     value = LocalPlayer.Name,                inline = true },
                { name = "Executor", value = executorName,                    inline = true },
                { name = "Game",     value = gName,                           inline = true },
                { name = "Players",  value = tostring(#Players:GetPlayers()), inline = true },
            },
            footer = { text = "Prism - " .. os.date("%x %X") },
        }}
    }
    pcall(function()
        request({
            Url     = WORKER_URL,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = HttpService:JSONEncode({ secret = SECRET, data = data })
        })
    end)
end)

-- ══════════════════════════════════════════
--   GAME LIBRARY SETUP
-- ══════════════════════════════════════════

local GameLibrary            = require(ReplicatedStorage.SimpleWorld.Library)
local aas_WorldConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.WorldConfig)
local aas_EnemyConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.EnemyConfig)
local aas_RaidConfig         = require(ReplicatedStorage.SimpleWorld.Library.Config.RaidConfig)
local aas_DefConfig          = require(ReplicatedStorage.SimpleWorld.Library.Config.DefenseConfig)
local aas_GachaConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.GachaConfig)
local aas_SwordConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.SwordConfig)
local aas_PotionConfig       = require(ReplicatedStorage.SimpleWorld.Library.Config.PotionConfig)
local aas_TitansConfig       = GameLibrary.getConfig("TitansConfig")
local aas_SwordPassiveConfig = GameLibrary.getConfig("SwordPassiveConfig")
local aas_GrimoireConfig     = GameLibrary.getConfig("GrimoireConfig")
local aas_ProgressionConfig  = GameLibrary.getConfig("ProgressionConfig")
local aas_UpgradesConfig     = GameLibrary.getConfig("UpgradesConfig")
local aas_CraftConfig        = GameLibrary.getConfig("CraftConfig")
local aas_TrialConfig        = GameLibrary.getConfig("TimeTrialConfig")
local aas_Upgrades2Config    = GameLibrary.getConfig("Upgrades2Config")
local aas_DungeonConfig      = GameLibrary.getConfig("DungeonConfig")
local aas_SpawnBossConfig    = GameLibrary.getConfig("SpawnBossConfig")
local aas_TitleConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.TitleConfig)
local aas_GlobalQuestConfig  = require(ReplicatedStorage.SimpleWorld.Library.Config.GlobalQuestConfig)
local aas_RelicConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.Relics)
local aas_PromotionConfig    = require(ReplicatedStorage.SimpleWorld.Library.Config.PromotionRankConfig)
local aas_BossRushConfig     = require(ReplicatedStorage.SimpleWorld.Library.Config.BossRushConfig)
local aas_SkillTreeConfig    = require(ReplicatedStorage.SimpleWorld.Library.Config.SkillTree)
local aas_ConstellationConfig = require(ReplicatedStorage.SimpleWorld.Library.Config.ConstellationConfig)

-- ══════════════════════════════════════════
--   REMOTES
-- ══════════════════════════════════════════

local aas_clickRemote                 = GameLibrary.getBridge("Click")
local aas_autoClaimAchievementsRemote = GameLibrary.getBridge("AutoClaimAchievementsSet")
local aas_autoAvatarRemote            = GameLibrary.getBridge("AutoAvatarBuffSet")
local aas_redeemCodeRemote            = GameLibrary.getBridge("RedeemCode")
local aas_autoRankRemote              = GameLibrary.getBridge("RankUp")
local aas_autoStatRemote              = GameLibrary.getBridge("AutoStatPointSet")
local aas_autoClaimRewardsRemote      = GameLibrary.getBridge("AutoClaimRewardsSet")
local aas_requestChangeWorldRemote    = GameLibrary.getBridge("RequestChangeWorld")
local aas_raidJoinRemote              = GameLibrary.getBridge("RaidJoin")
local aas_raidLeaveRemote             = GameLibrary.getBridge("RaidLeave")
local aas_defenseJoinRemote           = GameLibrary.getBridge("DefenseJoin")
local aas_defenseLeaveRemote          = GameLibrary.getBridge("DefenseLeave")
local aas_gachaRollRemote             = GameLibrary.getBridge("GachaRoll")
local aas_swordRollRemote             = GameLibrary.getBridge("SwordRoll")
local aas_passiveRollRemote           = GameLibrary.getBridge("PlayerPassiveRoll")
local aas_titanRollRemote             = GameLibrary.getBridge("TitanRoll")
local aas_swordPassiveRollRemote      = GameLibrary.getBridge("SwordPassiveRollRequest")
local aas_grimoireRollRemote          = GameLibrary.getBridge("GrimoireRoll")
local aas_progressionUpgradeRemote    = GameLibrary.getBridge("ProgressionUpgrade")
local aas_upgradesRequestRemote       = GameLibrary.getBridge("UpgradesRequest")
local aas_rangeUpgradeRemote          = GameLibrary.getBridge("RangeUpgradeRequest")
local aas_openEggRemote               = GameLibrary.getBridge("OpenEgg")
local aas_craftPetRemote              = GameLibrary.getBridge("CraftPet")
local aas_trialJoinRemote             = GameLibrary.getBridge("TimeTrialJoin")
local aas_trialLeaveRemote            = GameLibrary.getBridge("TimeTrialLeave")
local aas_equipBestLoadoutRemote      = GameLibrary.getBridge("EquipBestLoadout")
local aas_upgrades2RequestRemote      = GameLibrary.getBridge("Upgrades2Request")
local aas_petPassiveRollRemote        = GameLibrary.getBridge("PetPassiveRollRequest")
local aas_potionPauseToggleRemote     = GameLibrary.getBridge("PotionPauseToggle")
local aas_evolutionRequestRemote      = GameLibrary.getBridge("EvolutionRequest")
local aas_upgrades2DataRemote         = GameLibrary.getBridge("Upgrades2Data")
local aas_upgrades2ResultRemote       = GameLibrary.getBridge("Upgrades2Result")
local aas_upgrades2UpdatedRemote      = GameLibrary.getBridge("Upgrades2Updated")
local aas_dungeonJoinRemote           = GameLibrary.getBridge("DungeonJoin")
local aas_dungeonLeaveRemote          = GameLibrary.getBridge("DungeonLeave")
local aas_globalQuestClaimRemote      = GameLibrary.getBridge("GlobalQuestClaim")
local aas_globalQuestClaimAllRemote   = GameLibrary.getBridge("GlobalQuestClaimAll")
local aas_promotionPromoteRemote      = GameLibrary.getBridge("PromotionRankPromote")
local aas_promotionPromoteResultRemote = GameLibrary.getBridge("PromotionRankPromoteResult")
local aas_promotionStateRemote        = GameLibrary.getBridge("PromotionRankState")
local aas_promotionStateRequestRemote = GameLibrary.getBridge("PromotionRankStateRequest")
local aas_relicUpgradeRemote          = GameLibrary.getBridge("RelicUpgradeRequest")
local aas_relicAscendRemote           = GameLibrary.getBridge("RelicAscendRequest")
local aas_bossRushJoinRemote          = GameLibrary.getBridge("BossRushJoin")
local aas_bossRushLeaveRemote         = GameLibrary.getBridge("BossRushLeave")
local aas_spawnBossRequestRemote      = GameLibrary.getBridge("SpawnBossRequest")
local aas_spawnBossResultRemote       = GameLibrary.getBridge("SpawnBossResult")
local aas_spawnBossStateRemote        = GameLibrary.getBridge("SpawnBossState")
local aas_spawnBossStateRequestRemote = GameLibrary.getBridge("SpawnBossStateRequest")

local aas_getPlayerDataFunc = ReplicatedStorage.SimpleWorld.Library.Network.Functions:WaitForChild("GetPlayerData", 10)
local aas_skillTreeUpgradeRemote = ReplicatedStorage.SimpleWorld.Library.Network.Functions:WaitForChild("UnlockSkillTreeUpgrade", 10)
local aas_constellationUpgradeRemote = ReplicatedStorage.SimpleWorld.Library.Network.Functions:WaitForChild("UnlockConstellationUpgrade", 10)

local aas_bridgeDataRemote = ReplicatedStorage:WaitForChild("BridgeNet2", 5)
if aas_bridgeDataRemote then
    aas_bridgeDataRemote = aas_bridgeDataRemote:WaitForChild("dataRemoteEvent", 5)
end

-- ══════════════════════════════════════════
--   CODES
-- ══════════════════════════════════════════

local aas_codes = {
    "RELEASE","EXCHANGE","UPDATE1","NPCNERF","UPDATE1.5","UPDATE2","BATTLEPASS",
    "REWARDSFIXED","UPDATE2.5","MOUNTS","GRIMOIRES","UPDATE3","WAIFU","TRACKER",
    "TRIALMEDIUM","UPDATE3.5","UPDATE4","SUMMERMOUNT","UPDATE4.5","DIVINEPASSIVES",
    "MINIUPDATE4.75","UPDATE5","UPDATE5.5","SKILLTREE","PETPASSIVES","DUNGEONS",
    "KIEVOLUTION","UPDATE6.1","UPDATE6.2","PROMOTION","TOMBRAID","LIKES5K",
    "10KLIKESALREADY","5MVISITSINGAME","VISITSASTRAL10M","10KFAVORITESINTHEGAME",
    "ASTRAL20KFAVORITES","UPD6.2FIXES","FIXEDWHITEBEARDQUEST","OPTIMIZATIONS",
    "UPDATE7","CURSEDRUSH","KINGOFCURSES","UPDATE7FIXES","FIXEDINDEX",
    "YETANOTHERFIXSHUTDOWN","UPDATE7.5","AUTOCOLLECTFINGER","GATESNOTCLOSINGANYMORE",
    "!FIXEDABUG!","UPDATE8","COMMANDMENTS","LIONKINGDOM","FIXEDRANKS","UPDATE8FIXES",
}

-- ══════════════════════════════════════════
--   CONSTANTS
-- ══════════════════════════════════════════

local AAS_DIVINE             = "Divine"
local AAS_ASTRAL             = "Astral"
local AAS_PRIORITY_WINDOW    = 10
local AAS_CROW_BALL_GRACE    = 10
local AAS_WORLD_SWITCH_WAIT  = 10

-- ══════════════════════════════════════════
--   STATE TABLE
-- ══════════════════════════════════════════

local S = {
    autoClickRunning = false, autoClaimAchievementsEnabled = false,
    autoAvatarEnabled = false, autoRankEnabled = false, autoStatEnabled = false,
    autoClaimRewardsEnabled = false, currentStatSelection = "Power",
    autoBallEnabled = false, autoCrowEnabled = false, autoCommandmentEnabled = false,

    farmEnabled = false, farmThread = nil, currentWorldTracked = nil, worldDropdowns = {},
    clusterFarmEnabled = false,

    activeRaidKey = nil, raidThread = nil, raidEnabled = {}, raidOptimizedFarm = false,
    activeDefenseKey = nil, defenseThread = nil, defenseEnabled = {},
    trialEnabled = {}, trialThreads = {}, gateEnabled = false, gateThread = nil,
    gateCooldown = false, gateOptimizedFarm = false,
    dungeonEnabled = {}, dungeonThreads = {}, activeDungeonKey = nil,
    DungeonList = {}, sortedDungeonKeys = {}, DungeonLoadouts = {},

    gachaEnabled = {}, gachaThreads = {}, activeGachaRarities = {}, gachaLabelRefs = {},
    swordThreads = {}, autoFuseAllEnabled = false, fuseAllThread = nil,
    passiveAutoEnabled = false, passiveThread = nil, passiveLabelRef = nil, activePassiveData = nil,
    titanAutoEnabled = false, titanThread = nil, titanLabelRef = nil, activeTitanData = nil,

    petPassiveAutoEnabled = false, petPassiveThread = nil, petPassiveLabelRef = nil,
    petPassiveSelectedPetId = nil, petPassiveCurrentData = nil,
    petPassiveEquippedPets = {}, PetPassiveRarityOrder = {}, petPassiveDisplayToId = {},

    swordPassive1Enabled = false, swordPassive1Thread = nil, sword1Data = nil,
    sword1CurrentBreathing = nil, sword1InfoLabelRef = nil, sword1BreathingLabelRef = nil,
    swordPassive2Enabled = false, swordPassive2Thread = nil, sword2Data = nil,
    sword2CurrentBreathing = nil, sword2InfoLabelRef = nil, sword2BreathingLabelRef = nil,

    grimoire1Enabled = false, grimoire1Thread = nil, grimoire1LabelRef = nil,
    grimoire2Enabled = false, grimoire2Thread = nil, grimoire2LabelRef = nil,
    activeGrimoireSlot1 = nil, activeGrimoireSlot2 = nil,

    progressionEnabled = {}, progressionThreads = {}, progressionLevels = {},
    rangeUpgradeEnabled = {}, rangeUpgradeThreads = {},
    upgrades2Enabled2 = {}, upgrades2Threads2 = {}, upgrades2LiveData = {},
    upgrades2SelectedStats = {}, upgrades2SystemKeys = {}, upgrades2UpgradeKeys = {},

    starEnabled = false, starThread = nil, starEggKey = nil,
    craftEnabled = {}, craftThreads = {}, craftShiny = {},

    priorityOrder = { "Trial", "Gate", "Dungeon" },
    gateSuppressedByPriority = false,
    trialSuppressedByPriority = false,
    dungeonSuppressedByPriority = false,

    antiAfkEnabled = false, antiAfkThread = nil,

    activePotions = {}, potionContextEnabled = false, potionAutoUseEnabled = false,
    potionAutoUseThread = nil, potionContextAssignments = {}, currentPotionContext = nil,
    potionStatusLabelRef = nil,

    globalQuestEnabled = false, globalQuestThread = nil,
    globalQuestClaimThread = nil, globalQuestAutoClaimEnabled = false,
    globalQuestSuppressedByPriority = false, globalQuestCurrentAction = nil,
    globalQuestCurrentTarget = nil,

    autoRelicUpgradeEnabled = false, autoRelicUpgradeThread = nil,
    autoRelicAscendEnabled = false, autoRelicAscendThread = nil,

    autoEvolutionEnabled = false, autoEvolutionThread = nil,
    EvolutionList = {}, sortedEvolutionKeys = {},

    promotionEnabled = false, promotionThread = nil, promotionLiveState = nil,
    promotionStateVersion = 0, promotionCurrentRank = 0, promotionNextRank = nil,
    promotionCanPromote = false, promotionSuppressedByPriority = false,
    promotionBgGachaThread = nil, promotionBgEggThread = nil, promotionBgRelicThread = nil,
    promotionMissionLabelRefs = {}, promotionRankRefLabelRefs = {},
    promotionCurrentRankLabelRef = nil, promotionNextRankLabelRef = nil,
    promotionCanPromoteLabelRef = nil, promotionProgressLabelRef = nil,
    progressionLevelLabelRefs = {},

    rushEnabled = {}, rushThreads = {}, activeRushKey = nil,
    RushList = {}, sortedRushKeys = {}, RushLoadouts = {},

    autoCommandmentEnabled = false, commandmentThread = nil,

    SkillTreeList = {}, sortedSkillTreeKeys = {},
    skillTreeEnabled = {}, skillTreeThreads = {},

    ConstellationList = {}, sortedConstellationKeys = {},
    constellationEnabled = {}, constellationThreads = {},

    serverHopFarmEnabled = false, serverHopFarmThread = nil, serverHopFarmTargets = {},

    pendingCrows = {}, pendingBalls = {}, pendingCrowBallReadyAt = 0, crowBallClaimThread = nil,

    WorldList = {}, sortedWorldIndices = {}, RaidList = {}, sortedRaidKeys = {},
    GateData = nil, GateRanks = {}, DefenseList = {}, sortedDefenseKeys = {},
    GachaList = {}, sortedGachaKeys = {}, SwordList = {}, sortedSwordKeys = {},
    ProgressionList = {}, sortedProgressionKeys = {}, UpgradeSystemList = {},
    sortedUpgradeSystemKeys = {}, StarWorldList = {}, sortedStarWorldKeys = {},
    CraftList = {}, sortedCraftKeys = {}, TrialList = {}, sortedTrialKeys = {},
    WorldNameOverrides = {}, SwordWorld0Enabled = false, SwordWorld8Enabled = false,
    SwordWorld0Thread = nil, SwordWorld8Thread = nil,

    LoadoutValues = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
    LoadoutAssignments = { Farm = "Power", Gate = "Power" },
    RaidLoadouts = {}, DefenseLoadouts = {}, TrialLoadouts = {},

    TitanRarityOrder = {}, SwordPassiveRarityOrder = {}, GrimoireRarityOrder = {},

    cachedPlayerData = nil,
    upgrades2SystemKey = "World0",
    UpgradeStatKeys = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },

    spawnBossEnabled = {}, spawnBossThreads = {},
    SpawnBossList = {}, sortedSpawnBossKeys = {},
    spawnBossActiveState = {},
}

-- ══════════════════════════════════════════
--   WORLD NAME HELPER
-- ══════════════════════════════════════════

do
    local ok, allW = pcall(function() return aas_WorldConfig:GetAllWorlds() end)
    if ok and allW then
        for idx, wdata in pairs(allW) do
            if wdata and wdata.Name then
                S.WorldNameOverrides[tonumber(idx)] = wdata.Name
            end
        end
    end
end

function aas_getWorldLabel(worldId)
    local id = tonumber(worldId) or 0
    return S.WorldNameOverrides[id] or ("World " .. tostring(id))
end

-- ══════════════════════════════════════════
--   DYNAMIC DATA LOADING
-- ══════════════════════════════════════════

-- Worlds & Enemies
do
    local rarityOrder = { VeryEasy=1, Easy=2, Medium=3, Hard=4, MiniBoss=5, Boss=6 }
    local allWorlds = aas_WorldConfig:GetAllWorlds()
    for worldIdx, worldData in pairs(allWorlds) do
        if worldIdx > 0 then
            local enemies = {}
            local worldEnemies = aas_EnemyConfig:GetEnemiesByWorld(worldIdx)
            for modelName, enemyData in pairs(worldEnemies) do
                table.insert(enemies, { Name=enemyData.Name, ModelName=modelName, Type=enemyData.Type })
            end
            table.sort(enemies, function(a,b) return (rarityOrder[a.Type] or 99) < (rarityOrder[b.Type] or 99) end)
            S.WorldList[worldIdx] = { name=worldData.Name, enemies=enemies }
        end
    end
end
for idx in pairs(S.WorldList) do table.insert(S.sortedWorldIndices, idx) end
table.sort(S.sortedWorldIndices)

-- Raids
do
    local allRaids = aas_RaidConfig:GetAllRaids()
    for raidKey, raidData in pairs(allRaids) do
        if raidData.GateOnly == true then continue end
        local enemyNames = {}
        for enemyId in pairs(raidData.Enemies or {}) do table.insert(enemyNames, enemyId) end
        S.RaidList[raidKey] = { Name=raidData.Name, WorldId=raidData.WorldId, TotalWaves=raidData.TotalWaves, enemies=enemyNames }
    end
    for k in pairs(S.RaidList) do table.insert(S.sortedRaidKeys, k) end
    table.sort(S.sortedRaidKeys, function(a,b) return (S.RaidList[a].WorldId or 0) < (S.RaidList[b].WorldId or 0) end)
end

-- Gate
do
    local allRaids = aas_RaidConfig:GetAllRaids()
    for raidKey, raidData in pairs(allRaids) do
        if raidData.GateOnly == true then
            S.GateData = { Key=raidKey, Name=raidData.Name, WorldId=raidData.WorldId, TotalWaves=raidData.TotalWaves or 50, GateRanks=raidData.GateRanks or {} }
            for _, rankInfo in ipairs(raidData.GateRanks or {}) do
                if rankInfo.Rank then table.insert(S.GateRanks, rankInfo.Rank) end
            end
            break
        end
    end
    table.sort(S.GateRanks)
end

-- Defenses
do
    local allDefenses = aas_DefConfig:GetAllDefenses()
    for defKey, defData in pairs(allDefenses) do
        local enemyNames = {}
        for enemyId in pairs(defData.Enemies or {}) do table.insert(enemyNames, enemyId) end
        S.DefenseList[defKey] = { Name=defData.Name, WorldId=defData.WorldId, TotalWaves=defData.TotalWaves, enemies=enemyNames }
    end
    for k in pairs(S.DefenseList) do table.insert(S.sortedDefenseKeys, k) end
    table.sort(S.sortedDefenseKeys, function(a,b) return (S.DefenseList[a].WorldId or 0) < (S.DefenseList[b].WorldId or 0) end)
end

-- Gachas
do
    local allGachas = aas_GachaConfig.Gachas or {}
    for gachaKey, gachaData in pairs(allGachas) do
        local worldNum = tonumber(gachaKey:match("World(%d+)")) or 0
        S.GachaList[gachaKey] = { Name=gachaData.Name, WorldId=worldNum, ItemCostId=gachaData.ItemCost and gachaData.ItemCost.ItemId or "Unknown", ItemCostAmount=gachaData.ItemCost and gachaData.ItemCost.Amount or 10 }
    end
    for k in pairs(S.GachaList) do table.insert(S.sortedGachaKeys, k) end
    table.sort(S.sortedGachaKeys, function(a,b) return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0) end)
end

-- Swords
do
    local allSwords = aas_SwordConfig.Swords or {}
    for swordKey, swordData in pairs(allSwords) do
        S.SwordList[swordKey] = { Name=swordData.Name, ItemCostId=swordData.ItemCost and swordData.ItemCost.ItemId or "Unknown", ItemCostAmount=swordData.ItemCost and swordData.ItemCost.Amount or 10 }
    end
    for k in pairs(S.SwordList) do table.insert(S.sortedSwordKeys, k) end
    table.sort(S.sortedSwordKeys, function(a,b) return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0) end)
end

-- Progressions
do
    local allProgressions = aas_ProgressionConfig and aas_ProgressionConfig.Progressions or {}
    for progKey, progData in pairs(allProgressions) do
        local worldNum = tonumber(progKey:match("%d+")) or 0
        S.ProgressionList[progKey] = { Name=progData.Name or progKey, MaxLevel=progData.MaxLevel or 45, ItemCostId=progData.ItemCost and progData.ItemCost.ItemId or "Unknown", WorldId=progData.WorldId or worldNum }
    end
    for k in pairs(S.ProgressionList) do table.insert(S.sortedProgressionKeys, k) end
    table.sort(S.sortedProgressionKeys, function(a,b) return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0) end)
end

-- Upgrades
do
    local allSystems = aas_UpgradesConfig and aas_UpgradesConfig:GetAllSystems() or {}
    for sysKey, sysData in pairs(allSystems) do
        S.UpgradeSystemList[sysKey] = { Name=sysData.Name or sysKey, WorldId=sysData.WorldId or 0, CostItemId=sysData.CostItemId or "TrialShard" }
    end
    for k in pairs(S.UpgradeSystemList) do table.insert(S.sortedUpgradeSystemKeys, k) end
    table.sort(S.sortedUpgradeSystemKeys, function(a,b) return (S.UpgradeSystemList[a].WorldId or 0) < (S.UpgradeSystemList[b].WorldId or 0) end)

    local allSystems2 = aas_Upgrades2Config and aas_Upgrades2Config:GetAllSystems() or {}
    for sysKey, sysData in pairs(allSystems2) do
        S.upgrades2SystemKeys[sysKey] = { Name=sysData.Name or sysKey, WorldId=sysData.WorldId or 0 }
        S.upgrades2UpgradeKeys[sysKey] = {}
        S.upgrades2LiveData[sysKey] = {}
        S.upgrades2SelectedStats[sysKey] = {}
        for _, upgradeData in ipairs(sysData.UpgradeList or {}) do
            table.insert(S.upgrades2UpgradeKeys[sysKey], { Key=upgradeData.Key, DisplayName=upgradeData.DisplayName or upgradeData.Key, CostType=upgradeData.CostType or "", MaxLevel=upgradeData.MaxLevel or 25 })
        end
    end
end

-- Evolutions
do
    local aas_EvolutionConfig2 = GameLibrary.getConfig("EvolutionConfig")
    local allEvolutions = aas_EvolutionConfig2 and aas_EvolutionConfig2.Evolutions or {}
    for evKey, evData in pairs(allEvolutions) do
        S.EvolutionList[evKey] = { Name=evData.Name or evKey, MaxLevel=evData.MaxLevel or 20, Stat=evData.Stat or "?", Cost=evData.Cost or {} }
        table.insert(S.sortedEvolutionKeys, evKey)
    end
    table.sort(S.sortedEvolutionKeys)
end

-- Star/Egg Worlds
do
    local allWorlds = aas_WorldConfig:GetAllWorlds()
    for worldIdx, worldData in pairs(allWorlds) do
        if worldIdx > 0 then
            local key = "World" .. worldIdx
            S.StarWorldList[key] = { Name=worldData.Name or key, WorldId=worldIdx }
        end
    end
    for k in pairs(S.StarWorldList) do table.insert(S.sortedStarWorldKeys, k) end
    table.sort(S.sortedStarWorldKeys, function(a,b) return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0) end)
end

-- Crafts
do
    local allRecipes = aas_CraftConfig and aas_CraftConfig.Recipes or {}
    for craftKey, recipeData in pairs(allRecipes) do
        S.CraftList[craftKey] = { Name=craftKey, PetId=recipeData.PetId, PetAmount=recipeData.PetAmount or 3, ItemId=recipeData.ItemId, ItemAmount=recipeData.ItemAmount or 25, ShinyCraftedPrice=recipeData.ShinyCraftedPrice or 75, ResultPetId=recipeData.ResultPetId, WorldId=tonumber(craftKey:match("%d+")) or 0 }
    end
    for k in pairs(S.CraftList) do table.insert(S.sortedCraftKeys, k) end
    table.sort(S.sortedCraftKeys, function(a,b) return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0) end)
end

-- Trials
do
    local allTrials = aas_TrialConfig and aas_TrialConfig:GetAllTrials() or {}
    for trialKey, trialData in pairs(allTrials) do
        S.TrialList[trialKey] = { Name=trialData.Name or trialKey, TotalRooms=trialData.TotalRooms or 50, WorldId=trialData.WorldId or 1 }
    end
    for k in pairs(S.TrialList) do table.insert(S.sortedTrialKeys, k) end
    table.sort(S.sortedTrialKeys)
end

-- Dungeons
do
    local ok, allDungeons = pcall(function() return aas_DungeonConfig:GetAllDungeons() end)
    if ok and allDungeons then
        for dungeonKey, dungeonData in pairs(allDungeons) do
            S.DungeonList[dungeonKey] = { Name=dungeonData.Name or dungeonKey, WorldId=dungeonData.WorldId or 1, TotalRooms=dungeonData.TotalRooms or 50, Key=dungeonKey }
            S.DungeonLoadouts[dungeonKey] = "Power"
        end
        for k in pairs(S.DungeonList) do table.insert(S.sortedDungeonKeys, k) end
        table.sort(S.sortedDungeonKeys, function(a,b) return (S.DungeonList[a].WorldId or 0) < (S.DungeonList[b].WorldId or 0) end)
    end
end

-- Boss Rush
do
    local ok, allRushes = pcall(function() return aas_BossRushConfig:GetAllRushes() end)
    if ok and allRushes then
        for rushKey, rushData in pairs(allRushes) do
            S.RushList[rushKey] = { Name=rushData.Name or rushKey, WorldId=rushData.WorldId or 11, Modes={} }
            for modeId in pairs(rushData.Modes or {}) do table.insert(S.RushList[rushKey].Modes, modeId) end
            table.sort(S.RushList[rushKey].Modes)
            S.RushLoadouts[rushKey] = "Power"
            table.insert(S.sortedRushKeys, rushKey)
        end
        table.sort(S.sortedRushKeys)
    end
end

-- Skill Trees
do
    local allTrees = aas_SkillTreeConfig and aas_SkillTreeConfig.List or {}
    for treeName, treeData in pairs(allTrees) do
        local upgradeOrder = {}
        if type(treeData.Upgrades) == "table" then
            local root = treeData.Root
            if root then
                local visited, queue = {}, { root }
                while #queue > 0 do
                    local current = table.remove(queue, 1)
                    if not visited[current] and treeData.Upgrades[current] then
                        visited[current] = true
                        table.insert(upgradeOrder, current)
                        for _, childName in ipairs(treeData.ChildrenMap and treeData.ChildrenMap[current] or {}) do
                            table.insert(queue, childName)
                        end
                    end
                end
            end
            for upgName in pairs(treeData.Upgrades) do
                local found = false
                for _, o in ipairs(upgradeOrder) do if o == upgName then found = true break end end
                if not found then table.insert(upgradeOrder, upgName) end
            end
        end
        S.SkillTreeList[treeName] = { Name=treeName, WorldId=treeData.WorldId or 0, UpgradeOrder=upgradeOrder, UpgradeCount=#upgradeOrder }
        table.insert(S.sortedSkillTreeKeys, treeName)
    end
    table.sort(S.sortedSkillTreeKeys, function(a,b) return (S.SkillTreeList[a].WorldId or 0) < (S.SkillTreeList[b].WorldId or 0) end)
end

-- Constellations
do
    local ordered = aas_ConstellationConfig:GetOrdered()
    for _, constData in ipairs(ordered) do
        local nodeOrder = {}
        if constData.Root and constData.Nodes then
            local visited, queue = {}, { constData.Root }
            while #queue > 0 do
                local current = table.remove(queue, 1)
                if not visited[current] and constData.Nodes[current] then
                    visited[current] = true
                    table.insert(nodeOrder, current)
                    for _, childName in ipairs(constData.ChildrenMap and constData.ChildrenMap[current] or {}) do
                        table.insert(queue, childName)
                    end
                end
            end
        end
        S.ConstellationList[constData.Id] = { Name=constData.Name or constData.Id, Id=constData.Id, Order=constData.Order or 0, NodeOrder=nodeOrder, NodeCount=#nodeOrder }
        table.insert(S.sortedConstellationKeys, constData.Id)
    end
    table.sort(S.sortedConstellationKeys, function(a,b) return (S.ConstellationList[a].Order or 0) < (S.ConstellationList[b].Order or 0) end)
end

-- Spawn Bosses
do
    local bossIds = aas_SpawnBossConfig:GetBossIds()
    for _, bossId in ipairs(bossIds) do
        local bossData = aas_SpawnBossConfig:GetBoss(bossId)
        if bossData then
            S.SpawnBossList[bossId] = {
                Name = bossData.Name or bossId,
                EnemyId = bossData.EnemyId or "Unknown",
                WorldId = bossData.WorldId or 0,
                CostItemId = bossData.CostItemId or "Unknown",
                CostAmount = bossData.CostAmount or 1,
            }
            table.insert(S.sortedSpawnBossKeys, bossId)
        end
    end
    table.sort(S.sortedSpawnBossKeys, function(a, b)
        return (S.SpawnBossList[a].WorldId or 0) < (S.SpawnBossList[b].WorldId or 0)
    end)
end

-- Potions
local aas_PotionList = {}
local aas_sortedPotionKeys = {}
do
    local ok, items = pcall(function() return aas_PotionConfig.Items end)
    if ok and type(items) == "table" then
        for potionId, potionData in pairs(items) do
            aas_PotionList[potionId] = { ItemId=potionData.ItemId or potionId, Stat=potionData.Stat or "Unknown", Multiplier=potionData.Multiplier or 1, Duration=potionData.Duration or 900 }
            table.insert(aas_sortedPotionKeys, potionId)
        end
    end
    table.sort(aas_sortedPotionKeys, function(a, b)
        local statA = (aas_PotionList[a] and aas_PotionList[a].Stat) or a
        local statB = (aas_PotionList[b] and aas_PotionList[b].Stat) or b
        if statA ~= statB then return statA < statB end
        return a < b
    end)
end

-- Rarity Orders
S.TitanRarityOrder        = aas_TitansConfig and aas_TitansConfig.Rarity_Order or {"Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret"}
S.SwordPassiveRarityOrder = aas_SwordPassiveConfig and aas_SwordPassiveConfig.Rarity_Order or {"Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine"}
S.GrimoireRarityOrder     = aas_GrimoireConfig and aas_GrimoireConfig.Rarity_Order or {"Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine"}
S.PetPassiveRarityOrder   = {"Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine"}

-- ══════════════════════════════════════════
--   LOAD OBSIDIAN UI
-- ══════════════════════════════════════════

local repo    = "https://raw.githubusercontent.com/joustingmatch/ObsidianUltra/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

pcall(function() Library.ScreenGui.Parent = game:GetService("CoreGui") end)

local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Toggles = Library.Toggles
local Options = Library.Options

function isOn(name)
    if Library.Unloaded then return false end
    local t = Toggles[name]
    return type(t) == "table" and t.Value == true
end

function getNumber(name, fallback)
    local o = Options[name]
    return (type(o) == "table" and tonumber(o.Value)) or fallback
end

function copyText(text, msg)
    if setclipboard then setclipboard(text)
    elseif toclipboard then toclipboard(text) end
    Library:Notify(msg or "Copied to clipboard!")
end

-- ══════════════════════════════════════════
--   FORMATTING HELPERS
-- ══════════════════════════════════════════

function c(t, col)
    t = tostring(t or "")
    if not col or col == "" then return t end
    return string.format('<font color="%s">%s</font>', tostring(col), t)
end

function b(t) return string.format("<b>%s</b>", t) end
function i(t) return string.format("<i>%s</i>", t) end
function sz(t, size) return string.format('<font size="%d">%s</font>', size, t) end

function hexToRgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

function rgbToHex(r, g, b)
    return string.format("#%02x%02x%02x", math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
end

function lerp(a, b, t) return a + (b - a) * t end

function createGradientText(word, startHex, endHex)
    local r1, g1, b1 = hexToRgb(startHex)
    local r2, g2, b2 = hexToRgb(endHex)
    local result = ""
    local len = #word
    if len == 0 then return "" end
    if len == 1 then return string.format('<font color="%s">%s</font>', startHex, word) end
    for j = 1, len do
        local t = (j - 1) / (len - 1)
        local r = math.round(lerp(r1, r2, t))
        local g = math.round(lerp(g1, g2, t))
        local b = math.round(lerp(b1, b2, t))
        local char = word:sub(j, j)
        if char == " " then
            result = result .. " "
        else
            result = result .. string.format('<font color="%s">%s</font>', rgbToHex(r, g, b), char)
        end
    end
    return result
end

function createMultiGradientText(word, colors)
    if #colors < 2 then return createGradientText(word, colors[1] or "#ffffff", colors[1] or "#ffffff") end
    local result = ""
    local len = #word
    if len == 0 then return "" end
    for j = 1, len do
        local globalT = (len == 1) and 0 or (j - 1) / (len - 1)
        local scaled = globalT * (#colors - 1)
        local idx = math.floor(scaled) + 1
        local localT = scaled - (idx - 1)
        local c1 = colors[math.min(idx, #colors)]
        local c2 = colors[math.min(idx + 1, #colors)]
        local r1, g1, b1 = hexToRgb(c1)
        local r2, g2, b2 = hexToRgb(c2)
        local r = math.round(lerp(r1, r2, localT))
        local g = math.round(lerp(g1, g2, localT))
        local b = math.round(lerp(b1, b2, localT))
        local char = word:sub(j, j)
        if char == " " then
            result = result .. " "
        else
            result = result .. string.format('<font color="%s">%s</font>', rgbToHex(r, g, b), char)
        end
    end
    return result
end

local PALETTE = {
    prism   = { "#38bdf8", "#a78bfa", "#ec4899" },
    aurora  = { "#4ade80", "#22d3ee", "#a78bfa" },
    sunset  = { "#fbbf24", "#f97316", "#ef4444" },
    ocean   = { "#38bdf8", "#0ea5e9", "#6366f1" },
    fire    = { "#fef08a", "#fb923c", "#dc2626" },
    ice     = { "#e0f2fe", "#7dd3fc", "#3b82f6" },
    rainbow = { "#ef4444", "#fbbf24", "#4ade80", "#22d3ee", "#a78bfa", "#ec4899" },
}

function formatNumber(n)
    if type(n) ~= "number" then return tostring(n) end
    local formatted = tostring(math.floor(n))
    while true do
        local newFormatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        formatted = newFormatted
        if k == 0 then break end
    end
    return formatted
end

function formatDuration(secs)
    secs = math.floor(secs)
    local h = math.floor(secs / 3600)
    local m = math.floor((secs % 3600) / 60)
    local s = secs % 60
    if h > 0 then return string.format("%dh %dm %ds", h, m, s) end
    if m > 0 then return string.format("%dm %ds", m, s) end
    return string.format("%ds", s)
end

-- Gradient [+] prefix generator for Info tab only
function gradPlus(colors)
    return createMultiGradientText("[+]", colors)
end

local DISCORD_INVITE = "https://discord.gg/DHeCNzTypH"
local RSCRIPTS_LINK  = "https://rscripts.net/@Prism"

-- ══════════════════════════════════════════
--   CREATE WINDOW
-- ══════════════════════════════════════════

local Window = Library:CreateWindow({
    Title            = "Prism",
    Footer           = "Prism  |  Anime Astral Simulator  |  v2.5",
    Icon             = "rbxassetid://117487160988921",
    MobileButtonSide = "Right",
    NotifySide       = "Right",
    ShowCustomCursor = false,
    CornerRadius     = 2,
	Animations = {
		ToggleWindow = false, -- Fade/scale the window when it is shown or hidden
		TabSwitch = true, -- Fade + slide the tab content when you switch tabs
		Groupbox = false,
		Dropdown = true,
		KeyPicker = true,
		SubTabUnderline = true, -- Slide the underline under the active sub tab (Default value = true)
	},
})

-- ══════════════════════════════════════════
--   PLAYER SYSTEM SETUP (FROM ORIGINAL)
-- ══════════════════════════════════════════

local FLYING = false
local QEfly = true
local iyflyspeed = 1
local vehicleflyspeed = 1
local flyKeyDown, flyKeyUp

local currentWalkSpeed = 16
local currentJumpPower = 50
local currentFlySpeed  = 60
local characterParts   = {}

function wpc_getRoot()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
end

function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function sFLY(vfly)
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
        humanoid = char:FindFirstChildOfClass("Humanoid")
    end

    if flyKeyDown or flyKeyUp then
        if flyKeyDown then flyKeyDown:Disconnect() end
        if flyKeyUp then flyKeyUp:Disconnect() end
    end

    local T = wpc_getRoot()
    if not T then return end

    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        task.spawn(function()
            repeat task.wait()
                local camera = workspace.CurrentCamera
                if not camera then continue end

                if not vfly and humanoid then
                    humanoid.PlatformStand = true
                end

                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = currentFlySpeed
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end

                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = camera.CFrame
            until not FLYING or Library.Unloaded

            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()

            if humanoid then humanoid.PlatformStand = false end
        end)
    end

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        local multi = (vfly and vehicleflyspeed or iyflyspeed)
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = multi
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -multi
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -multi
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = multi
        elseif input.KeyCode == Enum.KeyCode.E and QEfly then CONTROL.Q = multi * 2
        elseif input.KeyCode == Enum.KeyCode.Q and QEfly then CONTROL.E = -multi * 2
        end
    end)

    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0
        end
    end)

    FLY()
end

function updateCharParts(char)
    table.clear(characterParts)
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            table.insert(characterParts, p)
        end
    end
end

local charAddedConn = LocalPlayer.CharacterAdded:Connect(function(char)
    updateCharParts(char)
    local childAdded = char.DescendantAdded:Connect(function(p)
        if p:IsA("BasePart") then table.insert(characterParts, p) end
    end)
    local childRemoved = char.DescendantRemoving:Connect(function(p)
        local idx = table.find(characterParts, p)
        if idx then table.remove(characterParts, idx) end
    end)
    local deathConn
    deathConn = char:WaitForChild("Humanoid").Died:Connect(function()
        childAdded:Disconnect()
        childRemoved:Disconnect()
        deathConn:Disconnect()
    end)
end)

if LocalPlayer.Character then
    updateCharParts(LocalPlayer.Character)
end

local steppedConnection = RunService.Stepped:Connect(function()
    if Library.Unloaded then return end
    if isOn("NoClip") then
        for i = 1, #characterParts do
            local p = characterParts[i]
            if p and p.Parent then
                p.CanCollide = false
            end
        end
    end
end)

local jumpConnection = RunService.RenderStepped:Connect(function() end)
local renderConnection = RunService.RenderStepped:Connect(function()
    if Library.Unloaded then return end
    if isOn("WalkSpeedEnabled") then
        local h = getHumanoid()
        if h then h.WalkSpeed = currentWalkSpeed end
    end
    if isOn("JumpPowerEnabled") then
        local h = getHumanoid()
        if h then h.JumpPower = currentJumpPower end
    end
end)

local infJumpConnection = UserInputService.JumpRequest:Connect(function()
    if Library.Unloaded then return end
    if isOn("InfJump") then
        local h = getHumanoid()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ══════════════════════════════════════════
--   TABS
-- ══════════════════════════════════════════

local Tabs = {
    Info        = Window:AddTab("Info",            "activity"),
    Main        = Window:AddTab("Main",            "star"),
    Farm        = Window:AddTab("Mob Farm",        "sword"),
    Gamemodes   = Window:AddTab("Gamemodes",       "gamepad-2"),
    Config      = Window:AddTab("Loadouts / Potions", "sliders-horizontal"),
    Gacha       = Window:AddTab("Gacha",           "sparkles"),
    Progression = Window:AddTab("Progression",     "trending-up"),
    Star        = Window:AddTab("Star",            "star"),
    Quests      = Window:AddTab("Quests",          "scroll-text"),
    Promotion   = Window:AddTab("Promotion",       "medal"),
    Player      = Window:AddTab("Player",          "user-check"),
    Settings    = Window:AddTab("Settings",        "settings"),
}

-- Gamemodes SubTabs
Tabs.Priority = Tabs.Gamemodes:AddSubTab("Priority", "triangle-alert")
Tabs.Raid     = Tabs.Gamemodes:AddSubTab("Raid",     "zap")
Tabs.Defense  = Tabs.Gamemodes:AddSubTab("Defense",  "shield")
Tabs.Dungeon  = Tabs.Gamemodes:AddSubTab("Dungeon",  "door-open")
Tabs.Rush     = Tabs.Gamemodes:AddSubTab("Rush",     "skull")
Tabs.Trial    = Tabs.Gamemodes:AddSubTab("Trial",    "clock")
Tabs.Gate     = Tabs.Gamemodes:AddSubTab("Gate",     "shield")
Tabs.Loadouts = Tabs.Config:AddSubTab("Loadouts",    "layers-2")
Tabs.Potions  = Tabs.Config:AddSubTab("Potions",     "flask-conical")

-- ══════════════════════════════════════════
--   INFO TAB (GRADIENT ENABLED)
-- ══════════════════════════════════════════

do
    local PrismBox = Tabs.Info:AddLeftGroupbox("Prism", "sparkles")
    PrismBox:AddLabel(sz(b(createMultiGradientText("PRISM", PALETTE.prism)), 20), true)
    PrismBox:AddLabel(c(i("keyless forever, always will be"), "#9ca3af"), true)
    PrismBox:AddLabel(
        c(b("status "),  "#6b7280") .. c(b("online"), "#4ade80") ..
        c("     ",       "#374151") ..
        c(b("version "), "#6b7280") .. c(b("4.6"), "#38bdf8"),
    true)
    PrismBox:AddDivider()
    PrismBox:AddLabel(sz(b(createMultiGradientText("if you enjoy the script or want to report a bug, please consider the following:", PALETTE.ice)), 14), true)
    PrismBox:AddLabel(sz(b(createMultiGradientText("more than 60 keyless scripts in this hub, I would love your support!", PALETTE.ice)), 14), true)    PrismBox:AddButton({ Text = "Discord for Support 💝",     Func = function() copyText(DISCORD_INVITE, "Discord invite copied!") end })
    PrismBox:AddButton({ Text = "Follow Rscripts 🙏", Func = function() copyText(RSCRIPTS_LINK, "Rscripts link copied!") end })

    local FeaturesBox = Tabs.Info:AddLeftGroupbox("Features", "layers")
    local featureList = {
        "Auto Farm Mobs",
        "Auto Farm Raid",
        "Auto Farm Defense",
        "Auto Farm Trial",
        "Auto Farm Gate",
        "Auto Farm Dungeon",
        "Auto Farm Boss Rush",
        "Auto Farm Cursed Rush",
        "Auto Spawn Z Boss",
        "Priority System",
        "Auto Gacha",
        "Auto Passives",
        "Auto Swords",
        "Auto Progression",
        "Auto Upgrades",
        "Auto Global Quests",
        "Auto Promotion Quests",
        "Auto Crow, Ball, Commandment",
        "Auto Star",
        "Auto Craft",
        "Auto Evolution",
        "Auto Upgrade Skill Tree",
        "Auto Upgrade Constellation",
        "Auto Pause/Unpause Potions",
        "Auto Swap Loadouts",
        "Anti AFK",
        "Fly, NoClip, WalkSpeed",
    }
    for _, item in ipairs(featureList) do
        FeaturesBox:AddLabel(gradPlus(PALETTE.prism) .. c(" " .. item, "#f3f4f6"), true)
    end

    local DiagnosticBox = Tabs.Info:AddRightGroupbox("Live", "cpu")
    local FpsLabel     = DiagnosticBox:AddLabel(b("FPS: ")    .. c("...", "#60a5fa"), true)
    local PingLabel    = DiagnosticBox:AddLabel(b("Ping: ")   .. c("...", "#4ade80"), true)
    local MemoryLabel  = DiagnosticBox:AddLabel(b("Memory: ") .. c("...", "#fbbf24"), true)
    local SessionLabel = DiagnosticBox:AddLabel(b("Uptime: ") .. c("0s",  "#a78bfa"), true)

    local sessionStart = SessionStats.startTime
    local frameCount = 0
    local lastFpsUpdate = os.clock()

    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = os.clock()
        if now - lastFpsUpdate >= 0.5 then
            local fps = math.floor(frameCount / (now - lastFpsUpdate))
            frameCount = 0
            lastFpsUpdate = now
            if not Library.Unloaded then
                local ping = math.floor(StatsService.PerformanceStats.Ping:GetValue())
                local mem  = math.floor(StatsService:GetTotalMemoryUsageMb())
                local fpsColor  = fps > 45 and "#4ade80" or (fps > 25 and "#fbbf24" or "#ef4444")
                local pingColor = ping < 80 and "#4ade80" or (ping < 150 and "#fbbf24" or "#ef4444")
                FpsLabel:SetText(b("FPS: ")    .. c(tostring(fps), fpsColor))
                PingLabel:SetText(b("Ping: ")  .. c(tostring(ping) .. " ms", pingColor))
                MemoryLabel:SetText(b("Memory: ") .. c(tostring(mem) .. " MB", "#fbbf24"))
            end
        end
    end)

    task.spawn(function()
        while not Library.Unloaded do
            task.wait(1)
            SessionLabel:SetText(b("Uptime: ") .. c(formatDuration(os.clock() - sessionStart), "#a78bfa"))
        end
    end)

    local SessionBox = Tabs.Info:AddRightGroupbox("Roblox", "server")
    SessionBox:AddLabel(b(createMultiGradientText("EXTRA INFO", PALETTE.aurora)), true)
    SessionBox:AddDivider()
    SessionBox:AddLabel(b("User: ")     .. c(LocalPlayer.Name, "#ffffff"), true)
    SessionBox:AddLabel(b("Executor: ") .. c(executorName, "#fb923c"), true)
    SessionBox:AddLabel(b("Place ID: ") .. c(tostring(game.PlaceId), "#60a5fa"), true)
    SessionBox:AddLabel(b("Job ID: ")   .. c(string.sub(tostring(game.JobId), 1, 14) .. "...", "#9ca3af"), true)
    SessionBox:AddDivider()
    SessionBox:AddButton({
        Text = "Copy Server ID",
        Func = function() copyText(game.JobId, "Server JobId copied!") end,
    })
    SessionBox:AddButton({
        Text = "Copy Rejoin Script",
        Func = function()
            copyText(string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId), "Rejoin script copied!")
        end,
    })
end

-- ══════════════════════════════════════════
--   CORE GAME HELPERS
-- ══════════════════════════════════════════

function aas_getHolePosition(hole)
    if hole.PrimaryPart then return hole.PrimaryPart.Position end
    if hole:IsA("BasePart") then return hole.Position end
    local part = hole:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

function aas_teleportToMob(mob)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("PrimaryPart") or mob:FindFirstChildOfClass("BasePart")
    if not mobRoot then return end
    hrp.CFrame = mobRoot.CFrame * CFrame.new(0, 0, 4)
    hrp.AssemblyLinearVelocity = Vector3.zero
end

function aas_waitForDead(mob, timeoutSecs)
    timeoutSecs = timeoutSecs or 30
    local deadline = tick() + timeoutSecs
    while tick() < deadline do
        if not mob or not mob.Parent then return true end
        if mob:GetAttribute("EnemyDead") == true then return true end
        task.wait(0.05)
    end
    return false
end

function aas_findMobsInFolder(enemiesFolder, selectedNames)
    if not enemiesFolder then return {} end
    local found = {}
    if selectedNames and #selectedNames > 0 then
        local nameSet = {}
        for _, n in ipairs(selectedNames) do nameSet[n] = true end
        for _, child in ipairs(enemiesFolder:GetChildren()) do
            if nameSet[child.Name] and child:GetAttribute("EnemyDead") ~= true then
                table.insert(found, child)
            end
        end
    else
        for _, child in ipairs(enemiesFolder:GetChildren()) do
            if child:GetAttribute("EnemyDead") ~= true then
                table.insert(found, child)
            end
        end
    end
    return found
end

function aas_teleportToWorld(worldIdx)
    pcall(function() aas_requestChangeWorldRemote:Fire(worldIdx) end)
    task.wait(2.5)
end

function aas_tryGetCurrentWorldId()
    local ok, data = pcall(function() return aas_getPlayerDataFunc:InvokeServer() end)
    if not ok or type(data) ~= "table" then return nil end
    return tonumber(data.ActiveWorld or data.CurrentWorld or data.WorldId or data.World or data.PlayerWorld)
end

function aas_changeWorldAndWait(worldId)
    pcall(function() aas_requestChangeWorldRemote:Fire(worldId) end)
    task.wait(AAS_WORLD_SWITCH_WAIT)
    local deadline = tick() + 2
    while tick() < deadline do
        local currentWorld = aas_tryGetCurrentWorldId()
        if currentWorld and currentWorld == tonumber(worldId) then task.wait(0.5) return true end
        task.wait(0.25)
    end
    return true
end

function aas_equipLoadout(stat)
    if not stat or stat == "" then return end
    pcall(function() aas_equipBestLoadoutRemote:Fire(stat) end)
    task.wait(0.5)
end

function aas_findArenaChild(arenaFolder, key)
    if not arenaFolder then return nil end
    for _, child in ipairs(arenaFolder:GetChildren()) do
        if child.Name == key or child.Name:sub(1, #key + 1) == key .. "_" then return child end
    end
    return nil
end

function aas_raidArenaExists(raidKey)
    local arenas = workspace:FindFirstChild("RaidArenas")
    if not arenas then return false end
    for _, child in ipairs(arenas:GetChildren()) do
        if child.Name == raidKey or child.Name:sub(1, #raidKey + 1) == raidKey .. "_" then return true end
    end
    return false
end

function aas_defenseArenaExists(defKey)
    local arenas = workspace:FindFirstChild("DefenseArenas")
    if not arenas then return false end
    for _, child in ipairs(arenas:GetChildren()) do
        if child.Name == defKey or child.Name:sub(1, #defKey + 1) == defKey .. "_" then return true end
    end
    return false
end

function aas_dungeonArenaExists(dungeonKey)
    local arenas = workspace:FindFirstChild("DungeonArenas")
    if not arenas then return false end
    if dungeonKey then
        for _, child in ipairs(arenas:GetChildren()) do
            if child.Name == dungeonKey or child.Name:sub(1, #dungeonKey + 1) == dungeonKey .. "_" then return true end
        end
        return false
    end
    return #arenas:GetChildren() > 0
end

function aas_trialArenaExists(trialKey)
    local arenas = workspace:FindFirstChild("TimeTrialArenas")
    if not arenas then return false end
    for _, child in ipairs(arenas:GetChildren()) do
        if child.Name == trialKey or child.Name:sub(1, #trialKey + 1) == trialKey .. "_" then return true end
    end
    return false
end

function aas_gateArenaExists()
    local arenas = workspace:FindFirstChild("RaidArenas")
    if not arenas then return false end
    for _, child in ipairs(arenas:GetChildren()) do
        if child.Name == "World5" or child.Name:sub(1, 7) == "World5_" then return true end
    end
    return false
end

function aas_rushArenaExists(rushKey)
    local arenas = workspace:FindFirstChild("BossRushArenas")
    if not arenas then return false, nil end
    for _, child in ipairs(arenas:GetChildren()) do
        if child.Name:sub(1, #rushKey) == rushKey then return true, child end
    end
    return false, nil
end

function aas_anyRaidActive()    return S.activeRaidKey ~= nil end
function aas_anyDefenseActive() return S.activeDefenseKey ~= nil end
function aas_anyDungeonActive() return S.activeDungeonKey ~= nil end
function aas_anyRushActive()    return S.activeRushKey ~= nil end

function aas_anySpawnBossActive()
    for _, bossId in ipairs(S.sortedSpawnBossKeys) do
        if S.spawnBossEnabled[bossId] then return true end
    end
    return false
end

function aas_findSpawnBossMob(bossId)
    local bossData = S.SpawnBossList[bossId]
    if not bossData then return nil end
    local worldFolder = workspace:FindFirstChild("Worlds")
    if not worldFolder then return nil end
    local wChild = worldFolder:FindFirstChild(tostring(bossData.WorldId))
    if not wChild then return nil end
    local enemies = wChild:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, child in ipairs(enemies:GetChildren()) do
        if child.Name == bossData.Name or child.Name == bossData.EnemyId then
            if child:GetAttribute("EnemyDead") ~= true then
                return child
            end
        end
    end
    return nil
end

function aas_waitForSpawnBossMob(bossId, timeoutSecs)
    timeoutSecs = timeoutSecs or 10
    local deadline = tick() + timeoutSecs
    while tick() < deadline do
        if not S.spawnBossEnabled[bossId] then return nil end
        local mob = aas_findSpawnBossMob(bossId)
        if mob and mob.Parent and mob:GetAttribute("EnemyDead") ~= true then
            return mob
        end
        task.wait(0.25)
    end
    return nil
end

function aas_getPriorityRank(activityType)
    for i, v in ipairs(S.priorityOrder) do if v == activityType then return i end end
    return 999
end

function aas_hasHigherPriority(activityA, activityB)
    return aas_getPriorityRank(activityA) < aas_getPriorityRank(activityB)
end

function aas_isHighPriorityActivityRunning()
    for _, tk in ipairs(S.sortedTrialKeys) do
        if S.trialEnabled[tk] and aas_trialArenaExists(tk) then return true, "Trial" end
    end
    if S.gateEnabled and aas_gateArenaExists() then return true, "Gate" end
    for _, dk in ipairs(S.sortedDungeonKeys) do
        if S.dungeonEnabled[dk] and aas_dungeonArenaExists(dk) then return true, "Dungeon" end
    end
    return false, nil
end

function aas_isHighPrioritySpawnOrRunPresent()
    for _, tk in ipairs(S.sortedTrialKeys) do
        if S.trialEnabled[tk] and aas_trialArenaExists(tk) then return true, "Trial" end
    end
    local gateSpawned = false
    pcall(function()
        gateSpawned = S.gateEnabled and workspace.Worlds["5"].Systems.RaidStation:FindFirstChild("ActiveGate") ~= nil
    end)
    if gateSpawned or (S.gateEnabled and aas_gateArenaExists()) then return true, "Gate" end
    for _, dk in ipairs(S.sortedDungeonKeys) do
        if S.dungeonEnabled[dk] and aas_dungeonArenaExists(dk) then return true, "Dungeon" end
    end
    return false, nil
end

function aas_monitorForConflicts(ownType, windowSecs)
    windowSecs = windowSecs or AAS_PRIORITY_WINDOW
    local deadline = tick() + windowSecs
    local highestConflict, highestRank = nil, aas_getPriorityRank(ownType)
    while tick() < deadline do
        if ownType ~= "Trial" then
            for _, tk in ipairs(S.sortedTrialKeys) do
                if S.trialEnabled[tk] and aas_trialArenaExists(tk) then
                    local rank = aas_getPriorityRank("Trial")
                    if rank < highestRank then highestRank = rank highestConflict = "Trial" end
                end
            end
        end
        if ownType ~= "Gate" and S.gateEnabled and aas_gateArenaExists() then
            local rank = aas_getPriorityRank("Gate")
            if rank < highestRank then highestRank = rank highestConflict = "Gate" end
        end
        if ownType ~= "Dungeon" then
            for _, dk in ipairs(S.sortedDungeonKeys) do
                if S.dungeonEnabled[dk] and aas_dungeonArenaExists(dk) then
                    local rank = aas_getPriorityRank("Dungeon")
                    if rank < highestRank then highestRank = rank highestConflict = "Dungeon" end
                end
            end
        end
        task.wait(0.5)
    end
    return highestConflict
end

-- ══════════════════════════════════════════
--   POTION SYSTEM
-- ══════════════════════════════════════════

function aas_getPotionContextSet(contextKey)
    local opt = Options["PotionCtx_" .. contextKey]
    if not opt then return {} end
    local result = {}
    for potionId, state in pairs(opt.Value or {}) do if state then result[potionId] = true end end
    return result
end

function aas_applyPotionContext(contextKey)
    if not S.potionContextEnabled then return end
    local wantedSet = aas_getPotionContextSet(contextKey)
    pcall(function()
        local data = aas_getPlayerDataFunc:InvokeServer()
        if data and type(data.ActivePotions) == "table" then S.activePotions = data.ActivePotions end
    end)
    for potionId, potionState in pairs(S.activePotions) do
        local shouldBeActive = wantedSet[potionId] == true
        local isCurrentlyPaused = potionState.Paused == true
        if shouldBeActive and isCurrentlyPaused then
            pcall(function() aas_potionPauseToggleRemote:Fire(potionId) end)
            task.wait(0.15)
        elseif not shouldBeActive and not isCurrentlyPaused then
            pcall(function() aas_potionPauseToggleRemote:Fire(potionId) end)
            task.wait(0.15)
        end
    end
    S.currentPotionContext = contextKey
    if S.potionStatusLabelRef then
        S.potionStatusLabelRef:SetText("Context: " .. contextKey)
    end
end

function aas_pauseAllPotions()
    pcall(function()
        local data = aas_getPlayerDataFunc:InvokeServer()
        if data and type(data.ActivePotions) == "table" then S.activePotions = data.ActivePotions end
    end)
    for potionId, potionState in pairs(S.activePotions) do
        if not potionState.Paused then
            pcall(function() aas_potionPauseToggleRemote:Fire(potionId) end)
            task.wait(0.15)
        end
    end
end

function aas_enterPotionContext(contextKey)
    if not S.potionContextEnabled then return end
    if S.currentPotionContext == contextKey then return end
    aas_applyPotionContext(contextKey)
end

function aas_clearPotionContext()
    if not S.potionContextEnabled then return end
    S.currentPotionContext = nil
    if S.potionStatusLabelRef then S.potionStatusLabelRef:SetText("Context: Idle") end
    aas_pauseAllPotions()
end

function aas_autoUsePotionLoop()
    while S.potionAutoUseEnabled do
        local opt = Options["PotionAutoUseSelect"]
        if opt then
            for potionId, state in pairs(opt.Value or {}) do
                if state then
                    pcall(function()
                        local args = { [1] = { [1] = { ["__BridgeTuplePayload__"] = true, ["Payload"] = { [1] = potionId, [2] = 1, ["n"] = 2 } }, [2] = "\5\1" } }
                        aas_bridgeDataRemote:FireServer(unpack(args))
                    end)
                    task.wait(0.5)
                end
            end
        end
        task.wait(30)
    end
end

-- ══════════════════════════════════════════
--   SNAPSHOT & RESUME
-- ══════════════════════════════════════════

function aas_snapshotAndPauseActivities()
    local snapshot = { farmWasActive=false, raidKey=nil, defenseKey=nil, dungeonKey=nil, rushKey=nil }

    if S.farmEnabled then
        snapshot.farmWasActive = true
        S.farmEnabled = false
        if S.farmThread then task.cancel(S.farmThread) S.farmThread = nil end
        S.currentWorldTracked = nil
    end

    if S.activeRaidKey then
        snapshot.raidKey = S.activeRaidKey
        local rk = S.activeRaidKey
        S.raidEnabled[rk] = false S.activeRaidKey = nil
        if S.raidThread then task.cancel(S.raidThread) S.raidThread = nil end
        if aas_raidArenaExists(rk) then pcall(function() aas_raidLeaveRemote:Fire() end) end
        task.wait(1)
    end

    if S.activeDefenseKey then
        snapshot.defenseKey = S.activeDefenseKey
        local dk = S.activeDefenseKey
        S.defenseEnabled[dk] = false S.activeDefenseKey = nil
        if S.defenseThread then task.cancel(S.defenseThread) S.defenseThread = nil end
        if aas_defenseArenaExists(dk) then pcall(function() aas_defenseLeaveRemote:Fire() end) end
        task.wait(1)
    end

    if S.activeDungeonKey then
        snapshot.dungeonKey = S.activeDungeonKey
        local dunk = S.activeDungeonKey
        S.dungeonEnabled[dunk] = false S.activeDungeonKey = nil
        if S.dungeonThreads[dunk] then task.cancel(S.dungeonThreads[dunk]) S.dungeonThreads[dunk] = nil end
        if aas_dungeonArenaExists(dunk) then pcall(function() aas_dungeonLeaveRemote:Fire() end) end
        task.wait(1)
    end

    if S.globalQuestEnabled then
        snapshot.globalQuestWasActive = true
        S.globalQuestEnabled = false
        if S.globalQuestThread then task.cancel(S.globalQuestThread) S.globalQuestThread = nil end
        S.globalQuestCurrentTarget = nil S.globalQuestCurrentAction = nil
    end

    if S.activeRushKey then
        snapshot.rushKey = S.activeRushKey
        local rk = S.activeRushKey
        S.rushEnabled[rk] = false S.activeRushKey = nil
        if S.rushThreads[rk] then task.cancel(S.rushThreads[rk]) S.rushThreads[rk] = nil end
        pcall(function() aas_bossRushLeaveRemote:Fire() end)
        task.wait(1)
    end

    snapshot.spawnBossKeys = {}
    for _, bossId in ipairs(S.sortedSpawnBossKeys) do
        if S.spawnBossEnabled[bossId] then
            table.insert(snapshot.spawnBossKeys, bossId)
            S.spawnBossEnabled[bossId] = false
            if S.spawnBossThreads[bossId] then
                task.cancel(S.spawnBossThreads[bossId])
                S.spawnBossThreads[bossId] = nil
            end
        end
    end

    return snapshot
end

function aas_resumeIndependentThreads(snapshot)
    if snapshot and snapshot.globalQuestWasActive then
        if Toggles["GQFarmerEnabled"] and Toggles["GQFarmerEnabled"].Value then
            S.globalQuestEnabled = true
            if S.globalQuestThread then task.cancel(S.globalQuestThread) end
            S.globalQuestThread = task.spawn(aas_globalQuestLoop)
        end
    end
end

function aas_resumeFromSnapshot(snapshot)
    if not snapshot then return end
    task.wait(1)

    for _, tk in ipairs(S.sortedTrialKeys) do
        if S.trialEnabled[tk] and aas_trialArenaExists(tk) then
            aas_resumeIndependentThreads(snapshot)
            return
        end
    end
    if S.gateEnabled and aas_gateArenaExists() then
        aas_resumeIndependentThreads(snapshot)
        return
    end
    for _, dk in ipairs(S.sortedDungeonKeys) do
        if S.dungeonEnabled[dk] and aas_dungeonArenaExists(dk) then
            aas_resumeIndependentThreads(snapshot)
            return
        end
    end

    task.wait(1)

    if snapshot.farmWasActive then
        local farmStat = S.LoadoutAssignments.Farm or "Power"
        aas_equipLoadout(farmStat)
        aas_enterPotionContext("Farm")
        S.farmEnabled = true
        if S.farmThread then task.cancel(S.farmThread) end
        S.farmThread = task.spawn(aas_farmLoop)
    end

    if snapshot.raidKey then
        local rk = snapshot.raidKey
        if Toggles["AutoRaid_"..rk] and Toggles["AutoRaid_"..rk].Value then
            aas_equipLoadout(S.RaidLoadouts[rk] or "Power")
            aas_enterPotionContext("Raid_"..rk)
            S.raidEnabled[rk] = true S.activeRaidKey = rk
            if S.raidThread then task.cancel(S.raidThread) end
            S.raidThread = task.spawn(function() aas_raidLoop(rk) end)
        end
    end

    if snapshot.defenseKey then
        local dk = snapshot.defenseKey
        if Toggles["AutoDefense_"..dk] and Toggles["AutoDefense_"..dk].Value then
            local defData = S.DefenseList[dk]
            if defData and defData.WorldId then pcall(function() aas_requestChangeWorldRemote:Fire(defData.WorldId) end) task.wait(3) end
            aas_equipLoadout(S.DefenseLoadouts[dk] or "Power")
            aas_enterPotionContext("Defense_"..dk)
            S.defenseEnabled[dk] = true S.activeDefenseKey = dk
            if S.defenseThread then task.cancel(S.defenseThread) end
            S.defenseThread = task.spawn(function() aas_defenseLoop(dk) end)
        end
    end

    if snapshot.dungeonKey then
        local dunk = snapshot.dungeonKey
        if Toggles["AutoDungeon_"..dunk] and Toggles["AutoDungeon_"..dunk].Value then
            aas_equipLoadout(S.DungeonLoadouts[dunk] or "Power")
            aas_enterPotionContext("Dungeon_"..dunk)
            S.dungeonEnabled[dunk] = true S.activeDungeonKey = dunk
            if S.dungeonThreads[dunk] then task.cancel(S.dungeonThreads[dunk]) end
            S.dungeonThreads[dunk] = task.spawn(function() aas_dungeonLoop(dunk) end)
        end
    end

    if snapshot.rushKey then
        local rk = snapshot.rushKey
        if Toggles["AutoRush_"..rk] and Toggles["AutoRush_"..rk].Value then
            aas_equipLoadout(S.RushLoadouts[rk] or "Power")
            aas_enterPotionContext("Rush_"..rk)
            S.rushEnabled[rk] = true S.activeRushKey = rk
            if S.rushThreads[rk] then task.cancel(S.rushThreads[rk]) end
            S.rushThreads[rk] = task.spawn(function() aas_rushLoop(rk) end)
        end
    end

    if snapshot.spawnBossKeys then
        for _, bossId in ipairs(snapshot.spawnBossKeys) do
            if Toggles["AutoSpawnBoss_" .. bossId] and Toggles["AutoSpawnBoss_" .. bossId].Value then
                S.spawnBossEnabled[bossId] = true
                if S.spawnBossThreads[bossId] then task.cancel(S.spawnBossThreads[bossId]) end
                S.spawnBossThreads[bossId] = task.spawn(function() aas_spawnBossLoop(bossId) end)
            end
        end
    end

    if snapshot.globalQuestWasActive then
        if Toggles["GQFarmerEnabled"] and Toggles["GQFarmerEnabled"].Value then
            S.globalQuestEnabled = true
            if S.globalQuestThread then task.cancel(S.globalQuestThread) end
            S.globalQuestThread = task.spawn(aas_globalQuestLoop)
        end
    end
end

-- ══════════════════════════════════════════
--   CLUSTER FARMING
-- ══════════════════════════════════════════

function aas_getClusterCenter(mobs, clusterRadius, minClusterSize)
    clusterRadius = clusterRadius or 40
    minClusterSize = minClusterSize or 1
    if #mobs == 0 then return nil, {} end
    local bestCenter, bestCluster, bestCount = nil, {}, 0
    for _, mobA in ipairs(mobs) do
        local posA = (mobA:FindFirstChild("HumanoidRootPart") and mobA.HumanoidRootPart.Position)
            or (mobA.PrimaryPart and mobA.PrimaryPart.Position) or nil
        if not posA then continue end
        local cluster, sumX, sumY, sumZ = {}, 0, 0, 0
        for _, mobB in ipairs(mobs) do
            if mobB:GetAttribute("EnemyDead") == true or not mobB.Parent then continue end
            local posB = (mobB:FindFirstChild("HumanoidRootPart") and mobB.HumanoidRootPart.Position)
                or (mobB.PrimaryPart and mobB.PrimaryPart.Position) or nil
            if not posB then continue end
            if (posA - posB).Magnitude <= clusterRadius then
                table.insert(cluster, mobB)
                sumX = sumX + posB.X sumY = sumY + posB.Y sumZ = sumZ + posB.Z
            end
        end
        if #cluster > bestCount then
            bestCount = #cluster bestCluster = cluster
            bestCenter = Vector3.new(sumX/#cluster, sumY/#cluster, sumZ/#cluster)
        end
    end
    if bestCount >= minClusterSize and bestCenter then return bestCenter, bestCluster end
    local fallbackPos = (mobs[1]:FindFirstChild("HumanoidRootPart") and mobs[1].HumanoidRootPart.Position)
        or (mobs[1].PrimaryPart and mobs[1].PrimaryPart.Position) or nil
    return fallbackPos, { mobs[1] }
end

function aas_teleportToClusterCenter(centerPos)
    if not centerPos then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(centerPos)
    hrp.AssemblyLinearVelocity = Vector3.zero
end

function aas_waitForClusterDead(cluster, timeoutSecs)
    timeoutSecs = timeoutSecs or 30
    local deadline = tick() + timeoutSecs
    while tick() < deadline do
        local allDead = true
        for _, mob in ipairs(cluster) do
            if mob and mob.Parent and mob:GetAttribute("EnemyDead") ~= true then allDead = false break end
        end
        if allDead then return true end
        task.wait(0.05)
    end
    return false
end

-- ══════════════════════════════════════════
--   AUTO MOB FARM LOOP
-- ══════════════════════════════════════════

function aas_getSelectedForWorld(worldIdx)
    local key = S.worldDropdowns[worldIdx]
    if not key then return {} end
    local opt = Options[key]
    if not opt then return {} end
    local selected = {}
    for name, state in pairs(opt.Value or {}) do
        if state and name ~= "None" then table.insert(selected, name) end
    end
    return selected
end

function aas_getWorldsWithSelections()
    local worlds = {}
    for _, worldIdx in ipairs(S.sortedWorldIndices) do
        if #aas_getSelectedForWorld(worldIdx) > 0 then table.insert(worlds, worldIdx) end
    end
    return worlds
end

function aas_findMobsInWorld(worldIdx, selectedNames)
    local worldFolder = workspace:FindFirstChild("Worlds")
    if not worldFolder then return {} end
    local wChild = worldFolder:FindFirstChild(tostring(worldIdx))
    if not wChild then return {} end
    return aas_findMobsInFolder(wChild:FindFirstChild("Enemies"), selectedNames)
end

function aas_preloadWorld7Boss()
    local ok = pcall(function()
        local bossSpawn = workspace.Worlds["7"].Map["black clover boss"]
        if not bossSpawn then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local targetPos = nil
        if bossSpawn:IsA("BasePart") then targetPos = bossSpawn.Position
        elseif bossSpawn:IsA("Model") then
            if bossSpawn.PrimaryPart then targetPos = bossSpawn.PrimaryPart.Position
            else
                local firstPart = bossSpawn:FindFirstChildWhichIsA("BasePart", true)
                if firstPart then targetPos = firstPart.Position
                else local bbOk, cf = pcall(function() return bossSpawn:GetBoundingBox() end)
                    if bbOk and cf then targetPos = cf.Position end
                end
            end
        end
        if targetPos then
            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
    task.wait(3)
end

function aas_farmLoop()
    S.currentWorldTracked = nil
    while S.farmEnabled do
        local worlds = aas_getWorldsWithSelections()
        if #worlds == 0 then task.wait(0.5) continue end

        for _, worldIdx in ipairs(worlds) do
            if not S.farmEnabled then break end
            if S.currentWorldTracked ~= worldIdx then
                aas_teleportToWorld(worldIdx)
                S.currentWorldTracked = worldIdx
            end
            local selectedNames = aas_getSelectedForWorld(worldIdx)
            if #selectedNames == 0 then continue end

            if worldIdx == 7 then
                local needsLucies = false
                for _, name in ipairs(selectedNames) do if name == "Lucies" then needsLucies = true break end end
                if needsLucies then
                    local lf = workspace:FindFirstChild("Worlds")
                    lf = lf and lf:FindFirstChild("7") lf = lf and lf:FindFirstChild("Enemies")
                    if not (lf and lf:FindFirstChild("Lucies")) then aas_preloadWorld7Boss() end
                end
            end

            local mobs = aas_findMobsInWorld(worldIdx, selectedNames)
            if #mobs == 0 then task.wait(1) continue end

            local aliveMobs = {}
            for _, mob in ipairs(mobs) do
                if mob and mob.Parent and mob:GetAttribute("EnemyDead") ~= true then
                    local currentSelected = aas_getSelectedForWorld(worldIdx)
                    local stillWanted = false
                    for _, n in ipairs(currentSelected) do if n == mob.Name then stillWanted = true break end end
                    if stillWanted then table.insert(aliveMobs, mob) end
                end
            end
            if #aliveMobs == 0 then task.wait(0.5) continue end

            if S.clusterFarmEnabled then
                local centerPos, cluster = aas_getClusterCenter(aliveMobs, 40, 1)
                if centerPos then
                    aas_teleportToClusterCenter(centerPos)
                    aas_waitForClusterDead(cluster, 25)
                end
                task.wait(0.05)
            else
                for _, mob in ipairs(aliveMobs) do
                    if not S.farmEnabled then break end
                    if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                    aas_teleportToMob(mob)
                    aas_waitForDead(mob, 25)
                    task.wait(0.05)
                end
            end
        end
        task.wait(0.05)
    end
    S.currentWorldTracked = nil
end

-- ══════════════════════════════════════════
--   GAMEMODE LOOPS
-- ══════════════════════════════════════════

-- RAID
function aas_getCurrentRaidWave()
    local ok, result = pcall(function() return LocalPlayer.PlayerGui.RaidGui.Main.Wave.Text end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Wave%s+(%d+)/")) or 0
end

function aas_getRaidLeaveAtWave(raidKey)
    local opt = Options["RaidLeaveWave_"..raidKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

function aas_getRaidEnemiesFolder(raidKey)
    local arenas = workspace:FindFirstChild("RaidArenas")
    if not arenas then return nil end
    local arena = aas_findArenaChild(arenas, raidKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

function aas_joinOrCreateRaid(raidKey)
    if aas_raidArenaExists(raidKey) then pcall(function() aas_raidJoinRemote:Fire("Join", raidKey) end)
    else pcall(function() aas_raidJoinRemote:Fire("Create", raidKey) end) end
end

function aas_leaveRaid() pcall(function() aas_raidLeaveRemote:Fire() end) end

function aas_waitForRaidArena(raidKey, timeoutSecs)
    timeoutSecs = timeoutSecs or 10
    local deadline = tick() + timeoutSecs
    while tick() < deadline do if aas_raidArenaExists(raidKey) then return true end task.wait(0.5) end
    return false
end

function aas_disableOtherRaids(exceptKey)
    for _, rk in ipairs(S.sortedRaidKeys) do
        if rk ~= exceptKey and S.raidEnabled[rk] then
            S.raidEnabled[rk] = false
            local tk = "AutoRaid_"..rk
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
        end
    end
end

function aas_disableAllDefenses()
    for _, dk in ipairs(S.sortedDefenseKeys) do
        if S.defenseEnabled[dk] then
            S.defenseEnabled[dk] = false
            local tk = "AutoDefense_"..dk
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
        end
    end
    if S.defenseThread then task.cancel(S.defenseThread) S.defenseThread = nil end
    S.activeDefenseKey = nil
end

function aas_raidLoop(raidKey)
    local raidData = S.RaidList[raidKey]
    if not raidData then return end
    aas_equipLoadout(S.RaidLoadouts[raidKey] or "Power")
    aas_enterPotionContext("Raid_"..raidKey)
    aas_joinOrCreateRaid(raidKey) aas_waitForRaidArena(raidKey, 10) task.wait(5)
    while S.raidEnabled[raidKey] do
        local leaveAt = aas_getRaidLeaveAtWave(raidKey)
        if leaveAt > 0 then
            local cw = aas_getCurrentRaidWave()
            if cw > 0 and cw >= leaveAt then
                aas_leaveRaid() task.wait(6)
                if not S.raidEnabled[raidKey] then break end
                aas_joinOrCreateRaid(raidKey) aas_waitForRaidArena(raidKey, 10) task.wait(5) continue
            end
        end
        if not aas_raidArenaExists(raidKey) then
            task.wait(6)
            if not S.raidEnabled[raidKey] then break end
            aas_joinOrCreateRaid(raidKey) aas_waitForRaidArena(raidKey, 10) task.wait(5) continue
        end
        if S.raidOptimizedFarm then task.wait(0.5)
        else
            local mobs = aas_findMobsInFolder(aas_getRaidEnemiesFolder(raidKey), nil)
            if #mobs == 0 then task.wait(0.5) continue end
            for _, mob in ipairs(mobs) do
                if not S.raidEnabled[raidKey] then break end
                if not aas_raidArenaExists(raidKey) then break end
                if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                aas_teleportToMob(mob) aas_waitForDead(mob, 15) task.wait(0.05)
            end
        end
        task.wait(0.05)
    end
    if aas_raidArenaExists(raidKey) then aas_leaveRaid() end
    S.activeRaidKey = nil
end

-- DEFENSE
function aas_getCurrentDefenseWave()
    local ok, result = pcall(function() return LocalPlayer.PlayerGui.DefenseGui.Main.Wave.Text end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Wave%s+(%d+)/")) or 0
end

function aas_getDefenseLeaveAtWave(defKey)
    local opt = Options["DefLeaveWave_"..defKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

function aas_getDefenseEnemiesFolder(defKey)
    local arenas = workspace:FindFirstChild("DefenseArenas")
    if not arenas then return nil end
    local arena = aas_findArenaChild(arenas, defKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

function aas_joinOrCreateDefense(defKey)
    if aas_defenseArenaExists(defKey) then pcall(function() aas_defenseJoinRemote:Fire("Join", defKey) end)
    else pcall(function() aas_defenseJoinRemote:Fire("Create", defKey) end) end
end

function aas_leaveDefense() pcall(function() aas_defenseLeaveRemote:Fire() end) end

function aas_waitForDefenseArena(defKey, timeoutSecs)
    timeoutSecs = timeoutSecs or 10
    local deadline = tick() + timeoutSecs
    while tick() < deadline do if aas_defenseArenaExists(defKey) then return true end task.wait(0.5) end
    return false
end

function aas_defenseLoop(defKey)
    local defData = S.DefenseList[defKey]
    if not defData then return end
    aas_equipLoadout(S.DefenseLoadouts[defKey] or "Power")
    aas_enterPotionContext("Defense_"..defKey)
    aas_joinOrCreateDefense(defKey) aas_waitForDefenseArena(defKey, 10) task.wait(5)
    while S.defenseEnabled[defKey] do
        local leaveAt = aas_getDefenseLeaveAtWave(defKey)
        if leaveAt > 0 then
            local cw = aas_getCurrentDefenseWave()
            if cw > 0 and cw >= leaveAt then
                aas_leaveDefense() task.wait(6)
                if not S.defenseEnabled[defKey] then break end
                aas_joinOrCreateDefense(defKey) aas_waitForDefenseArena(defKey, 10) task.wait(5) continue
            end
        end
        if not aas_defenseArenaExists(defKey) then
            task.wait(6)
            if not S.defenseEnabled[defKey] then break end
            aas_joinOrCreateDefense(defKey) aas_waitForDefenseArena(defKey, 10) task.wait(5) continue
        end
        local mobs = aas_findMobsInFolder(aas_getDefenseEnemiesFolder(defKey), nil)
        if #mobs == 0 then task.wait(0.5) continue end
        for _, mob in ipairs(mobs) do
            if not S.defenseEnabled[defKey] then break end
            if not aas_defenseArenaExists(defKey) then break end
            if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
            aas_teleportToMob(mob) aas_waitForDead(mob, 15) task.wait(0.05)
        end
        task.wait(0.05)
    end
    if aas_defenseArenaExists(defKey) then aas_leaveDefense() end
    S.activeDefenseKey = nil
end

-- DUNGEON
function aas_getCurrentDungeonRoom()
    local ok, result = pcall(function() return LocalPlayer.PlayerGui.DungeonGui.Main.Room.Text end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Room%s+(%d+)")) or 0
end

function aas_getDungeonLeaveAtRoom(dungeonKey)
    local opt = Options["DungeonLeaveRoom_"..dungeonKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

function aas_getDungeonEnemiesFolder(dungeonKey)
    local arenas = workspace:FindFirstChild("DungeonArenas")
    if not arenas then return nil end
    local arena = aas_findArenaChild(arenas, dungeonKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies") or arena:FindFirstChild("EnemySpawns") or arena
end

function aas_joinDungeon(dungeonKey) pcall(function() aas_dungeonJoinRemote:Fire("Join", dungeonKey) end) end
function aas_leaveDungeon() pcall(function() aas_dungeonLeaveRemote:Fire() end) end

function aas_waitForDungeonArena(dungeonKey, timeoutSecs)
    timeoutSecs = timeoutSecs or 15
    local deadline = tick() + timeoutSecs
    while tick() < deadline do if aas_dungeonArenaExists(dungeonKey) then return true end task.wait(0.5) end
    return false
end

function aas_dungeonLoop(dungeonKey)
    local dungeonData = S.DungeonList[dungeonKey]
    if not dungeonData then return end

    while S.dungeonEnabled[dungeonKey] do
        if S.dungeonSuppressedByPriority then
            local stillSuppressed = false
            if aas_hasHigherPriority("Trial", "Dungeon") then
                for _, tk in ipairs(S.sortedTrialKeys) do
                    if S.trialEnabled[tk] and aas_trialArenaExists(tk) then stillSuppressed = true break end
                end
            end
            if not stillSuppressed and aas_hasHigherPriority("Gate", "Dungeon") then
                if S.gateEnabled and aas_gateArenaExists() then stillSuppressed = true end
            end
            if stillSuppressed then task.wait(1) continue
            else S.dungeonSuppressedByPriority = false end
        end

        if not aas_dungeonArenaExists(dungeonKey) then task.wait(1) continue end

        local conflictActivity = aas_monitorForConflicts("Dungeon", AAS_PRIORITY_WINDOW)
        if conflictActivity then
            S.dungeonSuppressedByPriority = true
            Library:Notify("Priority: " .. conflictActivity .. " - Dungeon suppressed.")
            task.wait(1) continue
        end

        local sessionSnapshot = aas_snapshotAndPauseActivities()
        aas_equipLoadout(S.DungeonLoadouts[dungeonKey] or "Power")
        aas_enterPotionContext("Dungeon_"..dungeonKey)
        aas_joinDungeon(dungeonKey)

        local arenaLoaded = aas_waitForDungeonArena(dungeonKey, 15)
        if not arenaLoaded then
            Library:Notify(dungeonData.Name .. " - Arena did not load. Skipping.")
            aas_resumeFromSnapshot(sessionSnapshot) task.wait(3) continue
        end

        task.wait(3) S.activeDungeonKey = dungeonKey
        local sessionActive, needsLeave = true, false

        while S.dungeonEnabled[dungeonKey] and sessionActive do
            if not aas_dungeonArenaExists(dungeonKey) then sessionActive = false needsLeave = false break end
            local leaveAt = aas_getDungeonLeaveAtRoom(dungeonKey)
            if leaveAt > 0 then
                local cr = aas_getCurrentDungeonRoom()
                if cr > 0 and cr >= leaveAt then needsLeave = true sessionActive = false break end
            end
            local mobs = aas_findMobsInFolder(aas_getDungeonEnemiesFolder(dungeonKey), nil)
            if #mobs == 0 then task.wait(0.2) continue end
            for _, mob in ipairs(mobs) do
                if not S.dungeonEnabled[dungeonKey] then sessionActive = false break end
                if not aas_dungeonArenaExists(dungeonKey) then sessionActive = false break end
                if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                aas_teleportToMob(mob) aas_waitForDead(mob, 15) task.wait(0.05)
            end
            task.wait(0.05)
        end

        if needsLeave and aas_dungeonArenaExists(dungeonKey) then aas_leaveDungeon() task.wait(5) end
        S.activeDungeonKey = nil
        S.dungeonSuppressedByPriority = false S.trialSuppressedByPriority = false S.gateSuppressedByPriority = false
        task.wait(0.5) aas_resumeFromSnapshot(sessionSnapshot) task.wait(3)
    end
    S.activeDungeonKey = nil S.dungeonSuppressedByPriority = false
end

-- BOSS RUSH
function aas_getCurrentRushWave()
    local ok, result = pcall(function() return LocalPlayer.PlayerGui.BossRushGui.Main.Wave.Text end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("%d+")) or 0
end

function aas_joinOrCreateRush(rushKey, modeId)
    local exists, _ = aas_rushArenaExists(rushKey)
    if exists then pcall(function() aas_bossRushJoinRemote:Fire("Join", rushKey, modeId, "") end)
    else pcall(function() aas_bossRushJoinRemote:Fire("Create", rushKey, modeId, true) end) end
end

function aas_leaveRush() pcall(function() aas_bossRushLeaveRemote:Fire() end) end

function aas_collectFingers(arena)
    if not arena then return false end
    local finger = arena:FindFirstChild("SukunaFinger")
    if not finger then return false end
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local target = nil
    if finger:IsA("BasePart") then target = finger
    elseif finger:IsA("Model") then target = finger.PrimaryPart or finger:FindFirstChildWhichIsA("BasePart", true)
    end
    if not target then for _, d in ipairs(finger:GetDescendants()) do if d:IsA("BasePart") then target = d break end end end
    if not target then return false end
    task.wait(0.5)
    if not finger or not finger.Parent then return false end
    hrp.CFrame = target.CFrame * CFrame.new(0, 3, 0) hrp.AssemblyLinearVelocity = Vector3.zero task.wait(0.25)
    local prompt = finger:FindFirstChild("FingerPrompt", true)
    if not (prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled) then return false end
    pcall(function() fireproximityprompt(prompt, 3) end)
    local deadline = tick() + 1.25
    while tick() < deadline do
        if not finger or not finger.Parent then task.wait(0.15) return true end
        task.wait(0.05)
    end
    return false
end

function aas_rushLoop(rushKey)
    local rushData = S.RushList[rushKey]
    if not rushData then return end
    local modeOpt = Options["RushMode_"..rushKey]
    local modeId = modeOpt and modeOpt.Value or "V1"
    aas_equipLoadout(S.RushLoadouts[rushKey] or "Power")
    aas_enterPotionContext("Rush_"..rushKey)
    aas_joinOrCreateRush(rushKey, modeId) task.wait(5)

    while S.rushEnabled[rushKey] do
        local exists, arena = aas_rushArenaExists(rushKey)
        if not exists then
            task.wait(6)
            if not S.rushEnabled[rushKey] then break end
            modeId = Options["RushMode_"..rushKey] and Options["RushMode_"..rushKey].Value or "V1"
            aas_joinOrCreateRush(rushKey, modeId) task.wait(5) continue
        end

        local leaveOpt = Options["RushLeaveWave_"..rushKey]
        local leaveAt = tonumber(leaveOpt and leaveOpt.Value) or 0
        if leaveAt > 0 then
            local cw = aas_getCurrentRushWave()
            if cw > 0 and cw >= leaveAt then aas_leaveRush() task.wait(6) continue end
        end

        if aas_collectFingers(arena) then continue end
        if not S.rushEnabled[rushKey] then break end

        local enemiesFolder = arena:FindFirstChild("Enemies")
        local mobs = aas_findMobsInFolder(enemiesFolder, nil)
        if #mobs == 0 then task.wait(0.5) continue end

        for _, mob in ipairs(mobs) do
            if not S.rushEnabled[rushKey] then break end
            if not aas_rushArenaExists(rushKey) then break end
            local waveNow = aas_getCurrentRushWave()
            if leaveAt > 0 and waveNow > 0 and waveNow >= leaveAt then break end
            if aas_collectFingers(arena) then break end
            if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
            aas_teleportToMob(mob) aas_waitForDead(mob, 15) task.wait(0.05)
        end
        task.wait(0.05)
    end
    if aas_rushArenaExists(rushKey) then aas_leaveRush() end
    S.activeRushKey = nil
end

-- SPAWN BOSS
function aas_spawnBossLoop(bossId)
    local bossData = S.SpawnBossList[bossId]
    if not bossData then return end

    while S.spawnBossEnabled[bossId] do
        local highPrio, highType = aas_isHighPrioritySpawnOrRunPresent()
        if highPrio then
            task.wait(1)
            continue
        end

        local currentWorld = aas_tryGetCurrentWorldId()
        if currentWorld ~= bossData.WorldId then
            aas_changeWorldAndWait(bossData.WorldId)
            task.wait(1)
        end

        local existingMob = aas_findSpawnBossMob(bossId)

        if not existingMob then
            pcall(function() aas_spawnBossRequestRemote:Fire(bossId) end)
            task.wait(2)

            existingMob = aas_waitForSpawnBossMob(bossId, 10)

            if not existingMob then
                task.wait(3)
                continue
            end
        end

        aas_teleportToMob(existingMob)

        local died = aas_waitForDead(existingMob, 120)

        if died then
            task.wait(0.5)
            pcall(function() aas_spawnBossRequestRemote:Fire(bossId) end)
            task.wait(2)
        else
            task.wait(1)
        end
    end
end

-- TIME TRIAL
function aas_getCurrentTrialRoom()
    local ok, result = pcall(function() return LocalPlayer.PlayerGui.TrialGui.Main.Room.Text end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Room%s+(%d+)/")) or 0
end

function aas_getTrialLeaveAtRoom(trialKey)
    local opt = Options["TrialLeaveRoom_"..trialKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v == "0 (Never Leave)" then return 0 end
    return tonumber(v:match("^(%d+)")) or 0
end

function aas_getTrialEnemiesFolder(trialKey)
    local arenas = workspace:FindFirstChild("TimeTrialArenas")
    if not arenas then return nil end
    local arena = aas_findArenaChild(arenas, trialKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

function aas_joinTrial(trialKey) pcall(function() aas_trialJoinRemote:Fire("Join", trialKey) end) end
function aas_leaveTrial() pcall(function() aas_trialLeaveRemote:Fire() end) end

function aas_trialLoop(trialKey)
    local trialData = S.TrialList[trialKey]
    if not trialData then return end

    while S.trialEnabled[trialKey] do
        if S.trialSuppressedByPriority then
            local stillSuppressed = false
            if aas_hasHigherPriority("Gate", "Trial") and S.gateEnabled and aas_gateArenaExists() then stillSuppressed = true end
            if not stillSuppressed and aas_hasHigherPriority("Dungeon", "Trial") then
                for _, dk in ipairs(S.sortedDungeonKeys) do
                    if S.dungeonEnabled[dk] and aas_dungeonArenaExists(dk) then stillSuppressed = true break end
                end
            end
            if stillSuppressed then task.wait(1) continue
            else S.trialSuppressedByPriority = false end
        end

        if not aas_trialArenaExists(trialKey) then task.wait(1) continue end

        local conflictActivity = aas_monitorForConflicts("Trial", AAS_PRIORITY_WINDOW)
        if conflictActivity then
            S.trialSuppressedByPriority = true
            Library:Notify("Priority: " .. conflictActivity .. " - Trial suppressed.")
            task.wait(0.05) continue
        end

        local sessionSnapshot = aas_snapshotAndPauseActivities()
        aas_equipLoadout(S.TrialLoadouts[trialKey] or "Power")
        aas_enterPotionContext("Trial_"..trialKey)
        aas_joinTrial(trialKey) task.wait(5)

        local sessionActive, needsLeave = true, false

        while S.trialEnabled[trialKey] and sessionActive do
            if not aas_trialArenaExists(trialKey) then sessionActive = false needsLeave = false break end
            local leaveAt = aas_getTrialLeaveAtRoom(trialKey)
            if leaveAt > 0 then
                local cr = aas_getCurrentTrialRoom()
                if cr > 0 and cr >= leaveAt then needsLeave = true sessionActive = false break end
            end
            local mobs = aas_findMobsInFolder(aas_getTrialEnemiesFolder(trialKey), nil)
            if #mobs == 0 then task.wait(0.1) continue end
            for _, mob in ipairs(mobs) do
                if not S.trialEnabled[trialKey] then sessionActive = false break end
                if not aas_trialArenaExists(trialKey) then sessionActive = false break end
                if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                aas_teleportToMob(mob) aas_waitForDead(mob, 15) task.wait(0.05)
            end
            task.wait(0.05)
        end

        if needsLeave and aas_trialArenaExists(trialKey) then aas_leaveTrial() task.wait(5) end
        S.trialSuppressedByPriority = false S.gateSuppressedByPriority = false S.dungeonSuppressedByPriority = false
        task.wait(0.5) aas_resumeFromSnapshot(sessionSnapshot) task.wait(1)
    end
    S.trialSuppressedByPriority = false
end

-- GATE
function aas_isWorld5SystemsLoaded()
    local ok, result = pcall(function() return workspace.Worlds["5"].Systems ~= nil and #workspace.Worlds["5"].Systems:GetChildren() > 0 end)
    return ok and result
end

function aas_getActiveGateRank()
    local ok2, rankText = pcall(function() return workspace.Worlds["5"].Systems.RaidStation.Gui.Main.Rank.Text end)
    if not ok2 or type(rankText) ~= "string" then return nil end
    return rankText:match("GATE RANK:%s*(%S+)")
end

function aas_getGateLeaveAtWave(rank)
    local opt = Options["GateLeaveWave_"..rank]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

function aas_isGateRankWanted(rank)
    local opt = Options["GateRankSelect"]
    if not opt then return false end
    for r, state in pairs(opt.Value or {}) do if state and r == rank then return true end end
    return false
end

function aas_getGateEnemiesFolder()
    local arenas = workspace:FindFirstChild("RaidArenas")
    if not arenas then return nil end
    local arena = aas_findArenaChild(arenas, "World5")
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

function aas_isActiveGatePresent()
    local ok, result = pcall(function() return workspace.Worlds["5"].Systems.RaidStation:FindFirstChild("ActiveGate") ~= nil end)
    return ok and result
end

function aas_enterGatePortal()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local portalPart = nil
    pcall(function()
        local station = workspace.Worlds["5"].Systems.RaidStation
        local tryNames = { "Portal", "PortalPart", "Gate", "GatePart", "Trigger", "TouchPart", "Enter" }
        for _, n in ipairs(tryNames) do
            local p = station:FindFirstChild(n, true)
            if p and p:IsA("BasePart") then portalPart = p break end
        end
        if not portalPart then
            for _, desc in ipairs(station:GetDescendants()) do
                if desc:IsA("BasePart") and desc.Name ~= "Hitbox" then portalPart = desc break end
            end
        end
    end)
    if portalPart then
        local portalPos = portalPart.Position
        local dirToPortal = Vector3.new((portalPos - hrp.Position).X, 0, (portalPos - hrp.Position).Z).Unit
        hrp.CFrame = CFrame.new(portalPos - dirToPortal * 4 + Vector3.new(0, 3, 0), portalPos)
        hrp.AssemblyLinearVelocity = Vector3.zero task.wait(0.3)
        for i = 1, 5 do hrp.CFrame = hrp.CFrame + dirToPortal * 1.2 hrp.AssemblyLinearVelocity = Vector3.zero task.wait(0.1) end
    else
        local ok, raidStation = pcall(function() return workspace.Worlds["5"].Systems.RaidStation end)
        if ok and raidStation then
            local stationPos = raidStation.CFrame.Position
            local forward = raidStation.CFrame.LookVector
            hrp.CFrame = CFrame.new(stationPos - forward * 4 + Vector3.new(0, 3, 0), stationPos)
            hrp.AssemblyLinearVelocity = Vector3.zero task.wait(0.3)
            for i = 1, 5 do hrp.CFrame = hrp.CFrame + forward * 1.2 hrp.AssemblyLinearVelocity = Vector3.zero task.wait(0.1) end
        end
    end
end

function aas_teleportToBaruke1()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local baruke = nil
    pcall(function()
        local arenas = workspace:FindFirstChild("RaidArenas")
        if not arenas then return end
        local arena = aas_findArenaChild(arenas, "World5")
        if not arena then return end
        local spawns = arena:FindFirstChild("EnemySpawns")
        if spawns then baruke = spawns:FindFirstChild("Baruke_1") end
    end)
    if baruke then
        local pos = baruke:IsA("BasePart") and baruke.Position
            or (baruke:IsA("Model") and (baruke.PrimaryPart or baruke:FindFirstChildOfClass("BasePart")) and (baruke.PrimaryPart or baruke:FindFirstChildOfClass("BasePart")).Position)
        if pos then hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) hrp.AssemblyLinearVelocity = Vector3.zero end
    end
end

function aas_gateLoop()
    while S.gateEnabled do
        if S.gateCooldown then task.wait(1) continue end
        if not aas_isWorld5SystemsLoaded() then task.wait(1) continue end

        if S.gateSuppressedByPriority then
            local stillSuppressed = false
            if aas_hasHigherPriority("Trial", "Gate") then
                for _, tk in ipairs(S.sortedTrialKeys) do
                    if S.trialEnabled[tk] and aas_trialArenaExists(tk) then stillSuppressed = true break end
                end
            end
            if not stillSuppressed and aas_hasHigherPriority("Dungeon", "Gate") then
                for _, dk in ipairs(S.sortedDungeonKeys) do
                    if S.dungeonEnabled[dk] and aas_dungeonArenaExists(dk) then stillSuppressed = true break end
                end
            end
            if stillSuppressed then task.wait(1) continue else S.gateSuppressedByPriority = false end
        end

        if not aas_isActiveGatePresent() then task.wait(0.5) continue end
        local rank = aas_getActiveGateRank()
        if not rank or not aas_isGateRankWanted(rank) then task.wait(1) continue end

        local conflictActivity = aas_monitorForConflicts("Gate", AAS_PRIORITY_WINDOW)
        if conflictActivity then
            S.gateSuppressedByPriority = true
            Library:Notify("Priority: " .. conflictActivity .. " - Gate suppressed.")
            task.wait(1) continue
        end

        local snapshot = aas_snapshotAndPauseActivities()
        local gateLoadout = Options["LoadoutGateRank_"..rank] and Options["LoadoutGateRank_"..rank].Value or "Power"
        aas_equipLoadout(gateLoadout)
        aas_enterPotionContext("Gate_"..rank)
        pcall(function() aas_requestChangeWorldRemote:Fire(5) end) task.wait(3)

        local arenaDeadline = tick() + 20
        while tick() < arenaDeadline do
            if aas_gateArenaExists() then break end
            aas_enterGatePortal() task.wait(1)
        end

        if not aas_gateArenaExists() then
            Library:Notify("Auto Gate - Arena did not load. Skipping.")
            aas_resumeFromSnapshot(snapshot) task.wait(2) continue
        end

        local sessionActive = true
        while S.gateEnabled and sessionActive do
            if not aas_gateArenaExists() then sessionActive = false break end
            local leaveAt = aas_getGateLeaveAtWave(rank)
            if leaveAt > 0 then
                local cw = aas_getCurrentRaidWave()
                if cw > 0 and cw >= leaveAt then aas_leaveRaid() task.wait(5) sessionActive = false break end
            end

            if S.gateOptimizedFarm then aas_teleportToBaruke1() task.wait(0.5)
            else
                local mobs = aas_findMobsInFolder(aas_getGateEnemiesFolder(), nil)
                if #mobs == 0 then task.wait(0.5) continue end
                for _, mob in ipairs(mobs) do
                    if not S.gateEnabled then sessionActive = false break end
                    if not aas_gateArenaExists() then sessionActive = false break end
                    if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                    aas_teleportToMob(mob) aas_waitForDead(mob, 15) task.wait(0.05)
                end
            end
            task.wait(0.05)
        end

        S.gateCooldown = true
        task.spawn(function() task.wait(60) S.gateCooldown = false end)
        S.gateSuppressedByPriority = false S.trialSuppressedByPriority = false S.dungeonSuppressedByPriority = false
        task.wait(0.5) aas_resumeFromSnapshot(snapshot) task.wait(3)
    end
    S.gateCooldown = false
end

-- ══════════════════════════════════════════
--   SYNC & DATA MANAGERS
-- ══════════════════════════════════════════

function aas_getRarityIndex(rarityOrder, rarity)
    for i, r in ipairs(rarityOrder) do if r == rarity then return i end end
    return 0
end

function aas_updateSword1Labels()
    if S.sword1InfoLabelRef then
        if S.sword1Data then
            local stars = string.rep("⭐", S.sword1Data.Level or 0)
            if stars == "" then stars = "0" end
            pcall(function() S.sword1InfoLabelRef:SetText("Sword 1: "..tostring(S.sword1Data.Rarity).." | Stars: "..stars) end)
        else pcall(function() S.sword1InfoLabelRef:SetText("Sword 1: Not Found") end) end
    end
    if S.sword1BreathingLabelRef then
        local breathingText = S.sword1CurrentBreathing
            and ("Breathing: "..tostring(S.sword1CurrentBreathing.Name or "Unknown").." ("..tostring(S.sword1CurrentBreathing.Rarity or "?")..")")
            or "Breathing: None"
        pcall(function() S.sword1BreathingLabelRef:SetText(breathingText) end)
    end
end

function aas_updateSword2Labels()
    if S.sword2InfoLabelRef then
        if S.sword2Data then
            local stars = string.rep("⭐", S.sword2Data.Level or 0)
            if stars == "" then stars = "0" end
            pcall(function() S.sword2InfoLabelRef:SetText("Sword 2: "..tostring(S.sword2Data.Rarity).." | Stars: "..stars) end)
        else pcall(function() S.sword2InfoLabelRef:SetText("Sword 2: Not Found") end) end
    end
    if S.sword2BreathingLabelRef then
        local breathingText = S.sword2CurrentBreathing
            and ("Breathing: "..tostring(S.sword2CurrentBreathing.Name or "Unknown").." ("..tostring(S.sword2CurrentBreathing.Rarity or "?")..")")
            or "Breathing: None"
        pcall(function() S.sword2BreathingLabelRef:SetText(breathingText) end)
    end
end

function aas_updateGrimoireLabels()
    if S.grimoire1LabelRef then pcall(function() S.grimoire1LabelRef:SetText("Slot 1: "..(S.activeGrimoireSlot1 or "None")) end) end
    if S.grimoire2LabelRef then pcall(function() S.grimoire2LabelRef:SetText("Slot 2: "..(S.activeGrimoireSlot2 or "None")) end) end
end

function aas_updateProgressionLabels()
    for _, progKey in ipairs(S.sortedProgressionKeys) do
        local labelRef = S.progressionLevelLabelRefs[progKey]
        if labelRef then
            local level = S.progressionLevels[progKey] or 0
            local maxLevel = S.ProgressionList[progKey] and S.ProgressionList[progKey].MaxLevel or "?"
            pcall(function() labelRef:SetText("Level: "..tostring(level).." / "..tostring(maxLevel)) end)
        end
    end
end

function aas_applyUpgrades2Payload(sysKey, payload)
    if type(payload) ~= "table" then return end
    if not S.upgrades2LiveData[sysKey] then S.upgrades2LiveData[sysKey] = {} end
    local upgradesList = payload.Upgrades
    if type(upgradesList) == "table" then
        for _, upg in ipairs(upgradesList) do
            if type(upg) == "table" and type(upg.Multiplier) == "string" then
                local key = upg.Multiplier
                if not S.upgrades2LiveData[sysKey][key] then S.upgrades2LiveData[sysKey][key] = {} end
                for k, v in pairs(upg) do S.upgrades2LiveData[sysKey][key][k] = v end
            end
        end
    end
end

task.spawn(function()
    pcall(function()
        aas_upgrades2DataRemote:Connect(function(payload)
            if type(payload) ~= "table" then return end
            local systems = payload.Systems
            if type(systems) == "table" then
                for sysKey, sysPayload in pairs(systems) do aas_applyUpgrades2Payload(sysKey, sysPayload) end
            end
        end)
    end)
    pcall(function()
        aas_upgrades2UpdatedRemote:Connect(function(payload)
            if type(payload) ~= "table" then return end
            local sysKey = payload.SystemKey
            if type(sysKey) == "string" then aas_applyUpgrades2Payload(sysKey, payload) end
        end)
    end)
    pcall(function()
        aas_upgrades2ResultRemote:Connect(function(success, errCode, payload)
            if type(payload) ~= "table" then return end
            local sysKey = payload.SystemKey
            if type(sysKey) == "string" then aas_applyUpgrades2Payload(sysKey, payload) end
        end)
    end)
end)

function aas_syncAllPlayerData()
    if not aas_getPlayerDataFunc then return end
    local ok, data = pcall(function() return aas_getPlayerDataFunc:InvokeServer() end)
    if not ok or type(data) ~= "table" then return end
    S.cachedPlayerData = data

    if type(data.ActivePotions) == "table" then S.activePotions = data.ActivePotions end

    local activeGachas = data.ActiveGachas
    if type(activeGachas) == "table" then
        for gachaKey, rarity in pairs(activeGachas) do
            S.activeGachaRarities[gachaKey] = tostring(rarity)
            local labelRef = S.gachaLabelRefs[gachaKey]
            if labelRef then pcall(function() labelRef:SetText("Current: "..tostring(rarity)) end) end
        end
    end

    local activePassive = data.ActivePassive
    if type(activePassive) == "table" and activePassive.Name and activePassive.Rarity then
        S.activePassiveData = activePassive
        if S.passiveLabelRef then pcall(function() S.passiveLabelRef:SetText("Active: "..tostring(activePassive.Name).." | "..tostring(activePassive.Rarity)) end) end
    else
        S.activePassiveData = nil
        if S.passiveLabelRef then pcall(function() S.passiveLabelRef:SetText("Active: None") end) end
    end

    local activeTitans = data.ActiveTitans
    if type(activeTitans) == "table" then
        local bestRarity, bestIdx = nil, 0
        for _, titanData in pairs(activeTitans) do
            if type(titanData) == "table" and titanData.Rarity then
                local idx = aas_getRarityIndex(S.TitanRarityOrder, titanData.Rarity)
                if idx > bestIdx then bestIdx = idx bestRarity = titanData.Rarity end
            end
        end
        S.activeTitanData = bestRarity and { rarity=bestRarity } or nil
        if S.titanLabelRef then
            pcall(function() S.titanLabelRef:SetText(S.activeTitanData and ("Active Titan: "..S.activeTitanData.rarity) or "Active Titan: None") end)
        end
    end

    local sword1Raw = data.EquippedSword
    S.sword1Data = type(sword1Raw) == "table" and { SwordKey=sword1Raw.SwordKey or "World0", Rarity=sword1Raw.Rarity or "Common", Level=sword1Raw.Level or 0, Index=sword1Raw.Index or 1 } or nil

    local sword2Raw = data.EquippedSword2
    S.sword2Data = type(sword2Raw) == "table" and { SwordKey=sword2Raw.SwordKey or "World0", Rarity=sword2Raw.Rarity or "Common", Level=sword2Raw.Level or 0, Index=sword2Raw.Index or 1 } or nil

    local swordPassives = data.SwordPassives
    if type(swordPassives) == "table" then
        if S.sword1Data then
            local key1 = string.format("World0_%s_%d_%d", S.sword1Data.Rarity, S.sword1Data.Level, S.sword1Data.Index)
            S.sword1CurrentBreathing = type(swordPassives[key1]) == "table" and swordPassives[key1] or nil
        end
        if S.sword2Data then
            local key2 = string.format("World0_%s_%d_%d", S.sword2Data.Rarity, S.sword2Data.Level, S.sword2Data.Index)
            S.sword2CurrentBreathing = type(swordPassives[key2]) == "table" and swordPassives[key2] or nil
        end
    end

    local activeGrimoires = data.ActiveGrimoires
    if type(activeGrimoires) == "table" then
        local world7 = activeGrimoires["World7"]
        if type(world7) == "table" then
            S.activeGrimoireSlot1 = type(world7.Slot1) == "string" and world7.Slot1 or nil
            S.activeGrimoireSlot2 = type(world7.Slot2) == "string" and world7.Slot2 or nil
        else S.activeGrimoireSlot1 = nil S.activeGrimoireSlot2 = nil end
    end

    local activeProgressions = data.ActiveProgressions
    if type(activeProgressions) == "table" then
        for progKey, level in pairs(activeProgressions) do S.progressionLevels[progKey] = tonumber(level) or 0 end
    end

    aas_updateSword1Labels() aas_updateSword2Labels() aas_updateGrimoireLabels() aas_updateProgressionLabels()
end

task.spawn(function()
    while true do task.wait(30) pcall(aas_syncAllPlayerData) end
end)

-- ══════════════════════════════════════════
--   GACHA & ROLLING SYSTEMS
-- ══════════════════════════════════════════

function aas_gachaLoop(gachaKey)
    local lastSync = 0
    while S.gachaEnabled[gachaKey] do
        if S.activeGachaRarities[gachaKey] == AAS_ASTRAL then
            S.gachaEnabled[gachaKey] = false
            if Toggles["AutoGacha_"..gachaKey] then Toggles["AutoGacha_"..gachaKey]:SetValue(false) end
            Library:Notify((S.GachaList[gachaKey] and S.GachaList[gachaKey].Name or gachaKey) .. " - Reached Astral!")
            break
        end
        pcall(function() aas_gachaRollRemote:Fire(gachaKey) end) task.wait(0.1)
        if tick() - lastSync >= 5 then
            lastSync = tick() pcall(aas_syncAllPlayerData)
            if S.activeGachaRarities[gachaKey] == AAS_ASTRAL then
                S.gachaEnabled[gachaKey] = false
                if Toggles["AutoGacha_"..gachaKey] then Toggles["AutoGacha_"..gachaKey]:SetValue(false) end
                Library:Notify((S.GachaList[gachaKey] and S.GachaList[gachaKey].Name or gachaKey) .. " - Reached Astral!")
                break
            end
        end
    end
end

function aas_swordWorld0Loop() while S.SwordWorld0Enabled do pcall(function() aas_swordRollRemote:Fire("World0") end) task.wait(0.1) end end
function aas_swordWorld8Loop() while S.SwordWorld8Enabled do pcall(function() aas_swordRollRemote:Fire("World8") end) task.wait(0.1) end end
function aas_fuseAllLoop() while S.autoFuseAllEnabled do if aas_bridgeDataRemote then pcall(function() aas_bridgeDataRemote:FireServer({ [2] = "Q" }) end) end task.wait(5) end end
function aas_passiveLoop() while S.passiveAutoEnabled do pcall(function() aas_passiveRollRemote:Fire() end) task.wait(0.1) end end
function aas_titanLoop() while S.titanAutoEnabled do pcall(function() aas_titanRollRemote:Fire("World4") end) task.wait(0.1) end end

-- SWORD PASSIVES
function aas_getSword1StopRarities()
    local opt = Options["SwordPassive1StopRarities"]
    if not opt then return {} end
    local selected = {}
    for rarity, state in pairs(opt.Value or {}) do if state then table.insert(selected, rarity) end end
    return selected
end

function aas_getSword2StopRarities()
    local opt = Options["SwordPassive2StopRarities"]
    if not opt then return {} end
    local selected = {}
    for rarity, state in pairs(opt.Value or {}) do if state then table.insert(selected, rarity) end end
    return selected
end

function aas_swordPassiveRarityReached(currentPassive, stopRarities)
    if not currentPassive or #stopRarities == 0 then return false end
    local currentRarity = currentPassive.Rarity or ""
    for _, r in ipairs(stopRarities) do if r == currentRarity then return true end end
    return false
end

function aas_swordPassive1Loop()
    while S.swordPassive1Enabled do
        local stopRarities = aas_getSword1StopRarities()
        if aas_swordPassiveRarityReached(S.sword1CurrentBreathing, stopRarities) then
            S.swordPassive1Enabled = false
            if Toggles["AutoSwordPassive1Enabled"] then Toggles["AutoSwordPassive1Enabled"]:SetValue(false) end
            Library:Notify("Sword Passive 1 Stopped - Reached: "..(S.sword1CurrentBreathing and S.sword1CurrentBreathing.Name or "Unknown"))
            break
        end
        if not S.sword1Data then task.wait(1) continue end
        pcall(function() aas_swordPassiveRollRemote:Fire({ SwordKey=S.sword1Data.SwordKey or "World0", Rarity=S.sword1Data.Rarity, Level=S.sword1Data.Level or 0, Index=S.sword1Data.Index or 1, SystemKey="World6" }) end)
        task.wait(0.1)
    end
end

function aas_swordPassive2Loop()
    while S.swordPassive2Enabled do
        local stopRarities = aas_getSword2StopRarities()
        if aas_swordPassiveRarityReached(S.sword2CurrentBreathing, stopRarities) then
            S.swordPassive2Enabled = false
            if Toggles["AutoSwordPassive2Enabled"] then Toggles["AutoSwordPassive2Enabled"]:SetValue(false) end
            Library:Notify("Sword Passive 2 Stopped - Reached: "..(S.sword2CurrentBreathing and S.sword2CurrentBreathing.Name or "Unknown"))
            break
        end
        if not S.sword2Data then task.wait(1) continue end
        pcall(function() aas_swordPassiveRollRemote:Fire({ SwordKey=S.sword2Data.SwordKey or "World0", Rarity=S.sword2Data.Rarity, Level=S.sword2Data.Level or 0, Index=S.sword2Data.Index or 1, SystemKey="World6" }) end)
        task.wait(0.1)
    end
end

-- GRIMOIRES
function aas_grimoire1Loop()
    while S.grimoire1Enabled do
        if S.activeGrimoireSlot1 == AAS_DIVINE then
            S.grimoire1Enabled = false
            if Toggles["AutoGrimoire1Enabled"] then Toggles["AutoGrimoire1Enabled"]:SetValue(false) end
            Library:Notify("Auto Grimoire Slot 1 Stopped - Reached Divine!") break
        end
        pcall(function() aas_grimoireRollRemote:Fire("World7", "Slot1") end) task.wait(0.1)
    end
end

function aas_grimoire2Loop()
    while S.grimoire2Enabled do
        if S.activeGrimoireSlot2 == AAS_DIVINE then
            S.grimoire2Enabled = false
            if Toggles["AutoGrimoire2Enabled"] then Toggles["AutoGrimoire2Enabled"]:SetValue(false) end
            Library:Notify("Auto Grimoire Slot 2 Stopped - Reached Divine!") break
        end
        pcall(function() aas_grimoireRollRemote:Fire("World7", "Slot2") end) task.wait(0.1)
    end
end

-- PET PASSIVES
function aas_getPetPassiveStopRarities()
    local opt = Options["PetPassiveStopRarities"]
    if not opt then return {} end
    local selected = {}
    for rarity, state in pairs(opt.Value or {}) do if state then table.insert(selected, rarity) end end
    return selected
end

function aas_getPetPassiveCurrentRarity()
    if not S.petPassiveCurrentData then return nil end
    return S.petPassiveCurrentData.Rarity
end

function aas_petPassiveRarityReached(stopRarities)
    local currentRarity = aas_getPetPassiveCurrentRarity()
    if not currentRarity or #stopRarities == 0 then return false end
    for _, r in ipairs(stopRarities) do if r == currentRarity then return true end end
    return false
end

function aas_syncPetPassiveData()
    if not aas_getPlayerDataFunc then return end
    local ok, data = pcall(function() return aas_getPlayerDataFunc:InvokeServer() end)
    if not ok or type(data) ~= "table" then return end
    local petPassives = data.PetPassives
    local selectedId = S.petPassiveSelectedPetId
    if type(petPassives) == "table" and selectedId then
        local passiveId = petPassives[selectedId]
        if type(passiveId) == "string" and passiveId ~= "" then
            local passiveConfig = nil
            pcall(function()
                local cfg = GameLibrary.getConfig("PetPassiveConfig")
                if cfg and cfg.GetPassiveById then passiveConfig = cfg:GetPassiveById(passiveId) end
            end)
            if passiveConfig then S.petPassiveCurrentData = { Id=passiveConfig.Id, Name=passiveConfig.Name or passiveId, Rarity=passiveConfig.Rarity or "Unknown" }
            else S.petPassiveCurrentData = { Id=passiveId, Name=passiveId, Rarity="Unknown" } end
        else S.petPassiveCurrentData = nil end
    end
    if S.petPassiveLabelRef then
        if S.petPassiveCurrentData then
            pcall(function() S.petPassiveLabelRef:SetText("Current: "..tostring(S.petPassiveCurrentData.Name).." ("..tostring(S.petPassiveCurrentData.Rarity)..")") end)
        else pcall(function() S.petPassiveLabelRef:SetText("Current: None") end) end
    end
end

function aas_scanEquippedPets()
    local equipped, equippedIds, petPassives = {}, {}, {}
    pcall(function()
        local data = aas_getPlayerDataFunc:InvokeServer()
        if data and data.EquippedPets then
            for uuid, isEquipped in pairs(data.EquippedPets) do if isEquipped == true then equippedIds[uuid] = true end end
        end
        if data and data.PetPassives then
            for uuid, passiveData in pairs(data.PetPassives) do
                if type(passiveData) == "table" then petPassives[uuid] = { Name=passiveData.Name or passiveData.Id or "Unknown", Rarity=passiveData.Rarity or "Unknown" } end
            end
        end
    end)
    local petNames = {}
    pcall(function()
        local scrollFrame = LocalPlayer.PlayerGui.Windows.Pets.Main.Pets.ScrollingFrame
        for _, child in ipairs(scrollFrame:GetChildren()) do
            if not child:IsA("GuiObject") then continue end
            local uuid = child.Name
            if not uuid:match("^%x+%-%x+%-%x+%-%x+%-%x+$") then continue end
            local main = child:FindFirstChild("Main")
            if main then
                local nameLabel = main:FindFirstChild("Name")
                if nameLabel and nameLabel:IsA("TextLabel") and nameLabel.Text ~= "" then petNames[uuid] = nameLabel.Text end
            end
        end
    end)
    for uuid in pairs(equippedIds) do
        local name = petNames[uuid] or ("Pet "..uuid:sub(1, 8))
        local passive = petPassives[uuid]
        equipped[uuid] = { Name=name, Passive=passive }
    end
    return equipped
end

function aas_petPassiveLoop()
    while S.petPassiveAutoEnabled do
        local selectedId = S.petPassiveSelectedPetId
        if not selectedId or selectedId == "" then task.wait(1) continue end
        pcall(aas_syncPetPassiveData)
        local stopRarities = aas_getPetPassiveStopRarities()
        if aas_petPassiveRarityReached(stopRarities) then
            S.petPassiveAutoEnabled = false
            if Toggles["AutoPetPassiveEnabled"] then Toggles["AutoPetPassiveEnabled"]:SetValue(false) end
            Library:Notify("Pet Passive Stopped - Reached: "..tostring(S.petPassiveCurrentData and S.petPassiveCurrentData.Name or "Unknown"))
            break
        end
        pcall(function() aas_petPassiveRollRemote:Fire({ SystemKey="World9", PetUniqueId=selectedId }) end)
        task.wait(1.1)
        if aas_petPassiveRarityReached(aas_getPetPassiveStopRarities()) then
            S.petPassiveAutoEnabled = false
            if Toggles["AutoPetPassiveEnabled"] then Toggles["AutoPetPassiveEnabled"]:SetValue(false) end
            Library:Notify("Pet Passive Stopped - Reached: "..tostring(S.petPassiveCurrentData and S.petPassiveCurrentData.Name or "Unknown"))
            break
        end
    end
end

-- ══════════════════════════════════════════
--   PROGRESSION, UPGRADES & EVOLUTION
-- ══════════════════════════════════════════

function aas_progressionLoop(progKey)
    local progData = S.ProgressionList[progKey]
    if not progData then return end
    while S.progressionEnabled[progKey] do
        local currentLevel = S.progressionLevels[progKey] or 0
        if currentLevel >= (progData.MaxLevel or 45) then
            S.progressionEnabled[progKey] = false
            if Toggles["AutoProgression_"..progKey] then Toggles["AutoProgression_"..progKey]:SetValue(false) end
            Library:Notify(progData.Name.." Stopped - Reached max level "..tostring(progData.MaxLevel).."!")
            break
        end
        pcall(function() aas_progressionUpgradeRemote:Fire(progKey) end) task.wait(0.1)
    end
end

function aas_rangeUpgradeLoop(sysKey)
    while S.rangeUpgradeEnabled[sysKey] do pcall(function() aas_rangeUpgradeRemote:Fire(sysKey) end) task.wait(1.0) end
end

function aas_upgrades2LoopV2(sysKey)
    pcall(function() aas_upgrades2DataRemote:Fire() end) task.wait(1)
    while S.upgrades2Enabled2[sysKey] do
        local selectedStats = S.upgrades2SelectedStats[sysKey] or {}
        local anySelected = false
        for _ in pairs(selectedStats) do anySelected = true break end
        if not anySelected then task.wait(1) continue end

        local liveData = S.upgrades2LiveData[sysKey] or {}
        local anyUpgraded = false
        local cfg = GameLibrary.getConfig("Upgrades2Config")
        local sysData = cfg and cfg:GetSystem(sysKey)
        local upgradeList = sysData and sysData.UpgradeList or {}

        for _, upgradeInfo in ipairs(upgradeList) do
            local statKey = upgradeInfo.Key
            if not selectedStats[statKey] then continue end
            local live = liveData[statKey]
            local currentLevel = (live and live.Level) or 0
            local maxLevel = upgradeInfo.MaxLevel or math.huge
            if currentLevel >= maxLevel then
                S.upgrades2SelectedStats[sysKey][statKey] = nil
                Library:Notify("Professions: "..(upgradeInfo.DisplayName or statKey).." - Reached MAX! Deselected.")
                continue
            end
            if live and live.CanUpgrade == true then
                pcall(function() aas_upgrades2RequestRemote:Fire(sysKey, statKey) end)
                anyUpgraded = true task.wait(1.5)
                pcall(function() aas_upgrades2DataRemote:Fire() end) task.wait(0.5)
            end
        end

        if not anyUpgraded then task.wait(3) else task.wait(0.5) end
    end
end

function aas_autoEvolutionLoop()
    pcall(aas_syncAllPlayerData)
    while S.autoEvolutionEnabled do
        local allMaxed = true
        for _, evKey in ipairs(S.sortedEvolutionKeys) do
            if not S.autoEvolutionEnabled then break end
            local currentLevel = 0
            pcall(function()
                local evolutions = S.cachedPlayerData and S.cachedPlayerData.Evolutions
                if type(evolutions) == "table" then currentLevel = tonumber(evolutions[evKey]) or 0 end
            end)
            local evData = S.EvolutionList[evKey]
            if not evData then continue end
            if currentLevel < evData.MaxLevel then
                allMaxed = false
                pcall(function() aas_evolutionRequestRemote:Fire(evKey) end)
                task.wait(5.5) pcall(aas_syncAllPlayerData)
            end
        end
        if allMaxed then
            S.autoEvolutionEnabled = false
            if Toggles["AutoEvolutionEnabled"] then Toggles["AutoEvolutionEnabled"]:SetValue(false) end
            Library:Notify("Auto Evolution - All evolutions are at MAX level!")
            break
        end
        task.wait(1)
    end
end

-- ══════════════════════════════════════════
--   SKILL TREE & CONSTELLATIONS
-- ══════════════════════════════════════════

function aas_skillTreeLoop(treeName)
    local treeData = S.SkillTreeList[treeName]
    if not treeData then return end
    while S.skillTreeEnabled[treeName] do
        pcall(aas_syncAllPlayerData)
        local purchased = {}
        pcall(function()
            if S.cachedPlayerData and S.cachedPlayerData.SkillTree then
                local treeProgress = S.cachedPlayerData.SkillTree[treeName]
                if type(treeProgress) == "table" then purchased = treeProgress end
            end
        end)
        local allDone = true
        for _, upgradeName in ipairs(treeData.UpgradeOrder) do
            if not S.skillTreeEnabled[treeName] then break end
            if not purchased[upgradeName] then
                allDone = false
                pcall(function() aas_skillTreeUpgradeRemote:InvokeServer(treeName, upgradeName) end)
                task.wait(0.5) pcall(aas_syncAllPlayerData)
            end
        end
        if allDone then
            S.skillTreeEnabled[treeName] = false
            if Toggles["AutoSkillTree_"..treeName] then Toggles["AutoSkillTree_"..treeName]:SetValue(false) end
            Library:Notify("Skill Tree: "..treeName.." - All upgrades purchased!")
            break
        end
        task.wait(1)
    end
end

function aas_constellationLoop(constId)
    local constData = S.ConstellationList[constId]
    if not constData then return end
    while S.constellationEnabled[constId] do
        pcall(aas_syncAllPlayerData)
        local purchased = {}
        pcall(function()
            if S.cachedPlayerData and S.cachedPlayerData.SinsRaid then
                local constellations = S.cachedPlayerData.SinsRaid.Constellations
                if type(constellations) == "table" then
                    local constProgress = constellations[constId]
                    if type(constProgress) == "table" then purchased = constProgress end
                end
            end
        end)
        local allDone = true
        for _, nodeName in ipairs(constData.NodeOrder) do
            if not S.constellationEnabled[constId] then break end
            if purchased[nodeName] ~= true then
                allDone = false
                pcall(function() aas_constellationUpgradeRemote:InvokeServer(constId, nodeName) end)
                task.wait(0.5) pcall(aas_syncAllPlayerData)
            end
        end
        if allDone then
            S.constellationEnabled[constId] = false
            if Toggles["AutoConstellation_"..constId] then Toggles["AutoConstellation_"..constId]:SetValue(false) end
            Library:Notify("Constellation: "..constData.Name.." - All nodes purchased!")
            break
        end
        task.wait(1)
    end
end

-- ══════════════════════════════════════════
--   STAR, CRAFTS & RELICS
-- ══════════════════════════════════════════

function aas_getPetAutoActionsForEgg(eggKey)
    local out = {}
    if not eggKey or eggKey == "" then return out end

    local data = S.cachedPlayerData
    if type(data) ~= "table" then
        local ok, fetched = pcall(function() return aas_getPlayerDataFunc:InvokeServer() end)
        if ok and type(fetched) == "table" then
            S.cachedPlayerData = fetched
            data = fetched
        end
    end

    local petAutoActions = data and data.PetAutoActions
    if type(petAutoActions) ~= "table" then return out end

    local eggActions = petAutoActions[eggKey]
    if type(eggActions) ~= "table" then return out end

    local validActions = { delete = true, lock = true, deleteShiny = true, lockShiny = true }
    for rarity, action in pairs(eggActions) do
        if type(rarity) == "string" and type(action) == "string" and validActions[action] then
            out[rarity] = action
        end
    end
    return out
end

function aas_starLoop()
    local lastSync = 0
    while S.starEnabled do
        local eggKey = S.starEggKey
        if not eggKey then task.wait(0.5) continue end
        if tick() - lastSync >= 5 then
            lastSync = tick()
            pcall(aas_syncAllPlayerData)
        end
        local actions = aas_getPetAutoActionsForEgg(eggKey)
        pcall(function() aas_openEggRemote:Fire(eggKey, actions) end)
        task.wait(0.1)
    end
end

function aas_craftLoop(craftKey)
    local craftData = S.CraftList[craftKey]
    if not craftData then return end
    while S.craftEnabled[craftKey] do
        local isShiny = S.craftShiny[craftKey] == true
        pcall(function() aas_craftPetRemote:Fire(craftKey, isShiny) end) task.wait(1.1)
    end
end

function aas_getRelicState(relicName)
    if not S.cachedPlayerData then return nil end
    local relics = S.cachedPlayerData.Relics
    if type(relics) ~= "table" then return nil end
    local state = relics[relicName]
    if type(state) ~= "table" then return nil end
    return state
end

local AAS_GQ_RELIC_MAP = {
    ["Ninja Relic"]   = { WorldId=1, Stat="Yen"    },
    ["Dragon Relic"]  = { WorldId=2, Stat="Power"  },
    ["Fruits Relic"]  = { WorldId=3, Stat="Luck"   },
    ["Titan Relic"]   = { WorldId=4, Stat="Damage" },
    ["Shadows Relic"] = { WorldId=5, Stat="Drop"   },
    ["Slayer Relic"]  = { WorldId=6, Stat="XP"     },
}

function aas_autoRelicUpgradeLoop()
    while S.autoRelicUpgradeEnabled do
        pcall(aas_syncAllPlayerData)
        local allMaxed = true
        for relicName, _ in pairs(AAS_GQ_RELIC_MAP) do
            if not S.autoRelicUpgradeEnabled then break end
            local relicState = aas_getRelicState(relicName)
            if relicState then
                local level = tonumber(relicState.Level) or 0
                local ascension = tonumber(relicState.Ascension) or 0
                local isMaxed = false
                pcall(function() isMaxed = aas_RelicConfig:IsMaxed(level, ascension) end)
                if not isMaxed then
                    allMaxed = false
                    local canAscend = false
                    pcall(function() canAscend = aas_RelicConfig:CanAscend(level, ascension) end)
                    if not canAscend then pcall(function() aas_relicUpgradeRemote:Fire(relicName) end) task.wait(0.3) end
                end
            end
        end
        if allMaxed then
            S.autoRelicUpgradeEnabled = false
            if Toggles["AutoRelicUpgradeEnabled"] then Toggles["AutoRelicUpgradeEnabled"]:SetValue(false) end
            Library:Notify("Auto Relic Upgrade - All relics maxed!")
            break
        end
        task.wait(0.5)
    end
end

function aas_autoRelicAscendLoop()
    while S.autoRelicAscendEnabled do
        pcall(aas_syncAllPlayerData)
        for relicName, _ in pairs(AAS_GQ_RELIC_MAP) do
            if not S.autoRelicAscendEnabled then break end
            local relicState = aas_getRelicState(relicName)
            if relicState then
                local level = tonumber(relicState.Level) or 0
                local ascension = tonumber(relicState.Ascension) or 0
                local canAscend = false
                pcall(function() canAscend = aas_RelicConfig:CanAscend(level, ascension) end)
                if canAscend then pcall(function() aas_relicAscendRemote:Fire(relicName) end) task.wait(1) end
            end
        end
        task.wait(2)
    end
end

-- ══════════════════════════════════════════
--   GLOBAL QUEST SYSTEM
-- ══════════════════════════════════════════

local AAS_GQ_DEFEAT_MAP = {
    Itachi      = { ModelName="Itachi",      EnemyName="Itache",        WorldId=1  },
    Broly       = { ModelName="Broly",       EnemyName="Broly",         WorldId=2  },
    BarbaBranca = { ModelName="BarbaBranca", EnemyName="White Beard",   WorldId=3  },
    ArmoredTitan= { ModelName="ArmoredTitan",EnemyName="Armored Titan", WorldId=4  },
    Beleon      = { ModelName="Beleon",      EnemyName="Beleon",        WorldId=5  },
    Kokeshebo   = { ModelName="Kokeshebo",   EnemyName="Kokeshebo",     WorldId=6  },
    Lucies      = { ModelName="Lucies",      EnemyName="Lucies",        WorldId=7  },
    Quinella    = { ModelName="Quinella",    EnemyName="Quinella",      WorldId=8  },
    Sho         = { ModelName="Sho",         EnemyName="Sho",           WorldId=9  },
    Aiz         = { ModelName="Aiz",         EnemyName="Aiz",           WorldId=10 },
}

local AAS_GQ_GAMEMODE_MAP = {
    TimelessRaid    = { Type="Raid",    Key="World0",        WorldId=0  },
    NinjaRaid       = { Type="Raid",    Key="World1",        WorldId=1  },
    TitanDefense    = { Type="Defense", Key="World4",        WorldId=4  },
    TrialEasy       = { Type="Trial",   Key="Easy",          WorldId=1  },
    TrialMedium     = { Type="Trial",   Key="Medium",        WorldId=1  },
    GateRaid        = { Type="Gate",    Key="World5",        WorldId=5  },
    InfinityCastle  = { Type="Raid",    Key="World6",        WorldId=6  },
    CloverRaid      = { Type="Raid",    Key="World7",        WorldId=7  },
    BeachDefense    = { Type="Defense", Key="World8",        WorldId=8  },
    FireCityDungeon = { Type="Dungeon", Key="World9Dungeon", WorldId=9  },
    SoulRaid        = { Type="Raid",    Key="World10",       WorldId=10 },
}

local AAS_GQ_ACCESSORY_MAP = {
    AkatsukiHat = { Mob="Itachi",      WorldId=1  },
    Gogeta      = { Mob="Broly",       WorldId=2  },
    Enel        = { Mob="BarbaBranca", WorldId=3  },
    Levi        = { Mob="ArmoredTitan",WorldId=4  },
    Iron        = { Mob="Beleon",      WorldId=5  },
    KingCape    = { Mob="Lucies",      WorldId=7  },
    Floatie     = { Mob="Quinella",    WorldId=8  },
    FireJacket  = { Mob="Aiz",         WorldId=10 },
}

local AAS_GQ_GACHA_MAP = {
    World1="World1", World2="World2", World2DivineTechniques="World2DivineTechniques",
    World3="World3", World3DemonFruits="World3DemonFruits", World4="World4",
    World5="World5", World6="World6", World7="World7", World8="World8",
    World9="World9", World10="World10",
}

function aas_gqGetDef(index)
    local allQuests = aas_GlobalQuestConfig:GetAll()
    return allQuests and allQuests[index] or nil
end

function aas_gqReadQuest(index)
    local result = { Index=index, Current=0, Required=0, Complete=false, Claimed=false, Objective="" }
    pcall(function()
        local windows = LocalPlayer.PlayerGui:FindFirstChild("Windows")
        if not windows then return end
        local gqWindow = windows:FindFirstChild("GlobalQuest")
        if not gqWindow then return end
        local main = gqWindow:FindFirstChild("Main")
        if not main then return end
        local scroll = main:FindFirstChild("Scroll")
        if not scroll then return end
        local card = scroll:FindFirstChild("GlobalQuest_" .. tostring(index))
        if not card then return end

        local qty = card:FindFirstChild("Quantity") or card:FindFirstChild("Quantity", true)
        if qty and (qty:IsA("TextLabel") or qty:IsA("TextButton")) then
            local cur, req = qty.Text:match("(%d+)/(%d+)")
            result.Current = tonumber(cur) or 0
            result.Required = tonumber(req) or 0
        end

        local obj = card:FindFirstChild("Objective") or card:FindFirstChild("Objective", true)
        if obj then result.Objective = obj.Text or "" end

        local claimBtn = card:FindFirstChild("Claim") or card:FindFirstChild("Claim", true)
        if claimBtn and claimBtn:IsA("GuiButton") and claimBtn.Visible then
            result.Complete = true
        end

        local completedBtn = card:FindFirstChild("Completed") or card:FindFirstChild("Completed", true)
        if completedBtn and completedBtn:IsA("GuiObject") and completedBtn.Visible then
            result.Claimed = true
            result.Complete = true
        end

        if result.Required > 0 and result.Current >= result.Required then
            result.Complete = true
        end
    end)
    return result
end

function aas_gqBuildDisplay(i)
    local def = aas_gqGetDef(i)
    if not def then return "#"..i.." — Unknown" end
    local t = def.Type or "?"
    local reward = ""
    pcall(function() reward = aas_GlobalQuestConfig:FormatReward(def.Reward) or "" end)
    local desc = ""
    if t == "Defeat" then
        local mobInfo = AAS_GQ_DEFEAT_MAP[def.Mob]
        desc = "Kill "..(mobInfo and mobInfo.EnemyName or def.Mob or "?").." x"..tostring(def.Kills or 0)
    elseif t == "GamemodeJoin" then desc = "Join "..tostring(def.Gamemode).." x"..tostring(def.Joins or 0)
    elseif t == "GamemodeComplete" then desc = "Complete "..tostring(def.Gamemode).." x"..tostring(def.Amount or 0)
    elseif t == "GamemodeWaves" then desc = tostring(def.Waves or 0).." waves in "..tostring(def.Gamemode)
    elseif t == "GachaRoll" then desc = "Roll "..tostring(def.Result or "?").." in "..tostring(def.Gacha or "?")
    elseif t == "PlayerRank" then desc = "Reach Rank "..tostring(def.Rank or 0)
    elseif t == "RelicLevel" then desc = tostring(def.Relic or "?").." Lv."..tostring(def.Level or 0)
    elseif t == "RelicAscension" then desc = tostring(def.Relic or "?").." Ascension "..tostring(def.Ascension or 0)
    elseif t == "AccessoryObtain" then desc = "Obtain "..tostring(def.Accessory or "?")
    else desc = tostring(t) end
    return "#"..i.." "..desc.." ["..reward.."]"
end

function aas_gqIsFarmable(index)
    local ok, def = pcall(aas_gqGetDef, index)
    if not ok or not def then return false end
    local t = def.Type
    if not t then return false end
    if t == "Defeat" and def.Mob and AAS_GQ_DEFEAT_MAP[def.Mob] then return true end
    if t == "AccessoryObtain" and def.Accessory and AAS_GQ_ACCESSORY_MAP[def.Accessory] then return true end
    if t == "RelicLevel" and def.Relic and AAS_GQ_RELIC_MAP[def.Relic] then return true end
    if t == "RelicAscension" and def.Relic and AAS_GQ_RELIC_MAP[def.Relic] then return true end
    if (t == "GamemodeJoin" or t == "GamemodeComplete" or t == "GamemodeWaves") and def.Gamemode and AAS_GQ_GAMEMODE_MAP[def.Gamemode] then return true end
    if t == "GachaRoll" and def.Gacha and AAS_GQ_GACHA_MAP[def.Gacha] then return true end
    if t == "PlayerRank" then return true end
    return false
end

function aas_globalQuestLoop()
    while S.globalQuestEnabled do
        local highPrio, highType = aas_isHighPrioritySpawnOrRunPresent()
        if highPrio then
            if not S.globalQuestSuppressedByPriority then
                S.globalQuestSuppressedByPriority = true
                Library:Notify("GQ Paused - "..tostring(highType).." has higher priority.")
            end
            task.wait(1) continue
        else
            if S.globalQuestSuppressedByPriority then
                S.globalQuestSuppressedByPriority = false
                Library:Notify("GQ Resumed")
            end
        end

        local selectedIndices = {}
        local selectOpt = Options["GQSelectQuests"]
        if selectOpt and type(selectOpt.Value) == "table" then
            for display, state in pairs(selectOpt.Value) do
                if state then
                    local idx = tonumber(display:match("^#(%d+)"))
                    if idx then table.insert(selectedIndices, idx) end
                end
            end
        end

        if #selectedIndices == 0 then task.wait(2) continue end
        table.sort(selectedIndices)

        local hasMobQuests, hasGamemodeQuests, hasGachaQuests, hasRankQuests = false, false, false, false
        for _, idx in ipairs(selectedIndices) do
            local def = aas_gqGetDef(idx)
            if not def then continue end
            if def.Type == "Defeat" or def.Type == "AccessoryObtain" or def.Type == "RelicLevel" or def.Type == "RelicAscension" then hasMobQuests = true
            elseif def.Type == "GamemodeJoin" or def.Type == "GamemodeComplete" or def.Type == "GamemodeWaves" then hasGamemodeQuests = true
            elseif def.Type == "GachaRoll" then hasGachaQuests = true
            elseif def.Type == "PlayerRank" then hasRankQuests = true end
        end

        if hasRankQuests then pcall(function() aas_toggleAutoRank(true) end) end

        if hasMobQuests then
            aas_equipLoadout(S.LoadoutAssignments.Farm or "Power")
            aas_enterPotionContext("Farm")
            local farmDone = false
            while S.globalQuestEnabled and not farmDone and not S.globalQuestSuppressedByPriority do
                local allMobsDone = true
                for _, idx in ipairs(selectedIndices) do
                    local def = aas_gqGetDef(idx)
                    if not def then continue end
                    local mobInfo = nil
                    if def.Type == "Defeat" then mobInfo = AAS_GQ_DEFEAT_MAP[def.Mob]
                    elseif def.Type == "AccessoryObtain" then
                        local accInfo = AAS_GQ_ACCESSORY_MAP[def.Accessory]
                        if accInfo then mobInfo = AAS_GQ_DEFEAT_MAP[accInfo.Mob] end
                    elseif def.Type == "RelicLevel" or def.Type == "RelicAscension" then
                        local relicInfo = AAS_GQ_RELIC_MAP[def.Relic]
                        if relicInfo then
                            for _, mi in pairs(AAS_GQ_DEFEAT_MAP) do
                                if mi.WorldId == relicInfo.WorldId then mobInfo = mi break end
                            end
                        end
                    end
                    if mobInfo then
                        allMobsDone = false
                        if S.currentWorldTracked ~= mobInfo.WorldId then aas_teleportToWorld(mobInfo.WorldId) S.currentWorldTracked = mobInfo.WorldId end
                        local mobs = aas_findMobsInWorld(mobInfo.WorldId, { mobInfo.EnemyName })
                        for _, mob in ipairs(mobs) do
                            if not S.globalQuestEnabled or S.globalQuestSuppressedByPriority then break end
                            if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                            aas_teleportToMob(mob) aas_waitForDead(mob, 25) task.wait(0.05)
                        end
                    end
                end
                if allMobsDone then farmDone = true end
                task.wait(0.5)
            end
        end

        if not S.globalQuestEnabled then break end

        if hasGachaQuests then
            while S.globalQuestEnabled and not S.globalQuestSuppressedByPriority do
                local anyRemaining = false
                for _, idx in ipairs(selectedIndices) do
                    local def = aas_gqGetDef(idx)
                    if not def or def.Type ~= "GachaRoll" then continue end
                    local gachaKey = AAS_GQ_GACHA_MAP[def.Gacha]
                    if gachaKey then anyRemaining = true pcall(function() aas_gachaRollRemote:Fire(gachaKey) end) task.wait(0.1) end
                end
                if not anyRemaining then break end
                task.wait(0.05)
            end
        end

        if not S.globalQuestEnabled then break end

        for _, idx in ipairs(selectedIndices) do
            pcall(function() aas_globalQuestClaimRemote:Fire(idx) end) task.wait(0.5)
        end

        task.wait(2)
    end
    S.globalQuestCurrentTarget = nil S.globalQuestCurrentAction = nil S.globalQuestSuppressedByPriority = false
end

-- ══════════════════════════════════════════
--   PROMOTION SYSTEM
-- ══════════════════════════════════════════

local AAS_PROMO_RELIC_ALIASES = { SlayerRelic="Slayer Relic", DragonRelic="Dragon Relic", NinjaRelic="Ninja Relic", TitanRelic="Titan Relic", FruitsRelic="Fruits Relic", ShadowsRelic="Shadows Relic" }
local AAS_PROMO_MOB_MAP = {
    ["Itachi"]={EnemyName="Itache",WorldId=1}, ["Broly"]={EnemyName="Broly",WorldId=2},
    ["WhiteBeard"]={EnemyName="White Beard",WorldId=3}, ["BarbaBranca"]={EnemyName="White Beard",WorldId=3},
    ["ArmoredTitan"]={EnemyName="Armored Titan",WorldId=4}, ["Beleon"]={EnemyName="Beleon",WorldId=5},
    ["Kokeshebo"]={EnemyName="Kokeshebo",WorldId=6}, ["Lucies"]={EnemyName="Lucies",WorldId=7},
    ["Quinella"]={EnemyName="Quinella",WorldId=8}, ["Sho"]={EnemyName="Sho",WorldId=9},
    ["Aiz"]={EnemyName="Aiz",WorldId=10},
}

function aas_promoNormalizeRelicName(name) return AAS_PROMO_RELIC_ALIASES[tostring(name or "")] or tostring(name or "") end

function aas_promoMissionSource(missionState)
    if type(missionState) ~= "table" then return {} end
    return missionState.Mission or missionState
end

function aas_promoMissionType(missionState)
    local src = aas_promoMissionSource(missionState)
    if type(missionState) == "table" and type(missionState.Type) == "string" and missionState.Type ~= "" then return missionState.Type end
    local ok, result = pcall(function() return aas_PromotionConfig:GetQuestType(src) end)
    return ok and tostring(result or "Defeat") or "Defeat"
end

function aas_promoMissionRequired(missionState)
    if type(missionState) == "table" and missionState.Required ~= nil then return tonumber(missionState.Required) or 0 end
    local src = aas_promoMissionSource(missionState)
    local ok, result = pcall(function() return aas_PromotionConfig:GetRequiredAmount(src) end)
    return ok and (tonumber(result) or 0) or 0
end

function aas_promoMissionCurrent(missionState)
    if type(missionState) ~= "table" then return 0 end
    return tonumber(missionState.Current) or 0
end

function aas_promoMissionComplete(missionState)
    if type(missionState) ~= "table" then return false end
    if missionState.Complete == true then return true end
    return aas_promoMissionCurrent(missionState) >= aas_promoMissionRequired(missionState)
end

function aas_promoResolveMobTarget(rawMobName)
    local raw = tostring(rawMobName or "")
    if raw == "" then return nil end
    if AAS_PROMO_MOB_MAP[raw] then return AAS_PROMO_MOB_MAP[raw] end
    local cleaned = raw:gsub("%s+", ""):lower()
    for key, info in pairs(AAS_PROMO_MOB_MAP) do
        if tostring(key):gsub("%s+", ""):lower() == cleaned then return info end
    end
    return nil
end

function aas_promoBuildMissionText(missionState, includeProgress)
    local src = aas_promoMissionSource(missionState)
    local t = aas_promoMissionType(missionState)
    local text = ""
    if t == "Defeat" then text = "Defeat "..(src.Mob or "*").." x"..tostring(src.Kills or src.Amount or aas_promoMissionRequired(missionState))
    elseif t == "PlayerLevel" then text = "Reach Level "..tostring(src.Level or aas_promoMissionRequired(missionState))
    elseif t == "PlayerRank" then text = "Reach Rank "..tostring(src.Rank or aas_promoMissionRequired(missionState))
    elseif t == "GamemodeJoin" then text = "Join "..tostring(src.Gamemode or "?").." x"..tostring(src.Joins or aas_promoMissionRequired(missionState))
    elseif t == "GamemodeWaves" then text = tostring(src.Waves or aas_promoMissionRequired(missionState)).." waves in "..tostring(src.Gamemode or "?")
    elseif t == "GamemodeComplete" then text = "Complete "..tostring(src.Gamemode or "?").." x"..tostring(src.Amount or aas_promoMissionRequired(missionState))
    elseif t == "GachaRoll" then text = "Roll "..tostring(src.Gacha or "?").." x"..tostring(src.Amount or aas_promoMissionRequired(missionState))
    elseif t == "RelicLevel" then text = tostring(aas_promoNormalizeRelicName(src.Relic or "?")).." to Level "..tostring(src.Level or aas_promoMissionRequired(missionState))
    elseif t == "RelicAscension" then text = tostring(aas_promoNormalizeRelicName(src.Relic or "?")).." to Ascension "..tostring(src.Ascension or aas_promoMissionRequired(missionState))
    elseif t == "PetSummon" then text = "Summon pets in "..tostring(src.World or "?").." x"..tostring(src.Amount or aas_promoMissionRequired(missionState))
    else text = tostring(t) end
    if includeProgress then text = text.." ("..tostring(aas_promoMissionCurrent(missionState)).."/"..tostring(aas_promoMissionRequired(missionState))..")" end
    return text
end

function aas_promoBuildRankSummary(rank)
    local rankData = aas_PromotionConfig:GetRank(rank)
    if not rankData then return "Promotion "..tostring(rank).." — Unknown" end
    local bits = {}
    for _, mission in ipairs(rankData.Missions or {}) do table.insert(bits, aas_promoBuildMissionText(mission, false)) end
    return tostring(rankData.Name or ("Promotion "..tostring(rank))).." — "..table.concat(bits, " | ")
end

function aas_buildFallbackPromotionState()
    if not S.cachedPlayerData then pcall(aas_syncAllPlayerData) end
    local data = S.cachedPlayerData or {}
    local currentRank = tonumber(data.PromotionRank) or 0
    local missions = aas_PromotionConfig:GetMissions(currentRank) or {}
    local rawProgress = data.PromotionProgress or {}
    local stateMissions = {}
    for i, mission in ipairs(missions) do
        local req = tonumber(aas_PromotionConfig:GetRequiredAmount(mission)) or 0
        local cur = tonumber(rawProgress[tostring(i)] or rawProgress[i]) or 0
        table.insert(stateMissions, { Index=i, Type=aas_PromotionConfig:GetQuestType(mission), Mission=mission, Current=cur, Required=req, Complete=cur>=req })
    end
    return { PromotionRank=currentRank, NextRank=aas_PromotionConfig:GetNextRank(currentRank), CanPromote=false, Missions=stateMissions }
end

function aas_promoGetMergedState()
    local fallback = aas_buildFallbackPromotionState()
    local live = S.promotionLiveState
    local rank = tonumber((live and live.PromotionRank) or (S.cachedPlayerData and S.cachedPlayerData.PromotionRank) or fallback.PromotionRank or 0) or 0
    local cfgMissions = aas_PromotionConfig:GetMissions(rank) or {}
    local liveMissions = (live and type(live.Missions) == "table" and live.Missions) or {}
    local rawProgress = (S.cachedPlayerData and S.cachedPlayerData.PromotionProgress) or {}
    local merged = { PromotionRank=rank, NextRank=(live and live.NextRank) or aas_PromotionConfig:GetNextRank(rank), CanPromote=(live and live.CanPromote == true) or false, Missions={} }
    for i, cfgMission in ipairs(cfgMissions) do
        local liveMission = liveMissions[i]
        local req, cur, complete = 0, 0, false
        if liveMission then
            req = tonumber(aas_promoMissionRequired(liveMission)) or 0
            cur = tonumber(aas_promoMissionCurrent(liveMission)) or 0
            complete = aas_promoMissionComplete(liveMission)
        else
            req = tonumber(aas_PromotionConfig:GetRequiredAmount(cfgMission)) or 0
            cur = tonumber(rawProgress[tostring(i)] or rawProgress[i]) or 0
            complete = req > 0 and cur >= req
        end
        table.insert(merged.Missions, { Index=i, Type=aas_PromotionConfig:GetQuestType(cfgMission), Mission=cfgMission, Current=cur, Required=req, Complete=complete })
    end
    return merged
end

function aas_requestPromotionState(timeout)
    timeout = timeout or 2
    local oldVersion = S.promotionStateVersion or 0
    pcall(function() aas_promotionStateRequestRemote:Fire() end)
    local deadline = tick() + timeout
    while tick() < deadline do
        if (S.promotionStateVersion or 0) > oldVersion and type(S.promotionLiveState) == "table" then return true, S.promotionLiveState end
        task.wait(0.05)
    end
    return type(S.promotionLiveState) == "table" and true or false, S.promotionLiveState or aas_buildFallbackPromotionState()
end

function aas_updatePromotionUi()
    local state = aas_promoGetMergedState()
    if type(state) ~= "table" then return end
    local currentRank = tonumber(state.PromotionRank) or 0
    local missions = state.Missions or {}
    local completeCount = 0
    for _, m in ipairs(missions) do if aas_promoMissionComplete(m) then completeCount += 1 end end
    if S.promotionCurrentRankLabelRef then pcall(function() S.promotionCurrentRankLabelRef:SetText("Current Rank: "..tostring(currentRank)) end) end
    if S.promotionNextRankLabelRef then pcall(function() S.promotionNextRankLabelRef:SetText("Next Rank: "..tostring(state.NextRank or "-")) end) end
    if S.promotionCanPromoteLabelRef then pcall(function() S.promotionCanPromoteLabelRef:SetText("Can Promote: "..tostring(state.CanPromote == true)) end) end
    if S.promotionProgressLabelRef then pcall(function() S.promotionProgressLabelRef:SetText("Mission Progress: "..tostring(completeCount).."/"..tostring(#missions)) end) end
    for i = 1, 10 do
        local labelRef = S.promotionMissionLabelRefs[i]
        if labelRef then
            local missionState = missions[i]
            if missionState then
                local icon = aas_promoMissionComplete(missionState) and "✅ " or "⏳ "
                pcall(function() labelRef:SetText(icon..aas_promoBuildMissionText(missionState, true)) end)
            else pcall(function() labelRef:SetText(" ") end) end
        end
    end
    for rank, labelRef in pairs(S.promotionRankRefLabelRefs) do
        if labelRef then
            local prefix = rank < currentRank and "✅ " or (rank == currentRank and "➡️ " or "• ")
            pcall(function() labelRef:SetText(prefix..aas_promoBuildRankSummary(rank)) end)
        end
    end
end

function aas_promoGetIncompleteMissions()
    local state = aas_promoGetMergedState()
    local incomplete = {}
    for _, missionState in ipairs(state.Missions or {}) do
        if not aas_promoMissionComplete(missionState) then table.insert(incomplete, missionState) end
    end
    return state, incomplete
end

function aas_promoChooseForegroundAction(incompleteMissions)
    for _, missionState in ipairs(incompleteMissions) do
        local src = aas_promoMissionSource(missionState)
        local t = aas_promoMissionType(missionState)
        if (t == "GamemodeWaves" or t == "GamemodeComplete") and AAS_GQ_GAMEMODE_MAP[tostring(src.Gamemode or "")] then
            return { Kind="GamemodeFull", Gamemode=tostring(src.Gamemode or "") }
        end
    end
    for _, missionState in ipairs(incompleteMissions) do
        local src = aas_promoMissionSource(missionState)
        local t = aas_promoMissionType(missionState)
        if t == "Defeat" then
            local target = aas_promoResolveMobTarget(src.Mob)
            if target then return { Kind="SpecificMob", Target=target } end
        elseif t == "RelicLevel" or t == "RelicAscension" then
            local relicInfo = AAS_GQ_RELIC_MAP[aas_promoNormalizeRelicName(src.Relic)]
            if relicInfo then
                for _, mi in pairs(AAS_PROMO_MOB_MAP) do
                    if mi.WorldId == relicInfo.WorldId then return { Kind="SpecificMob", Target=mi } end
                end
            end
        elseif t == "AccessoryObtain" then
            local accInfo = AAS_GQ_ACCESSORY_MAP[src.Accessory or ""]
            if accInfo then
                local target = aas_promoResolveMobTarget(accInfo.Mob)
                if target then return { Kind="SpecificMob", Target=target } end
            end
        end
    end
    for _, missionState in ipairs(incompleteMissions) do
        local src = aas_promoMissionSource(missionState)
        local t = aas_promoMissionType(missionState)
        if t == "GamemodeJoin" and AAS_GQ_GAMEMODE_MAP[tostring(src.Gamemode or "")] then
            return { Kind="GamemodeJoin", Gamemode=tostring(src.Gamemode or "") }
        end
    end
    for _, missionState in ipairs(incompleteMissions) do
        local src = aas_promoMissionSource(missionState)
        local t = aas_promoMissionType(missionState)
        if t == "Defeat" then
            local isAny = false
            pcall(function() isAny = aas_PromotionConfig:IsAnyMob(src) end)
            if isAny then
                local bestWorldId = 1
                pcall(function()
                    local data = S.cachedPlayerData or {}
                    bestWorldId = tonumber(data.CurrentWorld or data.ActiveWorld or 1) or 1
                end)
                return { Kind="AnyMob", WorldId=bestWorldId }
            end
        end
    end
    return nil
end

function aas_promoDoGamemodeStep(gamemodeName, fullRun)
    local gmInfo = AAS_GQ_GAMEMODE_MAP[gamemodeName]
    if not gmInfo then task.wait(1) return end
    if gmInfo.Type == "Raid" then
        aas_equipLoadout(S.RaidLoadouts[gmInfo.Key] or "Power")
        if fullRun then
            aas_joinOrCreateRaid(gmInfo.Key)
            if not aas_waitForRaidArena(gmInfo.Key, 10) then return end
            task.wait(5)
            local deadline = tick() + 900
            while S.promotionEnabled and tick() < deadline do
                if not aas_raidArenaExists(gmInfo.Key) then break end
                if S.raidOptimizedFarm then task.wait(0.5)
                else
                    local mobs = aas_findMobsInFolder(aas_getRaidEnemiesFolder(gmInfo.Key), nil)
                    if #mobs == 0 then task.wait(0.2) continue end
                    for _, mob in ipairs(mobs) do
                        if not S.promotionEnabled or not aas_raidArenaExists(gmInfo.Key) then break end
                        if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                        aas_teleportToMob(mob) aas_waitForDead(mob, 15) task.wait(0.05)
                    end
                end
                task.wait(0.05)
            end
            if aas_raidArenaExists(gmInfo.Key) then aas_leaveRaid() task.wait(5) end
        else
            aas_joinOrCreateRaid(gmInfo.Key) task.wait(2.5)
            if aas_raidArenaExists(gmInfo.Key) then aas_leaveRaid() end
            task.wait(2.5)
        end
    elseif gmInfo.Type == "Defense" then
        aas_equipLoadout(S.DefenseLoadouts[gmInfo.Key] or "Power")
        local defData = S.DefenseList[gmInfo.Key]
        if defData and defData.WorldId then pcall(function() aas_requestChangeWorldRemote:Fire(defData.WorldId) end) task.wait(3) end
        if fullRun then
            aas_joinOrCreateDefense(gmInfo.Key)
            if not aas_waitForDefenseArena(gmInfo.Key, 10) then return end
            task.wait(5)
            local deadline = tick() + 900
            while S.promotionEnabled and tick() < deadline do
                if not aas_defenseArenaExists(gmInfo.Key) then break end
                local mobs = aas_findMobsInFolder(aas_getDefenseEnemiesFolder(gmInfo.Key), nil)
                if #mobs == 0 then task.wait(0.2) continue end
                for _, mob in ipairs(mobs) do
                    if not S.promotionEnabled or not aas_defenseArenaExists(gmInfo.Key) then break end
                    if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                    aas_teleportToMob(mob) aas_waitForDead(mob, 15) task.wait(0.05)
                end
                task.wait(0.05)
            end
            if aas_defenseArenaExists(gmInfo.Key) then aas_leaveDefense() task.wait(5) end
        else
            aas_joinOrCreateDefense(gmInfo.Key) task.wait(2.5)
            if aas_defenseArenaExists(gmInfo.Key) then aas_leaveDefense() end
            task.wait(2.5)
        end
    else task.wait(1) end
end

function aas_promoBackgroundGachaLoop()
    while S.promotionEnabled do
        pcall(aas_syncAllPlayerData) pcall(function() aas_promotionStateRequestRemote:Fire() end)
        local liveState = S.promotionLiveState or {}
        local rank = tonumber(liveState.PromotionRank) or tonumber(S.cachedPlayerData and S.cachedPlayerData.PromotionRank) or 0
        local cfgMissions = aas_PromotionConfig:GetMissions(rank) or {}
        local liveMissions = liveState.Missions or {}
        local didSomething = false
        for i, cfgMission in ipairs(cfgMissions) do
            if not S.promotionEnabled then break end
            if aas_PromotionConfig:GetQuestType(cfgMission) ~= "GachaRoll" then continue end
            local liveMission = liveMissions[i]
            if not (liveMission and aas_promoMissionComplete(liveMission)) then
                local gachaKey = tostring(cfgMission.Gacha or "")
                if gachaKey ~= "" then pcall(function() aas_gachaRollRemote:Fire(gachaKey) end) didSomething = true task.wait(0.3) end
            end
        end
        task.wait(didSomething and 0.3 or 1)
    end
end

function aas_promoBackgroundEggLoop()
    while S.promotionEnabled do
        pcall(aas_syncAllPlayerData) pcall(function() aas_promotionStateRequestRemote:Fire() end)
        local liveState = S.promotionLiveState or {}
        local rank = tonumber(liveState.PromotionRank) or tonumber(S.cachedPlayerData and S.cachedPlayerData.PromotionRank) or 0
        local cfgMissions = aas_PromotionConfig:GetMissions(rank) or {}
        local liveMissions = liveState.Missions or {}
        local didSomething = false
        for i, cfgMission in ipairs(cfgMissions) do
            if not S.promotionEnabled then break end
            if aas_PromotionConfig:GetQuestType(cfgMission) ~= "PetSummon" then continue end
            local liveMission = liveMissions[i]
            if not (liveMission and aas_promoMissionComplete(liveMission)) then
                local eggKey = tostring(cfgMission.World or "")
                if eggKey ~= "" then pcall(function() aas_openEggRemote:Fire(eggKey) end) didSomething = true task.wait(0.65) end
            end
        end
        task.wait(didSomething and 0.65 or 1)
    end
end

function aas_promoBackgroundRelicLoop()
    while S.promotionEnabled do
        pcall(aas_syncAllPlayerData) pcall(function() aas_promotionStateRequestRemote:Fire() end)
        local state = aas_promoGetMergedState()
        local didSomething = false
        for _, missionState in ipairs(state.Missions or {}) do
            if not S.promotionEnabled then break end
            if aas_promoMissionComplete(missionState) then continue end
            local src = aas_promoMissionSource(missionState)
            local t = aas_promoMissionType(missionState)
            if t == "RelicLevel" or t == "RelicAscension" then
                local relicName = aas_promoNormalizeRelicName(src.Relic)
                local relicState = aas_getRelicState(relicName)
                if relicState then
                    local level = tonumber(relicState.Level) or 0
                    local asc = tonumber(relicState.Ascension) or 0
                    local canAscend = false
                    pcall(function() canAscend = aas_RelicConfig:CanAscend(level, asc) end)
                    if canAscend then pcall(function() aas_relicAscendRemote:Fire(relicName) end) task.wait(1)
                    else pcall(function() aas_relicUpgradeRemote:Fire(relicName) end) task.wait(0.3) end
                    didSomething = true
                end
            end
        end
        task.wait(didSomething and 0.3 or 1)
    end
end

function aas_promoStartBackgroundThreads()
    if not S.promotionBgGachaThread then S.promotionBgGachaThread = task.spawn(aas_promoBackgroundGachaLoop) end
    if not S.promotionBgEggThread then S.promotionBgEggThread = task.spawn(aas_promoBackgroundEggLoop) end
    if not S.promotionBgRelicThread then S.promotionBgRelicThread = task.spawn(aas_promoBackgroundRelicLoop) end
end

function aas_promoStopBackgroundThreads()
    if S.promotionBgGachaThread then task.cancel(S.promotionBgGachaThread) S.promotionBgGachaThread = nil end
    if S.promotionBgEggThread then task.cancel(S.promotionBgEggThread) S.promotionBgEggThread = nil end
    if S.promotionBgRelicThread then task.cancel(S.promotionBgRelicThread) S.promotionBgRelicThread = nil end
end

function aas_autoPromotionLoop()
    pcall(aas_syncAllPlayerData) aas_requestPromotionState(2) aas_promoStartBackgroundThreads()
    while S.promotionEnabled do
        pcall(aas_syncAllPlayerData) aas_requestPromotionState(1.5)
        local highPrio, highType = aas_isHighPrioritySpawnOrRunPresent()
        if highPrio then
            if not S.promotionSuppressedByPriority then
                S.promotionSuppressedByPriority = true
                Library:Notify("Promotion Paused - "..tostring(highType).." has higher priority.")
            end
            task.wait(1) continue
        else
            if S.promotionSuppressedByPriority then
                S.promotionSuppressedByPriority = false
                Library:Notify("Promotion Resumed")
            end
        end

        local state, incomplete = aas_promoGetIncompleteMissions()
        aas_updatePromotionUi()
        if type(state) ~= "table" then task.wait(1) continue end

        if state.CanPromote == true then
            local oldRank = tonumber(state.PromotionRank) or 0
            Library:Notify("Promotion - Promoting from rank "..tostring(oldRank).."...")
            pcall(function() aas_promotionPromoteRemote:Fire() end)
            local promoted = false
            local deadline = tick() + 10
            while S.promotionEnabled and tick() < deadline do
                task.wait(0.4) pcall(aas_syncAllPlayerData) aas_requestPromotionState(1.2)
                local newRank = tonumber((S.promotionLiveState and S.promotionLiveState.PromotionRank) or (S.cachedPlayerData and S.cachedPlayerData.PromotionRank) or oldRank) or oldRank
                if newRank > oldRank then promoted = true break end
            end
            aas_updatePromotionUi()
            if promoted then Library:Notify("Promotion - Now farming Promotion "..tostring(S.promotionLiveState and S.promotionLiveState.PromotionRank or "?")) end
            task.wait(0.5) continue
        end

        if #incomplete == 0 then task.wait(1) continue end

        local action = aas_promoChooseForegroundAction(incomplete)
        if not action then task.wait(1)
        elseif action.Kind == "GamemodeFull" then aas_promoDoGamemodeStep(action.Gamemode, true)
        elseif action.Kind == "GamemodeJoin" then aas_promoDoGamemodeStep(action.Gamemode, false)
        elseif action.Kind == "SpecificMob" then
            aas_equipLoadout(S.LoadoutAssignments.Farm or "Power")
            aas_enterPotionContext("Farm")

            if action.Target.WorldId == 7 and action.Target.EnemyName == "Lucies" then
                local lf = workspace:FindFirstChild("Worlds")
                lf = lf and lf:FindFirstChild("7") lf = lf and lf:FindFirstChild("Enemies")
                if not (lf and lf:FindFirstChild("Lucies")) then aas_preloadWorld7Boss() end
            end

            if S.currentWorldTracked ~= action.Target.WorldId then
                aas_teleportToWorld(action.Target.WorldId)
                S.currentWorldTracked = action.Target.WorldId
            end

            local mobs = aas_findMobsInWorld(action.Target.WorldId, { action.Target.EnemyName })
            local count = 0
            if S.clusterFarmEnabled then
                local centerPos, cluster = aas_getClusterCenter(mobs, 40, 1)
                if centerPos then
                    aas_teleportToClusterCenter(centerPos)
                    aas_waitForClusterDead(cluster, 25)
                end
            else
                for _, mob in ipairs(mobs) do
                    if not S.promotionEnabled then break end
                    if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                    aas_teleportToMob(mob) aas_waitForDead(mob, 25) task.wait(0.05)
                    count += 1
                    if count >= 10 then break end
                end
            end
        elseif action.Kind == "AnyMob" then
            aas_equipLoadout(S.LoadoutAssignments.Farm or "Power")
            aas_enterPotionContext("Farm")

            local bestWorldId = action.WorldId or 1
            if S.currentWorldTracked ~= bestWorldId then
                aas_teleportToWorld(bestWorldId)
                S.currentWorldTracked = bestWorldId
            end

            local mobs = aas_findMobsInWorld(bestWorldId, nil)
            local count = 0
            if S.clusterFarmEnabled then
                local centerPos, cluster = aas_getClusterCenter(mobs, 40, 1)
                if centerPos then
                    aas_teleportToClusterCenter(centerPos)
                    aas_waitForClusterDead(cluster, 25)
                end
            else
                for _, mob in ipairs(mobs) do
                    if not S.promotionEnabled then break end
                    if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                    aas_teleportToMob(mob) aas_waitForDead(mob, 25) task.wait(0.05)
                    count += 1
                    if count >= 10 then break end
                end
            end
        else task.wait(1) end

        pcall(aas_syncAllPlayerData) aas_requestPromotionState(1.2) task.wait(0.1)
    end
    aas_promoStopBackgroundThreads()
    S.currentWorldTracked = nil S.promotionSuppressedByPriority = false
end

-- ══════════════════════════════════════════
--   CROW / BALL / COMMANDMENT HARVESTERS
-- ══════════════════════════════════════════

function aas_getAllCrows()
    local folder = workspace:FindFirstChild("World6Corvos")
    if not folder then return {} end
    local found = {}
    for _, child in ipairs(folder:GetChildren()) do
        if child.Name:match("^Corvo_") then table.insert(found, child) end
    end
    return found
end

function aas_getAllBalls()
    local folder = workspace:FindFirstChild("World8Balls")
    if not folder then return {} end
    local found = {}
    for _, child in ipairs(folder:GetChildren()) do
        if child.Name:match("^Ball_") then table.insert(found, child) end
    end
    return found
end

function aas_getAllCommandments()
    local folder = workspace:FindFirstChild("World12Commandments")
    if not folder then return {} end
    local found = {}
    for _, child in ipairs(folder:GetChildren()) do
        if child.Name:match("^Commandment_") then table.insert(found, child) end
    end
    return found
end

function aas_claimObject(obj)
    local target = nil
    if obj:IsA("BasePart") then target = obj
    elseif obj:IsA("Model") then target = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
    end
    if not target then
        for _, v in ipairs(obj:GetDescendants()) do if v:IsA("BasePart") then target = v break end end
    end
    if not target then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = target.CFrame * CFrame.new(0, 3, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.05)
    local prompt = nil
    for _, desc in ipairs(obj:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then prompt = desc break end
    end
    if not prompt then
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc:IsA("ProximityPrompt") and desc.Enabled then
                local part = desc.Parent
                if part and part:IsA("BasePart") and (part.Position - hrp.Position).Magnitude < 15 then
                    prompt = desc break
                end
            end
        end
    end
    if prompt then
        pcall(function() prompt.HoldDuration = 0 prompt.MaxActivationDistance = math.huge prompt.RequiresLineOfSight = false prompt.Enabled = true end)
        local done = false
        local conns = {}
        table.insert(conns, obj.AncestryChanged:Connect(function(_, parent) if not parent then done = true end end))
        local deadline = os.clock() + 1.25
        local nextFire = os.clock() + 0.05
        while not done and os.clock() < deadline and obj.Parent do
            hrp.CFrame = target.CFrame * CFrame.new(0, 3, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
            if os.clock() >= nextFire then pcall(fireproximityprompt, prompt, 1) nextFire = os.clock() + 0.08 end
            task.wait()
        end
        for _, c in ipairs(conns) do c:Disconnect() end
    else
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end

function aas_crowBallClaimProcessor()
    while S.autoCrowEnabled or S.autoBallEnabled or S.autoCommandmentEnabled do
        local hadPendingBefore = (#S.pendingCrows > 0) or (#S.pendingBalls > 0)
        local newCrowCount, newBallCount = 0, 0

        if S.autoCrowEnabled then
            local crows = aas_getAllCrows()
            for _, crow in ipairs(crows) do
                local already = false
                for _, pc in ipairs(S.pendingCrows) do if pc == crow then already = true break end end
                if not already then table.insert(S.pendingCrows, crow) newCrowCount = newCrowCount + 1 end
            end
        end

        if S.autoBallEnabled then
            local balls = aas_getAllBalls()
            for _, ball in ipairs(balls) do
                local already = false
                for _, pb in ipairs(S.pendingBalls) do if pb == ball then already = true break end end
                if not already then table.insert(S.pendingBalls, ball) newBallCount = newBallCount + 1 end
            end
        end

        if S.autoCommandmentEnabled then
            local cmdFolder = workspace:FindFirstChild("World12Commandments")
            if cmdFolder then
                for _, child in ipairs(cmdFolder:GetChildren()) do
                    if child.Name:match("^Commandment_") then
                        local already = false
                        for _, pc in ipairs(S.pendingBalls) do if pc == child then already = true break end end
                        if not already then table.insert(S.pendingBalls, child) newBallCount = newBallCount + 1 end
                    end
                end
            end
        end

        local hasPendingNow = (#S.pendingCrows > 0) or (#S.pendingBalls > 0)
        if hasPendingNow and not hadPendingBefore then
            S.pendingCrowBallReadyAt = tick() + AAS_CROW_BALL_GRACE
        end

        if newCrowCount > 0 or newBallCount > 0 then
            Library:Notify("Detected Spawn - Queued " .. tostring(#S.pendingCrows) .. " crow(s), " .. tostring(#S.pendingBalls) .. " ball(s). Harvesting in " .. tostring(AAS_CROW_BALL_GRACE) .. "s...")
        end

        if hasPendingNow then
            local aliveCrows = {}
            for _, crow in ipairs(S.pendingCrows) do if crow and crow.Parent then table.insert(aliveCrows, crow) end end
            S.pendingCrows = aliveCrows
            local aliveBalls = {}
            for _, ball in ipairs(S.pendingBalls) do if ball and ball.Parent then table.insert(aliveBalls, ball) end end
            S.pendingBalls = aliveBalls
        end

        hasPendingNow = (#S.pendingCrows > 0) or (#S.pendingBalls > 0)

        if hasPendingNow then
            local highPriorityPresent, _ = aas_isHighPrioritySpawnOrRunPresent()
            if not highPriorityPresent and S.pendingCrowBallReadyAt > 0 and tick() >= S.pendingCrowBallReadyAt then
                local snapshot = aas_snapshotAndPauseActivities()
                Library:Notify("Harvesting items now...")

                local crowClaimedCount = 0
                if #S.pendingCrows > 0 then
                    aas_changeWorldAndWait(6) task.wait(0.5)
                    for _, crow in ipairs(S.pendingCrows) do
                        if crow and crow.Parent then pcall(function() aas_claimObject(crow) end) crowClaimedCount = crowClaimedCount + 1 task.wait(1) end
                    end
                    S.pendingCrows = {}
                end

                local ballClaimedCount = 0
                if #S.pendingBalls > 0 then
                    local world8Items, world12Items = {}, {}
                    for _, item in ipairs(S.pendingBalls) do
                        if item and item.Parent then
                            if item.Name:match("^Commandment_") then table.insert(world12Items, item)
                            else table.insert(world8Items, item) end
                        end
                    end
                    if #world8Items > 0 then
                        aas_changeWorldAndWait(8) task.wait(0.5)
                        for _, ball in ipairs(world8Items) do
                            if ball and ball.Parent then pcall(function() aas_claimObject(ball) end) ballClaimedCount = ballClaimedCount + 1 task.wait(1) end
                        end
                    end
                    if #world12Items > 0 then
                        aas_changeWorldAndWait(12) task.wait(0.5)
                        for _, cmd in ipairs(world12Items) do
                            if cmd and cmd.Parent then pcall(function() aas_claimObject(cmd) end) ballClaimedCount = ballClaimedCount + 1 task.wait(1) end
                        end
                    end
                    S.pendingBalls = {}
                end

                S.pendingCrowBallReadyAt = 0
                Library:Notify("Harvest Complete - " .. tostring(crowClaimedCount) .. " crow(s), " .. tostring(ballClaimedCount) .. " ball(s)/commandment(s)")
                aas_resumeFromSnapshot(snapshot)
            end
        else
            S.pendingCrowBallReadyAt = 0
        end

        task.wait(1)
    end
    S.pendingCrows = {} S.pendingBalls = {} S.pendingCrowBallReadyAt = 0
end

-- ══════════════════════════════════════════
--   SERVER HOP SYSTEMS
-- ══════════════════════════════════════════

local AC_visited = {}
local AC_serverCache = {}
local AC_backoffUntil = 0
local AC_fetching = false

function AC_markVisited(jobId) if not jobId or jobId == "" then return end AC_visited[jobId] = os.time() end
AC_markVisited(game.JobId)

function AC_httpJson(url)
    local req = request or http_request or (syn and syn.request)
    if req then
        local ok, res = pcall(req, { Url = url, Method = "GET" })
        if not ok then return nil, "err" end
        if res.StatusCode == 429 then return nil, "429" end
        if res.StatusCode ~= 200 then return nil, tostring(res.StatusCode) end
        local ok2, dec = pcall(function() return HttpService:JSONDecode(res.Body) end)
        return ok2 and dec or nil, ok2 and "ok" or "decode"
    end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if not ok or body == "" then return nil, "err" end
    local ok2, dec = pcall(function() return HttpService:JSONDecode(body) end)
    return ok2 and dec or nil, ok2 and "ok" or "decode"
end

function AC_fetchServers()
    if AC_fetching or os.time() < AC_backoffUntil then return end
    AC_fetching = true
    local seen = {}
    for _, id in ipairs(AC_serverCache) do seen[id] = true end
    local cursor = ""
    for page = 1, 3 do
        local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100"):format(game.PlaceId)
        if cursor ~= "" then url = url .. "&cursor=" .. cursor end
        local dec, why = AC_httpJson(url)
        if why == "429" then AC_backoffUntil = os.time() + 60 break end
        if not dec or not dec.data then break end
        for _, srv in ipairs(dec.data) do
            if srv.id ~= game.JobId and not AC_visited[srv.id] and not seen[srv.id]
                and srv.playing and srv.maxPlayers and srv.playing < srv.maxPlayers then
                AC_serverCache[#AC_serverCache + 1] = srv.id
                seen[srv.id] = true
            end
        end
        cursor = dec.nextPageCursor or ""
        if cursor == "" then break end
        if page < 3 then task.wait(1) end
    end
    AC_fetching = false
end

task.spawn(function()
    while true do
        if #AC_serverCache < 12 and os.time() >= AC_backoffUntil then AC_fetchServers() end
        task.wait(5)
    end
end)

function AC_serverHop()
    if #AC_serverCache == 0 then
        AC_fetchServers()
        local deadline = os.clock() + 5
        while AC_fetching and os.clock() < deadline do task.wait(0.1) end
    end
    Library:Notify("Scanning active public servers (" .. #AC_serverCache .. " cached)...")
    local failed = false
    local conn = game:GetService("TeleportService").TeleportInitFailed:Connect(function() failed = true end)
    AC_markVisited(game.JobId)
    for attempt = 1, 8 do
        if #AC_serverCache == 0 then AC_fetchServers() task.wait(3) end
        if #AC_serverCache == 0 then break end
        local i = math.random(1, #AC_serverCache)
        local pick = table.remove(AC_serverCache, i)
        if not AC_visited[pick] then
            failed = false AC_markVisited(pick)
            pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, pick, LocalPlayer) end)
            local deadline = os.clock() + 4
            while not failed and os.clock() < deadline do task.wait(0.1) end
            if not failed then break end
        end
    end
    conn:Disconnect()
end

-- ══════════════════════════════════════════
--   SERVER HOP FARM
-- ══════════════════════════════════════════

function aas_serverHopFarmLoop()
    while S.serverHopFarmEnabled do
        local targets = S.serverHopFarmTargets or {}
        local foundAny, claimedAny = false, false

        if targets["Crow"] then
            local crows = aas_getAllCrows()
            if #crows > 0 then
                foundAny = true aas_changeWorldAndWait(6) task.wait(0.5)
                for _, crow in ipairs(crows) do
                    if crow and crow.Parent then pcall(function() aas_claimObject(crow) end) claimedAny = true task.wait(1) end
                end
            end
        end

        if targets["Ball"] then
            local balls = aas_getAllBalls()
            if #balls > 0 then
                foundAny = true aas_changeWorldAndWait(8) task.wait(0.5)
                for _, ball in ipairs(balls) do
                    if ball and ball.Parent then pcall(function() aas_claimObject(ball) end) claimedAny = true task.wait(1) end
                end
            end
        end

        if targets["Commandment"] then
            local cmds = aas_getAllCommandments()
            if #cmds > 0 then
                foundAny = true aas_changeWorldAndWait(12) task.wait(0.5)
                for _, cmd in ipairs(cmds) do
                    if cmd and cmd.Parent then pcall(function() aas_claimObject(cmd) end) claimedAny = true task.wait(1) end
                end
            end
        end

        if not foundAny then AC_serverHop() task.wait(10)
        elseif claimedAny then Library:Notify("Items secured! Re-scanning...") task.wait(2)
        else task.wait(2)
        end
    end
end

-- ══════════════════════════════════════════
--   AUTOMATION CONTROLS
-- ══════════════════════════════════════════

function aas_autoClick()
    task.spawn(function()
        while S.autoClickRunning do
            pcall(function() aas_clickRemote:Fire() end)
            task.wait(0.05)
        end
    end)
end

function aas_toggleAutoClaimAchievements(enabled) return pcall(function() aas_autoClaimAchievementsRemote:Fire(enabled) end) end
function aas_toggleAutoAvatar(enabled)             return pcall(function() aas_autoAvatarRemote:Fire(enabled) end) end
function aas_toggleAutoRank(enabled)               return pcall(function() aas_autoRankRemote:Fire("SetAutoRankUp", enabled) end) end
function aas_toggleAutoStat(statName, enabled)     return pcall(function() aas_autoStatRemote:Fire(statName, enabled) end) end
function aas_toggleAutoClaimRewards(enabled)       return pcall(function() aas_autoClaimRewardsRemote:Fire(enabled) end) end

function aas_redeemAllCodes()
    Library:Notify("Redeeming " .. #aas_codes .. " codes...")
    task.spawn(function()
        local successCount = 0
        for _, code in ipairs(aas_codes) do
            local ok = pcall(function() aas_redeemCodeRemote:Fire(code) end)
            if ok then successCount = successCount + 1 end
            task.wait(1)
        end
        Library:Notify("Codes Processed - " .. successCount .. "/" .. #aas_codes .. " redeemed!")
    end)
end

-- ══════════════════════════════════════════
--   CLEANUP SYSTEM
-- ══════════════════════════════════════════

function aas_cleanup()
    S.farmEnabled = false
    if S.farmThread then task.cancel(S.farmThread) S.farmThread = nil end

    for rk in pairs(S.raidEnabled) do S.raidEnabled[rk] = false end
    if S.raidThread then task.cancel(S.raidThread) S.raidThread = nil end
    if S.activeRaidKey and aas_raidArenaExists(S.activeRaidKey) then aas_leaveRaid() end
    S.activeRaidKey = nil

    for dk in pairs(S.defenseEnabled) do S.defenseEnabled[dk] = false end
    if S.defenseThread then task.cancel(S.defenseThread) S.defenseThread = nil end
    if S.activeDefenseKey and aas_defenseArenaExists(S.activeDefenseKey) then aas_leaveDefense() end
    S.activeDefenseKey = nil

    for dunk in pairs(S.dungeonEnabled) do S.dungeonEnabled[dunk] = false end
    for dunk, t in pairs(S.dungeonThreads) do task.cancel(t) S.dungeonThreads[dunk] = nil end
    if S.activeDungeonKey and aas_dungeonArenaExists(S.activeDungeonKey) then aas_leaveDungeon() end
    S.activeDungeonKey = nil

    for tk in pairs(S.trialEnabled) do S.trialEnabled[tk] = false end
    for tk, t in pairs(S.trialThreads) do task.cancel(t) S.trialThreads[tk] = nil end

    S.gateEnabled = false
    if S.gateThread then task.cancel(S.gateThread) S.gateThread = nil end

    for _, gk in ipairs(S.sortedGachaKeys) do
        S.gachaEnabled[gk] = false
        if S.gachaThreads[gk] then task.cancel(S.gachaThreads[gk]) S.gachaThreads[gk] = nil end
    end

    S.autoFuseAllEnabled = false
    if S.fuseAllThread then task.cancel(S.fuseAllThread) S.fuseAllThread = nil end

    S.autoCrowEnabled = false S.autoBallEnabled = false S.autoCommandmentEnabled = false
    if S.crowBallClaimThread then task.cancel(S.crowBallClaimThread) S.crowBallClaimThread = nil end
    S.pendingCrows = {} S.pendingBalls = {}

    S.passiveAutoEnabled = false
    if S.passiveThread then task.cancel(S.passiveThread) S.passiveThread = nil end

    S.titanAutoEnabled = false
    if S.titanThread then task.cancel(S.titanThread) S.titanThread = nil end

    S.swordPassive1Enabled = false
    if S.swordPassive1Thread then task.cancel(S.swordPassive1Thread) S.swordPassive1Thread = nil end
    S.swordPassive2Enabled = false
    if S.swordPassive2Thread then task.cancel(S.swordPassive2Thread) S.swordPassive2Thread = nil end

    S.grimoire1Enabled = false
    if S.grimoire1Thread then task.cancel(S.grimoire1Thread) S.grimoire1Thread = nil end
    S.grimoire2Enabled = false
    if S.grimoire2Thread then task.cancel(S.grimoire2Thread) S.grimoire2Thread = nil end

    for k in pairs(S.progressionEnabled) do S.progressionEnabled[k] = false end
    for k, t in pairs(S.progressionThreads) do task.cancel(t) S.progressionThreads[k] = nil end

    for k in pairs(S.rangeUpgradeEnabled) do S.rangeUpgradeEnabled[k] = false end
    for k, t in pairs(S.rangeUpgradeThreads) do task.cancel(t) S.rangeUpgradeThreads[k] = nil end

    for k in pairs(S.craftEnabled) do S.craftEnabled[k] = false end
    for k, t in pairs(S.craftThreads) do task.cancel(t) S.craftThreads[k] = nil end

    S.starEnabled = false
    if S.starThread then task.cancel(S.starThread) S.starThread = nil end

    S.autoClickRunning = false S.gateCooldown = false

    aas_toggleAutoClaimAchievements(false)
    aas_toggleAutoAvatar(false)
    aas_toggleAutoRank(false)
    aas_toggleAutoStat(S.currentStatSelection, false)
    aas_toggleAutoClaimRewards(false)

    S.SwordWorld0Enabled = false
    if S.SwordWorld0Thread then task.cancel(S.SwordWorld0Thread) S.SwordWorld0Thread = nil end
    S.SwordWorld8Enabled = false
    if S.SwordWorld8Thread then task.cancel(S.SwordWorld8Thread) S.SwordWorld8Thread = nil end

    S.antiAfkEnabled = false
    if S.antiAfkThread then task.cancel(S.antiAfkThread) S.antiAfkThread = nil end

    S.petPassiveAutoEnabled = false
    if S.petPassiveThread then task.cancel(S.petPassiveThread) S.petPassiveThread = nil end

    S.potionContextEnabled = false S.potionAutoUseEnabled = false
    if S.potionAutoUseThread then task.cancel(S.potionAutoUseThread) S.potionAutoUseThread = nil end
    S.currentPotionContext = nil

    S.globalQuestEnabled = false
    if S.globalQuestThread then task.cancel(S.globalQuestThread) S.globalQuestThread = nil end
    S.globalQuestAutoClaimEnabled = false
    if S.globalQuestClaimThread then task.cancel(S.globalQuestClaimThread) S.globalQuestClaimThread = nil end

    S.autoRelicUpgradeEnabled = false
    if S.autoRelicUpgradeThread then task.cancel(S.autoRelicUpgradeThread) S.autoRelicUpgradeThread = nil end
    S.autoRelicAscendEnabled = false
    if S.autoRelicAscendThread then task.cancel(S.autoRelicAscendThread) S.autoRelicAscendThread = nil end

    S.autoEvolutionEnabled = false
    if S.autoEvolutionThread then task.cancel(S.autoEvolutionThread) S.autoEvolutionThread = nil end

    for sysKey in pairs(S.upgrades2Enabled2) do S.upgrades2Enabled2[sysKey] = false end
    for sysKey, t in pairs(S.upgrades2Threads2) do task.cancel(t) S.upgrades2Threads2[sysKey] = nil end

    S.promotionEnabled = false
    if S.promotionThread then task.cancel(S.promotionThread) S.promotionThread = nil end
    aas_promoStopBackgroundThreads()

    for rk in pairs(S.rushEnabled) do S.rushEnabled[rk] = false end
    for rk, t in pairs(S.rushThreads) do task.cancel(t) S.rushThreads[rk] = nil end
    if S.activeRushKey and aas_rushArenaExists(S.activeRushKey) then aas_leaveRush() end
    S.activeRushKey = nil

    for k in pairs(S.skillTreeEnabled) do S.skillTreeEnabled[k] = false end
    for k, t in pairs(S.skillTreeThreads) do task.cancel(t) S.skillTreeThreads[k] = nil end

    for k in pairs(S.constellationEnabled) do S.constellationEnabled[k] = false end
    for k, t in pairs(S.constellationThreads) do task.cancel(t) S.constellationThreads[k] = nil end

    S.serverHopFarmEnabled = false
    if S.serverHopFarmThread then task.cancel(S.serverHopFarmThread) S.serverHopFarmThread = nil end

    for bossId in pairs(S.spawnBossEnabled) do S.spawnBossEnabled[bossId] = false end
    for bossId, t in pairs(S.spawnBossThreads) do task.cancel(t) S.spawnBossThreads[bossId] = nil end

    print("Prism Unloaded Successfully.")
end

-- ══════════════════════════════════════════
--   LIVE STATE LISTENERS
-- ══════════════════════════════════════════

task.spawn(function()
    pcall(function()
        aas_promotionStateRemote:Connect(function(payload)
            if type(payload) ~= "table" then return end
            S.promotionLiveState = payload
            S.promotionCurrentRank = tonumber(payload.PromotionRank) or 0
            S.promotionNextRank = payload.NextRank
            S.promotionCanPromote = payload.CanPromote == true
            S.promotionStateVersion = (S.promotionStateVersion or 0) + 1
            aas_updatePromotionUi()
        end)
    end)
    pcall(function()
        aas_promotionPromoteResultRemote:Connect(function(success, errCode)
            local msg = success and "Promoted successfully!" or (errCode == "missions_incomplete" and "Complete all missions first." or errCode == "max_rank" and "Already at max promotion." or "Could not promote.")
            Library:Notify("Promotion - "..msg)
            task.wait(0.2) pcall(function() aas_promotionStateRequestRemote:Fire() end)
        end)
    end)
end)

task.spawn(function()
    pcall(function()
        aas_spawnBossStateRemote:Connect(function(payload)
            if type(payload) == "table" then
                S.spawnBossActiveState = payload
            end
        end)
    end)
    pcall(function() aas_spawnBossStateRequestRemote:Fire() end)
end)

-- ══════════════════════════════════════════
--   MAIN TAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local MainLeft = Tabs.Main:AddLeftGroupbox("Main Automation", "zap")

    MainLeft:AddToggle("AutoClick", {
        Text = "Auto Click", Default = false,
        Callback = function(value)
            S.autoClickRunning = value
            if value then aas_autoClick() Library:Notify("Auto Click - Started!") end
        end,
    })
    MainLeft:AddToggle("AutoClaimAchievements", {
        Text = "Auto Claim Achievements", Default = false,
        Callback = function(value)
            aas_toggleAutoClaimAchievements(value)
            Library:Notify("Auto Claim Achievements - "..(value and "Enabled!" or "Disabled"))
        end,
    })
    MainLeft:AddToggle("AutoAvatar", {
        Text = "Auto Equip Best Avatar", Default = false,
        Callback = function(value)
            aas_toggleAutoAvatar(value)
            Library:Notify("Auto Equip Avatar - "..(value and "Enabled!" or "Disabled"))
        end,
    })
    MainLeft:AddToggle("AutoRank", {
        Text = "Auto Rank Up", Default = false,
        Callback = function(value)
            aas_toggleAutoRank(value)
            Library:Notify("Auto Rank Up - "..(value and "Enabled!" or "Disabled"))
        end,
    })
    MainLeft:AddToggle("AutoClaimRewards", {
        Text = "Auto Claim Time Rewards", Default = false,
        Callback = function(value)
            aas_toggleAutoClaimRewards(value)
            Library:Notify("Auto Claim Rewards - "..(value and "Enabled!" or "Disabled"))
        end,
    })
    MainLeft:AddDivider()
    MainLeft:AddDropdown("StatSelection", {
        Values = { "Power", "Yen", "Damage", "Luck", "Xp", "Drop" },
        Default = 1, Text = "Select Stat to Auto Upgrade",
        Callback = function(value)
            S.currentStatSelection = value
            if S.autoStatEnabled then aas_toggleAutoStat(value, true) end
        end,
    })
    MainLeft:AddToggle("AutoStat", {
        Text = "Enable Auto Stat", Default = false,
        Callback = function(value)
            S.autoStatEnabled = value
            aas_toggleAutoStat(S.currentStatSelection, value)
            Library:Notify("Auto Stat - "..(value and ("Enabled for "..S.currentStatSelection) or "Disabled"))
        end,
    })

    local MainRight = Tabs.Main:AddRightGroupbox("Utilities", "wrench")

    MainRight:AddToggle("AntiAfkEnabled", {
        Text = "Anti AFK", Default = false,
        Callback = function(value)
            S.antiAfkEnabled = value
            if value then
                if S.antiAfkThread then task.cancel(S.antiAfkThread) end
                S.antiAfkThread = task.spawn(function()
                    local vim = game:GetService("VirtualInputManager")
                    while S.antiAfkEnabled do
                        vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game) task.wait(0.1)
                        vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game) task.wait(120)
                    end
                end)
                Library:Notify("Anti AFK - Enabled!")
            else
                if S.antiAfkThread then task.cancel(S.antiAfkThread) S.antiAfkThread = nil end
            end
        end,
    })
    MainRight:AddButton({ Text = "Redeem All Codes", Func = aas_redeemAllCodes })

    local CrowGroup = Tabs.Main:AddRightGroupbox("Auto Crow / Ball / Commandment", "feather")
    CrowGroup:AddLabel("Items are claimed AFTER Trial/Gate/Dungeon finishes.", true)
    CrowGroup:AddDivider()
    CrowGroup:AddToggle("AutoCrow", {
        Text = "Auto Crow (World 6)", Default = false,
        Callback = function(value)
            S.autoCrowEnabled = value
            if value then
                if not S.crowBallClaimThread then S.crowBallClaimThread = task.spawn(aas_crowBallClaimProcessor) end
                Library:Notify("Auto Crow - Enabled!")
            else
                if not S.autoBallEnabled and not S.autoCommandmentEnabled then
                    if S.crowBallClaimThread then task.cancel(S.crowBallClaimThread) S.crowBallClaimThread = nil end
                end
                S.pendingCrows = {}
            end
        end,
    })
    CrowGroup:AddToggle("AutoBall", {
        Text = "Auto Ball (World 8)", Default = false,
        Callback = function(value)
            S.autoBallEnabled = value
            if value then
                if not S.crowBallClaimThread then S.crowBallClaimThread = task.spawn(aas_crowBallClaimProcessor) end
                Library:Notify("Auto Ball - Enabled!")
            else
                if not S.autoCrowEnabled and not S.autoCommandmentEnabled then
                    if S.crowBallClaimThread then task.cancel(S.crowBallClaimThread) S.crowBallClaimThread = nil end
                end
                S.pendingBalls = {}
            end
        end,
    })
    CrowGroup:AddToggle("AutoCommandment", {
        Text = "Auto Commandment (World 12)", Default = false,
        Callback = function(value)
            S.autoCommandmentEnabled = value
            if value then
                if not S.crowBallClaimThread then S.crowBallClaimThread = task.spawn(aas_crowBallClaimProcessor) end
                Library:Notify("Auto Commandment - Enabled!")
            else
                if not S.autoCrowEnabled and not S.autoBallEnabled then
                    if S.crowBallClaimThread then task.cancel(S.crowBallClaimThread) S.crowBallClaimThread = nil end
                end
                local filtered = {}
                for _, item in ipairs(S.pendingBalls) do
                    if not item.Name:match("^Commandment_") then table.insert(filtered, item) end
                end
                S.pendingBalls = filtered
            end
        end,
    })

    local ServerHopGroup = Tabs.Main:AddRightGroupbox("Server Hop Farm", "refresh-cw")
    ServerHopGroup:AddLabel("Scans for items. Hops server if none found.", true)
    ServerHopGroup:AddDropdown("ServerHopTargets", {
        Values = { "Crow", "Ball", "Commandment" }, Multi = true, Default = nil,
        Text = "Select Items to Farm",
        Callback = function(val)
            S.serverHopFarmTargets = {}
            for item, state in pairs(val or {}) do if state then S.serverHopFarmTargets[item] = true end end
        end,
    })
    ServerHopGroup:AddToggle("ServerHopFarmEnabled", {
        Text = "Enable Server Hop Farm", Default = false,
        Callback = function(value)
            S.serverHopFarmEnabled = value
            if value then
                local anySelected = false
                for _ in pairs(S.serverHopFarmTargets) do anySelected = true break end
                if not anySelected then
                    Toggles["ServerHopFarmEnabled"]:SetValue(false)
                    Library:Notify("Server Hop Farm - Select at least one item type first!")
                    return
                end
                if S.serverHopFarmThread then task.cancel(S.serverHopFarmThread) end
                S.serverHopFarmThread = task.spawn(aas_serverHopFarmLoop)
                Library:Notify("Server Hop Farm - Started!")
            else
                if S.serverHopFarmThread then task.cancel(S.serverHopFarmThread) S.serverHopFarmThread = nil end
            end
        end,
    })

    local SpawnBossGroup = Tabs.Main:AddLeftGroupbox("Auto Spawn Boss", "skull")
    SpawnBossGroup:AddLabel("Spawns and farms bosses automatically.\nPauses for Trial/Gate/Dungeon.", true)
    SpawnBossGroup:AddDivider()

    if #S.sortedSpawnBossKeys == 0 then
        SpawnBossGroup:AddLabel("No spawn boss data found.", true)
    else
        for _, bossId in ipairs(S.sortedSpawnBossKeys) do
            local bossData = S.SpawnBossList[bossId]
            local worldLabel = aas_getWorldLabel(bossData.WorldId)
            local toggleKey = "AutoSpawnBoss_" .. bossId
            S.spawnBossEnabled[bossId] = false

            SpawnBossGroup:AddToggle(toggleKey, {
                Text = bossData.Name .. " (" .. worldLabel .. ")",
                Default = false,
                Callback = function(value)
                    if value then
                        if S.farmEnabled or aas_anyRaidActive() or aas_anyDefenseActive() or aas_anyRushActive() then
                            Toggles[toggleKey]:SetValue(false)
                            Library:Notify("Blocked - Disable Farm/Raid/Defense/Rush first.")
                            return
                        end
                        for _, otherBossId in ipairs(S.sortedSpawnBossKeys) do
                            if otherBossId ~= bossId and S.spawnBossEnabled[otherBossId] then
                                S.spawnBossEnabled[otherBossId] = false
                                if Toggles["AutoSpawnBoss_" .. otherBossId] then
                                    Toggles["AutoSpawnBoss_" .. otherBossId]:SetValue(false)
                                end
                                if S.spawnBossThreads[otherBossId] then
                                    task.cancel(S.spawnBossThreads[otherBossId])
                                    S.spawnBossThreads[otherBossId] = nil
                                end
                            end
                        end

                        S.spawnBossEnabled[bossId] = true
                        aas_equipLoadout(S.LoadoutAssignments.Farm or "Power")
                        aas_enterPotionContext("Farm")
                        if S.spawnBossThreads[bossId] then task.cancel(S.spawnBossThreads[bossId]) end
                        S.spawnBossThreads[bossId] = task.spawn(function() aas_spawnBossLoop(bossId) end)
                        Library:Notify("Auto Spawn Boss - " .. bossData.Name .. " started!")
                    else
                        S.spawnBossEnabled[bossId] = false
                        if S.spawnBossThreads[bossId] then
                            task.cancel(S.spawnBossThreads[bossId])
                            S.spawnBossThreads[bossId] = nil
                        end
                    end
                end,
            })
        end
    end
end

-- ══════════════════════════════════════════
--   FARM TAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local FarmControl = Tabs.Farm:AddLeftGroupbox("Farm Control", "zap")
    FarmControl:AddToggle("AutoFarmEnabled", {
        Text = "Enable Auto Farm", Default = false,
        Callback = function(value)
            if value and (aas_anyRaidActive() or aas_anyDefenseActive()) then
                Toggles.AutoFarmEnabled:SetValue(false)
                Library:Notify("Blocked - Disable active Raid/Defense first.")
                return
            end
            S.farmEnabled = value
            if value then
                aas_equipLoadout(S.LoadoutAssignments.Farm or "Power")
                aas_enterPotionContext("Farm")
                if S.farmThread then task.cancel(S.farmThread) end
                S.farmThread = task.spawn(aas_farmLoop)
                Library:Notify("Auto Farm - Started!")
            else
                if S.farmThread then task.cancel(S.farmThread) S.farmThread = nil end
                S.currentWorldTracked = nil
            end
        end,
    })
    FarmControl:AddToggle("ClusterFarmEnabled", {
        Text = "Optimized Farm (HIGH RANGE)", Default = false,
        Callback = function(value)
            S.clusterFarmEnabled = value
            if value then Library:Notify("Optimized Farm - Enabled! Requires HIGH RANGE.") end
        end,
    })

    for i, worldIdx in ipairs(S.sortedWorldIndices) do
        local worldData = S.WorldList[worldIdx]
        local dropKey = "FarmWorld_"..worldIdx
        S.worldDropdowns[worldIdx] = dropKey
        local enemyNames = { "None" }
        for _, e in ipairs(worldData.enemies) do table.insert(enemyNames, e.Name) end

        local WorldGroup
        if i % 2 == 1 then WorldGroup = Tabs.Farm:AddRightGroupbox(aas_getWorldLabel(worldIdx), "map-pin")
        else WorldGroup = Tabs.Farm:AddLeftGroupbox(aas_getWorldLabel(worldIdx), "map-pin") end

        local capturedIdx = worldIdx
        WorldGroup:AddButton({
            Text = "Teleport to "..aas_getWorldLabel(worldIdx),
            Func = function() aas_teleportToWorld(capturedIdx) Library:Notify("Teleporting to "..aas_getWorldLabel(capturedIdx)) end,
        })
        if #enemyNames <= 1 then WorldGroup:AddLabel("No enemies found.", true)
        else
            WorldGroup:AddDropdown(dropKey, {
                Values = enemyNames, Multi = true, Default = nil,
                Text = "Select Mobs", Searchable = #enemyNames > 6, Callback = function(_) end,
            })
        end
    end
end

-- ══════════════════════════════════════════
--   RAID SUBTAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local RaidInfo = Tabs.Raid:AddLeftGroupbox("Auto Raid", "zap")
    RaidInfo:AddLabel("Active raid blocks farm and defense.", true)
    RaidInfo:AddToggle("RaidOptimizedFarm", {
        Text = "Optimized Raid Farm (HIGH RANGE)", Default = false,
        Callback = function(value)
            S.raidOptimizedFarm = value
            if value then Library:Notify("Raid Optimized Farm - Enabled! Requires HIGH RANGE.") end
        end,
    })
    RaidInfo:AddDivider()

    for _, raidKey in ipairs(S.sortedRaidKeys) do
        local raidData = S.RaidList[raidKey]
        local toggleKey = "AutoRaid_"..raidKey
        local waveOptKey = "RaidLeaveWave_"..raidKey
        S.raidEnabled[raidKey] = false S.RaidLoadouts[raidKey] = "Power"

        local worldLabel = aas_getWorldLabel(raidData.WorldId or 0)
        local RaidGroup = Tabs.Raid:AddLeftGroupbox(raidData.Name.." ("..worldLabel..")", "shield")

        local waveValues = { "0 (Never Leave)" }
        for w = 1, raidData.TotalWaves do table.insert(waveValues, tostring(w)) end
        RaidGroup:AddDropdown(waveOptKey, { Values=waveValues, Default=1, Text="Leave at Wave", Searchable=raidData.TotalWaves>20, Callback=function(_) end })
        RaidGroup:AddToggle(toggleKey, {
            Text = "Enable "..raidData.Name, Default = false,
            Callback = function(value)
                if value then
                    if S.farmEnabled or aas_anyDefenseActive() then
                        Toggles[toggleKey]:SetValue(false)
                        Library:Notify("Blocked - Disable Farm/Defense first.")
                        return
                    end
                    if S.activeRaidKey and S.activeRaidKey ~= raidKey then
                        Toggles[toggleKey]:SetValue(false)
                        Library:Notify("Blocked - Disable "..S.RaidList[S.activeRaidKey].Name.." first.")
                        return
                    end
                    aas_disableOtherRaids(raidKey)
                    S.raidEnabled[raidKey] = true S.activeRaidKey = raidKey
                    if S.raidThread then task.cancel(S.raidThread) S.raidThread = nil end
                    S.raidThread = task.spawn(function() aas_raidLoop(raidKey) end)
                    Library:Notify(raidData.Name.." - Auto Raid started!")
                else
                    S.raidEnabled[raidKey] = false
                    if S.activeRaidKey == raidKey then S.activeRaidKey = nil end
                    if S.raidThread then task.cancel(S.raidThread) S.raidThread = nil end
                end
            end,
        })
    end
end

-- ══════════════════════════════════════════
--   DEFENSE SUBTAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local DefInfo = Tabs.Defense:AddLeftGroupbox("Auto Defense", "shield")
    DefInfo:AddLabel("Active defense blocks farm and raids.", true)
    DefInfo:AddDivider()

    for _, defKey in ipairs(S.sortedDefenseKeys) do
        local defData = S.DefenseList[defKey]
        local toggleKey = "AutoDefense_"..defKey
        local waveOptKey = "DefLeaveWave_"..defKey
        S.defenseEnabled[defKey] = false S.DefenseLoadouts[defKey] = "Power"

        local worldLabel = aas_getWorldLabel(defData.WorldId or 0)
        local DefGroup = Tabs.Defense:AddLeftGroupbox(defData.Name.." ("..worldLabel..")", "zap")

        local waveValues = { "0 (Never Leave)" }
        for w = 1, defData.TotalWaves do table.insert(waveValues, tostring(w)) end
        DefGroup:AddDropdown(waveOptKey, { Values=waveValues, Default=1, Text="Leave at Wave", Searchable=defData.TotalWaves>20, Callback=function(_) end })
        DefGroup:AddToggle(toggleKey, {
            Text = "Enable "..defData.Name, Default = false,
            Callback = function(value)
                if value then
                    if S.farmEnabled or aas_anyRaidActive() then
                        Toggles[toggleKey]:SetValue(false)
                        Library:Notify("Blocked - Disable Farm/Raid first.")
                        return
                    end
                    if S.activeDefenseKey and S.activeDefenseKey ~= defKey then
                        Toggles[toggleKey]:SetValue(false)
                        Library:Notify("Blocked - Disable "..S.DefenseList[S.activeDefenseKey].Name.." first.")
                        return
                    end
                    aas_disableAllDefenses()
                    S.defenseEnabled[defKey] = true S.activeDefenseKey = defKey
                    if S.defenseThread then task.cancel(S.defenseThread) S.defenseThread = nil end
                    S.defenseThread = task.spawn(function() aas_defenseLoop(defKey) end)
                    Library:Notify(defData.Name.." - Auto Defense started!")
                else
                    S.defenseEnabled[defKey] = false
                    if S.activeDefenseKey == defKey then S.activeDefenseKey = nil end
                    if S.defenseThread then task.cancel(S.defenseThread) S.defenseThread = nil end
                end
            end,
        })
    end
end

-- ══════════════════════════════════════════
--   DUNGEON SUBTAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local DungeonInfo = Tabs.Dungeon:AddLeftGroupbox("Auto Dungeon", "door-open")
    DungeonInfo:AddLabel("Dungeon pauses Farm/Raid/Defense temporarily.", true)
    DungeonInfo:AddLabel("Priority vs Trial/Gate set in Priority subtab.", true)
    DungeonInfo:AddDivider()

    if #S.sortedDungeonKeys == 0 then
        DungeonInfo:AddLabel("No dungeon data found.", true)
    else
        for _, dungeonKey in ipairs(S.sortedDungeonKeys) do
            local dungeonData = S.DungeonList[dungeonKey]
            local toggleKey = "AutoDungeon_"..dungeonKey
            local roomOptKey = "DungeonLeaveRoom_"..dungeonKey
            S.dungeonEnabled[dungeonKey] = false

            local worldLabel = aas_getWorldLabel(dungeonData.WorldId or 0)
            local DungGroup = Tabs.Dungeon:AddLeftGroupbox(dungeonData.Name.." ("..worldLabel..")", "zap")

            local roomValues = { "0 (Never Leave)" }
            for r = 1, dungeonData.TotalRooms do table.insert(roomValues, tostring(r)) end
            DungGroup:AddDropdown(roomOptKey, { Values=roomValues, Default=1, Text="Leave at Room", Searchable=dungeonData.TotalRooms>20, Callback=function(_) end })
            DungGroup:AddToggle(toggleKey, {
                Text = "Enable "..dungeonData.Name, Default = false,
                Callback = function(value)
                    S.dungeonEnabled[dungeonKey] = value
                    if value then
                        if S.dungeonThreads[dungeonKey] then task.cancel(S.dungeonThreads[dungeonKey]) end
                        S.dungeonThreads[dungeonKey] = task.spawn(function() aas_dungeonLoop(dungeonKey) end)
                        Library:Notify(dungeonData.Name.." - Waiting for dungeon to spawn...")
                    else
                        if S.dungeonThreads[dungeonKey] then task.cancel(S.dungeonThreads[dungeonKey]) S.dungeonThreads[dungeonKey] = nil end
                        if S.activeDungeonKey == dungeonKey then
                            if aas_dungeonArenaExists(dungeonKey) then aas_leaveDungeon() end
                            S.activeDungeonKey = nil
                        end
                    end
                end,
            })
        end
    end
end

-- ══════════════════════════════════════════
--   RUSH SUBTAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local RushInfo = Tabs.Rush:AddLeftGroupbox("Auto Boss Rush", "skull")
    RushInfo:AddLabel("Auto farms Boss Rushes. Collects Sukuna Fingers.", true)
    RushInfo:AddDivider()

    if #S.sortedRushKeys == 0 then
        RushInfo:AddLabel("No Boss Rush data found.", true)
    else
        for _, rushKey in ipairs(S.sortedRushKeys) do
            local rushData = S.RushList[rushKey]
            S.rushEnabled[rushKey] = false
            local worldLabel = aas_getWorldLabel(rushData.WorldId or 11)
            local RushGroup = Tabs.Rush:AddLeftGroupbox(rushData.Name.." ("..worldLabel..")", "zap")

            RushGroup:AddDropdown("RushMode_"..rushKey, { Values=rushData.Modes, Default=1, Text="Select Mode", Callback=function(_) end })
            RushGroup:AddInput("RushLeaveWave_"..rushKey, {
                Default = "0", Numeric = true, Finished = true, ClearTextOnFocus = false,
                Text = "Leave at Wave", Placeholder = "0 - 9999",
                Callback = function(Value)
                    local n = tonumber(Value)
                    if not n then Options["RushLeaveWave_"..rushKey]:SetValue("0") return end
                    Options["RushLeaveWave_"..rushKey]:SetValue(tostring(math.clamp(math.floor(n), 0, 9999)))
                end,
            })
            RushGroup:AddToggle("AutoRush_"..rushKey, {
                Text = "Enable "..rushData.Name, Default = false,
                Callback = function(value)
                    S.rushEnabled[rushKey] = value
                    if value then
                        if S.farmEnabled then
                            Toggles["AutoRush_"..rushKey]:SetValue(false)
                            Library:Notify("Blocked - Disable Auto Farm first.")
                            return
                        end
                        if S.activeRushKey and S.activeRushKey ~= rushKey then
                            Toggles["AutoRush_"..rushKey]:SetValue(false)
                            Library:Notify("Blocked - Another Boss Rush is active.")
                            return
                        end
                        S.activeRushKey = rushKey
                        if S.rushThreads[rushKey] then task.cancel(S.rushThreads[rushKey]) end
                        S.rushThreads[rushKey] = task.spawn(function() aas_rushLoop(rushKey) end)
                        Library:Notify(rushData.Name.." - Auto Boss Rush started!")
                    else
                        if S.activeRushKey == rushKey then S.activeRushKey = nil end
                        if S.rushThreads[rushKey] then task.cancel(S.rushThreads[rushKey]) S.rushThreads[rushKey] = nil end
                    end
                end,
            })
        end
    end
end

-- ══════════════════════════════════════════
--   TRIAL SUBTAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local TrialInfo = Tabs.Trial:AddLeftGroupbox("Auto Trial", "clock")
    TrialInfo:AddLabel("Trials pause Farm/Raid/Defense temporarily.", true)
    TrialInfo:AddDivider()

    for _, trialKey in ipairs(S.sortedTrialKeys) do
        local trialData = S.TrialList[trialKey]
        local toggleKey = "AutoTrial_"..trialKey
        local roomOptKey = "TrialLeaveRoom_"..trialKey
        S.trialEnabled[trialKey] = false S.TrialLoadouts[trialKey] = "Power"

        local TrialGroup = Tabs.Trial:AddLeftGroupbox(trialData.Name, "zap")
        local roomValues = { "0 (Never Leave)" }
        for r = 1, trialData.TotalRooms do table.insert(roomValues, tostring(r)) end
        TrialGroup:AddDropdown(roomOptKey, { Values=roomValues, Default=1, Text="Leave at Room", Searchable=trialData.TotalRooms>20, Callback=function(_) end })
        TrialGroup:AddToggle(toggleKey, {
            Text = "Enable "..trialData.Name, Default = false,
            Callback = function(value)
                S.trialEnabled[trialKey] = value
                if value then
                    if S.trialThreads[trialKey] then task.cancel(S.trialThreads[trialKey]) end
                    S.trialThreads[trialKey] = task.spawn(function() aas_trialLoop(trialKey) end)
                    Library:Notify(trialData.Name.." - Waiting for trial to spawn...")
                else
                    if S.trialThreads[trialKey] then task.cancel(S.trialThreads[trialKey]) S.trialThreads[trialKey] = nil end
                end
            end,
        })
    end
end

-- ══════════════════════════════════════════
--   GATE SUBTAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local GateInfo = Tabs.Gate:AddLeftGroupbox("Auto Gate", "shield")
    GateInfo:AddLabel("Gate pauses Farm/Raid/Defense temporarily.", true)
    GateInfo:AddDivider()

    if S.GateData then
        GateInfo:AddDropdown("GateRankSelect", {
            Values = S.GateRanks, Multi = true, Default = nil,
            Text = "Select Gate Ranks to Farm", Callback = function(_) end,
        })
        for _, rank in ipairs(S.GateRanks) do
            local waveValues = { "0 (Never Leave)" }
            for w = 1, (S.GateData.TotalWaves or 50) do table.insert(waveValues, tostring(w)) end
            GateInfo:AddDropdown("GateLeaveWave_"..rank, {
                Values = waveValues, Default = 1, Text = "Leave at Wave (Rank "..rank..")",
                Searchable = (S.GateData.TotalWaves or 50) > 20, Callback = function(_) end,
            })
        end
        GateInfo:AddDivider()
        GateInfo:AddToggle("GateOptimizedFarm", {
            Text = "Optimized Middle Farm (HIGH RANGE)", Default = false,
            Callback = function(value)
                S.gateOptimizedFarm = value
                if value then Library:Notify("Gate Optimized Farm - Enabled! Requires HIGH RANGE.") end
            end,
        })
        GateInfo:AddDivider()
        GateInfo:AddToggle("AutoGateEnabled", {
            Text = "Enable Auto Gate", Default = false,
            Callback = function(value)
                S.gateEnabled = value
                if value then
                    if S.gateThread then task.cancel(S.gateThread) S.gateThread = nil end
                    S.gateThread = task.spawn(aas_gateLoop)
                    Library:Notify("Auto Gate - Monitoring World 5...")
                else
                    if S.gateThread then task.cancel(S.gateThread) S.gateThread = nil end
                    S.gateSuppressedByPriority = false
                end
            end,
        })
    else GateInfo:AddLabel("No gate data found.", true) end
end

-- ══════════════════════════════════════════
--   PRIORITY SUBTAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local PriorityInfo = Tabs.Priority:AddLeftGroupbox("Priority System", "triangle-alert")
    PriorityInfo:AddLabel("When Trial, Gate, OR Dungeon spawn simultaneously,\nthe highest priority one runs. Others are suppressed.", true)
    PriorityInfo:AddDivider()
    PriorityInfo:AddDropdown("PrioritySlot1", { Values={"Trial","Gate","Dungeon"}, Default=1, Text="Priority #1 (Highest)", Callback=function(val) S.priorityOrder[1]=val end })
    PriorityInfo:AddDropdown("PrioritySlot2", { Values={"Trial","Gate","Dungeon"}, Default=2, Text="Priority #2 (Medium)",  Callback=function(val) S.priorityOrder[2]=val end })
    PriorityInfo:AddDropdown("PrioritySlot3", { Values={"Trial","Gate","Dungeon"}, Default=3, Text="Priority #3 (Lowest)",  Callback=function(val) S.priorityOrder[3]=val end })
end

-- ══════════════════════════════════════════
--   LOADOUTS SUBTAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local LoadoutGroup = Tabs.Loadouts:AddLeftGroupbox("Activity Loadouts", "layers-2")
    LoadoutGroup:AddDropdown("LoadoutFarm", { Values={"Power","Yen","Damage","XP","Drop","Luck"}, Default=1, Text="Farm Loadout", Callback=function(v) S.LoadoutAssignments.Farm=v end })
    LoadoutGroup:AddDivider()
    LoadoutGroup:AddLabel("Per-Gate-Rank Loadouts:", true)
    for _, rank in ipairs(S.GateRanks) do
        LoadoutGroup:AddDropdown("LoadoutGateRank_"..rank, { Values={"Power","Yen","Damage","XP","Drop","Luck"}, Default=1, Text="Gate Rank "..rank.." Loadout", Callback=function(_) end })
    end
    LoadoutGroup:AddDivider()
    LoadoutGroup:AddLabel("Per-Raid Loadouts:", true)
    for _, raidKey in ipairs(S.sortedRaidKeys) do
        local raidData = S.RaidList[raidKey]
        S.RaidLoadouts[raidKey] = "Power"
        LoadoutGroup:AddDropdown("LoadoutRaid_"..raidKey, { Values={"Power","Yen","Damage","XP","Drop","Luck"}, Default=1, Text=raidData.Name.." Loadout", Callback=function(v) S.RaidLoadouts[raidKey]=v end })
    end

    local LoadoutRight = Tabs.Loadouts:AddRightGroupbox("More Loadouts", "layers-2")
    LoadoutRight:AddLabel("Per-Defense Loadouts:", true)
    for _, defKey in ipairs(S.sortedDefenseKeys) do
        local defData = S.DefenseList[defKey]
        S.DefenseLoadouts[defKey] = "Power"
        LoadoutRight:AddDropdown("LoadoutDef_"..defKey, { Values={"Power","Yen","Damage","XP","Drop","Luck"}, Default=1, Text=defData.Name.." Loadout", Callback=function(v) S.DefenseLoadouts[defKey]=v end })
    end
    LoadoutRight:AddDivider()
    LoadoutRight:AddLabel("Per-Trial Loadouts:", true)
    for _, trialKey in ipairs(S.sortedTrialKeys) do
        local trialData = S.TrialList[trialKey]
        S.TrialLoadouts[trialKey] = "Power"
        LoadoutRight:AddDropdown("LoadoutTrial_"..trialKey, { Values={"Power","Yen","Damage","XP","Drop","Luck"}, Default=1, Text=trialData.Name.." Loadout", Callback=function(v) S.TrialLoadouts[trialKey]=v end })
    end
    LoadoutRight:AddDivider()
    LoadoutRight:AddLabel("Per-Dungeon Loadouts:", true)
    for _, dungeonKey in ipairs(S.sortedDungeonKeys) do
        local dungeonData = S.DungeonList[dungeonKey]
        S.DungeonLoadouts[dungeonKey] = "Power"
        LoadoutRight:AddDropdown("LoadoutDungeon_"..dungeonKey, { Values={"Power","Yen","Damage","XP","Drop","Luck"}, Default=1, Text=dungeonData.Name.." Loadout", Callback=function(v) S.DungeonLoadouts[dungeonKey]=v end })
    end
    LoadoutRight:AddDivider()
    LoadoutRight:AddLabel("Per-Boss Rush Loadouts:", true)
    for _, rushKey in ipairs(S.sortedRushKeys) do
        local rushData = S.RushList[rushKey]
        S.RushLoadouts[rushKey] = "Power"
        LoadoutRight:AddDropdown("LoadoutRush_"..rushKey, { Values={"Power","Yen","Damage","XP","Drop","Luck"}, Default=1, Text=rushData.Name.." Loadout", Callback=function(v) S.RushLoadouts[rushKey]=v end })
    end
end

-- ══════════════════════════════════════════
--   POTIONS SUBTAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local aas_allPotionIds = {}
    for _, pid in ipairs(aas_sortedPotionKeys) do table.insert(aas_allPotionIds, pid) end

    local PotionInfo = Tabs.Potions:AddLeftGroupbox("Potion Context", "flask-conical")
    PotionInfo:AddLabel("Automatically pauses/unpauses potions based on current activity.", true)
    PotionInfo:AddDivider()
    local potionStatusObj = PotionInfo:AddLabel("Context: Idle", false, "PotionStatusLabel")
    S.potionStatusLabelRef = Options["PotionStatusLabel"] or potionStatusObj
    PotionInfo:AddDivider()
    PotionInfo:AddToggle("PotionContextEnabled", {
        Text = "Enable Potion Context", Default = false,
        Callback = function(value)
            S.potionContextEnabled = value
            Library:Notify("Potion Context - "..(value and "Enabled!" or "Disabled"))
        end,
    })
    PotionInfo:AddDivider()
    if #aas_allPotionIds > 0 then
        PotionInfo:AddDropdown("PotionAutoUseSelect", {
            Values = aas_allPotionIds, Multi = true, Default = nil,
            Text = "Select Potions to Auto Use", Searchable = #aas_allPotionIds > 8, Callback = function(_) end,
        })
    end
    PotionInfo:AddToggle("PotionAutoUseEnabled", {
        Text = "Auto Use Potion (every 30s)", Default = false,
        Callback = function(value)
            S.potionAutoUseEnabled = value
            if value then
                if S.potionAutoUseThread then task.cancel(S.potionAutoUseThread) end
                S.potionAutoUseThread = task.spawn(aas_autoUsePotionLoop)
                Library:Notify("Auto Use Potion - Started!")
            else
                if S.potionAutoUseThread then task.cancel(S.potionAutoUseThread) S.potionAutoUseThread = nil end
            end
        end,
    })

    local PotionCtxGroup = Tabs.Potions:AddRightGroupbox("Per-Activity Potion Selection", "settings")
    PotionCtxGroup:AddLabel("Select which potions stay ACTIVE per activity.\nUnselected potions will be paused.", true)
    PotionCtxGroup:AddDivider()

    function aas_buildPotionContextDropdown(group, contextKey, label)
        if #aas_allPotionIds == 0 then return end
        group:AddDropdown("PotionCtx_"..contextKey, {
            Values = aas_allPotionIds, Multi = true, Default = nil,
            Text = label, Searchable = #aas_allPotionIds > 8, Callback = function(_) end
        })
    end

    aas_buildPotionContextDropdown(PotionCtxGroup, "Farm", "Farm Potions")
    PotionCtxGroup:AddDivider()
    for _, rank in ipairs(S.GateRanks) do aas_buildPotionContextDropdown(PotionCtxGroup, "Gate_"..rank, "Gate Rank "..rank.." Potions") end
    PotionCtxGroup:AddDivider()
    for _, raidKey in ipairs(S.sortedRaidKeys) do aas_buildPotionContextDropdown(PotionCtxGroup, "Raid_"..raidKey, S.RaidList[raidKey].Name.." Potions") end
    PotionCtxGroup:AddDivider()
    for _, defKey in ipairs(S.sortedDefenseKeys) do aas_buildPotionContextDropdown(PotionCtxGroup, "Defense_"..defKey, S.DefenseList[defKey].Name.." Potions") end
    PotionCtxGroup:AddDivider()
    for _, trialKey in ipairs(S.sortedTrialKeys) do aas_buildPotionContextDropdown(PotionCtxGroup, "Trial_"..trialKey, S.TrialList[trialKey].Name.." Potions") end
    PotionCtxGroup:AddDivider()
    for _, dungeonKey in ipairs(S.sortedDungeonKeys) do aas_buildPotionContextDropdown(PotionCtxGroup, "Dungeon_"..dungeonKey, S.DungeonList[dungeonKey].Name.." Potions") end
    PotionCtxGroup:AddDivider()
    for _, rushKey in ipairs(S.sortedRushKeys) do aas_buildPotionContextDropdown(PotionCtxGroup, "Rush_"..rushKey, S.RushList[rushKey].Name.." Potions") end
end

-- ══════════════════════════════════════════
--   GACHA TAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    task.spawn(function() task.wait(2) pcall(aas_syncAllPlayerData) end)

    local GachaInfo = Tabs.Gacha:AddLeftGroupbox("Auto Gacha", "sparkles")
    GachaInfo:AddLabel("Multiple gachas can run simultaneously. Stops at Divine.", true)
    GachaInfo:AddDivider()

    for _, gachaKey in ipairs(S.sortedGachaKeys) do
        local gachaData = S.GachaList[gachaKey]
        local toggleKey = "AutoGacha_"..gachaKey
        S.gachaEnabled[gachaKey] = false
        local worldLabel = aas_getWorldLabel(gachaData.WorldId)
        local GachaGroup = Tabs.Gacha:AddLeftGroupbox(gachaData.Name.." ("..worldLabel..")", "star")
        local rarityLabelObj = GachaGroup:AddLabel("Current: Unknown", false, "GachaRarityLabel_"..gachaKey)
        S.gachaLabelRefs[gachaKey] = Options["GachaRarityLabel_"..gachaKey] or rarityLabelObj
        GachaGroup:AddToggle(toggleKey, {
            Text = "Enable Auto Roll", Default = false,
            Callback = function(value)
                S.gachaEnabled[gachaKey] = value
                if value then
                    if S.gachaThreads[gachaKey] then task.cancel(S.gachaThreads[gachaKey]) end
                    S.gachaThreads[gachaKey] = task.spawn(function() aas_gachaLoop(gachaKey) end)
                    Library:Notify(gachaData.Name.." - Auto Gacha started!")
                else
                    if S.gachaThreads[gachaKey] then task.cancel(S.gachaThreads[gachaKey]) S.gachaThreads[gachaKey] = nil end
                end
            end,
        })
    end

    local SwordGroup = Tabs.Gacha:AddRightGroupbox("Auto Swords", "sword")
    SwordGroup:AddToggle("AutoFuseAll", {
        Text = "Auto Fuse All Swords", Default = false,
        Callback = function(value)
            S.autoFuseAllEnabled = value
            if value then if S.fuseAllThread then task.cancel(S.fuseAllThread) end S.fuseAllThread = task.spawn(aas_fuseAllLoop) Library:Notify("Auto Fuse All - Enabled!")
            else if S.fuseAllThread then task.cancel(S.fuseAllThread) S.fuseAllThread = nil end end
        end,
    })
    SwordGroup:AddToggle("AutoSword_World0", {
        Text = "Auto Roll Sword (World0)", Default = false,
        Callback = function(value)
            S.SwordWorld0Enabled = value
            if value then if S.SwordWorld0Thread then task.cancel(S.SwordWorld0Thread) end S.SwordWorld0Thread = task.spawn(aas_swordWorld0Loop)
            else if S.SwordWorld0Thread then task.cancel(S.SwordWorld0Thread) S.SwordWorld0Thread = nil end end
        end,
    })
    SwordGroup:AddToggle("AutoSword_World8", {
        Text = "Auto Roll Summer Sword (World8)", Default = false,
        Callback = function(value)
            S.SwordWorld8Enabled = value
            if value then if S.SwordWorld8Thread then task.cancel(S.SwordWorld8Thread) end S.SwordWorld8Thread = task.spawn(aas_swordWorld8Loop)
            else if S.SwordWorld8Thread then task.cancel(S.SwordWorld8Thread) S.SwordWorld8Thread = nil end end
        end,
    })

    local PassiveGroup = Tabs.Gacha:AddRightGroupbox("Auto Player Passive", "shield")
    local passiveLabelObj = PassiveGroup:AddLabel("Active: None", false, "PassiveActiveLabel")
    S.passiveLabelRef = Options["PassiveActiveLabel"] or passiveLabelObj
    PassiveGroup:AddToggle("AutoPassiveEnabled", {
        Text = "Enable Auto Player Passive Roll", Default = false,
        Callback = function(value)
            S.passiveAutoEnabled = value
            if value then if S.passiveThread then task.cancel(S.passiveThread) end S.passiveThread = task.spawn(aas_passiveLoop)
            else if S.passiveThread then task.cancel(S.passiveThread) S.passiveThread = nil end end
        end,
    })

    local TitanGroup = Tabs.Gacha:AddRightGroupbox("Auto Titan", "zap")
    local titanLabelObj = TitanGroup:AddLabel("Active Titan: None", false, "TitanActiveLabel")
    S.titanLabelRef = Options["TitanActiveLabel"] or titanLabelObj
    TitanGroup:AddToggle("AutoTitanEnabled", {
        Text = "Enable Auto Titan Roll", Default = false,
        Callback = function(value)
            S.titanAutoEnabled = value
            if value then if S.titanThread then task.cancel(S.titanThread) end S.titanThread = task.spawn(aas_titanLoop)
            else if S.titanThread then task.cancel(S.titanThread) S.titanThread = nil end end
        end,
    })

    local SP1Group = Tabs.Gacha:AddRightGroupbox("Sword Passive (Sword 1)", "wind")
    local sp1InfoObj = SP1Group:AddLabel("Sword 1: Loading...", false, "SwordPassive1InfoLabel")
    S.sword1InfoLabelRef = Options["SwordPassive1InfoLabel"] or sp1InfoObj
    local sp1BreathObj = SP1Group:AddLabel("Breathing: None", false, "SwordPassive1BreathLabel")
    S.sword1BreathingLabelRef = Options["SwordPassive1BreathLabel"] or sp1BreathObj
    SP1Group:AddDropdown("SwordPassive1StopRarities", { Values=S.SwordPassiveRarityOrder, Multi=true, Default=nil, Text="Stop at Rarity", Callback=function(_) end })
    SP1Group:AddToggle("AutoSwordPassive1Enabled", {
        Text = "Enable Auto Roll (Sword 1)", Default = false,
        Callback = function(value)
            S.swordPassive1Enabled = value
            if value then if S.swordPassive1Thread then task.cancel(S.swordPassive1Thread) end S.swordPassive1Thread = task.spawn(aas_swordPassive1Loop)
            else if S.swordPassive1Thread then task.cancel(S.swordPassive1Thread) S.swordPassive1Thread = nil end end
        end,
    })

    local SP2Group = Tabs.Gacha:AddRightGroupbox("Sword Passive (Sword 2)", "wind")
    local sp2InfoObj = SP2Group:AddLabel("Sword 2: Loading...", false, "SwordPassive2InfoLabel")
    S.sword2InfoLabelRef = Options["SwordPassive2InfoLabel"] or sp2InfoObj
    local sp2BreathObj = SP2Group:AddLabel("Breathing: None", false, "SwordPassive2BreathLabel")
    S.sword2BreathingLabelRef = Options["SwordPassive2BreathLabel"] or sp2BreathObj
    SP2Group:AddDropdown("SwordPassive2StopRarities", { Values=S.SwordPassiveRarityOrder, Multi=true, Default=nil, Text="Stop at Rarity", Callback=function(_) end })
    SP2Group:AddToggle("AutoSwordPassive2Enabled", {
        Text = "Enable Auto Roll (Sword 2)", Default = false,
        Callback = function(value)
            S.swordPassive2Enabled = value
            if value then if S.swordPassive2Thread then task.cancel(S.swordPassive2Thread) end S.swordPassive2Thread = task.spawn(aas_swordPassive2Loop)
            else if S.swordPassive2Thread then task.cancel(S.swordPassive2Thread) S.swordPassive2Thread = nil end end
        end,
    })

    local G1Group = Tabs.Gacha:AddRightGroupbox("Auto Grimoire (Slot 1)", "book-open")
    local g1LabelObj = G1Group:AddLabel("Slot 1: None", false, "Grimoire1Label")
    S.grimoire1LabelRef = Options["Grimoire1Label"] or g1LabelObj
    G1Group:AddToggle("AutoGrimoire1Enabled", {
        Text = "Enable Auto Roll (Slot 1)", Default = false,
        Callback = function(value)
            S.grimoire1Enabled = value
            if value then if S.grimoire1Thread then task.cancel(S.grimoire1Thread) end S.grimoire1Thread = task.spawn(aas_grimoire1Loop)
            else if S.grimoire1Thread then task.cancel(S.grimoire1Thread) S.grimoire1Thread = nil end end
        end,
    })

    local G2Group = Tabs.Gacha:AddRightGroupbox("Auto Grimoire (Slot 2)", "book-open")
    local g2LabelObj = G2Group:AddLabel("Slot 2: None", false, "Grimoire2Label")
    S.grimoire2LabelRef = Options["Grimoire2Label"] or g2LabelObj
    G2Group:AddToggle("AutoGrimoire2Enabled", {
        Text = "Enable Auto Roll (Slot 2)", Default = false,
        Callback = function(value)
            S.grimoire2Enabled = value
            if value then if S.grimoire2Thread then task.cancel(S.grimoire2Thread) end S.grimoire2Thread = task.spawn(aas_grimoire2Loop)
            else if S.grimoire2Thread then task.cancel(S.grimoire2Thread) S.grimoire2Thread = nil end end
        end,
    })

    local PPGroup = Tabs.Gacha:AddRightGroupbox("Auto Pet Passive", "paw-print")
    PPGroup:AddLabel("Refresh to scan equipped pets. Stops at selected rarity.", true)
    local ppLabelObj = PPGroup:AddLabel("Current: None", false, "PetPassiveActiveLabel")
    S.petPassiveLabelRef = Options["PetPassiveActiveLabel"] or ppLabelObj
    PPGroup:AddDropdown("PetPassivePetSelect", { Values={"(Click Refresh)"}, Default=1, Text="Select Equipped Pet",
        Callback = function(val)
            local uuid = S.petPassiveDisplayToId and S.petPassiveDisplayToId[val]
            if uuid then S.petPassiveSelectedPetId = uuid pcall(aas_syncPetPassiveData) end
        end,
    })
    PPGroup:AddButton({
        Text = "Refresh Pets",
        Func = function()
            local success, equipped = pcall(aas_scanEquippedPets)
            if not success then Library:Notify("Pet Passive Error - Failed to scan pets.") return end
            local count = 0 for _ in pairs(equipped) do count = count + 1 end
            if count == 0 then Library:Notify("Pet Passive - No equipped pets found.") return end
            local values = {} S.petPassiveDisplayToId = {}
            local nameCounts = {}
            for uuid, info in pairs(equipped) do
                local name = info.Name
                nameCounts[name] = (nameCounts[name] or 0) + 1
                local displayName = nameCounts[name] > 1 and (name.." #"..nameCounts[name]) or name
                if info.Passive then displayName = displayName.." ["..info.Passive.Name.." - "..info.Passive.Rarity.."]"
                else displayName = displayName.." [No Passive]" end
                table.insert(values, displayName) S.petPassiveDisplayToId[displayName] = uuid
            end
            table.sort(values)
            if Options["PetPassivePetSelect"] then
                Options["PetPassivePetSelect"]:SetValues(values)
                if #values > 0 then
                    Options["PetPassivePetSelect"]:SetValue(values[1])
                    S.petPassiveSelectedPetId = S.petPassiveDisplayToId[values[1]]
                    pcall(aas_syncPetPassiveData)
                end
            end
            Library:Notify("Pet Passive - Found "..tostring(count).." equipped pet(s)!")
        end,
    })
    PPGroup:AddDropdown("PetPassiveStopRarities", { Values=S.PetPassiveRarityOrder, Multi=true, Default=nil, Text="Stop at Rarity", Callback=function(_) end })
    PPGroup:AddToggle("AutoPetPassiveEnabled", {
        Text = "Enable Auto Pet Passive Roll", Default = false,
        Callback = function(value)
            S.petPassiveAutoEnabled = value
            if value then
                if not S.petPassiveSelectedPetId or S.petPassiveSelectedPetId == "" then
                    Toggles["AutoPetPassiveEnabled"]:SetValue(false)
                    Library:Notify("Pet Passive - Select an equipped pet first!")
                    return
                end
                if S.petPassiveThread then task.cancel(S.petPassiveThread) end
                S.petPassiveThread = task.spawn(aas_petPassiveLoop)
                Library:Notify("Auto Pet Passive - Started!")
            else
                if S.petPassiveThread then task.cancel(S.petPassiveThread) S.petPassiveThread = nil end
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   PROGRESSION TAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local ProgInfo = Tabs.Progression:AddLeftGroupbox("Auto Progressions", "trending-up")
    ProgInfo:AddLabel("Each progression runs simultaneously. Stops at max level.", true)
    ProgInfo:AddDivider()

    for _, progKey in ipairs(S.sortedProgressionKeys) do
        local progData = S.ProgressionList[progKey]
        local toggleKey = "AutoProgression_"..progKey
        S.progressionEnabled[progKey] = false
        local worldLabel = aas_getWorldLabel(progData.WorldId or 0)
        local ProgGroup = Tabs.Progression:AddLeftGroupbox(worldLabel, "zap")
        local levelLabelObj = ProgGroup:AddLabel("Level: 0 / "..tostring(progData.MaxLevel), false, "ProgLevel_"..progKey)
        S.progressionLevelLabelRefs[progKey] = Options["ProgLevel_"..progKey] or levelLabelObj
        ProgGroup:AddToggle(toggleKey, {
            Text = "Enable Auto Upgrade", Default = false,
            Callback = function(value)
                S.progressionEnabled[progKey] = value
                if value then
                    if S.progressionThreads[progKey] then task.cancel(S.progressionThreads[progKey]) end
                    S.progressionThreads[progKey] = task.spawn(function() aas_progressionLoop(progKey) end)
                    Library:Notify(progData.Name.." - Auto Progression started!")
                else
                    if S.progressionThreads[progKey] then task.cancel(S.progressionThreads[progKey]) S.progressionThreads[progKey] = nil end
                end
            end,
        })
    end

    local UpgradeGroup = Tabs.Progression:AddRightGroupbox("Auto Upgrades", "zap")
    UpgradeGroup:AddLabel("Auto upgrade stats per system.", true)
    UpgradeGroup:AddDivider()

    for _, sysKey in ipairs(S.sortedUpgradeSystemKeys) do
        local sysData = S.UpgradeSystemList[sysKey]
        local worldLabel = aas_getWorldLabel(sysData.WorldId or 0)
        local statDropKey = "UpgradeStat_"..sysKey
        local upgradeTogKey = "AutoUpgrade_"..sysKey
        local UGroup = Tabs.Progression:AddRightGroupbox(worldLabel.." Upgrades", "arrow-up")
        local currentStatForSys = { value = "Power" }
        UGroup:AddDropdown(statDropKey, { Values=S.UpgradeStatKeys, Default=1, Text="Stat to Upgrade", Callback=function(val) currentStatForSys.value=val end })
        UGroup:AddToggle(upgradeTogKey, {
            Text = "Enable Auto Upgrade", Default = false,
            Callback = function(value)
                if value then
                    local thread = task.spawn(function()
                        while Toggles[upgradeTogKey] and Toggles[upgradeTogKey].Value do
                            pcall(function() aas_upgradesRequestRemote:Fire(sysKey, currentStatForSys.value) end) task.wait(1.0)
                        end
                    end)
                    if S.rangeUpgradeThreads["upgrade_"..sysKey] then task.cancel(S.rangeUpgradeThreads["upgrade_"..sysKey]) end
                    S.rangeUpgradeThreads["upgrade_"..sysKey] = thread
                    Library:Notify(sysData.Name.." - Auto Upgrade started!")
                else
                    local t = S.rangeUpgradeThreads["upgrade_"..sysKey]
                    if t then task.cancel(t) S.rangeUpgradeThreads["upgrade_"..sysKey] = nil end
                end
            end,
        })
        UGroup:AddDivider()
        UGroup:AddToggle("AutoRangeUpgrade_"..sysKey, {
            Text = "Enable Auto Range Upgrade", Default = false,
            Callback = function(value)
                S.rangeUpgradeEnabled[sysKey] = value
                if value then
                    if S.rangeUpgradeThreads[sysKey] then task.cancel(S.rangeUpgradeThreads[sysKey]) end
                    S.rangeUpgradeThreads[sysKey] = task.spawn(function() aas_rangeUpgradeLoop(sysKey) end)
                    Library:Notify(sysData.Name.." Range - Started!")
                else
                    if S.rangeUpgradeThreads[sysKey] then task.cancel(S.rangeUpgradeThreads[sysKey]) S.rangeUpgradeThreads[sysKey] = nil end
                end
            end,
        })
    end

    local allSystems2 = aas_Upgrades2Config and aas_Upgrades2Config:GetAllSystems() or {}
    local sortedSysKeys2 = {}
    for sysKey in pairs(allSystems2) do table.insert(sortedSysKeys2, sysKey) end
    table.sort(sortedSysKeys2, function(a,b) return (allSystems2[a] and allSystems2[a].WorldId or 0) < (allSystems2[b] and allSystems2[b].WorldId or 0) end)

    for _, sysKey in ipairs(sortedSysKeys2) do
        local sysData = allSystems2[sysKey]
        local sysName = sysData and sysData.Name or sysKey
        local worldLabel = aas_getWorldLabel(sysData and sysData.WorldId or 0)
        local upgradeList = sysData and sysData.UpgradeList or {}
        if #upgradeList == 0 then continue end

        local upgradeDisplayNames, upgradeDisplayToKey = {}, {}
        for _, upg in ipairs(upgradeList) do
            local display = upg.DisplayName or upg.Key
            table.insert(upgradeDisplayNames, display)
            upgradeDisplayToKey[display] = upg.Key
        end

        local U2Group = Tabs.Progression:AddRightGroupbox(sysName.." ("..worldLabel..")", "briefcase")
        S.upgrades2SelectedStats[sysKey] = {}
        U2Group:AddDropdown("Upgrades2StatSelect_"..sysKey, {
            Values = upgradeDisplayNames, Multi = true, Default = nil,
            Text = "Select Stats to Upgrade", Searchable = #upgradeDisplayNames > 6,
            Callback = function(val)
                S.upgrades2SelectedStats[sysKey] = {}
                for display, state in pairs(val or {}) do
                    if state then local key = upgradeDisplayToKey[display] if key then S.upgrades2SelectedStats[sysKey][key] = true end end
                end
            end,
        })
        S.upgrades2Enabled2[sysKey] = false
        U2Group:AddToggle("AutoUpgrades2_"..sysKey, {
            Text = "Enable Auto Upgrade ("..sysName..")", Default = false,
            Callback = function(value)
                S.upgrades2Enabled2[sysKey] = value
                if value then
                    if S.upgrades2Threads2[sysKey] then task.cancel(S.upgrades2Threads2[sysKey]) end
                    local anySelected = false
                    for _ in pairs(S.upgrades2SelectedStats[sysKey] or {}) do anySelected = true break end
                    if not anySelected then
                        Toggles["AutoUpgrades2_"..sysKey]:SetValue(false) S.upgrades2Enabled2[sysKey] = false
                        Library:Notify(sysName.." - Select at least one stat first!") return
                    end
                    S.upgrades2Threads2[sysKey] = task.spawn(function() aas_upgrades2LoopV2(sysKey) end)
                    Library:Notify(sysName.." - Auto Upgrade started!")
                else
                    if S.upgrades2Threads2[sysKey] then task.cancel(S.upgrades2Threads2[sysKey]) S.upgrades2Threads2[sysKey] = nil end
                end
            end,
        })
        U2Group:AddDivider()
        U2Group:AddToggle("AutoRangeUpgrade2_"..sysKey, {
            Text = "Enable Auto Range Upgrade", Default = false,
            Callback = function(value)
                S.rangeUpgradeEnabled[sysKey] = value
                if value then
                    if S.rangeUpgradeThreads[sysKey] then task.cancel(S.rangeUpgradeThreads[sysKey]) end
                    S.rangeUpgradeThreads[sysKey] = task.spawn(function() aas_rangeUpgradeLoop(sysKey) end)
                    Library:Notify(sysName.." Range - Started!")
                else
                    if S.rangeUpgradeThreads[sysKey] then task.cancel(S.rangeUpgradeThreads[sysKey]) S.rangeUpgradeThreads[sysKey] = nil end
                end
            end,
        })
    end

    local EvoGroup = Tabs.Progression:AddRightGroupbox("Auto Evolution", "zap")
    if #S.sortedEvolutionKeys == 0 then EvoGroup:AddLabel("No evolution data found.", true)
    else
        for _, evKey in ipairs(S.sortedEvolutionKeys) do
            local evData = S.EvolutionList[evKey]
            EvoGroup:AddLabel("• "..evData.Name.." | "..evData.Stat.." | Max: "..tostring(evData.MaxLevel), true)
        end
        EvoGroup:AddDivider()
        EvoGroup:AddToggle("AutoEvolutionEnabled", {
            Text = "Enable Auto Evolution", Default = false,
            Callback = function(value)
                S.autoEvolutionEnabled = value
                if value then
                    if S.autoEvolutionThread then task.cancel(S.autoEvolutionThread) end
                    S.autoEvolutionThread = task.spawn(aas_autoEvolutionLoop)
                    Library:Notify("Auto Evolution - Started!")
                else
                    if S.autoEvolutionThread then task.cancel(S.autoEvolutionThread) S.autoEvolutionThread = nil end
                end
            end,
        })
    end

    local STGroup = Tabs.Progression:AddRightGroupbox("Auto Skill Tree", "git-branch")
    if #S.sortedSkillTreeKeys == 0 then STGroup:AddLabel("No skill tree data found.", true)
    else
        STGroup:AddLabel("Purchases all upgrades in order.", true) STGroup:AddDivider()
        for _, treeName in ipairs(S.sortedSkillTreeKeys) do
            local treeData = S.SkillTreeList[treeName]
            local toggleKey = "AutoSkillTree_"..treeName
            S.skillTreeEnabled[treeName] = false
            STGroup:AddToggle(toggleKey, {
                Text = treeName.." ("..aas_getWorldLabel(treeData.WorldId or 0)..") — "..tostring(treeData.UpgradeCount).." nodes",
                Default = false,
                Callback = function(value)
                    S.skillTreeEnabled[treeName] = value
                    if value then
                        if S.skillTreeThreads[treeName] then task.cancel(S.skillTreeThreads[treeName]) end
                        S.skillTreeThreads[treeName] = task.spawn(function() aas_skillTreeLoop(treeName) end)
                        Library:Notify("Skill Tree: "..treeName.." - Started!")
                    else
                        if S.skillTreeThreads[treeName] then task.cancel(S.skillTreeThreads[treeName]) S.skillTreeThreads[treeName] = nil end
                    end
                end,
            })
        end
    end

    local ConstGroup = Tabs.Progression:AddRightGroupbox("Auto Constellation", "star")
    if #S.sortedConstellationKeys == 0 then ConstGroup:AddLabel("No constellation data found.", true)
    else
        ConstGroup:AddLabel("Purchases all nodes in order.", true) ConstGroup:AddDivider()
        for _, constId in ipairs(S.sortedConstellationKeys) do
            local constData = S.ConstellationList[constId]
            local toggleKey = "AutoConstellation_"..constId
            S.constellationEnabled[constId] = false
            ConstGroup:AddToggle(toggleKey, {
                Text = constData.Name.." — "..tostring(constData.NodeCount).." nodes",
                Default = false,
                Callback = function(value)
                    S.constellationEnabled[constId] = value
                    if value then
                        if S.constellationThreads[constId] then task.cancel(S.constellationThreads[constId]) end
                        S.constellationThreads[constId] = task.spawn(function() aas_constellationLoop(constId) end)
                        Library:Notify("Constellation: "..constData.Name.." - Started!")
                    else
                        if S.constellationThreads[constId] then task.cancel(S.constellationThreads[constId]) S.constellationThreads[constId] = nil end
                    end
                end,
            })
        end
    end
end

-- ══════════════════════════════════════════
--   STAR TAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local StarInfo = Tabs.Star:AddLeftGroupbox("Auto Star", "star")
    StarInfo:AddLabel("Automatically opens eggs from the selected world.", true)
    StarInfo:AddDivider()

    local starWorldDisplayNames, starWorldDisplayToKey = {}, {}
    for _, key in ipairs(S.sortedStarWorldKeys) do
        local worldData = S.StarWorldList[key]
        local displayName = aas_getWorldLabel(worldData.WorldId)
        table.insert(starWorldDisplayNames, displayName)
        starWorldDisplayToKey[displayName] = key
    end
    if #S.sortedStarWorldKeys > 0 then S.starEggKey = S.sortedStarWorldKeys[1] end

    if #starWorldDisplayNames > 0 then
        StarInfo:AddDropdown("StarWorldSelect", {
            Values = starWorldDisplayNames, Default = 1, Text = "Select World (Egg)",
            Searchable = #starWorldDisplayNames > 5,
            Callback = function(val)
                local key = starWorldDisplayToKey[val]
                if key then S.starEggKey = key end
            end,
        })
    end
    StarInfo:AddToggle("AutoStarEnabled", {
        Text = "Enable Auto Star Roll", Default = false,
        Callback = function(value)
            S.starEnabled = value
            if value then
                if not S.starEggKey then Toggles["AutoStarEnabled"]:SetValue(false) Library:Notify("Auto Star - No world selected!") return end
                if S.starThread then task.cancel(S.starThread) S.starThread = nil end
                S.starThread = task.spawn(aas_starLoop)
                Library:Notify("Auto Star - Started rolling "..(S.starEggKey or "?"))
            else
                if S.starThread then task.cancel(S.starThread) S.starThread = nil end
            end
        end,
    })

    local CraftInfo = Tabs.Star:AddRightGroupbox("Auto Craft", "hammer")
    CraftInfo:AddLabel("Automatically crafts pets. Enable Shiny for shiny variants.", true)
    CraftInfo:AddDivider()

    for _, craftKey in ipairs(S.sortedCraftKeys) do
        local craftData = S.CraftList[craftKey]
        local toggleKey = "AutoCraft_"..craftKey
        local shinyKey = "AutoCraftShiny_"..craftKey
        S.craftEnabled[craftKey] = false S.craftShiny[craftKey] = false
        local worldLabel = aas_getWorldLabel(craftData.WorldId or 0)
        local CraftGroup = Tabs.Star:AddRightGroupbox(craftKey.." ("..worldLabel..")", "zap")
        CraftGroup:AddToggle(shinyKey, { Text="Craft Shiny", Default=false, Callback=function(value) S.craftShiny[craftKey]=value end })
        CraftGroup:AddToggle(toggleKey, {
            Text = "Enable Auto Craft", Default = false,
            Callback = function(value)
                S.craftEnabled[craftKey] = value
                if value then
                    if S.craftThreads[craftKey] then task.cancel(S.craftThreads[craftKey]) end
                    S.craftThreads[craftKey] = task.spawn(function() aas_craftLoop(craftKey) end)
                    Library:Notify(craftKey.." - Auto Craft started!")
                else
                    if S.craftThreads[craftKey] then task.cancel(S.craftThreads[craftKey]) S.craftThreads[craftKey] = nil end
                end
            end,
        })
    end
end

-- ══════════════════════════════════════════
--   QUESTS TAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local GQListGroup = Tabs.Quests:AddLeftGroupbox("Quest Selection", "list")
    GQListGroup:AddLabel("Select quests to auto-farm. Open Global Quest window to see progress.", true)
    GQListGroup:AddDivider()

    local aas_gqAllValues = {}
    do
        local allQuests = {}
        pcall(function() allQuests = aas_GlobalQuestConfig:GetAll() or {} end)
        for i, def in ipairs(allQuests) do
            local display, farmable = "", false
            pcall(function() display = aas_gqBuildDisplay(i) end)
            pcall(function() farmable = aas_gqIsFarmable(i) end)
            if display ~= "" and farmable then table.insert(aas_gqAllValues, display) end
        end
    end

    if #aas_gqAllValues > 0 then
        GQListGroup:AddDropdown("GQSelectQuests", {
            Values = aas_gqAllValues, Multi = true, Default = nil,
            Text = "Select Quests to Farm", Searchable = true, Callback = function(_) end,
        })
    else GQListGroup:AddLabel("No farmable quests found.", true) end

    local GQControlGroup = Tabs.Quests:AddRightGroupbox("Controls", "settings")
    GQControlGroup:AddToggle("GQAutoClaimAll", {
        Text = "Auto Claim Completed Quests", Default = false,
        Callback = function(value)
            S.globalQuestAutoClaimEnabled = value
            if value then
                if S.globalQuestClaimThread then task.cancel(S.globalQuestClaimThread) end
                S.globalQuestClaimThread = task.spawn(function()
                    while S.globalQuestAutoClaimEnabled do
                        pcall(function() aas_globalQuestClaimAllRemote:Fire() end) task.wait(30)
                    end
                end)
                Library:Notify("GQ Auto Claim - Enabled!")
            else
                if S.globalQuestClaimThread then task.cancel(S.globalQuestClaimThread) S.globalQuestClaimThread = nil end
            end
        end,
    })
    GQControlGroup:AddDivider()
    GQControlGroup:AddToggle("GQFarmerEnabled", {
        Text = "Enable Global Quest Farmer", Default = false,
        Callback = function(value)
            S.globalQuestEnabled = value
            if value then
                if S.globalQuestThread then task.cancel(S.globalQuestThread) end
                S.globalQuestThread = task.spawn(aas_globalQuestLoop)
                Library:Notify("GQ Farmer - Started!")
            else
                if S.globalQuestThread then task.cancel(S.globalQuestThread) S.globalQuestThread = nil end
                S.globalQuestCurrentTarget = nil S.globalQuestCurrentAction = nil S.globalQuestSuppressedByPriority = false
            end
        end,
    })

    local GQRelicGroup = Tabs.Quests:AddRightGroupbox("Auto Relic", "trending-up")
    GQRelicGroup:AddLabel("Upgrades and ascends ALL owned relics.", true)
    GQRelicGroup:AddDivider()
    GQRelicGroup:AddToggle("AutoRelicUpgradeEnabled", {
        Text = "Auto Upgrade All Relics", Default = false,
        Callback = function(value)
            S.autoRelicUpgradeEnabled = value
            if value then
                if S.autoRelicUpgradeThread then task.cancel(S.autoRelicUpgradeThread) end
                S.autoRelicUpgradeThread = task.spawn(aas_autoRelicUpgradeLoop)
                Library:Notify("Auto Relic Upgrade - Started!")
            else
                if S.autoRelicUpgradeThread then task.cancel(S.autoRelicUpgradeThread) S.autoRelicUpgradeThread = nil end
            end
        end,
    })
    GQRelicGroup:AddToggle("AutoRelicAscendEnabled", {
        Text = "Auto Ascend All Relics", Default = false,
        Callback = function(value)
            S.autoRelicAscendEnabled = value
            if value then
                if S.autoRelicAscendThread then task.cancel(S.autoRelicAscendThread) end
                S.autoRelicAscendThread = task.spawn(aas_autoRelicAscendLoop)
                Library:Notify("Auto Relic Ascend - Started!")
            else
                if S.autoRelicAscendThread then task.cancel(S.autoRelicAscendThread) S.autoRelicAscendThread = nil end
            end
        end,
    })

    local GQFullListGroup = Tabs.Quests:AddLeftGroupbox("Quest Reference (All)", "book-open")
    local aas_gqStatusLabelRefs = {}

    GQFullListGroup:AddButton({
        Text = "Refresh Status",
        Func = function()
            local claimedCount, completeCount, progressCount = 0, 0, 0
            local allQuests = aas_GlobalQuestConfig:GetAll() or {}

            for i, def in ipairs(allQuests) do
                local qData = aas_gqReadQuest(i)
                local display = aas_gqBuildDisplay(i)

                local statusIcon
                if qData.Claimed then
                    statusIcon = "✅" claimedCount = claimedCount + 1
                elseif qData.Complete then
                    statusIcon = "🟡" completeCount = completeCount + 1
                else
                    statusIcon = "⏳" progressCount = progressCount + 1
                end

                local progressText = ""
                if qData.Required > 0 then
                    progressText = " (" .. tostring(qData.Current) .. "/" .. tostring(qData.Required) .. ")"
                end

                local labelRef = aas_gqStatusLabelRefs[i]
                if labelRef then
                    pcall(function() labelRef:SetText(statusIcon .. " " .. display .. progressText) end)
                end
            end

            Library:Notify(
                "GQ Status Refreshed - ✅ Claimed: " .. claimedCount ..
                " | 🟡 Complete: " .. completeCount ..
                " | ⏳ In Progress: " .. progressCount
            )
        end,
    })

    GQFullListGroup:AddDivider()

    do
        local allQuests = aas_GlobalQuestConfig:GetAll() or {}
        for i, def in ipairs(allQuests) do
            local display = aas_gqBuildDisplay(i)
            local labelKey = "GQStatus_" .. i
            local labelObj = GQFullListGroup:AddLabel("⏳ " .. display, true, labelKey)
            aas_gqStatusLabelRefs[i] = Options[labelKey] or labelObj
        end
    end
end

-- ══════════════════════════════════════════
--   PROMOTION TAB (SOLID COLORS)
-- ══════════════════════════════════════════

do
    local PromoInfoGroup = Tabs.Promotion:AddLeftGroupbox("Current Promotion Status", "list")
    local promoRankObj = PromoInfoGroup:AddLabel("Current Rank: Loading...", false, "PromotionCurrentRankLabel")
    S.promotionCurrentRankLabelRef = Options["PromotionCurrentRankLabel"] or promoRankObj
    local promoNextObj = PromoInfoGroup:AddLabel("Next Rank: -", false, "PromotionNextRankLabel")
    S.promotionNextRankLabelRef = Options["PromotionNextRankLabel"] or promoNextObj
    local promoCanObj = PromoInfoGroup:AddLabel("Can Promote: false", false, "PromotionCanPromoteLabel")
    S.promotionCanPromoteLabelRef = Options["PromotionCanPromoteLabel"] or promoCanObj
    local promoProgObj = PromoInfoGroup:AddLabel("Mission Progress: 0/0", false, "PromotionProgressLabel")
    S.promotionProgressLabelRef = Options["PromotionProgressLabel"] or promoProgObj
    PromoInfoGroup:AddDivider()
    for i = 1, 10 do
        local key = "PromotionMissionLabel_"..i
        local obj = PromoInfoGroup:AddLabel(" ", true, key)
        S.promotionMissionLabelRefs[i] = Options[key] or obj
    end

    local PromoControlGroup = Tabs.Promotion:AddRightGroupbox("Controls", "settings")
    PromoControlGroup:AddButton({
        Text = "Refresh Promotion State",
        Func = function()
            pcall(aas_syncAllPlayerData) aas_requestPromotionState(2) aas_updatePromotionUi()
            local state = S.promotionLiveState or aas_buildFallbackPromotionState()
            Library:Notify("Promotion Refreshed - Rank: "..tostring(state and state.PromotionRank or "?"))
        end,
    })
    PromoControlGroup:AddDivider()
    PromoControlGroup:AddToggle("AutoPromotionEnabled", {
        Text = "Enable Auto Promotion", Default = false,
        Callback = function(value)
            S.promotionEnabled = value
            if value then
                if S.promotionThread then task.cancel(S.promotionThread) S.promotionThread = nil end
                S.promotionThread = task.spawn(aas_autoPromotionLoop)
                Library:Notify("Auto Promotion - Started!")
            else
                if S.promotionThread then task.cancel(S.promotionThread) S.promotionThread = nil end
                aas_promoStopBackgroundThreads() S.promotionSuppressedByPriority = false
            end
        end,
    })
    PromoControlGroup:AddButton({
        Text = "Force Promote (If Ready)",
        Func = function()
            pcall(function() aas_promotionPromoteRemote:Fire() end)
            task.wait(0.2) aas_requestPromotionState(2) aas_updatePromotionUi()
        end,
    })

    local PromoRefGroup = Tabs.Promotion:AddLeftGroupbox("Promotion Rank Reference", "book-open")
    do
        local maxRank = aas_PromotionConfig:GetMaxRank()
        for rank = 0, maxRank do
            local key = "PromotionRef_"..rank
            local obj = PromoRefGroup:AddLabel("• "..aas_promoBuildRankSummary(rank), true, key)
            S.promotionRankRefLabelRefs[rank] = Options[key] or obj
        end
    end

    task.defer(function()
        pcall(aas_syncAllPlayerData) aas_requestPromotionState(2) aas_updatePromotionUi()
    end)
end

-- ══════════════════════════════════════════
--   PLAYER TAB (GRADIENT ENABLED)
-- ══════════════════════════════════════════

do
    local PlayerGroup = Tabs.Player:AddLeftGroupbox("Player", "user-check")
    PlayerGroup:AddLabel(b(createMultiGradientText("USER", PALETTE.fire)), true)
    PlayerGroup:AddPlayerInfo("PlayerCardCompact", {
        ThumbnailType = "Bust",
        Height = 190,
    })

    local FlyGroup = Tabs.Player:AddRightGroupbox("Movement", "feather")
    FlyGroup:AddLabel(b(createMultiGradientText("FLIGHT", PALETTE.prism)), true)
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("Fly",      { Text = "Fly", Default = false })
    FlyGroup:AddSlider("FlySpeed", { Text = "Fly Speed", Default = 60, Min = 10, Max = 350, Rounding = 0, Callback = function(v) currentFlySpeed = v end })
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("AntiSit", {
        Text = "Anti-Sit",
        Default = false,
        Callback = function(v)
            local h = getHumanoid()
            if h then h:SetStateEnabled(Enum.HumanoidStateType.Seated, not v) end
        end,
    })
    FlyGroup:AddDivider()
    FlyGroup:AddLabel(b(createMultiGradientText("MOBILITY", PALETTE.ocean)), true)
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("WalkSpeedEnabled", { Text = "Speed", Default = false })
    FlyGroup:AddSlider("WalkSpeed",        { Text = "Speed Value", Default = 16, Min = 16, Max = 250, Rounding = 0, Callback = function(v) currentWalkSpeed = v end })
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("JumpPowerEnabled", { Text = "Jump", Default = false })
    MoveGroup = FlyGroup
    FlyGroup:AddSlider("JumpPower",        { Text = "Jump Value", Default = 50, Min = 50, Max = 300, Rounding = 0, Callback = function(v) currentJumpPower = v end })
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("InfJump", { Text = "Infinite Jump", Default = false })
    FlyGroup:AddToggle("NoClip",  { Text = "NoClip", Default = false })
end

Toggles.Fly:OnChanged(function(v)
    if v then
        sFLY(false)
    else
        FLYING = false
        if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
        if flyKeyUp then flyKeyUp:Disconnect() flyKeyUp = nil end
        local h = getHumanoid()
        if h then h.PlatformStand = false end
    end
end)

Toggles.WalkSpeedEnabled:OnChanged(function(v)
    if not v then
        local h = getHumanoid()
        if h then h.WalkSpeed = 16 end
    end
end)

Toggles.JumpPowerEnabled:OnChanged(function(v)
    if not v then
        local h = getHumanoid()
        if h then h.JumpPower = 50 end
    end
end)

-- ══════════════════════════════════════════
--   SETTINGS TAB (GRADIENT ENABLED)
-- ══════════════════════════════════════════

do
    local PerfGroup = Tabs.Settings:AddLeftGroupbox("Performance", "cpu")
    PerfGroup:AddLabel(b(createMultiGradientText("OPTIMIZATION", PALETTE.aurora)), true)
    PerfGroup:AddDivider()
    PerfGroup:AddToggle("PotatoMode", {
        Text = "Disable 3D Rendering",
        Default = false,
        Tooltip = "Cuts GPU/CPU usage to near zero while AFK farming",
        Callback = function(v) RunService:Set3dRenderingEnabled(not v) end,
    })
    PerfGroup:AddToggle("AntiAFK", {
        Text = "Anti-AFK",
        Default = true,
        Tooltip = "Prevents Roblox disconnects after 20 minutes of inactivity"
    })

    local MenuGroup = Tabs.Settings:AddRightGroupbox("Interface", "settings")

    MenuGroup:AddLabel(b(createMultiGradientText("UI PREFERENCES", PALETTE.prism)), true)
    MenuGroup:AddDivider()
    MenuGroup:AddToggle("KeybindMenuOpen", {
        Text     = "Show Keybind Menu",
        Default  = false,
        Callback = function(v) if Library.KeybindFrame then Library.KeybindFrame.Visible = v end end,
    })
    MenuGroup:AddDropdown("NotificationSide", {
        Values   = { "Left", "Right" },
        Default  = "Right",
        Text     = "Notification Placement",
        Callback = function(v) pcall(function() Library:SetNotifySide(v) end) end,
    })
    MenuGroup:AddDivider()
    MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", { Default = "G", NoUI = true, Text = "Menu keybind" })
    Library.ToggleKeybind = Options.MenuKeybind
    MenuGroup:AddButton("Unload Prism", function() Library:Unload() end)
end

-- ══════════════════════════════════════════
--   FINALIZE INITIALIZATION
-- ══════════════════════════════════════════

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("PrismHub")
SaveManager:SetFolder("PrismHub/AnimeAstralSimulator")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

ThemeManager:SaveDefault("Claude")
ThemeManager:LoadDefault()

SaveManager:LoadAutoloadConfig()

Window:SetGlow(true, {
    Color = Color3.fromRGB(217, 119, 87),
    Radius = 30,
    Transparency = 0.1
})

Library:OnUnload(function()
    pcall(aas_cleanup)
    pcall(function() if steppedConnection then steppedConnection:Disconnect() end end)
    pcall(function() if jumpConnection then jumpConnection:Disconnect() end end)
    pcall(function() if renderConnection then renderConnection:Disconnect() end end)
    pcall(function() if infJumpConnection then infJumpConnection:Disconnect() end end)
    pcall(function() if charAddedConn then charAddedConn:Disconnect() end end)

    FLYING = false
    pcall(function() if flyKeyDown then flyKeyDown:Disconnect() end end)
    pcall(function() if flyKeyUp then flyKeyUp:Disconnect() end end)

    pcall(function() RunService:Set3dRenderingEnabled(true) end)
    pcall(function()
        local h = getHumanoid()
        if h then
            h.PlatformStand = false
            h.WalkSpeed     = 16
            h.JumpPower     = 50
        end
    end)
end)

task.spawn(function()
    task.wait(3)
    pcall(aas_syncAllPlayerData)
    pcall(function() aas_requestPromotionState(2) aas_updatePromotionUi() end)
end)

task.defer(function()
    task.wait(2.5)
    Library:Notify(
        "Prism Adaptor Successful! Welcome, " .. LocalPlayer.Name ..
        " | " .. executorName .. " detected."
    )
end)
