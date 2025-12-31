-- 🎯 BLOX FRUITS EXPLOITER - Mobile Version
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer

-- 🔧 أنظمة Blox Fruits
local BloxSystems = {
    -- Shop System
    shopNetwork = game:GetService("ReplicatedStorage"):FindFirstChild("Modules") 
        and game:GetService("ReplicatedStorage").Modules.Net.RE.ShopNetwork,
    
    -- Sales System  
    salesEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") 
        and game:GetService("ReplicatedStorage").Remotes.SalesEvent,
    
    -- Purchase Systems
    purchaseSubclass = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") 
        and game:GetService("ReplicatedStorage").Remotes.SubclassNetwork.PurchaseSubclass,
    
    purchasePassive = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") 
        and game:GetService("ReplicatedStorage").Remotes.SubclassNetwork.PurchasePassive,
    
    -- Shop Requests
    shopRequest = game:GetService("ReplicatedStorage"):FindFirstChild("Modules") 
        and game:GetService("ReplicatedStorage").Modules.Net.RF.ShopNetworkRequest
}

-- 🎯 المنتجات في Blox Fruits
local BloxProducts = {
    fruits = {
        "Bomb-Bomb",
        "Spike-Spike", 
        "Chop-Chop",
        "Spring-Spring",
        "Kilo-Kilo",
        "Spin-Spin"
    },
    
    gamepasses = {
        "2xMoney",
        "2xMastery", 
        "2xBeli",
        "FruitNotifier",
        "Inventory+"
    },
    
    subclasses = {
        "BlackLeg",
        "Electro",
        "FishmanKarate",
        "DragonBreath"
    },
    
    swords = {
        "Katana",
        "Cutlass",
        "Dual Katana",
        "Triple Katana"
    }
}

-- ⚡ استغلال ShopNetwork
local function exploitShop(product, price)
    price = price or 0
    
    if not BloxSystems.shopNetwork then
        return false, "❌ ShopNetwork مش موجود"
    end
    
    -- Payloads مختلفة
    local payloads = {
        {item = product, price = price, player = player},
        {product = product, cost = price, buyer = player.Name},
        {name = product, value = price, purchase = true},
        {id = product, amount = 1, currency = "Beli", price = price}
    }
    
    for i, payload in ipairs(payloads) do
        local success, result = pcall(function()
            BloxSystems.shopNetwork:FireServer(payload)
            return "✅ أرسلت"
        end)
        
        if success then
            return true, "✅ نجح Payload " .. i .. " - " .. product
        end
        
        task.wait(0.1)
    end
    
    return false, "❌ فشل كل الطرق"
end

-- ⚡ استغلال PurchaseSubclass
local function exploitSubclass(subclassName)
    if not BloxSystems.purchaseSubclass then
        return false, "❌ PurchaseSubclass مش موجود"
    end
    
    local success, result = pcall(function()
        return BloxSystems.purchaseSubclass:InvokeServer(subclassName)
    end)
    
    if success then
        return true, "✅ اشترينا Subclass: " .. subclassName
    else
        return false, "❌ فشل شراء Subclass"
    end
end

