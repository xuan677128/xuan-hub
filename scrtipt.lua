-- Xuan Hub AutoExecute Manager (Draggable)

if not writefile or not readfile then
    warn("Executor does not support file functions")
    return
end

local AUTOEXEC_FOLDER = "AutoExecute"
local FILE_PATH = AUTOEXEC_FOLDER .. "/autoexecute.txt"
local UIS = game:GetService("UserInputService")
local PANEL_GRADIENT_TOP = Color3.fromRGB(68, 14, 54)
local PANEL_GRADIENT_BOTTOM = Color3.fromRGB(34, 6, 30)
local BUTTON_PRIMARY = Color3.fromRGB(252, 104, 170)
local BUTTON_SECONDARY = Color3.fromRGB(210, 72, 140)
local BUTTON_NEUTRAL = Color3.fromRGB(146, 52, 108)
local BUTTON_DANGER = Color3.fromRGB(208, 38, 106)
local ICON_BUTTON_COLOR = Color3.fromRGB(94, 28, 80)
local TEXT_PRIMARY = Color3.fromRGB(255, 236, 247)
local TEXT_SECONDARY = Color3.fromRGB(234, 184, 214)
local STROKE_COLOR = Color3.fromRGB(255, 182, 214)

local function tryInstance(className)
    local ok, instance = pcall(Instance.new, className)
    if not ok then
        warn("Unable to create instance of", className, ":", instance)
        return nil
    end
    return instance
end

local function setSafe(object, property, value)
    local ok, err = pcall(function()
        object[property] = value
    end)
    if not ok then
        warn("Failed to set", property, "on", object.ClassName, ":", err)
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TitleBar = Instance.new("TextLabel")
local Box = Instance.new("TextBox")
local Save = Instance.new("TextButton")
local Clear = Instance.new("TextButton")
local Delete = Instance.new("TextButton")
local Load = Instance.new("TextButton")
local Status = Instance.new("TextLabel")
local Minimize = Instance.new("TextButton")
local Maximize = Instance.new("TextButton")

ScreenGui.Name = "XuanHubAutoExecute"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

if syn and syn.protect_gui then
    pcall(syn.protect_gui, ScreenGui)
end

local parentGui = typeof(gethui) == "function" and gethui()
if not parentGui then
    local ok, coreGui = pcall(game.GetService, game, "CoreGui")
    if ok then
        parentGui = coreGui
    else
        local players = game:GetService("Players")
        local localPlayer = players.LocalPlayer or players.PlayerAdded:Wait()
        parentGui = localPlayer:WaitForChild("PlayerGui")
    end
end
ScreenGui.Parent = parentGui

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 460, 0, 320)
Frame.Position = UDim2.new(0.5, -230, 0.5, -160)
Frame.BackgroundColor3 = PANEL_GRADIENT_TOP
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = false
local frameCorner = tryInstance("UICorner")
if frameCorner then
    frameCorner.CornerRadius = UDim.new(0, 14)
    frameCorner.Parent = Frame
end

local frameStroke = tryInstance("UIStroke")
if frameStroke then
    frameStroke.Color = STROKE_COLOR
    frameStroke.Transparency = 0.55
    frameStroke.Thickness = 1.4
    frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    frameStroke.Parent = Frame
end

local frameGradient = tryInstance("UIGradient")
if frameGradient then
    frameGradient.Color = ColorSequence.new(
        ColorSequenceKeypoint.new(0, PANEL_GRADIENT_TOP),
        ColorSequenceKeypoint.new(1, PANEL_GRADIENT_BOTTOM)
    )
    frameGradient.Rotation = 90
    frameGradient.Parent = Frame
end

local frameGlow = tryInstance("ImageLabel")
if frameGlow then
    frameGlow.Name = "Glow"
    frameGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    frameGlow.Position = UDim2.new(0.5, 0, 0.5, 6)
    frameGlow.Size = UDim2.new(1, 52, 1, 52)
    frameGlow.BackgroundTransparency = 1
    frameGlow.Image = "rbxassetid://4996891970"
    frameGlow.ImageColor3 = BUTTON_PRIMARY
    frameGlow.ImageTransparency = 0.55
    frameGlow.ZIndex = 0
    frameGlow.Active = false
    frameGlow.ScaleType = Enum.ScaleType.Stretch
    frameGlow.Parent = Frame
