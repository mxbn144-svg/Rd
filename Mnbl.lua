-- ============================================
-- DELTA MENU v1.2 (С ТЕЛЕПОРТАЦИЕЙ)
-- ============================================

-- Очистка старого GUI
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("DeltaMenu"):Destroy()
end)

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = game:GetService("Workspace").CurrentCamera

local speedMultiplier = 1.0
local enabled = false
local autoStartEnabled = false
local autoStartConnection = nil

local function applySpeed()
    if enabled then
        local vehicle = Character:FindFirstChildOfClass("VehicleSeat")
        if vehicle then
            local bv = vehicle:FindFirstChildOfClass("BodyVelocity")
            if bv then
                bv.Velocity = Vector3.new(0, 0, -speedMultiplier * 50)
            else
                vehicle:SetAttribute("Throttle", speedMultiplier)
            end
        else
            if Humanoid then
                Humanoid.WalkSpeed = 16 * speedMultiplier
            end
        end
    else
        if Humanoid then
            Humanoid.WalkSpeed = 16
        end
        local vehicle = Character:FindFirstChildOfClass("VehicleSeat")
        if vehicle then
            local bv = vehicle:FindFirstChildOfClass("BodyVelocity")
            if bv then
                bv.Velocity = Vector3.new(0, 0, 0)
            end
            vehicle:SetAttribute("Throttle", 0)
        end
    end
end

local function autoStartCheck()
    local function searchInGUI(gui)
        for _, obj in ipairs(gui:GetChildren()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local txt = obj.Text or ""
                if txt == "3" or txt == "2" or txt == "1" then
                    if txt == "1" then
                        enabled = true
                        toggleSpeedBtn.Text = "ВКЛ"
                        toggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                        applySpeed()
                    end
                end
            end
            searchInGUI(obj)
        end
    end

    local coreGui = game:GetService("CoreGui")
    local playerGui = LP:WaitForChild("PlayerGui")
    searchInGUI(coreGui)
    searchInGUI(playerGui)
end

-- ============================================
-- ФУНКЦИЯ ТЕЛЕПОРТАЦИИ ВПЕРЁД НА 35 МЕТРОВ
-- ============================================
local function teleportForward()
    if not Character or not Character.PrimaryPart then
        Character = LP.Character or LP.CharacterAdded:Wait()
        if not Character or not Character.PrimaryPart then
            warn("Персонаж не найден!")
            return
        end
    end
    
    local primaryPart = Character.PrimaryPart
    if not primaryPart then
        warn("Нет PrimaryPart у персонажа!")
        return
    end
    
    -- Получаем направление взгляда камеры
    local lookVector = Camera.CFrame.LookVector
    
    -- Убираем вертикальную составляющую (движение только по горизонтали)
    lookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    
    -- Телепортируем на 35 метров вперёд
    local newPosition = primaryPart.Position + lookVector * 35
    
    -- Проверяем, что не улетаем под карту
    if newPosition.Y < 0 then
        newPosition = Vector3.new(newPosition.X, 5, newPosition.Z)
    end
    
    -- Перемещаем персонажа
    primaryPart.CFrame = CFrame.new(newPosition)
    
    print("🚀 Телепортировался на 35 метров вперёд!")
end

-- ============================================
-- СОЗДАНИЕ GUI
-- ============================================
local CoreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaMenu"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Кнопка открытия/закрытия
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 70, 0, 70)
toggleButton.Position = UDim2.new(0, 15, 0, 120)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.Text = "☰ МЕНЮ"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Bold
toggleButton.BorderSizePixel = 2
toggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

-- Основное меню (УВЕЛИЧЕННАЯ ВЫСОТА ДЛЯ НОВОЙ КНОПКИ)
local mainMenu = Instance.new("Frame")
mainMenu.Size = UDim2.new(0, 320, 0, 360)  -- Увеличил высоту
mainMenu.Position = UDim2.new(0, 100, 0, 120)
mainMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainMenu.BorderSizePixel = 2
mainMenu.BorderColor3 = Color3.fromRGB(100, 100, 255)
mainMenu.Visible = false
mainMenu.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
title.Text = "⚡ DELTA МЕНЮ"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.Bold
title.Parent = mainMenu

