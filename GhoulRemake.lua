--[[ 
 Ghoul Hub Remake
 Brookhaven | Delta Executor
 Estilo: Roxo + Preto | Sidebar branca
 Botão flutuante redondo com imagem
 Música clean de entrada
]]

if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- CONFIG
local IMAGE_ID = "rbxassetid://74356605425526" -- imagem Ghoul
local MUSIC_ID = "rbxassetid://1843529637" -- música clean/emo
local LOAD_TIME = 4

-- ================= LOADER =================
local loaderGui = Instance.new("ScreenGui", player.PlayerGui)
loaderGui.IgnoreGuiInset = true

local bg = Instance.new("Frame", loaderGui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)

local img = Instance.new("ImageLabel", bg)
img.Size = UDim2.new(1,0,1,0)
img.Image = IMAGE_ID
img.BackgroundTransparency = 1
img.ScaleType = Enum.ScaleType.Crop

local barBG = Instance.new("Frame", bg)
barBG.Size = UDim2.new(0.4,0,0,16)
barBG.Position = UDim2.new(0.3,0,0.85,0)
barBG.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)

local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(160,0,255)
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

local text = Instance.new("TextLabel", bg)
text.Size = UDim2.new(1,0,0,30)
text.Position = UDim2.new(0,0,0.8,0)
text.BackgroundTransparency = 1
text.Text = "Carregando 0%"
text.TextColor3 = Color3.new(1,1,1)
text.Font = Enum.Font.GothamBold
text.TextSize = 18

local sound = Instance.new("Sound", bg)
sound.SoundId = MUSIC_ID
sound.Volume = 2
sound:Play()

local start = tick()
while tick() - start < LOAD_TIME do
	local p = (tick() - start) / LOAD_TIME
	bar.Size = UDim2.new(p,0,1,0)
	text.Text = "Carregando "..math.floor(p*100).."%"
	RunService.RenderStepped:Wait()
end

loaderGui:Destroy()

-- ================= FLOAT BUTTON =================
local floatGui = Instance.new("ScreenGui", player.PlayerGui)

local floatBtn = Instance.new("ImageButton", floatGui)
floatBtn.Size = UDim2.new(0,60,0,60)
floatBtn.Position = UDim2.new(0.05,0,0.5,0)
floatBtn.Image = IMAGE_ID
floatBtn.BackgroundColor3 = Color3.fromRGB(90,0,140)
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1,0)

-- drag
local dragging, dragStart, startPos
floatBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = floatBtn.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = i.Position - dragStart
		floatBtn.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- ================= HUB UI =================
local hubGui = Instance.new("ScreenGui", player.PlayerGui)
hubGui.Enabled = false

local main = Instance.new("Frame", hubGui)
main.Size = UDim2.new(0,520,0,330)
main.Position = UDim2.new(0.5,-260,0.5,-165)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- SIDEBAR
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0,130,1,0)
side.BackgroundColor3 = Color3.fromRGB(235,235,235)

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
	btn.TextColor3 = Color3.fromRGB(60,0,90)
	btn.BackgroundTransparency = 1
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14

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

local tabPlayer = createTab("Player",1)
local tabMove   = createTab("Movement",2)
local tabFun    = createTab("Fun",3)
local tabSet    = createTab("Settings",4)

tabs[1].Visible = true

local function button(parent,text,y,cb)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0,220,0,40)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(90,0,140)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	b.MouseButton1Click:Connect(cb)
end

-- FLY
local flying = false
button(tabMove,"Fly",30,function()
	flying = not flying
	if flying then
		local bv = Instance.new("BodyVelocity", hrp)
		bv.Name = "FlyForce"
		bv.MaxForce = Vector3.new(1,1,1)*1e5
		RunService.RenderStepped:Connect(function()
			if flying and bv.Parent then
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
button(tabMove,"Noclip",80,function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _,p in pairs(char:GetDescendants()) do
			if p:IsA("BasePart") then
				p.CanCollide = false
			end
		end
	end
end)

button(tabPlayer,"Reset Character",30,function()
	char:BreakJoints()
end)

button(tabSet,"Close Hub",30,function()
	hubGui.Enabled = false
end)

-- TOGGLE HUB
floatBtn.MouseButton1Click:Connect(function()
	hubGui.Enabled = not hubGui.Enabled
end)    page("Fly")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

sideBtn("Noclip").MouseButton1Click:Connect(function()
    page("Noclip")
    for _,v in pairs(LP.Character:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
end)

sideBtn("Tools").MouseButton1Click:Connect(function()
    page("Tools")
end)

sideBtn("House").MouseButton1Click:Connect(function()
    page("House")
end)

sideBtn("Vehicle").MouseButton1Click:Connect(function()
    page("Vehicle")
end)

sideBtn("Close").MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- ===== TOGGLE HUB =====
floatBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
