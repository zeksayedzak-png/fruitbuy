-- 🚀 PREVIEW BUTTON SPAMMER
-- Mobile Version
-- loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

-- 🔍 إيجاد PreviewButton
local function findPreviewButton()
    local target = gui
    
    local path = {
        "GachaWindow", 
        "HolidayGacha25", 
        "Premium", 
        "MainGachaUI", 
        "PurchaseFooter", 
        "PreviewButton"
    }
    
    for _, folder in ipairs(path) do
        target = target:FindFirstChild(folder)
        if not target then
            return nil
        end
    end
    
    return target
end

-- 🚀 نظام الضغط السريع
local PreviewSpammer = {
    previewButton = nil,
    spamming = false,
    speed = 100, -- مرة في الثانية
    totalClicks = 0,
    
    -- 1. تهيئة النظام
    setup = function(self)
        self.previewButton = findPreviewButton()
        
        if not self.previewButton then
            print("❌ PreviewButton مش موجود")
            return false
        end
        
        print("✅ PreviewButton وجد: " .. self.previewButton:GetFullName())
        return true
    end,
    
    -- 2. تعطيل التحقق الأصلي
    disableOriginal = function(self)
        if not self.previewButton then return end
        
        -- تعطيل كل الروابط الأصلية
        local connections = getconnections(self.previewButton.MouseButton1Click)
        for _, conn in pairs(connections) do
            conn:Disable()
        end
        
        print("✅ عُطلت الوظيفة الأصلية")
    end,
    
    -- 3. دالة الضغط الواحدة
    singleClick = function(self)
        if not self.previewButton then return end
        
        -- محاكاة الضغط
        pcall(function()
            -- الطريقة 1: Fire مباشر
            self.previewButton:Fire("click")
            
            -- الطريقة 2: MouseButton1Click
            self.previewButton.MouseButton1Click:Fire()
            
            -- الطريقة 3: Activate
            self.previewButton:Activate()
            
            self.totalClicks = self.totalClicks + 1
        end)
    end,
    
    -- 4. الضغط السريع
    rapidFire = function(self)
        self.spamming = true
        self.totalClicks = 0
        
        print("🚀 بدء الضغط السريع...")
        
        -- حساب الوقت بين كل ضغطة (100/ثانية = 0.01 ثانية)
        local interval = 1 / self.speed
        
        while self.spamming do
            -- ضغط متعدد في نفس الإطار
            for i = 1, 10 do
                task.spawn(function()
                    self:singleClick()
                end)
            end
            
            task.wait(interval)
        end
    end,
    
    -- 5. إيقاف الضغط
    stopSpam = function(self)
        self.spamming = false
        print("⏹️ توقف الضغط - " .. self.totalClicks .. " ضغطة")
    end,
    
    -- 6. تشغيل النظام
    executeSpam = function(self, duration)
        if not self:setup() then return end
        
        self:disableOriginal()
        
        -- تغيير لون الزر للتحضير
        self.previewButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        self.previewButton.Text = "💣 SPAMMING..."
        
        -- بدء الضغط
        task.spawn(function()
            self:rapidFire()
        end)
        
        -- إيقاف بعد المدة
        if duration then
            task.wait(duration)
            self:stopSpam()
            
            -- إعادة الزر لحالته
            self.previewButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            self.previewButton.Text = ""
        end
    end
}

-- 📱 واجهة الضغط السريع
local ui = Instance.new("ScreenGui")
ui.Name = "PreviewSpammerUI"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.4, 0, 0.35, 0)
main.Position = UDim2.new(0.55, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.Active = true
main.Draggable = true

-- العنوان
local title = Instance.new("TextLabel")
title.Text = "🚀 PREVIEW SPAMMER"
title.Size = UDim2.new(1, 0, 0.15, 0)
title.BackgroundColor3 = Color3.fromRGB(255, 100, 0)

-- إعدادات السرعة
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "السرعة: 100 ضغطة/ثانية"
speedLabel.Size = UDim2.new(1, 0, 0.1, 0)
speedLabel.Position = UDim2.new(0, 0, 0.16, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)

-- زر البدء السريع
local startBtn = Instance.new("TextButton")
startBtn.Text = "🚀 ابدأ الضغط السريع"
startBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
startBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

-- زر الإيقاف
local stopBtn = Instance.new("TextButton")
stopBtn.Text = "⏹️ إيقاف الضغط"
stopBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
stopBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stopBtn.Visible = false

-- العداد
local counter = Instance.new("TextLabel")
counter.Text = "الضغطات: 0"
counter.Size = UDim2.new(0.9, 0, 0.15, 0)
counter.Position = UDim2.new(0.05, 0, 0.8, 0)
counter.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
counter.TextColor3 = Color3.new(1, 1, 1)

-- تحديث العداد
game:GetService("RunService").Heartbeat:Connect(function()
    counter.Text = "الضغطات: " .. PreviewSpammer.totalClicks
end)

-- أحداث الأزرار
startBtn.MouseButton1Click:Connect(function()
    startBtn.Text = "💣 جاري الضغط..."
    startBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    stopBtn.Visible = true
    
    task.spawn(function()
        PreviewSpammer:executeSpam()
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    PreviewSpammer:stopSpam()
    
    startBtn.Text = "🚀 ابدأ الضغط السريع"
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    stopBtn.Visible = false
    
    -- إعادة زر PreviewButton الأصلي
    if PreviewSpammer.previewButton then
        PreviewSpammer.previewButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        PreviewSpammer.previewButton.Text = ""
    end
end)

-- تعديل السرعة
local speedSlider = Instance.new("TextButton")
speedSlider.Text = "⚡ تغيير السرعة"
speedSlider.Size = UDim2.new(0.9, 0, 0.15, 0)
speedSlider.Position = UDim2.new(0.05, 0, 0.1, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(100, 100, 200)

speedSlider.MouseButton1Click:Connect(function()
    PreviewSpammer.speed = PreviewSpammer.speed + 50
    if PreviewSpammer.speed > 500 then
        PreviewSpammer.speed = 50
    end
    
    speedLabel.Text = "السرعة: " .. PreviewSpammer.speed .. " ضغطة/ثانية"
end)

-- التجميع
title.Parent = main
speedSlider.Parent = main
speedLabel.Parent = main
startBtn.Parent = main
stopBtn.Parent = main
counter.Parent = main
main.Parent = ui
ui.Parent = gui

-- تهيئة النظام
task.spawn(function()
    task.wait(2)
    if PreviewSpammer:setup() then
        print("✅ PreviewSpammer جاهز!")
        title.Text = "🚀 PREVIEW SPAMMER - READY"
        title.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        title.Text = "❌ PREVIEW SPAMMER - ERROR"
        title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

print("🚀 PREVIEW SPAMMER - READY!")
print("🎯 الهدف: PreviewButton")
print("⚡ السرعة: 100 ضغطة/ثانية")
print("💥 يضغط بسرعة خيالية")
