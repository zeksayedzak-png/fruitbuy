-- 🍭 CANDY BYPASS EXPLOIT
-- Mobile Version

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

-- إيجاد زر الشراء
local purchaseBtn = gui:WaitForChild("GachaWindow"):WaitForChild("HolidayGacha25")
    :WaitForChild("FreeToPlay"):WaitForChild("MainGachaUI")
    :WaitForChild("Main"):WaitForChild("Footer"):WaitForChild("PurchaseButton")

print("🎯 زر الشراء موجود - يطلب 100 Candy")

-- نظام الـ Candy Bypass
local CandyExploit = {
    active = false,
    fakeCandyAmount = 999999,
    
    -- 1. تلاعب بالكلاينت
    manipulateClient = function(self)
        -- البحث عن الـ Candy في الكلاينت
        local stats = plr:FindFirstChild("leaderstats")
        if stats then
            for _, stat in pairs(stats:GetChildren()) do
                local name = stat.Name:lower()
                if name:find("candy") or name:find("christmas") then
                    pcall(function()
                        stat.Value = self.fakeCandyAmount
                        print("💰 عُدلت الـ Candy إلى: " .. stat.Value)
                    end)
                end
            end
        end
    end,
    
    -- 2. تخطي التحقق
    bypassCheck = function(self)
        -- تعطيل الوظيفة الأصلية
        local connections = getconnections(purchaseBtn.MouseButton1Click)
        for _, conn in pairs(connections) do
            conn:Disable()
        end
        
        -- وظيفة جديدة
        purchaseBtn.MouseButton1Click:Connect(function()
            print("💥 تم الضغط - تجاوز تحقق الـ Candy")
            
            -- إرسال شراء مزيف
            self:sendFakePurchase()
        end)
    end,
    
    -- 3. إرسال شراء مزيف
    sendFakePurchase = function(self)
        local rs = game:GetService("ReplicatedStorage")
        
        -- بيانات الشراء المزيفة
        local purchaseData = {
            action = "purchase_spin",
            cost = 100,
            candyBefore = self.fakeCandyAmount,
            candyAfter = self.fakeCandyAmount - 100,
            success = true,
            player = plr.Name,
            timestamp = os.time()
        }
        
        -- البحث عن Remote المناسب
        local found = false
        
        -- المحاولة 1: البحث بالاسم
        local targetNames = {"GachaPurchase", "BuySpin", "PurchaseSpin", "HolidayPurchase"}
        for _, name in pairs(targetNames) do
            local remote = rs:FindFirstChild(name)
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer(purchaseData)
                print("🎯 أرسل لـ: " .. name)
                found = true
            end
        end
        
        -- المحاولة 2: البحث في كل الـ Remotes
        if not found then
            for _, remote in pairs(rs:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    local rName = remote.Name:lower()
                    if rName:find("purchase") or rName:find("buy") or rName:find("gacha") then
                        remote:FireServer(purchaseData)
                        print("🎯 أرسل لـ: " .. remote.Name)
                    end
                end
            end
        end
    end,
    
    -- 4. تشغيل النظام
    activate = function(self)
        if self.active then return end
        
        self.active = true
        print("🚀 تفعيل نظام تجاوز الـ Candy...")
        
        self:manipulateClient()
        self:bypassCheck()
        
        -- تغيير مظهر الزر
        purchaseBtn.Text = "🎁 FREE SPIN"
        purchaseBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        print("✅ النظام مفعل! اضغط على الزر!")
    end
}

-- واجهة التحكم
local ui = Instance.new("ScreenGui")
ui.Name = "CandyBypassUI"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.35, 0, 0.2, 0)
main.Position = UDim2.new(0.6, 0, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "🍭 CANDY BYPASS"
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundColor3 = Color3.fromRGB(200, 100, 0)

local activateBtn = Instance.new("TextButton")
activateBtn.Text = "⚡ تفعيل النظام"
activateBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
activateBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

local status = Instance.new("TextLabel")
status.Text = "الزر يطلب 100 Candy\nتفعيل النظام للتجاوز"
status.Size = UDim2.new(0.9, 0, 0.25, 0)
status.Position = UDim2.new(0.05, 0, 0.85, 0)
status.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
status.TextWrapped = true

-- حدث التفعيل
activateBtn.MouseButton1Click:Connect(function()
    activateBtn.Text = "⚡ جاري..."
    status.Text = "يتجاوز شرط 100 Candy..."
    
    task.spawn(function()
        CandyExploit:activate()
        
        task.wait(1)
        activateBtn.Text = "✅ تم التفعيل"
        activateBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        status.Text = "✅ النظام مفعل!\nاضغط على PurchaseButton!"
    end)
end)

-- التجميع
title.Parent = main
activateBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = gui

print("🍭 CANDY BYPASS SYSTEM READY!")
print("🎯 الزر يطلب: 100 Candy")
print("💥 النظام هيجاوز هذا الشرط")
