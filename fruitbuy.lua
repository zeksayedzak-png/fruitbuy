-- 🎯 BLOX FRUITS DEALER HACK
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer
local dealerRemote = game:GetService("ReplicatedStorage").Modules.Net.RE.ShopNetwork

-- 📋 الفواكه المتاحة في Blox Fruits
local FRUITS = {
    "Bomb-Bomb",
    "Spike-Spike", 
    "Chop-Chop",
    "Spring-Spring",
    "Kilo-Kilo",
    "Spin-Spin",
    "Dark-Dark",
    "Diamond-Diamond",
    "Flame-Flame",
    "Ice-Ice",
    "Sand-Sand",
    "Light-Light",
    "Rubber-Rubber",
    "Barrier-Barrier",
    "Ghost-Ghost",
    "Magma-Magma",
    "Quake-Quake",
    "String-String",
    "Portal-Portal"
}

-- ⚡ اختراق Dealer مباشر
local function hackDealer(fruitName, price)
    price = price or 0
    
    -- Payloads خاصة للاختراق
    local hackPayloads = {
        -- Payload 1: مع force buy
        {
            name = fruitName,
            cost = price,
            player = player.Name,
            forceBuy = true,
            bypass = true,
            serverSide = false
        },
        
        -- Payload 2: كـ admin
        {
            fruit = fruitName,
            price = price,
            buyerId = player.UserId,
            admin = true,
            ignoreRequirements = true
        },
        
        -- Payload 3: بسيط جداً
        {name = fruitName, price = price},
        
        -- Payload 4: مع timestamp
        {
            item = fruitName,
            amount = 1,
            currency = "Beli",
            price = price,
            timestamp = os.time(),
            _bypass = "true"
        }
    }
    
    -- جرب كل payload
    for i, payload in ipairs(hackPayloads) do
        print("🎯 جرب Payload " .. i .. " مع " .. fruitName)
        
        local success, result = pcall(function()
            dealerRemote:FireServer(payload)
            return "✅ أرسلت"
        end)
        
        if success then
            print("🎉 نجح Payload " .. i .. "!")
            return true, "✅ اشتريت " .. fruitName .. " مجاناً!"
        end
        
        task.wait(0.1) -- تأخير بسيط
    end
    
    return false, "❌ كل الطرق فشلت"
end

