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

-- 🌀 LOADING SCREEN FIRST
local loadingGui = Instance.new("ScreenGui", PlayerGui)
loadingGui.Name = "LoadingScreen"
loadingGui.IgnoreGuiInset = true
loadingGui.ResetOnSpawn = false

local bg = Instance.new("Frame", loadingGui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

local loadBox = Instance.new("Frame", bg)
loadBox.Size = UDim2.new(0, 240, 0, 90)
loadBox.Position = UDim2.new(0.5, -120, 0.5, -45)
loadBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", loadBox).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", loadBox)
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Text = "Kuni Hub"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.TextScaled = true

local text = Instance.new("TextLabel", loadBox)
text.Size = UDim2.new(1, 0, 0.3, 0)
text.Position = UDim2.new(0, 0, 0.4, 0)
text.Text = "Loading"
text.Font = Enum.Font.FredokaOne
text.TextColor3 = Color3.fromRGB(255, 215, 0)
text.BackgroundTransparency = 1
text.TextScaled = true

local barBG = Instance.new("Frame", loadBox)
barBG.Size = UDim2.new(0.9, 0, 0, 8)
barBG.Position = UDim2.new(0.05, 0, 1, -16)
barBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)

task.spawn(function()
    for i = 1, 30 do
        local p = i / 30
        TweenService:Create(bar, TweenInfo.new(0.3), {Size = UDim2.new(p, 0, 1, 0)}):Play()
        text.Text = "Loading" .. string.rep(".", i % 4)
        task.wait(10/30)
    end
end)

task.wait(10.2)
loadingGui:Destroy()

-- 🌟 MAIN GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "KuniVIPGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.01, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

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

local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Pet Predictor by Kuni"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextScaled = true

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 38)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.Font = Enum.Font.Gotham
status.TextScaled = true

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

-- 💡 FUNCTIONAL BUTTONS
local canClick = true
randomBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    status.Text = "Randomizing..."
    randomizeEggs()
    task.wait(2)
    status.Text = ""
    canClick = true
end)

autoBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    status.Text = "Searching for rare pet..."
    local found = false
    local startTime = tick()

    local function isRareFound()
        for _, gui in pairs(espList) do
            if gui:IsA("BillboardGui") then
                local label = gui:FindFirstChildOfClass("TextLabel")
                local model = gui.Parent
                if model and eggToPets[model.Name] then
                    local rare = eggToPets[model.Name][#eggToPets[model.Name]]
                    if label.Text == rare then
                        return true, rare
                    end
                end
            end
        end
        return false
    end

    task.spawn(function()
        while tick() - startTime < 18 do
            randomizeEggs()
            local ok, pet = isRareFound()
            if ok then
                found = true
                status.Text = "✅ Found: " .. pet
                break
            end
            task.wait(2)
        end

        if not found then
            randomizeEggs(true)
            local pet
            for _, gui in pairs(espList) do
                local label = gui:FindFirstChildOfClass("TextLabel")
                if label then pet = label.Text break end
            end
            status.Text = "✅ Forced Drop: " .. (pet or "Rare Pet")
        end

        task.wait(3)
        status.Text = ""
        canClick = true
    end)
end)
