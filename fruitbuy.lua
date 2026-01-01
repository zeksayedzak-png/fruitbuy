-- 🎰 GACHA HACK SYSTEM
-- Mobile Version
-- loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- 🔍 البحث عن الغاتشا
local function findGachaSystem()
    -- كل المسارات المحتملة للغاتشا
    local gachaPaths = {
        rs.Controllers.UI.GachaWindow,
        rs.GachaSystem,
        rs.Gacha,
        rs.Lootbox,
        rs.ChestSystem,
        rs.Rewards,
        rs.PremiumGacha,
        rs.GachaController
    }
    
    for _, path in pairs(gachaPaths) do
        if path then
            return path
        end
    end
    
    -- بحث متعمق
    for _, obj in pairs(rs:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("gacha") or name:find("lootbox") or name:find("chest") then
            return obj
        end
    end
    
    return nil
end

-- 🎰 تفعيل الغاتشا المجانية
local function exploitGacha()
    print("🎰 جاري اختراق الغاتشا...")
    
    local gachaSystem = findGachaSystem()
    
    if not gachaSystem then
        print("❌ ما لقيتش نظام غاتشا")
        return
    end
    
    print("✅ وجدت نظام الغاتشا: " .. gachaSystem:GetFullName())
    
    -- 🔥 الطريقة 1: إرسال طلب spin مجاني
    local function method1_freeSpin()
        print("🔄 المحاولة 1: Spin مجاني")
        
        local remoteEvents = {}
        for _, child in pairs(gachaSystem:GetDescendants()) do
            if child:IsA("RemoteEvent") then
                table.insert(remoteEvents, child)
            end
        end
        
        for _, remote in pairs(remoteEvents) do
            -- جرب كل الأوامر الممكنة
            local commands = {
                "spin_free",
                "free_spin", 
                "gacha_spin",
                "roll_free",
                "open_free",
                "claim_free_spin",
                "daily_spin"
            }
            
            for _, cmd in pairs(commands) do
                pcall(function()
                    remote:FireServer(cmd)
                    print("   🔥 أمر: " .. cmd)
                end)
                task.wait(0.1)
            end
        end
    end
    
    -- 🔥 الطريقة 2: تخطي التحقق
    local function method2_bypassCheck()
        print("🔄 المحاولة 2: تخطي التحقق")
        
        local fakePurchase = {
            purchased = true,
            productId = 999999,
            price = 0,
            currency = "FREE",
            receipt = "GACHA_HACK_" .. os.time(),
            playerId = plr.UserId
        }
        
        for _, remote in pairs(gachaSystem:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                pcall(function()
                    remote:FireServer("verify_purchase", fakePurchase)
                    remote:FireServer("confirm_purchase", fakePurchase)
                end)
            end
        end
    end
    
    -- 🔥 الطريقة 3: Claim مكافآت وهمية
    local function method3_fakeRewards()
        print("🔄 المحاولة 3: مكافآت وهمية")
        
        local rewards = {
            {rarity = "LEGENDARY", item = "Leopard-Fruit"},
            {rarity = "MYTHICAL", item = "Dragon-Fruit"},
            {rarity = "RARE", item = "Venom-Fruit"},
            {rarity = "EPIC", item = "Dough-Fruit"}
        }
        
        for _, reward in pairs(rewards) do
            local fakeReward = {
                rewardType = reward.rarity,
                itemName = reward.item,
                amount = 1,
                timestamp = os.time(),
                valid = true
            }
            
            for _, remote in pairs(gachaSystem:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer("claim_reward", fakeReward)
                        remote:FireServer("reward_collected", fakeReward)
                    end)
                end
            end
            task.wait(0.2)
        end
    end
    
    -- 🔥 الطريقة 4: تعديل الـ Cooldown
    local function method4_removeCooldown()
        print("🔄 المحاولة 4: إزالة وقت الانتظار")
        
        local cooldownData = {
            cooldown = 0,
            nextSpin = 0,
            unlimited = true,
            bypass = true
        }
        
        for _, remote in pairs(gachaSystem:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                pcall(function()
                    remote:FireServer("update_cooldown", cooldownData)
                    remote:FireServer("reset_cooldown")
                end)
            end
        end
    end
    
    -- تشغيل كل الطرق
    method1_freeSpin()
    task.wait(1)
    method2_bypassCheck()
    task.wait(1)
    method3_fakeRewards()
    task.wait(1)
    method4_removeCooldown()
    
    print("✅ اكتمل اختراق الغاتشا!")
end

-- 📱 واجهة الهاتف
local ui = Instance.new("ScreenGui")
ui.Name = "GachaHack"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.35, 0, 0.3, 0)
main.Position = UDim2.new(0.6, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "🎰 GACHA HACK"
title.Size = UDim2.new(1, 0, 0.15, 0)
title.BackgroundColor3 = Color3.fromRGB(150, 0, 200)

local hackBtn = Instance.new("TextButton")
hackBtn.Text = "⚡ اختراق الغاتشا"
hackBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
hackBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
hackBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)

local status = Instance.new("TextLabel")
status.Text = "جاهز لاختراق الغاتشا"
status.Size = UDim2.new(0.9, 0, 0.3, 0)
status.Position = UDim2.new(0.05, 0, 0.65, 0)
status.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
status.TextWrapped = true

-- الأحداث
hackBtn.MouseButton1Click:Connect(function()
    hackBtn.Text = "🎰 جاري الاختراق..."
    status.Text = "🔍 يبحث عن نظام الغاتشا..."
    
    task.spawn(function()
        exploitGacha()
        
        hackBtn.Text = "⚡ اختراق الغاتشا"
        status.Text = "✅ اكتمل الاختراق!\nتحقق من المكافآت!"
    end)
end)

-- التجميع
title.Parent = main
hackBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = plr.PlayerGui

print("🎰 GACHA HACK SYSTEM READY!")
print("⚡ 4 طرق مختلفة للاختراق")
print("🎁 الحصول على فواكه نادرة مجاناً")
