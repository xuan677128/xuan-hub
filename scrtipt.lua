
-- Xuan Hub - Modern Sidebar UI (Remastered)
-- Services
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- File System Setup
local ROOT = "XuanHub"
local SCRIPTS_DIR = ROOT .. "/Scripts"
local AUTOEXEC_DIR = ROOT .. "/Autoexecute"

if not isfolder(ROOT) then makefolder(ROOT) end
if not isfolder(SCRIPTS_DIR) then makefolder(SCRIPTS_DIR) end
if not isfolder(AUTOEXEC_DIR) then makefolder(AUTOEXEC_DIR) end

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local GameEvents = ReplicatedStorage:WaitForChild("GameEvents", 5)
local FarmFolder = workspace:FindFirstChild("Farm") or workspace:WaitForChild("Farm", 5)
local SellEvent = GameEvents and GameEvents:FindFirstChild("Sell_Inventory")
local BuySeedEvent = GameEvents and GameEvents:FindFirstChild("BuySeedStock")

-- Internal Auto Execution
pcall(function()
    local autoFiles = listfiles(AUTOEXEC_DIR)
    if #autoFiles == 0 then
        writefile(AUTOEXEC_DIR .. "/default.txt", "-- Put code here to run when XuanHub loads")
    end
    
    for _, file in pairs(listfiles(AUTOEXEC_DIR)) do
        if file:match("%.txt$") or file:match("%.lua$") then
            spawn(function()
                loadstring(readfile(file))()
            end)
        end
    end
end)

-- UI Constants
local THEME = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Item = Color3.fromRGB(35, 35, 40),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(236, 72, 153), -- Pink
    Hover = Color3.fromRGB(255, 100, 180),
    Red = Color3.fromRGB(220, 60, 60),
    Green = Color3.fromRGB(60, 200, 110),
    Stroke = Color3.fromRGB(50, 50, 60)
}

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XuanHubUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 10000 -- Ensure it's on top

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 350) -- Wider
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = THEME.Stroke
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- Notification System
local Notification = Instance.new("TextLabel")
Notification.Name = "Notification"
Notification.Size = UDim2.new(0, 200, 0, 30)
Notification.Position = UDim2.new(0.5, -100, 0.85, 0)
Notification.BackgroundColor3 = THEME.Sidebar
Notification.TextColor3 = THEME.Text
Notification.Font = Enum.Font.GothamBold
Notification.TextSize = 12
Notification.Text = "Notification"
Notification.TextWrapped = true -- Allow multi-line errors
Notification.Visible = false
Notification.ZIndex = 100
Notification.Parent = MainFrame

local NotifCorner = Instance.new("UICorner")
NotifCorner.CornerRadius = UDim.new(0, 6)
NotifCorner.Parent = Notification

local function notify(text, color)
    spawn(function()
        Notification.Text = text
        Notification.TextColor3 = color
        Notification.Visible = true
        wait(2)
        Notification.Visible = false
    end)
end

-- Header (Draggable)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = THEME.Sidebar
Header.BorderSizePixel = 0
Header.Active = true -- Important for Delta
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame") -- Square off bottom
HeaderCover.Size = UDim2.new(1, 0, 0, 10)
HeaderCover.Position = UDim2.new(0, 0, 1, -10)
HeaderCover.BackgroundColor3 = THEME.Sidebar
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "XuanHub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = THEME.Accent
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "-"
CloseBtn.Size = UDim2.new(0, 45, 1, 0)
CloseBtn.Position = UDim2.new(1, -90, 0, 0) -- Moved left
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = THEME.SubText
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = Header

local ExitBtn = Instance.new("TextButton")
ExitBtn.Text = "X"
ExitBtn.Size = UDim2.new(0, 45, 1, 0)
ExitBtn.Position = UDim2.new(1, -45, 0, 0)
ExitBtn.BackgroundTransparency = 1
ExitBtn.TextColor3 = THEME.Red
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextSize = 20
ExitBtn.Parent = Header

-- Sidebar
local Sidebar = Instance.new("ScrollingFrame") -- Scrollable
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -45) -- Narrower
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidebarCover = Instance.new("Frame") -- Square off right
SidebarCover.Size = UDim2.new(0, 10, 1, 0)
SidebarCover.Position = UDim2.new(1, -10, 0, 0)
SidebarCover.BackgroundColor3 = THEME.Sidebar
SidebarCover.BorderSizePixel = 0
SidebarCover.Parent = Sidebar

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -140, 1, -55) -- Adjusted
Content.Position = UDim2.new(0, 135, 0, 50) -- Adjusted
Content.BackgroundColor3 = THEME.Background
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Floating Button (Minimized)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
FloatingBtn.BackgroundColor3 = THEME.Sidebar
FloatingBtn.Text = "XH"
FloatingBtn.TextColor3 = THEME.Accent
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.TextSize = 20
FloatingBtn.Visible = false
FloatingBtn.Active = true -- Important for Delta
FloatingBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0) -- Circle
FloatCorner.Parent = FloatingBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = THEME.Accent
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatingBtn

-- Dragging Logic (Robust for Delta)
local function makeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

makeDraggable(Header, MainFrame)
makeDraggable(FloatingBtn, FloatingBtn)

-- Minimize/Maximize/Close
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingBtn.Visible = true
end)

ExitBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

FloatingBtn.MouseButton1Click:Connect(function()
    -- Check if it was a click or a drag (simple check: if mouse didn't move much)
    MainFrame.Visible = true
    FloatingBtn.Visible = false
end)

-- Navigation System
local currentTab = nil
local tabs = {}

local function createTabButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 10 + (order * 45))
    btn.BackgroundColor3 = THEME.Sidebar
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. name
    btn.TextColor3 = THEME.SubText
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

