local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

repeat task.wait() until LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShootHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 180, 0, 120)
MainFrame.Position = UDim2.new(0, 100, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextButton")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "SHOOT HUB (тащи меня)"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.Parent = MainFrame

local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -10, 0, 25)
ESPButton.Position = UDim2.new(0, 5, 0, 30)
ESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPButton.Text = "ESP: OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.SourceSans
ESPButton.TextSize = 13
ESPButton.Parent = MainFrame

local AimbotButton = Instance.new("TextButton")
AimbotButton.Size = UDim2.new(1, -10, 0, 25)
AimbotButton.Position = UDim2.new(0, 5, 0, 58)
AimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimbotButton.Text = "AIMBOT: OFF"
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.Font = Enum.Font.SourceSans
AimbotButton.TextSize = 13
AimbotButton.Parent = MainFrame

local NoCDButton = Instance.new("TextButton")
NoCDButton.Size = UDim2.new(1, -10, 0, 25)
NoCDButton.Position = UDim2.new(0, 5, 0, 86)
NoCDButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NoCDButton.Text = "NO CD: OFF"
NoCDButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoCDButton.Font = Enum.Font.SourceSans
NoCDButton.TextSize = 13
NoCDButton.Parent = MainFrame

local dragging = false
local dragStart = nil
local startPos = nil

Title.MouseButton1Down:Connect(function()
    dragging = true
    dragStart = UIS:GetMouseLocation()
    startPos = MainFrame.Position
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = UIS:GetMouseLocation()
        local delta = mouse - dragStart
        MainFrame.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    end
end)

local espEnabled = false
local aimbotEnabled = false
local noCDEnabled = false

local function toggleESP()
    espEnabled = not espEnabled
    ESPButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    if espEnabled then
        spawn(function()
            while espEnabled do
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = p.Character.HumanoidRootPart
                        if not hrp:FindFirstChild("ESP") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "ESP"
                            hl.Adornee = hrp
                            hl.FillColor = Color3.fromRGB(255, 0, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.4
                            hl.Parent = hrp
                        end
                    end
                end
                task.wait(0.5)
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hl = p.Character.HumanoidRootPart:FindFirstChild("ESP")
                    if hl then hl:Destroy() end
                end
            end
        end)
    end
end

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    AimbotButton.Text = aimbotEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
    if aimbotEnabled then
        spawn(function()
            while aimbotEnabled do
                if UIS:IsMouseButtonPressed(1) then
                    local closest = nil
                    local minDist = math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                            local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if d < minDist then
                                minDist = d
                                closest = p
                            end
                        end
                    end
                    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                        Cam.CFrame = CFrame.new(Cam.CFrame.Position, closest.Character.Head.Position)
                    end
                end
                task.wait()
            end
        end)
    end
end

local function toggleNoCD()
    noCDEnabled = not noCDEnabled
    NoCDButton.Text = noCDEnabled and "NO CD: ON" or "NO CD: OFF"
    if noCDEnabled then
        spawn(function()
            while noCDEnabled do
                for _, v in ipairs(getgc()) do
                    if type(v) == "table" then
                        pcall(function()
                            for _, key in ipairs({"cooldown", "Cooldown", "cd", "CD", "cooldownTime", "CooldownTime"}) do
                                if v[key] and type(v[key]) == "number" then
                                    v[key] = 0
                                end
                            end
                        end)
                    end
                end
                task.wait(1)
            end
        end)
    end
end

ESPButton.MouseButton1Click:Connect(toggleESP)
AimbotButton.MouseButton1Click:Connect(toggleAimbot)
NoCDButton.MouseButton1Click:Connect(toggleNoCD)

print("Shoot HUB loaded")
