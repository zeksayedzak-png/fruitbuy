-- 💣 SYSTEM VALIDATION DESTROYER
-- Mobile Version
-- loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local gui = plr.PlayerGui

-- 🔍 إيجاد زر الشراء
local purchaseBtn = gui:WaitForChild("GachaWindow"):WaitForChild("HolidayGacha25")
    :WaitForChild("FreeToPlay"):WaitForChild("MainGachaUI")
    :WaitForChild("Main"):WaitForChild("Footer"):WaitForChild("PurchaseButton")

print("🎯 هدفنا: تدمير تحقق الـ 100 Candy")

-- نظام تدمير التحقق
local ValidationDestroyer = {
    destroyed = false,
    
    -- 1. تعطيل جميع RemoteFunctions للتحقق
    disableValidationFunctions = function(self)
        print("💀 جاري تعطيل functions التحقق...")
        
        local disabled = 0
        for _, obj in pairs(rs:GetDescendants()) do
            if obj:IsA("RemoteFunction") then
                local name = obj.Name:lower()
                
                -- إذا كان function للتحقق
                if name:find("check") or name:find("validate") or 
                   name:find("verify") or name:find("can") then
                    
                    -- استبدال الوظيفة
                    local originalInvoke = obj.InvokeServer
                    obj.InvokeServer = function(self, ...)
                        local args = {...}
                        
                        -- إذا كان يتحقق من شراء أو Candy
                        if type(args[1]) == "string" then
                            if args[1]:find("candy") or args[1]:find("purchase") or 
                               args[1]:find("buy") or args[1]:find("cost") then
                                
                                print("✅ عُطل تحقق: " .. args[1])
                                return {
                                    success = true,
                                    canProceed = true,
                                    hasEnough = true,
                                    required = 0,
                                    current = 999999
                                }
                            end
                        end
                        
                        return originalInvoke(self, ...)
                    end
                    
                    disabled = disabled + 1
                end
            end
        end
        
        print("✅ عُطلت " .. disabled .. " function للتحقق")
    end,
    
    -- 2. إيقاف RemoteEvents للتحقق
    stopValidationEvents = function(self)
        print("💀 جاري إيقاف events التحقق...")
        
        local stopped = 0
        for _, obj in pairs(rs:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                
                -- إذا كان event للتحقق قبل الشراء
                if name:find("validate") or name:find("check") or 
                   name:find("beforepurchase") or name:find("verify") then
                    
                    -- استبدال الوظيفة
                    local originalFire = obj.FireServer
                    obj.FireServer = function(self, ...)
                        local args = {...}
                        
                        -- إذا كان تحقق قبل شراء
                        if type(args[1]) == "table" and args[1].action then
                            local action = args[1].action:lower()
                            if action:find("check") or action:find("validate") then
                                print("✅ منع تحقق: " .. action)
                                return  -- لا ترسل للخادم
                            end
                        end
                        
                        return originalFire(self, ...)
                    end
                    
                    stopped = stopped + 1
                end
            end
        end
        
        print("✅ أوقفت " .. stopped .. " event للتحقق")
    end,
    
    -- 3. اختطاف زر الشراء
    hijackPurchaseButton = function(self)
        print("🎯 جاري اختطاف زر الشراء...")
        
        -- تعطيل جميع الروابط
        local connections = getconnections(purchaseBtn.MouseButton1Click)
        for _, conn in pairs(connections) do
            conn:Disable()
        end
        
        -- وظيفة جديدة قوية
        purchaseBtn.MouseButton1Click:Connect(function()
            print("💣 زر الشراء تم اختطافه!")
            
            -- إرسال شراء مباشر بدون تحقق
            self:sendDirectPurchase()
        end)
        
        -- تغيير مظهر الزر
        purchaseBtn.Text = "💣 FORCE BUY"
        purchaseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end,
    
    -- 4. إرسال شراء قسري
    sendDirectPurchase = function(self)
        print("🚀 إرسال شراء قسري...")
        
        -- بيانات الشراء القسري
        local forcedPurchase = {
            action = "force_purchase",
            item = "GACHA_SPIN",
            cost = 0,  -- مجاني
            bypass = true,
            validation = "DISABLED",
            player = plr.Name,
            timestamp = os.time(),
            receipt = "FORCED_PURCHASE_" .. math.random(100000, 999999)
        }
        
        -- أرسل لكل الـ Remotes
        local sent = 0
        for _, obj in pairs(rs:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                
                -- إذا كان مرتبط بالشراء أو الغاتشا
                if name:find("purchase") or name:find("buy") or 
                   name:find("gacha") or name:find("shop") then
                    
                    pcall(function()
                        obj:FireServer(forcedPurchase)
                        obj:FireServer("BUY_FORCE")
                        obj:FireServer("PURCHASE_FORCE")
                        sent = sent + 1
                    end)
                end
            end
        end
        
        -- إذا ما فيش remotes، أرسل لكل حاجة
        if sent == 0 then
            for _, obj in pairs(rs:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    pcall(function()
                        obj:FireServer(forcedPurchase)
                        sent = sent + 1
                    end)
                end
            end
        end
        
        print("✅ أرسل " .. sent .. " طلب شراء قسري")
    end,
    
    -- 5. تشغيل التدمير الكامل
    activateNuclearOption = function(self)
        if self.destroyed then return end
        
        print("💣 تفعيل خيار تدمير التحقق...")
        
        self:disableValidationFunctions()
        task.wait(0.5)
        
        self:stopValidationEvents()
        task.wait(0.5)
        
        self:hijackPurchaseButton()
        
        self.destroyed = true
        
        print("✅ نظام التحقق تم تدميره!")
    end
}

-- 📱 واجهة التدمير
local ui = Instance.new("ScreenGui")
ui.Name = "ValidationDestroyer"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.4, 0, 0.25, 0)
main.Position = UDim2.new(0.55, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "💣 VALIDATION DESTROYER"
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)

local nukeBtn = Instance.new("TextButton")
nukeBtn.Text = "💥 تدمير نظام التحقق"
nukeBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
nukeBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
nukeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
nukeBtn.TextColor3 = Color3.new(1, 1, 1)

local status = Instance.new("TextLabel")
status.Text = "النظام: 🟢 جاهز للتدمير\nالزر يطلب: 100 Candy"
status.Size = UDim2.new(0.9, 0, 0.2, 0)
status.Position = UDim2.new(0.05, 0, 0.85, 0)
status.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
status.TextColor3 = Color3.new(1, 1, 1)
status.TextWrapped = true

-- حدث التدمير
nukeBtn.MouseButton1Click:Connect(function()
    nukeBtn.Text = "💀 جاري التدمير..."
    status.Text = "💣 يعطل التحقق والـ Validation..."
    
    task.spawn(function()
        ValidationDestroyer:activateNuclearOption()
        
        task.wait(2)
        nukeBtn.Text = "✅ تم التدمير"
        nukeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        status.Text = "✅ النظام دُمّر!\nاضغط على PurchaseButton!"
        
        -- تغيير زر الشراء الأصلي
        if purchaseBtn then
            purchaseBtn.Text = "💣 FORCE BUY"
        end
    end)
end)

-- التجميع
title.Parent = main
nukeBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = gui

print("💣 VALIDATION DESTROYER - READY!")
print("🎯 الهدف: تدمير تحقق الـ 100 Candy")
print("💀 يعطل RemoteFunctions")
print("🛑 يوقف RemoteEvents")
print("💣 يختطف زر الشراء")
print("🚀 يرسل شراء قسري")
