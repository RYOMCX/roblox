local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
local title = Instance.new("TextLabel", main)
local minimize = Instance.new("TextButton", main)
local close = Instance.new("TextButton", main)

main.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
main.Size = UDim2.new(0, 260, 0, 420)
main.Position = UDim2.new(0, 100, 0, 100)
main.Active = true
main.Draggable = true

title.Text = "RYOFC EXECUTOR"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.new(0, 0.4, 1)
title.TextScaled = true

minimize.Text = "_"
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -60, 0, 0)
minimize.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
minimize.TextColor3 = Color3.new(1,1,1)

close.Text = "X"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.new(0.8, 0, 0)
close.TextColor3 = Color3.new(1,1,1)

local buttons = {
    "Auto Kill", "Auto Headshot", "ESP", "Magic Bullet",
    "Aimbot", "Trigger Bot", "Wallbang", "Chams"
}

local states = {}
local funcs = {}
for i, name in ipairs(buttons) do
    states[name] = false
    local btn = Instance.new("TextButton", main)
    btn.Text = name
    btn.Size = UDim2.new(0, 240, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 40 + (i-1)*45)
    btn.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true

    btn.MouseButton1Click:Connect(function()
        states[name] = not states[name]
        if funcs[name] then funcs[name](states[name]) end
    end)
end

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    local reopen = Instance.new("TextButton", gui)
    reopen.Text = "▶"
    reopen.Size = UDim2.new(0, 40, 0, 40)
    reopen.Position = UDim2.new(0, 10, 0, 10)
    reopen.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    reopen.TextColor3 = Color3.new(1,1,1)
    reopen.MouseButton1Click:Connect(function()
        main.Visible = true
        reopen:Destroy()
    end)
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local cam = workspace.CurrentCamera

funcs["ESP"] = function(on)
    if not on then return end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local box = Drawing.new("Square")
            local line = Drawing.new("Line")
            box.Color = Color3.new(1,0,0)
            line.Color = Color3.new(0,1,0)
            box.Thickness = 2
            line.Thickness = 2
            rs.RenderStepped:Connect(function()
                if not states["ESP"] then box:Remove() line:Remove() return end
                local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos, vis = cam:WorldToViewportPoint(hrp.Position)
                    if vis then
                        box.Visible = true
                        line.Visible = true
                        box.Size = Vector2.new(60,100)
                        box.Position = Vector2.new(pos.X-30, pos.Y-50)
                        line.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                        line.To = Vector2.new(pos.X, pos.Y)
                    else
                        box.Visible = false
                        line.Visible = false
                    end
                end
            end)
        end
    end
end

funcs["Auto Kill"] = function(on)
    coroutine.wrap(function()
        while states["Auto Kill"] and wait(0.3) do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    game.ReplicatedStorage.Shoot:FireServer(p.Character.HumanoidRootPart.Position)
                end
            end
        end
    end)()
end

funcs["Auto Headshot"] = function(on)
    coroutine.wrap(function()
        while states["Auto Headshot"] and wait(0.2) do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                    game.ReplicatedStorage.Shoot:FireServer(p.Character.Head.Position)
                end
            end
        end
    end)()
end

funcs["Magic Bullet"] = function(on)
    if not on then return end
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local method = getnamecallmethod()
        if tostring(method) == "FireServer" and tostring(args[1]) == "Shoot" and states["Magic Bullet"] then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                    args[2] = p.Character.Head.Position
                end
            end
        end
        return old(unpack(args))
    end)
end

funcs["Aimbot"] = function(on)
    coroutine.wrap(function()
        while states["Aimbot"] and wait() do
            local target = nil
            local shortest = math.huge
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                    local pos, onScreen = cam:WorldToViewportPoint(p.Character.Head.Position)
                    local dist = (Vector2.new(pos.X,pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).magnitude
                    if onScreen and dist < shortest then
                        shortest = dist
                        target = p
                    end
                end
            end
            if target then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
            end
        end
    end)()
end

funcs["Trigger Bot"] = function(on)
    coroutine.wrap(function()
        while states["Trigger Bot"] and wait(0.05) do
            local ray = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector * 1000)
            local part, pos = workspace:FindPartOnRay(ray, lp.Character, false, true)
            if part and part.Parent:FindFirstChild("Humanoid") then
                game.ReplicatedStorage.Shoot:FireServer(pos)
            end
        end
    end)()
end

funcs["Wallbang"] = function(on)
    if not on then return end
    local old = debug.getupvalue(game.ReplicatedStorage.Shoot.FireServer, 1)
    debug.setupvalue(game.ReplicatedStorage.Shoot.FireServer, 1, function(...) return true end)
end

funcs["Chams"] = function(on)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            for _, part in pairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = on and Enum.Material.ForceField or Enum.Material.Plastic
                    part.Color = on and Color3.fromRGB(255, 0, 0) or Color3.new(1, 1, 1)
                end
            end
        end
    end
end
