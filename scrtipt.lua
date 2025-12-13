-- Xuan Hub AutoExecute Manager with Script Library

if not writefile or not readfile then
    warn("Executor does not support file functions")
    return
end

local SCRIPTS_FOLDER = "XuanHub/Scripts"
local AUTOEXEC_FILE = "XuanHub/autoexec.txt"
local UIS = game:GetService("UserInputService")

-- Ensure folder exists
pcall(function()
    if not isfolder("XuanHub") then makefolder("XuanHub") end
    if not isfolder(SCRIPTS_FOLDER) then makefolder(SCRIPTS_FOLDER) end
end)

-- Bright pink color scheme
local PANEL_BG = Color3.fromRGB(250, 235, 245)
local PANEL_TOP = Color3.fromRGB(252, 104, 170)
local PINK_PRIMARY = Color3.fromRGB(252, 104, 170)
local PINK_SECONDARY = Color3.fromRGB(255, 143, 194)
local PINK_LIGHT = Color3.fromRGB(255, 182, 214)
local PINK_ACCENT = Color3.fromRGB(230, 80, 150)
local TEXT_COLOR = Color3.fromRGB(60, 20, 50)
local TEXT_DIM = Color3.fromRGB(150, 80, 120)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")

-- Tab Buttons
local TabFrame = Instance.new("Frame")
local ScriptsTab = Instance.new("TextButton")
local AutoExecTab = Instance.new("TextButton")

-- Scripts Panel
local ScriptsPanel = Instance.new("Frame")
local ScriptsList = Instance.new("ScrollingFrame")
local AddNewBtn = Instance.new("TextButton")

-- AutoExec Panel
local AutoExecPanel = Instance.new("Frame")
local AutoExecBox = Instance.new("TextBox")
local AutoExecSaveBtn = Instance.new("TextButton")
local AutoExecLoadBtn = Instance.new("TextButton")
local AutoExecExecBtn = Instance.new("TextButton")

local Status = Instance.new("TextLabel")

ScreenGui.Name = "XuanHubScriptManager"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 420, 0, 380)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -190)
MainFrame.BackgroundColor3 = PANEL_BG
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = PINK_LIGHT
MainFrame.ClipsDescendants = true

-- Title Bar
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, -80, 0, 35)
TitleBar.BackgroundColor3 = PANEL_TOP
TitleBar.BorderSizePixel = 0
TitleBar.Text = "🌸 Xuan Hub"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 15
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
local titlePad = Instance.new("UIPadding", TitleBar)
titlePad.PaddingLeft = UDim.new(0, 12)

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 40, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 0)
MinimizeBtn.BackgroundColor3 = PINK_ACCENT
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16

CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 40, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 100)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22

-- Tabs
TabFrame.Parent = MainFrame
TabFrame.Size = UDim2.new(1, 0, 0, 32)
TabFrame.Position = UDim2.new(0, 0, 0, 35)
TabFrame.BackgroundColor3 = Color3.fromRGB(255, 220, 240)
TabFrame.BorderSizePixel = 0

ScriptsTab.Parent = TabFrame
ScriptsTab.Size = UDim2.new(0.5, 0, 1, 0)
ScriptsTab.Position = UDim2.new(0, 0, 0, 0)
ScriptsTab.BackgroundColor3 = PINK_SECONDARY
ScriptsTab.BorderSizePixel = 0
ScriptsTab.Text = "📜 Scripts"
ScriptsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptsTab.Font = Enum.Font.GothamBold
ScriptsTab.TextSize = 13

AutoExecTab.Parent = TabFrame
AutoExecTab.Size = UDim2.new(0.5, 0, 1, 0)
AutoExecTab.Position = UDim2.new(0.5, 0, 0, 0)
AutoExecTab.BackgroundColor3 = PINK_LIGHT
AutoExecTab.BorderSizePixel = 0
AutoExecTab.Text = "⚡ Auto Execute"
AutoExecTab.TextColor3 = TEXT_COLOR
AutoExecTab.Font = Enum.Font.GothamBold
AutoExecTab.TextSize = 13

-- Scripts Panel
ScriptsPanel.Parent = MainFrame
ScriptsPanel.Size = UDim2.new(1, 0, 1, -102)
ScriptsPanel.Position = UDim2.new(0, 0, 0, 67)
ScriptsPanel.BackgroundColor3 = PANEL_BG
ScriptsPanel.BorderSizePixel = 0
ScriptsPanel.Visible = true

ScriptsList.Parent = ScriptsPanel
ScriptsList.Size = UDim2.new(1, -16, 1, -50)
ScriptsList.Position = UDim2.new(0, 8, 0, 8)
ScriptsList.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
ScriptsList.BorderSizePixel = 1
ScriptsList.BorderColor3 = PINK_LIGHT
ScriptsList.ScrollBarThickness = 5
ScriptsList.CanvasSize = UDim2.new(0, 0, 0, 0)

