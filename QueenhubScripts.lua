--==================================================
-- TFFA (THROW A FOOD FOR ANIMALS) - QUEEN HUB
-- Keyless Version
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local Theme = {
    BG      = Color3.fromRGB(15, 15, 18),
    Panel   = Color3.fromRGB(25, 25, 30),
    Sidebar = Color3.fromRGB(20, 20, 25),
    Text    = Color3.fromRGB(255, 255, 255),
    Muted   = Color3.fromRGB(130, 130, 140),
    Accent  = Color3.fromRGB(0, 200, 255), -- Cyan
    Good    = Color3.fromRGB(0, 255, 100),
    Bad     = Color3.fromRGB(255, 60, 60)
}

local State = {
    AutoTrain = false, AutoUpgrade = false, AutoThrow = false,
    AutoBuyFood = false, AutoPlacePet = false, AutoQuest = false,
    AutoBuyEvent = false, AutoFusePet = false
}

-- Cleanup
for _, name in ipairs({"TFFA_Main"}) do
    local old = PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

--==================================================
-- MAIN HUB UI
--==================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "TFFA_Main"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(550, 380)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Theme.BG
Main.BorderSizePixel = 0
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1
stroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Theme.Panel
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 15)
headerFix.Position = UDim2.new(0, 0, 1, -15)
headerFix.BackgroundColor3 = Theme.Panel
headerFix.BorderSizePixel = 0
headerFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "QUEEN HUB | TFFA"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(20, 20)
Close.Position = UDim2.new(1, -30, 0.5, -10)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Theme.Muted
Close.Font = Enum.Font.GothamBold
Close.Parent = Header
Close.MouseButton1Click:Connect(function() Gui:Destroy() end)

-- Drag Main
local drag, start, pos
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; start = i.Position; pos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - start; Main.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(120, 320)
Sidebar.Position = UDim2.fromOffset(10, 50)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local sideList = Instance.new("UIListLayout")
sideList.Padding = UDim.new(0, 2)
sideList.Parent = Sidebar

local tabs = {{"Farming", "🌾"}, {"Events", "🎃"}, {"Settings", "⚙️"}}
local tabBtns = {}

for i, data in ipairs(tabs) do
    local tb = Instance.new("TextButton")
    tb.Size = UDim2.new(1, 0, 0, 36)
    tb.BackgroundTransparency = 1
    tb.Text = "  " .. data[2] .. "  " .. data[1]
    tb.TextColor3 = (i == 1) and Theme.Accent or Theme.Muted
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = 13
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.BorderSizePixel = 0
    tb.Parent = Sidebar
    table.insert(tabBtns, tb)
end

-- Pages
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -140, 320, 0)
Pages.Position = UDim2.fromOffset(140, 50)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

local function MakePage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundColor3 = Theme.Panel
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = Theme.Accent
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new()
    p.Visible = (name == "Farming")
    p.Parent = Pages
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 8)
    
    local pad = Instance.new("UIPadding", p)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    
    local list = Instance.new("UIListLayout", p)
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    return p
end

local pFarm = MakePage("Farming")
local pEvent = MakePage("Events")
local pSettings = MakePage("Settings")

-- UI Components
local function MakeToggle(parent, text, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Theme.BG
    btn.Text = "  " .. text
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.fromOffset(40, 20)
    status.Position = UDim2.new(1, -45, 0.5, -10)
    status.BackgroundTransparency = 1
    status.Text = default and "ON" or "OFF"
    status.TextColor3 = default and Theme.Good or Theme.Muted
    status.Font = Enum.Font.GothamBold
    status.TextSize = 11
    status.Parent = btn
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        status.Text = state and "ON" or "OFF"
        status.TextColor3 = state and Theme.Good or Theme.Muted
        btn.BackgroundColor3 = state and Color3.fromRGB(35, 45, 35) or Theme.BG
        if callback then callback(state) end
    end)
end

-- Populate Pages
MakeToggle(pFarm, "1. Auto Train (Pull Ups)", false, function(v) State.AutoTrain = v end)
MakeToggle(pFarm, "2. Auto Upgrade (Strength)", false, function(v) State.AutoUpgrade = v end)
MakeToggle(pFarm, "3. Auto Throw (Perfect 20+)", false, function(v) State.AutoThrow = v end)
MakeToggle(pFarm, "4. Auto Buy Food", false, function(v) State.AutoBuyFood = v end)
MakeToggle(pFarm, "5. Auto Place Best Pet", false, function(v) State.AutoPlacePet = v end)

MakeToggle(pEvent, "1. Auto Quest", false, function(v) State.AutoQuest = v end)
MakeToggle(pEvent, "2. Auto Buy 2x Boosts", false, function(v) State.AutoBuyEvent = v end)
MakeToggle(pEvent, "3. Auto Fuse Best Pet", false, function(v) State.AutoFusePet = v end)