end
local expandedSize = Frame.Size
local minimizedSize = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 0, 40)

-- TITLE BAR (DRAG HANDLE)
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
setSafe(TitleBar, "Text", "🌸 Xuan Hub — AutoExecute Manager")
setSafe(TitleBar, "TextColor3", TEXT_PRIMARY)
setSafe(TitleBar, "BackgroundColor3", Color3.fromRGB(96, 24, 82))
setSafe(TitleBar, "BackgroundTransparency", 0.1)
setSafe(TitleBar, "Font", Enum.Font.GothamBold)
setSafe(TitleBar, "TextSize", 18)
setSafe(TitleBar, "BorderSizePixel", 0)
setSafe(TitleBar, "TextXAlignment", Enum.TextXAlignment.Left)
setSafe(TitleBar, "TextStrokeColor3", STROKE_COLOR)
setSafe(TitleBar, "TextStrokeTransparency", 0.7)
TitleBar.ZIndex = 2
local titlePadding = tryInstance("UIPadding")
if titlePadding then
    titlePadding.PaddingLeft = UDim.new(0, 16)
    titlePadding.Parent = TitleBar
end

-- TEXTBOX
Box.Parent = Frame
Box.Position = UDim2.new(0, 16, 0, 58)
Box.Size = UDim2.new(1, -32, 0, 160)
Box.MultiLine = true
Box.ClearTextOnFocus = false
Box.TextWrapped = true
Box.TextYAlignment = Enum.TextYAlignment.Top
Box.Font = Enum.Font.Code
setSafe(Box, "TextSize", 15)
setSafe(Box, "LineHeight", 1.25)
setSafe(Box, "Text", "")
setSafe(Box, "BackgroundColor3", Color3.fromRGB(54, 12, 46))
setSafe(Box, "TextColor3", TEXT_PRIMARY)
setSafe(Box, "PlaceholderText", "-- Paste your script here")
setSafe(Box, "PlaceholderColor3", TEXT_SECONDARY)
setSafe(Box, "TextXAlignment", Enum.TextXAlignment.Left)
setSafe(Box, "TextStrokeTransparency", 0.9)
local boxCorner = tryInstance("UICorner")
if boxCorner then
    boxCorner.CornerRadius = UDim.new(0, 10)
    boxCorner.Parent = Box
end

local boxStroke = tryInstance("UIStroke")
if boxStroke then
    boxStroke.Color = STROKE_COLOR
    boxStroke.Transparency = 0.75
    boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    boxStroke.Parent = Box
end

-- BUTTONS
Save.Parent = Frame
Save.Position = UDim2.new(0, 16, 0, 220)
Save.Size = UDim2.new(0.5, -26, 0, 36)
setSafe(Save, "Text", "💾 Save")
setSafe(Save, "BackgroundColor3", BUTTON_PRIMARY)
setSafe(Save, "TextColor3", TEXT_PRIMARY)
setSafe(Save, "Font", Enum.Font.GothamSemibold)
setSafe(Save, "TextSize", 14)
Save.AutoButtonColor = false

Load.Parent = Frame
Load.Position = UDim2.new(0.5, 10, 0, 220)
Load.Size = UDim2.new(0.5, -26, 0, 36)
setSafe(Load, "Text", "📂 Load Script")
setSafe(Load, "BackgroundColor3", BUTTON_SECONDARY)
setSafe(Load, "TextColor3", TEXT_PRIMARY)
setSafe(Load, "Font", Enum.Font.GothamSemibold)
setSafe(Load, "TextSize", 14)
Load.AutoButtonColor = false

