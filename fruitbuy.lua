-- 🎯 FRUIT DEALER RANDOM HACK
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

-- 🔍 البحث عن Fruit Dealer الحقيقي
local function findFruitDealer()
    local dealers = {}
    
    print("🔍 يبحث عن Fruit Dealer في Workspace...")
    
    -- ابحث في Workspace عن Dealer NPC
    for _, npc in pairs(game:GetService("Workspace"):GetDescendants()) do
        if npc:IsA("Model") then
            local npcName = npc.Name:lower()
            
            if npcName:find("dealer") or 
               npcName:find("fruit") and npcName:find("seller") or
               npcName:find("merchant") then
                
                -- تجميع معلومات Dealer
                local dealerInfo = {
                    model = npc,
                    name = npc.Name,
                    position = npc.PrimaryPart and npc.PrimaryPart.Position,
                    humanoid = npc:FindFirstChild("Humanoid")
                }
                
                -- ابحث عن ProximityPrompt
                for _, prompt in pairs(npc:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        dealerInfo.prompt = prompt
                        dealerInfo.promptText = prompt.ActionText
                    end
                end
                
                table.insert(dealers, dealerInfo)
            end
        end
    end
    
    return dealers
end

-- ⚡ اختراق Fruit Dealer
local function hackFruitDealer(dealerName)
    -- Payloads مختلفة لـ Dealer
    local dealerPayloads = {
        -- 1. مع Dealer ID
        {
            dealer = dealerName,
            action = "buy_random_fruit",
            player = player.Name,
            price = 0,
            free = true
        },
        
        -- 2. مع Fruit Type
        {
            type = "random_fruit",
            dealerId = dealerName,
            buyerId = player.UserId,
            cost = 0,
            bypass = true
        },
        
        -- 3. بسيط
        {buy = "random_fruit", dealer = dealerName},
        
        -- 4. مع بيانات كاملة
        {
            transaction = {
                type = "fruit_purchase",
                dealer = dealerName,
                fruit = "random",
                price = 0,
                buyer = player.Name,
                timestamp = os.time()
            }
        }
    }
    
    -- جرب كل RemoteEvent ممكن
    local remotesToTry = {
        game:GetService("ReplicatedStorage"):FindFirstChild("Modules") 
            and game:GetService("ReplicatedStorage").Modules.Net.RE.ShopNetwork,
        game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") 
            and game:GetService("ReplicatedStorage").Remotes.SalesEvent,
        game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") 
            and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("FruitPurchase")
    }
    
    -- جرب كل Remote مع كل Payload
    for _, remote in pairs(remotesToTry) do
        if remote and remote:IsA("RemoteEvent") then
            for i, payload in ipairs(dealerPayloads) do
                local success, result = pcall(function()
                    remote:FireServer(payload)
                    return "✅ أرسلت إلى " .. remote.Name
                end)
                
                if success then
                    return true, "🎉 اخترقنا Dealer! - " .. result
                end
            end
        end
    end
    
    return false, "❌ مافيش RemoteEvent ينفع مع Dealer"
end

-- 📱 واجهة الموبايل
local function createDealerUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FruitDealerHack"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.9, 0, 0.45, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.27, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🍎 FRUIT DEALER HACK"
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- زر البحث عن Dealers
    local findBtn = Instance.new("TextButton")
    findBtn.Text = "🔍 ابحث عن Fruit Dealer"
    findBtn.Size = UDim2.new(0.85, 0, 0.15, 0)
    findBtn.Position = UDim2.new(0.075, 0, 0.2, 0)
    findBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    findBtn.TextColor3 = Color3.new(1, 1, 1)
    findBtn.Font = Enum.Font.SourceSansBold
    
    -- قائمة Dealers
    local dealersList = Instance.new("TextLabel")
    dealersList.Text = "لم يتم البحث بعد"
    dealersList.Size = UDim2.new(0.85, 0, 0.35, 0)
    dealersList.Position = UDim2.new(0.075, 0, 0.4, 0)
    dealersList.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    dealersList.TextColor3 = Color3.new(1, 1, 1)
    dealersList.TextWrapped = true
    
    -- زر الاختراق
    local hackBtn = Instance.new("TextButton")
    hackBtn.Text = "⚡ اخترق Dealer الحالي"
    hackBtn.Size = UDim2.new(0.85, 0, 0.15, 0)
    hackBtn.Position = UDim2.new(0.075, 0, 0.8, 0)
    hackBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    hackBtn.TextColor3 = Color3.new(1, 1, 1)
    hackBtn.Font = Enum.Font.SourceSansBold
    hackBtn.Visible = false
    
    -- المتغيرات
    local currentDealers = {}
    local selectedDealer = nil
    
    -- حدث البحث
    findBtn.MouseButton1Click:Connect(function()
        findBtn.Text = "⏳ جاري البحث..."
        dealersList.Text = "🔍 يبحث عن Fruit Dealers..."
        
        task.spawn(function()
            currentDealers = findFruitDealer()
            
            if #currentDealers == 0 then
                dealersList.Text = "❌ مافيش Fruit Dealer\n\n" ..
                                  "تأكد أنك:\n" ..
                                  "1. في منطقة بها Dealer\n" ..
                                  "2. قريب من Dealer\n" ..
                                  "3. أعد المحاولة"
                hackBtn.Visible = false
            else
                local dealerText = "✅ وجد " .. #currentDealers .. " Dealer:\n\n"
                
                for i, dealer in ipairs(currentDealers) do
                    dealerText = dealerText .. i .. ". " .. dealer.name .. "\n"
                    if dealer.promptText then
                        dealerText = dealerText .. "   📝: " .. dealer.promptText .. "\n"
                    end
                end
                
                dealersList.Text = dealerText
                hackBtn.Visible = true
                selectedDealer = currentDealers[1]
            end
            
            findBtn.Text = "🔍 ابحث عن Fruit Dealer"
        end)
    end)
    
    -- حدث الاختراق
    hackBtn.MouseButton1Click:Connect(function()
        if not selectedDealer then return end
        
        hackBtn.Text = "💥 يخترق..."
        dealersList.Text = "⚡ جاري اختراق: " .. selectedDealer.name
        
        task.spawn(function()
            local success, message = hackFruitDealer(selectedDealer.name)
            
            if success then
                dealersList.Text = message
                dealersList.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
            else
                dealersList.Text = message
                dealersList.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            end
            
            hackBtn.Text = "⚡ اخترق Dealer الحالي"
        end)
    end)
    
    -- التجميع
    title.Parent = mainFrame
    findBtn.Parent = mainFrame
    dealersList.Parent = mainFrame
    hackBtn.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- أوامر الكونسول
_G.FindDealers = function()
    return findFruitDealer()
end

_G.HackDealer = function(dealerName)
    if not dealerName then
        local dealers = findFruitDealer()
        if #dealers == 0 then return "❌ مافيش Dealers" end
        
        print("🎯 Dealers المتاحة:")
        for i, dealer in ipairs(dealers) do
            print(i .. ". " .. dealer.name)
        end
        return "أدخل اسم Dealer"
    end
    
    return hackFruitDealer(dealerName)
end

_G.AutoHackDealers = function()
    local dealers = findFruitDealer()
    if #dealers == 0 then return "❌ مافيش Dealers" end
    
    for i, dealer in ipairs(dealers) do
        print("🎯 [" .. i .. "] يخترق: " .. dealer.name)
        hackFruitDealer(dealer.name)
        task.wait(0.5)
    end
    
    return "جربت اختراق " .. #dealers .. " Dealer"
end

-- بدء التشغيل
print([[
    
🍎 FRUIT DEALER HACK
🎯 اختراق Fruit Dealer العشوائي في Blox Fruits

🔍 Dealer هو:
• NPC يبيع فواكه عشوائية
• موجود في الجزر المختلفة
• سعره من 50k إلى 100k Beli

⚡ الأوامر:
_G.FindDealers() - البحث عن Dealers
_G.HackDealer("اسم_Dealer") - اختراق Dealer
_G.AutoHackDealers() - اختراق كل Dealers

]])

-- إنشاء الواجهة
createDealerUI()

print("✅ Fruit Dealer Hack جاهز!")
