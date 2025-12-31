-- Blox Fruits Auto Gift Opener
-- ضع هذا الكود كاملاً في الـ loadstring

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

-- إعدادات السكربت
local AUTO_OPEN = true
local OPEN_SPEED = 1 -- ثانية بين كل محاولة

-- واجهة الهاتف
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoGiftBloxFruits"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.8, 0, 0.25, 0)
mainFrame.Position = UDim2.new(0.1, 0, 0.7, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 100, 150)

local title = Instance.new("TextLabel")
title.Text = "🎁 AUTO GIFT OPENER"
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "🔍 جاري البحث عن RF/GiftFunction..."
statusLabel.Size = UDim2.new(1, 0, 0.3, 0)
statusLabel.Position = UDim2.new(0, 0, 0.25, 0)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextWrapped = true

local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "⏸ إيقاف"
toggleBtn.Size = UDim2.new(0.45, 0, 0.25, 0)
toggleBtn.Position = UDim2.new(0.025, 0, 0.6, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16

local infoBtn = Instance.new("TextButton")
infoBtn.Text = "ℹ️ معلومات"
infoBtn.Size = UDim2.new(0.45, 0, 0.25, 0)
infoBtn.Position = UDim2.new(0.525, 0, 0.6, 0)
infoBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
infoBtn.TextColor3 = Color3.new(1, 1, 1)
infoBtn.Font = Enum.Font.SourceSansBold
infoBtn.TextSize = 16

-- تجميع الواجهة
title.Parent = mainFrame
statusLabel.Parent = mainFrame
toggleBtn.Parent = mainFrame
infoBtn.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = player:WaitForChild("PlayerGui")

-- البحث عن الـ GiftFunction
local giftFunction
local function findFunction()
    local modules = ReplicatedStorage:FindFirstChild("Modules")
    if modules then
        local net = modules:FindFirstChild("Net")
        if net then
            giftFunction = net:FindFirstChild("RF/GiftFunction")
            if giftFunction then
                statusLabel.Text = "✅ وجدت RF/GiftFunction!\nجاري فتح الهدايا..."
                statusLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                return true
            end
        end
    end
    return false
end

-- محاولة فتح الهدايا
local connection
local function startAutoOpen()
    if not giftFunction or not giftFunction:IsA("RemoteFunction") then
        statusLabel.Text = "❌ RF/GiftFunction غير موجود!"
        statusLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        return
    end
    
    AUTO_OPEN = true
    toggleBtn.Text = "⏸ إيقاف"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    if connection then
        connection:Disconnect()
    end
    
    connection = RunService.Heartbeat:Connect(function()
        if AUTO_OPEN then
            pcall(function()
                giftFunction:InvokeServer()
                statusLabel.Text = "🎁 جاري فتح الهدايا..."
            end)
            wait(OPEN_SPEED)
        end
    end)
end

local function stopAutoOpen()
    AUTO_OPEN = false
    toggleBtn.Text = "▶ تشغيل"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    if connection then
        connection:Disconnect()
    end
    statusLabel.Text = "⏸ توقف فتح الهدايا"
end

-- أحداث الأزرار
toggleBtn.MouseButton1Click:Connect(function()
    if AUTO_OPEN then
        stopAutoOpen()
    else
        startAutoOpen()
    end
end)

infoBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "📱 السكربت يعمل على الهاتف\n⚡ فتح الهدايا تلقائياً\n🔄 اضغط التشغيل/الإيقاف"
    wait(3)
    if giftFunction then
        statusLabel.Text = "✅ RF/GiftFunction جاهز!\n🎁 اضغط التشغيل لبدء الفتح"
    end
end)

-- البدء التلقائي
task.wait(2)
if findFunction() then
    startAutoOpen()
else
    statusLabel.Text = "❌ لم أجد RF/GiftFunction\n🔍 أعد المحاولة لاحقاً"
end

print("🎁 Blox Fruits Auto Gift Opener - جاهز!")
print("📱 يعمل على الهاتف")
