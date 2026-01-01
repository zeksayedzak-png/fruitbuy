-- 🛒 FAKE PURCHASE BUTTON CREATOR
-- Mobile Version
-- loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui
local rs = game:GetService("ReplicatedStorage")

-- صنع زرنا الخاص
local function createFakePurchaseButton()
    print("🎨 جاري صنع زر الشراء المزيف...")
    
    -- 1. إنشاء زر جديد
    local fakeBtn = Instance.new("TextButton")
    fakeBtn.Name = "FakePurchaseButton"
    fakeBtn.Text = "🎁 FREE SPIN (0 Candy)"
    fakeBtn.Size = UDim2.new(0.25, 0, 0.06, 0)
    fakeBtn.Position = UDim2.new(0.7, 0, 0.2, 0) -- مكان واضح
    fakeBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fakeBtn.TextColor3 = Color3.new(0, 0, 0)
    fakeBtn.Font = Enum.Font.SourceSansBold
    fakeBtn.TextSize = 16
    fakeBtn.ZIndex = 100  -- فوق كل شيء
    fakeBtn.Active = true
    fakeBtn.Draggable = true  -- تقدر تحركه
    
    -- 2. وظيفة الزر (بدون أي تحقق)
    fakeBtn.MouseButton1Click:Connect(function()
        print("🎰 زرنا الخاص يشتري...")
        
        -- البحث عن RemoteEvent للغاتشا
        local targetRemote = nil
        
        -- طريقة 1: البحث في مسارات معروفة
        local possiblePaths = {
            "ReplicatedStorage.GachaSystem.Purchase",
            "ReplicatedStorage.Gacha.BuySpin",
            "ReplicatedStorage.Shop.Purchase",
            "ReplicatedStorage.Controllers.Gacha.Purchase",
            "ReplicatedStorage.Remotes.GachaPurchase"
        }
        
        for _, path in pairs(possiblePaths) do
            local target = rs
            for part in path:gmatch("[^%.]+") do
                target = target:FindFirstChild(part)
                if not target then break end
            end
            
            if target and target:IsA("RemoteEvent") then
                targetRemote = target
                break
            end
        end
        
        -- طريقة 2: البحث بالاسم
        if not targetRemote then
            for _, obj in pairs(rs:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    local name = obj.Name:lower()
                    if name:find("gacha") and name:find("purchase") then
                        targetRemote = obj
                        break
                    end
                end
            end
        end
        
        -- طريقة 3: أول RemoteEvent نجده
        if not targetRemote then
            for _, obj in pairs(rs:GetChildren()) do
                if obj:IsA("RemoteEvent") then
                    targetRemote = obj
                    break
                end
            end
        end
        
        -- إرسال طلب الشراء المزيف
        if targetRemote then
            print("✅ وجدت Remote: " .. targetRemote.Name)
            
            -- بيانات الشراء المزيف
            local fakeData = {
                action = "purchase_spin",
                player = plr.Name,
                userId = plr.UserId,
                cost = 0,  -- مجاني
                candy = 0, -- بدون Candy
                timestamp = os.time(),
                receipt = "FREE_PURCHASE_" .. math.random(10000, 99999),
                bypass = true
            }
            
            -- إرسال عدة مرات
            for i = 1, 5 do
                pcall(function()
                    targetRemote:FireServer(fakeData)
                    targetRemote:FireServer("buy_spin")
                    targetRemote:FireServer("purchase_free")
                end)
                task.wait(0.1)
            end
            
            fakeBtn.Text = "✅ تم الشراء!"
            task.wait(1)
            fakeBtn.Text = "🎁 FREE SPIN (0 Candy)"
        else
            print("❌ ما لقيتش Remote")
            fakeBtn.Text = "❌ Remote مش موجود"
            task.wait(1)
            fakeBtn.Text = "🎁 FREE SPIN (0 Candy)"
        end
    end)
    
    -- 3. زر الإغلاق
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0.1, 0, 1, 0)
    closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.SourceSansBold
    
    closeBtn.MouseButton1Click:Connect(function()
        fakeBtn.Visible = not fakeBtn.Visible
    end)
    
    -- 4. زر الإعدادات
    local settingsBtn = Instance.new("TextButton")
    settingsBtn.Text = "⚙️"
    settingsBtn.Size = UDim2.new(0.1, 0, 1, 0)
    settingsBtn.Position = UDim2.new(0.8, 0, 0, 0)
    settingsBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    settingsBtn.TextColor3 = Color3.new(1, 1, 1)
    
    settingsBtn.MouseButton1Click:Connect(function()
        -- خيارات إضافية
        local options = {
            "🔁 إرسال 10 مرات",
            "💰 0 Candy + 0 Robux",
            "🎯 تجاهل كل التحققات",
            "⚡ وضع سريع"
        }
        
        -- هنا ممكن نضيف قائمة اختيار
        fakeBtn.Text = "⚙️ الخيارات..."
        task.wait(1)
        fakeBtn.Text = "🎁 FREE SPIN (0 Candy)"
    end)
    
    -- 5. إضافة الزر للواجهة
    closeBtn.Parent = fakeBtn
    settingsBtn.Parent = fakeBtn
    fakeBtn.Parent = gui
    
    -- 6. صنع نسخ احتياطية في أماكن مختلفة
    local backupLocations = {
        UDim2.new(0.1, 0, 0.2, 0),  -- يسار
        UDim2.new(0.8, 0, 0.5, 0),  -- يمين
        UDim2.new(0.4, 0, 0.8, 0)   -- أسفل
    }
    
    for i, pos in ipairs(backupLocations) do
        local backupBtn = fakeBtn:Clone()
        backupBtn.Name = "FakePurchaseButton_" .. i
        backupBtn.Position = pos
        backupBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        backupBtn.Parent = gui
    end
    
    print("✅ زر الشراء المزيف جاهز!")
    print("🎁 اضغط عليه للشراء بدون Candy")
    
    return fakeBtn