Clear.Parent = Frame
Clear.Position = UDim2.new(0, 16, 0, 266)
Clear.Size = UDim2.new(0.3, -6, 0, 32)
setSafe(Clear, "Text", "🧹 Clear")
setSafe(Clear, "BackgroundColor3", BUTTON_NEUTRAL)
setSafe(Clear, "TextColor3", TEXT_PRIMARY)
setSafe(Clear, "Font", Enum.Font.GothamSemibold)
setSafe(Clear, "TextSize", 13)
Clear.AutoButtonColor = false

Delete.Parent = Frame
Delete.Position = UDim2.new(0.34, 6, 0, 266)
Delete.Size = UDim2.new(0.3, -6, 0, 32)
setSafe(Delete, "Text", "🗑 Delete")
setSafe(Delete, "BackgroundColor3", BUTTON_DANGER)
setSafe(Delete, "TextColor3", TEXT_PRIMARY)
setSafe(Delete, "Font", Enum.Font.GothamSemibold)
setSafe(Delete, "TextSize", 13)
Delete.AutoButtonColor = false

Status.Parent = Frame
Status.Position = UDim2.new(0.65, 4, 0, 266)
Status.Size = UDim2.new(0.34, -20, 0, 32)
setSafe(Status, "BackgroundColor3", Color3.fromRGB(62, 16, 52))
setSafe(Status, "BackgroundTransparency", 0.25)
setSafe(Status, "BorderSizePixel", 0)
setSafe(Status, "Font", Enum.Font.GothamSemibold)
setSafe(Status, "TextSize", 13)
setSafe(Status, "TextColor3", TEXT_SECONDARY)
setSafe(Status, "TextXAlignment", Enum.TextXAlignment.Center)
setSafe(Status, "TextYAlignment", Enum.TextYAlignment.Center)
setSafe(Status, "Text", "✨ Ready")
Status.ZIndex = 2
local statusCorner = tryInstance("UICorner")
if statusCorner then
    statusCorner.CornerRadius = UDim.new(0, 10)
    statusCorner.Parent = Status
end

local statusStroke = tryInstance("UIStroke")
if statusStroke then
    statusStroke.Color = STROKE_COLOR
    statusStroke.Transparency = 0.75
    statusStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    statusStroke.Parent = Status
end

Minimize.Parent = Frame
Minimize.Size = UDim2.new(0, 28, 0, 24)
Minimize.Position = UDim2.new(1, -80, 0, 8)
setSafe(Minimize, "BackgroundColor3", ICON_BUTTON_COLOR)
setSafe(Minimize, "TextColor3", TEXT_PRIMARY)
setSafe(Minimize, "Font", Enum.Font.GothamBold)
setSafe(Minimize, "TextSize", 16)
setSafe(Minimize, "Text", "—")
Minimize.AutoButtonColor = false
Minimize.ZIndex = 3

Maximize.Parent = Frame
Maximize.Size = UDim2.new(0, 28, 0, 24)
Maximize.Position = UDim2.new(1, -44, 0, 8)
setSafe(Maximize, "BackgroundColor3", ICON_BUTTON_COLOR)
setSafe(Maximize, "TextColor3", TEXT_PRIMARY)
setSafe(Maximize, "Font", Enum.Font.GothamBold)
setSafe(Maximize, "TextSize", 16)
setSafe(Maximize, "Text", "⬜")
Maximize.Visible = false
Maximize.AutoButtonColor = false
Maximize.ZIndex = 3

-- LOGIC
local minimized = false
local bodyElements = {Box, Save, Load, Clear, Delete, Status}
local folderReady = false

local function ensureAutoExecFolder()
    if folderReady then
        return true
    end

    local ok, err = pcall(function()
        if isfolder and not isfolder(AUTOEXEC_FOLDER) then
            if makefolder then
                makefolder(AUTOEXEC_FOLDER)
            end
        end
    end)

    if ok then
        folderReady = (not isfolder) or isfolder(AUTOEXEC_FOLDER)
        if not folderReady then
            Status.Text = "❗ Folder blocked"
            return false
        end
        return true
    else
        warn("Failed to prepare auto-execute folder:", err)
        Status.Text = "❗ Folder error"
        return false
    end
end

