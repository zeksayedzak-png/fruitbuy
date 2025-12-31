-- ============================================
-- 🎮 DUPEGOD SYSTEM: Freeze + Duplication
-- ============================================

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

-- الأزرار
local inventoryBtn = gui:WaitForChild("Main"):WaitForChild("InventoryButton")
local dialogueBtn = gui:WaitForChild("Main"):WaitForChild("Dialogue"):WaitForChild("Option3")
local hotbarBtn = gui:WaitForChild("Backpack"):WaitForChild("Hotbar"):WaitForChild("Container"):WaitForChild("More"):WaitForChild("TextButton")

-- نظام التجميد المتقدم
local FreezeSystem = {
    active = false,
    freezeTime = 0.3, -- ثلث ثانية تجميد
    originalProperties = {},
    
    freeze = function(self, button)
        if self.active then return end
        
        print("❄️ جاري تجميد الزر: " .. button.Name)
        self.active = true
        
        -- حفظ الخصائص الأصلية
        self.originalProperties = {
            active = button.Active,
            autoButtonColor = button.AutoButtonColor,
            backgroundColor = button.BackgroundColor3,
            text = button.Text,
            textColor = button.TextColor3
        }
        
        -- التجميد الفعلي
        button.Active = false
        button.AutoButtonColor = false
        button.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        button.Text = "❄️ FROZEN"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- منع أي ضغط
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Disable()
        end
        
        -- مؤقت التجميد
        task.spawn(function()
            task.wait(self.freezeTime)
            self:unfreeze(button)
        end)
    end,
    
    unfreeze = function(self, button)
        if not self.active then return end
        
        print("✅ فك تجميد الزر")
        
        -- استعادة الخصائص
        button.Active = self.originalProperties.active
        button.AutoButtonColor = self.originalProperties.autoButtonColor
        button.BackgroundColor3 = self.originalProperties.backgroundColor
        button.Text = self.originalProperties.text
        button.TextColor3 = self.originalProperties.textColor
        
        -- إعادة تفعيل الضغط
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Enable()
        end
        
        self.active = false
    end
}

-- ============================================
-- 🎯 عملية الدوبليكيشن بالتجميد
-- ============================================

local function executePerfectDuplication()
    print("\n" .. string.rep("=", 50))
    print("🎮 DUPEGOD SYSTEM ACTIVATED")
    print(string.rep("=", 50))
    
    -- 🔄 الخطوة 1: فتح الشنطة
    print("1. 📦 فتح الإنفنتوري...")
    guaranteedClick(inventoryBtn)
    task.wait(0.3)
    
    -- 🔄 الخطوة 2: إخراج الفاكهة
    print("2. 🎯 إخراج الفاكهة من الهوتبار...")
    guaranteedClick(hotbarBtn)
    task.wait(0.1)
    
    -- 🔄 الخطوة 3: التجميد في اللحظة الحرجة
    print("3. ❄️ تجميد زر الدخول في اللحظة الحرجة...")
    
    -- هنا الفاكهة خرجت لكن لسة ما دخلتش الشنطة
    -- النظام بيحسب إن الفاكهة في حالة "انتقال"
    FreezeSystem:freeze(dialogueBtn)
    
    -- 🔄 الخطوة 4: محاولة إدخال بالفريز
    print("4. ⚡ محاولة إدخال أثناء التجميد...")
    
    -- أول محاولة (أثناء التجميد)
    for i = 1, 3 do
        pcall(function()
            dialogueBtn.MouseButton1Click:Fire()
        end)
        task.wait(0.05)
    end
    
    -- 🔄 الخطوة 5: فك التجميد بسرعة
    task.wait(0.15)
    FreezeSystem:unfreeze(dialogueBtn)
    
    -- 🔄 الخطوة 6: محاولة إدخال ثانية
    print("5. 🔄 محاولة إدخال بعد فك التجميد...")
    for i = 1, 3 do
        guaranteedClick(dialogueBtn)
        task.wait(0.05)
    end
    
    -- 🔄 الخطوة 7: التهيئة
    print("6. 🎉 إكمال العملية...")
    task.wait(0.3)
    
    -- 🔄 الخطوة 8: إغلاق الشنطة وفتحها للتحقق
    guaranteedClick(inventoryBtn) -- إغلاق
    task.wait(0.2)
    guaranteedClick(inventoryBtn) -- فتح
    
    print("\n✅ العملية اكتملت!")
    print("🔍 تحقق من عدد الفاكهة في الشنطة")
    print(string.rep("=", 50))
