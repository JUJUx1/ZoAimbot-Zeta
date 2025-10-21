-- Zo Aimbot Mobile UI
-- Zeta Realm Edition | MERGED & WITH ON/OFF LABELS
-- Mobile-safe, draggable, toggle-syncing UI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Safely wait for PlayerGui
local playerGui = player:WaitForChild("PlayerGui")

-- UI STATE
local isMinimized = false
local originalSize = UDim2.new(0, 280, 0, 360)
local minimizedSize = UDim2.new(0, 280, 0, 36)

-- Utility: Safe tap handler for mobile + desktop
local function connectTap(button, callback)
    if not button or not callback then return end
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Visual feedback (safe)
            local originalColor = button.BackgroundColor3
            pcall(function() button.BackgroundColor3 = Color3.fromRGB(50, 50, 65) end)
            task.delay(0.12, function()
                if button and button.Parent then
                    pcall(function() button.BackgroundColor3 = originalColor end)
                end
            end)
            callback()
        end
    end)
end

-- Utility: Create frame
local function createFrame(parent, name, size, position, bgColor)
    local f = Instance.new("Frame")
    f.Name = name
    f.Size = size
    f.Position = position or UDim2.new(0, 0, 0, 0)
    f.BackgroundColor3 = bgColor or Color3.fromRGB(20, 20, 25)
    f.BorderSizePixel = 0
    f.BackgroundTransparency = 0.2
    f.Parent = parent
    return f
end

-- Utility: Add corner
local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

