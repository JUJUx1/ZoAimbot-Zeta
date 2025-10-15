-- Zo Aimbot Mobile UI
-- Zeta Realm Edition  
-- Optimized for touch controls
-- GitHub: ZoAimbot-Zeta

-- [Rest of your ui.lua code...]
-- ui.lua - MOBILE UI CONTROLS
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- UI STATE
local gui = nil
local isMinimized = false
local originalSize = UDim2.new(0, 300, 0, 400)
local minimizedSize = UDim2.new(0, 300, 0, 40)

-- CREATE THE FUCKING UI
local function createMobileUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZoMobileAimbotUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = originalSize
    MainFrame.Position = UDim2.new(0.5, -150, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame

    -- Title Bar (for dragging and minimizing)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar

    -- Title with stats
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = "ZO AIMBOT 🎯 | LOCKED: 0"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    -- Minimize Button (-)
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Text = "-"
    MinimizeBtn.Size = UDim2.new(0, 40, 1, 0)
    MinimizeBtn.Position = UDim2.new(1, -80, 0, 0)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.Font = Enum.Font.GothamBlack
    MinimizeBtn.TextSize = 16
    MinimizeBtn.Parent = TitleBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeBtn

    -- Close Button (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Text = "X"
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBlack
    CloseBtn.TextSize = 16
    CloseBtn.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    -- Content Area (minimizable)
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -20, 1, -60)
    Content.Position = UDim2.new(0, 10, 0, 50)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- Status Display
    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Text = "STATUS: ACTIVE 🔥"
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 14
    Status.Parent = Content
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 6)
    StatusCorner.Parent = Status

    -- Toggles Frame
    local TogglesFrame = Instance.new("Frame")
    TogglesFrame.Name = "TogglesFrame"
    TogglesFrame.Size = UDim2.new(1, 0, 0, 250)
    TogglesFrame.Position = UDim2.new(0, 0, 0, 40)
    TogglesFrame.BackgroundTransparency = 1
    TogglesFrame.Parent = Content

    -- Toggle buttons (Aimbot, ESP, Team Check, Prediction)
    local toggleButtons = {
        {Name = "Aimbot", Default = true, YPos = 0},
        {Name = "ESP", Default = true, YPos = 60},
        {Name = "TeamCheck", Default = false, YPos = 120},
        {Name = "Prediction", Default = true, YPos = 180}
    }

    for _, toggleInfo in pairs(toggleButtons) do
        local toggle = Instance.new("TextButton")
        toggle.Name = toggleInfo.Name .. "Toggle"
        toggle.Text = toggleInfo.Name:upper() .. ": " .. (toggleInfo.Default and "ON" or "OFF")
        toggle.Size = UDim2.new(1, 0, 0, 50)
        toggle.Position = UDim2.new(0, 0, 0, toggleInfo.YPos)
        toggle.BackgroundColor3 = toggleInfo.Default and Color3.fromRGB(60, 150, 60) or Color3.fromRGB(150, 60, 60)
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.Font = Enum.Font.GothamSemibold
        toggle.TextSize = 16
        toggle.Parent = TogglesFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 8)
        toggleCorner.Parent = toggle
    end

    return ScreenGui
end

-- DRAGGING FUNCTIONALITY
local function makeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- MINIMIZE/MAXIMIZE FUNCTIONALITY
local function toggleMinimize(mainFrame, minimizeBtn, content)
    isMinimized = not isMinimized
    
    if isMinimized then
        mainFrame.Size = minimizedSize
        content.Visible = false
        minimizeBtn.Text = "+"
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    else
        mainFrame.Size = originalSize
        content.Visible = true
        minimizeBtn.Text = "-"
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end

-- UPDATE UI STATS
local function updateUIStats(titleLabel, statusLabel)
    if _G.ZoAimbot then
        titleLabel.Text = "ZO AIMBOT 🎯 | LOCKED: " .. _G.ZoAimbot.TargetsLocked
        statusLabel.Text = "STATUS: " .. _G.ZoAimbot.Status
        statusLabel.BackgroundColor3 = _G.ZoAimbot.Enabled and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(150, 60, 60)
    end
