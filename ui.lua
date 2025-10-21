-- Zo Aimbot Mobile UI
-- Zeta Realm Edition | FULLY MOBILE-COMPATIBLE
-- GitHub: ZoAimbot-Zeta

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
            -- Visual feedback
            local originalColor = button.BackgroundColor3
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            task.delay(0.15, function()
                if button and button.Parent then
                    button.BackgroundColor3 = originalColor
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

-- MAIN UI CREATION
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZoMobileAimbotUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    -- Main Frame (MUST be Active for mobile touch!)
    local mainFrame = createFrame(screenGui, "MainFrame", originalSize, UDim2.new(0.5, -140, 0.1, 0), Color3.fromRGB(15, 15, 22))
    mainFrame.Active = true  -- 🔑 CRITICAL FOR MOBILE TOUCH
    addCorner(mainFrame, 16)

    -- Title Bar
    local titleBar = createFrame(mainFrame, "TitleBar", UDim2.new(1, 0, 0, 36), nil, Color3.fromRGB(25, 25, 35))
    titleBar.BackgroundTransparency = 0.3
    addCorner(titleBar, 16)

    local titleLabel = Instance.new("TextLabel")
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

    -- Create Toggle
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
        label.Text = name:upper()
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(230, 230, 245)
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 14
        label.Parent = btn

        local stateBg = Instance.new("Frame")
        stateBg.Size = UDim2.new(0, 36, 0, 24)
        stateBg.Position = UDim2.new(1, -52, 0.5, -12)
        stateBg.BackgroundColor3 = default and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(200, 60, 80)
        stateBg.Parent = btn
        addCorner(stateBg, 12)

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 18, 0, 18)
        indicator.Position = UDim2.new(default and 0.5 or 0, 3, 0.5, -9)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Parent = stateBg
        addCorner(indicator, 9)

        return btn, stateBg, indicator
    end

    local aimbotBtn, aimbotBg, aimbotInd = makeToggle("Aimbot", 0, true)
    local espBtn, espBg, espInd = makeToggle("ESP", 58, true)
    local teamBtn, teamBg, teamInd = makeToggle("Team Check", 116, false)
    local predBtn, predBg, predInd = makeToggle("Prediction", 174, true)

    -- Return all references
    return {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        TitleLabel = titleLabel,
        MinimizeBtn = minimizeBtn,
        CloseBtn = closeBtn,
        Content = content,
        StatusLabel = statusLabel,
        Toggles = {
            Aimbot = {Btn = aimbotBtn, Bg = aimbotBg, Ind = aimbotInd},
            ESP = {Btn = espBtn, Bg = espBg, Ind = espInd},
            Team = {Btn = teamBtn, Bg = teamBg, Ind = teamInd},
            Prediction = {Btn = predBtn, Bg = predBg, Ind = predInd}
        }
    }
end

-- TOGGLE ANIMATION
local function animateToggle(stateBg, indicator, enabled)
    stateBg.BackgroundColor3 = enabled and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(200, 60, 80)
    local goalX = enabled and 0.5 or 0
    TweenService:Create(indicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(goalX, 3, 0.5, -9)
    }):Play()
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

    local targets = _G.ZoAimbot.TargetsLocked or 0
    local enabled = _G.ZoAimbot.Enabled == true
    local espOn = _G.ZoAimbot.ESPEnabled == true
    local teamOn = _G.ZoAimbot.TeamCheck == true
    local predOn = _G.ZoAimbot.Prediction == true

    ui.TitleLabel.Text = ("ZO AIMBOT • LOCKED: %d"):format(targets)
    ui.StatusLabel.Text = enabled and "ACTIVE • READY" or "DISABLED"
    ui.StatusLabel.BackgroundColor3 = enabled and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(180, 60, 60)

    -- Sync toggle visuals (in case changed externally)
    animateToggle(ui.Toggles.Aimbot.Bg, ui.Toggles.Aimbot.Ind, enabled)
    animateToggle(ui.Toggles.ESP.Bg, ui.Toggles.ESP.Ind, espOn)
    animateToggle(ui.Toggles.Team.Bg, ui.Toggles.Team.Ind, teamOn)
    animateToggle(ui.Toggles.Prediction.Bg, ui.Toggles.Prediction.Ind, predOn)
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
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ui.MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            ui.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- BUTTONS
    connectTap(ui.MinimizeBtn, function()
        setMinimized(ui, not isMinimized)
    end)

    connectTap(ui.CloseBtn, function()
        ui.ScreenGui:Destroy()
        print("🗑️ Zeta UI Closed — Aimbot still running in background.")
    end)

    -- TOGGLES
    connectTap(ui.Toggles.Aimbot.Btn, function()
        if _G.ZoAimbot then
            local newState = not (_G.ZoAimbot.Enabled == true)
            _G.ZoAimbot.ToggleAimbot(newState)
            animateToggle(ui.Toggles.Aimbot.Bg, ui.Toggles.Aimbot.Ind, newState)
        end
    end)

    connectTap(ui.Toggles.ESP.Btn, function()
        if _G.ZoAimbot then
            local newState = not (_G.ZoAimbot.ESPEnabled == true)
            _G.ZoAimbot.ToggleESP(newState)
            animateToggle(ui.Toggles.ESP.Bg, ui.Toggles.ESP.Ind, newState)
        end
    end)

    connectTap(ui.Toggles.Team.Btn, function()
        if _G.ZoAimbot then
            local newState = not (_G.ZoAimbot.TeamCheck == true)
            _G.ZoAimbot.ToggleTeamCheck(newState)
            animateToggle(ui.Toggles.Team.Bg, ui.Toggles.Team.Ind, newState)
        end
    end)

    connectTap(ui.Toggles.Prediction.Btn, function()
        if _G.ZoAimbot then
            local newState = not (_G.ZoAimbot.Prediction == true)
            _G.ZoAimbot.TogglePrediction(newState)
            animateToggle(ui.Toggles.Prediction.Bg, ui.Toggles.Prediction.Ind, newState)
        end
    end)

    -- Auto-update
    task.spawn(function()
        while ui.ScreenGui and ui.ScreenGui.Parent do
            updateUI(ui)
            task.wait(0.5)
        end
    end)

    print("✨ Zeta Mobile UI Loaded — Optimized for Touch")
    return ui.ScreenGui
end

-- LAUNCH
if playerGui then
    init()
else
    warn("❌ PlayerGui not found!")
end
