-- 🎰 GACHA PURCHASE EXPLOIT
-- Mobile Version

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

-- البحث عن زر الشراء
local purchaseButton = gui:FindFirstChild("GachaWindow")
if purchaseButton then
    purchaseButton = purchaseButton:FindFirstChild("HolidayGacha25")
    if purchaseButton then
        purchaseButton = purchaseButton:FindFirstChild("FreeToPlay")
        if purchaseButton then
            purchaseButton = purchaseButton:FindFirstChild("MainGachaUI")
            if purchaseButton then
                purchaseButton = purchaseButton:FindFirstChild("Main")
                if purchaseButton then
                    purchaseButton = purchaseButton:FindFirstChild("Footer")
                    if purchaseButton then
                        purchaseButton = purchaseButton:FindFirstChild("PurchaseButton")
                    end
                end
            end
        end
    end
end

if purchaseButton then
    print("✅ زر الشراء موجود!")
    
    -- استبدال وظيفة الزر
    local function hijackPurchaseButton()
        -- تعطيل الوظيفة الأصلية
        for _, connection in pairs(getconnections(purchaseButton.MouseButton1Click)) do
            connection:Disable()
        end
        
        -- وظيفة جديدة
        purchaseButton.MouseButton1Click:Connect(function()
            print("💥 زر الشراء تم اختراقه!")
            
            -- البحث عن Remote للغاتشا
            local rs = game:GetService("ReplicatedStorage")
            local foundRemote = false
            
            for _, remote in pairs(rs:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:find("gacha") or name:find("spin") or name:find("purchase") then
                        
                        -- إرسال طلب spin مجاني
                        local fakeData = {
                            action = "spin",
                            cost = 0,
                            type = "PREMIUM",
                            player = plr.Name,
                            free = true
                        }
                        
                        remote:FireServer(fakeData)
                        print("   🎯 أرسل طلب لـ: " .. remote.Name)
                        foundRemote = true
                    end
                end
            end
            
            if not foundRemote then
                -- إذا ما لقيتش remote، جرب كل الـ remotes
                for _, remote in pairs(rs:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        pcall(function()
                            remote:FireServer("GACHA_SPIN_FREE")
                        end)
                    end
                end
            end
        end)
        
        -- تغيير مظهر الزر
        purchaseButton.Text = "🎁 FREE SPIN"
        purchaseButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end
    
    -- تنفيذ الـ hijack
    hijackPurchaseButton()
    
    -- واجهة تأكيد
    local ui = Instance.new("ScreenGui")
    ui.Name = "GachaHijack"
    ui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.3, 0, 0.15, 0)
    frame.Position = UDim2.new(0.65, 0, 0.05, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
    
    local label = Instance.new("TextLabel")
    label.Text = "✅ زر الغاتشا مخترق!\nاضغط عليه للـ FREE SPINS"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextWrapped = true
    label.TextColor3 = Color3.new(1, 1, 1)
    
    label.Parent = frame
    frame.Parent = ui
    ui.Parent = gui
    
    print("🎰 زر الغاتشا جاهز للاستخدام!")
    print("💥 اضغط على PurchaseButton للحصول على spins مجانية!")
else
    print("❌ زر الشراء مش موجود")
end
