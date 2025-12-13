-- Xuan Hub AutoExecute Manager (Draggable)

if not writefile or not readfile then
    warn("Executor does not support file functions")
    return
end

local FILE_PATH = "AutoExecute/autoexecute.txt"
local UIS = game:GetService("UserInputService")

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

ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 460, 0, 320)
Frame.Position = UDim2.new(0.5, -230, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
Frame.BorderSizePixel = 0
local expandedSize = Frame.Size
local minimizedSize = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 0, 40)

-- TITLE BAR (DRAG HANDLE)
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Text = "👋 Welcome to Xuan Hub — AutoExecute Manager"
TitleBar.TextColor3 = Color3.new(1,1,1)
TitleBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 18

-- TEXTBOX
Box.Parent = Frame
Box.Position = UDim2.new(0, 10, 0, 50)
Box.Size = UDim2.new(1, -20, 0, 160)
Box.MultiLine = true
Box.ClearTextOnFocus = false
Box.TextWrapped = true
Box.TextYAlignment = Enum.TextYAlignment.Top
Box.Font = Enum.Font.Code
Box.TextSize = 14
Box.Text = "-- Paste your script here"
Box.BackgroundColor3 = Color3.fromRGB(28,28,28)
Box.TextColor3 = Color3.new(1,1,1)

-- BUTTONS
Save.Parent = Frame
Save.Position = UDim2.new(0, 10, 0, 220)
Save.Size = UDim2.new(0.48, 0, 0, 32)
Save.Text = "💾 Save"
Save.BackgroundColor3 = Color3.fromRGB(0,170,127)
Save.TextColor3 = Color3.new(1,1,1)
Save.Font = Enum.Font.GothamBold
Save.TextSize = 13

Load.Parent = Frame
Load.Position = UDim2.new(0.52, 0, 0, 220)
Load.Size = UDim2.new(0.48, 0, 0, 32)
Load.Text = "📜 Load Saved Script"
Load.BackgroundColor3 = Color3.fromRGB(60,60,60)
Load.TextColor3 = Color3.new(1,1,1)
Load.Font = Enum.Font.GothamBold
Load.TextSize = 13

Clear.Parent = Frame
Clear.Position = UDim2.new(0, 10, 0, 258)
Clear.Size = UDim2.new(0.31, 0, 0, 28)
Clear.Text = "🧹 Clear"
Clear.BackgroundColor3 = Color3.fromRGB(80,80,80)
Clear.TextColor3 = Color3.new(1,1,1)
Clear.Font = Enum.Font.Gotham
Clear.TextSize = 12

Delete.Parent = Frame
Delete.Position = UDim2.new(0.35, 0, 0, 258)
Delete.Size = UDim2.new(0.31, 0, 0, 28)
Delete.Text = "🗑 Delete"
Delete.BackgroundColor3 = Color3.fromRGB(150,60,60)
Delete.TextColor3 = Color3.new(1,1,1)
Delete.Font = Enum.Font.Gotham
Delete.TextSize = 12

Status.Parent = Frame
Status.Position = UDim2.new(0.69, 0, 0, 258)
Status.Size = UDim2.new(0.29, 0, 0, 28)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextColor3 = Color3.fromRGB(200,200,200)

Minimize.Parent = Frame
Minimize.Size = UDim2.new(0, 28, 0, 24)
Minimize.Position = UDim2.new(1, -64, 0, 8)
Minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 16
Minimize.Text = "—"

Maximize.Parent = Frame
Maximize.Size = UDim2.new(0, 28, 0, 24)
Maximize.Position = UDim2.new(1, -32, 0, 8)
Maximize.BackgroundColor3 = Color3.fromRGB(40,40,40)
Maximize.TextColor3 = Color3.new(1,1,1)
Maximize.Font = Enum.Font.GothamBold
Maximize.TextSize = 16
Maximize.Text = "⬜"
Maximize.Visible = false

-- LOGIC
local minimized = false
local bodyElements = {Box, Save, Load, Clear, Delete, Status}

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