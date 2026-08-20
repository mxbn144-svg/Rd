-- ТЕЛЕПОРТ НА 35 МЕТРОВ (КНОПКА ЗАКРЕПЛЕНА СВЕРХУ)
-- Кнопка не перемещается, всегда в левом верхнем углу

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Кнопка телепортации
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0, 80, 0, 80)          -- размер
teleportBtn.Position = UDim2.new(0.02, 0, 0.02, 0)  -- закреплена в левом верхнем углу
teleportBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255) -- ярко-синий
teleportBtn.Text = "⬆\n35м"                         
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.TextScaled = true
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.BorderSizePixel = 0
teleportBtn.BackgroundTransparency = 0.2
teleportBtn.Parent = screenGui

-- Делаем кнопку круглой
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = teleportBtn

-- Добавляем лёгкую тень для эффекта
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.Image = "rbxassetid://1316044315"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.BackgroundTransparency = 1
shadow.ZIndex = 0
shadow.Parent = teleportBtn

-- ===== ФУНКЦИЯ ТЕЛЕПОРТАЦИИ =====
local function teleportForward()
    if not character or not hrp then return end
    -- Направление вперёд от персонажа
    local forward = hrp.CFrame.LookVector
    -- Новая позиция = текущая + 35 метров вперёд
    local newPos = hrp.Position + forward * 35
    -- Немного поднимаем, чтобы не провалиться под землю
    newPos = newPos + Vector3.new(0, 2, 0)
    -- Телепортируем, сохраняя направление взгляда
    hrp.CFrame = CFrame.new(newPos, newPos + forward)
end

-- Нажатие на кнопку
teleportBtn.MouseButton1Click:Connect(teleportForward)

-- ===== КНОПКА УДАЛЕНИЯ (опционально) =====
-- Можно добавить маленький крестик для закрытия, если нужно:
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextScaled = true
closeBtn.Parent = teleportBtn
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

print("✅ Кнопка телепортации закреплена сверху! Нажмите для прыжка на 35 м.")