AddNewBtn.Parent = ScriptsPanel
AddNewBtn.Size = UDim2.new(1, -16, 0, 34)
AddNewBtn.Position = UDim2.new(0, 8, 1, -42)
AddNewBtn.BackgroundColor3 = PINK_PRIMARY
AddNewBtn.BorderSizePixel = 0
AddNewBtn.Text = "+ New Script"
AddNewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddNewBtn.Font = Enum.Font.GothamBold
AddNewBtn.TextSize = 13

-- AutoExec Panel
AutoExecPanel.Parent = MainFrame
AutoExecPanel.Size = UDim2.new(1, 0, 1, -102)
AutoExecPanel.Position = UDim2.new(0, 0, 0, 67)
AutoExecPanel.BackgroundColor3 = PANEL_BG
AutoExecPanel.BorderSizePixel = 0
AutoExecPanel.Visible = false

AutoExecBox.Parent = AutoExecPanel
AutoExecBox.Size = UDim2.new(1, -16, 1, -52)
AutoExecBox.Position = UDim2.new(0, 8, 0, 8)
AutoExecBox.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
AutoExecBox.BorderSizePixel = 1
AutoExecBox.BorderColor3 = PINK_LIGHT
AutoExecBox.TextColor3 = TEXT_COLOR
AutoExecBox.PlaceholderText = "-- Auto-execute script (runs on join)"
AutoExecBox.PlaceholderColor3 = TEXT_DIM
AutoExecBox.Text = ""
AutoExecBox.MultiLine = true
AutoExecBox.ClearTextOnFocus = false
AutoExecBox.TextWrapped = true
AutoExecBox.TextXAlignment = Enum.TextXAlignment.Left
AutoExecBox.TextYAlignment = Enum.TextYAlignment.Top
AutoExecBox.Font = Enum.Font.Code
AutoExecBox.TextSize = 13

AutoExecSaveBtn.Parent = AutoExecPanel
AutoExecSaveBtn.Size = UDim2.new(0.32, -6, 0, 36)
AutoExecSaveBtn.Position = UDim2.new(0, 8, 1, -44)
AutoExecSaveBtn.BackgroundColor3 = PINK_PRIMARY
AutoExecSaveBtn.BorderSizePixel = 0
AutoExecSaveBtn.Text = "💾 Save"
AutoExecSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoExecSaveBtn.Font = Enum.Font.GothamBold
AutoExecSaveBtn.TextSize = 13

AutoExecLoadBtn.Parent = AutoExecPanel
AutoExecLoadBtn.Size = UDim2.new(0.32, -6, 0, 36)
AutoExecLoadBtn.Position = UDim2.new(0.34, 3, 1, -44)
AutoExecLoadBtn.BackgroundColor3 = PINK_SECONDARY
AutoExecLoadBtn.BorderSizePixel = 0
AutoExecLoadBtn.Text = "📂 Load"
AutoExecLoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoExecLoadBtn.Font = Enum.Font.GothamBold
AutoExecLoadBtn.TextSize = 13

AutoExecExecBtn.Parent = AutoExecPanel
AutoExecExecBtn.Size = UDim2.new(0.32, -6, 0, 36)
AutoExecExecBtn.Position = UDim2.new(0.68, 6, 1, -44)
AutoExecExecBtn.BackgroundColor3 = PINK_ACCENT
AutoExecExecBtn.BorderSizePixel = 0
AutoExecExecBtn.Text = "▶️ Run"
AutoExecExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoExecExecBtn.Font = Enum.Font.GothamBold
AutoExecExecBtn.TextSize = 13

Status.Parent = MainFrame
Status.Size = UDim2.new(1, 0, 0, 24)
Status.Position = UDim2.new(0, 0, 1, -24)
Status.BackgroundColor3 = Color3.fromRGB(255, 220, 240)
Status.BorderSizePixel = 0
Status.Text = "✨ Ready"
Status.TextColor3 = TEXT_DIM
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.TextXAlignment = Enum.TextXAlignment.Center

-- LOGIC
local currentScriptName = nil
local scriptButtons = {}
local contextMenu = nil

local function switchTab(showScripts)
    ScriptsPanel.Visible = showScripts
    AutoExecPanel.Visible = not showScripts
    
    if showScripts then
        ScriptsTab.BackgroundColor3 = PINK_SECONDARY
        ScriptsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        AutoExecTab.BackgroundColor3 = PINK_LIGHT
        AutoExecTab.TextColor3 = TEXT_COLOR
    else
        AutoExecTab.BackgroundColor3 = PINK_SECONDARY
        AutoExecTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        ScriptsTab.BackgroundColor3 = PINK_LIGHT
        ScriptsTab.TextColor3 = TEXT_COLOR
    end
end

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