-- Скорость
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0, 280, 0, 50)
speedFrame.Position = UDim2.new(0, 20, 0, 50)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainMenu

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 110, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 10)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Скорость: 1.0x"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextScaled = true
speedLabel.Parent = speedFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 40, 0, 40)
minusBtn.Position = UDim2.new(0, 120, 0, 5)
minusBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.new(1, 1, 1)
minusBtn.TextScaled = true
minusBtn.Parent = speedFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 60, 0, 40)
speedInput.Position = UDim2.new(0, 165, 0, 5)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.BorderSizePixel = 1
speedInput.BorderColor3 = Color3.fromRGB(200, 200, 200)
speedInput.Text = "1.0"
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.TextScaled = true
speedInput.ClearTextOnFocus = false
speedInput.Parent = speedFrame

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 40, 0, 40)
plusBtn.Position = UDim2.new(0, 230, 0, 5)
plusBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.new(1, 1, 1)
plusBtn.TextScaled = true
plusBtn.Parent = speedFrame

-- Ускорение
local toggleSpeedFrame = Instance.new("Frame")
toggleSpeedFrame.Size = UDim2.new(0, 280, 0, 40)
toggleSpeedFrame.Position = UDim2.new(0, 20, 0, 110)
toggleSpeedFrame.BackgroundTransparency = 1
toggleSpeedFrame.Parent = mainMenu

local toggleSpeedLabel = Instance.new("TextLabel")
toggleSpeedLabel.Size = UDim2.new(0, 140, 0, 40)
toggleSpeedLabel.Position = UDim2.new(0, 0, 0, 0)
toggleSpeedLabel.BackgroundTransparency = 1
toggleSpeedLabel.Text = "🔹 Ускорение"
toggleSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
toggleSpeedLabel.TextScaled = true
toggleSpeedLabel.Parent = toggleSpeedFrame

local toggleSpeedBtn = Instance.new("TextButton")
toggleSpeedBtn.Size = UDim2.new(0, 90, 0, 40)
toggleSpeedBtn.Position = UDim2.new(0, 150, 0, 0)
toggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleSpeedBtn.Text = "ВЫКЛ"
toggleSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
toggleSpeedBtn.TextScaled = true
toggleSpeedBtn.Parent = toggleSpeedFrame

-- Авто-старт
local autoStartFrame = Instance.new("Frame")
autoStartFrame.Size = UDim2.new(0, 280, 0, 40)
autoStartFrame.Position = UDim2.new(0, 20, 0, 160)
autoStartFrame.BackgroundTransparency = 1
autoStartFrame.Parent = mainMenu

local autoStartLabel = Instance.new("TextLabel")
autoStartLabel.Size = UDim2.new(0, 140, 0, 40)
autoStartLabel.Position = UDim2.new(0, 0, 0, 0)
autoStartLabel.BackgroundTransparency = 1
autoStartLabel.Text = "🏁 Авто-старт"
autoStartLabel.TextColor3 = Color3.new(1, 1, 1)
autoStartLabel.TextScaled = true
autoStartLabel.Parent = autoStartFrame

local autoStartBtn = Instance.new("TextButton")
autoStartBtn.Size = UDim2.new(0, 90, 0, 40)
autoStartBtn.Position = UDim2.new(0, 150, 0, 0)
autoStartBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
autoStartBtn.Text = "ВЫКЛ"
autoStartBtn.TextColor3 = Color3.new(1, 1, 1)
autoStartBtn.TextScaled = true
autoStartBtn.Parent = autoStartFrame

-- ============================================
-- НОВАЯ КНОПКА ТЕЛЕПОРТАЦИИ
-- ============================================
local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(0, 280, 0, 50)
teleportFrame.Position = UDim2.new(0, 20, 0, 210)
teleportFrame.BackgroundTransparency = 1
teleportFrame.Parent = mainMenu

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Size = UDim2.new(0, 140, 0, 50)
teleportLabel.Position = UDim2.new(0, 0, 0, 0)
teleportLabel.BackgroundTransparency = 1
teleportLabel.Text = "🚀 Телепорт"
teleportLabel.TextColor3 = Color3.new(1, 1, 1)
teleportLabel.TextScaled = true
teleportLabel.Parent = teleportFrame