-- Settings Page
local smartLog = Instance.new("TextLabel")
smartLog.Size = UDim2.new(1, 0, 0, 60)
smartLog.BackgroundColor3 = Theme.BG
smartLog.Text = "Remote Engine: SCANNING...\nWaiting for game to load remotes."
smartLog.TextColor3 = Theme.Muted
smartLog.Font = Enum.Font.Code
smartLog.TextSize = 11
smartLog.TextWrapped = true
smartLog.Parent = pSettings
Instance.new("UICorner", smartLog).CornerRadius = UDim.new(0, 6)

-- Tab Switching
tabBtns[1].MouseButton1Click:Connect(function()
    pFarm.Visible = true; pEvent.Visible = false; pSettings.Visible = false
    tabBtns[1].TextColor3 = Theme.Accent; tabBtns[2].TextColor3 = Theme.Muted; tabBtns[3].TextColor3 = Theme.Muted
end)
tabBtns[2].MouseButton1Click:Connect(function()
    pFarm.Visible = false; pEvent.Visible = true; pSettings.Visible = false
    tabBtns[1].TextColor3 = Theme.Muted; tabBtns[2].TextColor3 = Theme.Accent; tabBtns[3].TextColor3 = Theme.Muted
end)
tabBtns[3].MouseButton1Click:Connect(function()
    pFarm.Visible = false; pEvent.Visible = false; pSettings.Visible = true
    tabBtns[1].TextColor3 = Theme.Muted; tabBtns[2].TextColor3 = Theme.Muted; tabBtns[3].TextColor3 = Theme.Accent
end)

--==================================================
-- REMOTE ENGINE (AUTOMATIC SCANNER)
--==================================================
local Remotes = {}
for _, v in ipairs(RS:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        table.insert(Remotes, v)
    end
end

smartLog.Text = "Found " .. tostring(#Remotes) .. " remotes. Engine Ready."

local function SafeFire(keyword, ...)
    for _, remote in ipairs(Remotes) do
        if remote.Name:lower():find(keyword) then
            pcall(function()
                if remote:IsA("RemoteEvent") then remote:FireServer(...)
                else remote:InvokeServer(...) end
            end)
        end
    end
end

--==================================================
-- AUTO FARM LOOPS
--==================================================
task.spawn(function()
    while task.wait(0.5) do
        if State.AutoTrain then SafeFire("train") end
        if State.AutoUpgrade then SafeFire("upgrade") end
        if State.AutoPlacePet then SafeFire("equip") end
        if State.AutoQuest then SafeFire("quest") end
        if State.AutoFusePet then SafeFire("fuse") end
    end
end)

-- Auto Throw
task.spawn(function()
    while task.wait(0.2) do
        if State.AutoThrow then
            local char = LP.Character
            local backpack = LP:FindFirstChild("Backpack")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if hum and backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:lower():find("food") or item.Name:lower():find("meat")) then
                        hum:EquipTool(item)
                        task.wait(0.1)
                        item:Activate()
                        task.wait(0.1)
                        hum:UnequipTools()
                        break
                    end
                end
            end
        end
    end
end)

-- Auto Buy
task.spawn(function()
    while task.wait(2) do
        if State.AutoBuyFood then SafeFire("buy") end
        if State.AutoBuyEvent then 
            SafeFire("buy", "2xStrength")
            SafeFire("buy", "2xMoney")
        end
    end
end)

--==================================================
-- FLOATING TOGGLE
--==================================================
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.fromOffset(50, 50)
floatBtn.Position = UDim2.fromOffset(20, 300)
floatBtn.AnchorPoint = Vector2.new(0, 1)
floatBtn.BackgroundColor3 = Theme.BG
floatBtn.Text = "Q"
floatBtn.TextColor3 = Theme.Accent
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 20
floatBtn.BorderSizePixel = 0
floatBtn.Parent = Gui
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)

local fStroke = Instance.new("UIStroke")
fStroke.Color = Theme.Accent
fStroke.Thickness = 2
fStroke.Parent = floatBtn

local fDrag, fMoved, fStart, fPos
floatBtn.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        fDrag = true; fMoved = false; fStart = i.Position; fPos = floatBtn.Position
    end 
end)
UIS.InputChanged:Connect(function(i) 
    if fDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
        local d = i.Position - fStart
        if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then fMoved = true end
        floatBtn.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + d.X, fPos.Y.Scale, fPos.Y.Offset + d.Y)
    end 
end)
UIS.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        fDrag = false
        if not fMoved then Main.Visible = not Main.Visible end
    end 
end)
 notify("QUEEN HUB LOADED")
end
