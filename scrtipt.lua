-- Xuan Hub AutoExecute Manager (Draggable)

if not writefile or not readfile then
    warn("Executor does not support file functions")
    return
end

local FILE_PATH = "AutoExecute/autoexecute.txt"
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
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 460, 0, 320)
Frame.Position = UDim2.new(0.5, -230, 0.5, -160)
Frame.BackgroundColor3 = PANEL_GRADIENT_TOP
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = false
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = Frame
local frameStroke = Instance.new("UIStroke")
frameStroke.Color = STROKE_COLOR
frameStroke.Transparency = 0.55
frameStroke.Thickness = 1.4
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
frameStroke.Parent = Frame
local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new(
    ColorSequenceKeypoint.new(0, PANEL_GRADIENT_TOP),
    ColorSequenceKeypoint.new(1, PANEL_GRADIENT_BOTTOM)
)
frameGradient.Rotation = 90
frameGradient.Parent = Frame
local frameGlow = Instance.new("ImageLabel")
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
local expandedSize = Frame.Size
local minimizedSize = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 0, 40)

-- TITLE BAR (DRAG HANDLE)
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Text = "🌸 Xuan Hub — AutoExecute Manager"
TitleBar.TextColor3 = TEXT_PRIMARY
TitleBar.BackgroundColor3 = Color3.fromRGB(96, 24, 82)
TitleBar.BackgroundTransparency = 0.1
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 18
TitleBar.BorderSizePixel = 0
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.TextStrokeColor3 = STROKE_COLOR
TitleBar.TextStrokeTransparency = 0.7
TitleBar.ZIndex = 2
local titlePadding = Instance.new("UIPadding")
titlePadding.PaddingLeft = UDim.new(0, 16)
titlePadding.Parent = TitleBar

-- TEXTBOX
Box.Parent = Frame
Box.Position = UDim2.new(0, 16, 0, 58)
Box.Size = UDim2.new(1, -32, 0, 160)
Box.MultiLine = true
Box.ClearTextOnFocus = false
Box.TextWrapped = true
Box.TextYAlignment = Enum.TextYAlignment.Top
Box.Font = Enum.Font.Code
Box.TextSize = 15
Box.LineHeight = 1.25
Box.Text = ""
Box.BackgroundColor3 = Color3.fromRGB(54, 12, 46)
Box.TextColor3 = TEXT_PRIMARY
Box.PlaceholderText = "-- Paste your script here"
Box.PlaceholderColor3 = TEXT_SECONDARY
Box.TextXAlignment = Enum.TextXAlignment.Left
Box.TextStrokeTransparency = 0.9
local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 10)
boxCorner.Parent = Box
local boxStroke = Instance.new("UIStroke")
boxStroke.Color = STROKE_COLOR
boxStroke.Transparency = 0.75
boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
boxStroke.Parent = Box

-- BUTTONS
Save.Parent = Frame
Save.Position = UDim2.new(0, 16, 0, 220)
Save.Size = UDim2.new(0.5, -26, 0, 36)
Save.Text = "💾 Save"
Save.BackgroundColor3 = BUTTON_PRIMARY
Save.TextColor3 = TEXT_PRIMARY
Save.Font = Enum.Font.GothamSemibold
Save.TextSize = 14
Save.AutoButtonColor = false

Load.Parent = Frame
Load.Position = UDim2.new(0.5, 10, 0, 220)
Load.Size = UDim2.new(0.5, -26, 0, 36)
Load.Text = "📂 Load Script"
Load.BackgroundColor3 = BUTTON_SECONDARY
Load.TextColor3 = TEXT_PRIMARY
Load.Font = Enum.Font.GothamSemibold
Load.TextSize = 14
Load.AutoButtonColor = false

Clear.Parent = Frame
Clear.Position = UDim2.new(0, 16, 0, 266)
Clear.Size = UDim2.new(0.3, -6, 0, 32)
Clear.Text = "🧹 Clear"
Clear.BackgroundColor3 = BUTTON_NEUTRAL
Clear.TextColor3 = TEXT_PRIMARY
Clear.Font = Enum.Font.GothamSemibold
Clear.TextSize = 13
Clear.AutoButtonColor = false

Delete.Parent = Frame
Delete.Position = UDim2.new(0.34, 6, 0, 266)
Delete.Size = UDim2.new(0.3, -6, 0, 32)
Delete.Text = "🗑 Delete"
Delete.BackgroundColor3 = BUTTON_DANGER
Delete.TextColor3 = TEXT_PRIMARY
Delete.Font = Enum.Font.GothamSemibold
Delete.TextSize = 13
Delete.AutoButtonColor = false

Status.Parent = Frame
Status.Position = UDim2.new(0.65, 4, 0, 266)
Status.Size = UDim2.new(0.34, -20, 0, 32)
Status.BackgroundColor3 = Color3.fromRGB(62, 16, 52)
Status.BackgroundTransparency = 0.25
Status.BorderSizePixel = 0
Status.Font = Enum.Font.GothamSemibold
Status.TextSize = 13
Status.TextColor3 = TEXT_SECONDARY
Status.TextXAlignment = Enum.TextXAlignment.Center
Status.TextYAlignment = Enum.TextYAlignment.Center
Status.Text = "✨ Ready"
Status.ZIndex = 2
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = Status
local statusStroke = Instance.new("UIStroke")
statusStroke.Color = STROKE_COLOR
statusStroke.Transparency = 0.75
statusStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
statusStroke.Parent = Status

Minimize.Parent = Frame
Minimize.Size = UDim2.new(0, 28, 0, 24)
Minimize.Position = UDim2.new(1, -80, 0, 8)
Minimize.BackgroundColor3 = ICON_BUTTON_COLOR
Minimize.TextColor3 = TEXT_PRIMARY
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 16
Minimize.Text = "—"
Minimize.AutoButtonColor = false
Minimize.ZIndex = 3

Maximize.Parent = Frame
Maximize.Size = UDim2.new(0, 28, 0, 24)
Maximize.Position = UDim2.new(1, -44, 0, 8)
Maximize.BackgroundColor3 = ICON_BUTTON_COLOR
Maximize.TextColor3 = TEXT_PRIMARY
Maximize.Font = Enum.Font.GothamBold
Maximize.TextSize = 16
Maximize.Text = "⬜"
Maximize.Visible = false
Maximize.AutoButtonColor = false
Maximize.ZIndex = 3

-- LOGIC
local minimized = false
local bodyElements = {Box, Save, Load, Clear, Delete, Status}

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

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius or 10)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = STROKE_COLOR
    stroke.Transparency = 0.6
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = button

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
    writefile(FILE_PATH, Box.Text)
    Status.Text = "✅ Saved"
end)

Load.MouseButton1Click:Connect(function()
    if isfile(FILE_PATH) then
        Box.Text = readfile(FILE_PATH)
        Status.Text = "📜 Loaded"
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
        delfile(FILE_PATH)
        Status.Text = "🗑 Deleted"
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
