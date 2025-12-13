-- Xuan Hub - Modern Sidebar UI
-- Services
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- File System Setup
local ROOT = "XuanHub"
local SCRIPTS_DIR = ROOT .. "/Scripts"
local AUTOEXEC_FILE = ROOT .. "/autoexec.txt"
local LEGACY_AUTOEXEC = "autoexec.txt" -- For compatibility

if not isfolder(ROOT) then makefolder(ROOT) end
if not isfolder(SCRIPTS_DIR) then makefolder(SCRIPTS_DIR) end
if not isfile(AUTOEXEC_FILE) then writefile(AUTOEXEC_FILE, "-- Auto Execute Script\nprint('XuanHub AutoExec Loaded')") end

-- UI Constants
local THEME = {
    Background = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(30, 30, 30),
    Item = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(236, 72, 153), -- Pink
    Red = Color3.fromRGB(220, 50, 50),
    Green = Color3.fromRGB(50, 200, 100)
}

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XuanHubUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Header (Draggable)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = THEME.Sidebar
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

-- Fix bottom corners of header to be square
local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 10)
HeaderCover.Position = UDim2.new(0, 0, 1, -10)
HeaderCover.BackgroundColor3 = THEME.Sidebar
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "XuanHub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = THEME.Accent
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "-"
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = THEME.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local SidebarCover = Instance.new("Frame")
SidebarCover.Size = UDim2.new(0, 10, 1, 0)
SidebarCover.Position = UDim2.new(1, -10, 0, 0)
SidebarCover.BackgroundColor3 = THEME.Sidebar
SidebarCover.BorderSizePixel = 0
SidebarCover.Parent = Sidebar

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -160, 1, -50)
Content.Position = UDim2.new(0, 155, 0, 45)
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
FloatingBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingBtn

-- Dragging Logic
local function makeDraggable(obj, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(MainFrame, Header)
makeDraggable(FloatingBtn, FloatingBtn)

-- Minimize/Maximize
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingBtn.Visible = true
end)

FloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingBtn.Visible = false
end)

-- Navigation System
local currentTab = nil
local tabs = {}

local function createTabButton(name, icon, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 10 + (order * 40))
    btn.BackgroundColor3 = THEME.Background
    btn.Text = "  " .. name
    btn.TextColor3 = THEME.Text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

local function switchTab(name)
    if currentTab then
        currentTab.Button.BackgroundColor3 = THEME.Background
        currentTab.Button.TextColor3 = THEME.Text
        currentTab.Page.Visible = false
    end
    
    local newTab = tabs[name]
    if newTab then
        newTab.Button.BackgroundColor3 = THEME.Accent
        newTab.Button.TextColor3 = Color3.new(1,1,1)
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
AutoBox.Size = UDim2.new(1, 0, 1, -40)
AutoBox.BackgroundColor3 = THEME.Item
AutoBox.TextColor3 = THEME.Text
AutoBox.Font = Enum.Font.Code
AutoBox.TextSize = 14
AutoBox.TextXAlignment = Enum.TextXAlignment.Left
AutoBox.TextYAlignment = Enum.TextYAlignment.Top
AutoBox.ClearTextOnFocus = false
AutoBox.MultiLine = true
AutoBox.Text = readfile(AUTOEXEC_FILE)
AutoBox.Parent = AutoExecPage

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 6)
AutoCorner.Parent = AutoBox

local AutoSave = Instance.new("TextButton")
AutoSave.Size = UDim2.new(0, 100, 0, 30)
AutoSave.Position = UDim2.new(0, 0, 1, -30)
AutoSave.BackgroundColor3 = THEME.Accent
AutoSave.Text = "Save"
AutoSave.TextColor3 = Color3.new(1,1,1)
AutoSave.Font = Enum.Font.GothamBold
AutoSave.TextSize = 14
AutoSave.Parent = AutoExecPage

local AutoSaveCorner = Instance.new("UICorner")
AutoSaveCorner.CornerRadius = UDim.new(0, 6)
AutoSaveCorner.Parent = AutoSave

