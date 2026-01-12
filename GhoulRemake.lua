--========================
-- GHOUL HUB | REMAKE
-- SIDEBAR BRANCA / TEXTO ROXO
-- DELTA COMPATÍVEL
--========================

if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

--========================
-- MÚSICA
--========================
local music = Instance.new("Sound")
music.Parent = SoundService
music.SoundId = "rbxassetid://1837635154"
music.Volume = 2
music.Looped = true
music:Play()

--========================
-- GUI
--========================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "GhoulHub"
gui.ResetOnSpawn = false

--========================
-- BOTÃO FLUTUANTE
--========================
local openBtn = Instance.new("ImageButton", gui)
openBtn.Size = UDim2.new(0,60,0,60)
openBtn.Position = UDim2.new(0.05,0,0.4,0)
openBtn.BackgroundColor3 = Color3.fromRGB(130,0,200)
openBtn.Image = "rbxassetid://74356605425526"
openBtn.Active = true
openBtn.Draggable = true
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

--========================
-- HUB
--========================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,330)
main.Position = UDim2.new(0.5,-260,0.5,-165)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

--========================
-- SIDEBAR BRANCA
--========================
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0,140,1,0)
side.BackgroundColor3 = Color3.fromRGB(245,245,245)
Instance.new("UICorner", side).CornerRadius = UDim.new(0,14)

-- Conteúdo
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,140,0,0)
content.Size = UDim2.new(1,-140,1,0)
content.BackgroundTransparency = 1

--========================
-- SISTEMA DE ABAS
--========================
local tabs = {}

local function createTab(text, order)
	local btn = Instance.new("TextButton", side)
	btn.Size = UDim2.new(1,0,0,45)
	btn.Position = UDim2.new(0,0,0,(order-1)*50)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(140,0,200) -- ROXO
	btn.BackgroundColor3 = Color3.fromRGB(255,255,255)

	local frame = Instance.new("Frame", content)
	frame.Size = UDim2.new(1,0,1,0)
	frame.Visible = false
	frame.BackgroundTransparency = 1

	btn.MouseButton1Click:Connect(function()
		for _,v in pairs(tabs) do
			v.Visible = false
		end
		frame.Visible = true
	end)

	table.insert(tabs, frame)
	return frame
end

local tabPlayer = createTab("Player",1)
local tabMove   = createTab("Movement",2)
local tabSet    = createTab("Settings",3)

tabs[1].Visible = true

--========================
-- BOTÕES
--========================
local function makeButton(parent,text,y,callback)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0,220,0,42)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(140,0,200)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	b.MouseButton1Click:Connect(callback)
end

--========================
-- FUNÇÕES
--========================
makeButton(tabMove,"Speed",30,function()
	hum.WalkSpeed = 32
end)

makeButton(tabMove,"Jump",80,function()
	hum.JumpPower = 90
end)

local flying = false
makeButton(tabMove,"Fly",130,function()
	flying = not flying
	if flying then
		local bv = Instance.new("BodyVelocity", hrp)
		bv.Name = "FlyForce"
		bv.MaxForce = Vector3.new(1,1,1) * 1e5
		RunService.RenderStepped:Connect(function()
			if flying then
				bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
			end
		end)
	else
		if hrp:FindFirstChild("FlyForce") then
			hrp.FlyForce:Destroy()
		end
	end
end)

makeButton(tabSet,"Mute Music",30,function()
	music.Playing = not music.Playing
end)

makeButton(tabSet,"Close Hub",80,function()
	main.Visible = false
end)

--========================
-- ABRIR HUB
--========================
openBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)
