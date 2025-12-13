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

-- Modern pink color scheme
local PANEL_BG = Color3.fromRGB(255, 250, 252)
local PANEL_TOP = Color3.fromRGB(255, 105, 180)
local PINK_PRIMARY = Color3.fromRGB(255, 105, 180)
local PINK_SECONDARY = Color3.fromRGB(255, 182, 214)
local PINK_LIGHT = Color3.fromRGB(255, 218, 235)
local PINK_ACCENT = Color3.fromRGB(255, 130, 195)
local CARD_BG = Color3.fromRGB(255, 255, 255)
local TEXT_COLOR = Color3.fromRGB(40, 40, 60)
local TEXT_DIM = Color3.fromRGB(120, 100, 130)
local SHADOW_COLOR = Color3.fromRGB(255, 182, 214)

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

-- Floating reopen button
local FloatingBtn = Instance.new("TextButton")

ScreenGui.Name = "XuanHubScriptManager"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 400, 0, 360)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -180)
MainFrame.BackgroundColor3 = CARD_BG
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = MainFrame

local mainShadow = Instance.new("ImageLabel")
mainShadow.Name = "Shadow"
mainShadow.Parent = MainFrame
mainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
mainShadow.BackgroundTransparency = 1
mainShadow.Position = UDim2.new(0.5, 0, 0.5, 6)
mainShadow.Size = UDim2.new(1, 30, 1, 30)
mainShadow.ZIndex = -1
mainShadow.Image = "rbxassetid://4996891970"
mainShadow.ImageColor3 = SHADOW_COLOR
mainShadow.ImageTransparency = 0.7

-- Title Bar
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = PANEL_TOP
TitleBar.BorderSizePixel = 0
TitleBar.Text = "🌸 Xuan Hub"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 16
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.ZIndex = 3

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = TitleBar

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, PANEL_TOP),
    ColorSequenceKeypoint.new(1, PINK_ACCENT)
}
titleGradient.Rotation = 45
titleGradient.Parent = TitleBar

local titlePad = Instance.new("UIPadding", TitleBar)
titlePad.PaddingLeft = UDim.new(0, 18)

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 36, 0, 36)
MinimizeBtn.Position = UDim2.new(1, -84, 0, 7)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundTransparency = 0.3
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.ZIndex = 4
MinimizeBtn.AutoButtonColor = false

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = MinimizeBtn

CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -44, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 120)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.ZIndex = 4
CloseBtn.AutoButtonColor = false

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = CloseBtn

-- Tabs
TabFrame.Parent = MainFrame
TabFrame.Size = UDim2.new(1, -32, 0, 44)
TabFrame.Position = UDim2.new(0, 16, 0, 58)
TabFrame.BackgroundTransparency = 1
TabFrame.BorderSizePixel = 0

ScriptsTab.Parent = TabFrame
ScriptsTab.Size = UDim2.new(0.48, 0, 1, 0)
ScriptsTab.Position = UDim2.new(0, 0, 0, 0)
ScriptsTab.BackgroundColor3 = PINK_PRIMARY
ScriptsTab.BorderSizePixel = 0
ScriptsTab.Text = "📜 Scripts"
ScriptsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptsTab.Font = Enum.Font.GothamBold
ScriptsTab.TextSize = 13
ScriptsTab.AutoButtonColor = false
ScriptsTab.ZIndex = 2

local scriptsCorner = Instance.new("UICorner")
scriptsCorner.CornerRadius = UDim.new(0, 12)
scriptsCorner.Parent = ScriptsTab

AutoExecTab.Parent = TabFrame
AutoExecTab.Size = UDim2.new(0.48, 0, 1, 0)
AutoExecTab.Position = UDim2.new(0.52, 0, 0, 0)
AutoExecTab.BackgroundColor3 = PINK_LIGHT
AutoExecTab.BorderSizePixel = 0
AutoExecTab.Text = "⚡ Auto Execute"
AutoExecTab.TextColor3 = TEXT_COLOR
AutoExecTab.Font = Enum.Font.GothamBold
AutoExecTab.TextSize = 13
AutoExecTab.AutoButtonColor = false
AutoExecTab.ZIndex = 2

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 12)
autoCorner.Parent = AutoExecTab

