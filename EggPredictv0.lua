-- ✅ Wait until the game is fully loaded
repeat task.wait() until game:IsLoaded()

-- ✅ Get necessary services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer or Players:GetPlayers()[1]
repeat task.wait() until LocalPlayer:FindFirstChild("PlayerGui")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ✅ Egg-to-pets table (used for ESP and randomizer)
-- Note: Last pet in each egg list = rarest
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

-- ✅ Holds all created ESP GUIs
local espList = {}

-- ✅ Clear previous ESPs
local function clearESP()
    for _, gui in pairs(espList) do
        if gui and gui.Parent then gui:Destroy() end
    end
    espList = {}
end

-- ✅ Create ESP label above a BasePart
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

-- ✅ Get a random pet OR the rarest pet from a given egg
local function getRandomPet(eggName, forceRare)
    local pool = eggToPets[eggName]
    if pool then
        if forceRare then return pool[#pool] end
        return pool[math.random(1, #pool)]
    end
    return "Unknown"
end

-- ✅ Go through all eggs in Workspace and assign predicted pets
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

-- ✅ KUNI LOADING SCREEN (10 seconds with animated bar)
local loadingGui = Instance.new("ScreenGui", PlayerGui)
loadingGui.Name = "KuniLoading"
loadingGui.IgnoreGuiInset = true

local bg = Instance.new("Frame", loadingGui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

local box = Instance.new("Frame", bg)
box.Size = UDim2.new(0, 240, 0, 90)
box.Position = UDim2.new(0.5, -120, 0.5, -45)
box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", box)
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Text = "Kuni Hub"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.TextScaled = true

local status = Instance.new("TextLabel", box)
status.Size = UDim2.new(1, 0, 0.3, 0)
status.Position = UDim2.new(0, 0, 0.4, 0)
status.Text = "Loading"
status.Font = Enum.Font.GothamBold
status.TextColor3 = Color3.fromRGB(255, 215, 0)
status.BackgroundTransparency = 1
status.TextScaled = true

local barBG = Instance.new("Frame", box)
barBG.Size = UDim2.new(0.9, 0, 0, 8)
barBG.Position = UDim2.new(0.05, 0, 1, -16)
barBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)

-- ✅ Animate the progress bar and loading text
task.spawn(function()
    for i = 1, 30 do
        TweenService:Create(bar, TweenInfo.new(0.3), {Size = UDim2.new(i / 30, 0, 1, 0)}):Play()
        status.Text = "Loading" .. string.rep(".", i % 4)
        task.wait(10 / 30)
    end
end)

-- ✅ After loading, remove screen
task.wait(10.2)
loadingGui:Destroy()

-- ✅ MAIN GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "KuniHubFinal"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 150)
frame.Position = UDim2.new(0.01, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- ✅ Title
local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Pet Predictor by Kuni"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true

-- ✅ Status label (for messages)
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 38)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true

-- ✅ Manual Button: Randomize once
local randomBtn = Instance.new("TextButton", frame)
randomBtn.Size = UDim2.new(0.9, 0, 0, 30)
randomBtn.Position = UDim2.new(0.05, 0, 0, 65)
randomBtn.Text = "Randomize Pet"
randomBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
randomBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
randomBtn.Font = Enum.Font.GothamBold
randomBtn.TextScaled = true
Instance.new("UICorner", randomBtn).CornerRadius = UDim.new(0, 8)

-- ✅ Auto Button: Randomize until rare (or timeout)
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(0.9, 0, 0, 30)
autoBtn.Position = UDim2.new(0.05, 0, 0, 100)
autoBtn.Text = "Auto Until Rare"
autoBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
autoBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextScaled = true
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, 8)

-- ✅ Anti-spam toggle
local canClick = true

-- ✅ Manual randomize logic
randomBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    statusLabel.Text = "Randomizing..."
    randomizeEggs()
    task.wait(2)
    statusLabel.Text = ""
    canClick = true
end)

-- ✅ Auto randomize until rare (max 20s, then force)
autoBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    statusLabel.Text = "Searching for rare pet..."
    local found = false
    local startTime = tick()

    local function isRareFound()
        for _, gui in pairs(espList) do
            local label = gui:FindFirstChildOfClass("TextLabel")
            local model = gui.Parent
            if model and label and eggToPets[model.Name] then
                local rare = eggToPets[model.Name][#eggToPets[model.Name]]
                if label.Text == rare then return true, rare end
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
                statusLabel.Text = "✅ Got: " .. pet
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
            statusLabel.Text = "✅ Forced: " .. (pet or "Rare Pet")
        end
        task.wait(3)
        statusLabel.Text = ""
        canClick = true
    end)
end)
