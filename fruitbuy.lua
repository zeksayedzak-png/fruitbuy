-- 🏆 PREMIUM GACHA HACK
-- Mobile Version

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

-- نظام اختراق Premium Gacha
local PremiumGachaHack = {
    premiumUI = nil,
    premiumGacha = nil,
    
    -- 1. فتح Premium Gacha
    unlockPremiumGacha = function(self)
        print("🔓 جاري فتح Premium Gacha...")
        
        -- البحث عن واجهة Premium
        local target = gui
        local path = {"GachaWindow", "HolidayGacha25", "Premium", "MainGachaUI"}
        
        for _, folder in ipairs(path) do
            target = target:FindFirstChild(folder)
            if not target then
                print("❌ " .. folder .. " مش موجود")
                return false
            end
        end
        
        self.premiumUI = target
        print("✅ Premium Gacha موجود: " .. target:GetFullName())
        
        -- تفعيل الواجهة
        target.Enabled = true
        target.Visible = true
        
        -- البحث عن PremiumGacha داخل Content
        local content = target:FindFirstChild("Main")
        if content then
            content = content:FindFirstChild("Content")
            if content then
                self.premiumGacha = content:FindFirstChild("PremiumGacha")
                if self.premiumGacha then
                    print("✅ PremiumGacha وجد: " .. self.premiumGacha:GetFullName())
                end
            end
        end
        
        return true
    end,
    
    -- 2. النقر على الفواكه النادرة
    clickRareFruits = function(self)
        if not self.premiumGacha then
            print("❌ PremiumGacha مش موجود")
            return 0
        end
        
        print("🎯 جاري النقر على الفواكه النادرة...")
        
        local clicks = 0
        
        -- الفواكه من 7 إلى 1 (الأندر أولاً)
        for i = 7, 1, -1 do
            local fruitBtn = self.premiumGacha:FindFirstChild("Fruit" .. i)
            if fruitBtn and fruitBtn:IsA("GuiButton") then
                
                -- تعطيل الوظيفة الأصلية
                local connections = getconnections(fruitBtn.MouseButton1Click)
                for _, conn in pairs(connections) do
                    conn:Disable()
                end
                
                -- وظيفة جديدة
                fruitBtn.MouseButton1Click:Connect(function()
                    print("🍎 Fruit" .. i .. " تم النقر!")
                    
                    -- إرسال طلب الحصول على الفاكهة
                    self:sendFruitClaim(i)
                    clicks = clicks + 1
                end)
                
                -- محاولة النقر تلقائياً
                task.spawn(function()
                    task.wait(0.5 * i)
                    pcall(function()
                        fruitBtn:Fire("click")
                    end)
                end)
            end
        end
        
        return clicks
    end,
    
    -- 3. اختراق PreviewButton
    hijackPreviewButton = function(self)
        local previewBtn = gui.GachaWindow.HolidayGacha25.Premium.MainGachaUI.PurchaseFooter:FindFirstChild("PreviewButton")
        
        if not previewBtn then
            print("❌ PreviewButton مش موجود")
            return false
        end
        
        print("🔍 جاري اختراق PreviewButton...")
        
        -- تعطيل الوظيفة الأصلية
        local connections = getconnections(previewBtn.MouseButton1Click)
        for _, conn in pairs(connections) do
            conn:Disable()
        end
        
        -- وظيفة جديدة
        previewBtn.MouseButton1Click:Connect(function()
            print("💥 PreviewButton مخترق!")
            
            -- إرسال طلب شراء Premium Gacha
            self:sendPremiumPurchase()
            
            -- تغيير مظهر الزر
            previewBtn.Text = "✅ تم الشراء!"
            task.wait(1)
            previewBtn.Text = ""
        end)
        
        -- تغيير لون الزر
        previewBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        
        return true
    end,
    
    -- 4. إرسال طلب فاكهة
    sendFruitClaim = function(self, fruitNumber)
        local rs = game:GetService("ReplicatedStorage")
        
        -- تحديد اسم الفاكهة حسب الرقم
        local fruitNames = {
            [7] = "LEOPARD",
            [6] = "DRAGON", 
            [5] = "DOUGH",
            [4] = "VENOM",
            [3] = "SHADOW",
            [2] = "RUMBLE",
            [1] = "PHOENIX"
        }
        
        local fruitName = fruitNames[fruitNumber] or "RARE_FRUIT"
        
        -- بيانات المطالبة
        local claimData = {
            fruit = fruitName,
            fromGacha = "PREMIUM",
            position = fruitNumber,
            player = plr.Name,
            free = true
        }
        
        -- البحث عن Remote
        for _, remote in pairs(rs:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local rName = remote.Name:lower()
                if rName:find("gacha") or rName:find("fruit") or rName:find("reward") then
                    pcall(function()
                        remote:FireServer("claim_fruit", claimData)
                        remote:FireServer("get_fruit", fruitName)
                    end)
                end
            end
        end
    end,
    
    -- 5. إرسال شراء Premium
    sendPremiumPurchase = function(self)
        local rs = game:GetService("ReplicatedStorage")
        
        local purchaseData = {
            type = "PREMIUM_GACHA",
            cost = 0,
            player = plr.Name,
            timestamp = os.time(),
            receipt = "FREE_PREMIUM_" .. math.random(10000, 99999)
        }
        
        for _, remote in pairs(rs:GetDescendants()) do
            if remote:IsA("RemoteEvent") and remote.Name:find("Purchase") then
                pcall(function()
                    remote:FireServer(purchaseData)
                end)
            end
        end
    end,
    
    -- 6. تشغيل الهجوم الكامل
    executeAttack = function(self)
        print("🚀 بدء هجوم Premium Gacha...")
        
        -- فتح Premium Gacha
        if not self:unlockPremiumGacha() then
            return "❌ فشل فتح Premium Gacha"
        end
        
        task.wait(1)
        
        -- اختراق PreviewButton
        self:hijackPreviewButton()
        
        task.wait(1)
        
        -- النقر على الفواكه
        local clicks = self:clickRareFruits()
        
        return "✅ هجوم مكتمل! " .. clicks .. " فواكه جاهزة"
    end
}

-- 📱 واجهة التحكم
local ui = Instance.new("ScreenGui")
ui.Name = "PremiumGachaHackUI"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.4, 0, 0.25, 0)
main.Position = UDim2.new(0.55, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "🏆 PREMIUM GACHA HACK"
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundColor3 = Color3.fromRGB(150, 0, 200)

local attackBtn = Instance.new("TextButton")
attackBtn.Text = "🎰 اختراق Premium Gacha"
attackBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
attackBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
attackBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)

local status = Instance.new("TextLabel")
status.Text = "🎯 Fruit7 و Fruit6 موجودان\n🔍 PreviewButton جاهز للاختراق"
status.Size = UDim2.new(0.9, 0, 0.2, 0)
status.Position = UDim2.new(0.05, 0, 0.85, 0)
status.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
status.TextWrapped = true

-- حدث الهجوم
attackBtn.MouseButton1Click:Connect(function()
    attackBtn.Text = "💣 جاري الاختراق..."
    status.Text = "🔓 يفتح Premium Gacha..."
    
    task.spawn(function()
        local result = PremiumGachaHack:executeAttack()
        
        attackBtn.Text = "✅ تم الاختراق"
        attackBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        status.Text = result .. "\nاضغط على الفواكه!"
    end)
end)

-- التجميع
title.Parent = main
attackBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = gui

print("🏆 PREMIUM GACHA HACK - READY!")
print("🎯 Fruit7: أغلى فاكهة (Leopard)")
print("🎯 Fruit6: فاكهة نادرة (Dragon)")
print("🔍 PreviewButton: زر المعاينة")
print("💥 يحول المعاينة لشراء مجاني")