-- Scripts Panel
ScriptsPanel.Parent = MainFrame
ScriptsPanel.Size = UDim2.new(1, 0, 1, -128)
ScriptsPanel.Position = UDim2.new(0, 0, 0, 110)
ScriptsPanel.BackgroundTransparency = 1
ScriptsPanel.BorderSizePixel = 0
ScriptsPanel.Visible = true

ScriptsList.Parent = ScriptsPanel
ScriptsList.Size = UDim2.new(1, -32, 1, -58)
ScriptsList.Position = UDim2.new(0, 16, 0, 4)
ScriptsList.BackgroundColor3 = Color3.fromRGB(248, 248, 252)
ScriptsList.BorderSizePixel = 0
ScriptsList.ScrollBarThickness = 4
ScriptsList.ScrollBarImageColor3 = PINK_SECONDARY
ScriptsList.CanvasSize = UDim2.new(0, 0, 0, 0)

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 12)
listCorner.Parent = ScriptsList

AddNewBtn.Parent = ScriptsPanel
AddNewBtn.Size = UDim2.new(1, -32, 0, 42)
AddNewBtn.Position = UDim2.new(0, 16, 1, -46)
AddNewBtn.BackgroundColor3 = PINK_PRIMARY
AddNewBtn.BorderSizePixel = 0
AddNewBtn.Text = "+ New Script"
AddNewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddNewBtn.Font = Enum.Font.GothamBold
AddNewBtn.TextSize = 14
AddNewBtn.AutoButtonColor = false
AddNewBtn.ZIndex = 2

local addCorner = Instance.new("UICorner")
addCorner.CornerRadius = UDim.new(0, 12)
addCorner.Parent = AddNewBtn

local addStroke = Instance.new("UIStroke")
addStroke.Color = PINK_ACCENT
addStroke.Thickness = 0
addStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
addStroke.Parent = AddNewBtn

-- AutoExec Panel
AutoExecPanel.Parent = MainFrame
AutoExecPanel.Size = UDim2.new(1, 0, 1, -128)
AutoExecPanel.Position = UDim2.new(0, 0, 0, 110)
AutoExecPanel.BackgroundTransparency = 1
AutoExecPanel.BorderSizePixel = 0
AutoExecPanel.Visible = false

AutoExecBox.Parent = AutoExecPanel
AutoExecBox.Size = UDim2.new(1, -32, 1, -58)
AutoExecBox.Position = UDim2.new(0, 16, 0, 4)
AutoExecBox.BackgroundColor3 = Color3.fromRGB(248, 248, 252)
AutoExecBox.BorderSizePixel = 0
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
AutoExecBox.ZIndex = 2

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 12)
boxCorner.Parent = AutoExecBox

local boxPad = Instance.new("UIPadding")
boxPad.PaddingLeft = UDim.new(0, 12)
boxPad.PaddingRight = UDim.new(0, 12)
boxPad.PaddingTop = UDim.new(0, 10)
boxPad.PaddingBottom = UDim.new(0, 10)
boxPad.Parent = AutoExecBox

AutoExecSaveBtn.Parent = AutoExecPanel
AutoExecSaveBtn.Size = UDim2.new(0.31, 0, 0, 40)
AutoExecSaveBtn.Position = UDim2.new(0, 16, 1, -44)
AutoExecSaveBtn.BackgroundColor3 = PINK_PRIMARY
AutoExecSaveBtn.BorderSizePixel = 0
AutoExecSaveBtn.Text = "💾 Save"
AutoExecSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoExecSaveBtn.Font = Enum.Font.GothamBold
AutoExecSaveBtn.TextSize = 13
AutoExecSaveBtn.AutoButtonColor = false
AutoExecSaveBtn.ZIndex = 2

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 10)
saveCorner.Parent = AutoExecSaveBtn

