local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExecutorUI"
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.CornerRadius = UDim.new(0, 8)
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 30, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.Text = "BRUTEFARM Executor"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local exitButton = Instance.new("TextButton")
exitButton.Size = UDim2.new(0, 30, 1, 0)
exitButton.Position = UDim2.new(1, -30, 0, 0)
exitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exitButton.Font = Enum.Font.SourceSansBold
exitButton.TextSize = 18
exitButton.Text = "X"
exitButton.Parent = titleBar

exitButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local codeTextBox = Instance.new("TextBox")
codeTextBox.Size = UDim2.new(1, -20, 1, -80)
codeTextBox.Position = UDim2.new(0, 10, 0, 40)
codeTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
codeTextBox.BorderSizePixel = 0
codeTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
codeTextBox.Font = Enum.Font.SourceSans
codeTextBox.TextSize = 14
codeTextBox.PlaceholderText = "Masukkan kode di sini..."
codeTextBox.MultiLine = true
codeTextBox.TextWrapped = true
codeTextBox.Parent = mainFrame

local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0, 150, 0, 40)
executeButton.Position = UDim2.new(0, 10, 1, -40)
executeButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextSize = 16
executeButton.Text = "Execute"
executeButton.Parent = mainFrame

executeButton.MouseButton1Click:Connect(function()
    local code = codeTextBox.Text
    local f, err = loadstring(code)
    
    if f then
        local success, result = pcall(f)
        if not success then
            print("Executor Error: " .. result)
        else
            codeTextBox.Text = ""
        end
    else
        print("Syntax Error: " .. err)
    end
end)