local function switchTab(name)
    if currentTab then
        TweenService:Create(currentTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = THEME.SubText}):Play()
        currentTab.Page.Visible = false
    end
    
    local newTab = tabs[name]
    if newTab then
        TweenService:Create(newTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = THEME.Item, TextColor3 = THEME.Accent}):Play()
        newTab.Page.Visible = true
        currentTab = newTab
    end
end

-- PAGE: Auto Execute
local AutoExecPage = Instance.new("Frame")
AutoExecPage.Size = UDim2.new(1, 0, 1, 0)
AutoExecPage.BackgroundTransparency = 1
AutoExecPage.Visible = false
AutoExecPage.Parent = Content

-- AutoExec List (Left Side)
local AutoListContainer = Instance.new("Frame")
AutoListContainer.Size = UDim2.new(0, 140, 1, 0)
AutoListContainer.BackgroundColor3 = THEME.Item
AutoListContainer.Parent = AutoExecPage

local AutoListCorner = Instance.new("UICorner")
AutoListCorner.CornerRadius = UDim.new(0, 8)
AutoListCorner.Parent = AutoListContainer

local AutoList = Instance.new("ScrollingFrame")
AutoList.Size = UDim2.new(1, -10, 1, -10)
AutoList.Position = UDim2.new(0, 5, 0, 5)
AutoList.BackgroundTransparency = 1
AutoList.ScrollBarThickness = 2
AutoList.AutomaticCanvasSize = Enum.AutomaticSize.Y
AutoList.CanvasSize = UDim2.new(0, 0, 0, 0)
AutoList.Parent = AutoListContainer

local AutoListLayout = Instance.new("UIListLayout")
AutoListLayout.Padding = UDim.new(0, 5)
AutoListLayout.Parent = AutoList

-- AutoExec Editor (Right Side)
local AutoEditorContainer = Instance.new("Frame")
AutoEditorContainer.Size = UDim2.new(1, -150, 1, 0)
AutoEditorContainer.Position = UDim2.new(0, 150, 0, 0)
AutoEditorContainer.BackgroundTransparency = 1
AutoEditorContainer.Parent = AutoExecPage

local AutoFileNameBox = Instance.new("TextBox")
AutoFileNameBox.Size = UDim2.new(1, 0, 0, 30)
AutoFileNameBox.Position = UDim2.new(0, 0, 0, 0)
AutoFileNameBox.BackgroundColor3 = THEME.Item
AutoFileNameBox.TextColor3 = THEME.Accent
AutoFileNameBox.Font = Enum.Font.GothamBold
AutoFileNameBox.TextSize = 14
AutoFileNameBox.Text = "AutoExec Name"
AutoFileNameBox.ClearTextOnFocus = false
AutoFileNameBox.Parent = AutoEditorContainer

local AutoFileCorner = Instance.new("UICorner")
AutoFileCorner.CornerRadius = UDim.new(0, 6)
AutoFileCorner.Parent = AutoFileNameBox

local AutoEditor = Instance.new("TextBox")
AutoEditor.Size = UDim2.new(1, 0, 1, -80)
AutoEditor.Position = UDim2.new(0, 0, 0, 35)
AutoEditor.BackgroundColor3 = THEME.Item
AutoEditor.TextColor3 = THEME.Text
AutoEditor.Font = Enum.Font.Code
AutoEditor.TextSize = 13
AutoEditor.TextXAlignment = Enum.TextXAlignment.Left
AutoEditor.TextYAlignment = Enum.TextYAlignment.Top
AutoEditor.ClearTextOnFocus = false
AutoEditor.MultiLine = true
AutoEditor.TextWrapped = true
AutoEditor.Text = "-- Select an auto-exec file"
AutoEditor.Parent = AutoEditorContainer

local AutoEditorPadding = Instance.new("UIPadding")
AutoEditorPadding.PaddingLeft = UDim.new(0, 8)
AutoEditorPadding.PaddingRight = UDim.new(0, 8)
AutoEditorPadding.PaddingTop = UDim.new(0, 8)
AutoEditorPadding.PaddingBottom = UDim.new(0, 8)
AutoEditorPadding.Parent = AutoEditor

local AutoEditorCorner = Instance.new("UICorner")
AutoEditorCorner.CornerRadius = UDim.new(0, 8)
AutoEditorCorner.Parent = AutoEditor

-- AutoExec Controls
local AutoControls = Instance.new("Frame")
AutoControls.Size = UDim2.new(1, 0, 0, 40)
AutoControls.Position = UDim2.new(0, 0, 1, -40)
AutoControls.BackgroundTransparency = 1
AutoControls.Parent = AutoEditorContainer

local CurrentAutoFile = nil