AutoExecLoadBtn.Parent = AutoExecPanel
AutoExecLoadBtn.Size = UDim2.new(0.31, 0, 0, 40)
AutoExecLoadBtn.Position = UDim2.new(0.345, 0, 1, -44)
AutoExecLoadBtn.BackgroundColor3 = PINK_SECONDARY
AutoExecLoadBtn.BorderSizePixel = 0
AutoExecLoadBtn.Text = "📂 Load"
AutoExecLoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoExecLoadBtn.Font = Enum.Font.GothamBold
AutoExecLoadBtn.TextSize = 13
AutoExecLoadBtn.AutoButtonColor = false
AutoExecLoadBtn.ZIndex = 2

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 10)
loadCorner.Parent = AutoExecLoadBtn

AutoExecExecBtn.Parent = AutoExecPanel
AutoExecExecBtn.Size = UDim2.new(0.31, 0, 0, 40)
AutoExecExecBtn.Position = UDim2.new(0.69, 0, 1, -44)
AutoExecExecBtn.BackgroundColor3 = PINK_ACCENT
AutoExecExecBtn.BorderSizePixel = 0
AutoExecExecBtn.Text = "▶️ Run"
AutoExecExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoExecExecBtn.Font = Enum.Font.GothamBold
AutoExecExecBtn.TextSize = 13
AutoExecExecBtn.AutoButtonColor = false
AutoExecExecBtn.ZIndex = 2

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 10)
execCorner.Parent = AutoExecExecBtn

Status.Parent = MainFrame
Status.Size = UDim2.new(1, 0, 0, 28)
Status.Position = UDim2.new(0, 0, 1, -28)
Status.BackgroundColor3 = Color3.fromRGB(252, 245, 250)
Status.BorderSizePixel = 0
Status.Text = "✨ Ready"
Status.TextColor3 = TEXT_DIM
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.TextXAlignment = Enum.TextXAlignment.Center

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 16)
statusCorner.Parent = Status

-- Floating Button (hidden by default)
FloatingBtn.Parent = ScreenGui
FloatingBtn.Size = UDim2.new(0, 70, 0, 70)
FloatingBtn.Position = UDim2.new(1, -90, 1, -90)
FloatingBtn.BackgroundColor3 = PINK_PRIMARY
FloatingBtn.BorderSizePixel = 0
FloatingBtn.Text = "XuanHub"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.TextSize = 14
FloatingBtn.Visible = false
FloatingBtn.AutoButtonColor = false
FloatingBtn.TextWrapped = true

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = FloatingBtn

local floatShadow = Instance.new("ImageLabel")
floatShadow.Parent = FloatingBtn
floatShadow.AnchorPoint = Vector2.new(0.5, 0.5)
floatShadow.BackgroundTransparency = 1
floatShadow.Position = UDim2.new(0.5, 0, 0.5, 4)
floatShadow.Size = UDim2.new(1, 20, 1, 20)
floatShadow.ZIndex = -1
floatShadow.Image = "rbxassetid://4996891970"
floatShadow.ImageColor3 = SHADOW_COLOR
floatShadow.ImageTransparency = 0.5

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
    contextMenu.Size = UDim2.new(0, 150, 0, 150)
    contextMenu.Position = UDim2.new(0, btn.AbsolutePosition.X + btn.AbsoluteSize.X + 8, 0, btn.AbsolutePosition.Y)
    contextMenu.BackgroundColor3 = CARD_BG
    contextMenu.BorderSizePixel = 0
    contextMenu.ZIndex = 100
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 12)
    menuCorner.Parent = contextMenu
    
    local menuShadow = Instance.new("ImageLabel")
    menuShadow.Parent = contextMenu
    menuShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    menuShadow.BackgroundTransparency = 1
    menuShadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    menuShadow.Size = UDim2.new(1, 20, 1, 20)
    menuShadow.ZIndex = 99
    menuShadow.Image = "rbxassetid://4996891970"
    menuShadow.ImageColor3 = SHADOW_COLOR
    menuShadow.ImageTransparency = 0.6
    
    local function createOption(text, yPos, callback)
        local opt = Instance.new("TextButton")
        opt.Parent = contextMenu
        opt.Size = UDim2.new(1, -8, 0, 36)
        opt.Position = UDim2.new(0, 4, 0, yPos + 3)
        opt.BackgroundColor3 = CARD_BG
        opt.BorderSizePixel = 0
        opt.Text = text
        opt.TextColor3 = TEXT_COLOR
        opt.Font = Enum.Font.GothamSemibold
        opt.TextSize = 12
        opt.TextXAlignment = Enum.TextXAlignment.Left
        opt.ZIndex = 101
        opt.AutoButtonColor = false
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 8)
        optCorner.Parent = opt
        
        local optPad = Instance.new("UIPadding")
        optPad.PaddingLeft = UDim.new(0, 12)
        optPad.Parent = opt
        
        opt.MouseEnter:Connect(function()
            opt.BackgroundColor3 = PINK_LIGHT
        end)
        
        opt.MouseLeave:Connect(function()
            opt.BackgroundColor3 = CARD_BG
        end)
        
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
        btn.Size = UDim2.new(1, -16, 0, 38)
        btn.Position = UDim2.new(0, 8, 0, yOffset)
        btn.BackgroundColor3 = CARD_BG
        btn.BorderSizePixel = 0
        btn.Text = "  📄 " .. filename:gsub("%.txt$", ""):gsub("%.lua$", "")
        btn.TextColor3 = TEXT_COLOR
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 8)
        itemCorner.Parent = btn
        
        local itemStroke = Instance.new("UIStroke")
        itemStroke.Color = PINK_LIGHT
        itemStroke.Thickness = 1
        itemStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        itemStroke.Parent = btn
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = PINK_LIGHT
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = CARD_BG
        end)
        
        btn.MouseButton1Click:Connect(function()
            showContextMenu(btn, filename)
        end)
        
        table.insert(scriptButtons, btn)
        yOffset = yOffset + 42
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

