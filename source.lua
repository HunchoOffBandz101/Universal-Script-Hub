local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Universal Script Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "UniversalScriptConfig",
})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
})

-- Variables for toggles and fly
local infJump = false
local noclip = false
local flying = false
local flySpeed = 50
local bodyVelocity

-- 1. Teleport to Spawn Button
Tab:AddButton({
    Name = "Teleport to Spawn",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame
            OrionLib:MakeNotification({
                Name = "Teleport",
                Content = "Teleported to Spawn",
                Image = "rbxassetid://4483345998",
                Time = 3,
            })
        end
    end
})

-- 2. Infinite Jump Toggle
Tab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Save = true,
    Flag = "InfiniteJumpFlag",
    Callback = function(value)
        infJump = value
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and game.Players.LocalPlayer.Character then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 3. WalkSpeed Slider
Tab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 16,
    Save = true,
    Flag = "WalkSpeedFlag",
    Callback = function(value)
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end,
})

-- 4. JumpPower Slider
Tab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,
    Save = true,
    Flag = "JumpPowerFlag",
    Callback = function(value)
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
        end
    end,
})

-- 5. Noclip Toggle
Tab:AddToggle({
    Name = "Noclip",
    Default = false,
    Save = true,
    Flag = "NoclipFlag",
    Callback = function(value)
        noclip = value
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CanCollide = not noclip
        end
    end,
})

-- 6. Fly Toggle
Tab:AddToggle({
    Name = "Fly",
    Default = false,
    Save = true,
    Flag = "FlyFlag",
    Callback = function(value)
        flying = value
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if flying and hrp then
            bodyVelocity = Instance.new("BodyVelocity", hrp)
            bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        elseif bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end,
})

-- 7. Fly Speed Slider
Tab:AddSlider({
    Name = "Fly Speed",
    Min = 25,
    Max = 200,
    Default = 50,
    Save = true,
    Flag = "FlySpeedFlag",
    Callback = function(value)
        flySpeed = value
    end,
})

game:GetService("RunService").Heartbeat:Connect(function()
    if flying and bodyVelocity then
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local direction = Vector3.new()
            local UIS = game:GetService("UserInputService")
            if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + hrp.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - hrp.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - hrp.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + hrp.CFrame.RightVector end
            bodyVelocity.Velocity = direction.Unit * flySpeed
        end
    end
end)

-- 8. Pickup All Tools Button
Tab:AddButton({
    Name = "Pickup All Tools",
    Callback = function()
        local player = game.Players.LocalPlayer
        for _, tool in pairs(workspace:GetDescendants()) do
            if tool:IsA("Tool") then
                tool:Clone().Parent = player.Backpack
            end
        end
        OrionLib:MakeNotification({Name = "Tools", Content = "All tools picked up", Time = 3})
    end,
})

-- 9. Teleport to Nearest Player Button
Tab:AddButton({
    Name = "Teleport to Nearest Player",
    Callback = function()
        local player = game.Players.LocalPlayer
        local minDist = math.huge
        local target = nil
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = plr
                end
            end
        end
        if target then
            player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            OrionLib:MakeNotification({Name = "Teleport", Content = "Teleported to nearest player", Time = 3})
        else
            OrionLib:MakeNotification({Name = "Teleport", Content = "No player found", Time = 3})
        end
    end,
})

-- 10. Reset WalkSpeed Button
Tab:AddButton({
    Name = "Reset WalkSpeed",
    Callback = function()
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = 16 end
    end,
})

-- 11. Reset JumpPower Button
Tab:AddButton({
    Name = "Reset JumpPower",
    Callback = function()
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = 50 end
    end,
})

-- 12. Sit/Stand Toggle
Tab:AddToggle({
    Name = "Sit/Stand",
    Default = false,
    Save = true,
    Flag = "SitFlag",
    Callback = function(value)
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Sit = value
        end
    end,
})

-- 13. Toggle GUI Visibility
local guiVisible = true
Tab:AddToggle({
    Name = "Toggle GUI",
    Default = true,
    Save = true,
    Flag = "GuiVisibleFlag",
    Callback = function(value)
        guiVisible = value
        OrionLib:Toggle()
    end,
})

-- 14. Heal Character Button
Tab:AddButton({
    Name = "Heal Character",
    Callback = function()
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = humanoid.MaxHealth end
    end,
})

-- 15. Destroy All Tools Button
Tab:AddButton({
    Name = "Destroy All Tools",
    Callback = function()
        local player = game.Players.LocalPlayer
        for _, tool in pairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
        OrionLib:MakeNotification({Name = "Tools", Content = "All tools destroyed", Time = 3})
    end,
})

OrionLib:Init()
