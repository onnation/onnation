local function deleteRecursive(path, keepPath)
    if path == keepPath then return end
    if isfolder and isfolder(path) then
        for _, item in ipairs(listfiles(path)) do
            deleteRecursive(item, keepPath)
        end
        if path ~= keepPath then
            if delfolder then delfolder(path) else pcall(delfolder, path) end
        end
    else
        delfile(path)
    end
end

if not isfolder("newvape") then
    print("folder 'newvape' not found")
    return
end

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local userInput = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "reinstallgui"
gui.ResetOnSpawn = false
gui.Parent = playerGui
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 150)
frame.Position = UDim2.new(0.5, -170, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 200, 255)
frame.ClipsDescendants = true
frame.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.Parent = frame
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "skidv4 reinstall"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.BackgroundTransparency = 0.8
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

local keepBtn = Instance.new("TextButton")
keepBtn.Size = UDim2.new(0, 130, 0, 40)
keepBtn.Position = UDim2.new(0.08, 0, 0.75, -20)
keepBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 220)
keepBtn.BackgroundTransparency = 0.2
keepBtn.BorderSizePixel = 0
keepBtn.Text = "keep profiles - (configs)"
keepBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keepBtn.TextSize = 14
keepBtn.Font = Enum.Font.GothamBold
keepBtn.Parent = frame
local keepCorner = Instance.new("UICorner")
keepCorner.CornerRadius = UDim.new(0, 6)
keepCorner.Parent = keepBtn

local deleteBtn = Instance.new("TextButton")
deleteBtn.Size = UDim2.new(0, 130, 0, 40)
deleteBtn.Position = UDim2.new(0.58, 0, 0.75, -20)
deleteBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
deleteBtn.BackgroundTransparency = 0.2
deleteBtn.BorderSizePixel = 0
deleteBtn.Text = "delete all"
deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
deleteBtn.TextSize = 14
deleteBtn.Font = Enum.Font.GothamBold
deleteBtn.Parent = frame
local deleteCorner = Instance.new("UICorner")
deleteCorner.CornerRadius = UDim.new(0, 6)
deleteCorner.Parent = deleteBtn
local dragging = false
local dragStart, frameStart

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = frame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

userInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

local choice = nil
local closed = false

keepBtn.MouseButton1Click:Connect(function()
    choice = "keep"
    gui:Destroy()
end)

deleteBtn.MouseButton1Click:Connect(function()
    choice = "delete"
    gui:Destroy()
end)

closeBtn.MouseButton1Click:Connect(function()
    closed = true
    gui:Destroy()
end)

repeat task.wait() until choice ~= nil or closed

if closed then return end

local keepFullPath = "newvape/profiles"

if choice == "keep" then
    for _, item in ipairs(listfiles("newvape")) do
        if item ~= keepFullPath then
            deleteRecursive(item, keepFullPath)
        end
    end
else
    if isfolder("newvape") then
        for _, item in ipairs(listfiles("newvape")) do
            deleteRecursive(item, nil)
        end
        if delfolder then delfolder("newvape") else pcall(delfolder, "newvape") end
    end
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "skidv4",
    Text = "reinject skidv4 :D",
    Duration = 5
})
