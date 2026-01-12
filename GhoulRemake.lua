-- Ghoul Hub Remake | Brookhaven | Delta Executor
-- UI clean roxo/branco + botão flutuante com imagem
-- Imagem Ghoul ID: 74356605425526

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- ===== PROTEÇÃO =====
pcall(function()
    if game.PlaceId ~= 4924922222 then
        warn("Ghoul Hub: Apenas Brookhaven")
    end
end)

-- ===== GUI ROOT =====
local gui = Instance.new("ScreenGui")
gui.Name = "GhoulHub"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- ===== MÚSICA DE ENTRADA (EMO / CLEAN) =====
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://1843529274" -- emo/clean vibe
sound.Volume = 2
sound.Looped = false
sound.Parent = gui
sound:Play()

-- ===== BOTÃO FLUTUANTE (CÍRCULO) =====
local floatBtn = Instance.new("ImageButton")
floatBtn.Size = UDim2.fromOffset(64,64)
floatBtn.Position = UDim2.new(0,20,0.5,-32)
floatBtn.Image = "rbxassetid://74356605425526"
floatBtn.BackgroundColor3 = Color3.fromRGB(120,0,170)
floatBtn.AutoButtonColor = false
floatBtn.Parent = gui

local corner = Instance.new("UICorner", floatBtn)
corner.CornerRadius = UDim.new(1,0)

-- Drag mobile
do
    local dragging, dragStart, startPos
    floatBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = floatBtn.Position
        end
    end)
    floatBtn.InputEnded:Connect(function()
        dragging = false
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = i.Position - dragStart
            floatBtn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ===== HUB PRINCIPAL =====
local main = Instance.new("Frame")
main.Size = UDim2.fromScale(0.55,0.55)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- Topo
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,60)
top.BackgroundColor3 = Color3.fromRGB(90,0,140)
Instance.new("UICorner", top).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "GHOUL HUB 🖤"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

-- ===== SIDEBAR =====
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0,160,1,-60)
sidebar.Position = UDim2.new(0,0,0,60)
sidebar.BackgroundColor3 = Color3.fromRGB(240,240,240)

local list = Instance.new("UIListLayout", sidebar)
list.Padding = UDim.new(0,6)

local function sideBtn(txt)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-10,0,40)
    b.Position = UDim2.new(0,5,0,0)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(80,0,120)
    b.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    b.Parent = sidebar
    return b
end

-- ===== CONTEÚDO =====
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-160,1,-60)
content.Position = UDim2.new(0,160,0,60)
content.BackgroundTransparency = 1

local function clear()
    for _,v in ipairs(content:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
end

local function page(name)
    clear()
    local f = Instance.new("Frame", content)
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,0,0,40)
    lbl.Text = name
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 20
    lbl.TextColor3 = Color3.fromRGB(180,120,255)
    lbl.BackgroundTransparency = 1
end

-- ===== FUNÇÕES =====
sideBtn("Fly").MouseButton1Click:Connect(function()
    page("Fly")
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
