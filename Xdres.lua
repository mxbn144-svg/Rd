-- ТЕЛЕПОРТ НА 35 МЕТРОВ (с перетаскиваемой кнопкой)
-- Работает на телефоне: кнопку можно двигать, нажатие телепортирует вперёд

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Кнопка телепортации
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0, 70, 0, 70)          -- размер
teleportBtn.Position = UDim2.new(0.8, -35, 0.5, -35) -- по умолчанию справа по центру
teleportBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255) -- ярко-синий
teleportBtn.Text = "⬆\n35м"                         -- текст с иконкой
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.TextScaled = true
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.BorderSizePixel = 0
teleportBtn.ClipsDescendants = true
teleportBtn.Parent = screenGui

-- Делаем кнопку круглой (опционально)
teleportBtn.BackgroundTransparency = 0.2
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)  -- полный радиус для круга
corner.Parent = teleportBtn

-- Добавляем тень для эффекта (опционально)
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.Image = "rbxassetid://1316044315"  -- размытая тень
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.BackgroundTransparency = 1
shadow.ZIndex = 0
shadow.Parent = teleportBtn

-- ===== ПЕРЕТАСКИВАНИЕ КНОПКИ (для телефона) =====
local dragDetector = Instance.new("UIDragDetector")
dragDetector.Parent = teleportBtn
-- Разрешаем перетаскивание только по осям X и Y
dragDetector.DragDirection = Enum.DragDirection.XY
-- Ограничиваем, чтобы кнопка не выходила за экран (можно настроить)
dragDetector.DragStart:Connect(function()
    -- при начале перетаскивания можно немного подсветить
    teleportBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
end)
dragDetector.DragEnd:Connect(function()
    teleportBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
end)

-- Также можно добавить обработку нажатия для телепортации
teleportBtn.MouseButton1Click:Connect(function()
    -- Проверяем, что персонаж существует
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Направление вперёд от корня
    local forward = root.CFrame.LookVector
    -- Новая позиция = текущая + направление * 35
    local newPos = root.Position + forward * 35
    -- Немного поднимаем, чтобы не провалиться под землю (можно 2-5 единиц)
    newPos = newPos + Vector3.new(0, 2, 0)

    -- Телепортируем (устанавливаем CFrame с сохранением ориентации)
    root.CFrame = CFrame.new(newPos, newPos + root.CFrame.LookVector)

    -- Визуальный отклик (мигание)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    wait(0.15)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
end)

-- ===== ДОПОЛНИТЕЛЬНО: КНОПКА УДАЛЕНИЯ GUI (опционально) =====
-- Можно добавить небольшую кнопку для закрытия, но не обязательно.
-- Если нужно, раскомментируйте:
-- local closeBtn = Instance.new("TextButton")
-- closeBtn.Size = UDim2.new(0, 20, 0, 20)
-- closeBtn.Position = UDim2.new(1, -25, 0, 5)
-- closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
-- closeBtn.Text = "✕"
-- closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
-- closeBtn.TextScaled = true
-- closeBtn.Parent = teleportBtn
-- closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

print("✅ Кнопка телепортации на 35 метров загружена!")
print("📱 Перетащите её пальцем в любое место экрана, нажмите – и вы переместитесь вперёд.")