-- Button hover effects
MinimizeBtn.MouseEnter:Connect(function()
    MinimizeBtn.BackgroundTransparency = 0.1
end)
MinimizeBtn.MouseLeave:Connect(function()
    MinimizeBtn.BackgroundTransparency = 0.3
end)

CloseBtn.MouseEnter:Connect(function()
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
end)
CloseBtn.MouseLeave:Connect(function()
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 120)
end)

AddNewBtn.MouseEnter:Connect(function()
    AddNewBtn.BackgroundColor3 = PINK_ACCENT
end)
AddNewBtn.MouseLeave:Connect(function()
    AddNewBtn.BackgroundColor3 = PINK_PRIMARY
end)

AutoExecSaveBtn.MouseEnter:Connect(function()
    AutoExecSaveBtn.BackgroundColor3 = PINK_ACCENT
end)
AutoExecSaveBtn.MouseLeave:Connect(function()
    AutoExecSaveBtn.BackgroundColor3 = PINK_PRIMARY
end)

AutoExecLoadBtn.MouseEnter:Connect(function()
    AutoExecLoadBtn.BackgroundColor3 = PINK_LIGHT
end)
AutoExecLoadBtn.MouseLeave:Connect(function()
    AutoExecLoadBtn.BackgroundColor3 = PINK_SECONDARY
end)

AutoExecExecBtn.MouseEnter:Connect(function()
    AutoExecExecBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 205)
end)
AutoExecExecBtn.MouseLeave:Connect(function()
    AutoExecExecBtn.BackgroundColor3 = PINK_ACCENT
end)

FloatingBtn.MouseEnter:Connect(function()
    FloatingBtn.Size = UDim2.new(0, 76, 0, 76)
end)
FloatingBtn.MouseLeave:Connect(function()
    FloatingBtn.Size = UDim2.new(0, 70, 0, 70)
end)

local minimized = false

local function toggleMinimize()
    minimized = not minimized
    if minimized then
        MainFrame.Visible = false
        FloatingBtn.Visible = true
    else
        MainFrame.Visible = true
        FloatingBtn.Visible = false
    end
end

MinimizeBtn.MouseButton1Click:Connect(function()
    toggleMinimize()
end)

FloatingBtn.MouseButton1Click:Connect(function()
    if minimized then
        toggleMinimize()
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

-- DRAGGING (Title Bar)
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