-- 📱 واجهة الهاتف
local function createMobileUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DealerHack"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.95, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.025, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "⚡ FRUIT DEALER HACK"
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- قائمة الفواكه
    local fruitsFrame = Instance.new("ScrollingFrame")
    fruitsFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
    fruitsFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
    fruitsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    fruitsFrame.ScrollBarThickness = 8
    fruitsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local fruitsLayout = Instance.new("UIListLayout")
    fruitsLayout.Parent = fruitsFrame
    fruitsLayout.Padding = UDim.new(0, 5)
    
    -- زر اختراق الكل
    local hackAllBtn = Instance.new("TextButton")
    hackAllBtn.Text = "💣 اختراق كل الفواكه"
    hackAllBtn.Size = UDim2.new(0.9, 0, 0.1, 0)
    hackAllBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
    hackAllBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 0)
    hackAllBtn.TextColor3 = Color3.new(1, 1, 1)
    hackAllBtn.Font = Enum.Font.SourceSansBold
    
    -- النتائج
    local resultLabel = Instance.new("TextLabel")
    resultLabel.Text = "اختر فاكهة واضغط عليها"
    resultLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
    resultLabel.Position = UDim2.new(0.05, 0, 0.78, 0)
    resultLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    resultLabel.TextColor3 = Color3.new(1, 1, 1)
    resultLabel.TextWrapped = true
    
    -- إنشاء أزرار للفواكه
    for i, fruit in ipairs(FRUITS) do
        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(1, 0, 0, 40)
        btnFrame.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(45, 45, 55)
        
        local fruitLabel = Instance.new("TextLabel")
        fruitLabel.Text = "🍎 " .. fruit
        fruitLabel.Size = UDim2.new(0.7, 0, 1, 0)
        fruitLabel.BackgroundTransparency = 1
        fruitLabel.TextColor3 = Color3.new(1, 1, 1)
        fruitLabel.TextXAlignment = Enum.TextXAlignment.Left
        fruitLabel.PaddingLeft = UDim.new(0, 10)
        
        local hackBtn = Instance.new("TextButton")
        hackBtn.Text = "⚡ اخترق"
        hackBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
        hackBtn.Position = UDim2.new(0.73, 0, 0.15, 0)
        hackBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        hackBtn.TextColor3 = Color3.new(1, 1, 1)
        
        -- حدث الاختراق
        hackBtn.MouseButton1Click:Connect(function()
            hackBtn.Text = "💥"
            resultLabel.Text = "جاري اختراق " .. fruit
            
            task.spawn(function()
                local success, message = hackDealer(fruit, 0)
                
                if success then
                    resultLabel.Text = message
                    resultLabel.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
                    hackBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                else
                    resultLabel.Text = message
                    resultLabel.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
                    hackBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                end
                
                hackBtn.Text = "⚡ اخترق"
            end)
        end)
        
        fruitLabel.Parent = btnFrame
        hackBtn.Parent = btnFrame
        btnFrame.Parent = fruitsFrame
    end
    
    -- حدث اختراق الكل
    hackAllBtn.MouseButton1Click:Connect(function()
        hackAllBtn.Text = "💥 يخترق الكل..."
        resultLabel.Text = "جاري اختراق جميع الفواكه..."
        
        task.spawn(function()
            local successCount = 0
            
            for i, fruit in ipairs(FRUITS) do
                resultLabel.Text = "💥 يخترق (" .. i .. "/" .. #FRUITS .. "): " .. fruit
                
                local success, _ = hackDealer(fruit, 0)
                if success then
                    successCount = successCount + 1
                    print("✅ اخترقنا: " .. fruit)
                end
                
                task.wait(0.3) -- تأخير بين الفواكه
            end
            
            resultLabel.Text = "📊 اخترقنا " .. successCount .. "/" .. #FRUITS .. " فواكه"
            
            if successCount > 0 then
                resultLabel.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
            else
                resultLabel.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            end
            
            hackAllBtn.Text = "💣 اختراق كل الفواكه"
        end)
    end)
    
    -- التجميع
    title.Parent = mainFrame
    fruitsFrame.Parent = mainFrame
    hackAllBtn.Parent = mainFrame
    resultLabel.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- 🔧 تحقق من Dealer
local function checkDealerSystem()
    print("\n🎯 تحقق من Fruit Dealer...")
    
    if not dealerRemote then
        print("❌ ShopNetwork مش موجود!")
        print("🔍 المسار: ReplicatedStorage.Modules.Net.RE.ShopNetwork")
        return false
    end
    
    print("✅ Dealer موجود: " .. dealerRemote.Name)
    print("🎯 جاهز للاختراق!")
    return true
end

-- أوامر الكونسول
_G.HackFruit = function(fruitName)
    if not fruitName then
        print("🍎 الفواكه المتاحة:")
        for i, fruit in ipairs(FRUITS) do
            print(i .. ". " .. fruit)
        end
        return "اختر فاكهة"
    end
    
    return hackDealer(fruitName, 0)
end

_G.HackAllFruits = function()
    local successCount = 0
    for i, fruit in ipairs(FRUITS) do
        print("🎯 [" .. i .. "] يخترق: " .. fruit)
        local success, _ = hackDealer(fruit, 0)
        if success then successCount = successCount + 1 end
        task.wait(0.2)
    end
    return "اخترقنا " .. successCount .. "/" .. #FRUITS .. " فواكه"
end

-- بدء التشغيل
print([[
    
⚡ FRUIT DEALER HACK
🎯 اختراق متجر الفواكه في Blox Fruits

🍎 الفواكه المتاحة:
1. Bomb-Bomb ← أسهل
2. Spike-Spike
3. Chop-Chop  
4. Flame-Flame
5. Ice-Ice
6. Light-Light

⚡ الأوامر:
_G.HackFruit("Bomb-Bomb")
_G.HackAllFruits()

]])

-- التحقق من النظام
if checkDealerSystem() then
    -- إنشاء الواجهة
    createMobileUI()
    print("✅ الواجهة جاهزة! جرب Bomb-Bomb أولاً!")
else
    print("❌ النظام مش موجود!")
end
