-- ============================================
-- DELTA MENU v1.0 (для мобильных устройств)
-- Функции: регулировка скорости, ускорение,
-- авто-старт по обратному отсчёту 3-2-1
-- ============================================

-- Очистка старого GUI
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("DeltaMenu"):Destroy()
end)

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Глобальные переменные
local speedMultiplier = 1.0
local enabled = false          -- включено ли ускорение
local autoStartEnabled = false
local autoStartConnection = nil

-- ----------------------------------------------
-- Функция применения скорости (пешком или в транспорте)
-- ----------------------------------------------
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

-- ----------------------------------------------
-- Функция авто-старта (поиск текста "3","2","1")
-- ----------------------------------------------
local function autoStartCheck()
    local function searchInGUI(gui)
        for _, obj in ipairs(gui:GetChildren()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local txt = obj.Text or ""
                if txt == "3" or txt == "2" or txt == "1" then
                    if txt == "1" then
                        enabled = true
                        toggleSpeedBtn.Text = "On"
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

-- ----------------------------------------------
-- СОЗДАНИЕ GUI
-- ----------------------------------------------
local CoreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaMenu"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- --- Кнопка открытия/закрытия меню (плавающая) ---
local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 55, 0, 55)
toggleButton.Position = UDim2.new(0, 10, 0, 100)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.BorderSizePixel = 0
toggleButton.Image = "rbxassetid://0"
toggleButton.Parent = screenGui

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(1, 0, 1, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Menu"
toggleLabel.TextColor3 = Color3.new(1, 1, 1)
toggleLabel.TextScaled = true
toggleLabel.Parent = toggleButton

-- --- Основное меню (изначально скрыто) ---
local mainMenu = Instance.new("Frame")
mainMenu.Size = UDim2.new(0, 300, 0, 280)
mainMenu.Position = UDim2.new(0, 75, 0, 100)
mainMenu.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainMenu.BorderSizePixel = 0
mainMenu.Visible = false
mainMenu.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "⚡ Delta Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.Bold
title.Parent = mainMenu

-- -------- Регулировка скорости (ползунок + кнопки) --------
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0, 260, 0, 45)
speedFrame.Position = UDim2.new(0, 20, 0, 40)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainMenu

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 100, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 1.0x"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextScaled = true
speedLabel.Parent = speedFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 35, 0, 35)
minusBtn.Position = UDim2.new(0, 80, 0, 5)
minusBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.new(1, 1, 1)
minusBtn.TextScaled = true
minusBtn.Parent = speedFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 60, 0, 35)
speedInput.Position = UDim2.new(0, 120, 0, 5)
speedInput.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
speedInput.BorderSizePixel = 0
speedInput.Text = "1.0"
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.TextScaled = true
speedInput.ClearTextOnFocus = false
speedInput.Parent = speedFrame

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 35, 0, 35)
plusBtn.Position = UDim2.new(0, 185, 0, 5)
plusBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.new(1, 1, 1)
plusBtn.TextScaled = true
plusBtn.Parent = speedFrame

-- -------- Включение/отключение ускорения --------
local toggleSpeedFrame = Instance.new("Frame")
toggleSpeedFrame.Size = UDim2.new(0, 260, 0, 35)
toggleSpeedFrame.Position = UDim2.new(0, 20, 0, 95)
toggleSpeedFrame.BackgroundTransparency = 1
toggleSpeedFrame.Parent = mainMenu

local toggleSpeedLabel = Instance.new("TextLabel")
toggleSpeedLabel.Size = UDim2.new(0, 130, 0, 35)
toggleSpeedLabel.Position = UDim2.new(0, 0, 0, 0)
toggleSpeedLabel.BackgroundTransparency = 1
toggleSpeedLabel.Text = "Ускорение"
toggleSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
toggleSpeedLabel.TextScaled = true
toggleSpeedLabel.Parent = toggleSpeedFrame

local toggleSpeedBtn = Instance.new("TextButton")
toggleSpeedBtn.Size = UDim2.new(0, 80, 0, 35)
toggleSpeedBtn.Position = UDim2.new(0, 140, 0, 0)
toggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleSpeedBtn.Text = "Off"
toggleSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
toggleSpeedBtn.TextScaled = true
toggleSpeedBtn.Parent = toggleSpeedFrame

-- -------- Авто-старт (по обратному отсчёту) --------
local autoStartFrame = Instance.new("Frame")
autoStartFrame.Size = UDim2.new(0, 260, 0, 35)
autoStartFrame.Position = UDim2.new(0, 20, 0, 140)
autoStartFrame.BackgroundTransparency = 1
autoStartFrame.Parent = mainMenu

local autoStartLabel = Instance.new("TextLabel")
autoStartLabel.Size = UDim2.new(0, 130, 0, 35)
autoStartLabel.Position = UDim2.new(0, 0, 0, 0)
autoStartLabel.BackgroundTransparency = 1
autoStartLabel.Text = "Авто-старт"
autoStartLabel.TextColor3 = Color3.new(1, 1, 1)
autoStartLabel.TextScaled = true
autoStartLabel.Parent = autoStartFrame

local autoStartBtn = Instance.new("TextButton")
autoStartBtn.Size = UDim2.new(0, 80, 0, 35)
autoStartBtn.Position = UDim2.new(0, 140, 0, 0)
autoStartBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
autoStartBtn.Text = "Off"
autoStartBtn.TextColor3 = Color3.new(1, 1, 1)
autoStartBtn.TextScaled = true
autoStartBtn.Parent = autoStartFrame

-- ----------------------------------------------
-- ОБРАБОТЧИКИ СОБЫТИЙ
-- ----------------------------------------------

local function updateSpeed()
    local val = tonumber(speedInput.Text) or 1.0
    if val < 0.1 then val = 0.1 end
    if val > 10 then val = 10 end
    speedMultiplier = val
    speedInput.Text = string.format("%.1f", val)
    speedLabel.Text = "Speed: " .. string.format("%.1f", val) .. "x"
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
    toggleSpeedBtn.Text = enabled and "On" or "Off"
    toggleSpeedBtn.BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    applySpeed()
end)

autoStartBtn.MouseButton1Click:Connect(function()
    autoStartEnabled = not autoStartEnabled
    autoStartBtn.Text = autoStartEnabled and "On" or "Off"
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

-- *** ОТКРЫТИЕ / ЗАКРЫТИЕ МЕНЮ ***
local menuVisible = false
toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    mainMenu.Visible = menuVisible
end)

updateSpeed()

LP.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    applySpeed()
end)

print("✅ Delta Menu загружен! Нажмите 'Menu' для открытия.")
