-- Blox Fruits Fruit Purchaser
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer

-- Fruit Purchase Systems
local FRUIT_SYSTEMS = {
    {
        name = "Tiger Fruit",
        remotePath = "ReplicatedStorage.Modules.Net.RE.OnPermanentTigerPurchase",
        type = "RemoteEvent",
        itemId = "TigerFruit"
    },
    {
        name = "Kitsune Fruit", 
        remotePath = "ReplicatedStorage.Modules.Net.RE.OnPermanentKitsunePurchase",
        type = "RemoteEvent",
        itemId = "KitsuneFruit"
    }
}

-- Check if system exists
local function checkSystem(system)
    local pathParts = system.remotePath:split(".")
    local current = game
    
    for i = 2, #pathParts do
        if current:FindFirstChild(pathParts[i]) then
            current = current[pathParts[i]]
        else
            return false, "Path part missing: " .. pathParts[i]
        end
    end
    
    if current and ((system.type == "RemoteEvent" and current:IsA("RemoteEvent")) or 
                   (system.type == "RemoteFunction" and current:IsA("RemoteFunction"))) then
        return true, current
    end
    
    return false, "System not found or incorrect type"
end

-- Purchase function
local function purchaseFruit(system)
    local exists, remote = checkSystem(system)
    if not exists then
        return false, remote
    end
    
    -- Purchase payloads
    local payloads = {
        {
            permanent = true,
            price = 0,
            player = player,
            timestamp = os.time()
        },
        {
            fruit = system.itemId,
            cost = 0,
            buyer = player.Name,
            transactionId = "purchase_" .. system.itemId .. "_" .. os.time()
        },
        {
            item = system.itemId,
            amount = 1,
            currency = "FREE",
            source = "DirectPurchase"
        }
    }
    
    -- Try each payload
    for i, payload in ipairs(payloads) do
        local success, result = pcall(function()
            if system.type == "RemoteEvent" then
                remote:FireServer(payload)
                return "Event fired successfully"
            else
                return remote:InvokeServer(payload)
            end
        end)
        
        if success then
            print("✅ Payload " .. i .. " succeeded for " .. system.name)
            return true, system.name .. " purchase successful"
        else
            print("❌ Payload " .. i .. " failed for " .. system.name)
        end
        
        task.wait(0.2)
    end
    
    return false, "All purchase attempts failed"
end

-- Create mobile interface
local function createMobileInterface()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FruitPurchaser"
    screenGui.ResetOnSpawn = false
    
    -- Main frame (movable)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.85, 0, 0.3, 0)
    mainFrame.Position = UDim2.new(0.075, 0, 0.35, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "🍇 Fruit Purchaser"
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    
    -- Tiger Fruit button
    local tigerBtn = Instance.new("TextButton")
    tigerBtn.Name = "TigerButton"
    tigerBtn.Text = "🐯 Tiger Fruit"
    tigerBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
    tigerBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
    tigerBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    tigerBtn.TextColor3 = Color3.new(1, 1, 1)
    tigerBtn.Font = Enum.Font.SourceSansBold
    tigerBtn.TextSize = 16
    
    -- Kitsune Fruit button
    local kitsuneBtn = Instance.new("TextButton")
    kitsuneBtn.Name = "KitsuneButton"
    kitsuneBtn.Text = "🦊 Kitsune Fruit"
    kitsuneBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
    kitsuneBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
    kitsuneBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
    kitsuneBtn.TextColor3 = Color3.new(1, 1, 1)
    kitsuneBtn.Font = Enum.Font.SourceSansBold
    kitsuneBtn.TextSize = 16
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = "Select a fruit to purchase"
    statusLabel.Size = UDim2.new(1, 0, 0.2, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.85, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.TextWrapped = true
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 14
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0.1, 0, 0.2, 0)
    closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.SourceSansBold
    
    -- Button events
    tigerBtn.MouseButton1Click:Connect(function()
        tigerBtn.Text = "⏳ Purchasing..."
        statusLabel.Text = "Purchasing Tiger Fruit..."
        
        task.spawn(function()
            local success, message = purchaseFruit(FRUIT_SYSTEMS[1])
            
            if success then
                statusLabel.Text = "✅ " .. message
                statusLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                tigerBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            else
                statusLabel.Text = "❌ " .. message
                statusLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
                tigerBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            end
            
            tigerBtn.Text = "🐯 Tiger Fruit"
            
            -- Reset button color after 2 seconds
            task.wait(2)
            tigerBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        end)
    end)
    
    kitsuneBtn.MouseButton1Click:Connect(function()
        kitsuneBtn.Text = "⏳ Purchasing..."
        statusLabel.Text = "Purchasing Kitsune Fruit..."
        
        task.spawn(function()
            local success, message = purchaseFruit(FRUIT_SYSTEMS[2])
            
            if success then
                statusLabel.Text = "✅ " .. message
                statusLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                kitsuneBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            else
                statusLabel.Text = "❌ " .. message
                statusLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
                kitsuneBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            end
            
            kitsuneBtn.Text = "🦊 Kitsune Fruit"
            
            -- Reset button color after 2 seconds
            task.wait(2)
            kitsuneBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
        end)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Make frame draggable
    local dragging = false
    local dragStart, startPos
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Assemble UI
    title.Parent = mainFrame
    tigerBtn.Parent = mainFrame
    kitsuneBtn.Parent = mainFrame
    statusLabel.Parent = mainFrame
    closeBtn.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- Console commands
_G.PurchaseTiger = function()
    return purchaseFruit(FRUIT_SYSTEMS[1])
end

_G.PurchaseKitsune = function()
    return purchaseFruit(FRUIT_SYSTEMS[2])
end

-- Check systems on startup
task.spawn(function()
    task.wait(1)
    print("\n🔍 Checking fruit purchase systems...")
    
    for _, system in ipairs(FRUIT_SYSTEMS) do
        local exists, _ = checkSystem(system)
        if exists then
            print("✅ " .. system.name .. " system found")
        else
            print("❌ " .. system.name .. " system not found")
        end
    end
end)

-- Create interface
createMobileInterface()

print([[
    
🍇 Blox Fruits Fruit Purchaser
🎯 Purchase Tiger and Kitsune Fruits

Features:
• 🐯 Tiger Fruit purchase
• 🦊 Kitsune Fruit purchase
• 📱 Mobile-optimized interface
• 🎯 Direct system access

Console Commands:
_G.PurchaseTiger() - Purchase Tiger Fruit
_G.PurchaseKitsune() - Purchase Kitsune Fruit

Interface:
• Frame is movable (drag anywhere)
• Green = Success, Red = Failed
• Status updates in real-time

]])

print("✅ Fruit Purchaser ready")
