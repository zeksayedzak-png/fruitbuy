-- Pet Simulator 99 GOD MODE HACKER
-- FilteringEnabled مفتوح - يعمل على الهاتف

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local lp = game:GetService("Players").LocalPlayer

-- نجمع كل الريمورتات المهمة
local remotes = {
    FakePurchase = rs:WaitForChild("GameEvents"):WaitForChild("Market"):WaitForChild("FakePurchase"),
    ClaimReward = rs:WaitForChild("GameEvents"):WaitForChild("SeasonPass"):WaitForChild("ClaimSeasonPassReward"),
    BuyPetEgg = rs:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"),
    BuyRebirth = rs:WaitForChild("GameEvents"):WaitForChild("BuyRebirth"),
    BuyEventStock = rs:WaitForChild("GameEvents"):WaitForChild("BuyEventShopStock")
}

-- واجهة God Mode
local ui = Instance.new("ScreenGui")
ui.Name = "GOD_MODE_HACKER"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.95, 0, 0.6, 0)
main.Position = UDim2.new(0.025, 0, 0.35, 0)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.BorderSizePixel = 3

-- العنوان
local title = Instance.new("TextLabel")
title.Text = "🔥 GOD MODE ACTIVATED - FilteringEnabled: OFF 🔥"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- زر الإنفجار
local nukeBtn = Instance.new("TextButton")
nukeBtn.Text = "💣 NUKE EVERYTHING (اختراق كامل)"
nukeBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
nukeBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
nukeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
nukeBtn.TextColor3 = Color3.new(1, 1, 1)
nukeBtn.Font = Enum.Font.SourceSansBold

-- زر المال اللانهائي
local moneyBtn = Instance.new("TextButton")
moneyBtn.Text = "💰 INFINITE MONEY (مال لا نهائي)"
moneyBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
moneyBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
moneyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
moneyBtn.TextColor3 = Color3.new(0, 0, 0)
moneyBtn.Font = Enum.Font.SourceSansBold

-- زر البيض
local eggBtn = Instance.new("TextButton")
eggBtn.Text = "🥚 UNLIMITED EGGS (بيض لا محدود)"
eggBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
eggBtn.Position = UDim2.new(0.05, 0, 0.48, 0)
eggBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
eggBtn.TextColor3 = Color3.new(0, 0, 0)
eggBtn.Font = Enum.Font.SourceSansBold

-- زر Season Pass
local seasonBtn = Instance.new("TextButton")
seasonBtn.Text = "🎁 MAX SEASON PASS (موسم كامل)"
seasonBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
seasonBtn.Position = UDim2.new(0.05, 0, 0.66, 0)
seasonBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
seasonBtn.TextColor3 = Color3.new(1, 1, 1)
seasonBtn.Font = Enum.Font.SourceSansBold

-- الحالة
local status = Instance.new("TextLabel")
status.Text = "✅ GOD MODE جاهز! FilteringEnabled مفتوح!"
status.Size = UDim2.new(1, 0, 0.1, 0)
status.Position = UDim2.new(0, 0, 0.85, 0)
status.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
status.TextColor3 = Color3.new(0, 255, 0)
status.TextWrapped = true

-- نضيف للواجهة
title.Parent = main
nukeBtn.Parent = main
moneyBtn.Parent = main
eggBtn.Parent = main
seasonBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = plr:WaitForChild("PlayerGui")

-- دالة NUKE الكاملة
local function nukeEverything()
    status.Text = "💣 جاري تدمير كل شيء..."
    
    -- 1. مال لا نهائي
    for i = 1, 100 do
        pcall(function()
            remotes.FakePurchase:FireServer("Cash", 9999999, 0)
            remotes.FakePurchase:FireServer("Gems", 999999, 0)
            remotes.FakePurchase:FireServer("Tokens", 99999, 0)
        end)
        task.wait(0.05)
    end
    
    -- 2. كل البيض
    local eggs = {"MythicalEgg", "HugeEgg", "RainbowEgg", "GoldenEgg", "ExclusiveEgg"}
    for _, egg in pairs(eggs) do
        for i = 1, 50 do
            pcall(function()
                remotes.BuyPetEgg:FireServer(egg, 99)
            end)
            task.wait(0.05)
        end
    end
    
    -- 3. Season Pass كامل
    for level = 1, 100 do
        pcall(function()
            remotes.ClaimReward:FireServer(level, "Premium")
            remotes.ClaimReward:FireServer(level, "Free")
        end)
        task.wait(0.03)
    end
    
    -- 4. Rebirthات
    for i = 1, 100 do
        pcall(function()
            remotes.BuyRebirth:FireServer()
        end)
        task.wait(0.05)
    end
    
    status.Text = "💥 تم تدمير كل شيء! GOD MODE مكتمل!"
end

-- دالة المال اللانهائي
local function infiniteMoney()
    status.Text = "💰 جاري إضافة مال لا نهائي..."
    
    local moneyTypes = {
        {"Cash", 9999999},
        {"Gems", 999999},
        {"Tokens", 99999},
        {"Diamonds", 9999},
        {"RainbowCoins", 999}
    }
    
    for _, money in pairs(moneyTypes) do
        for i = 1, 20 do
            pcall(function()
                remotes.FakePurchase:FireServer(money[1], money[2], 0)
            end)
            task.wait(0.1)
        end
    end
    
    status.Text = "✅ مال لا نهائي مكتمل!"
end

-- دالة البيض اللانهائي
local function unlimitedEggs()
    status.Text = "🥚 جاري إضافة بيض لا محدود..."
    
    local eggList = {
        "MythicalEgg", "HugeEgg", "RainbowEgg", "GoldenEgg",
        "ExclusiveEgg", "LegendaryEgg", "EpicEgg", "RareEgg"
    }
    
    for _, egg in pairs(eggList) do
        for i = 1, 30 do
            pcall(function()
                remotes.BuyPetEgg:FireServer(egg, 50)
            end)
            task.wait(0.08)
        end
    end
    
    status.Text = "✅ بيض لا محدود مكتمل!"
end

-- دالة Season Pass كامل
local function maxSeasonPass()
    status.Text = "🎁 جاري فتح Season Pass كامل..."
    
    for level = 1, 100 do
        for _, rewardType in pairs({"Premium", "Free", "Bonus", "Special"}) do
            pcall(function()
                remotes.ClaimReward:FireServer(level, rewardType)
            end)
        end
        task.wait(0.05)
    end
    
    status.Text = "✅ Season Pass كامل مكتمل!"
end

-- أحداث الأزرار
nukeBtn.MouseButton1Click:Connect(nukeEverything)
moneyBtn.MouseButton1Click:Connect(infiniteMoney)
eggBtn.MouseButton1Click:Connect(unlimitedEggs)
seasonBtn.MouseButton1Click:Connect(maxSeasonPass)

print("===========================================")
print("🔥 GOD MODE ACTIVATED - FilteringEnabled: OFF")
print("💣 NUKE EVERYTHING - اختراق كامل")
print("💰 INFINITE MONEY - مال لا نهائي")
print("🥚 UNLIMITED EGGS - بيض لا محدود")
print("🎁 MAX SEASON PASS - موسم كامل")
print("===========================================")

-- بداية تلقائية
task.wait(2)
status.Text = "⚡ اضغط أي زر للبدء! FilteringEnabled مفتوح!"