local function createAutoBtn(text, color, posScale, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Size = UDim2.new(0.24, 0, 0, 30) -- 4 buttons
    btn.Position = UDim2.new(posScale, 0, 0.5, -15)
    btn.Parent = AutoControls
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

function refreshAutoExec()
    for _, v in pairs(AutoList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    local files = listfiles(AUTOEXEC_DIR)
    for _, file in pairs(files) do
        local name = file:match("([^/]+)$")
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = THEME.Sidebar
        btn.Text = name
        btn.TextColor3 = THEME.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Parent = AutoList
        
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            CurrentAutoFile = name
            AutoFileNameBox.Text = name
            AutoEditor.Text = readfile(file)
            for _, b in pairs(AutoList:GetChildren()) do
                if b:IsA("TextButton") then b.BackgroundColor3 = THEME.Sidebar end
            end
            btn.BackgroundColor3 = THEME.Accent
        end)
    end
    AutoList.CanvasSize = UDim2.new(0, 0, 0, #files * 35)
end

-- Buttons: Save, New, Delete, Clear
createAutoBtn("💾", THEME.Accent, 0, function()
    if CurrentAutoFile then
        writefile(AUTOEXEC_DIR .. "/" .. CurrentAutoFile, AutoEditor.Text)
        notify("Saved AutoExec!", THEME.Accent)
    end
end)

createAutoBtn("📄", THEME.Sidebar, 0.25, function()
    CurrentAutoFile = nil
    AutoEditor.Text = ""
    local name = "Auto_" .. math.random(1000) .. ".txt"
    CurrentAutoFile = name
    AutoFileNameBox.Text = name
    writefile(AUTOEXEC_DIR .. "/" .. name, "")
    refreshAutoExec()
    notify("New AutoExec Created!", THEME.Sidebar)
end)

createAutoBtn("🗑", THEME.Red, 0.50, function()
    if CurrentAutoFile then
        delfile(AUTOEXEC_DIR .. "/" .. CurrentAutoFile)
        CurrentAutoFile = nil
        AutoEditor.Text = ""
        AutoFileNameBox.Text = "AutoExec Name"
        refreshAutoExec()
        notify("Deleted!", THEME.Red)
    end
end)

createAutoBtn("Clear", THEME.Sidebar, 0.75, function()
    AutoEditor.Text = ""
    notify("Cleared!", THEME.Sidebar)
end)

-- PAGE: Settings
local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = Content

local SettingsList = Instance.new("UIListLayout")
SettingsList.Padding = UDim.new(0, 10)
SettingsList.Parent = SettingsPage

-- Discord Section
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(1, 0, 0, 40)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord Blurple
DiscordBtn.Text = "Join Discord Server"
DiscordBtn.TextColor3 = Color3.new(1,1,1)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 14
DiscordBtn.Parent = SettingsPage

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 8)
DiscordCorner.Parent = DiscordBtn

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/kaydensdens")
    notify("Link Copied to Clipboard!", Color3.fromRGB(88, 101, 242))
end)

-- Theme Section
local ThemeLabel = Instance.new("TextLabel")
ThemeLabel.Size = UDim2.new(1, 0, 0, 30)
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.Text = "Theme Color"
ThemeLabel.TextColor3 = THEME.SubText
ThemeLabel.Font = Enum.Font.GothamBold
ThemeLabel.TextSize = 14
ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left
ThemeLabel.Parent = SettingsPage

local ColorContainer = Instance.new("Frame")
ColorContainer.Size = UDim2.new(1, 0, 0, 40)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = SettingsPage

local ColorLayout = Instance.new("UIListLayout")
ColorLayout.FillDirection = Enum.FillDirection.Horizontal
ColorLayout.Padding = UDim.new(0, 10)
ColorLayout.Parent = ColorContainer

local colors = {
    {Color3.fromRGB(236, 72, 153), "Pink"},
    {Color3.fromRGB(60, 200, 110), "Green"},
    {Color3.fromRGB(88, 101, 242), "Blue"},
    {Color3.fromRGB(220, 60, 60), "Red"},
    {Color3.fromRGB(255, 170, 0), "Orange"},
    {Color3.fromRGB(170, 0, 255), "Purple"}
}

local function updateAccent(newColor)
    THEME.Accent = newColor
    Title.TextColor3 = newColor
    FloatingBtn.TextColor3 = newColor
    FloatStroke.Color = newColor
    FileNameBox.TextColor3 = newColor
    
    -- Update active tab color if needed
    if currentTab then
        currentTab.Button.TextColor3 = newColor
    end
    
    -- Update Save Button (It's the 2nd button in Controls)
    -- We need to find it dynamically or store it. 
    -- Since we know the order, we can iterate.
    for _, btn in pairs(Controls:GetChildren()) do
        if btn:IsA("TextButton") and btn.Text == "💾" then
            btn.BackgroundColor3 = newColor
        end
    end
end

for _, colorData in ipairs(colors) do
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 30, 0, 30)
    colorBtn.BackgroundColor3 = colorData[1]
    colorBtn.Text = ""
    colorBtn.Parent = ColorContainer
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = colorBtn
    
    colorBtn.MouseButton1Click:Connect(function()
        updateAccent(colorData[1])
        notify("Theme Changed: " .. colorData[2], colorData[1])
    end)
end

-- Utilities Section
local UtilsLabel = Instance.new("TextLabel")
UtilsLabel.Size = UDim2.new(1, 0, 0, 30)
UtilsLabel.BackgroundTransparency = 1
UtilsLabel.Text = "Utilities"
UtilsLabel.TextColor3 = THEME.SubText
UtilsLabel.Font = Enum.Font.GothamBold
UtilsLabel.TextSize = 14
UtilsLabel.TextXAlignment = Enum.TextXAlignment.Left
UtilsLabel.Parent = SettingsPage

local UtilsContainer = Instance.new("Frame")
UtilsContainer.Size = UDim2.new(1, 0, 0, 170) -- Increased height for more buttons
UtilsContainer.BackgroundTransparency = 1
UtilsContainer.Parent = SettingsPage

local UtilsLayout = Instance.new("UIListLayout")
UtilsLayout.Padding = UDim.new(0, 10)
UtilsLayout.Parent = UtilsContainer

local function createUtilBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = THEME.Item
    btn.Text = text
    btn.TextColor3 = THEME.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = UtilsContainer
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Rejoin Server
createUtilBtn("Rejoin Server", function()
    notify("Rejoining...", THEME.Accent)
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

-- Server Hop (Public)
createUtilBtn("Server Hop (Public)", function()
    notify("Finding Server...", THEME.Accent)
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"
    
    local _place = game.PlaceId
    local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
    
    local function ListServers(cursor)
        local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
        return Http:JSONDecode(Raw)
    end
    
    local Server, Next; repeat
        local Servers = ListServers(Next)
        Server = Servers.data[1]
        Next = Servers.nextPageCursor
    until Server
    
    TPS:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
end)

-- Anti-AFK (Auto-enabled)
local antiAfkEnabled = true
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

createUtilBtn("Anti-AFK (Enabled)", function()
    notify("Anti-AFK is already enabled automatically!", THEME.Green)
end)

-- Auto Reconnect (Auto-enabled)
local autoRejoinEnabled = true
pcall(function()
    game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    end)
end)

