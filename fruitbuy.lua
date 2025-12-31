-- Pet Simulator 99 Purchase Hacker
-- يعمل على الهاتف في loadstring

local rs = game:GetService("ReplicatedStorage")
local plr = game.Players.LocalPlayer

-- أهم الريمورتات للاختراق
local remotes = {
    FakePurchase = rs:WaitForChild("GameEvents"):WaitForChild("Market"):WaitForChild("FakePurchase"),
    DeveloperPurchase = rs:WaitForChild("GameEvents"):WaitForChild("DeveloperPurchase"),
    ClaimSeasonPassReward = rs:WaitForChild("GameEvents"):WaitForChild("SeasonPass"):WaitForChild("ClaimSeasonPassReward"),
    BuyPetEgg = rs:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"),
    BuyRebirth = rs:WaitForChild("GameEvents"):WaitForChild("BuyRebirth")
}

-- واجهة الهاتف
local ui = Instance.new("ScreenGui")
ui.Name = "PurchaseHacker"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.9, 0, 0.5, 0)
main.Position = UDim2.new(0.05, 0, 0.45, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderColor3 = Color3.fromRGB(255, 0, 0)

local title = Instance.new("TextLabel")
title.Text = "🔥 PURCHASE HACKER"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold

local status = Instance.new("TextLabel")
status.Text = "✅ جاهز للاختراق!"
status.Size = UDim2.new(1, 0, 0.15, 0)
status.Position = UDim2.new(0, 0, 0.1, 0)
status.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
status.TextColor3 = Color3.new(1, 1, 1)
status.TextWrapped = true

-- أزرار الاختراق
local buttons = {}

local function createButton(name, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0.9, 0, 0.12, 0)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = main
    return btn
end

-- إنشاء الأزرار
buttons.fakePurchase = createButton("💳 FakePurchase", 0.27, Color3.fromRGB(200, 0, 0))
buttons.devPurchase = createButton("👨‍💻 DeveloperPurchase", 0.41, Color3.fromRGB(0, 150, 200))
buttons.claimReward = createButton("🎁 ClaimSeasonPass", 0.55, Color3.fromRGB(0, 180, 0))
buttons.buyEgg = createButton("🥚 BuyPetEgg", 0.69, Color3.fromRGB(180, 0, 180))
buttons.massHack = createButton("💥 MASS HACK ALL", 0.83, Color3.fromRGB(255, 100, 0))

-- نضيف كل حاجة
title.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = plr:WaitForChild("PlayerGui")

-- دالة الاختراق
local function hackFakePurchase()
    status.Text = "💳 جاري اختراق FakePurchase..."
    
    for i = 1, 10 do
        pcall(function()
            remotes.FakePurchase:FireServer("HugePet", 1, 0) -- حيوان ضخم مجاناً
            remotes.FakePurchase:FireServer("ExclusiveEgg", 5, 0) -- بيض حصري
            remotes.FakePurchase:FireServer("RainbowCoin", 1000, 0) -- عملة
        end)
        task.wait(0.2)
    end
    
    status.Text = "✅ FakePurchase تم اختراقه!"
end

local function hackDevPurchase()
    status.Text = "👨‍💻 جاري اختراق DeveloperPurchase..."
    
    for i = 1, 20 do
        pcall(function()
            remotes.DeveloperPurchase:InvokeServer("GodMode", true)
            remotes.DeveloperPurchase:InvokeServer("UnlockAll", plr)
            remotes.DeveloperPurchase:InvokeServer("MaxCurrency", 999999)
        end)
        task.wait(0.1)
    end
    
    status.Text = "✅ DeveloperPurchase تم اختراقه!"
end

local function hackSeasonPass()
    status.Text = "🎁 جاري اختراق SeasonPass..."
    
    for level = 1, 100 do
        pcall(function()
            remotes.ClaimSeasonPassReward:FireServer(level, "PremiumReward")
            remotes.ClaimSeasonPassReward:FireServer(level, "FreeReward")
        end)
        task.wait(0.05)
    end
    
    status.Text = "✅ SeasonPass تم اختراقه!"
end

local function hackPetEggs()
    status.Text = "🥚 جاري اختراق PetEggs..."
    
    local eggTypes = {"HugeEgg", "RainbowEgg", "GoldenEgg", "MythicalEgg", "ExclusiveEgg"}
    
    for _, egg in ipairs(eggTypes) do
        for i = 1, 5 do
            pcall(function()
                remotes.BuyPetEgg:FireServer(egg, 999)
            end)
            task.wait(0.1)
        end
    end
    
    status.Text = "✅ PetEggs تم اختراقه!"
end

local function massHackAll()
    status.Text = "💥 جاري اختراق كل شيء..."
    
    hackFakePurchase()
    task.wait(1)
    hackDevPurchase()
    task.wait(1)
    hackSeasonPass()
    task.wait(1)
    hackPetEggs()
    
    status.Text = "💣 كل شيء تم اختراقه!"
end

-- أحداث الأزرار
buttons.fakePurchase.MouseButton1Click:Connect(hackFakePurchase)
buttons.devPurchase.MouseButton1Click:Connect(hackDevPurchase)
buttons.claimReward.MouseButton1Click:Connect(hackSeasonPass)
buttons.buyEgg.MouseButton1Click:Connect(hackPetEggs)
buttons.massHack.MouseButton1Click:Connect(massHackAll)

print("🔥 Purchase Hacker - جاهز للاستخدام!")
print("💳 FakePurchase - للشراء المزيف")
print("👨‍💻 DeveloperPurchase - وضع المطور")
print("🎁 SeasonPass - مكافآت الموسم")
print("🥚 PetEggs - شراء البيض")
