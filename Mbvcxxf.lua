-- СУПЕР-СБОРЩИК ЛИСТЬЕВ (все миры, все листья до единого)
-- Меню с плавающей кнопкой, ESP, запоминание прогресса

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.Image = "rbxassetid://6031091070"
toggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 500)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.3
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "🍃 Сборщик (все миры)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Parent = mainFrame

local function toggleMenu()
    mainFrame.Visible = not mainFrame.Visible
end
toggleBtn.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -45)
scroll.Position = UDim2.new(0, 0, 0, 45)
scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scroll.BackgroundTransparency = 0.5
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = mainFrame

-- ===== СОСТОЯНИЯ =====
local states = {}
local function getState(name) return states[name] or false end
local function setState(name, val) states[name] = val end

-- ===== ПЕРЕМЕННЫЕ =====
local botRunning = false
local espEnabled = false
local collectedLeaves = {}
local leafList = {}
local highlightObjects = {}

-- ===== ПОИСК ЛИСТЬЕВ (по всему workspace) =====
local function findLeaves()
    local leaves = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("leaf") or name:find("лист") or name:find("foliage") or name:find("tree") or name:find("plant") or name:find("bush") then
                table.insert(leaves, obj)
            end
        end
    end
    return leaves
end

-- ===== ESP =====
local function updateESP()
    for _, h in pairs(highlightObjects) do
        if h and h.Parent then h:Destroy() end
    end
    highlightObjects = {}
    if not espEnabled then return end
    for _, leaf in ipairs(leafList) do
        if not collectedLeaves[leaf] then
            local part
            if leaf:IsA("BasePart") then
                part = leaf
            elseif leaf:IsA("Model") and leaf.PrimaryPart then
                part = leaf.PrimaryPart
            else
                part = leaf:FindFirstChildWhichIsA("BasePart")
            end
            if part then
                local highlight = Instance.new("Highlight")
                highlight.Parent = part
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.FillTransparency = 0.3
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                table.insert(highlightObjects, highlight)
            end
        end
    end
end

-- ===== ФУНКЦИЯ СБОРА (телепорт + клик) =====
local function collectLeaf(leaf)
    if not leaf then return end
    local pos
    if leaf:IsA("BasePart") then
        pos = leaf.Position
    elseif leaf:IsA("Model") and leaf.PrimaryPart then
        pos = leaf.PrimaryPart.Position
    else
        return
    end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
    wait(0.1)
    if leaf:IsA("BasePart") and leaf:FindFirstChild("ClickDetector") then
        leaf.ClickDetector:Click()
    else
        mouse1click()
    end
    collectedLeaves[leaf] = true
end

-- ===== СБОР ВСЕХ ЛИСТЬЕВ (все миры) =====
local function collectAllLeaves()
    leafList = findLeaves()
    local remaining = {}
    for _, leaf in ipairs(leafList) do
        if not collectedLeaves[leaf] then
            table.insert(remaining, leaf)
        end
    end
    if #remaining == 0 then
        print("✅ Все листья уже собраны на всех мирах!")
        return
    end
    print("🍃 Начинаем сбор " .. #remaining .. " листьев (включая все миры)...")
    -- Сортируем по расстоянию, чтобы сначала собирать ближайшие
    table.sort(remaining, function(a, b)
        local posA = a:IsA("BasePart") and a.Position or (a.PrimaryPart and a.PrimaryPart.Position) or Vector3.new(0,0,0)
        local posB = b:IsA("BasePart") and b.Position or (b.PrimaryPart and b.PrimaryPart.Position) or Vector3.new(0,0,0)
        return (hrp.Position - posA).Magnitude < (hrp.Position - posB).Magnitude
    end)
    for _, leaf in ipairs(remaining) do
        collectLeaf(leaf)
        wait(0.2)
    end
    updateESP()
    print("✅ Все листья на всех мирах собраны!")
end

-- ===== ФАРМБОТ (автоматический режим) =====
local function farmLeaves()
    while botRunning do
        leafList = findLeaves()
        local remaining = {}
        for _, leaf in ipairs(leafList) do
            if not collectedLeaves[leaf] then
                table.insert(remaining, leaf)
            end
        end
        if #remaining == 0 then
            print("✅ Все листья собраны (все миры)!")
            updateESP()
            break
        end
        table.sort(remaining, function(a, b)
            local posA = a:IsA("BasePart") and a.Position or (a.PrimaryPart and a.PrimaryPart.Position) or Vector3.new(0,0,0)
            local posB = b:IsA("BasePart") and b.Position or (b.PrimaryPart and b.PrimaryPart.Position) or Vector3.new(0,0,0)
            return (hrp.Position - posA).Magnitude < (hrp.Position - posB).Magnitude
        end)
        for _, leaf in ipairs(remaining) do
            if not botRunning then break end
            collectLeaf(leaf)
            wait(0.3)
        end
        wait(1) -- небольшая пауза перед новым сканированием
    end
end

-- ===== УПРАВЛЕНИЕ =====
local function toggleFarmBot()
    botRunning = not botRunning
    setState("farmbot", botRunning)
    if botRunning then
        spawn(farmLeaves)
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    setState("esp", espEnabled)
    updateESP()
end

local function resetProgress()
    collectedLeaves = {}
    leafList = findLeaves()
    updateESP()
    print("🔄 Прогресс сброшен (все миры)")
end

local function teleportCenter()
    hrp.CFrame = CFrame.new(0, 10, 0)
end

-- ===== СОЗДАНИЕ КНОПОК =====
local yPos = 10

local function addToggle(text, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.Text = text .. " ⚪"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(function()
        callback()
        local state = getState(name)
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = text .. (state and " 🟢" or " ⚪")
    end)
    yPos = yPos + 50
    return btn
end

local function addAction(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(70, 70, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    yPos = yPos + 50
    return btn
end

addToggle("🍃 Фармбот (авто)", "farmbot", toggleFarmBot)
addToggle("👁️ ESP", "esp", toggleESP)
addAction("⚡ Собрать все листья (все миры)", collectAllLeaves, Color3.fromRGB(200, 150, 0))
addAction("Сброс прогресса", resetProgress, Color3.fromRGB(200, 100, 0))
addAction("Телепорт в центр", teleportCenter, Color3.fromRGB(60, 120, 200))
addAction("Удалить GUI", function() screenGui:Destroy() end, Color3.fromRGB(100, 100, 100))

scroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

espEnabled = true
setState("esp", true)
updateESP()

print("✅ Супер-сборщик загружен! Нажмите ☰ для меню.")
print("🍃 Бот соберёт все листья на всех мирах, даже если их много.")
