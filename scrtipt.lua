-- Xuan Hub AutoExecute Manager with Script Library

if not writefile or not readfile then
    warn("Executor does not support file functions")
    return
end

local SCRIPTS_FOLDER = "XuanHub/Scripts"
local UIS = game:GetService("UserInputService")

-- Ensure folder exists
pcall(function()
    if not isfolder("XuanHub") then makefolder("XuanHub") end
    if not isfolder(SCRIPTS_FOLDER) then makefolder(SCRIPTS_FOLDER) end
end)

-- Pink color scheme
local PANEL_BG = Color3.fromRGB(34, 6, 30)
local PANEL_TOP = Color3.fromRGB(68, 14, 54)
local PINK_PRIMARY = Color3.fromRGB(252, 104, 170)
local PINK_SECONDARY = Color3.fromRGB(210, 72, 140)
local PINK_DARK = Color3.fromRGB(146, 52, 108)
local TEXT_COLOR = Color3.fromRGB(255, 236, 247)
local TEXT_DIM = Color3.fromRGB(234, 184, 214)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")

-- Left Panel (Script List)
local LeftPanel = Instance.new("Frame")
local LeftTitle = Instance.new("TextLabel")
local ScriptsList = Instance.new("ScrollingFrame")
local AddNewBtn = Instance.new("TextButton")

-- Right Panel (Editor)
local RightPanel = Instance.new("Frame")
local RightTitle = Instance.new("TextLabel")
local EditorBox = Instance.new("TextBox")
local SaveBtn = Instance.new("TextButton")
local ExecuteBtn = Instance.new("TextButton")
local DeleteBtn = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

ScreenGui.Name = "XuanHubScriptManager"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 700, 0, 450)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
MainFrame.BackgroundColor3 = PANEL_BG
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Title Bar
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, -80, 0, 40)
TitleBar.BackgroundColor3 = PANEL_TOP
TitleBar.BorderSizePixel = 0
TitleBar.Text = "🌸 Xuan Hub — Script Manager"
TitleBar.TextColor3 = TEXT_COLOR
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 16
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
local titlePad = Instance.new("UIPadding", TitleBar)
titlePad.PaddingLeft = UDim.new(0, 15)

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(94, 28, 80)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = TEXT_COLOR
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18

CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(208, 38, 106)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = TEXT_COLOR
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24

-- Left Panel
LeftPanel.Parent = MainFrame
LeftPanel.Size = UDim2.new(0, 240, 1, -40)
LeftPanel.Position = UDim2.new(0, 0, 0, 40)
LeftPanel.BackgroundColor3 = Color3.fromRGB(28, 10, 24)
LeftPanel.BorderSizePixel = 0

LeftTitle.Parent = LeftPanel
LeftTitle.Size = UDim2.new(1, 0, 0, 35)
LeftTitle.BackgroundColor3 = Color3.fromRGB(48, 14, 40)
LeftTitle.BorderSizePixel = 0
LeftTitle.Text = "📂 My Scripts"
LeftTitle.TextColor3 = TEXT_COLOR
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.TextSize = 14

ScriptsList.Parent = LeftPanel
ScriptsList.Size = UDim2.new(1, -10, 1, -90)
ScriptsList.Position = UDim2.new(0, 5, 0, 40)
ScriptsList.BackgroundTransparency = 1
ScriptsList.BorderSizePixel = 0
ScriptsList.ScrollBarThickness = 6
ScriptsList.CanvasSize = UDim2.new(0, 0, 0, 0)

AddNewBtn.Parent = LeftPanel
AddNewBtn.Size = UDim2.new(1, -20, 0, 36)
AddNewBtn.Position = UDim2.new(0, 10, 1, -46)
AddNewBtn.BackgroundColor3 = PINK_PRIMARY
AddNewBtn.BorderSizePixel = 0
AddNewBtn.Text = "+ New Script"
AddNewBtn.TextColor3 = TEXT_COLOR
AddNewBtn.Font = Enum.Font.GothamBold
AddNewBtn.TextSize = 13

