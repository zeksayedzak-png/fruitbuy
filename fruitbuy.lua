-- 🔥 PROXY SYSTEM EXPLOIT
-- Mobile Version
-- loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- نظام اختراق الـ Proxy
local ProxyHack = {
    mainProxy = rs.Util.Misc.Proxy,
    proxyEmitter = rs.Util.ProxyEmitter,
    
    -- 1. هجوم مباشر على الـ Proxy
    attackMainProxy = function(self)
        print("💣 هجوم على Main Proxy...")
        
        if not self.mainProxy then
            print("❌ Main Proxy مش موجود")
            return 0
        end
        
        local attacks = 0
        
        -- أوامر شراء Gamepasses
        local gamepassCommands = {
            {cmd = "Purchase", data = {productId = 123, price = 0}},
            {cmd = "BuyGamepass", data = {gamepass = "ALL", cost = 0}},
            {cmd = "UnlockPremium", data = {player = plr}},
            {cmd = "GetAllPasses", data = {userId = plr.UserId}}
        }
        
        for _, command in ipairs(gamepassCommands) do
            pcall(function()
                self.mainProxy:FireServer(command.cmd, command.data)
                attacks = attacks + 1
                print("   ✅ أرسل: " .. command.cmd)
            end)
            task.wait(0.1)
        end
        
        -- أوامر العملات
        local currencyCommands = {
            {cmd = "AddBeli", amount = 9999999},
            {cmd = "AddFragments", amount = 99999},
            {cmd = "AddMoney", amount = 999999999},
            {cmd = "SetCurrency", amount = 1000000}
        }
        
        for _, command in ipairs(currencyCommands) do
            pcall(function()
                self.mainProxy:FireServer(command.cmd, {
                    player = plr,
                    amount = command.amount,
                    source = "proxy_hack"
                })
                attacks = attacks + 1
                print("   💰 أرسل: " .. command.cmd)
            end)
            task.wait(0.1)
        end
        
        return attacks
    end,
    
    -- 2. استغلال ProxyEmitter
    exploitProxyEmitter = function(self)
        print("📡 استغلال ProxyEmitter...")
        
        if not self.proxyEmitter then
            print("❌ ProxyEmitter مش موجود")
            return 0
        end
        
        local emissions = 0
        
        -- إرسال إشارات مزيفة
        local fakeEmissions = {
            {
                event = "SystemNotification",
                message = "🎁 FREE GAMEPASS ACTIVATED!",
                type = "success"
            },
            {
                event = "PurchaseVerified",
                verified = true,
                amount = 0,
                product = "ALL_GAMEPASSES"
            },
            {
                event = "DataUpdate",
                beli = 9999999,
                fragments = 99999,
                fruits = "ALL"
            },
            {
                event = "AdminCommand",
                command = "give_all",
                target = plr.Name
            }
        }
        
        for _, emission in ipairs(fakeEmissions) do
            pcall(function()
                self.proxyEmitter:FireServer("Emit", emission)
                emissions = emissions + 1
                print("   📤 أرسل إشعار: " .. emission.event)
            end)
            task.wait(0.1)
        end
        
        return emissions
    end,
    
    -- 3. تشغيل الهجوم الكامل
    executeFullAttack = function(self)
        print("🚀 بدء الهجوم الكامل على نظام الـ Proxy...")
        
        local totalAttacks = 0
        
        -- المرحلة 1: Main Proxy
        local proxyAttacks = self:attackMainProxy()
        totalAttacks = totalAttacks + proxyAttacks
        
        task.wait(1)
        
        -- المرحلة 2: ProxyEmitter
        local emitterAttacks = self:exploitProxyEmitter()
        totalAttacks = totalAttacks + emitterAttacks
        
        -- المرحلة 3: هجوم إضافي
        print("💥 هجوم إضافي على كل الـ Remotes...")
        
        for _, obj in pairs(rs:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                if name:find("proxy") or name:find("emitter") then
                    pcall(function()
                        obj:FireServer("FORCE_UNLOCK")
                        totalAttacks = totalAttacks + 1
                    end)
                end
            end
        end
        
        return totalAttacks
    end
}

-- 📱 واجهة التحكم
local ui = Instance.new("ScreenGui")
ui.Name = "ProxyHackUI"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.35, 0, 0.25, 0)
main.Position = UDim2.new(0.6, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "🔥 PROXY SYSTEM HACK"
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundColor3 = Color3.fromRGB(150, 0, 150)

local attackBtn = Instance.new("TextButton")
attackBtn.Text = "💣 اختراق نظام الـ Proxy"
attackBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
attackBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
attackBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

local status = Instance.new("TextLabel")
status.Text = "🎯 Main Proxy موجود\n📡 ProxyEmitter جاهز"
status.Size = UDim2.new(0.9, 0, 0.2, 0)
status.Position = UDim2.new(0.05, 0, 0.85, 0)
status.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
status.TextWrapped = true

-- التحقق من وجود الـ Proxies
task.spawn(function()
    if ProxyHack.mainProxy then
        status.Text = status.Text .. "\n✅ Main Proxy: OK"
    else
        status.Text = status.Text .. "\n❌ Main Proxy: MISSING"
    end
    
    if ProxyHack.proxyEmitter then
        status.Text = status.Text .. "\n✅ ProxyEmitter: OK"
    else
        status.Text = status.Text .. "\n❌ ProxyEmitter: MISSING"
    end
end)

-- حدث الهجوم
attackBtn.MouseButton1Click:Connect(function()
    attackBtn.Text = "💣 جاري الاختراق..."
    status.Text = "🚀 يهاجم نظام الـ Proxy..."
    
    task.spawn(function()
        local totalAttacks = ProxyHack:executeFullAttack()
        
        attackBtn.Text = "✅ تم الاختراق"
        attackBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        status.Text = "🎉 " .. totalAttacks .. " هجوم ناجح!\nتحقق من مكافآتك!"
    end)
end)

-- التجميع
title.Parent = main
attackBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = plr.PlayerGui

print("🔥 PROXY SYSTEM HACK - READY!")
print("🎯 Main Proxy: نظام الوساطة الرئيسي")
print("📡 ProxyEmitter: مُرسل الإشارات")
print("💥 يهاجم قلب النظام مباشرة")
