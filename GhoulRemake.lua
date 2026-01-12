-- GHOUL REMAKE HUB | DELTA READY

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- CONFIG
local GHOUL_IMAGE = "rbxassetid://74356605425526" -- foto do ghoul
local MUSIC_ID = "rbxassetid://1843528843" -- música emo clean
local ACCENT = Color3.fromRGB(170, 0, 255)

-- MUSIC
local sound = Instance.new("Sound", workspace)
sound.SoundId = MUSIC_ID
sound.Volume = 2
sound.Looped = true
sound:Play()

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "GhoulRemake"
gui.ResetOnSpawn = false

-- FLOAT BUTTON
local float = Instance.new("ImageButton", gui)
float.Size = UDim2.new(0,60,0,60)
float.Position = UDim2.new(0,20,0.5,-30)
float.Image = GHOUL_IMAGE
float.BackgroundColor3 = Color3.new(1,1,1)
float.AutoButtonColor = false
Instance.new("UICorner", float).CornerRadius = UDim.new(1,0)

-- DRAG
local dragging, dragInput, dragStart, startPos
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
UIS.InputEnded:Connect(function()
	dragging = false
end)

-- MAIN HUB
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,340)
main.Position = UDim2.new(0.5,-260,0.5,-170)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

float.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- SIDEBAR
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0,130,1,0)
side.BackgroundColor3 = Color3.new(1,1,1)

-- CONTENT
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,130,0,0)
content.Size = UDim2.new(1,-130,1,0)
content.BackgroundTransparency = 1

local tabs = {}

local function createTab(name, order)
	local btn = Instance.new("TextButton", side)
	btn.Size = UDim2.new(1,0,0,45)
	btn.Position = UDim2.new(0,0,0,(order-1)*50)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = ACCENT
	btn.BackgroundTransparency = 1

	local frame = Instance.new("Frame", content)
	frame.Size = UDim2.new(1,0,1,0)
	frame.Visible = false
	frame.BackgroundTransparency = 1

	btn.MouseButton1Click:Connect(function()
		for _,v in pairs(tabs) do v.Visible = false end
		frame.Visible = true
	end)

	table.insert(tabs, frame)
	return frame
end

-- TABS
local tabPlayer = createTab("Player",1)
local tabMove = createTab("Movement",2)
local tabVisual = createTab("Visual",3)
local tabFun = createTab("Fun",4)
local tabSet = createTab("Settings",5)

tabs[1].Visible = true

-- BUTTON MAKER
local function makeBtn(tab,text,y,callback)
	local b = Instance.new("TextButton", tab)
	b.Size = UDim2.new(0,220,0,40)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = ACCENT
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	b.MouseButton1Click:Connect(callback)
end

-- FLY
local fly = false
makeBtn(tabMove,"Fly",30,function()
	fly = not fly
	if fly then
		local bv = Instance.new("BodyVelocity",hrp)
		bv.Name = "FlyForce"
		bv.MaxForce = Vector3.new(1,1,1)*1e5
		RunService.RenderStepped:Connect(function()
			if fly then
				bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
			end
		end)
	else
		if hrp:FindFirstChild("FlyForce") then
			hrp.FlyForce:Destroy()
		end
	end
end)

-- NOCLIP
local noclip = false
makeBtn(tabMove,"Noclip",80,function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- RESET
makeBtn(tabPlayer,"Reset Character",30,function()
	char:BreakJoints()
end)

-- CLOSE
makeBtn(tabSet,"Close Hub",30,function()
	gui:Destroy()
	sound:Stop()
end)