createUtilBtn("Auto Reconnect (Enabled)", function()
    notify("Auto Reconnect is already enabled automatically!", THEME.Green)
end)

-- PAGE: About
local AboutPage = Instance.new("Frame")
AboutPage.Size = UDim2.new(1, 0, 1, 0)
AboutPage.BackgroundTransparency = 1
AboutPage.Visible = false
AboutPage.Parent = Content

local AboutContainer = Instance.new("Frame")
AboutContainer.Size = UDim2.new(1, 0, 0, 150)
AboutContainer.BackgroundColor3 = THEME.Item
AboutContainer.Parent = AboutPage

local AboutCorner = Instance.new("UICorner")
AboutCorner.CornerRadius = UDim.new(0, 8)
AboutCorner.Parent = AboutContainer

local AboutText = Instance.new("TextLabel")
AboutText.Size = UDim2.new(1, -20, 1, -10)
AboutText.Position = UDim2.new(0, 10, 0, 5)
AboutText.BackgroundTransparency = 1
AboutText.Text = "XuanHub Remastered v1.1\n\nA modern Script Hub designed for Mobile & PC.\n• Internal Auto-Execute System\n• Advanced Script Editor\n• Utilities (Anti-AFK, Rejoin, Server Hop)\n• Custom Themes\n\nI'm Xuan, Admin from Kaydens Server in Discord."
AboutText.TextColor3 = THEME.Text
AboutText.Font = Enum.Font.Gotham
AboutText.TextSize = 13
AboutText.TextWrapped = true
AboutText.TextXAlignment = Enum.TextXAlignment.Left
AboutText.TextYAlignment = Enum.TextYAlignment.Top
AboutText.Parent = AboutContainer

-- Garden automation functionality (UI removed, runs automatically)


InventoryBack.TextColor3 = THEME.Text
InventoryBack.Font = Enum.Font.GothamBold
InventoryBack.TextSize = 12
InventoryBack.Parent = InventoryFrame
local IB_Corner = Instance.new("UICorner")
IB_Corner.CornerRadius = UDim.new(0, 6)
IB_Corner.Parent = InventoryBack

InventoryBack.MouseButton1Click:Connect(function()
    InventoryFrame.Visible = false
    MethodContainer.Visible = true
end)

local StockLabel = Instance.new("TextLabel")
StockLabel.Text = "Seed Shop Stock"
StockLabel.Size = UDim2.new(0.45, 0, 0, 20)
StockLabel.Position = UDim2.new(0, 0, 0, 30)
StockLabel.BackgroundTransparency = 1
StockLabel.TextColor3 = THEME.SubText
StockLabel.Font = Enum.Font.GothamBold
StockLabel.TextSize = 12
StockLabel.Parent = InventoryFrame

local StockScroll = Instance.new("ScrollingFrame")
StockScroll.Size = UDim2.new(0.45, 0, 0.75, 0)
StockScroll.Position = UDim2.new(0, 0, 0, 55)
StockScroll.BackgroundColor3 = THEME.Item
StockScroll.ScrollBarThickness = 2
StockScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
StockScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
StockScroll.Parent = InventoryFrame
local StockCorner = Instance.new("UICorner")
StockCorner.CornerRadius = UDim.new(0, 8)
StockCorner.Parent = StockScroll
local StockLayout = Instance.new("UIListLayout")
StockLayout.Padding = UDim.new(0, 4)
StockLayout.Parent = StockScroll

local InventoryDetails = Instance.new("Frame")
InventoryDetails.Size = UDim2.new(0.45, 0, 0.75, 0)
InventoryDetails.Position = UDim2.new(0.55, 0, 0, 55)
InventoryDetails.BackgroundColor3 = THEME.Item
InventoryDetails.Parent = InventoryFrame
local InventoryDetailsCorner = Instance.new("UICorner")
InventoryDetailsCorner.CornerRadius = UDim.new(0, 8)
InventoryDetailsCorner.Parent = InventoryDetails
local InventoryDetailsPadding = Instance.new("UIPadding")
InventoryDetailsPadding.PaddingLeft = UDim.new(0, 10)
InventoryDetailsPadding.PaddingRight = UDim.new(0, 10)
InventoryDetailsPadding.PaddingTop = UDim.new(0, 10)
InventoryDetailsPadding.PaddingBottom = UDim.new(0, 10)
InventoryDetailsPadding.Parent = InventoryDetails
local InventoryDetailsLayout = Instance.new("UIListLayout")
InventoryDetailsLayout.Padding = UDim.new(0, 8)
InventoryDetailsLayout.SortOrder = Enum.SortOrder.LayoutOrder
InventoryDetailsLayout.Parent = InventoryDetails

local InventoryHeader = Instance.new("TextLabel")
InventoryHeader.Size = UDim2.new(1, 0, 0, 20)
InventoryHeader.BackgroundTransparency = 1
InventoryHeader.Text = "Seed Details"
InventoryHeader.TextColor3 = THEME.SubText
InventoryHeader.Font = Enum.Font.GothamBold
InventoryHeader.TextSize = 13
InventoryHeader.TextXAlignment = Enum.TextXAlignment.Left
InventoryHeader.Parent = InventoryDetails

