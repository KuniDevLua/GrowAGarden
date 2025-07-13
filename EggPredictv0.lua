local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

local eggToPets = {
    ["Common Egg"]     = {"Dog", "Golden Lab", "Bunny"},
    ["Uncommon Egg"]   = {"Black Bunny", "Cat", "Chicken", "Deer"},
    ["Rare Egg"]       = {"Monkey", "Orange Tabby", "Pig", "Rooster", "Spotted Deer"},
    ["Legendary Egg"]  = {"Cow", "Silver Monkey", "Sea Otter", "Turtle", "Polar Bear"},
    ["Mythical Egg"]   = {"Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant", "Red Fox"},
    ["Bug Egg"]        = {"Snail", "Giant Ant", "Caterpillar", "Praying Mantis", "Dragonfly"},
    ["Bee Egg"]        = {"Bee", "Honey Bee", "Bear Bee", "Petal Bee", "Queen Bee"},
    ["Paradise Egg"]   = {"Ostrich", "Peacock", "Capybara", "Scarlet Macaw", "Mimic Octopus"},
    ["Oasis Egg"]      = {"Meerkat", "Sand Snake", "Axolotl", "Hyacinth Macaw"},
}

local espList = {}

local function clearESP()
    for _, gui in pairs(espList) do
        if gui and gui.Parent then gui:Destroy() end
    end
    espList = {}
end

local function createESP(part, petName)
    if part and not part:FindFirstChild("EggESP") then
        local gui = Instance.new("BillboardGui", part)
        gui.Name = "EggESP"
        gui.Size = UDim2.new(0, 100, 0, 40)
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        gui.AlwaysOnTop = true

        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = petName
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0.5
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true

        table.insert(espList, gui)
    end
end

local function getRandomPet(eggName, forceRare)
    local pool = eggToPets[eggName]
    if pool then
        if forceRare then
            return pool[#pool]
        end
        return pool[math.random(1, #pool)]
    end
    return "Unknown"
end

local function randomizeEggs(forceRare)
    clearESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and eggToPets[obj.Name] then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local pet = getRandomPet(obj.Name, forceRare)
                createESP(part, pet)
            end
        end
    end
end

-- 🌀 LOADING SCREEN
local loadingGui = Instance.new("ScreenGui", PlayerGui)
loadingGui.Name = "LoadingScreen"
loadingGui.IgnoreGuiInset = true

local bgFrame = Instance.new("Frame", loadingGui)
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

local loadingFrame = Instance.new("Frame", bgFrame)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.Size = UDim2.new(0, 250, 0, 100)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
loadingFrame.BorderSizePixel = 0
loadingFrame.ClipsDescendants = true
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel", loadingFrame)
titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Kuni Hub"
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.TextScaled = true

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(1, 0, 0.3, 0)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading"
loadingText.Font = Enum.Font.FredokaOne
loadingText.TextColor3 = Color3.fromRGB(255, 215, 0)
loadingText.TextScaled = true

local barBG = Instance.new("Frame", loadingFrame)
barBG.Size = UDim2.new(1, -20, 0, 10)
barBG.Position = UDim2.new(0, 10, 1, -20)
barBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
barBG.BorderSizePixel = 0

local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
bar.BorderSizePixel = 0

task.spawn(function()
    for i = 1, 30 do
        local percent = i / 30
        TweenService:Create(bar, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
            Size = UDim2.new(percent, 0, 1, 0)
        }):Play()
        loadingText.Text = "Loading" .. string.rep(".", i % 4)
        task.wait(10/30)
    end
end)

task.wait(10.2)
TweenService:Create(loadingFrame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(titleLabel, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(loadingText, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(barBG, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(bar, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
task.wait(0.7)
loadingGui:Destroy()

-- GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "KuniVIPGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.01, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Minimize / Exit Buttons
local exitBtn = Instance.new("TextButton", frame)
exitBtn.Text = "✕"
exitBtn.Size = UDim2.new(0, 30, 0, 30)
exitBtn.Position = UDim2.new(1, -35, 0, 5)
exitBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
exitBtn.BackgroundTransparency = 1
exitBtn.Font = Enum.Font.GothamBold
exitBtn.TextScaled = true

exitBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Pet Predictor by Kuni"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.FredokaOne
title.TextScaled = true

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 38)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true

local randomBtn = Instance.new("TextButton", frame)
randomBtn.Size = UDim2.new(0.9, 0, 0, 30)
randomBtn.Position = UDim2.new(0.05, 0, 0, 65)
randomBtn.Text = "Randomize Pet"
randomBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
randomBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
randomBtn.Font = Enum.Font.GothamBold
randomBtn.TextScaled = true
Instance.new("UICorner", randomBtn).CornerRadius = UDim.new(0, 8)

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(0.9, 0, 0, 30)
autoBtn.Position = UDim2.new(0.05, 0, 0, 100)
autoBtn.Text = "Auto Randomize Until Rare"
autoBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
autoBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextScaled = true
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, 8)

-- Button Logic
local canClick = true
randomBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    statusLabel.Text = "Randomizing..."
    randomizeEggs()
    task.wait(2)
    statusLabel.Text = ""
    canClick = true
end)

autoBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    statusLabel.Text = "Searching for rare pet..."
    local found = false
    local startTime = tick()

    local function checkIfRareFound()
        for _, gui in pairs(espList) do
            if gui:IsA("BillboardGui") then
                local label = gui:FindFirstChildOfClass("TextLabel")
                local model = gui.Parent
                if model and eggToPets[model.Name] then
                    local rarePet = eggToPets[model.Name][#eggToPets[model.Name]]
                    if label.Text == rarePet then
                        return true, rarePet
                    end
                end
            end
        end
        return false
    end

    task.spawn(function()
        while tick() - startTime < 18 do
            randomizeEggs()
            local success, pet = checkIfRareFound()
            if success then
                found = true
                statusLabel.Text = "✅ Found: " .. pet
                break
            end
            task.wait(2)
        end

        if not found then
            randomizeEggs(true)
            local pet
            for _, gui in pairs(espList) do
                local label = gui:FindFirstChildOfClass("TextLabel")
                if label then
                    pet = label.Text
                    break
                end
            end
            statusLabel.Text = "✅ Forced Drop: " .. (pet or "Rare Pet")
        end

        task.wait(3)
        statusLabel.Text = ""
        canClick = true
    end)
end)
