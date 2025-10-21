-- Zo Aimbot Mobile UI
-- Zeta Realm Edition | Ultra-Modern Redesign
-- GitHub: ZoAimbot-Zeta

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- UI STATE
local gui = nil
local isMinimized = false
local originalSize = UDim2.new(0, 280, 0, 360)
local minimizedSize = UDim2.new(0, 280, 0, 36)

-- Utility: Safe touch/mouse button
local function connectTap(button, callback)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Visual press feedback
            local originalColor = button.BackgroundColor3
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            spawn(function()
                wait(0.1)
                button.BackgroundColor3 = originalColor
            end)
            callback()
        end
    end)
end

-- Utility: Create sleek frame
local function newFrame(parent, name, size, position, bgColor)
    local f = Instance.new("Frame")
    f.Name = name
    f.Size = size or UDim2.new(1, 0, 1, 0)
    f.Position = position or UDim2.new(0, 0, 0, 0)
    f.BackgroundColor3 = bgColor or Color3.fromRGB(20, 20, 25)
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end

-- Utility: Add corner
local function addCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
    return c
end

-- CREATE FUTURISTIC UI
local function createMobileUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZoMobileAimbotUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true

    -- Main Glassmorphic Frame
    local MainFrame = newFrame(ScreenGui, "MainFrame", originalSize, UDim2.new(0.5, -140, 0.1, 0), Color3.fromRGB(15, 15, 20))
    MainFrame.BackgroundTransparency = 0.2
    local bg = Instance.new("UIGradient")
    bg.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))}
    bg.Rotation = 90
    bg.Parent = MainFrame
    addCorner(MainFrame, 16)

    -- Glow effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Image = "rbxassetid://4483345943" -- Circle glow
    Glow.BackgroundTransparency = 1
    Glow.Size = UDim2.new(1.8, 0, 1.8, 0)
    Glow.Position = UDim2.new(-0.4, 0, -0.4, 0)
    Glow.ZIndex = 0
    Glow.ImageColor3 = Color3.fromRGB(60, 80, 255)
    Glow.ImageTransparency = 0.85
    Glow.Parent = MainFrame

    -- Title Bar
    local TitleBar = newFrame(MainFrame, "TitleBar", UDim2.new(1, 0, 0, 36), nil, Color3.fromRGB(25, 25, 35))
    TitleBar.BackgroundTransparency = 0.3
    addCorner(TitleBar, 16)

    local Title = Instance.new("TextLabel")
    Title.Text = "ZO AIMBOT • ZETA"
    Title.Size = UDim2.new(1, -90, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(240, 240, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Text = "—"
    MinimizeBtn.Size = UDim2.new(0, 36, 1, 0)
    MinimizeBtn.Position = UDim2.new(1, -72, 0, 0)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
    MinimizeBtn.Font = Enum.Font.GothamBlack
    MinimizeBtn.TextSize = 20
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.Parent = TitleBar
    addCorner(MinimizeBtn, 8)

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "✕"
    CloseBtn.Size = UDim2.new(0, 36, 1, 0)
    CloseBtn.Position = UDim2.new(1, -36, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBlack
    CloseBtn.TextSize = 20
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = TitleBar
    addCorner(CloseBtn, 8)

    -- Content Area
    local Content = newFrame(MainFrame, "Content", UDim2.new(1, -20, 1, -56), UDim2.new(0, 10, 0, 46), Color3.fromRGB(20, 20, 25))
    Content.BackgroundTransparency = 0.4
    addCorner(Content, 12)

    -- Status Bar
    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Text = "ACTIVE • TARGET LOCKED"
    Status.Size = UDim2.new(1, 0, 0, 28)
    Status.Position = UDim2.new(0, 0, 0, 0)
    Status.BackgroundColor3 = Color3.fromRGB(30, 180, 60)
    Status.BackgroundTransparency = 0.2
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 12
    Status.Parent = Content
    addCorner(Status, 6)

    -- Toggles Container
    local TogglesFrame = newFrame(Content, "TogglesFrame", UDim2.new(1, 0, 0, 220), UDim2.new(0, 0, 0, 38))

    -- Create toggle
    local function createToggle(parent, name, yPos, default)
        local toggle = Instance.new("TextButton")
        toggle.Name = name .. "Toggle"
        toggle.Text = ""
        toggle.Size = UDim2.new(1, 0, 0, 48)
        toggle.Position = UDim2.new(0, 0, 0, yPos)
        toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        toggle.AutoButtonColor = false
        toggle.Parent = parent
        addCorner(toggle, 10)

        local label = Instance.new("TextLabel")
        label.Text = name:upper()
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(230, 230, 240)
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 14
        label.Parent = toggle

        local state = Instance.new("Frame")
        state.Name = "State"
        state.Size = UDim2.new(0, 36, 0, 24)
        state.Position = UDim2.new(1, -52, 0.5, -12)
        state.BackgroundColor3 = default and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(200, 60, 80)
        state.Parent = toggle
        addCorner(state, 12)

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 18, 0, 18)
        indicator.Position = UDim2.new(default and 0.5 or 0, 3, 0.5, -9)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Parent = state
        addCorner(indicator, 9)

        return toggle, state, indicator
    end

    local aimbotToggle, aimbotState, aimbotIndicator = createToggle(TogglesFrame, "Aimbot", 0, true)
    local espToggle, espState, espIndicator = createToggle(TogglesFrame, "ESP", 58, true)
    local teamToggle, teamState, teamIndicator = createToggle(TogglesFrame, "Team Check", 116, false)
    local predToggle, predState, predIndicator = createToggle(TogglesFrame, "Prediction", 174, true)

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Title = Title,
        MinimizeBtn = MinimizeBtn,
        CloseBtn = CloseBtn,
        Content = Content,
        Status = Status,
        Toggles = {
            Aimbot = {Btn = aimbotToggle, State = aimbotState, Indicator = aimbotIndicator},
            ESP = {Btn = espToggle, State = espState, Indicator = espIndicator},
            Team = {Btn = teamToggle, State = teamState, Indicator = teamIndicator},
            Prediction = {Btn = predToggle, State = predState, Indicator = predIndicator}
        }
    }
end

-- ANIMATED MINIMIZE
local function toggleMinimize(ui, isNowMinimized)
    local goalSize = isNowMinimized and minimizedSize or originalSize
    local tween = TweenService:Create(ui.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = goalSize})
    tween:Play()
    ui.Content.Visible = not isNowMinimized
    ui.MinimizeBtn.Text = isNowMinimized and "+" or "—"
    ui.MinimizeBtn.BackgroundColor3 = isNowMinimized and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 55)