local SelectedSeedNameLabel = Instance.new("TextLabel")
SelectedSeedNameLabel.Size = UDim2.new(1, 0, 0, 22)
SelectedSeedNameLabel.BackgroundTransparency = 1
SelectedSeedNameLabel.Text = "Select a seed to view info"
SelectedSeedNameLabel.TextColor3 = THEME.Text
SelectedSeedNameLabel.Font = Enum.Font.Gotham
SelectedSeedNameLabel.TextSize = 12
SelectedSeedNameLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedSeedNameLabel.Parent = InventoryDetails

local SelectedSeedStockLabel = Instance.new("TextLabel")
SelectedSeedStockLabel.Size = UDim2.new(1, 0, 0, 20)
SelectedSeedStockLabel.BackgroundTransparency = 1
SelectedSeedStockLabel.Text = "Stock: --"
SelectedSeedStockLabel.TextColor3 = THEME.SubText
SelectedSeedStockLabel.Font = Enum.Font.Gotham
SelectedSeedStockLabel.TextSize = 11
SelectedSeedStockLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedSeedStockLabel.Parent = InventoryDetails

local InventoryStatusLabel = Instance.new("TextLabel")
InventoryStatusLabel.Size = UDim2.new(1, 0, 0, 32)
InventoryStatusLabel.BackgroundTransparency = 1
InventoryStatusLabel.Text = "Open the Seed Shop to load stock."
InventoryStatusLabel.TextColor3 = THEME.SubText
InventoryStatusLabel.Font = Enum.Font.Gotham
InventoryStatusLabel.TextSize = 11
InventoryStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
InventoryStatusLabel.TextWrapped = true
InventoryStatusLabel.Parent = InventoryDetails

local InventoryButtons = Instance.new("Frame")
InventoryButtons.Size = UDim2.new(1, 0, 0, 150)
InventoryButtons.BackgroundTransparency = 1
InventoryButtons.Parent = InventoryDetails
local InventoryButtonsLayout = Instance.new("UIListLayout")
InventoryButtonsLayout.Padding = UDim.new(0, 6)
InventoryButtonsLayout.FillDirection = Enum.FillDirection.Vertical
InventoryButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
InventoryButtonsLayout.Parent = InventoryButtons

-- Magpie: Modern Header
local MagpieTitle = Instance.new("TextLabel")
MagpieTitle.Text = "Magpie Automation"
MagpieTitle.Size = UDim2.new(0.6, 0, 0, 32)
MagpieTitle.Position = UDim2.new(0, 0, 0, 25)
MagpieTitle.BackgroundTransparency = 1
MagpieTitle.TextColor3 = THEME.Text
MagpieTitle.Font = Enum.Font.GothamBold
MagpieTitle.TextSize = 22
MagpieTitle.TextXAlignment = Enum.TextXAlignment.Left
MagpieTitle.Parent = MagpieFrame

local MagpieSubtitle = Instance.new("TextLabel")
MagpieSubtitle.Text = "Automatically harvest fruits, shovel rares, and sell hauls while you relax."
MagpieSubtitle.Size = UDim2.new(0.8, 0, 0, 20)
MagpieSubtitle.Position = UDim2.new(0, 0, 0, 55)
MagpieSubtitle.BackgroundTransparency = 1
MagpieSubtitle.TextColor3 = THEME.SubText
MagpieSubtitle.Font = Enum.Font.Gotham
MagpieSubtitle.TextSize = 12
MagpieSubtitle.TextXAlignment = Enum.TextXAlignment.Left
MagpieSubtitle.Parent = MagpieFrame

-- Magpie: Automation Panel
local AutomationPanel = Instance.new("Frame")
AutomationPanel.Size = UDim2.new(1, 0, 0.7, 0)
AutomationPanel.Position = UDim2.new(0, 0, 0, 85)
AutomationPanel.BackgroundColor3 = THEME.Item
AutomationPanel.Parent = MagpieFrame
local AutomationCorner = Instance.new("UICorner")
AutomationCorner.CornerRadius = UDim.new(0, 10)
AutomationCorner.Parent = AutomationPanel
local AutomationPadding = Instance.new("UIPadding")
AutomationPadding.PaddingTop = UDim.new(0, 12)
AutomationPadding.PaddingLeft = UDim.new(0, 12)
AutomationPadding.PaddingRight = UDim.new(0, 12)
AutomationPadding.PaddingBottom = UDim.new(0, 12)
AutomationPadding.Parent = AutomationPanel

local AutomationHeader = Instance.new("TextLabel")
AutomationHeader.Text = "Automation Controls"
AutomationHeader.Size = UDim2.new(1, 0, 0, 22)
AutomationHeader.BackgroundTransparency = 1
AutomationHeader.TextColor3 = THEME.Text
AutomationHeader.Font = Enum.Font.GothamBold
AutomationHeader.TextSize = 14
AutomationHeader.TextXAlignment = Enum.TextXAlignment.Left
AutomationHeader.Parent = AutomationPanel

local AutomationSub = Instance.new("TextLabel")
AutomationSub.Text = "Flip the switches you need, then hit Launch to begin harvesting."
AutomationSub.Size = UDim2.new(1, 0, 0, 32)
AutomationSub.BackgroundTransparency = 1
AutomationSub.TextColor3 = THEME.SubText
AutomationSub.Font = Enum.Font.Gotham
AutomationSub.TextWrapped = true
AutomationSub.TextSize = 12
AutomationSub.TextXAlignment = Enum.TextXAlignment.Left
AutomationSub.Parent = AutomationPanel

local AutomationStatusLabel = Instance.new("TextLabel")
AutomationStatusLabel.Size = UDim2.new(1, 0, 0, 30)
AutomationStatusLabel.Position = UDim2.new(0, 0, 1, -80) -- Positioned above the launch button
AutomationStatusLabel.BackgroundTransparency = 1
AutomationStatusLabel.Text = "Status: Idle"
AutomationStatusLabel.TextColor3 = THEME.SubText
AutomationStatusLabel.Font = Enum.Font.GothamBold
AutomationStatusLabel.TextSize = 12
AutomationStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
AutomationStatusLabel.Parent = AutomationPanel

