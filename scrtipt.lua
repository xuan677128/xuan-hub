-- Xuan Hub - Modern Sidebar UI (Remastered)
-- Services
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- File System Setup
local ROOT = "XuanHub"
local SCRIPTS_DIR = ROOT .. "/Scripts"
local AUTOEXEC_DIR = ROOT .. "/Autoexecute"
local AUTOEXEC_FILE = AUTOEXEC_DIR .. "/autoexecute.txt"

if not isfolder(ROOT) then makefolder(ROOT) end
if not isfolder(SCRIPTS_DIR) then makefolder(SCRIPTS_DIR) end
if not isfolder(AUTOEXEC_DIR) then makefolder(AUTOEXEC_DIR) end

if not isfile(AUTOEXEC_FILE) then 
    writefile(AUTOEXEC_FILE, "-- Put code here to run when XuanHub loads\nprint('Internal AutoExec Loaded')") 
end

-- Internal Auto Execution
pcall(function()
    if isfile(AUTOEXEC_FILE) then
        loadstring(readfile(AUTOEXEC_FILE))()
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

local AutoBox = Instance.new("TextBox")
AutoBox.Size = UDim2.new(1, 0, 1, -45)
AutoBox.BackgroundColor3 = THEME.Item
AutoBox.TextColor3 = THEME.Text
AutoBox.Font = Enum.Font.Code
AutoBox.TextSize = 13
AutoBox.TextXAlignment = Enum.TextXAlignment.Left
AutoBox.TextYAlignment = Enum.TextYAlignment.Top
AutoBox.ClearTextOnFocus = false
AutoBox.MultiLine = true
AutoBox.TextWrapped = true
AutoBox.Text = readfile(AUTOEXEC_FILE)
AutoBox.Parent = AutoExecPage

local AutoPadding = Instance.new("UIPadding")
AutoPadding.PaddingLeft = UDim.new(0, 8)
AutoPadding.PaddingRight = UDim.new(0, 8)
AutoPadding.PaddingTop = UDim.new(0, 8)
AutoPadding.PaddingBottom = UDim.new(0, 8)
AutoPadding.Parent = AutoBox

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 8)
AutoCorner.Parent = AutoBox

local AutoClear = Instance.new("TextButton")
AutoClear.Size = UDim2.new(0, 120, 0, 35)
AutoClear.Position = UDim2.new(1, -250, 1, -35)
AutoClear.BackgroundColor3 = THEME.Sidebar
AutoClear.Text = "Clear"
AutoClear.TextColor3 = THEME.Text
AutoClear.Font = Enum.Font.GothamBold
AutoClear.TextSize = 14
AutoClear.Parent = AutoExecPage

local AutoClearCorner = Instance.new("UICorner")
AutoClearCorner.CornerRadius = UDim.new(0, 8)
AutoClearCorner.Parent = AutoClear

AutoClear.MouseButton1Click:Connect(function()
    AutoBox.Text = ""
    notify("Cleared!", THEME.Sidebar)
end)

local AutoSave = Instance.new("TextButton")
AutoSave.Size = UDim2.new(0, 120, 0, 35)
AutoSave.Position = UDim2.new(1, -120, 1, -35)
AutoSave.BackgroundColor3 = THEME.Accent
AutoSave.Text = "Save AutoExec"
AutoSave.TextColor3 = Color3.new(1,1,1)
AutoSave.Font = Enum.Font.GothamBold
AutoSave.TextSize = 14
AutoSave.Parent = AutoExecPage

local AutoSaveCorner = Instance.new("UICorner")
AutoSaveCorner.CornerRadius = UDim.new(0, 8)
AutoSaveCorner.Parent = AutoSave

AutoSave.MouseButton1Click:Connect(function()
    writefile(AUTOEXEC_FILE, AutoBox.Text)
    AutoSave.Text = "Saved!"
    notify("AutoExec Saved!", THEME.Green)
    wait(1)
    AutoSave.Text = "Save AutoExec"
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
AboutText.Text = "XuanHub Remastered\n\nA modern Script Hub designed for Mobile & PC.\n• Internal Auto-Execute System\n• Advanced Script Editor\n• Custom Themes\n\nI'm Xuan, Admin from Kaydens Server in Discord."
AboutText.TextColor3 = THEME.Text
AboutText.Font = Enum.Font.Gotham
AboutText.TextSize = 13
AboutText.TextWrapped = true
AboutText.TextXAlignment = Enum.TextXAlignment.Left
AboutText.TextYAlignment = Enum.TextYAlignment.Top
AboutText.Parent = AboutContainer

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
tabs["AutoExec"].Button.MouseButton1Click:Connect(function() switchTab("AutoExec") end)
tabs["Scripts"].Button.MouseButton1Click:Connect(function() 
    switchTab("Scripts") 
    refreshScripts()
end)
tabs["Settings"].Button.MouseButton1Click:Connect(function() switchTab("Settings") end)
tabs["About"].Button.MouseButton1Click:Connect(function() switchTab("About") end)

-- Init
switchTab("AutoExec")