local function stylizeButton(button, baseColor, textSize, cornerRadius, font)
    local hovered = false
    local hoverColor = baseColor:Lerp(Color3.new(1, 1, 1), 0.18)
    local pressedColor = baseColor:Lerp(Color3.new(0, 0, 0), 0.2)

    button.AutoButtonColor = false
    button.BackgroundColor3 = baseColor
    button.TextColor3 = TEXT_PRIMARY
    button.Font = font or Enum.Font.GothamSemibold
    button.TextSize = textSize or button.TextSize
    button.ZIndex = math.max(button.ZIndex, 2)

    local corner = tryInstance("UICorner")
    if corner then
        corner.CornerRadius = UDim.new(0, cornerRadius or 10)
        corner.Parent = button
    end

    local stroke = tryInstance("UIStroke")
    if stroke then
        stroke.Color = STROKE_COLOR
        stroke.Transparency = 0.6
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = button
    end

    button.MouseEnter:Connect(function()
        hovered = true
        button.BackgroundColor3 = hoverColor
    end)

    button.MouseLeave:Connect(function()
        hovered = false
        button.BackgroundColor3 = baseColor
    end)

    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = pressedColor
    end)

    button.MouseButton1Up:Connect(function()
        if hovered then
            button.BackgroundColor3 = hoverColor
        else
            button.BackgroundColor3 = baseColor
        end
    end)
end

stylizeButton(Save, BUTTON_PRIMARY, 14)
stylizeButton(Load, BUTTON_SECONDARY, 14)
stylizeButton(Clear, BUTTON_NEUTRAL, 13)
stylizeButton(Delete, BUTTON_DANGER, 13)
stylizeButton(Minimize, ICON_BUTTON_COLOR, 16, 8, Enum.Font.GothamBold)
stylizeButton(Maximize, ICON_BUTTON_COLOR, 16, 8, Enum.Font.GothamBold)

-- Collapse or restore the UI body while keeping the title bar draggable
local function setMinimized(state)
    if minimized == state then
        return
    end

    minimized = state

    if minimized then
        expandedSize = Frame.Size
        Frame.Size = minimizedSize
        for _, element in ipairs(bodyElements) do
            element.Visible = false
        end
        Minimize.Visible = false
        Maximize.Visible = true
    else
        Frame.Size = expandedSize
        for _, element in ipairs(bodyElements) do
            element.Visible = true
        end
        Minimize.Visible = true
        Maximize.Visible = false
    end
end

Save.MouseButton1Click:Connect(function()
    if Box.Text == "" then
        Status.Text = "⚠️ Empty"
        return
    end
    if not ensureAutoExecFolder() then
        return
    end
    local ok, err = pcall(function()
        writefile(FILE_PATH, Box.Text)
    end)
    if ok then
        Status.Text = "✅ Saved"
    else
        warn("Failed to save auto-exec:", err)
        Status.Text = "❌ Save failed"
    end
end)

Load.MouseButton1Click:Connect(function()
    if isfile(FILE_PATH) then
        local ok, result = pcall(function()
            return readfile(FILE_PATH)
        end)
        if ok then
            Box.Text = result
            Status.Text = "📜 Loaded"
        else
            warn("Failed to load auto-exec:", result)
            Status.Text = "❌ Load failed"
        end
    else
        Status.Text = "❌ No file"
    end
end)

Clear.MouseButton1Click:Connect(function()
    Box.Text = ""
    Status.Text = "🧹 Cleared"
end)

Delete.MouseButton1Click:Connect(function()
    if isfile(FILE_PATH) then
        local ok, err = pcall(function()
            delfile(FILE_PATH)
        end)
        if ok then
            Status.Text = "🗑 Deleted"
        else
            warn("Failed to delete auto-exec:", err)
            Status.Text = "❌ Delete failed"
        end
    else
        Status.Text = "❌ No file"
    end
end)

Minimize.MouseButton1Click:Connect(function()
    setMinimized(true)
end)

Maximize.MouseButton1Click:Connect(function()
    setMinimized(false)
end)

-- 🔥 DRAGGING LOGIC
local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
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
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