-- MAIN UI CREATION (returns table of references)
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZoMobileAimbotUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    -- Main Frame (Active for mobile touch)
    local mainFrame = createFrame(screenGui, "MainFrame", originalSize, UDim2.new(0.5, -140, 0.1, 0), Color3.fromRGB(15, 15, 22))
    mainFrame.Active = true
    mainFrame.ClipsDescendants = true
    addCorner(mainFrame, 16)

    -- Title Bar
    local titleBar = createFrame(mainFrame, "TitleBar", UDim2.new(1, 0, 0, 36), nil, Color3.fromRGB(25, 25, 35))
    titleBar.BackgroundTransparency = 0.3
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    addCorner(titleBar, 16)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Text = "ZO AIMBOT • ZETA"
    titleLabel.Size = UDim2.new(1, -90, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 13
    titleLabel.Parent = titleBar

    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Text = "—"
    minimizeBtn.Size = UDim2.new(0, 36, 1, 0)
    minimizeBtn.Position = UDim2.new(1, -72, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
    minimizeBtn.Font = Enum.Font.GothamBlack
    minimizeBtn.TextSize = 20
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = titleBar
    addCorner(minimizeBtn, 8)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 36, 1, 0)
    closeBtn.Position = UDim2.new(1, -36, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 20
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = titleBar
    addCorner(closeBtn, 8)

    -- Content Area
    local content = createFrame(mainFrame, "Content", UDim2.new(1, -20, 1, -56), UDim2.new(0, 10, 0, 46), Color3.fromRGB(25, 25, 35))
    content.BackgroundTransparency = 0.35
    addCorner(content, 12)

    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Text = "STATUS: LOADING..."
    statusLabel.Size = UDim2.new(1, 0, 0, 28)
    statusLabel.Position = UDim2.new(0, 0, 0, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    statusLabel.BackgroundTransparency = 0.2
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 12
    statusLabel.Parent = content
    addCorner(statusLabel, 6)

    -- Toggles Container
    local togglesFrame = createFrame(content, "TogglesFrame", UDim2.new(1, 0, 0, 220), UDim2.new(0, 0, 0, 38), Color3.fromRGB(0, 0, 0))
    togglesFrame.BackgroundTransparency = 1
    togglesFrame.Parent = content

    -- Create Toggle (returns button, background frame, indicator, stateText)
    local function makeToggle(name, yPos, default)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Toggle"
        btn.Size = UDim2.new(1, 0, 0, 48)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        btn.AutoButtonColor = false
        btn.Parent = togglesFrame
        addCorner(btn, 10)

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Text = name:upper()
        label.Size = UDim2.new(1, -140, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(230, 230, 245)
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = btn

        -- ON/OFF text label (new)
        local stateText = Instance.new("TextLabel")
        stateText.Name = "StateText"
        stateText.Size = UDim2.new(0, 60, 1, 0)
        stateText.Position = UDim2.new(1, -124, 0, 0)
        stateText.BackgroundTransparency = 1
        stateText.Text = default and "ON" or "OFF"
        stateText.Font = Enum.Font.GothamBold
        stateText.TextSize = 13
        stateText.TextColor3 = default and Color3.fromRGB(180, 255, 200) or Color3.fromRGB(255, 200, 200)
        stateText.TextXAlignment = Enum.TextXAlignment.Right
        stateText.Parent = btn

        local stateBg = Instance.new("Frame")
        stateBg.Name = "StateBg"
        stateBg.Size = UDim2.new(0, 36, 0, 24)
        stateBg.Position = UDim2.new(1, -52, 0.5, -12)
        stateBg.BackgroundColor3 = default and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(200, 60, 80)
        stateBg.Parent = btn
        addCorner(stateBg, 12)

        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 18, 0, 18)
        indicator.Position = UDim2.new(default and 0.5 or 0, 3, 0.5, -9)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Parent = stateBg
        addCorner(indicator, 9)

        return btn, stateBg, indicator, stateText
    end

    local aimbotBtn, aimbotBg, aimbotInd, aimbotText = makeToggle("Aimbot", 0, true)
    local espBtn, espBg, espInd, espText = makeToggle("ESP", 58, true)
    local teamBtn, teamBg, teamInd, teamText = makeToggle("Team Check", 116, false)
    local predBtn, predBg, predInd, predText = makeToggle("Prediction", 174, true)

    -- Return all references
    return {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        TitleBar = titleBar,
        TitleLabel = titleLabel,
        MinimizeBtn = minimizeBtn,
        CloseBtn = closeBtn,
        Content = content,
        StatusLabel = statusLabel,
        Toggles = {
            Aimbot = {Btn = aimbotBtn, Bg = aimbotBg, Ind = aimbotInd, Text = aimbotText},
            ESP = {Btn = espBtn, Bg = espBg, Ind = espInd, Text = espText},
            Team = {Btn = teamBtn, Bg = teamBg, Ind = teamInd, Text = teamText},
            Prediction = {Btn = predBtn, Bg = predBg, Ind = predInd, Text = predText}
        }
    }
end

-- TOGGLE ANIMATION (updates textual ON/OFF too)
local function animateToggle(stateBg, indicator, stateText, enabled)
    stateBg.BackgroundColor3 = enabled and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(200, 60, 80)
    local goalX = enabled and 0.5 or 0
    TweenService:Create(indicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(goalX, 3, 0.5, -9)
    }):Play()
    if stateText then
        stateText.Text = enabled and "ON" or "OFF"
        stateText.TextColor3 = enabled and Color3.fromRGB(180, 255, 200) or Color3.fromRGB(255, 200, 200)
    end
end

-- MINIMIZE ANIMATION
local function setMinimized(ui, minimized)
    isMinimized = minimized
    local goalSize = minimized and minimizedSize or originalSize
    TweenService:Create(ui.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = goalSize
    }):Play()
    ui.Content.Visible = not minimized
    ui.MinimizeBtn.Text = minimized and "+" or "—"
    ui.MinimizeBtn.BackgroundColor3 = minimized and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 55)
end