AutoSave.MouseButton1Click:Connect(function()
    writefile(AUTOEXEC_FILE, AutoBox.Text)
    writefile(LEGACY_AUTOEXEC, AutoBox.Text) -- Sync with legacy
    AutoSave.Text = "Saved!"
    wait(1)
    AutoSave.Text = "Save"
end)

-- PAGE: Scripts
local ScriptsPage = Instance.new("Frame")
ScriptsPage.Size = UDim2.new(1, 0, 1, 0)
ScriptsPage.BackgroundTransparency = 1
ScriptsPage.Visible = false
ScriptsPage.Parent = Content

local ScriptList = Instance.new("ScrollingFrame")
ScriptList.Size = UDim2.new(0, 180, 1, 0)
ScriptList.BackgroundColor3 = THEME.Item
ScriptList.ScrollBarThickness = 4
ScriptList.Parent = ScriptsPage

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = ScriptList

local ScriptEditor = Instance.new("TextBox")
ScriptEditor.Size = UDim2.new(1, -190, 1, -40)
ScriptEditor.Position = UDim2.new(0, 190, 0, 0)
ScriptEditor.BackgroundColor3 = THEME.Item
ScriptEditor.TextColor3 = THEME.Text
ScriptEditor.Font = Enum.Font.Code
ScriptEditor.TextSize = 14
ScriptEditor.TextXAlignment = Enum.TextXAlignment.Left
ScriptEditor.TextYAlignment = Enum.TextYAlignment.Top
ScriptEditor.ClearTextOnFocus = false
ScriptEditor.MultiLine = true
ScriptEditor.Text = "-- Select a script to edit"
ScriptEditor.Parent = ScriptsPage

local EditorCorner = Instance.new("UICorner")
EditorCorner.CornerRadius = UDim.new(0, 6)
EditorCorner.Parent = ScriptEditor

local CurrentScriptFile = nil

local ScriptControls = Instance.new("Frame")
ScriptControls.Size = UDim2.new(1, -190, 0, 30)
ScriptControls.Position = UDim2.new(0, 190, 1, -30)
ScriptControls.BackgroundTransparency = 1
ScriptControls.Parent = ScriptsPage

local function createScriptBtn(text, color, order, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Size = UDim2.new(0.23, 0, 1, 0)
    btn.Position = UDim2.new(0.25 * order, 0, 0, 0)
    btn.Parent = ScriptControls
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createScriptBtn("Run", THEME.Green, 0, function()
    if ScriptEditor.Text ~= "" then
        loadstring(ScriptEditor.Text)()
    end
end)

createScriptBtn("Save", THEME.Accent, 1, function()
    if CurrentScriptFile then
        writefile(SCRIPTS_DIR .. "/" .. CurrentScriptFile, ScriptEditor.Text)
    else
        -- New file logic could go here
    end
end)

createScriptBtn("New", THEME.Sidebar, 2, function()
    CurrentScriptFile = nil
    ScriptEditor.Text = ""
    -- Simple input for name
    local name = "Script_" .. math.random(1000) .. ".lua"
    CurrentScriptFile = name
    writefile(SCRIPTS_DIR .. "/" .. name, "")
    refreshScripts()
end)

createScriptBtn("Delete", THEME.Red, 3, function()
    if CurrentScriptFile then
        delfile(SCRIPTS_DIR .. "/" .. CurrentScriptFile)
        CurrentScriptFile = nil
        ScriptEditor.Text = ""
        refreshScripts()
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
        btn.Size = UDim2.new(1, -10, 0, 30)
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
            ScriptEditor.Text = readfile(file)
        end)
    end
    ScriptList.CanvasSize = UDim2.new(0, 0, 0, #files * 35)
end

-- Register Tabs
tabs["AutoExec"] = { Button = createTabButton("AutoExec", "", 0), Page = AutoExecPage }
tabs["Scripts"] = { Button = createTabButton("Scripts", "", 1), Page = ScriptsPage }

-- Button Events
tabs["AutoExec"].Button.MouseButton1Click:Connect(function() switchTab("AutoExec") end)
tabs["Scripts"].Button.MouseButton1Click:Connect(function() 
    switchTab("Scripts") 
    refreshScripts()
end)

-- Init
switchTab("AutoExec")