-- 📱 واجهة موبايل بسيطة
local function createMobileUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BloxExploiter"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🎯 BLOX FRUITS EXPLOITER"
    title.Size = UDim2.new(1, 0, 0.12, 0)
    title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- حقل المنتج
    local productBox = Instance.new("TextBox")
    productBox.PlaceholderText = "اسم المنتج (مثال: Bomb-Bomb)"
    productBox.Size = UDim2.new(0.85, 0, 0.12, 0)
    productBox.Position = UDim2.new(0.075, 0, 0.15, 0)
    productBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    productBox.TextColor3 = Color3.new(1, 1, 1)
    
    -- زر الفواكه
    local fruitsBtn = Instance.new("TextButton")
    fruitsBtn.Text = "🍎 فواكه"
    fruitsBtn.Size = UDim2.new(0.4, 0, 0.1, 0)
    fruitsBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
    fruitsBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    fruitsBtn.TextColor3 = Color3.new(1, 1, 1)
    
    -- زر Subclasses
    local subclassBtn = Instance.new("TextButton")
    subclassBtn.Text = "🥋 Subclasses"
    subclassBtn.Size = UDim2.new(0.4, 0, 0.1, 0)
    subclassBtn.Position = UDim2.new(0.525, 0, 0.3, 0)
    subclassBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 150)
    subclassBtn.TextColor3 = Color3.new(1, 1, 1)
    
    -- زر الاستغلال
    local exploitBtn = Instance.new("TextButton")
    exploitBtn.Text = "⚡ استغل الآن (سعر 0)"
    exploitBtn.Size = UDim2.new(0.85, 0, 0.15, 0)
    exploitBtn.Position = UDim2.new(0.075, 0, 0.45, 0)
    exploitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    exploitBtn.TextColor3 = Color3.new(1, 1, 1)
    exploitBtn.Font = Enum.Font.SourceSansBold
    
    -- النتائج
    local resultLabel = Instance.new("TextLabel")
    resultLabel.Text = "اختر منتج واضغط ⚡"
    resultLabel.Size = UDim2.new(0.85, 0, 0.25, 0)
    resultLabel.Position = UDim2.new(0.075, 0, 0.65, 0)
    resultLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    resultLabel.TextColor3 = Color3.new(1, 1, 1)
    resultLabel.TextWrapped = true
    
    -- حدث زر الفواكه
    fruitsBtn.MouseButton1Click:Connect(function()
        productBox.Text = "Bomb-Bomb"
        resultLabel.Text = "🍎 جرب Bomb-Bomb أولاً"
    end)
    
    -- حدث زر Subclasses
    subclassBtn.MouseButton1Click:Connect(function()
        productBox.Text = "BlackLeg"
        resultLabel.Text = "🥋 جرب BlackLeg Subclass"
    end)
    
    -- حدث الاستغلال
    exploitBtn.MouseButton1Click:Connect(function()
        local product = productBox.Text
        if product == "" then return end
        
        exploitBtn.Text = "⏳"
        resultLabel.Text = "جاري: " .. product
        
        task.spawn(function()
            -- إذا كان Subclass
            local isSubclass = false
            for _, subclass in ipairs(BloxProducts.subclasses) do
                if product:find(subclass) then
                    isSubclass = true
                    break
                end
            end
            
            local success, message
            if isSubclass then
                success, message = exploitSubclass(product)
            else
                success, message = exploitShop(product, 0)
            end
            
            if success then
                resultLabel.Text = message
                resultLabel.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
                print("\n🎉 " .. message)
            else
                resultLabel.Text = message
                resultLabel.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            end
            
            exploitBtn.Text = "⚡ استغل الآن (سعر 0)"
        end)
    end)
    
    -- التجميع
    title.Parent = mainFrame
    productBox.Parent = mainFrame
    fruitsBtn.Parent = mainFrame
    subclassBtn.Parent = mainFrame
    exploitBtn.Parent = mainFrame
    resultLabel.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- أوامر الكونسول
_G.BuyFruit = function(fruitName)
    if not fruitName then
        print("🍎 الفواكه المتاحة:")
        for i, fruit in ipairs(BloxProducts.fruits) do
            print(i .. ". " .. fruit)
        end
        return "اختر فاكهة"
    end
    
    return exploitShop(fruitName, 0)
end

_G.BuySubclass = function(subclassName)
    if not subclassName then
        print("🥋 Subclasses المتاحة:")
        for i, subclass in ipairs(BloxProducts.subclasses) do
            print(i .. ". " .. subclass)
        end
        return "اختر Subclass"
    end
    
    return exploitSubclass(subclassName)
end

_G.TestAll = function()
    print("🎯 جرب كل الأنظمة...")
    
    -- جرب فاكهة
    exploitShop("Bomb-Bomb", 0)
    task.wait(0.5)
    
    -- جرب Subclass
    exploitSubclass("BlackLeg")
    task.wait(0.5)
    
    -- جرب Sword
    exploitShop("Katana", 0)
    
    return "تم اختبار 3 منتجات"
end

-- بدء التشغيل
print([[
    
🎯 BLOX FRUITS EXPLOITER
⚡ نظام Shop Network في Blox Fruits

🎯 الأنظمة المكتشفة:
1. ShopNetwork - المتجر الرئيسي
2. PurchaseSubclass - شراء Subclasses
3. PurchasePassive - شراء Passives
4. SalesEvent - عروض التخفيضات

🍎 أمثلة:
• Bomb-Bomb, Spike-Spike, Chop-Chop
• BlackLeg, Electro, FishmanKarate  
• Katana, Cutlass, Dual Katana

⚡ الأوامر:
_G.BuyFruit("Bomb-Bomb")
_G.BuySubclass("BlackLeg")
_G.TestAll()

]])

-- إنشاء الواجهة
createMobileUI()

print("✅ Blox Fruits Exploiter جاهز!")