end

-- INITIALIZE THE FUCKING UI
local function initializeUI()
    local ui = createMobileUI()
    local mainFrame = ui:FindFirstChild("MainFrame")
    local titleBar = mainFrame:FindFirstChild("TitleBar")
    local titleLabel = titleBar:FindFirstChild("Title")
    local minimizeBtn = titleBar:FindFirstChild("MinimizeBtn")
    local closeBtn = titleBar:FindFirstChild("CloseBtn")
    local content = mainFrame:FindFirstChild("Content")
    local statusLabel = content:FindFirstChild("Status")
    
    -- Get toggle buttons
    local togglesFrame = content:FindFirstChild("TogglesFrame")
    local aimbotToggle = togglesFrame:FindFirstChild("AimbotToggle")
    local espToggle = togglesFrame:FindFirstChild("ESPToggle")
    local teamToggle = togglesFrame:FindFirstChild("TeamCheckToggle")
    local predictionToggle = togglesFrame:FindFirstChild("PredictionToggle")

    -- Make draggable
    makeDraggable(mainFrame, titleBar)

    -- Minimize button functionality
    minimizeBtn.MouseButton1Click:Connect(function()
        toggleMinimize(mainFrame, minimizeBtn, content)
    end)

    -- Close button functionality
    closeBtn.MouseButton1Click:Connect(function()
        ui:Destroy()
        print("🗑️ UI CLOSED - AIMBOT STILL ACTIVE!")
    end)

    -- Toggle button functionality
    aimbotToggle.MouseButton1Click:Connect(function()
        if _G.ZoAimbot then
            _G.ZoAimbot.ToggleAimbot(not _G.ZoAimbot.Enabled)
            aimbotToggle.BackgroundColor3 = _G.ZoAimbot.Enabled and Color3.fromRGB(60, 150, 60) or Color3.fromRGB(150, 60, 60)
            aimbotToggle.Text = "AIMBOT: " .. (_G.ZoAimbot.Enabled and "ON" or "OFF")
            updateUIStats(titleLabel, statusLabel)
        end
    end)

    espToggle.MouseButton1Click:Connect(function()
        if _G.ZoAimbot then
            _G.ZoAimbot.ToggleESP(not _G.ZoAimbot.ESPEnabled)
            espToggle.BackgroundColor3 = _G.ZoAimbot.ESPEnabled and Color3.fromRGB(60, 150, 60) or Color3.fromRGB(150, 60, 60)
            espToggle.Text = "ESP: " .. (_G.ZoAimbot.ESPEnabled and "ON" or "OFF")
        end
    end)

    teamToggle.MouseButton1Click:Connect(function()
        if _G.ZoAimbot then
            _G.ZoAimbot.ToggleTeamCheck(not _G.ZoAimbot.TeamCheck)
            teamToggle.BackgroundColor3 = _G.ZoAimbot.TeamCheck and Color3.fromRGB(60, 150, 60) or Color3.fromRGB(150, 60, 60)
            teamToggle.Text = "TEAM CHECK: " .. (_G.ZoAimbot.TeamCheck and "ON" or "OFF")
        end
    end)

    predictionToggle.MouseButton1Click:Connect(function()
        if _G.ZoAimbot then
            _G.ZoAimbot.TogglePrediction(not _G.ZoAimbot.Prediction)
            predictionToggle.BackgroundColor3 = _G.ZoAimbot.Prediction and Color3.fromRGB(60, 150, 60) or Color3.fromRGB(150, 60, 60)
            predictionToggle.Text = "PREDICTION: " .. (_G.ZoAimbot.Prediction and "ON" or "OFF")
        end
    end)

    -- Update stats every second
    while ui.Parent do
        updateUIStats(titleLabel, statusLabel)
        wait(1)
    end

    print("📱 MOBILE UI LOADED! Drag, minimize with -, close with X.")
    return ui
end

-- START THE FUCKING UI
if _G.ZoAimbot then
    gui = initializeUI()
else
    warn("❌ Run main.lua first before ui.lua!")
end
