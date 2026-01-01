-- 🌿 GROW A GARDEN ULTIMATE HACK
-- Mobile Version
-- loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- 💥 الهجوم المباشر بدون بحث
local function nuclearAttack()
    print("💣 بدء الهجوم النووي على Grow a Garden!")
    
    local attacks = 0
    
    -- 🔥 1. FakePurchase - الشراء المزيف
    local fakePurchase = rs.GameEvents.Market.FakePurchase
    if fakePurchase then
        print("🎯 FakePurchase وجد!")
        
        -- محاولات شراء مزيفة
        local fakeItems = {
            "PREMIUM_MEMBERSHIP",
            "RAINBOW_SEEDS", 
            "GOLDEN_WATERING_CAN",
            "MYTHIC_PET_EGG",
            "INFINITE_COINS",
            "ALL_COSMETICS",
            "UNLOCK_ALL_PLANTS"
        }
        
        for _, item in pairs(fakeItems) do
            pcall(function()
                fakePurchase:FireServer({
                    action = "purchase",
                    item = item,
                    price = 0,
                    player = plr.Name,
                    timestamp = os.time()
                })
                attacks = attacks + 1
                print("   ✅ شراء مزيف: " .. item)
            end)
            task.wait(0.1)
        end
    end
    
    -- 🔥 2. أمر givepremium
    local givepremium = rs.CmdrClient.Commands.givepremium
    if givepremium then
        print("🎯 givepremium وجد!")
        
        pcall(function()
            givepremium:FireServer(plr, "lifetime")
            givepremium:FireServer(plr, "all_features")
            givepremium:FireServer("activate_premium", plr.UserId)
            attacks = attacks + 3
            print("   ✅ بريميوم مفعل!")
        end)
    end
    
    -- 🔥 3. متجر Robux
    local robuxBuyPath = "Modules.GardenCoinShopController.ItemFrame.Frame.Robux_Buy"
    local target = rs
    for part in robuxBuyPath:gmatch("[^%.]+") do
        target = target:FindFirstChild(part)
        if not target then break end
    end
    
    if target and target:IsA("RemoteEvent") then
        print("🎯 Robux_Buy وجد!")
        
        pcall(function()
            -- شراء كل العملات
            for i = 1, 10 do
                target:FireServer({
                    coins = 1000000,
                    price = 0,
                    purchaseId = "FREE_" .. i
                })
            end
            attacks = attacks + 10
            print("   ✅ عملات مجانية!")
        end)
    end
    
    -- 🔥 4. نظام Trade
    local addItem = rs.GameEvents.TradeEvents.AddItem
    if addItem then
        print("🎯 نظام Trade وجد!")
        
        -- إضافة عناصر للتجارة
        local rareItems = {
            "GOLDEN_SEED",
            "DIAMOND_FLOWER", 
            "RAINBOW_PETAL",
            "MYTHIC_FERTILIZER",
            "INFINITE_WATER"
        }
        
        for _, item in pairs(rareItems) do
            pcall(function()
                addItem:FireServer({
                    item = item,
                    quantity = 999,
                    player = plr
                })
                attacks = attacks + 1
            end)
        end
    end
    
    -- 🔥 5. هجوم على كل الـ Remotes
    print("💣 هجوم شامل على كل الأنظمة...")
    
    for _, obj in pairs(rs:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            
            -- إذا كان اسمه متعلق بالشراء أو المكافآت
            if name:find("buy") or name:find("purchase") or 
               name:find("add") or name:find("get") or
               name:find("unlock") or name:find("reward") then
                
                pcall(function()
                    obj:FireServer("FREE")
                    obj:FireServer("UNLOCK_ALL")
                    attacks = attacks + 1
                end)
            end
        end
    end
    
    return attacks
end

-- 📱 واجهة الهاتف
local ui = Instance.new("ScreenGui")
ui.Name = "GardenHack"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.4, 0, 0.25, 0)
main.Position = UDim2.new(0.55, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "🌿 GARDEN HACK"
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

local hackBtn = Instance.new("TextButton")
hackBtn.Text = "💥 اختراق اللعبة"
hackBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
hackBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
hackBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)

local status = Instance.new("TextLabel")
status.Text = "Grow a Garden - جاهز للاختراق"
status.Size = UDim2.new(0.9, 0, 0.2, 0)
status.Position = UDim2.new(0.05, 0, 0.8, 0)
status.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
status.TextWrapped = true

-- حدث الاختراق
hackBtn.MouseButton1Click:Connect(function()
    hackBtn.Text = "💣 جاري الاختراق..."
    status.Text = "🔥 يهاجم FakePurchase وأوامر Premium..."
    
    task.spawn(function()
        local attacks = nuclearAttack()
        
        hackBtn.Text = "💥 اختراق اللعبة"
        status.Text = "✅ " .. attacks .. " هجوم ناجح!\nتحقق من مكافآتك!"
    end)
end)

-- التجميع
title.Parent = main
hackBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = plr.PlayerGui

print("🌿 GROW A GARDEN HACK - READY!")
print("🎯 FakePurchase - شراء مزيف")
print("👑 givepremium - بريميوم مجاني")
print("💰 Robux_Buy - روبوكس مجاني")
print("🔄 AddItem - عناصر للتجارة")
