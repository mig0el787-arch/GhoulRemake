--// GHOUL HUB ☠️ | DELTA READY | BLACK & PURPLE

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- CONFIG
local HUB_NAME = "Ghoul hub☠️"
local ACCENT = Color3.fromRGB(170, 0, 255) -- roxo
local DARK = Color3.fromRGB(15,15,15)     -- preto
local GHOUL_IMAGE = "rbxassetid://74356605425526"
local MUSIC_ID = "rbxassetid://1843528843" -- emo

-- MUSIC
local sound = Instance.new("Sound", workspace)
sound.SoundId = MUSIC_ID
sound.Volume = 2
sound.Looped = true
pcall(function() sound:Play() end)

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "GhoulHub"
gui.ResetOnSpawn = false

-- FLOAT BUTTON
local float = Instance.new("ImageButton", gui)
float.Size = UDim2.fromOffset(60,60)
float.Position = UDim2.new(0,20,0.5,-30)
float.Image = GHOUL_IMAGE
float.BackgroundColor3 = DARK
float.AutoButtonColor = false
Instance.new("UICorner", float).CornerRadius = UDim.new(1,0)

-- DRAG
local dragging, dragStart, startPos
float.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = float.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		float.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.45,0.55)
frame.Position = UDim2.fromScale(0.275,0.22)
frame.BackgroundColor3 = DARK
frame.Visible = false
Instance.new("UICorner", frame)

-- SIDEBAR
local side = Instance.new("Frame", frame)
side.Size = UDim2.fromScale(0.25,1)
side.BackgroundColor3 = ACCENT
Instance.new("UICorner", side)

-- TITLE
local title = Instance.new("TextLabel", side)
title.Size = UDim2.new(1,0,0,60)
title.Text = HUB_NAME
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.BackgroundTransparency = 1

-- CONTENT
local content = Instance.new("Frame", frame)
content.Position = UDim2.fromScale(0.27,0.05)
content.Size = UDim2.fromScale(0.7,0.9)
content.BackgroundTransparency = 1

-- BUTTON CREATOR
local function createButton(text, y, callback)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.new(1,0,0,45)
	btn.Position = UDim2.new(0,0,0,y)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = ACCENT
	Instance.new("UICorner", btn)
	btn.MouseButton1Click:Connect(callback)
end

-- FUNCTIONS (EXEMPLO)
createButton("Speed x2", 0, function()
	player.Character.Humanoid.WalkSpeed = 32
end)

createButton("Jump High", 55, function()
	player.Character.Humanoid.JumpPower = 100
end)

createButton("Gravity Low", 110, function()
	workspace.Gravity = 80
end)

createButton("Reset Stats", 165, function()
	player.Character.Humanoid.WalkSpeed = 16
	player.Character.Humanoid.JumpPower = 50
	workspace.Gravity = 196.2
end)

-- TOGGLE HUB
float.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

print("Ghoul hub☠️ carregado com sucesso")
