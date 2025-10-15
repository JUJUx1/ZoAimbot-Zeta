-- Zo Aimbot Main System
-- Zeta Realm Edition
-- Created for Alpha - Omnipotent Commander
-- GitHub: ZoAimbot-Zeta

-- main.lua - AIMBOT CORE LOGIC
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- CONFIG - GLOBAL STATE
local MAX_AIM_DIST = 500
local AIM_SMOOTHNESS = 0.8
local ESP_COLOR = Color3.fromRGB(255, 0, 0)
local TARGET_COLOR = Color3.fromRGB(255, 255, 0)
local LOCK_ON_DELAY = 0.05

-- GLOBAL STATE (accessible from UI)
_G.ZoAimbot = {
    Enabled = true,
    ESPEnabled = true,
    TeamCheck = false,
    Prediction = true,
    PrioritySystem = true,
    
    -- Stats for UI
    TargetsLocked = 0,
    CurrentTarget = nil,
    Status = "ACTIVE"
}

-- STATE
local highlightESP = {}
local currentTarget = nil
local lastTargetTime = 0

-- ✅ WALL CHECK FUNCTION
local function isVisible(targetPart)
    if not targetPart then return false end
    
    local origin = camera.CFrame.Position
    local targetPos = targetPart.Position
    local direction = (targetPos - origin).Unit
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {player.Character}
    
    local result = Workspace:Raycast(origin, direction * MAX_AIM_DIST, params)
    
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    
    return true
end

-- ✅ VALID ENEMY CHECK
local function isValidEnemy(pl)
    if not pl or pl == player then return false end
    if not pl.Character or not pl.Character:FindFirstChild("Humanoid") then return false end
    if _G.ZoAimbot.TeamCheck and pl.Team and player.Team and pl.Team == player.Team then return false end
    local humanoid = pl.Character:FindFirstChild("Humanoid")
    if humanoid.Health <= 0 then return false end
    return true
end

-- ✅ ESP SYSTEM
local function addESP(plr)
    if plr == player then return end

    local function attachHighlight(char)
        if not _G.ZoAimbot.ESPEnabled then return end
        if highlightESP[plr] then
            highlightESP[plr]:Destroy()
        end
        local h = Instance.new("Highlight")
        h.Name = "EnemyESP"
        h.FillColor = ESP_COLOR
        h.OutlineColor = ESP_COLOR
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Parent = char
        highlightESP[plr] = h
    end

    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        attachHighlight(char)
    end)

    if plr.Character then
        attachHighlight(plr.Character)
    end
end

local function removeESP(plr)
    if highlightESP[plr] then
        highlightESP[plr]:Destroy()
        highlightESP[plr] = nil
    end
end

local function updateAllESP()
    for plr, highlight in pairs(highlightESP) do
        if highlight and highlight.Parent then
            highlight.Enabled = _G.ZoAimbot.ESPEnabled
        end
    end
end

-- ✅ TARGET ACQUISITION
local function getClosestTarget()
    if not _G.ZoAimbot.Enabled then return nil end
    if not player.Character or not player.Character:FindFirstChild("Head") then return nil end
    
    local bestTarget = nil
    local highestPriority = -math.huge

    for _, pl in pairs(Players:GetPlayers()) do
        if not isValidEnemy(pl) then continue end
        
        local head = pl.Character:FindFirstChild("Head") or pl.Character:FindFirstChild("HumanoidRootPart")
        if not head then continue end
        
        local dist = (head.Position - camera.CFrame.Position).Magnitude
        if dist > MAX_AIM_DIST then continue end
        
        local visible = isVisible(head)
        if not visible then
            local root = pl.Character:FindFirstChild("HumanoidRootPart")
            if root then
                visible = isVisible(root)
            end
        end
        
        if visible then
            local priority = 1000 - dist  -- Simple distance-based priority
            if priority > highestPriority then
                highestPriority = priority
                bestTarget = pl
            end
        end
    end
    
    return bestTarget
end

-- ✅ PREDICTIVE AIMING
local function getPredictedPosition(targetChar)
    if not _G.ZoAimbot.Prediction then
        local head = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
        return head and head.Position or nil
    end
    
    local head = targetChar:FindFirstChild("Head")
    local root = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not head and not root then return nil end
    
    local targetPart = head or root
    local currentPos = targetPart.Position
    
    local velocity = targetPart.AssemblyLinearVelocity
    if velocity.Magnitude > 2 then
        local dist = (currentPos - camera.CFrame.Position).Magnitude
        local travelTime = dist / 1000
        currentPos = currentPos + velocity * travelTime
    end
    
    return currentPos
end

-- ✅ MAIN AIMBOT LOOP
RunService.RenderStepped:Connect(function()
    pcall(function()
        -- Target acquisition
        if tick() - lastTargetTime > LOCK_ON_DELAY then
            currentTarget = getClosestTarget()
            _G.ZoAimbot.CurrentTarget = currentTarget
            lastTargetTime = tick()
            
            if currentTarget then
                _G.ZoAimbot.TargetsLocked = _G.ZoAimbot.TargetsLocked + 1
            end
        end

        -- Update ESP highlights
        if currentTarget and highlightESP[currentTarget] then
            local h = highlightESP[currentTarget]
            h.FillColor = TARGET_COLOR
            h.OutlineColor = TARGET_COLOR
            h.Enabled = _G.ZoAimbot.ESPEnabled
        end

        -- Reset other highlights
        for pl, h in pairs(highlightESP) do
            if h and h.Parent and pl ~= currentTarget and isValidEnemy(pl) then
                h.FillColor = ESP_COLOR
                h.OutlineColor = ESP_COLOR
                h.Enabled = _G.ZoAimbot.ESPEnabled
            end
        end

        -- Aiming system
        if _G.ZoAimbot.Enabled and currentTarget and currentTarget.Character then
            local tPart = currentTarget.Character:FindFirstChild("Head") or currentTarget.Character:FindFirstChild("HumanoidRootPart")
            if tPart and isVisible(tPart) then
                local targetPos = getPredictedPosition(currentTarget.Character)
                if targetPos then
                    local targetCF = CFrame.lookAt(camera.CFrame.Position, targetPos)
                    camera.CFrame = camera.CFrame:Lerp(targetCF, AIM_SMOOTHNESS)
                end
            end
        end
    end)
end)

-- ✅ INITIALIZE ESP FOR ALL PLAYERS
for _, pl in pairs(Players:GetPlayers()) do
    addESP(pl)
end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)

-- ✅ EXPORT FUNCTIONS FOR UI
_G.ZoAimbot.UpdateESP = updateAllESP
_G.ZoAimbot.ToggleAimbot = function(state)
    _G.ZoAimbot.Enabled = state
    _G.ZoAimbot.Status = state and "ACTIVE" or "INACTIVE"
end

_G.ZoAimbot.ToggleESP = function(state)
    _G.ZoAimbot.ESPEnabled = state
    updateAllESP()
end

_G.ZoAimbot.ToggleTeamCheck = function(state)
    _G.ZoAimbot.TeamCheck = state
end

_G.ZoAimbot.TogglePrediction = function(state)
    _G.ZoAimbot.Prediction = state
end

print("🎯 ZO AIMBOT MAIN SYSTEM LOADED!")
print("🔥 Status: " .. _G.ZoAimbot.Status)
print("📱 Run ui.lua to control the system!")
