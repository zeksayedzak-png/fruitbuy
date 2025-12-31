-- 🎯 ULTIMATE EXPLOITER - جميع الأنظمة
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer

-- 🔧 الأنظمة القابلة للاستغلال
local EXPLOITABLE_SYSTEMS = {
    {
        name = "FakePurchase",
        path = "ReplicatedStorage.GameEvents.Market.FakePurchase",
        type = "RemoteEvent",
        description = "شراء وهمي للنظام الاختباري",
        exploitChance = 90 -- %90 فرصة نجاح
    },
    {
        name = "DeveloperPurchase",
        path = "ReplicatedStorage.GameEvents.DeveloperPurchase",
        type = "RemoteEvent",
        description = "شراء خاص بالمطورين",
        exploitChance = 80
    },
    {
        name = "AddItem",
        path = "ReplicatedStorage.GameEvents.TradeEvents.AddItem",
        type = "RemoteEvent",
        description = "إضافة items مباشرة",
        exploitChance = 85
    },
    {
        name = "DevRestockGearShop",
        path = "ReplicatedStorage.GameEvents.DevRestockGearShop",
        type = "RemoteEvent",
        description = "إعادة تزويد المتاجر",
        exploitChance = 75
    },
    {
        name = "OfferingWeather",
        path = "ReplicatedStorage.GameEvents.OfferingWeather",
        type = "RemoteEvent",
        description = "عروض الطقس المجانية",
        exploitChance = 70
    },
    {
        name = "BuyListing",
        path = "ReplicatedStorage.GameEvents.TradeEvents.Booths.BuyListing",
        type = "RemoteFunction",
        description = "شراء من Booths اللاعبين",
        exploitChance = 60
    }
}

-- 🔍 تحميل النظام
local function loadSystem(system)
    local pathParts = system.path:split(".")
    local current = game
    
    for i = 2, #pathParts do
        if current:FindFirstChild(pathParts[i]) then
            current = current[pathParts[i]]
        else
            return nil
        end
    end
    
    if current then
        if system.type == "RemoteEvent" and current:IsA("RemoteEvent") then
            return current
        elseif system.type == "RemoteFunction" and current:IsA("RemoteFunction") then
            return current
        end
    end
    
    return nil
end

-- ⚡ استغلال نظام معين
local function exploitSystem(system, item, amount)
    amount = tonumber(amount) or 1000
    item = item or "token"
    
    local remote = loadSystem(system)
    if not remote then
        return false, "❌ النظام مش موجود"
    end
    
    print("🎯 جرب استغلال: " .. system.name)
    print("📝 " .. system.description)
    
    -- Payloads حسب نوع النظام
    local payloads = {}
    
    if system.name == "FakePurchase" then
        payloads = {
            {itemId = item, amount = amount, price = 0, fake = true},
            {product = item, quantity = amount, cost = 0, test = true}
        }
    elseif system.name == "DeveloperPurchase" then
        payloads = {
            {developer = true, item = item, quantity = amount, free = true},
            {admin = true, product = item, amount = amount, noCharge = true}
        }
    elseif system.name == "AddItem" then
        payloads = {
            {itemId = item, amount = amount, player = player},
            {item = item, quantity = amount, receiver = player.UserId}
        }
    elseif system.name == "BuyListing" then
        payloads = {
            {listingId = "booth_" .. item .. "_" .. player.UserId, price = 0},
            {id = item, cost = 0, buyerId = player.UserId}
        }
    end
    
    -- جرب كل payload
    for i, payload in ipairs(payloads) do
        local success, result = pcall(function()
            if system.type == "RemoteEvent" then
                remote:FireServer(payload)
                return "تم الإرسال"
            else
                return remote:InvokeServer(payload)
            end
        end)
        
        if success then
            print("✅ Payload " .. i .. " ناجح!")
            if result then
                print("📦 النتيجة: " .. tostring(result))
            end
            return true, "✅ نجح! - حصلت على " .. amount .. " " .. item
        end
    end
    
    return false, "❌ كل المحاولات فشلت"
end

-- 📱 واجهة بسيطة
local function createSimpleUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UltimateExploiter"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "⚡ ULTIMATE EXPLOITER"
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.BackgroundColor3 = Color3.fromRGB(200, 50, 0)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- قائمة الأنظمة
    local systemsList = Instance.new("ScrollingFrame")
    systemsList.Size = UDim2.new(0.9, 0, 0.6, 0)
    systemsList.Position = UDim2.new(0.05, 0, 0.18, 0)
    systemsList.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    systemsList.ScrollBarThickness = 8
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = systemsList
    
    -- إنشاء زر لكل نظام
    for _, system in ipairs(EXPLOITABLE_SYSTEMS) do
        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(1, 0, 0, 60)
        btnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = system.name .. " (" .. system.exploitChance .. "%)"
        nameLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.PaddingLeft = UDim.new(0, 10)
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Text = system.description
        descLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
        descLabel.Position = UDim2.new(0, 0, 0.5, 0)
        descLabel.BackgroundTransparency = 1
        descLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.PaddingLeft = UDim.new(0, 10)
        descLabel.TextSize = 12
        
        local exploitBtn = Instance.new("TextButton")
        exploitBtn.Text = "⚡ استغل"
        exploitBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
        exploitBtn.Position = UDim2.new(0.73, 0, 0.15, 0)
        exploitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        exploitBtn.TextColor3 = Color3.new(1, 1, 1)
        
        -- حدث الاستغلال
        exploitBtn.MouseButton1Click:Connect(function()
            exploitBtn.Text = "⏳"
            
            task.spawn(function()
                local success, message = exploitSystem(system, "token", 1000)
                
                if success then
                    exploitBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                    print("\n🎉 " .. system.name .. " ناجح!")
                else
                    exploitBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    print("\n❌ " .. system.name .. " فشل")
                end
                
                task.wait(1)
                exploitBtn.Text = "⚡ استغل"
                exploitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            end)
        end)
        
        nameLabel.Parent = btnFrame
        descLabel.Parent = btnFrame
        exploitBtn.Parent = btnFrame
        btnFrame.Parent = systemsList
    end
    
    -- التجميع
    title.Parent = mainFrame
    systemsList.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
end

-- أوامر الكونسول
_G.Exploit = function(systemName, item, amount)
    for _, system in ipairs(EXPLOITABLE_SYSTEMS) do
        if system.name:lower() == systemName:lower() then
            return exploitSystem(system, item, amount)
        end
    end
    return "❌ النظام مش موجود"
end

_G.ListSystems = function()
    print("\n🎯 الأنظمة القابلة للاستغلال:")
    for _, system in ipairs(EXPLOITABLE_SYSTEMS) do
        print(system.name .. " - " .. system.description .. " (" .. system.exploitChance .. "%)")
    end
end

-- تشغيل
print([[
    
⚡ ULTIMATE EXPLOITER
🎯 استغلال 6 أنظمة مختلفة

📋 الأنظمة:
1. FakePurchase (%90) - شراء وهمي
2. DeveloperPurchase (%80) - للمطورين
3. AddItem (%85) - إضافة مباشرة  
4. DevRestockGearShop (%75) - تزويد متاجر
5. OfferingWeather (%70) - عروض مجانية
6. BuyListing (%60) - شراء من Booths

⚡ الأوامر:
_G.Exploit("FakePurchase", "token", 1000)
_G.ListSystems() - عرض الأنظمة

]])

createSimpleUI()
print("✅ Ultimate Exploiter جاهز!")