-- Right Panel
RightPanel.Parent = MainFrame
RightPanel.Size = UDim2.new(1, -240, 1, -40)
RightPanel.Position = UDim2.new(0, 240, 0, 40)
RightPanel.BackgroundColor3 = Color3.fromRGB(22, 8, 20)
RightPanel.BorderSizePixel = 0

RightTitle.Parent = RightPanel
RightTitle.Size = UDim2.new(1, 0, 0, 35)
RightTitle.BackgroundColor3 = Color3.fromRGB(48, 14, 40)
RightTitle.BorderSizePixel = 0
RightTitle.Text = "✏️ Editor"
RightTitle.TextColor3 = TEXT_COLOR
RightTitle.Font = Enum.Font.GothamBold
RightTitle.TextSize = 14

EditorBox.Parent = RightPanel
EditorBox.Size = UDim2.new(1, -20, 1, -120)
EditorBox.Position = UDim2.new(0, 10, 0, 45)
EditorBox.BackgroundColor3 = Color3.fromRGB(54, 12, 46)
EditorBox.BorderSizePixel = 0
EditorBox.TextColor3 = TEXT_COLOR
EditorBox.PlaceholderText = "-- Write or paste your script here"
EditorBox.PlaceholderColor3 = TEXT_DIM
EditorBox.Text = ""
EditorBox.MultiLine = true
EditorBox.ClearTextOnFocus = false
EditorBox.TextWrapped = true
EditorBox.TextXAlignment = Enum.TextXAlignment.Left
EditorBox.TextYAlignment = Enum.TextYAlignment.Top
EditorBox.Font = Enum.Font.Code
EditorBox.TextSize = 14

SaveBtn.Parent = RightPanel
SaveBtn.Size = UDim2.new(0.32, -8, 0, 38)
SaveBtn.Position = UDim2.new(0, 10, 1, -70)
SaveBtn.BackgroundColor3 = PINK_PRIMARY
SaveBtn.BorderSizePixel = 0
SaveBtn.Text = "💾 Save"
SaveBtn.TextColor3 = TEXT_COLOR
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 14

ExecuteBtn.Parent = RightPanel
ExecuteBtn.Size = UDim2.new(0.32, -8, 0, 38)
ExecuteBtn.Position = UDim2.new(0.34, 4, 1, -70)
ExecuteBtn.BackgroundColor3 = PINK_SECONDARY
ExecuteBtn.BorderSizePixel = 0
ExecuteBtn.Text = "▶️ Execute"
ExecuteBtn.TextColor3 = TEXT_COLOR
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 14

DeleteBtn.Parent = RightPanel
DeleteBtn.Size = UDim2.new(0.32, -8, 0, 38)
DeleteBtn.Position = UDim2.new(0.68, 8, 1, -70)
DeleteBtn.BackgroundColor3 = Color3.fromRGB(208, 38, 106)
DeleteBtn.BorderSizePixel = 0
DeleteBtn.Text = "🗑️ Delete"
DeleteBtn.TextColor3 = TEXT_COLOR
DeleteBtn.Font = Enum.Font.GothamBold
DeleteBtn.TextSize = 14

Status.Parent = RightPanel
Status.Size = UDim2.new(1, -20, 0, 22)
Status.Position = UDim2.new(0, 10, 1, -28)
Status.BackgroundTransparency = 1
Status.Text = "✨ Ready"
Status.TextColor3 = TEXT_DIM
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextXAlignment = Enum.TextXAlignment.Center

-- LOGIC
local currentScriptName = nil
local scriptButtons = {}