end

-- ============================================
-- 🎯 نظام التوقيت الذكي
-- ============================================

local function smartTimingDuplication()
    -- هذا النظام بيحسب التوقيت بدقة
    local timings = {
        openInventory = 0.3,
        extractFruit = 0.1,
        freezeStart = 0.15, -- بعد 0.15 ثانية من الإخراج
        freezeDuration = 0.25,
        attemptDuringFreeze = 0.05,
        attemptAfterFreeze = 0.1
    }
    
    print("⏱️ نظام التوقيت الذكي مفعل")
    
    -- التسلسل الزمني
    local timeline = game:GetService("RunService").Heartbeat:Connect(function(delta)
        -- هنا ممكن نتحكم في كل خطوة بدقة
    end)
    
    executePerfectDuplication()
end

-- ============================================
-- 📱 واجهة DUPEGOD
-- ============================================

local dupeUI = Instance.new("ScreenGui")
dupeUI.Name = "DupeGodUI"
dupeUI.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.3, 0, 0.25, 0)
mainFrame.Position = UDim2.new(0.7, 0, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
mainFrame.Active = true
mainFrame.Draggable = true

-- زر التجميد فقط
local freezeBtn = Instance.new("TextButton")
freezeBtn.Text = "❄️ تجميد زر الدخول"
freezeBtn.Size = UDim2.new(0.9, 0, 0.3, 0)
freezeBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
freezeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

-- زر الدوب الكامل
local dupeBtn = Instance.new("TextButton")
dupeBtn.Text = "🎮 تشغيل دوبليكيشن كامل"
dupeBtn.Size = UDim2.new(0.9, 0, 0.3, 0)
dupeBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
dupeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)

-- إعدادات التجميد
local freezeSlider = Instance.new("TextLabel")
freezeSlider.Text = "⏱️ وقت التجميد: 0.3s"
freezeSlider.Size = UDim2.new(0.9, 0, 0.15, 0)
freezeSlider.Position = UDim2.new(0.05, 0, 0.8, 0)
freezeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

-- الأحداث
freezeBtn.MouseButton1Click:Connect(function()
    FreezeSystem:freeze(dialogueBtn)
    task.wait(FreezeSystem.freezeTime)
    FreezeSystem:unfreeze(dialogueBtn)
end)

dupeBtn.MouseButton1Click:Connect(function()
    dupeBtn.Text = "⚡ جاري..."
    task.spawn(function()
        executePerfectDuplication()
        task.wait(2)
        dupeBtn.Text = "🎮 تشغيل دوبليكيشن كامل"
    end)
end)

-- التحكم في وقت التجميد
freezeSlider.MouseButton1Click:Connect(function()
    FreezeSystem.freezeTime = FreezeSystem.freezeTime + 0.1
    if FreezeSystem.freezeTime > 1 then
        FreezeSystem.freezeTime = 0.1
    end
    freezeSlider.Text = "⏱️ وقت التجميد: " .. FreezeSystem.freezeTime .. "s"
end)

-- التجميع
freezeBtn.Parent = mainFrame
dupeBtn.Parent = mainFrame
freezeSlider.Parent = mainFrame
mainFrame.Parent = dupeUI
dupeUI.Parent = gui

-- ============================================
-- 📢 التعليمات
-- ============================================
print([[
    
🎮 DUPEGOD SYSTEM INSTRUCTIONS:

1. ❄️ زر "تجميد زر الدخول"
   - بيجمد الزر فقط للاختبار

2. 🎮 زر "تشغيل دوبليكيشن كامل"
   - بتنفيذ العملية كاملة:
     • فتح الشنطة
     • إخراج الفاكهة  
     • تجميد في اللحظة الحرجة
     • محاولات إدخال متعددة
     • تحقق من النتيجة

3. ⏱️ وقت التجميد
   - اضغط على الوقت لتغييره (0.1s - 1s)

🎯 الفكرة: تجميد الزر في اللحظة اللي الفاكهة
          بتكون فيها خارج الهوتبار لكن
          لسة ما دخلتش الشنطة!

]])
