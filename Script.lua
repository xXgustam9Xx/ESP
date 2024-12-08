local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineColor = Color3.fromRGB(255, 255, 255)
local OutlineTransparency = 0

local CoreGui = game:FindService("CoreGui")
local Players = game:FindService("Players")
local lp = Players.LocalPlayer
local connections = {}

local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

local function CreatePlayerTag(plr)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = plr.Character:WaitForChild("Head")
    billboard.Size = UDim2.new(0, 250, 0, 60)  
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)  
    billboard.AlwaysOnTop = true  
    billboard.Parent = plr.Character:WaitForChild("Head")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboard

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 1.5, 0)
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.8
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextSize = 18  
    nameLabel.Parent = frame

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.1, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.Text = "Vida: " .. math.floor(plr.Character.Humanoid.Health)
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextStrokeTransparency = 0.8
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextSize = 10  
    healthLabel.Parent = frame

    local function updateHealth()
        healthLabel.Text = "Vida: " .. math.floor(plr.Character.Humanoid.Health)
    end

    plr.Character:WaitForChild("Humanoid").HealthChanged:Connect(updateHealth)

    plr.Character:WaitForChild("Humanoid").Died:Connect(function()
        billboard:Destroy()
    end)
end

local function Highlight(plr)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.FillColor = Color3.fromRGB(0, 0, 0)
    Highlight.DepthMode = DepthMode
    Highlight.FillTransparency = FillTransparency
    Highlight.OutlineColor = OutlineColor
    Highlight.OutlineTransparency = 0
    Highlight.Parent = Storage

    local plrchar = plr.Character
    if plrchar then
        Highlight.Adornee = plrchar
    end

    connections[plr] = plr.CharacterAdded:Connect(function(char)
        Highlight.Adornee = char
    end)

    CreatePlayerTag(plr)
end

Players.PlayerAdded:Connect(Highlight)
for i, v in next, Players:GetPlayers() do
    Highlight(v)
end

Players.PlayerRemoving:Connect(function(plr)
    local plrname = plr.Name
    if Storage[plrname] then
        Storage[plrname]:Destroy()
    end
    if connections[plr] then
        connections[plr]:Disconnect()
    end
end)
