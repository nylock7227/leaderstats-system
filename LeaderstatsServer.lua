-- Leaderstats + basic coin saving
-- feed a brainrot

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local coinsStore = DataStoreService:GetDataStore("PlayerCoins")

local function createLeaderstats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats

    local kills = Instance.new("IntValue")
    kills.Name = "Kills"
    kills.Value = 0
    kills.Parent = leaderstats

    -- try to load saved coins
    local success, savedCoins = pcall(function()
        return coinsStore:GetAsync(player.UserId)
    end)

    if success and typeof(savedCoins) == "number" then
        coins.Value = savedCoins -- fix saving problem
    end
end

local function savePlayerCoins(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local coins = leaderstats:FindFirstChild("Coins")
    if not coins then return end

    local success, err = pcall(function()
        coinsStore:SetAsync(player.UserId, coins.Value)
    end)

    if not success then
        warn("Failed to save coins for " .. player.Name .. ": " .. tostring(err))
    end
end

Players.PlayerAdded:Connect(function(player)
    createLeaderstats(player)
end)

Players.PlayerRemoving:Connect(function(player)
    savePlayerCoins(player)
end)
-- clean up later 