local function getScriptFiles()
    local files = {}
    pcall(function()
        if isfolder and listfiles then
            for _, filepath in pairs(listfiles(SCRIPTS_FOLDER)) do
                local filename = filepath:match("([^/\\]+)$")
                if filename:match("%.txt$") or filename:match("%.lua$") then
                    table.insert(files, filename)
                end
            end
        end
    end)
    return files
end

local function refreshScriptList()
    for _, btn in pairs(scriptButtons) do
        btn:Destroy()
    end
    scriptButtons = {}
    
    local files = getScriptFiles()
    local yOffset = 0
    
    for _, filename in ipairs(files) do
        local btn = Instance.new("TextButton")
        btn.Parent = ScriptsList
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.Position = UDim2.new(0, 0, 0, yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(48, 14, 40)
        btn.BorderSizePixel = 0
        btn.Text = "  " .. filename:gsub("%.txt$", ""):gsub("%.lua$", "")
        btn.TextColor3 = TEXT_COLOR
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        
        btn.MouseButton1Click:Connect(function()
            currentScriptName = filename
            local filepath = SCRIPTS_FOLDER .. "/" .. filename
            if isfile(filepath) then
                EditorBox.Text = readfile(filepath)
                Status.Text = "📜 Loaded: " .. filename
                RightTitle.Text = "✏️ Editing: " .. filename:gsub("%.txt$", ""):gsub("%.lua$", "")
            end
        end)
        
        table.insert(scriptButtons, btn)
        yOffset = yOffset + 36
    end
    
    ScriptsList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

AddNewBtn.MouseButton1Click:Connect(function()
    local scriptNum = 1
    local newName = "Script" .. scriptNum .. ".txt"
    
    while isfile(SCRIPTS_FOLDER .. "/" .. newName) do
        scriptNum = scriptNum + 1
        newName = "Script" .. scriptNum .. ".txt"
    end
    
    pcall(function()
        writefile(SCRIPTS_FOLDER .. "/" .. newName, "-- New script")
    end)
    
    refreshScriptList()
    currentScriptName = newName
    EditorBox.Text = "-- New script"
    RightTitle.Text = "✏️ Editing: " .. newName:gsub("%.txt$", "")
    Status.Text = "✅ Created: " .. newName
end)

SaveBtn.MouseButton1Click:Connect(function()
    if not currentScriptName then
        Status.Text = "⚠️ No script selected"
        return
    end
    
    if EditorBox.Text == "" then
        Status.Text = "⚠️ Editor is empty"
        return
    end
    
    local filepath = SCRIPTS_FOLDER .. "/" .. currentScriptName
    pcall(function()
        writefile(filepath, EditorBox.Text)
    end)
    Status.Text = "✅ Saved: " .. currentScriptName
end)

ExecuteBtn.MouseButton1Click:Connect(function()
    if EditorBox.Text == "" then
        Status.Text = "⚠️ Nothing to execute"
        return
    end
    
    local success, err = pcall(function()
        loadstring(EditorBox.Text)()
    end)
    
    if success then
        Status.Text = "✅ Executed successfully"
    else
        Status.Text = "❌ Error: " .. tostring(err):sub(1, 30)
        warn("Execution error:", err)
    end
end)

DeleteBtn.MouseButton1Click:Connect(function()
    if not currentScriptName then
        Status.Text = "⚠️ No script selected"
        return
    end
    
    local filepath = SCRIPTS_FOLDER .. "/" .. currentScriptName
    if isfile(filepath) then
        pcall(function()
            delfile(filepath)
        end)
        Status.Text = "🗑️ Deleted: " .. currentScriptName
        EditorBox.Text = ""
        RightTitle.Text = "✏️ Editor"
        currentScriptName = nil
        refreshScriptList()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 700, 0, 40)
        MinimizeBtn.Text = "□"
    else
        MainFrame.Size = UDim2.new(0, 700, 0, 450)
        MinimizeBtn.Text = "—"
    end
end)

-- DRAGGING
local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Initial load
refreshScriptList()