local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0, 120, 0, 50)
teleportBtn.Position = UDim2.new(0, 140, 0, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)  -- Оранжевый
teleportBtn.Text = "35м →"
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.TextScaled = true
teleportBtn.Font = Enum.Font.Bold
teleportBtn.Parent = teleportFrame

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 280, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 275)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "✅ Меню загружено"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextScaled = true
statusLabel.Parent = mainMenu

-- ============================================
-- ОБРАБОТЧИКИ
-- ============================================

local function updateSpeed()
    local val = tonumber(speedInput.Text) or 1.0
    if val < 0.1 then val = 0.1 end
    if val > 10 then val = 10 end
    speedMultiplier = val
    speedInput.Text = string.format("%.1f", val)
    speedLabel.Text = "Скорость: " .. string.format("%.1f", val) .. "x"
    if enabled then applySpeed() end
end

plusBtn.MouseButton1Click:Connect(function()
    local val = tonumber(speedInput.Text) or 1.0
    val = math.min(val + 0.1, 10)
    speedInput.Text = string.format("%.1f", val)
    updateSpeed()
end)

minusBtn.MouseButton1Click:Connect(function()
    local val = tonumber(speedInput.Text) or 1.0
    val = math.max(val - 0.1, 0.1)
    speedInput.Text = string.format("%.1f", val)
    updateSpeed()
end)

speedInput.FocusLost:Connect(function()
    updateSpeed()
end)

toggleSpeedBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggleSpeedBtn.Text = enabled and "ВКЛ" or "ВЫКЛ"
    toggleSpeedBtn.BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    applySpeed()
end)

autoStartBtn.MouseButton1Click:Connect(function()
    autoStartEnabled = not autoStartEnabled
    autoStartBtn.Text = autoStartEnabled and "ВКЛ" or "ВЫКЛ"
    autoStartBtn.BackgroundColor3 = autoStartEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

    if autoStartEnabled then
        if autoStartConnection then autoStartConnection:Disconnect() end
        autoStartConnection = game:GetService("RunService").Heartbeat:Connect(function()
            autoStartCheck()
        end)
    else
        if autoStartConnection then
            autoStartConnection:Disconnect()
            autoStartConnection = nil
        end
    end
end)

-- ============================================
-- ОБРАБОТЧИК ТЕЛЕПОРТАЦИИ
-- ============================================
teleportBtn.MouseButton1Click:Connect(function()
    teleportForward()
    -- Визуальная обратная связь
    teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    task.wait(0.2)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
end)

-- ============================================
-- ОТКРЫТИЕ / ЗАКРЫТИЕ МЕНЮ
-- ============================================
local menuVisible = false

toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    mainMenu.Visible = menuVisible
    
    if menuVisible then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        toggleButton.Text = "☰ ЗАКРЫТЬ"
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        toggleButton.Text = "☰ МЕНЮ"
    end
end)

-- Закрытие по клику вне меню
local function closeMenuOnOutsideClick(inputObject, gameProcessedEvent)
    if gameProcessedEvent then return end
    if menuVisible then
        local mousePos = inputObject.Position
        local menuAbsPos = mainMenu.AbsolutePosition
        local menuSize = mainMenu.AbsoluteSize
        
        if not (mousePos.X >= menuAbsPos.X and mousePos.X <= menuAbsPos.X + menuSize.X and
                mousePos.Y >= menuAbsPos.Y and mousePos.Y <= menuAbsPos.Y + menuSize.Y) then
            
            local toggleAbsPos = toggleButton.AbsolutePosition
            local toggleSize = toggleButton.AbsoluteSize
            if not (mousePos.X >= toggleAbsPos.X and mousePos.X <= toggleAbsPos.X + toggleSize.X and
                    mousePos.Y >= toggleAbsPos.Y and mousePos.Y <= toggleAbsPos.Y + toggleSize.Y) then
                menuVisible = false
                mainMenu.Visible = false
                toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                toggleButton.Text = "☰ МЕНЮ"
            end
        end
    end
end

game:GetService("UserInputService").InputBegin:Connect(closeMenuOnOutsideClick)

updateSpeed()

LP.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    applySpeed()
end)

print("✅ Delta Menu v1.2 загружен! Нажмите 'МЕНЮ' для открытия.")
print("🚀 Добавлена кнопка телепортации на 35 метров!")
