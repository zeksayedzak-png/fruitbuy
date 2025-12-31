-- Blox Fruits Mobile Duplication Glitch
-- يعمل على الهاتف - واجهة صغيرة

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

-- إيجاد الازرار المهمة
local inventoryBtn = gui:WaitForChild("Main"):WaitForChild("InventoryButton")
local dialogueBtn = gui:WaitForChild("Main"):WaitForChild("Dialogue"):WaitForChild("Option3")
local hotbarBtn = gui:WaitForChild("Backpack"):WaitForChild("Hotbar"):WaitForChild("Container"):WaitForChild("More"):WaitForChild("TextButton")

-- حالة التجميد
local freezeActive = false
local freezeConnection = nil

-- دالة التجميد
local function freezeDialogueButton()
    if freezeActive then return end
    
    freezeActive = true
    print("❄️ زر Dialogue متجمد!")
    
    -- حفظ الوضع الأصلي
    local originalVisible = dialogueBtn.Visible
    local originalActive = dialogueBtn.Active
    local originalText = dialogueBtn.Text
    
    -- التجميد: جعل الزر غير نشط لكن مرئي
    dialogueBtn.Active = false
    dialogueBtn.Text = "⌛ Loading..."
    
    freezeConnection = game:GetService("RunService").Heartbeat:Connect(function()
        -- إعادة تعيين الخصائص باستمرار لمنع أي تغيير
        dialogueBtn.Active = false
        dialogueBtn.AutoButtonColor = false
        dialogueBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)
    
    return {
        originalVisible = originalVisible,
        originalActive = originalActive,
        originalText = originalText
    }
end

-- دالة فك التجميد
local function unfreezeDialogueButton(originalSettings)
    if not freezeActive then return end
    
    freezeActive = false
    if freezeConnection then
        freezeConnection:Disconnect()
        freezeConnection = nil
    end
    
    -- استعادة الإعدادات الأصلية
    dialogueBtn.Active = originalSettings.originalActive
    dialogueBtn.AutoButtonColor = true
    dialogueBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dialogueBtn.Text = originalSettings.originalText
    
    print("✅ تم فك تجميد الزر!")
end

-- دالة تنفيذ الدوبليكيشن
local function executeDuplication()
    print("🚀 بدء عملية الدوبليكيشن...")
    
    -- الخطوة 1: تجميد زر Dialogue
    local originalSettings = freezeDialogueButton()
    
    -- الخطوة 2: فتح الإنفنتوري
    inventoryBtn:Fire("click")
    task.wait(0.2)
    
    -- الخطوة 3: الضغط على زر الهوتبار (إخراج الفاكهة)
    hotbarBtn:Fire("click")
    print("🎯 تم إخراج الفاكهة من الهوتبار")
    
    -- الخطوة 4: محاولة الدخول بالمزر المجمد
    for i = 1, 10 do
        dialogueBtn:Fire("click")
        task.wait(0.05)
    end
    
    -- الخطوة 5: فك التجميد
    task.wait(0.5)
    unfreezeDialogueButton(originalSettings)
    
    -- الخطوة 6: التحقق
    task.wait(1)
    print("🎉 عملية الدوبليكيشن مكتملة!")
    print("🔍 تحقق من إن الفاكهة اتكررت!")
end

-- ============================================
-- 📱 واجهة الهاتف الصغيرة
-- ============================================
local ui = Instance.new("ScreenGui")
ui.Name = "DuplicationControl"
ui.ResetOnSpawn = false

-- الإطار الرئيسي (صغير ومتحرك)
local main = Instance.new("Frame")
main.Size = UDim2.new(0.25, 0, 0.15, 0)
main.Position = UDim2.new(0.75, 0, 0.05, 0) -- أعلى اليمين
main.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
main.BackgroundTransparency = 0.2
main.Active = true
main.Draggable = true -- قابل للسحب بالإصبع

-- زر التشغيل/الإيقاف
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Text = "▶ تشغيل الدوب"
toggleBtn.Size = UDim2.new(0.9, 0, 0.6, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextScaled = true -- ليناسب الشاشة الصغيرة

-- مؤشر الحالة
local status = Instance.new("TextLabel")
status.Name = "Status"
status.Text = "🟢 جاهز"
status.Size = UDim2.new(0.9, 0, 0.3, 0)
status.Position = UDim2.new(0.05, 0, 0.75, 0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)
status.TextScaled = true
status.Font = Enum.Font.SourceSans

-- إضافة العناصر
toggleBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = gui

-- حدث زر التشغيل/الإيقاف
toggleBtn.MouseButton1Click:Connect(function()
    if toggleBtn.Text == "▶ تشغيل الدوب" then
        -- وضع التشغيل
        toggleBtn.Text = "⏸ إيقاف الدوب"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "⚡ جاري التنفيذ..."
        
        task.spawn(function()
            executeDuplication()
            
            task.wait(2)
            toggleBtn.Text = "▶ تشغيل الدوب"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            status.Text = "✅ اكتمل!"
            
            task.wait(2)
            status.Text = "🟢 جاهز"
        end)
    else
        -- وضع الإيقاف
        toggleBtn.Text = "▶ تشغيل الدوب"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        status.Text = "⏹ متوقف"
    end
end)

-- زر إخفاء/إظهار (للتحكم)
local hideBtn = Instance.new("TextButton")
hideBtn.Text = "✖"
hideBtn.Size = UDim2.new(0.1, 0, 0.15, 0)
hideBtn.Position = UDim2.new(0.9, 0, 0, 0)
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.Parent = main

hideBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- جعل الواجهة دائماً فوق كل شيء
local alwaysOnTop = Instance.new("BoolValue")
alwaysOnTop.Name = "AlwaysOnTop"
alwaysOnTop.Value = true
alwaysOnTop.Parent = main

-- ============================================
-- 📢 رسالة البدء
-- ============================================
print([[
    
🎮 Blox Fruits Duplication Glitch
📱 Mobile Version - واجهة صغيرة

🎯 الأزرار المكتشفة:
1. InventoryButton: فتح الشنطة
2. Dialogue/Option3: إدخال الفاكهة
3. Hotbar/More: إخراج الفاكهة

⚡ الاستخدام:
1. اضغط "تشغيل الدوب"
2. انتظر اكتمال العملية
3. تحقق من تكرار الفاكهة

🔄 السحب بالإصبع متاح لتحريك الواجهة
✖ زر الإخفاء في الأعلى

]])

-- تأكيد أن الازرار موجودة
if inventoryBtn and dialogueBtn and hotbarBtn then
    print("✅ جميع الأزرار موجودة!")
    status.Text = "✅ جاهز - كل الأزرار OK"
else
    print("⚠️ بعض الأزرار مفقودة!")
    status.Text = "⚠️ أزرار مفقودة!"
end