end

-- UPDATE STATS
local function updateUI(ui)
    if not _G.ZoAimbot then return end
    local targets = _G.ZoAimbot.TargetsLocked or 0
    local status = _G.ZoAimbot.Enabled and "ACTIVE" or "DISABLED"
    local color = _G.ZoAimbot.Enabled and Color3.fromRGB(30, 180, 60) or Color3.fromRGB(180, 50, 60)
    
    ui.Title.Text = ("ZO AIMBOT • LOCKED: %d"):format(targets)
    ui.Status.Text = status .. " • TARGETS"
    ui.Status.BackgroundColor3 = color
end

-- INITIALIZE
local function initializeUI()
    local ui = createMobileUI()
    local elements = ui

    -- Draggable (title bar only)
    local dragging = false
    local dragStart, startPos
    elements.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = elements.MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            local delta = input.Position - dragStart
            elements.MainFrame.Position = UDim2.new(
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

    -- Button Connections
    connectTap(elements.MinimizeBtn, function()
        isMinimized = not isMinimized
        toggleMinimize(elements, isMinimized)
    end)

    connectTap(elements.CloseBtn, function()
        elements.ScreenGui:Destroy()
        print("🗑️ UI CLOSED — AIMBOT STILL RUNNING")
    end)

    -- Toggle logic
    local function bindToggle(name, globalFunc, stateObj)
        connectTap(stateObj.Btn, function()
            if not _G.ZoAimbot then return end
            local newValue = not _G.ZoAimbot[globalFunc]()
            _G.ZoAimbot["Toggle" .. name](newValue)

            -- Animate toggle
            local on = newValue
            stateObj.State.BackgroundColor3 = on and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(200, 60, 80)
            local goalX = on and 0.5 or 0
            TweenService:Create(stateObj.Indicator, TweenInfo.new(0.15), {Position = UDim2.new(goalX, 3, 0.5, -9)}):Play()
        end)
    end

    bindToggle("Aimbot", "Enabled", elements.Toggles.Aimbot)
    bindToggle("ESP", "ESPEnabled", elements.Toggles.ESP)
    bindToggle("TeamCheck", "TeamCheck", elements.Toggles.Team)
    bindToggle("Prediction", "Prediction", elements.Toggles.Prediction)

    -- Auto-update
    spawn(function()
        while elements.ScreenGui and elements.ScreenGui.Parent do
            updateUI(elements)
            wait(0.5)
        end
    end)

    print("📱 ZETA UI LOADED — DRAG • TAP • DOMINATE")
    return elements.ScreenGui
end

-- LAUNCH
if _G.ZoAimbot then
    gui = initializeUI()
else
    warn("❌ Load main.lua BEFORE ui.lua!")
end