local function setAutomationStatus(text, color)
    if AutomationStatusLabel then
        AutomationStatusLabel.Text = "Status: " .. text
        AutomationStatusLabel.TextColor3 = color or THEME.SubText
    end
end

setAutomationStatus("Idle", THEME.SubText)










    local data, err = fetchSeedStockData()
    if not data then
        seedShopData = {}
        seedShopLookup = {}
        clearStockEntries()
        selectedStockName = nil
        updateSelectedSeedDisplay()
        setInventoryStatus(err or "Unable to read stock.", THEME.Red)
        return
    end

    seedShopData = data
    seedShopLookup = {}
    clearStockEntries()

    for _, entry in ipairs(data) do
        seedShopLookup[entry.Name] = entry
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 24)
        btn.BackgroundColor3 = THEME.Sidebar
        btn.TextColor3 = THEME.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.Text = string.format("%s • Stock: %d", entry.Name, entry.Stock)
        btn.Parent = StockScroll
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn
        btn.MouseButton1Click:Connect(function()
            selectedStockName = entry.Name
            updateSelectedSeedDisplay()
        end)
    end

    if #data == 0 then
        local placeholder = Instance.new("TextLabel")
        placeholder.Size = UDim2.new(1, -10, 0, 24)
        placeholder.BackgroundTransparency = 1
        placeholder.Text = "No stock found. Open the shop UI and refresh."
        placeholder.TextColor3 = THEME.SubText
        placeholder.Font = Enum.Font.Gotham
        placeholder.TextSize = 11
        placeholder.Parent = StockScroll
    end

    StockScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(#data * 28, 10))
    if selectedStockName and not seedShopLookup[selectedStockName] then
        selectedStockName = nil
    end
    updateSelectedSeedDisplay()
    setInventoryStatus(string.format("Found %d seed types.", #data), THEME.Green)
    if showNotif then
        notify("Seed stock refreshed!", THEME.Accent)
    end
end

local function runPurchaseOrders(orders, statusText, successText)
    if inventoryBusy then
        setInventoryStatus("Purchase already running.", THEME.Red)
        return
    end
    if not BuySeedEvent then
        setInventoryStatus("Buy remote unavailable.", THEME.Red)
        notify("Grow A Garden remote missing: BuySeedStock", THEME.Red)
        return
    end
    inventoryBusy = true
    setInventoryStatus(statusText, THEME.Accent)
    task.spawn(function()
        for _, order in ipairs(orders) do
            for i = 1, order.Count do
                BuySeedEvent:FireServer(order.Name)
                task.wait(0.05)
            end
        end
        inventoryBusy = false
        setInventoryStatus(successText or "Purchase complete!", THEME.Green)
        task.delay(0.3, function()
            refreshInventoryList()
        end)
    end)
end

local function buySelectedSeeds(amount)
    if not selectedStockName then
        setInventoryStatus("Select a seed first.", THEME.Red)
        return
    end
    local entry = seedShopLookup[selectedStockName]
    if not entry then
        setInventoryStatus("Refresh stock first.", THEME.Red)
        return
    end
    if entry.Stock <= 0 then
        setInventoryStatus("Seed is sold out.", THEME.Red)
        return
    end
    local qty = math.clamp(math.floor(amount or 1), 1, entry.Stock)
    runPurchaseOrders({{Name = selectedStockName, Count = qty}}, string.format("Buying %d %s...", qty, selectedStockName), "Selected purchase complete!")
end

local function buySelectedStock()
    if not selectedStockName then
        setInventoryStatus("Select a seed first.", THEME.Red)
        return
    end
    local entry = seedShopLookup[selectedStockName]
    if not entry then
        setInventoryStatus("Refresh stock first.", THEME.Red)
        return
    end
    if entry.Stock <= 0 then
        setInventoryStatus("Seed is sold out.", THEME.Red)
        return
    end
    runPurchaseOrders({{Name = selectedStockName, Count = entry.Stock}}, string.format("Buying all %s seeds...", selectedStockName), "Selected stock purchased!")
end

local function buyAllSeedsInShop()
    if #seedShopData == 0 then
        setInventoryStatus("Refresh stock first.", THEME.Red)
        return
    end
    local orders = {}
    local total = 0
    for _, entry in ipairs(seedShopData) do
        if entry.Stock > 0 then
            table.insert(orders, {Name = entry.Name, Count = entry.Stock})
            total = total + entry.Stock
        end
    end
    if total == 0 then
        setInventoryStatus("Everything is sold out.", THEME.Red)
        return
    end
    runPurchaseOrders(orders, string.format("Buying %d seeds...", total), "All available seeds purchased!")
end

local function setAutoBuyButtonState(enabled)
    if not AutoBuyAllButton then return end
    if enabled then
        AutoBuyAllButton.Text = "Auto Buy All (ON)"
        AutoBuyAllButton.BackgroundColor3 = THEME.Red
    else
        AutoBuyAllButton.Text = "Auto Buy All (OFF)"
        AutoBuyAllButton.BackgroundColor3 = THEME.Sidebar
    end
end

local function startAutoBuyAllLoop()
    if autoBuyAllThread then return end
    autoBuyAllThread = task.spawn(function()
        while autoBuyAllActive do
            refreshInventoryList()
            task.wait(0.2)
            if not autoBuyAllActive then
                break
            end
            buyAllSeedsInShop()
            local guard = 0
            while autoBuyAllActive and inventoryBusy and guard < 200 do
                task.wait(0.1)
                guard = guard + 1
            end
            local cooldown = 3
            local elapsed = 0
            while autoBuyAllActive and elapsed < cooldown do
                task.wait(0.5)
                elapsed = elapsed + 0.5
            end
        end
        autoBuyAllThread = nil
        if not autoBuyAllActive then
            setAutoBuyButtonState(false)
            setInventoryStatus("Auto-buy disabled.", THEME.SubText)
        end
    end)
end

local function createInventoryButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = InventoryButtons
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createInventoryButton("Refresh Stock", THEME.Sidebar, function()
    refreshInventoryList(true)
end)
createInventoryButton("Buy Selected (1)", THEME.Accent, function()
    buySelectedSeeds(1)
end)
createInventoryButton("Buy Selected Stock", THEME.Green, function()
    buySelectedStock()
end)
createInventoryButton("Buy All Seeds", THEME.Red, function()
    buyAllSeedsInShop()
end)
AutoBuyAllButton = createInventoryButton("Auto Buy All (OFF)", THEME.Sidebar, function()
    autoBuyAllActive = not autoBuyAllActive
    if autoBuyAllActive then
        setAutoBuyButtonState(true)
        setInventoryStatus("Auto-buy enabled. Keep the shop UI open.", THEME.Accent)
        startAutoBuyAllLoop()
    else
        setAutoBuyButtonState(false)
        setInventoryStatus("Auto-buy disabled.", THEME.SubText)
    end
end)




    if isSelling then return end
    if countCrops() == 0 then return end
    
    isSelling = true
    local character = getCharacter()
    if not (character and character.PrimaryPart) then 
        isSelling = false
        return 
    end

    -- Save current position
    local previousPosition = character.PrimaryPart.CFrame
    
    -- Step 1: Click the SELL button to teleport
    local sellBtn = findSellButton()
    if sellBtn then
        pcall(function()
            for _, connection in pairs(getconnections(sellBtn.MouseButton1Click)) do
                connection:Fire()
            end
        end)
        task.wait(1) -- Wait for teleport
    else
        -- Fallback to manual teleport if button not found
        character:PivotTo(SELL_POINT)
        task.wait(0.5)
    end
    
    -- Step 2: Click "Tap to talk" or proximity prompt
    local talkClicked = false
    for i = 1, 10 do
        if clickDialogOption("Tap to talk") or clickDialogOption("Talk") then
            talkClicked = true
            break
        end
        -- Try to find and trigger proximity prompt
        local npc = workspace:FindFirstChild("NPCs") or workspace
        for _, obj in ipairs(npc:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                fireproximityprompt(obj)
                talkClicked = true
                break
            end
        end
        if talkClicked then break end
        task.wait(0.2)
    end
    
    task.wait(0.5)
    
    -- Step 3: Click "I want to sell my inventory"
    local soldSuccessfully = false
    for i = 1, 15 do
        if clickDialogOption("I want to sell my inventory") or clickDialogOption("sell my inventory") then
            soldSuccessfully = true
            task.wait(0.5)
            break
        end
        task.wait(0.2)
    end
    
    -- Wait for selling to complete
    if soldSuccessfully or SellEvent then
        local attempts = 0
        local initialCount = countCrops()
        while countCrops() > 0 and attempts < 30 do
            if SellEvent then
                SellEvent:FireServer()
            end
            attempts = attempts + 1
            task.wait(0.2)
            -- Break if inventory decreased (selling is working)
            if countCrops() < initialCount then
                task.wait(1) -- Wait a bit more for full sale
                break
            end
        end
    end
    
    -- Step 4: Return to previous position
    task.wait(0.3)
    if character and character.PrimaryPart then
        character:PivotTo(previousPosition)
    end
    
    isSelling = false
end





-- PAGE: Scripts
local ScriptsPage = Instance.new("Frame")
ScriptsPage.Size = UDim2.new(1, 0, 1, 0)
ScriptsPage.BackgroundTransparency = 1
ScriptsPage.Visible = false
ScriptsPage.Parent = Content

-- Script List (Left Side of Content)
local ListContainer = Instance.new("Frame")
ListContainer.Size = UDim2.new(0, 140, 1, 0) -- Narrower
ListContainer.BackgroundColor3 = THEME.Item
ListContainer.Parent = ScriptsPage

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 8)
ListCorner.Parent = ListContainer

local ScriptList = Instance.new("ScrollingFrame")
ScriptList.Size = UDim2.new(1, -10, 1, -10)
ScriptList.Position = UDim2.new(0, 5, 0, 5)
ScriptList.BackgroundTransparency = 1
ScriptList.ScrollBarThickness = 2
ScriptList.AutomaticCanvasSize = Enum.AutomaticSize.Y -- Auto Scroll
ScriptList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptList.Parent = ListContainer

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = ScriptList

-- Editor Area (Right Side of Content)
local EditorContainer = Instance.new("Frame")
EditorContainer.Size = UDim2.new(1, -150, 1, 0) -- Adjusted
EditorContainer.Position = UDim2.new(0, 150, 0, 0) -- Adjusted
EditorContainer.BackgroundTransparency = 1
EditorContainer.Parent = ScriptsPage

local FileNameBox = Instance.new("TextBox")
FileNameBox.Size = UDim2.new(1, 0, 0, 30)
FileNameBox.Position = UDim2.new(0, 0, 0, 0)
FileNameBox.BackgroundColor3 = THEME.Item
FileNameBox.TextColor3 = THEME.Accent
FileNameBox.Font = Enum.Font.GothamBold
FileNameBox.TextSize = 14
FileNameBox.Text = "Script Name"
FileNameBox.ClearTextOnFocus = false
FileNameBox.Parent = EditorContainer

local FileCorner = Instance.new("UICorner")
FileCorner.CornerRadius = UDim.new(0, 6)
FileCorner.Parent = FileNameBox

local ScriptEditor = Instance.new("TextBox")
ScriptEditor.Size = UDim2.new(1, 0, 1, -80) -- Adjusted
ScriptEditor.Position = UDim2.new(0, 0, 0, 35)
ScriptEditor.BackgroundColor3 = THEME.Item
ScriptEditor.TextColor3 = THEME.Text
ScriptEditor.Font = Enum.Font.Code
ScriptEditor.TextSize = 13
ScriptEditor.TextXAlignment = Enum.TextXAlignment.Left
ScriptEditor.TextYAlignment = Enum.TextYAlignment.Top
ScriptEditor.ClearTextOnFocus = false
ScriptEditor.MultiLine = true
ScriptEditor.TextWrapped = true -- Fix overflow
ScriptEditor.Text = "-- Select a script to edit"
ScriptEditor.Parent = EditorContainer

local EditorPadding = Instance.new("UIPadding")
EditorPadding.PaddingLeft = UDim.new(0, 8)
EditorPadding.PaddingRight = UDim.new(0, 8)
EditorPadding.PaddingTop = UDim.new(0, 8)
EditorPadding.PaddingBottom = UDim.new(0, 8)
EditorPadding.Parent = ScriptEditor

local EditorCorner = Instance.new("UICorner")
EditorCorner.CornerRadius = UDim.new(0, 8)
EditorCorner.Parent = ScriptEditor

-- Controls (Bottom of Editor)
local Controls = Instance.new("Frame")
Controls.Size = UDim2.new(1, 0, 0, 40) -- Slightly taller
Controls.Position = UDim2.new(0, 0, 1, -40)
Controls.BackgroundTransparency = 1
Controls.Parent = EditorContainer

local CurrentScriptFile = nil

local function createControlBtn(text, color, posScale, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Size = UDim2.new(0.19, 0, 0, 30) -- Smaller width for 5 buttons
    btn.Position = UDim2.new(posScale, 0, 0.5, -15)
    btn.Parent = Controls
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Buttons: Run, Save, Rename, New, Delete
createControlBtn("▶", THEME.Green, 0, function()
    if ScriptEditor.Text ~= "" then
        loadstring(ScriptEditor.Text)()
        notify("Run Successful!", THEME.Green)
    end
end)

createControlBtn("💾", THEME.Accent, 0.20, function()
    if CurrentScriptFile then
        writefile(SCRIPTS_DIR .. "/" .. CurrentScriptFile, ScriptEditor.Text)
        notify("Saved Successfully!", THEME.Accent)
    end
end)

createControlBtn("✏️", THEME.Sidebar, 0.40, function()
    if CurrentScriptFile and FileNameBox.Text ~= "" then
        local newName = FileNameBox.Text
        if not newName:match("%.txt$") then newName = newName .. ".txt" end
        
        if newName ~= CurrentScriptFile then
            writefile(SCRIPTS_DIR .. "/" .. newName, ScriptEditor.Text)
            delfile(SCRIPTS_DIR .. "/" .. CurrentScriptFile)
            CurrentScriptFile = newName
            refreshScripts()
            notify("Renamed Successfully!", THEME.Sidebar)
        end
    end
end)

createControlBtn("📄", THEME.Sidebar, 0.60, function()
    CurrentScriptFile = nil
    ScriptEditor.Text = ""
    local name = "Script_" .. math.random(1000) .. ".txt"
    CurrentScriptFile = name
    FileNameBox.Text = name
    writefile(SCRIPTS_DIR .. "/" .. name, "")
    refreshScripts()
    notify("New File Created!", THEME.Sidebar)
end)

createControlBtn("🗑", THEME.Red, 0.80, function()
    if CurrentScriptFile then
        delfile(SCRIPTS_DIR .. "/" .. CurrentScriptFile)
        CurrentScriptFile = nil
        ScriptEditor.Text = ""
        FileNameBox.Text = "Script Name"
        refreshScripts()
        notify("Deleted Successfully!", THEME.Red)
    end
end)

function refreshScripts()
    for _, v in pairs(ScriptList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    local files = listfiles(SCRIPTS_DIR)
    for _, file in pairs(files) do
        local name = file:match("([^/]+)$")
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = THEME.Sidebar
        btn.Text = name
        btn.TextColor3 = THEME.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Parent = ScriptList
        
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            CurrentScriptFile = name
            FileNameBox.Text = name
            ScriptEditor.Text = readfile(file)
            -- Highlight selection
            for _, b in pairs(ScriptList:GetChildren()) do
                if b:IsA("TextButton") then b.BackgroundColor3 = THEME.Sidebar end
            end
            btn.BackgroundColor3 = THEME.Accent
        end)
    end
    ScriptList.CanvasSize = UDim2.new(0, 0, 0, #files * 35)
end

-- Register Tabs
tabs["AutoExec"] = { Button = createTabButton("AutoExec", 0), Page = AutoExecPage }
tabs["Scripts"] = { Button = createTabButton("Scripts", 1), Page = ScriptsPage }
tabs["Settings"] = { Button = createTabButton("Settings", 2), Page = SettingsPage }
tabs["About"] = { Button = createTabButton("About", 3), Page = AboutPage }

-- Button Events
tabs["AutoExec"].Button.MouseButton1Click:Connect(function() 
    switchTab("AutoExec") 
    refreshAutoExec()
end)
tabs["Scripts"].Button.MouseButton1Click:Connect(function() 
    switchTab("Scripts") 
    refreshScripts()
end)
tabs["Settings"].Button.MouseButton1Click:Connect(function() switchTab("Settings") end)
tabs["About"].Button.MouseButton1Click:Connect(function() switchTab("About") end)

-- Init
switchTab("AutoExec")
