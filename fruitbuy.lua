-- 🏴‍☠️ GAMEPASS EXPLOIT SYSTEM
-- Mobile Version

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- نظام تفعيل الـ Proxies مجاناً
local function activateAllProxies()
    print("⚡ تفعيل كل الـ Proxies...")
    
    local fruits = {"Dough", "Dragon", "Kitsune", "TigerV2"}
    
    for _, fruit in pairs(fruits) do
        local fruitFolder = rs.Util.Sound.Storage:FindFirstChild(fruit)
        if fruitFolder then
            for _, proxy in pairs(fruitFolder:GetChildren()) do
                if proxy.Name:find("Proxy") then
                    pcall(function()
                        proxy:FireServer("activate")
                        print("✅ Proxy مفعل: " .. proxy.Name)
                    end)
                    task.wait(0.1)
                end
            end
        end
    end
end

-- تفعيل Passives مجاناً
local function activatePassives()
    print("🔥 تفعيل Passives...")
    
    -- Kitsune Passives
    local kitsunePassives = rs.Util.Sound.Storage.Kitsune.Fiverr:FindFirstChild("Passives- 1 Tail")
    if kitsunePassives then
        kitsunePassives:FireServer("enable")
        print("✅ Kitsune Passives مفعل")
    end
    
    -- Tiger Passives
    local tigerPassives = rs.Util.Sound.Storage.TigerV2:FindFirstChild("BF_TigerFt_AWK_PassiveFlame_Loop_01")
    if tigerPassives then
        tigerPassives:FireServer("loop")
        print("✅ Tiger Passives مفعل")
    end
end

-- تشغيل Cinematic مجاناً
local function playFreeCinematic()
    print("🎬 تشغيل Cinematic...")
    
    local cinematic = plr.PlayerScripts:FindFirstChild("LeviathanCinematicc")
    if cinematic then
        cinematic.Intro["Leviathan Intro"]:FireServer("play")
        print("✅ Cinematic مشغل")
    end
end

-- واجهة الهاتف
local ui = Instance.new("ScreenGui")
ui.Name = "GamepassExploit"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.4, 0, 0.35, 0)
main.Position = UDim2.new(0.55, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
main.Active = true
main.Draggable = true

-- أزرار
local btnProxies = Instance.new("TextButton")
btnProxies.Text = "⚡ تفعيل Proxies"
btnProxies.Size = UDim2.new(0.9, 0, 0.25, 0)
btnProxies.Position = UDim2.new(0.05, 0, 0.1, 0)
btnProxies.BackgroundColor3 = Color3.fromRGB(255, 100, 0)

local btnPassives = Instance.new("TextButton")
btnPassives.Text = "🔥 تفعيل Passives"
btnPassives.Size = UDim2.new(0.9, 0, 0.25, 0)
btnPassives.Position = UDim2.new(0.05, 0, 0.4, 0)
btnPassives.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

local btnCinematic = Instance.new("TextButton")
btnCinematic.Text = "🎬 تشغيل Cinematic"
btnCinematic.Size = UDim2.new(0.9, 0, 0.25, 0)
btnCinematic.Position = UDim2.new(0.05, 0, 0.7, 0)
btnCinematic.BackgroundColor3 = Color3.fromRGB(150, 0, 255)

-- الأحداث
btnProxies.MouseButton1Click:Connect(function()
    btnProxies.Text = "⚡ جاري..."
    task.spawn(function()
        activateAllProxies()
        task.wait(2)
        btnProxies.Text = "⚡ تفعيل Proxies"
    end)
end)

btnPassives.MouseButton1Click:Connect(function()
    btnPassives.Text = "🔥 جاري..."
    task.spawn(function()
        activatePassives()
        task.wait(2)
        btnPassives.Text = "🔥 تفعيل Passives"
    end)
end)

btnCinematic.MouseButton1Click:Connect(function()
    btnCinematic.Text = "🎬 جاري..."
    task.spawn(function()
        playFreeCinematic()
        task.wait(2)
        btnCinematic.Text = "🎬 تشغيل Cinematic"
    end)
end)

-- التجميع
btnProxies.Parent = main
btnPassives.Parent = main
btnCinematic.Parent = main
main.Parent = ui
ui.Parent = plr.PlayerGui

print("🏴‍☠️ GAMEPASS EXPLOIT SYSTEM READY!")
print("⚡ Proxies - مهارات الفواكه")
print("🔥 Passives - قدرات سلبية")
print("🎬 Cinematic - مشاهد")