-- UPDATE UI FROM AIMBOT STATE
local function updateUI(ui)
    if not _G.ZoAimbot then
        ui.StatusLabel.Text = "ERROR: MAIN NOT LOADED"
        ui.StatusLabel.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        return
    end

    local targets = tonumber(_G.ZoAimbot.TargetsLocked) or 0
    local enabled = _G.ZoAimbot.Enabled == true
    local espOn = _G.ZoAimbot.ESPEnabled == true
    local teamOn = _G.ZoAimbot.TeamCheck == true
    local predOn = _G.ZoAimbot.Prediction == true

    ui.TitleLabel.Text = ("ZO AIMBOT • LOCKED: %d"):format(targets)
    ui.StatusLabel.Text = enabled and "ACTIVE • READY" or "DISABLED"
    ui.StatusLabel.BackgroundColor3 = enabled and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(180, 60, 60)

    -- Sync toggle visuals (in case changed externally)
    animateToggle(ui.Toggles.Aimbot.Bg, ui.Toggles.Aimbot.Ind, ui.Toggles.Aimbot.Text, enabled)
    animateToggle(ui.Toggles.ESP.Bg, ui.Toggles.ESP.Ind, ui.Toggles.ESP.Text, espOn)
    animateToggle(ui.Toggles.Team.Bg, ui.Toggles.Team.Ind, ui.Toggles.Team.Text, teamOn)
    animateToggle(ui.Toggles.Prediction.Bg, ui.Toggles.Prediction.Ind, ui.Toggles.Prediction.Text, predOn)
end

-- INITIALIZE FULL UI
local function init()
    if not _G.ZoAimbot then
        warn("❌ _G.ZoAimbot not found! Load main.lua first.")
        return nil
    end

    local ui = createUI()

    -- Draggable (mobile-safe)
    local dragging = false
    local dragStart, startPos
    ui.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = ui.MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            ui.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- BUTTONS (use connectTap for mobile safety)
    connectTap(ui.MinimizeBtn, function()
        setMinimized(ui, not isMinimized)
    end)

    connectTap(ui.CloseBtn, function()
        if ui.ScreenGui and ui.ScreenGui.Parent then
            ui.ScreenGui:Destroy()
            print("🗑️ Zeta UI Closed — Aimbot still running in background.")
        end
    end)

    -- TOGGLES (calls to your working aimbot)
    connectTap(ui.Toggles.Aimbot.Btn, function()
        if _G.ZoAimbot and _G.ZoAimbot.ToggleAimbot then
            local newState = not (_G.ZoAimbot.Enabled == true)
            pcall(function() _G.ZoAimbot.ToggleAimbot(newState) end)
            animateToggle(ui.Toggles.Aimbot.Bg, ui.Toggles.Aimbot.Ind, ui.Toggles.Aimbot.Text, newState)
        end
    end)

    connectTap(ui.Toggles.ESP.Btn, function()
        if _G.ZoAimbot and _G.ZoAimbot.ToggleESP then
            local newState = not (_G.ZoAimbot.ESPEnabled == true)
            pcall(function() _G.ZoAimbot.ToggleESP(newState) end)
            animateToggle(ui.Toggles.ESP.Bg, ui.Toggles.ESP.Ind, ui.Toggles.ESP.Text, newState)
        end
    end)

    connectTap(ui.Toggles.Team.Btn, function()
        if _G.ZoAimbot and _G.ZoAimbot.ToggleTeamCheck then
            local newState = not (_G.ZoAimbot.TeamCheck == true)
            pcall(function() _G.ZoAimbot.ToggleTeamCheck(newState) end)
            animateToggle(ui.Toggles.Team.Bg, ui.Toggles.Team.Ind, ui.Toggles.Team.Text, newState)
        end
    end)

    connectTap(ui.Toggles.Prediction.Btn, function()
        if _G.ZoAimbot and _G.ZoAimbot.TogglePrediction then
            local newState = not (_G.ZoAimbot.Prediction == true)
            pcall(function() _G.ZoAimbot.TogglePrediction(newState) end)
            animateToggle(ui.Toggles.Prediction.Bg, ui.Toggles.Prediction.Ind, ui.Toggles.Prediction.Text, newState)
        end
    end)

    -- Auto-update loop (safe)
    task.spawn(function()
        while ui.ScreenGui and ui.ScreenGui.Parent do
            pcall(function() updateUI(ui) end)
            task.wait(0.5)
        end
    end)

    print("✨ Zeta Mobile UI Loaded — Optimized for Touch (with ON/OFF labels)")
    return ui.ScreenGui
end

-- LAUNCH
if playerGui then
    init()
else
    warn("❌ PlayerGui not found!")
end