end

-- 📱 واجهة التحكم
local controlUI = Instance.new("ScreenGui")
controlUI.Name = "FakeButtonControl"
controlUI.ResetOnSpawn = false

local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.new(0.3, 0, 0.2, 0)
controlFrame.Position = UDim2.new(0.65, 0, 0.02, 0)
controlFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
controlFrame.Active = true
controlFrame.Draggable = true

local controlTitle = Instance.new("TextLabel")
controlTitle.Text = "🎨 Fake Button Creator"
controlTitle.Size = UDim2.new(1, 0, 0.3, 0)
controlTitle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

local createBtn = Instance.new("TextButton")
createBtn.Text = "➕ صنع زر شراء مزيف"
createBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
createBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
createBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "جاهز لصنع زر خاص بينا"
statusLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
statusLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

-- حدث صنع الزر
createBtn.MouseButton1Click:Connect(function()
    createBtn.Text = "🎨 جاري الصنع..."
    statusLabel.Text = "يصنع زر شراء بدون تحقق..."
    
    task.spawn(function()
        local fakeButton = createFakePurchaseButton()
        
        createBtn.Text = "✅ تم الصنع"
        createBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        statusLabel.Text = "✅ الزر جاهز!\nاضغط عليه للشراء"
        
        task.wait(3)
        createBtn.Text = "➕ صنع زر شراء مزيف"
        createBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        statusLabel.Text = "الزر الأصفر: حركه واضغطه"
    end)
end)

-- التجميع
controlTitle.Parent = controlFrame
createBtn.Parent = controlFrame
statusLabel.Parent = controlFrame
controlFrame.Parent = controlUI
controlUI.Parent = gui

print("🎨 FAKE PURCHASE BUTTON CREATOR")
print("🎯 يصنع زر شراء خاص بينا")
print("💰 0 Candy - بدون تحقق")
print("🔄 تقدر تحرك الزر بإصبعك")
print("🎁 اضغط الزر الأصفر للشراء!")
