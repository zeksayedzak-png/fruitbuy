-- 🎰 GACHA FORCE HACK
-- Mobile Version - NO SEARCH
-- loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- 🎯 الأوامر المباشرة بدون بحث
local function forceGachaHack()
    print("💣 بدء الهجوم المباشر على الغاتشا!")
    
    -- 🔥 الهجوم على كل الـ Remotes في اللعبة
    local hacked = 0
    
    for _, obj in pairs(rs:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            
            -- إذا كان اسمه متعلق بالغاتشا أو المكافآت
            if name:find("gacha") or name:find("spin") or name:find("roll") or 
               name:find("chest") or name:find("loot") or name:find("reward") then
                
                print("🎯 وجدت: " .. obj:GetFullName())
                
                -- 💥 الهجوم 1: طلب spin مجاني
                for i = 1, 10 do
                    pcall(function()
                        if obj:IsA("RemoteEvent") then
                            obj:FireServer("SPIN_FREE")
                            obj:FireServer("FREE_SPIN")
                            obj:FireServer("OPEN_CHEST")
                        else
                            obj:InvokeServer("SPIN_FREE")
                            obj:InvokeServer("FREE_SPIN")
                        end
                        hacked = hacked + 1
                    end)
                    task.wait(0.05)
                end
                
                -- 💥 الهجوم 2: بيانات شراء مزيفة
                local fakePurchase = {
                    productId = 999999,
                    purchased = true,
                    price = 0,
                    currency = "FREE",
                    receipt = "HACKED_" .. os.time(),
                    playerId = plr.UserId,
                    success = true
                }
                
                for i = 1, 5 do
                    pcall(function()
                        if obj:IsA("RemoteEvent") then
                            obj:FireServer("PURCHASE_COMPLETE", fakePurchase)
                            obj:FireServer("VERIFY_PURCHASE", fakePurchase)
                        end
                        hacked = hacked + 1
                    end)
                    task.wait(0.05)
                end
                
                -- 💥 الهجوم 3: مطالبة بمكافآت
                local rewards = {
                    "LEOPARD_FRUIT",
                    "DRAGON_FRUIT", 
                    "DOUGH_FRUIT",
                    "VENOM_FRUIT",
                    "SHADOW_FRUIT",
                    "RUMBLE_FRUIT",
                    "PHOENIX_FRUIT",
                    "GRAVITY_FRUIT"
                }
                
                for _, reward in pairs(rewards) do
                    local fakeReward = {
                        item = reward,
                        rarity = "LEGENDARY",
                        amount = 999,
                        fromGacha = true,
                        timestamp = os.time()
                    }
                    
                    pcall(function()
                        if obj:IsA("RemoteEvent") then
                            obj:FireServer("CLAIM_REWARD", fakeReward)
                            obj:FireServer("REWARD_COLLECTED", fakeReward)
                        end
                        hacked = hacked + 1
                    end)
                    task.wait(0.03)
                end
            end
        end
    end
    
    -- 💣 هجوم إضافي على مسارات معروفة
    local knownPaths = {
        "ReplicatedStorage.GachaSystem",
        "ReplicatedStorage.LootboxSystem",
        "ReplicatedStorage.RewardsSystem",
        "ReplicatedStorage.PremiumGacha",
        "ReplicatedStorage.GachaController",
        "ReplicatedStorage.Controllers.UI.GachaWindow",
        "ReplicatedStorage.Controllers.Gacha"
    }
    
    for _, path in pairs(knownPaths) do
        local target = game
        for part in path:gmatch("[^%.]+") do
            target = target:FindFirstChild(part)
            if not target then break end
        end
        
        if target then
            print("💣 هجوم مباشر على: " .. path)
            
            -- هجوم شامل على كل الأطفال
            for _, child in pairs(target:GetDescendants()) do
                if child:IsA("RemoteEvent") then
                    for i = 1, 3 do
                        pcall(function()
                            child:FireServer("FORCE_SPIN")
                            child:FireServer("UNLOCK_ALL")
                            hacked = hacked + 1
                        end)
                    end
                end
            end
        end
    end
    
    -- 💥 إرسال طلبات عامة لكل الـ Remotes
    print("💣 هجوم شامل على كل الـ Remotes...")
    
    local allRemotes = {}
    for _, obj in pairs(rs:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(allRemotes, obj)
        end
    end
    
    for _, remote in pairs(allRemotes) do
        -- محاولة أوامر عامة
        local commands = {
            "GACHA_SPIN",
            "FREE_REWARD", 
            "CLAIM_DAILY",
            "OPEN_ALL_CHESTS",
            "GET_PREMIUM_REWARDS",
            "UNLOCK_GACHA",
            "RESET_COOLDOWN"
        }
        
        for _, cmd in pairs(commands) do
            pcall(function()
                remote:FireServer(cmd)
                hacked = hacked + 1
            end)
            task.wait(0.01)
        end
    end
    
    return hacked
end

-- 📱 واجهة الهجوم المباشر
local ui = Instance.new("ScreenGui")
ui.Name = "GachaForceHack"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.35, 0, 0.25, 0)
main.Position = UDim2.new(0.6, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "💣 GACHA FORCE HACK"
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)

local nukeBtn = Instance.new("TextButton")
nukeBtn.Text = "💥 NUKE GACHA SYSTEM"
nukeBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
nukeBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
nukeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
nukeBtn.TextColor3 = Color3.new(1, 1, 1)

local status = Instance.new("TextLabel")
status.Text = "جاهز لتدمير الغاتشا!"
status.Size = UDim2.new(0.9, 0, 0.2, 0)
status.Position = UDim2.new(0.05, 0, 0.8, 0)
status.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
status.TextColor3 = Color3.new(1, 1, 1)

-- حدث النوك
nukeBtn.MouseButton1Click:Connect(function()
    nukeBtn.Text = "💣 جاري التفجير..."
    status.Text = "🔥 هجوم شامل على كل الأنظمة..."
    
    task.spawn(function()
        local attacks = forceGachaHack()
        
        nukeBtn.Text = "💥 NUKE GACHA SYSTEM"
        status.Text = "✅ تم " .. attacks .. " هجوم!\nتحقق من المكافآت!"
        
        task.wait(3)
        status.Text = "⚡ جاهز لهجوم جديد!"
    end)
end)

-- التجميع
title.Parent = main
nukeBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = plr.PlayerGui

print("💣 GACHA FORCE HACK - READY!")
print("⚡ هجوم مباشر بدون بحث")
print("💥 يضرب كل الـ Remotes في اللعبة")
print("🎰 يحاول يكسر أي نظام غاتشا")