local function showContextMenu(btn, filename)
    if contextMenu then contextMenu:Destroy() end
    
    contextMenu = Instance.new("Frame")
    contextMenu.Parent = ScreenGui
    contextMenu.Size = UDim2.new(0, 140, 0, 140)
    contextMenu.Position = UDim2.new(0, btn.AbsolutePosition.X + btn.AbsoluteSize.X + 5, 0, btn.AbsolutePosition.Y)
    contextMenu.BackgroundColor3 = Color3.fromRGB(255, 240, 250)
    contextMenu.BorderSizePixel = 1
    contextMenu.BorderColor3 = PINK_PRIMARY
    contextMenu.ZIndex = 100
    
    local function createOption(text, yPos, callback)
        local opt = Instance.new("TextButton")
        opt.Parent = contextMenu
        opt.Size = UDim2.new(1, 0, 0, 35)
        opt.Position = UDim2.new(0, 0, 0, yPos)
        opt.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
        opt.BorderSizePixel = 0
        opt.Text = text
        opt.TextColor3 = TEXT_COLOR
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 12
        opt.ZIndex = 101
        opt.MouseButton1Click:Connect(function()
            callback()
            contextMenu:Destroy()
            contextMenu = nil
        end)
        return opt
    end
    
    createOption("▶️ Execute", 0, function()
        local filepath = SCRIPTS_FOLDER .. "/" .. filename
        if isfile(filepath) then
            local code = readfile(filepath)
            pcall(function() loadstring(code)() end)
            Status.Text = "✅ Executed: " .. filename
        end
    end)
    
    createOption("📂 Load to AutoExec", 35, function()
        local filepath = SCRIPTS_FOLDER .. "/" .. filename
        if isfile(filepath) then
            local code = readfile(filepath)
            writefile(AUTOEXEC_FILE, code)
            Status.Text = "✅ Set as AutoExec: " .. filename
        end
    end)
    
    createOption("✏️ Edit", 70, function()
        currentScriptName = filename
        local filepath = SCRIPTS_FOLDER .. "/" .. filename
        if isfile(filepath) then
            AutoExecBox.Text = readfile(filepath)
            switchTab(false)
            Status.Text = "📝 Editing: " .. filename
        end
    end)
    
    createOption("🗑️ Delete", 105, function()
        local filepath = SCRIPTS_FOLDER .. "/" .. filename
        if isfile(filepath) then
            delfile(filepath)
            Status.Text = "🗑️ Deleted: " .. filename
            refreshScriptList()
        end
    end)
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
        btn.Size = UDim2.new(1, -6, 0, 30)
        btn.Position = UDim2.new(0, 3, 0, yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(255, 225, 245)
        btn.BorderSizePixel = 0
        btn.Text = "  📄 " .. filename:gsub("%.txt$", ""):gsub("%.lua$", "")
        btn.TextColor3 = TEXT_COLOR
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        
        btn.MouseButton1Click:Connect(function()
            showContextMenu(btn, filename)
        end)
        
        table.insert(scriptButtons, btn)
        yOffset = yOffset + 33
    end
    
    ScriptsList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

ScriptsTab.MouseButton1Click:Connect(function()
    switchTab(true)
end)

AutoExecTab.MouseButton1Click:Connect(function()
    switchTab(false)
end)

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
    Status.Text = "✅ Created: " .. newName
end)

AutoExecSaveBtn.MouseButton1Click:Connect(function()
    if AutoExecBox.Text == "" then
        Status.Text = "⚠️ Empty"
        return
    end
    pcall(function()
        writefile(AUTOEXEC_FILE, AutoExecBox.Text)
    end)
    Status.Text = "✅ AutoExec saved"
end)

AutoExecLoadBtn.MouseButton1Click:Connect(function()
    if isfile(AUTOEXEC_FILE) then
        AutoExecBox.Text = readfile(AUTOEXEC_FILE)
        Status.Text = "📜 AutoExec loaded"
    else
        Status.Text = "❌ No AutoExec file"
    end
end)

AutoExecExecBtn.MouseButton1Click:Connect(function()
    if AutoExecBox.Text == "" then
        Status.Text = "⚠️ Nothing to run"
        return
    end
    
    local ok, err = pcall(function()
        loadstring(AutoExecBox.Text)()
    end)
    
    if ok then
        Status.Text = "✅ Executed"
    else
        Status.Text = "❌ Error"
        warn(err)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 420, 0, 35)
        MinimizeBtn.Text = "□"
    else
        MainFrame.Size = UDim2.new(0, 420, 0, 380)
        MinimizeBtn.Text = "—"
    end
end)

ScreenGui.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if contextMenu and not contextMenu:IsAncestorOf(game:GetService("Players").LocalPlayer:GetMouse().Target) then
            contextMenu:Destroy()
            contextMenu = nil
        end
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
