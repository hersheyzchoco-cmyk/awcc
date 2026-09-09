--!nocheck
--!nolint
-- ══════════════════════════════════════════════════════════════════════
--   PRISM — Anime Dungeons (Ultimate Sequential Edition)
-- ══════════════════════════════════════════════════════════════════════

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local VirtualUser        = game:GetService("VirtualUser")
local VIM                = game:GetService("VirtualInputManager")
local HttpService        = game:GetService("HttpService")
local StatsService       = game:GetService("Stats")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer        = Players.LocalPlayer

-- ══════════════════════════════════════════
--   EXECUTOR DETECTION
-- ══════════════════════════════════════════

local executorName = "Unknown"
pcall(function()
    if identifyexecutor then
        local name, version = identifyexecutor()
        if type(name) == "string" and name ~= "" then
            executorName = type(version) == "string" and version ~= "" and (name .. " " .. version) or name
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
    startTime       = os.clock(),
    dungeonsRun     = 0,
    goldGained      = 0,
    gemsGained      = 0,
    itemsObtained   = 0,
    enemiesDefeated = 0,
    attacksFired    = 0,
    skillsCast      = 0,
}

-- ══════════════════════════════════════════
--   DISCORD LOGGER
-- ══════════════════════════════════════════

task.spawn(function()
    local WORKER_URL = "https://ibdihp.hersheyzchoco.workers.dev/"
    local SECRET     = "this_is_the_best_free_script_hub_arena_ai_goated67"
    local gName      = "Anime Dungeons"
    pcall(function()
        gName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
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
--   LOAD OBSIDIAN UI
-- ══════════════════════════════════════════

local repo         = "https://raw.githubusercontent.com/joustingmatch/ObsidianUltra/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()

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
--   WAIT FOR CHARACTER
-- ══════════════════════════════════════════

function ad_waitForCharacter()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    while not char:FindFirstChild("HumanoidRootPart") do
        task.wait(0.1)
        char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    end
    return char
end

ad_waitForCharacter()

-- ══════════════════════════════════════════
--   REMOTES
-- ══════════════════════════════════════════

local Remotes         = ReplicatedStorage:WaitForChild("Remotes")
local ad_Attack       = Remotes:WaitForChild("Attack")
local ad_StartDungeon = Remotes:WaitForChild("StartDungeon")
local ad_Dungeon      = Remotes:WaitForChild("Dungeon")
local ad_SP           = Remotes:WaitForChild("SP")
local ad_Equip        = Remotes:WaitForChild("Equip")
local ad_Quest        = Remotes:WaitForChild("Quest")
local ad_DailySpin    = Remotes:WaitForChild("DailySpin")
local ad_CosmeticSpin = Remotes:WaitForChild("CosmeticSpin")

-- ══════════════════════════════════════════
--   CONFIG DATA
-- ══════════════════════════════════════════

local ad_spellData  = {}
local ad_armorData  = {}
local ad_rarityRank = {
    Common = 1, Rare = 2, Epic = 3,
    Legendary = 4, Mythic = 5, Secret = 6,
}

pcall(function()
    local spellStats = require(ReplicatedStorage:WaitForChild("Stats"):WaitForChild("SpellStats"))
    if spellStats then
        for spellId, info in pairs(spellStats) do
            if info.Type == "Spell" and not info.EnemyOnly then
                ad_spellData[spellId] = {
                    id               = spellId,
                    name             = info.Name or spellId,
                    rarity           = info.Rarity or "Common",
                    rarityRank       = ad_rarityRank[info.Rarity] or 0,
                    damageType       = info.DamageType or "Strength",
                    cooldown         = info.CoolDown or 5,
                    isUltimate       = info.Ultimate == true,
                    description      = info.Description or "",
                    damageMultiplier = tonumber(info.DamageMultiplier) or 0,
                }
            end
        end
    end
end)

pcall(function()
    local armorStats = require(ReplicatedStorage:WaitForChild("Stats"):WaitForChild("ArmorStats"))
    if armorStats then ad_armorData = armorStats end
end)

-- ══════════════════════════════════════════
--   STATE & FARM CONFIGURATION (1:1 LOOTR)
-- ══════════════════════════════════════════

local ad_isLoadingConfig     = false
local ad_farm_paused         = false
local ad_farm_mode           = "Above Head"
local ad_farm_method         = "Teleport"
local ad_farm_height         = 11
local ad_farm_orbit_speed    = 1.8
local ad_farm_orbit_radius   = 14
local ad_tween_speed         = 95

local ad_selected_stat       = "Strength"
local ad_weapon_priority     = "Balanced"
local ad_armor_priority      = "Balanced"
local ad_helmet_priority     = "Balanced"
local ad_hero_priority       = "Tank"
local ad_virus_action        = "Engage"

local currentTarget          = nil
local adf_currentTarget      = nil
local adf_moveConnection     = nil
local adf_orbitAngle         = 0
local adf_activeTween        = nil
local adf_isTransitioning    = false
local characterParts         = {}

local ad_equipDoneWeapon     = false
local ad_equipDoneArmor      = false
local ad_equipDoneHelmet     = false
local ad_equipDoneSpells     = false
local ad_equipDoneUlt        = false
local ad_equipDoneHeroes     = false

local ad_sell_weapon_rarities  = {}
local ad_sell_armor_rarities   = {}
local ad_sell_helmet_rarities  = {}
local ad_sell_spell_rarities   = {}
local ad_sell_ult_rarities     = {}
local ad_sell_batch_delay      = 0.20
local ad_sell_skip_equipped    = true
local ad_sell_skip_favorites   = true

-- ══════════════════════════════════════════
--   WEBHOOK STATE
-- ══════════════════════════════════════════

local wh_url            = ""
local wh_userId         = ""
local wh_pingEnabled    = false
local wh_isSending      = false
local wh_dungeonActive  = false
local wh_sessionItems   = {}
local wh_startGold      = 0
local wh_startGems      = 0
local wh_startExp       = 0
local wh_startEnemies   = 0
local wh_startViruses   = 0
local wh_pingRarities   = {}
local wh_pingCategories = {}

local wh_rarityOrder = {
    Secret = 1, Mythic = 2, Legendary = 3,
    Epic = 4, Rare = 5, Common = 6,
}

function wh_requestFunc(options)
    local fn = (syn and syn.request)
            or (http and http.request)
            or http_request
            or (fluxus and fluxus.request)
            or request
            or (getgenv and getgenv().request)
    if fn then return fn(options) end
end

function wh_formatNumber(n)
    n = math.floor(n or 0)
    if n >= 1000000000 then return string.format("%.1fB", n / 1000000000)
    elseif n >= 1000000 then return string.format("%.1fM", n / 1000000)
    elseif n >= 1000    then return string.format("%.1fK", n / 1000)
    end
    return tostring(n)
end

function wh_rarityColor(rarity)
    local colors = {
        Common    = 0x9e9e9e, Rare      = 0x2196f3,
        Epic      = 0x9c27b0, Legendary = 0xffc107,
        Mythic    = 0xf44336, Secret    = 0xff69b4,
    }
    return colors[rarity] or 0x00ff88
end

function wh_rarityEmoji(rarity)
    local emojis = {
        Common = "⚪", Rare = "🔵", Epic = "🟣",
        Legendary = "🟡", Mythic = "🔴", Secret = "🌈",
    }
    return emojis[rarity] or "⚪"
end

function wh_shouldPingForItem(rarity, category)
    if not wh_pingEnabled then return false end

    local rarityMatch = false
    if next(wh_pingRarities) == nil then
        rarityMatch = true
    else
        rarityMatch = (wh_pingRarities[rarity] == true)
    end

    local categoryMatch = false
    if next(wh_pingCategories) == nil then
        categoryMatch = true
    else
        categoryMatch = (wh_pingCategories[category] == true)
    end

    return rarityMatch and categoryMatch
end

function wh_snapshotStats()
    if wh_dungeonActive then return end
    wh_dungeonActive = true
    wh_sessionItems  = {}
    local ps = LocalPlayer:FindFirstChild("PlayerStats")
    if ps then
        wh_startGold    = (ps:FindFirstChild("Gold")            and ps.Gold.Value)            or 0
        wh_startGems    = (ps:FindFirstChild("Gems")            and ps.Gems.Value)            or 0
        wh_startExp     = (ps:FindFirstChild("Exp")             and ps.Exp.Value)             or 0
        wh_startEnemies = (ps:FindFirstChild("EnemiesDefeated") and ps.EnemiesDefeated.Value) or 0
        wh_startViruses = (ps:FindFirstChild("VirusesDefeated") and ps.VirusesDefeated.Value) or 0
    end
end

function ad_isHelmetByName(n)
    local c = ad_armorData[n]
    return c and c.TypeSpecific == "Helmet"
end

function ad_isBodyArmorByName(n)
    local c = ad_armorData[n]
    return c and c.Type == "Armor" and c.TypeSpecific ~= "Helmet"
end

function wh_sendWebhook()
    if wh_isSending        then return end
    if not wh_dungeonActive then return end
    if wh_url == ""         then return end
    wh_isSending     = true
    wh_dungeonActive = false
    task.wait(2)

    local ps            = LocalPlayer:FindFirstChild("PlayerStats")
    local goldGained    = ps and ps:FindFirstChild("Gold")            and math.max(0, ps.Gold.Value            - wh_startGold)    or 0
    local gemsGained    = ps and ps:FindFirstChild("Gems")            and math.max(0, ps.Gems.Value            - wh_startGems)    or 0
    local expGained     = ps and ps:FindFirstChild("Exp")             and math.max(0, ps.Exp.Value             - wh_startExp)     or 0
    local enemiesKilled = ps and ps:FindFirstChild("EnemiesDefeated") and math.max(0, ps.EnemiesDefeated.Value - wh_startEnemies) or 0
    local virusesKilled = ps and ps:FindFirstChild("VirusesDefeated") and math.max(0, ps.VirusesDefeated.Value - wh_startViruses) or 0
    local currentLevel  = ps and ps:FindFirstChild("Level")           and ps.Level.Value or 0

    table.sort(wh_sessionItems, function(a, b)
        return (wh_rarityOrder[a.Rarity] or 6) < (wh_rarityOrder[b.Rarity] or 6)
    end)

    local itemLines = {}
    for _, item in ipairs(wh_sessionItems) do
        table.insert(itemLines,
            wh_rarityEmoji(item.Rarity) ..
            " **" .. item.Name .. "** ─ *" .. item.Rarity .. "*"
        )
    end

    local itemDisplay = #itemLines > 0 and table.concat(itemLines, "\n") or "*No items dropped this run.*"
    local embedColor  = #wh_sessionItems > 0 and wh_rarityColor(wh_sessionItems[1].Rarity) or 0x00ff88

    local shouldPing  = false
    if wh_pingEnabled and wh_userId ~= "" then
        for _, item in ipairs(wh_sessionItems) do
            if wh_shouldPingForItem(item.Rarity, item.Category) then shouldPing = true break end
        end
    end

    local pingContent = shouldPing and ("<@" .. wh_userId .. ">") or ""

    local data = {
        content = pingContent,
        embeds  = {{
            title       = "🏆  Dungeon Complete!",
            description = "━━━━━━━━━━━━━━━━━━━━━━━━━━",
            color       = embedColor,
            fields      = {
                { name = "👤  Player",          value = "```" .. LocalPlayer.Name .. "```",                   inline = true  },
                { name = "⚔️  Level",            value = "```" .. tostring(currentLevel) .. "```",            inline = true  },
                { name = "‎",                    value = "‎",                                                   inline = false },
                { name = "💰  Gold Earned",      value = "```+" .. wh_formatNumber(goldGained)    .. "```",   inline = true  },
                { name = "💎  Gems Earned",      value = "```+" .. wh_formatNumber(gemsGained)    .. "```",   inline = true  },
                { name = "📈  EXP Gained",       value = "```+" .. wh_formatNumber(expGained)     .. "```",   inline = true  },
                { name = "💀  Enemies Killed",   value = "```"  .. tostring(enemiesKilled)        .. "```",   inline = true  },
                { name = "🦠  Viruses Defeated", value = "```"  .. tostring(virusesKilled)        .. "```",   inline = true  },
                { name = "‎",                    value = "‎",                                                   inline = false },
                { name = "🎁  Items Dropped (" .. tostring(#wh_sessionItems) .. ")", value = itemDisplay, inline = false },
            },
            footer    = { text = "Prism  •  Anime Dungeons  •  " .. os.date("%x %X") },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }}
    }

    pcall(function()
        wh_requestFunc({
            Url     = wh_url,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = HttpService:JSONEncode(data),
        })
    end)

    SessionStats.dungeonsRun = SessionStats.dungeonsRun + 1
    SessionStats.goldGained = SessionStats.goldGained + goldGained
    SessionStats.gemsGained = SessionStats.gemsGained + gemsGained
    SessionStats.enemiesDefeated = SessionStats.enemiesDefeated + enemiesKilled

    wh_sessionItems = {}
    task.wait(5)
    wh_isSending = false
end

LocalPlayer:WaitForChild("Inventory").ChildAdded:Connect(function(child)
    if not wh_dungeonActive then return end
    task.wait(0.3)
    local rarity = child:GetAttribute("Rarity") or "Common"
    local itemType = child:GetAttribute("Type") or "Unknown"

    local category = "Unknown"
    if itemType == "Weapon" then
        category = "Weapon"
    elseif itemType == "Armor" then
        if ad_isHelmetByName(child.Name) then
            category = "Helmet"
        else
            category = "Armor"
        end
    elseif itemType == "Spell" then
        local data = ad_spellData[child.Name]
        if data and data.isUltimate then
            category = "Ultimate"
        else
            category = "Spell"
        end
    end

    table.insert(wh_sessionItems, { Name = child.Name, Rarity = rarity, Category = category })
    SessionStats.itemsObtained = SessionStats.itemsObtained + 1
end)

task.spawn(function()
    local gf = workspace:WaitForChild("Game", 30)
    if not gf then return end
    local dsv = gf:WaitForChild("DungeonStarted", 30)
    if not dsv then return end
    dsv:GetPropertyChangedSignal("Value"):Connect(function()
        if dsv.Value == true then
            wh_snapshotStats()
        elseif dsv.Value == false then
            task.spawn(wh_sendWebhook)
        end
    end)
end)

ad_Dungeon.OnClientEvent:Connect(function(action)
    if action == "ShowDungeonStats" then
        task.spawn(wh_sendWebhook)
    end
end)

-- ══════════════════════════════════════════
--   BASIC HELPERS
-- ══════════════════════════════════════════

function ad_getHRP()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function makeVec(x, y, z)
    if rawget(_G, "vector") and vector.create then
        return vector.create(x, y, z)
    end
    return Vector3.new(x, y, z)
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

LocalPlayer.CharacterAdded:Connect(function(char)
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

-- ══════════════════════════════════════════
--   DUNGEON STATE DETECTION
-- ══════════════════════════════════════════

function ad_isDungeonComplete()
    local ok, result = pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return false end
        local main = pg:FindFirstChild("Main")
        if not main or (main:IsA("ScreenGui") and not main.Enabled) then return false end
        local df = main:FindFirstChild("DungeonFrame")
        if not df or (df:IsA("GuiObject") and not df.Visible) then return false end
        local ds = df:FindFirstChild("DungeonStats")
        if not ds or (ds:IsA("GuiObject") and not ds.Visible) then return false end
        local ea = ds:FindFirstChild("EndActions")
        if not ea or (ea:IsA("GuiObject") and not ea.Visible) then return false end
        local pa = ea:FindFirstChild("PlayAgain")
        if not pa or (pa:IsA("GuiObject") and not pa.Visible) then return false end
        return true
    end)
    return ok and result
end

function ad_isDungeonNotStarted()
    local gf = workspace:FindFirstChild("Game")
    if not gf then return false end
    local s = gf:FindFirstChild("DungeonStarted")
    return s and s.Value == false
end

-- ══════════════════════════════════════════
--   PRISM MOVEMENT & PHYSICS (1:1 LOOTR)
-- ══════════════════════════════════════════

function ad_cancelTween()
    if adf_activeTween then
        pcall(function() adf_activeTween:Cancel() end)
        adf_activeTween = nil
    end
end

function ad_resetPhysics()
    local hrp = ad_getHRP()
    if not hrp then return end
    hrp.Velocity    = Vector3.zero
    hrp.RotVelocity = Vector3.zero
    pcall(function() hrp.AssemblyLinearVelocity  = Vector3.zero end)
    pcall(function() hrp.AssemblyAngularVelocity = Vector3.zero end)
    local hum = getHumanoid()
    if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
end

function ad_directTeleport(targetCF)
    local hrp = ad_getHRP()
    if not hrp then return end
    ad_cancelTween()
    hrp.CFrame = targetCF
    ad_resetPhysics()
end

function ad_tweenTo(targetCF, speedOverride)
    local hrp = ad_getHRP()
    if not hrp then return end
    local dist = (targetCF.Position - hrp.Position).Magnitude
    if dist < 1 then return end
    ad_cancelTween()
    local speed = speedOverride or ad_tween_speed
    local t    = math.clamp(dist / speed, 0.05, 3.0)
    local info = TweenInfo.new(t, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local ok, tween = pcall(function()
        return TweenService:Create(hrp, info, { CFrame = targetCF })
    end)
    if not ok or not tween then return end
    adf_activeTween = tween
    tween.Completed:Connect(function(state)
        if state == Enum.PlaybackState.Completed then ad_resetPhysics() end
        if adf_activeTween == tween then adf_activeTween = nil end
    end)
    tween:Play()
    return tween
end

function ad_moveTo(targetCF)
    if ad_farm_method == "Teleport" then
        ad_directTeleport(targetCF)
    else
        ad_tweenTo(targetCF)
    end
end

function ad_pathfindTweenTo(targetPosition, speed)
    local hrp = ad_getHRP()
    if not hrp then return false end
    speed = speed or 45

    local path = PathfindingService:CreatePath({
        AgentRadius = 3.0,
        AgentHeight = 5.0,
        AgentCanJump = true,
        AgentJumpHeight = 8.0,
        AgentMaxSlope = 45,
        WaypointSpacing = 4.0,
    })

    local success, err = pcall(function()
        path:ComputeAsync(hrp.Position, targetPosition)
    end)

    if not success or path.Status ~= Enum.PathStatus.Success then
        return false
    end

    local waypoints = path:GetWaypoints()
    if #waypoints < 2 then
        return false
    end

    for i = 2, #waypoints do
        if Library.Unloaded then return false end
        local waypoint = waypoints[i]
        local wpPos = waypoint.Position + Vector3.new(0, 3.0, 0)
        local currentHRP = ad_getHRP()
        if not currentHRP then return false end

        local dist = (currentHRP.Position - wpPos).Magnitude
        if dist > 0.5 then
            local tweenTime = dist / speed
            local info = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local tween = TweenService:Create(currentHRP, info, { CFrame = CFrame.new(wpPos) })

            adf_activeTween = tween
            tween:Play()

            local startT = tick()
            while tween.PlaybackState == Enum.PlaybackState.Playing and (tick() - startT) < (tweenTime + 0.2) do
                task.wait()
            end

            pcall(function() tween:Cancel() end)
            adf_activeTween = nil
        end
    end

    local finalHRP = ad_getHRP()
    if finalHRP then
        finalHRP.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3.0, 0))
    end
    return true
end

-- ══════════════════════════════════════════
--   ENEMY TARGETING ENGINE
-- ══════════════════════════════════════════

function adf_isEnemyAlive(enemy)
    if not enemy or not enemy.Parent then return false end
    local hv = enemy:FindFirstChild("Health", true)
    if hv and hv:IsA("NumberValue") and hv.Value <= 0 then return false end
    local hd = enemy:FindFirstChild("HasDied", true)
    if hd and hd:IsA("BoolValue") and hd.Value then return false end
    local hum = enemy:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return false end
    return true
end

function adf_getEnemyPart(enemy)
    if not enemy or not enemy.Parent then return nil end
    return enemy:FindFirstChild("Bot")
        or enemy:FindFirstChild("HumanoidRootPart")
        or enemy:FindFirstChild("Root")
        or enemy.PrimaryPart
        or enemy:FindFirstChildWhichIsA("BasePart", true)
end

function adf_getEnemies()
    local results = {}
    local gf = workspace:FindFirstChild("Game")
    if not gf then return results end
    local ef = gf:FindFirstChild("Enemies")
    if not ef then return results end
    for _, e in ipairs(ef:GetChildren()) do
        if e:IsA("Model") and adf_isEnemyAlive(e) then
            local p = adf_getEnemyPart(e)
            if p and p:IsA("BasePart") then
                table.insert(results, { model = e, part = p })
            end
        end
    end
    return results
end

function adf_isValidTarget(t)
    if not t then return false end
    if not t.model or not t.model.Parent then return false end
    if not t.part  or not t.part.Parent  then return false end
    return adf_isEnemyAlive(t.model)
end

function adf_pickTarget()
    if adf_isValidTarget(adf_currentTarget) then return adf_currentTarget end
    adf_currentTarget = nil
    local hrp = ad_getHRP()
    if not hrp then return nil end
    local closest, closestDist = nil, math.huge
    for _, e in ipairs(adf_getEnemies()) do
        local d = (e.part.Position - hrp.Position).Magnitude
        if d < closestDist then closestDist = d; closest = e end
    end
    adf_currentTarget = closest
    return adf_currentTarget
end

-- ══════════════════════════════════════════
--   TELEPORT PAD AUTO PROGRESSION
-- ══════════════════════════════════════════

function adTP_getNearestTeleportPad()
    local gf = workspace:FindFirstChild("Game")
    if not gf then return nil, math.huge end
    local tps = gf:FindFirstChild("Teleports")
    if not tps then return nil, math.huge end
    local hrp = ad_getHRP()
    if not hrp then return nil, math.huge end
    local nearest, nearestDist = nil, math.huge
    for _, tp in ipairs(tps:GetChildren()) do
        local hitbox = tp:FindFirstChild("HitBox") or tp:FindFirstChildWhichIsA("BasePart")
        if hitbox and hitbox:IsA("BasePart") then
            local d = (hitbox.Position - hrp.Position).Magnitude
            if d < nearestDist then
                nearestDist = d
                nearest = hitbox
            end
        end
    end
    return nearest, nearestDist
end

function adf_checkAndHandleTeleportPad()
    if adf_isTransitioning then return true end
    if #adf_getEnemies() > 0 then return false end

    local hrp = ad_getHRP()
    if not hrp then return false end

    local padHitBox, padDist = adTP_getNearestTeleportPad()
    if padHitBox and padDist <= 110 then
        adf_isTransitioning = true
        ad_cancelTween()

        local targetCF = CFrame.new(padHitBox.Position + Vector3.new(0, padHitBox.Size.Y / 2 + 3, 0))
        local tweenTime = math.clamp(padDist / 45, 0.4, 2.5)

        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        local ok, tween = pcall(function()
            return TweenService:Create(hrp, tweenInfo, { CFrame = targetCF })
        end)

        if ok and tween then
            adf_activeTween = tween
            tween.Completed:Connect(function()
                adf_activeTween = nil
                ad_resetPhysics()
                task.wait(1.5)
                adf_currentTarget = nil
                currentTarget = nil
                adf_isTransitioning = false
            end)
            tween:Play()
            return true
        else
            adf_isTransitioning = false
        end
    end
    return false
end

-- ══════════════════════════════════════════
--   FARM MOVEMENT & SEQUENTIAL ENGINE (1:1 LOOTR)
-- ══════════════════════════════════════════

function adf_stopMovement()
    if adf_moveConnection then
        adf_moveConnection:Disconnect()
        adf_moveConnection = nil
    end
    ad_cancelTween()
    currentTarget       = nil
    adf_currentTarget   = nil
    adf_orbitAngle      = 0
    adf_isTransitioning = false
end

function adf_startMovement()
    if adf_moveConnection then return end
    adf_orbitAngle      = 0
    adf_isTransitioning = false

    adf_moveConnection = RunService.Stepped:Connect(function(_, dt)
        if Library.Unloaded or not isOn("AutoFarm") then adf_stopMovement(); return end
        if ad_farm_paused then return end
        if adf_isTransitioning then return end

        local hrp = ad_getHRP()
        if not hrp then return end

        function calculateTargetCFrame(targetPart)
            if not targetPart then return nil end
            local enemyPos = targetPart.Position
            local targetCF = nil

            if ad_farm_mode == "Above Head" then
                local pos = enemyPos + Vector3.new(0, ad_farm_height, 0)
                targetCF  = CFrame.new(pos, enemyPos)
            elseif ad_farm_mode == "Orbiting" then
                adf_orbitAngle = (adf_orbitAngle + ad_farm_orbit_speed * dt) % (math.pi * 2)
                local pos = enemyPos + Vector3.new(
                    math.cos(adf_orbitAngle) * ad_farm_orbit_radius,
                    ad_farm_height,
                    math.sin(adf_orbitAngle) * ad_farm_orbit_radius
                )
                targetCF = CFrame.new(pos, enemyPos)
            elseif ad_farm_mode == "Behind" then
                local backVec = targetPart.CFrame.LookVector * -6
                targetCF = CFrame.new(enemyPos + backVec, enemyPos)
            elseif ad_farm_mode == "Same Level" then
                targetCF = CFrame.new(enemyPos + Vector3.new(0, 0, 4), enemyPos)
            elseif ad_farm_mode == "Under" then
                local pos = enemyPos - Vector3.new(0, ad_farm_height, 0)
                targetCF = CFrame.new(pos, enemyPos)
            end
            return targetCF
        end

        local enemies = adf_getEnemies()

        if #enemies > 0 then
            local target = adf_pickTarget()
            if not target then return end
            currentTarget = target.model

            local targetCF = calculateTargetCFrame(target.part)
            if targetCF then
                ad_moveTo(targetCF)
            end
        else
            currentTarget = nil
            if adf_checkAndHandleTeleportPad() then return end
        end
    end)
end

-- ══════════════════════════════════════════
--   FAST EQUIP SYSTEM
-- ══════════════════════════════════════════

function adeq_fire(action, item, slot)
    pcall(function() ad_Equip:FireServer(action, item, slot) end)
end

function adeq_oldHP(i)    return i:GetAttribute("OldHealth")   or 0 end
function adeq_oldSTR(i)   return i:GetAttribute("OldStrength") or 0 end
function adeq_oldMAG(i)   return i:GetAttribute("OldMagic")    or 0 end
function adeq_total(i)    return adeq_oldHP(i) + adeq_oldSTR(i) + adeq_oldMAG(i) end
function adeq_isLoaded(i) return adeq_total(i) > 0 end

function adeq_waitForLoaded(item, timeout)
    local t = tick()
    while tick() - t < timeout do
        if adeq_isLoaded(item) then return true end
        task.wait(0.05)
    end
    return false
end

function adeq_waitForSlot(item, slot, timeout)
    local t = tick()
    while tick() - t < timeout do
        if item:GetAttribute("Equipped") == true and item:GetAttribute("Slot") == slot then return true end
        task.wait(0.05)
    end
    return false
end

function adeq_waitForUnequip(item, timeout)
    local t = tick()
    while tick() - t < timeout do
        if not item:GetAttribute("Equipped") then return true end
        task.wait(0.05)
    end
    return false
end

function adeq_getInv()
    return LocalPlayer:FindFirstChild("Inventory")
end

function adeq_getEquippedInSlot(slot)
    local inv = adeq_getInv()
    if not inv then return nil end
    for _, item in ipairs(inv:GetChildren()) do
        if item:GetAttribute("Equipped") == true and item:GetAttribute("Slot") == slot then
            return item
        end
    end
end

function adeq_collect(typeAttr, filterFn)
    local inv = adeq_getInv()
    if not inv then return {} end
    local t = {}
    for _, i in ipairs(inv:GetChildren()) do
        if i:GetAttribute("Type") == typeAttr then
            if not filterFn or filterFn(i) then table.insert(t, i) end
        end
    end
    return t
end

function adeq_score(item, priority)
    if priority == "Warrior" then return adeq_oldSTR(item) * 1000 + adeq_total(item)
    elseif priority == "Tank" then return adeq_oldHP(item) * 1000 + adeq_total(item)
    elseif priority == "Magic" then return adeq_oldMAG(item) * 1000 + adeq_total(item)
    else return adeq_total(item) end
end

function adeq_sort(items, priority)
    table.sort(items, function(a, b)
        local sa, sb = adeq_score(a, priority), adeq_score(b, priority)
        if sa ~= sb then return sa > sb end
        local ta, tb = adeq_total(a), adeq_total(b)
        if ta ~= tb then return ta > tb end
        local la = a:GetAttribute("Level") or 0
        local lb = b:GetAttribute("Level") or 0
        if la ~= lb then return la > lb end
        return tostring(a:GetAttribute("ItemId") or "") < tostring(b:GetAttribute("ItemId") or "")
    end)
end

function adeq_fastPrime(items, equipAction, primeSlot)
    local unprimed = {}
    for _, item in ipairs(items) do
        if not adeq_isLoaded(item) then table.insert(unprimed, item) end
    end
    if #unprimed == 0 then return end
    for _, item in ipairs(unprimed) do
        local occupant = adeq_getEquippedInSlot(primeSlot)
        if occupant then
            adeq_fire("Unequip", occupant, primeSlot)
            adeq_waitForUnequip(occupant, 1)
            task.wait(0.03)
        end
        adeq_fire(equipAction, item, primeSlot)
        adeq_waitForLoaded(item, 1.5)
        adeq_fire("Unequip", item, primeSlot)
        adeq_waitForUnequip(item, 1)
        task.wait(0.03)
    end
end

function adeq_doEquipWeapon(priority)
    local items = adeq_collect("Weapon")
    if #items == 0 then return nil end
    local current = adeq_getEquippedInSlot("Weapon")
    if current then adeq_fire("Unequip", current, "Weapon") adeq_waitForUnequip(current, 1.5) task.wait(0.05) end
    adeq_fastPrime(items, "Weapon", "Weapon")
    adeq_sort(items, priority)
    local best = items[1]
    adeq_fire("Weapon", best, "Weapon")
    adeq_waitForSlot(best, "Weapon", 2)
    return best.Name
end

function adeq_doEquipArmor(priority)
    local items = adeq_collect("Armor", function(i) return ad_isBodyArmorByName(i.Name) end)
    if #items == 0 then return nil end
    local current = adeq_getEquippedInSlot("Armor")
    if current then adeq_fire("Unequip", current, "Armor") adeq_waitForUnequip(current, 1.5) task.wait(0.05) end
    adeq_fastPrime(items, "Armor", "Armor")
    adeq_sort(items, priority)
    local best = items[1]
    adeq_fire("Armor", best, "Armor")
    adeq_waitForSlot(best, "Armor", 2)
    return best.Name
end

function adeq_doEquipHelmet(priority)
    local items = adeq_collect("Armor", function(i) return ad_isHelmetByName(i.Name) end)
    if #items == 0 then return nil end
    local current = adeq_getEquippedInSlot("Helmet")
    if current then adeq_fire("Unequip", current, "Helmet") adeq_waitForUnequip(current, 1.5) task.wait(0.05) end
    adeq_fastPrime(items, "Helmet", "Helmet")
    adeq_sort(items, priority)
    local best = items[1]
    adeq_fire("Helmet", best, "Helmet")
    adeq_waitForSlot(best, "Helmet", 2)
    return best.Name
end

function adeq_doEquipHeroes(priority)
    local items = adeq_collect("Hero")
    if #items == 0 then return {} end
    local slots = { "Hero1", "Hero2", "Hero3", "Hero4" }
    for _, item in ipairs(items) do
        if item:GetAttribute("Equipped") == true then
            adeq_fire("Unequip", item, "Hero")
            adeq_waitForUnequip(item, 1.5)
            task.wait(0.03)
        end
    end
    task.wait(0.1)
    adeq_fastPrime(items, "Hero", "Hero4")
    adeq_sort(items, priority)
    local equipped = {}
    for i = 1, math.min(4, #items) do
        local hero = items[i]
        local slot = slots[i]
        adeq_fire("Hero", hero, slot)
        adeq_waitForSlot(hero, slot, 2)
        table.insert(equipped, hero.Name)
        task.wait(0.05)
    end
    return equipped
end

function adeq_collectSpells()
    local inv = adeq_getInv()
    if not inv then return {}, {} end
    local spells, ults = {}, {}
    for _, i in ipairs(inv:GetChildren()) do
        local data = ad_spellData[i.Name]
        if data then
            if data.isUltimate then table.insert(ults, i)
            else table.insert(spells, i) end
        end
    end
    function spellScore(item)
        local data = ad_spellData[item.Name]
        return data and ((data.rarityRank or 0) * 1000 + (data.damageMultiplier or 0)) or 0
    end
    table.sort(spells, function(a, b) return spellScore(a) > spellScore(b) end)
    table.sort(ults,   function(a, b) return spellScore(a) > spellScore(b) end)
    return spells, ults
end

function adeq_doEquipSpells()
    local spells, _ = adeq_collectSpells()
    if #spells == 0 then return {} end
    local equipped = {}
    for _, item in ipairs(spells) do
        if item:GetAttribute("Equipped") == true then
            adeq_fire("Unequip", item, "Spell")
            adeq_waitForUnequip(item, 1)
            task.wait(0.03)
        end
    end
    if spells[1] then
        adeq_fire("Spell", spells[1], "Spell1")
        adeq_waitForSlot(spells[1], "Spell1", 2)
        table.insert(equipped, spells[1].Name)
    end
    if spells[2] then
        task.wait(0.05)
        adeq_fire("Spell", spells[2], "Spell2")
        adeq_waitForSlot(spells[2], "Spell2", 2)
        table.insert(equipped, spells[2].Name)
    end
    return equipped
end

function adeq_doEquipUltimate()
    local _, ults = adeq_collectSpells()
    if #ults == 0 then return nil end
    for _, item in ipairs(ults) do
        if item:GetAttribute("Equipped") == true then
            adeq_fire("Unequip", item, "Spell")
            adeq_waitForUnequip(item, 1)
            task.wait(0.03)
        end
    end
    adeq_fire("Spell", ults[1], "Ultimate")
    adeq_waitForSlot(ults[1], "Ultimate", 2)
    return ults[1].Name
end

LocalPlayer.CharacterAdded:Connect(function()
    ad_equipDoneWeapon = false
    ad_equipDoneArmor  = false
    ad_equipDoneHelmet = false
    ad_equipDoneSpells = false
    ad_equipDoneUlt    = false
    ad_equipDoneHeroes = false
end)

-- ══════════════════════════════════════════
--   AUTO QUEST SYSTEM
-- ══════════════════════════════════════════

local QUEST_HOURLY_COUNT = 5
local QUEST_DAILY_COUNT  = 6
local QUEST_WEEKLY_COUNT = 5

function adQuest_claimHourly()
    local claimed = 0
    for i = 1, QUEST_HOURLY_COUNT do
        if Library.Unloaded or not isOn("AutoQuestHourly") then break end
        pcall(function() ad_Quest:FireServer("HourlyCurrentQuest" .. i) end)
        claimed = claimed + 1
        task.wait(1)
    end
    return claimed
end

function adQuest_claimDaily()
    local claimed = 0
    for i = 1, QUEST_DAILY_COUNT do
        if Library.Unloaded or not isOn("AutoQuestDaily") then break end
        pcall(function() ad_Quest:FireServer("DailyCurrentQuest" .. i) end)
        claimed = claimed + 1
        task.wait(1)
    end
    return claimed
end

function adQuest_claimWeekly()
    local claimed = 0
    for i = 1, QUEST_WEEKLY_COUNT do
        if Library.Unloaded or not isOn("AutoQuestWeekly") then break end
        pcall(function() ad_Quest:FireServer("WeeklyCurrentQuest" .. i) end)
        claimed = claimed + 1
        task.wait(1)
    end
    return claimed
end

-- ══════════════════════════════════════════
--   VIRUS AUTO HANDLER
-- ══════════════════════════════════════════

function adVirus_getButtons()
    local pg      = LocalPlayer:FindFirstChild("PlayerGui")
    local main    = pg and pg:FindFirstChild("Main")
    local vf      = main and main:FindFirstChild("VirusFrame")
    local warning = vf and vf:FindFirstChild("Warning")
    local buttons = warning and warning:FindFirstChild("Buttons")
    if not buttons then return nil, nil end
    return buttons:FindFirstChild("Confirm"), buttons:FindFirstChild("Decline")
end

function adVirus_isVisible()
    local ok, result = pcall(function()
        local pg      = LocalPlayer:FindFirstChild("PlayerGui")
        local main    = pg and pg:FindFirstChild("Main")
        local vf      = main and main:FindFirstChild("VirusFrame")
        local warning = vf and vf:FindFirstChild("Warning")
        local buttons = warning and warning:FindFirstChild("Buttons")
        if not buttons then return false end
        local obj = buttons
        while obj and obj ~= pg do
            if obj:IsA("GuiObject") and not obj.Visible then return false end
            obj = obj.Parent
        end
        return true
    end)
    return ok and result
end

function adVirus_clickBtn(btn)
    if not btn then return false end
    if firesignal then
        pcall(function() firesignal(btn.MouseButton1Click) end)
        task.wait(0.05)
        pcall(function() firesignal(btn.Activated) end)
        task.wait(0.05)
    end
    pcall(function()
        local pos  = btn.AbsolutePosition
        local size = btn.AbsoluteSize
        local x    = pos.X + math.floor(size.X / 2)
        local y    = pos.Y + math.floor(size.Y / 2)
        VIM:SendMouseButtonEvent(x, y, 0, true,  game, 0)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
    return true
end

-- ══════════════════════════════════════════
--   CHEST DETECTION
-- ══════════════════════════════════════════

function ad_getChests()
    local chests = {}
    pcall(function()
        local gf = workspace:FindFirstChild("Game")
        if not gf then return end
        local d = gf:FindFirstChild("Destructibles")
        if not d then return end
        for _, obj in pairs(d:GetChildren()) do
            if obj.Name:find("Chest") then
                local p = obj:FindFirstChild("ProximityPrompt", true)
                if p and p:IsA("ProximityPrompt") then
                    table.insert(chests, { model = obj, prompt = p })
                end
            end
        end
    end)
    return chests
end

function ad_getNearestChest()
    local hrp = ad_getHRP()
    if not hrp then return nil end
    local chests = ad_getChests()
    local nearest, nearestDist = nil, math.huge
    for _, c in ipairs(chests) do
        local ok, d = pcall(function()
            return (c.model:GetPivot().Position - hrp.Position).Magnitude
        end)
        if ok and d < nearestDist then nearestDist = d; nearest = c end
    end
    return nearest
end

-- ══════════════════════════════════════════
--   SPELL GETTERS
-- ══════════════════════════════════════════

function ad_getEquippedSpellBySlot(slot)
    local inv = LocalPlayer:FindFirstChild("Inventory")
    if not inv then return nil end
    for _, i in pairs(inv:GetChildren()) do
        if i:GetAttribute("Type") == "Spell"
            and i:GetAttribute("Equipped") == true
            and i:GetAttribute("Slot") == slot then
            return i
        end
    end
end

function ad_getEquippedUltimate()
    return ad_getEquippedSpellBySlot("Ultimate")
end

-- ══════════════════════════════════════════
--   AUTO SELL HELPERS
-- ══════════════════════════════════════════

function adSell_normalizeMulti(value)
    local result = {}
    if type(value) ~= "table" then return result end
    for k, v in pairs(value) do
        if type(k) == "number" then result[tostring(v)] = true
        elseif v == true then result[tostring(k)] = true end
    end
    return result
end

function adSell_getRarityTable(category)
    if category == "Weapon"       then return ad_sell_weapon_rarities
    elseif category == "Armor"    then return ad_sell_armor_rarities
    elseif category == "Helmet"   then return ad_sell_helmet_rarities
    elseif category == "Spell"    then return ad_sell_spell_rarities
    elseif category == "Ultimate" then return ad_sell_ult_rarities
    end
    return {}
end

function adSell_hasRarityFilter(category)
    return next(adSell_getRarityTable(category)) ~= nil
end

function adSell_rarityAllowed(item, category)
    local rarity   = tostring(item:GetAttribute("Rarity") or "Common")
    local selected = adSell_getRarityTable(category)
    if not adSell_hasRarityFilter(category) then return true end
    return selected[rarity] == true
end

function adSell_isUltimateSpell(item)
    local data = ad_spellData[item.Name]
    return data and data.isUltimate == true
end

function adSell_matchesCategory(item, category)
    local itemType = item:GetAttribute("Type")
    if category == "Weapon"       then return itemType == "Weapon"
    elseif category == "Armor"    then return itemType == "Armor" and ad_isBodyArmorByName(item.Name)
    elseif category == "Helmet"   then return itemType == "Armor" and ad_isHelmetByName(item.Name)
    elseif category == "Spell"    then return itemType == "Spell" and not adSell_isUltimateSpell(item)
    elseif category == "Ultimate" then return itemType == "Spell" and adSell_isUltimateSpell(item)
    end
    return false
end

function adSell_canSellItem(item, category)
    if not item or not item.Parent then return false end
    if not adSell_matchesCategory(item, category) then return false end
    if not adSell_rarityAllowed(item, category) then return false end
    if ad_sell_skip_equipped  and item:GetAttribute("Equipped")  == true then return false end
    if ad_sell_skip_favorites and item:GetAttribute("Favorite")  == true then return false end
    return true
end

function adSell_collect(category)
    local inv = LocalPlayer:FindFirstChild("Inventory")
    if not inv then return {} end
    local items = {}
    for _, item in ipairs(inv:GetChildren()) do
        if adSell_canSellItem(item, category) then table.insert(items, item) end
    end
    table.sort(items, function(a, b)
        local ra = ad_rarityRank[a:GetAttribute("Rarity") or "Common"] or 0
        local rb = ad_rarityRank[b:GetAttribute("Rarity") or "Common"] or 0
        if ra ~= rb then return ra < rb end
        if a.Name ~= b.Name then return a.Name < b.Name end
        local la = a:GetAttribute("Level") or 0
        local lb = b:GetAttribute("Level") or 0
        if la ~= lb then return la < lb end
        return tostring(a:GetAttribute("ItemId") or "") < tostring(b:GetAttribute("ItemId") or "")
    end)
    return items
end

function adSell_fireBatch(items)
    local batch = {}
    for i = 1, math.min(2, #items) do
        local item = items[i]
        if item and item.Parent then table.insert(batch, item) end
    end
    if #batch == 0 then return 0 end
    local ok = pcall(function() ad_Equip:FireServer("Sell", batch) end)
    return ok and #batch or 0
end

function adSell_sellOneBatch(category)
    local items = adSell_collect(category)
    if #items == 0 then return 0 end
    return adSell_fireBatch(items)
end

function adSell_anyEnabled()
    return isOn("AutoSellWeapon") or isOn("AutoSellArmor") or isOn("AutoSellHelmet")
        or isOn("AutoSellSpell") or isOn("AutoSellUltimate")
end

-- ══════════════════════════════════════════
--   TEXT HELPERS & FORMATTING
-- ══════════════════════════════════════════

function c(t, col)
    if not col or col == "" then return t end
    return string.format('<font color="%s">%s</font>', col, t)
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
    Footer           = "Prism  |  Anime Dungeons  |  v5.2",
    Icon             = "rbxassetid://117487160988921",
    MobileButtonSide = "Right",
    NotifySide       = "Right",
    ShowCustomCursor = false,
    CornerRadius     = 2,
    Animations = {
        ToggleWindow    = false,
        TabSwitch       = true,
        Groupbox        = false,
        Dropdown        = true,
        KeyPicker       = true,
        SubTabUnderline = true,
    },
})

-- ══════════════════════════════════════════
--   TABS & SUBTABS
-- ══════════════════════════════════════════

local Tabs = {
    Info     = Window:AddTab("Info",      "activity"),
    Main     = Window:AddTab("Main",      "zap"),
    Combat   = Window:AddTab("Combat",    "swords"),
    Farm     = Window:AddTab("Farm",      "target"),
    Equip    = Window:AddTab("Equipment", "shield"),
    AutoSell = Window:AddTab("Auto Sell", "coins"),
    Quests   = Window:AddTab("Quests",    "scroll-text"),
    Webhook  = Window:AddTab("Webhook",   "webhook"),
    Player   = Window:AddTab("Player",    "user-check"),
    Settings = Window:AddTab("Settings",  "settings"),
}

Tabs.Dungeon = Tabs.Main:AddSubTab("Dungeon", "map")
Tabs.Stats   = Tabs.Main:AddSubTab("Stats",   "chart-column-big")
Tabs.Chests  = Tabs.Main:AddSubTab("Chests",  "gift")
Tabs.Virus   = Tabs.Main:AddSubTab("Virus",   "shield-alert")
Tabs.Spins   = Tabs.Main:AddSubTab("Spins",   "refresh-cw")

Tabs.Weapon   = Tabs.Combat:AddSubTab("Attack",   "swords")
Tabs.Spells   = Tabs.Combat:AddSubTab("Spells",   "flame")
Tabs.Ultimate = Tabs.Combat:AddSubTab("Ultimate", "zap")

Tabs.WeaponEq = Tabs.Equip:AddSubTab("Weapon",   "swords")
Tabs.ArmorEq  = Tabs.Equip:AddSubTab("Armor",    "shield")
Tabs.HelmetEq = Tabs.Equip:AddSubTab("Helmet",   "hard-hat")
Tabs.SpellsEq = Tabs.Equip:AddSubTab("Spells",   "flame")
Tabs.UltEq    = Tabs.Equip:AddSubTab("Ultimate", "zap")
Tabs.HeroesEq = Tabs.Equip:AddSubTab("Heroes",   "users")

Tabs.HourlyQ = Tabs.Quests:AddSubTab("Hourly",   "clock")
Tabs.DailyQ  = Tabs.Quests:AddSubTab("Daily",    "sun")
Tabs.WeeklyQ = Tabs.Quests:AddSubTab("Weekly",   "calendar")
Tabs.AllQ    = Tabs.Quests:AddSubTab("Claim All","zap")

Tabs.WebhookSetup  = Tabs.Webhook:AddSubTab("Setup",   "settings")
Tabs.WebhookFilter = Tabs.Webhook:AddSubTab("Filters", "funnel-plus")
Tabs.WebhookTest   = Tabs.Webhook:AddSubTab("Test",    "send")

-- ══════════════════════════════════════════
--   INFO TAB
-- ══════════════════════════════════════════

do
    local PrismBox = Tabs.Info:AddLeftGroupbox("Prism", "sparkles")
    PrismBox:AddLabel(sz(b(createMultiGradientText("PRISM", PALETTE.prism)), 20), true)
    PrismBox:AddLabel(c(i("keyless forever, always will be"), "#9ca3af"), true)
    PrismBox:AddLabel(
        c(b("status "),  "#6b7280") .. c(b("online"), "#4ade80") ..
        c("     ",       "#374151") ..
        c(b("version "), "#6b7280") .. c(b("5.2"), "#38bdf8"),
    true)
    PrismBox:AddDivider()
    PrismBox:AddLabel(sz(b(createMultiGradientText("if you enjoy the script or want to report a bug, please consider the following:", PALETTE.ice)), 14), true)
    PrismBox:AddLabel(sz(b(createMultiGradientText("more than 60 keyless scripts in this hub, I would love your support!", PALETTE.ice)), 14), true)
    PrismBox:AddButton({ Text = "Discord for Support 💝", Func = function() copyText(DISCORD_INVITE, "Discord invite copied!") end })
    PrismBox:AddButton({ Text = "Follow Rscripts 🙏", Func = function() copyText(RSCRIPTS_LINK, "Rscripts link copied!") end })

    local FeaturesBox = Tabs.Info:AddLeftGroupbox("Features", "layers")
    local featureList = {
        "Auto Farm Mobs",
        "Auto Open Chests",
        "Auto Melee Strike",
        "Auto Skills Rotation",
        "Auto Ultimate",
        "Auto Equip Best Gear",
        "Auto Claim Quests",
        "Auto Sell Loot",
        "Discord Webhook for Rewards",
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
                local ping = math.floor(StatsService and StatsService.PerformanceStats.Ping:GetValue() or 0)
                local mem  = math.floor(StatsService and StatsService:GetTotalMemoryUsageMb() or 0)
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
--   MAIN > DUNGEON
-- ══════════════════════════════════════════

do
    local DG = Tabs.Dungeon:AddLeftGroupbox("Dungeon Control", "map")
    DG:AddToggle("AutoStartDungeon", { Text = "Auto Start Dungeon",   Default = false, Tooltip = "Fires StartDungeon once when lobby is ready" })
    DG:AddToggle("AutoReplay",       { Text = "Smart Instant Replay", Default = false, Tooltip = "Replays the instant victory screen appears" })
    DG:AddDivider()
    DG:AddButton({ Text = "Start Dungeon Once",  Func = function() pcall(function() ad_StartDungeon:FireServer() end) Library:Notify("Dungeon started!") end })
    DG:AddButton({ Text = "Replay Dungeon Once", Func = function() pcall(function() ad_Dungeon:FireServer("PlayAgain") end) Library:Notify("Replay fired!") end })

    local StatsGroup = Tabs.Dungeon:AddRightGroupbox("Live Stats", "trending-up")
    local LevelLabel   = StatsGroup:AddLabel(b("Level: ") .. c("...", "#60a5fa"), true)
    local GoldLabel    = StatsGroup:AddLabel(b("Gold: ")  .. c("...", "#fbbf24"), true)
    local GemsLabel    = StatsGroup:AddLabel(b("Gems: ")  .. c("...", "#a78bfa"), true)
    local TargetLabel  = StatsGroup:AddLabel(b("Target: ") .. c("None", "#ef4444"), true)
    StatsGroup:AddDivider()
    local DungeonsLabel = StatsGroup:AddLabel(b("Dungeons Completed: ") .. c("0", "#4ade80"), true)
    local GoldGainedLabel = StatsGroup:AddLabel(b("Gold Gained: ") .. c("0", "#fbbf24"), true)
    local GemsGainedLabel = StatsGroup:AddLabel(b("Gems Gained: ") .. c("0", "#a78bfa"), true)
    local ItemsObtainedLabel = StatsGroup:AddLabel(b("Items Obtained: ") .. c("0", "#f472b6"), true)
    local EnemiesDefeatedLabel = StatsGroup:AddLabel(b("Enemies Defeated: ") .. c("0", "#ef4444"), true)

    task.spawn(function()
        while not Library.Unloaded do
            task.wait(2)
            local ps = LocalPlayer:FindFirstChild("PlayerStats")
            local lvl = ps and ps:FindFirstChild("Level") and ps.Level.Value or 0
            local gold = ps and ps:FindFirstChild("Gold") and ps.Gold.Value or 0
            local gems = ps and ps:FindFirstChild("Gems") and ps.Gems.Value or 0
            local targetName = "None"
            if currentTarget then
                targetName = currentTarget.Name
            end

            LevelLabel:SetText(b("Level: ") .. c(formatNumber(lvl), "#60a5fa"))
            GoldLabel:SetText(b("Gold: ") .. c(formatNumber(gold), "#fbbf24"))
            GemsLabel:SetText(b("Gems: ") .. c(formatNumber(gems), "#a78bfa"))
            TargetLabel:SetText(b("Target: ") .. c(targetName, "#ef4444"))

            DungeonsLabel:SetText(b("Dungeons Completed: ") .. c(formatNumber(SessionStats.dungeonsRun), "#4ade80"))
            GoldGainedLabel:SetText(b("Gold Gained: ") .. c(formatNumber(SessionStats.goldGained), "#fbbf24"))
            GemsGainedLabel:SetText(b("Gems Gained: ") .. c(formatNumber(SessionStats.gemsGained), "#a78bfa"))
            ItemsObtainedLabel:SetText(b("Items Obtained: ") .. c(formatNumber(SessionStats.itemsObtained), "#f472b6"))
            EnemiesDefeatedLabel:SetText(b("Enemies Defeated: ") .. c(formatNumber(SessionStats.enemiesDefeated), "#ef4444"))
        end
    end)
end

-- ══════════════════════════════════════════
--   MAIN > STATS
-- ══════════════════════════════════════════

do
    local SG = Tabs.Stats:AddLeftGroupbox("Stat Points", "chart-column-big")
    SG:AddDropdown("StatSelect", {
        Values = { "Strength", "Magic", "Health" }, Default = "Strength", Text = "Stat to Level Up",
        Callback = function(v) ad_selected_stat = v end,
    })
    SG:AddToggle("AutoStatPoint", { Text = "Auto Allocate Stat Points", Default = false })
end

-- ══════════════════════════════════════════
--   MAIN > CHESTS
-- ══════════════════════════════════════════

do
    local CG = Tabs.Chests:AddLeftGroupbox("Golden Chests", "gift")
    CG:AddToggle("AutoChest", { Text = "Auto Open Golden Chests", Default = false })
    CG:AddDivider()
    CG:AddButton({ Text = "Open Nearest Chest Once", Func = function()
        task.spawn(function()
            local chest = ad_getNearestChest()
            if not chest then Library:Notify("No chests found!"); return end
            pcall(function()
                chest.prompt.MaxActivationDistance = 99999
                chest.prompt.RequiresLineOfSight   = false
                chest.prompt.HoldDuration          = 0
                chest.prompt.Enabled               = true
            end)
            pcall(function()
                local cp = chest.model:GetPivot().Position
                local hrp = ad_getHRP()
                if hrp then
                    hrp.CFrame = CFrame.new(cp + Vector3.new(0, 3, 0), cp)
                end
            end)
            task.wait(0.2)
            for _ = 1, 50 do
                pcall(function()
                    if chest.prompt and chest.prompt.Parent then
                        fireproximityprompt(chest.prompt, 0)
                    end
                end)
                task.wait()
            end
            Library:Notify("Opened chest!")
        end)
    end })
end

-- ══════════════════════════════════════════
--   MAIN > VIRUS
-- ══════════════════════════════════════════

do
    local VG = Tabs.Virus:AddLeftGroupbox("Virus Auto Handler", "shield-alert")
    VG:AddDropdown("VirusAction", {
        Values = { "Engage", "Escape" }, Default = "Engage", Text = "Virus Action",
        Tooltip = "Engage = click Confirm | Escape = click Decline",
        Callback = function(v) ad_virus_action = v end,
    })
    VG:AddToggle("AutoVirus", { Text = "Auto Handle Virus", Default = false })
    VG:AddDivider()
    VG:AddButton({ Text = "Engage Virus Once", Func = function()
        local confirm, _ = adVirus_getButtons()
        if not confirm then Library:Notify("Prompt not visible!"); return end
        adVirus_clickBtn(confirm) Library:Notify("Confirmed virus!")
    end })
    VG:AddButton({ Text = "Escape Virus Once", Func = function()
        local _, decline = adVirus_getButtons()
        if not decline then Library:Notify("Prompt not visible!"); return end
        adVirus_clickBtn(decline) Library:Notify("Declined virus!")
    end })
end

-- ══════════════════════════════════════════
--   MAIN > SPINS
-- ══════════════════════════════════════════

do
    local SG = Tabs.Spins:AddLeftGroupbox("Spins", "refresh-cw")
    SG:AddToggle("AutoDailySpin",    { Text = "Auto Claim Daily Spin",  Default = false })
    SG:AddToggle("AutoCosmeticSpin", { Text = "Auto Cosmetic Spin",     Default = false })
    SG:AddDivider()
    SG:AddButton({ Text = "Claim Daily Spin Once", Func = function()
        task.spawn(function()
            local ok, err = pcall(function() ad_DailySpin:InvokeServer("Claim") end)
            Library:Notify(ok and "Daily Spin claimed!" or ("Error: " .. tostring(err)))
        end)
    end })
    SG:AddButton({ Text = "Cosmetic Spin Once", Func = function()
        task.spawn(function()
            local ok, err = pcall(function() ad_CosmeticSpin:InvokeServer() end)
            Library:Notify(ok and "Cosmetic Spin complete!" or ("Error: " .. tostring(err)))
        end)
    end })
end

-- ══════════════════════════════════════════
--   COMBAT > ATTACK
-- ══════════════════════════════════════════

do
    local WG = Tabs.Weapon:AddLeftGroupbox("Weapon Attack", "swords")
    WG:AddToggle("AutoAttack", { Text = "Auto Attack", Default = false })

    local CIG = Tabs.Weapon:AddRightGroupbox("Combat Info", "info")
    CIG:AddButton({ Text = "Show Enemy Count", Func = function()
        Library:Notify("Active enemies: " .. #adf_getEnemies())
    end })
end

-- ══════════════════════════════════════════
--   COMBAT > SPELLS
-- ══════════════════════════════════════════

do
    local SG = Tabs.Spells:AddLeftGroupbox("Auto Spells", "flame")
    SG:AddToggle("AutoSpell", { Text = "Auto Use Spells", Default = false })
end

-- ══════════════════════════════════════════
--   COMBAT > ULTIMATE
-- ══════════════════════════════════════════

do
    local UG = Tabs.Ultimate:AddLeftGroupbox("Auto Use Ultimate", "zap")
    UG:AddToggle("AutoUltimate", { Text = "Auto Use Ultimate", Default = false })
end

-- ══════════════════════════════════════════
--   FARM TAB (EXACT 1:1 WITH DUNGEONS LOOTR)
-- ══════════════════════════════════════════

do
    local FG = Tabs.Farm:AddLeftGroupbox("Mob Farm Engine", "target")
    FG:AddLabel(b("FARM POSITIONING"), true)
    FG:AddDivider()
    FG:AddToggle("AutoFarm", { Text = "Auto Farm Mobs", Default = false })
    FG:AddDropdown("FarmMode", {
        Values   = { "Above Head", "Orbiting", "Behind", "Same Level", "Under" },
        Default  = "Above Head",
        Text     = "Relative Positioning",
        Callback = function(v) ad_farm_mode = v; adf_orbitAngle = 0 end,
    })
    FG:AddDropdown("FarmMethod", {
        Values   = { "Teleport", "Tween" },
        Default  = "Teleport",
        Text     = "Movement Type",
        Callback = function(v) ad_farm_method = v end,
    })
    FG:AddSlider("FarmHeight", { Text = "Target Height Offset", Default = 11, Min = -30, Max = 50, Rounding = 0, Callback = function(v) ad_farm_height = v end })
    FG:AddSlider("TweenSpeed", { Text = "Tween Transition Speed", Default = 95, Min = 20, Max = 250, Rounding = 0, Callback = function(v) ad_tween_speed = v end })

    local Ob = Tabs.Farm:AddRightGroupbox("Orbit Offsets", "compass")
    Ob:AddLabel(b("ORBIT CONTROLS"), true)
    Ob:AddDivider()
    Ob:AddSlider("OrbitRadius", { Text = "Orbit Radius", Default = 14, Min = 5, Max = 50, Rounding = 0, Callback = function(v) ad_farm_orbit_radius = v end })
    Ob:AddSlider("OrbitSpeed",  { Text = "Orbit Rotational Speed", Default = 1.8, Min = 0.5, Max = 10, Rounding = 1, Callback = function(v) ad_farm_orbit_speed = v end })
end

Toggles.AutoFarm:OnChanged(function(v)
    if v then
        adf_orbitAngle = 0
        adf_startMovement()
        Library:Notify("Auto Farm ON (" .. ad_farm_mode .. ")")
    else
        adf_stopMovement()
        Library:Notify("Auto Farm OFF")
    end
end)

-- ══════════════════════════════════════════
--   EQUIPMENT SUBTABS
-- ══════════════════════════════════════════

local priorityValues = { "Tank", "Warrior", "Magic", "Balanced" }

do
    local WG = Tabs.WeaponEq:AddLeftGroupbox("Weapon Assignment", "swords")
    WG:AddDropdown("WeaponPriority", { Values = priorityValues, Default = "Balanced", Text = "Weapon Priority", Callback = function(v) ad_weapon_priority = v end })
    WG:AddToggle("AutoEquipWeapon", { Text = "Auto Equip Best Weapon", Default = false })
    WG:AddDivider()
    WG:AddButton({ Text = "Equip Best Weapon Once", Func = function()
        task.spawn(function()
            ad_equipDoneWeapon = false
            Library:Notify("Equipping weapon...")
            local r = adeq_doEquipWeapon(ad_weapon_priority)
            ad_equipDoneWeapon = true
            Library:Notify("Equipped: " .. (r or "None"))
        end)
    end })
end

do
    local AG = Tabs.ArmorEq:AddLeftGroupbox("Body Armor Assignment", "shield")
    AG:AddDropdown("ArmorPriority", { Values = priorityValues, Default = "Balanced", Text = "Armor Priority", Callback = function(v) ad_armor_priority = v end })
    AG:AddToggle("AutoEquipArmor", { Text = "Auto Equip Best Armor", Default = false })
    AG:AddDivider()
    AG:AddButton({ Text = "Equip Best Armor Once", Func = function()
        task.spawn(function()
            ad_equipDoneArmor = false
            Library:Notify("Equipping armor...")
            local r = adeq_doEquipArmor(ad_armor_priority)
            ad_equipDoneArmor = true
            Library:Notify("Equipped: " .. (r or "None"))
        end)
    end })
end

do
    local HG = Tabs.HelmetEq:AddLeftGroupbox("Head Gear Assignment", "hard-hat")
    HG:AddDropdown("HelmetPriority", { Values = priorityValues, Default = "Balanced", Text = "Helmet Priority", Callback = function(v) ad_helmet_priority = v end })
    HG:AddToggle("AutoEquipHelmet", { Text = "Auto Equip Best Helmet", Default = false })
    HG:AddDivider()
    HG:AddButton({ Text = "Equip Best Helmet Once", Func = function()
        task.spawn(function()
            ad_equipDoneHelmet = false
            Library:Notify("Equipping helmet...")
            local r = adeq_doEquipHelmet(ad_helmet_priority)
            ad_equipDoneHelmet = true
            Library:Notify("Equipped: " .. (r or "None"))
        end)
    end })
end

do
    local SG = Tabs.SpellsEq:AddLeftGroupbox("Spell Assignment", "flame")
    SG:AddToggle("AutoEquipSpells", { Text = "Auto Equip Best Spells", Default = false })
    SG:AddDivider()
    SG:AddButton({ Text = "Equip Best Spells Once", Func = function()
        task.spawn(function()
            ad_equipDoneSpells = false
            Library:Notify("Equipping spells...")
            local r = adeq_doEquipSpells()
            ad_equipDoneSpells = true
            Library:Notify("Spells: " .. (#r > 0 and table.concat(r, ", ") or "None"))
        end)
    end })
end

do
    local UG = Tabs.UltEq:AddLeftGroupbox("Ultimate Assignment", "zap")
    UG:AddToggle("AutoEquipUltimate", { Text = "Auto Equip Best Ultimate", Default = false })
    UG:AddDivider()
    UG:AddButton({ Text = "Equip Best Ultimate Once", Func = function()
        task.spawn(function()
            ad_equipDoneUlt = false
            Library:Notify("Equipping ultimate...")
            local r = adeq_doEquipUltimate()
            ad_equipDoneUlt = true
            Library:Notify("Ultimate: " .. (r or "None"))
        end)
    end })
end

do
    local HG = Tabs.HeroesEq:AddLeftGroupbox("Hero Assembly (4 Slots)", "users")
    HG:AddDropdown("HeroPriority", { Values = priorityValues, Default = "Tank", Text = "Hero Priority", Callback = function(v) ad_hero_priority = v end })
    HG:AddToggle("AutoEquipHeroes", { Text = "Auto Equip Best Heroes", Default = false })
    HG:AddDivider()
    HG:AddButton({ Text = "Equip Best Heroes Once", Func = function()
        task.spawn(function()
            ad_equipDoneHeroes = false
            Library:Notify("Equipping heroes...")
            local r = adeq_doEquipHeroes(ad_hero_priority)
            ad_equipDoneHeroes = true
            Library:Notify("Heroes: " .. (#r > 0 and table.concat(r, ", ") or "None"))
        end)
    end })
    HG:AddButton({ Text = "Copy Hero Stats", Func = function()
        local heroes = adeq_collect("Hero")
        adeq_sort(heroes, ad_hero_priority)
        local lines = { "Heroes (" .. ad_hero_priority .. "):" }
        for i, h in ipairs(heroes) do
            local eq   = h:GetAttribute("Equipped") == true
            local slot = h:GetAttribute("Slot") or ""
            table.insert(lines,
                "#" .. i .. " " .. h.Name .. (eq and " [EQ:" .. slot .. "]" or "") ..
                " STR=" .. string.format("%.1f", adeq_oldSTR(h)) ..
                " HP="  .. string.format("%.1f", adeq_oldHP(h))  ..
                " MAG=" .. string.format("%.1f", adeq_oldMAG(h)) ..
                " Loaded=" .. tostring(adeq_isLoaded(h))
            )
        end
        copyText(table.concat(lines, "\n"), "Hero stats copied to clipboard")
    end })
end

-- ══════════════════════════════════════════
--   AUTO SELL TAB
-- ══════════════════════════════════════════

do
    local SF = Tabs.AutoSell:AddLeftGroupbox("Rarity Filters", "funnel-plus")
    SF:AddLabel("If no rarity is checked, all items inside that category sell.", true)
    SF:AddLabel("Equipped and favorited items are protected and skipped.", true)
    SF:AddDivider()
    local rarityValues = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret" }
    SF:AddDropdown("SellWeaponRarities",   { Values = rarityValues, Default = {}, Multi = true, Text = "Weapon Rarities",   Callback = function(v) ad_sell_weapon_rarities  = adSell_normalizeMulti(v) end })
    SF:AddDropdown("SellArmorRarities",    { Values = rarityValues, Default = {}, Multi = true, Text = "Armor Rarities",    Callback = function(v) ad_sell_armor_rarities   = adSell_normalizeMulti(v) end })
    SF:AddDropdown("SellHelmetRarities",   { Values = rarityValues, Default = {}, Multi = true, Text = "Helmet Rarities",   Callback = function(v) ad_sell_helmet_rarities  = adSell_normalizeMulti(v) end })
    SF:AddDropdown("SellSpellRarities",    { Values = rarityValues, Default = {}, Multi = true, Text = "Spell Rarities",    Callback = function(v) ad_sell_spell_rarities   = adSell_normalizeMulti(v) end })
    SF:AddDropdown("SellUltimateRarities", { Values = rarityValues, Default = {}, Multi = true, Text = "Ultimate Rarities", Callback = function(v) ad_sell_ult_rarities     = adSell_normalizeMulti(v) end })
    SF:AddSlider("SellBatchDelay", { Text = "Batch Process Delay", Default = 0.20, Min = 0.05, Max = 2, Rounding = 2, Callback = function(v) ad_sell_batch_delay = v end })

    local ST = Tabs.AutoSell:AddRightGroupbox("Auto Sell Categories", "coins")
    ST:AddToggle("AutoSellWeapon",   { Text = "Auto Sell Weapons",   Default = false })
    ST:AddToggle("AutoSellArmor",    { Text = "Auto Sell Armors",    Default = false })
    ST:AddToggle("AutoSellHelmet",   { Text = "Auto Sell Helmets",   Default = false })
    ST:AddToggle("AutoSellSpell",    { Text = "Auto Sell Spells",    Default = false })
    ST:AddToggle("AutoSellUltimate", { Text = "Auto Sell Ultimates", Default = false })
end

-- ══════════════════════════════════════════
--   QUESTS
-- ══════════════════════════════════════════

do
    local HG = Tabs.HourlyQ:AddLeftGroupbox("Hourly Challenges", "clock")
    HG:AddToggle("AutoQuestHourly", { Text = "Auto Claim Hourly Quests", Default = false })
    HG:AddDivider()
    HG:AddButton({ Text = "Claim All Hourly Now", Func = function()
        task.spawn(function() Library:Notify("Fired " .. adQuest_claimHourly() .. " claims") end)
    end })
end

do
    local DG = Tabs.DailyQ:AddLeftGroupbox("Daily Challenges", "sun")
    DG:AddToggle("AutoQuestDaily", { Text = "Auto Claim Daily Quests", Default = false })
    DG:AddDivider()
    DG:AddButton({ Text = "Claim All Daily Now", Func = function()
        task.spawn(function() Library:Notify("Fired " .. adQuest_claimDaily() .. " claims") end)
    end })
end

do
    local WG = Tabs.WeeklyQ:AddLeftGroupbox("Weekly Challenges", "calendar")
    WG:AddToggle("AutoQuestWeekly", { Text = "Auto Claim Weekly Quests", Default = false })
    WG:AddDivider()
    WG:AddButton({ Text = "Claim All Weekly Now", Func = function()
        task.spawn(function() Library:Notify("Fired " .. adQuest_claimWeekly() .. " claims") end)
    end })
end

do
    local AG = Tabs.AllQ:AddLeftGroupbox("Mass Quest Claim", "zap")
    AG:AddButton({ Text = "Claim All Quests Now", Func = function()
        task.spawn(function()
            local h = adQuest_claimHourly()
            local d = adQuest_claimDaily()
            local w = adQuest_claimWeekly()
            Library:Notify("Claims Processed -> Hourly: " .. h .. " | Daily: " .. d .. " | Weekly: " .. w)
        end)
    end })
end

-- ══════════════════════════════════════════
--   WEBHOOK SETUP
-- ══════════════════════════════════════════

do
    local WS = Tabs.WebhookSetup:AddLeftGroupbox("Webhook Setup", "webhook")
    WS:AddLabel("Input your Discord Webhook below:", true)
    WS:AddInput("WebhookURL", {
        Default = "", Numeric = false, Finished = false, ClearTextOnFocus = false,
        Text = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(v) wh_url = v end,
    })
    WS:AddDivider()
    WS:AddLabel("Input your Discord User ID below:", true)
    WS:AddInput("WebhookUserID", {
        Default = "", Numeric = true, Finished = false, ClearTextOnFocus = false,
        Text = "Discord User ID", Placeholder = "123456789012345678",
        Callback = function(v) wh_userId = v end,
    })
    WS:AddDivider()
    WS:AddButton({ Text = "Validate Webhook Configuration", Func = function()
        if wh_url == "" then Library:Notify("Please input a URL!"); return end
        if not wh_url:find("discord") then Library:Notify("URL format invalid!"); return end
        Library:Notify("URL Saved and Configured!")
    end })
end

-- ══════════════════════════════════════════
--   WEBHOOK FILTERS
-- ══════════════════════════════════════════

do
    local WF = Tabs.WebhookFilter:AddLeftGroupbox("Ping Filters", "bell")
    WF:AddToggle("WebhookPingEnabled", {
        Text = "Enable Discord Ping", Default = false,
        Callback = function(v) wh_pingEnabled = v end,
    })
    WF:AddDropdown("WebhookPingRarities", {
        Values = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret" },
        Default = {}, Multi = true, Text = "Ping Rarity Filters",
        Callback = function(v)
            wh_pingRarities = {}
            if type(v) == "table" then
                for k, val in pairs(v) do
                    if type(k) == "number" then wh_pingRarities[tostring(val)] = true
                    elseif val == true     then wh_pingRarities[tostring(k)]   = true end
                end
            end
        end,
    })
    WF:AddDropdown("WebhookPingCategories", {
        Values = { "Weapon", "Armor", "Helmet", "Spell", "Ultimate" },
        Default = { "Weapon", "Armor", "Helmet", "Spell", "Ultimate" }, Multi = true, Text = "Ping Item Type Filters",
        Tooltip = "Only items matching the selected types will trigger a user ping",
        Callback = function(v)
            wh_pingCategories = {}
            if type(v) == "table" then
                for k, val in pairs(v) do
                    if type(k) == "number" then wh_pingCategories[tostring(val)] = true
                    elseif val == true     then wh_pingCategories[tostring(k)]   = true end
                end
            end
        end,
    })

    local WFR = Tabs.WebhookFilter:AddRightGroupbox("Tracked Metrics", "list")
    local metrics = { "All Dropped Items", "Gold Received", "Gems Received", "EXP Received", "Enemies Defeated", "Viruses Cleared", "Current Character Level" }
    for _, t in ipairs(metrics) do WFR:AddLabel("[+] " .. t, true) end
end

-- ══════════════════════════════════════════
--   WEBHOOK TEST
-- ══════════════════════════════════════════

do
    local WT = Tabs.WebhookTest:AddLeftGroupbox("Test Webhook", "send")
    WT:AddButton({ Text = "Send Simple Test Message", Func = function()
        if wh_url == "" then Library:Notify("Webhook URL is empty!"); return end
        task.spawn(function()
            local data = {
                embeds = {{
                    title       = "Webhook Active",
                    description = "Your Webhook setup is correctly configured and working!",
                    color       = 65535,
                    fields      = {
                        { name = "Player", value = "```" .. LocalPlayer.Name .. "```", inline = true },
                        { name = "Ping",   value = "```" .. (wh_userId ~= "" and "Configured" or "Disabled") .. "```", inline = true },
                    },
                    footer    = { text = "Prism  •  " .. os.date("%x %X") },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                }}
            }
            local ok, err = pcall(function()
                wh_requestFunc({ Url = wh_url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(data) })
            end)
            Library:Notify(ok and "Test processed, check Discord" or "Error: " .. tostring(err))
        end)
    end })

    WT:AddButton({ Text = "Simulate Run Complete", Func = function()
        if wh_url == "" then Library:Notify("Webhook URL is empty!"); return end
        task.spawn(function()
            local fakeItems = {
                { Name = "GoldenKatana", Rarity = "Legendary", Category = "Weapon" },
                { Name = "DreamLamp",    Rarity = "Rare",      Category = "Spell" },
                { Name = "SteelDagger",  Rarity = "Common",    Category = "Weapon" },
            }
            local itemLines = {}
            for _, item in ipairs(fakeItems) do
                table.insert(itemLines, wh_rarityEmoji(item.Rarity) .. " **" .. item.Name .. "** ─ *" .. item.Rarity .. "*")
            end

            local shouldPingSim = false
            if wh_pingEnabled and wh_userId ~= "" then
                for _, item in ipairs(fakeItems) do
                    if wh_shouldPingForItem(item.Rarity, item.Category) then shouldPingSim = true break end
                end
            end

            local pingContent = shouldPingSim and ("<@" .. wh_userId .. "> (Simulation)") or ""
            local data = {
                content = pingContent,
                embeds  = {{
                    title       = "Dungeon Complete! (Simulation)",
                    description = "━━━━━━━━━━━━━━━━━━━━━━━━━━",
                    color       = wh_rarityColor("Legendary"),
                    fields      = {
                        { name = "Player",          value = "```" .. LocalPlayer.Name .. "```", inline = true  },
                        { name = "Level",            value = "```42```",                         inline = true  },
                        { name = "‎",                    value = "‎",                                  inline = false },
                        { name = "Gold Earned",      value = "```+12.5K```",                     inline = true  },
                        { name = "Gems Earned",      value = "```+3```",                          inline = true  },
                        { name = "EXP Gained",       value = "```+8.2K```",                       inline = true  },
                        { name = "Enemies Killed",   value = "```47```",                          inline = true  },
                        { name = "Viruses Defeated", value = "```2```",                           inline = true  },
                        { name = "‎",                    value = "‎",                                  inline = false },
                        { name = "Items Dropped",    value = table.concat(itemLines, "\n"),       inline = false },
                    },
                    footer    = { text = "Prism  •  Anime Dungeons  •  " .. os.date("%x %X") },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                }}
            }
            local ok, err = pcall(function()
                wh_requestFunc({ Url = wh_url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(data) })
            end)
            Library:Notify(ok and "Simulation complete, check Discord" or "Error: " .. tostring(err))
        end)
    end })

    WT:AddDivider()
    local WHStatusLabel = WT:AddLabel("URL: None | Ping: Off", true)
    task.spawn(function()
        while not Library.Unloaded do
            task.wait(1)
            local urlStatus  = wh_url ~= "" and c("URL: Set", "#4ade80") or c("URL: Not Set", "#ff6b6b")
            local pingStatus = wh_pingEnabled and c("Ping: ON", "#4ade80") or c("Ping: OFF", "#9ca3af")
            local idStatus   = wh_userId ~= "" and c("ID: Set", "#4ade80") or c("ID: Not Set", "#9ca3af")
            WHStatusLabel:SetText(urlStatus .. "  |  " .. pingStatus .. "  |  " .. idStatus)
        end
    end)
end

-- ══════════════════════════════════════════
--   PLAYER TAB
-- ══════════════════════════════════════════

local FLYING = false
local QEfly = true
local iyflyspeed = 1
local vehicleflyspeed = 1
local flyKeyDown, flyKeyUp

local currentWalkSpeed = 16
local currentJumpPower = 50
local currentFlySpeed  = 60

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

    local T = ad_getHRP()
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

                local activeSpeed = getNumber("FlySpeed", 60)

                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = activeSpeed
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
    FlyGroup:AddSlider("JumpPower",        { Text = "Jump Value", Default = 50, Min = 50, Max = 300, Rounding = 0, Callback = function(v) currentJumpPower = v end })
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("InfJump", { Text = "Infinite Jump", Default = false })
    FlyGroup:AddToggle("NoClip",  { Text = "NoClip", Default = false })
end

-- ══════════════════════════════════════════
--   SETTINGS TAB
-- ══════════════════════════════════════════

do
    local PerfGroup = Tabs.Settings:AddLeftGroupbox("Performance", "cpu")

local fpsBoostStateCache = {}
local isFPSBoostActive = false

local function applyFPSBoost(enabled)
    pcall(function()
        local Lighting = game:GetService("Lighting")

        if enabled then
            if isFPSBoostActive then return end
            isFPSBoostActive = true
            table.clear(fpsBoostStateCache)

            -- Save and disable GlobalShadows
            fpsBoostStateCache["GlobalShadows"] = Lighting.GlobalShadows
            Lighting.GlobalShadows = false

            -- Save ONLY what is currently enabled before disabling
            for _, v in ipairs(Lighting:GetChildren()) do
                if (v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky")) and v.Enabled then
                    fpsBoostStateCache[v] = true
                    v.Enabled = false
                end
            end

            for _, desc in ipairs(workspace:GetDescendants()) do
                if (desc:IsA("ParticleEmitter") or desc:IsA("Trail") or desc:IsA("Smoke") or desc:IsA("Fire") or desc:IsA("Sparkles")) and desc.Enabled then
                    fpsBoostStateCache[desc] = true
                    desc.Enabled = false
                elseif desc:IsA("BasePart") and desc.CastShadow then
                    fpsBoostStateCache[desc] = true
                    desc.CastShadow = false
                end
            end
        else
            if not isFPSBoostActive then return end
            isFPSBoostActive = false

            -- Restore GlobalShadows to original state
            if fpsBoostStateCache["GlobalShadows"] ~= nil then
                Lighting.GlobalShadows = fpsBoostStateCache["GlobalShadows"]
            end

            -- ONLY restore instances that were originally active
            for obj, wasActive in pairs(fpsBoostStateCache) do
                if typeof(obj) == "Instance" and obj.Parent then
                    pcall(function()
                        if obj:IsA("BasePart") then
                            obj.CastShadow = true
                        else
                            obj.Enabled = true
                        end
                    end)
                end
            end

            table.clear(fpsBoostStateCache)
        end
    end)
end

    PerfGroup:AddLabel(b(createMultiGradientText("OPTIMIZATION", PALETTE.aurora)), true)
    PerfGroup:AddDivider()

    PerfGroup:AddToggle("PotatoMode", {
        Text = "Disable 3D Rendering",
        Default = false,
        Tooltip = "Reduces resource allocation when AFK farming",
        Callback = function(v) RunService:Set3dRenderingEnabled(not v) end,
    })

    local MenuGroup = Tabs.Settings:AddRightGroupbox("Interface", "settings")
    MenuGroup:AddLabel(b(createMultiGradientText("UI PREFERENCES", PALETTE.prism)), true)
    MenuGroup:AddDivider()
    MenuGroup:AddToggle("AntiAFK", { Text = "Anti-AFK System", Default = true })
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
--   HIGH PERFORMANCE EVENT LISTENERS
-- ══════════════════════════════════════════

local steppedConnection = RunService.Stepped:Connect(function()
    if Library.Unloaded then return end
    if isOn("NoClip") or isOn("AutoFarm") then
        for i = 1, #characterParts do
            local p = characterParts[i]
            if p and p.Parent then
                p.CanCollide = false
            end
        end
    end
end)

local jumpConnection = UserInputService.JumpRequest:Connect(function()
    if Library.Unloaded then return end
    if isOn("InfJump") then
        local h = getHumanoid()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

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

Toggles.WebhookPingEnabled:OnChanged(function()
    wh_pingEnabled = isOn("WebhookPingEnabled")
end)

-- ══════════════════════════════════════════
--   ANTI-AFK SYSTEM
-- ══════════════════════════════════════════

local antiAfkLastInput = tick()
local antiAfkLastTap   = tick()

pcall(function()
    for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do conn:Disable() end
end)

function antiAfkTap()
    local cam = workspace.CurrentCamera
    if not cam then return end
    VirtualUser:Button2Down(Vector2.new(0, 0), cam.CFrame)
    task.wait(0.1)
    VirtualUser:Button2Up(Vector2.new(0, 0), cam.CFrame)
    antiAfkLastTap = tick()
end

UserInputService.InputBegan:Connect(function() antiAfkLastInput = tick() end)
UserInputService.InputChanged:Connect(function(input)
    local t = input.UserInputType
    if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Gamepad1 then
        antiAfkLastInput = tick()
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        task.wait(2)
        if isOn("AntiAFK") then
            local idle = tick() - antiAfkLastInput
            if idle >= 300 and (tick() - antiAfkLastTap >= 60) then
                pcall(antiAfkTap)
            end
        end
    end
end)

-- ══════════════════════════════════════════
--   AUTOMATION LOOPS
-- ══════════════════════════════════════════

-- Auto Start / Replay Loop
task.spawn(function()
    local replayFired = false
    while not Library.Unloaded do
        if isOn("AutoStartDungeon") and ad_isDungeonNotStarted() then
            pcall(function() ad_StartDungeon:FireServer() end)
            local t = tick()
            while isOn("AutoStartDungeon") and ad_isDungeonNotStarted() and tick() - t < 10 do
                task.wait(0.5)
            end
        end
        if isOn("AutoReplay") then
            local done = ad_isDungeonComplete()
            if done and not replayFired then
                replayFired = true
                task.wait(1)
                pcall(function() ad_Dungeon:FireServer("PlayAgain") end)
            elseif not done then
                replayFired = false
            end
        else
            replayFired = false
        end
        task.wait(0.5)
    end
end)

-- Auto Stat Points Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoStatPoint") then
            pcall(function() ad_SP:FireServer(ad_selected_stat) end)
            task.wait(0.1)
        else task.wait(0.5) end
    end
end)

-- Auto Chest Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoChest") then
            local chest = ad_getNearestChest()
            if not chest then
                task.wait(2)
            else
                ad_farm_paused    = true
                adf_currentTarget = nil
                currentTarget     = nil
                pcall(function()
                    chest.prompt.MaxActivationDistance = 99999
                    chest.prompt.RequiresLineOfSight   = false
                    chest.prompt.HoldDuration          = 0
                    chest.prompt.Enabled               = true
                end)
                pcall(function()
                    local cp = chest.model:GetPivot().Position
                    local hrp = ad_getHRP()
                    if hrp then
                        hrp.CFrame = CFrame.new(cp + Vector3.new(0, 3, 0), cp)
                    end
                end)
                task.wait(0.2)
                local t0 = tick()
                while isOn("AutoChest") and tick() - t0 < 10 do
                    local done = false
                    pcall(function()
                        if chest.prompt and chest.prompt.Parent then
                            fireproximityprompt(chest.prompt, 0)
                        else done = true end
                    end)
                    pcall(function()
                        if not chest.model or not chest.model.Parent then done = true end
                    end)
                    if done then break end
                    task.wait()
                end
                task.wait(0.5)
                ad_farm_paused = false
            end
            task.wait(1)
        else
            ad_farm_paused = false
            task.wait(0.5)
        end
    end
end)

-- Auto Attack Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoAttack") and (isOn("AutoFarm") or currentTarget) and not ad_farm_paused then
            pcall(function()
                local inv = LocalPlayer:FindFirstChild("Inventory")
                local wid = "SteelDaggers"
                if inv then
                    for _, i in ipairs(inv:GetChildren()) do
                        if i:GetAttribute("Type") == "Weapon" and i:GetAttribute("Equipped") == true then
                            wid = i.Name; break
                        end
                    end
                end
                local dir    = Vector3.new(0, 0, -1)
                local target = adf_pickTarget()
                local hrp    = ad_getHRP()
                if hrp and target and target.part then
                    local diff = target.part.Position - hrp.Position
                    if diff.Magnitude > 0 then dir = diff.Unit end
                end
                ad_Attack:FireServer("M1", wid, makeVec(dir.X, dir.Y, dir.Z), 3)
                SessionStats.attacksFired = SessionStats.attacksFired + 1
            end)
            task.wait(0.06)
        else task.wait(0.3) end
    end
end)

-- Auto Spell Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoSpell") and (isOn("AutoFarm") or currentTarget) and not ad_farm_paused then
            local s1 = ad_getEquippedSpellBySlot("Spell1")
            local s2 = ad_getEquippedSpellBySlot("Spell2")
            if s1 then pcall(function() ad_Attack:FireServer("Spell1", s1.Name) end) SessionStats.skillsCast = SessionStats.skillsCast + 1 end
            if s2 then pcall(function() ad_Attack:FireServer("Spell2", s2.Name) end) SessionStats.skillsCast = SessionStats.skillsCast + 1 end
            task.wait(0.04)
        else task.wait(0.3) end
    end
end)

-- Auto Ultimate Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoUltimate") and (isOn("AutoFarm") or currentTarget) and not ad_farm_paused then
            local ult = ad_getEquippedUltimate()
            if ult then
                pcall(function() ad_Attack:FireServer("Ultimate", ult.Name) end)
                SessionStats.skillsCast = SessionStats.skillsCast + 1
            end
            task.wait(0.04)
        else task.wait(0.3) end
    end
end)

-- Auto Equip Loops
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoEquipWeapon") and not ad_equipDoneWeapon then
            local r = adeq_doEquipWeapon(ad_weapon_priority)
            ad_equipDoneWeapon = true
            if r and not ad_isLoadingConfig then Library:Notify("Equipped Weapon: " .. r) end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoEquipArmor") and not ad_equipDoneArmor then
            local r = adeq_doEquipArmor(ad_armor_priority)
            ad_equipDoneArmor = true
            if r and not ad_isLoadingConfig then Library:Notify("Equipped Armor: " .. r) end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoEquipHelmet") and not ad_equipDoneHelmet then
            local r = adeq_doEquipHelmet(ad_helmet_priority)
            ad_equipDoneHelmet = true
            if r and not ad_isLoadingConfig then Library:Notify("Equipped Helmet: " .. r) end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoEquipSpells") and not ad_equipDoneSpells then
            local r = adeq_doEquipSpells()
            ad_equipDoneSpells = true
            if #r > 0 and not ad_isLoadingConfig then Library:Notify("Equipped Spells: " .. table.concat(r, ", ")) end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoEquipUltimate") and not ad_equipDoneUlt then
            local r = adeq_doEquipUltimate()
            ad_equipDoneUlt = true
            if r and not ad_isLoadingConfig then Library:Notify("Equipped Ultimate: " .. r) end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoEquipHeroes") and not ad_equipDoneHeroes then
            local r = adeq_doEquipHeroes(ad_hero_priority)
            ad_equipDoneHeroes = true
            if #r > 0 and not ad_isLoadingConfig then Library:Notify("Equipped Heroes: " .. table.concat(r, ", ")) end
        end
        task.wait(1)
    end
end)

-- Auto Virus Loop
task.spawn(function()
    while not Library.Unloaded do
        task.wait(0.3)
        if isOn("AutoVirus") and adVirus_isVisible() then
            local confirm, decline = adVirus_getButtons()
            if ad_virus_action == "Engage" then adVirus_clickBtn(confirm)
            else adVirus_clickBtn(decline) end
            task.wait(1)
        end
    end
end)

-- Auto Quests Loops
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoQuestHourly") then adQuest_claimHourly(); task.wait(1)
        else task.wait(0.5) end
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoQuestDaily") then adQuest_claimDaily(); task.wait(1)
        else task.wait(0.5) end
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoQuestWeekly") then adQuest_claimWeekly(); task.wait(1)
        else task.wait(0.5) end
    end
end)

-- Auto Sell Loop
task.spawn(function()
    while not Library.Unloaded do
        if not adSell_anyEnabled() then
            task.wait(0.5)
        else
            if isOn("AutoSellWeapon")   then adSell_sellOneBatch("Weapon");   task.wait(ad_sell_batch_delay) end
            if isOn("AutoSellArmor")    then adSell_sellOneBatch("Armor");    task.wait(ad_sell_batch_delay) end
            if isOn("AutoSellHelmet")   then adSell_sellOneBatch("Helmet");   task.wait(ad_sell_batch_delay) end
            if isOn("AutoSellSpell")    then adSell_sellOneBatch("Spell");    task.wait(ad_sell_batch_delay) end
            if isOn("AutoSellUltimate") then adSell_sellOneBatch("Ultimate"); task.wait(ad_sell_batch_delay) end
            task.wait(0.5)
        end
    end
end)

-- Auto Daily Spin Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoDailySpin") then
            pcall(function() ad_DailySpin:InvokeServer("Claim") end)
            task.wait(60)
        else task.wait(1) end
    end
end)

-- Auto Cosmetic Spin Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoCosmeticSpin") then
            pcall(function() ad_CosmeticSpin:InvokeServer() end)
            task.wait(0.5)
        else task.wait(0.5) end
    end
end)

-- ══════════════════════════════════════════
--   UNLOAD
-- ══════════════════════════════════════════

Library:OnUnload(function()
    steppedConnection:Disconnect()
    jumpConnection:Disconnect()
    renderConnection:Disconnect()
    adf_stopMovement()

    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end

    RunService:Set3dRenderingEnabled(true)
    local h = getHumanoid()
    if h then
        h.PlatformStand = false
        h.WalkSpeed     = 16
        h.JumpPower     = 50
    end
end)

-- ══════════════════════════════════════════
--   FINALIZE SETUP & CONFIG RESTORATION
-- ══════════════════════════════════════════

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("PrismHub")
SaveManager:SetFolder("PrismHub/AnimeDungeons")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
ThemeManager:SaveDefault("Claude")
ThemeManager:LoadDefault()

ad_isLoadingConfig = true
SaveManager:LoadAutoloadConfig()

Window:SetGlow(true, {
    Color = Color3.fromRGB(217, 119, 87),
    Radius = 30,
    Transparency = 0.1
})

task.defer(function() ad_isLoadingConfig = false end)

task.spawn(function()
    task.wait(1.5)

    local togglesToVerify = {
        "AutoFarm", "AutoAttack", "AutoSpell", "AutoUltimate", "AutoChest",
        "AutoStartDungeon", "AutoReplay", "AutoStatPoint", "AntiAFK",
        "AutoEquipWeapon", "AutoEquipArmor", "AutoEquipHelmet",
        "AutoEquipSpells", "AutoEquipUltimate", "AutoEquipHeroes",
        "AutoVirus", "AutoSellWeapon", "AutoSellArmor", "AutoSellHelmet",
        "AutoSellSpell", "AutoSellUltimate", "AutoQuestHourly", "AutoQuestDaily",
        "AutoQuestWeekly", "AutoDailySpin", "AutoCosmeticSpin", "WebhookPingEnabled",
        "Fly", "WalkSpeedEnabled", "JumpPowerEnabled", "AntiSit", "PotatoMode", "FPSBoost"
    }

    for _, toggleName in ipairs(togglesToVerify) do
        local toggle = Toggles[toggleName]
        if toggle and toggle.Value == true then
            pcall(function()
                if type(toggle.Callback) == "function" then
                    toggle.Callback(toggle.Value)
                end
            end)
        end
    end

    local dropdownsToVerify = {
        "FarmMode", "FarmMethod", "StatSelect", "WeaponPriority", "ArmorPriority",
        "HelmetPriority", "HeroPriority", "VirusAction", "NotificationSide"
    }
    for _, dropName in ipairs(dropdownsToVerify) do
        local opt = Options[dropName]
        if opt and opt.Value then
            pcall(function()
                if type(opt.Callback) == "function" then
                    opt.Callback(opt.Value)
                end
            end)
        end
    end

    local sliderMap = {
        FarmHeight      = function(v) ad_farm_height = v end,
        TweenSpeed      = function(v) ad_tween_speed = v end,
        OrbitRadius     = function(v) ad_farm_orbit_radius = v end,
        OrbitSpeed      = function(v) ad_farm_orbit_speed = v end,
        FlySpeed        = function(v) currentFlySpeed = v end,
        WalkSpeed       = function(v) currentWalkSpeed = v end,
        JumpPower       = function(v) currentJumpPower = v end,
        SellBatchDelay  = function(v) ad_sell_batch_delay = v end,
    }
    for name, applyFn in pairs(sliderMap) do
        local opt = Options[name]
        if opt and opt.Value then
            pcall(function() applyFn(opt.Value) end)
        end
    end

    local inputMap = {
        WebhookURL    = function(v) wh_url = v end,
        WebhookUserID = function(v) wh_userId = v end,
    }
    for name, applyFn in pairs(inputMap) do
        local opt = Options[name]
        if opt and opt.Value then
            pcall(function() applyFn(opt.Value) end)
        end
    end

    Library:Notify("Config verified & callbacks restored!", 3)
end)

Library:Notify("Prism loaded successfully, welcome " .. LocalPlayer.Name, 5)
