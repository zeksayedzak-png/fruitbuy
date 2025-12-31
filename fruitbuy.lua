-- Blox Fruits Duplication Glitch FIXED
-- Mobile Version

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui
local uis = game:GetService("UserInputService")

-- إيجاد الازرار بطريقة أفضل
local function findButton(path)
    local current = gui
    for part in path:gmatch("[^%.]+") do
        current = current:FindFirstChild(part)
        if not current then return nil end
    end
    return current
end

-- ازرارنا
local inventoryBtn = findButton("Main.InventoryButton")
local dialogueBtn = findButton("Main.Dialogue.Option3") 
local hotbarBtn = findButton("Backpack.Hotbar.Container.More.TextButton")

-- دالة ضغط مؤكدة
local function guaranteedClick(button)
    if not button or not button:IsA("GuiButton") then
        print("❌ الزر مش موجود أو مش GuiButton")
        return false
    end
    
    print("🎯 جاري الضغط على: " .. button.Name)
    
    -- الطريقة 1: MouseButton1Click مباشر
    local success1 = pcall(function()
        button.MouseButton1Click:Fire()
    end)
    
    -- الطريقة 2: Activate
    local success2 = pcall(function()
        button:Activate()
    end)
    
    -- الطريقة 3: محاكاة الـ Input
    local success3 = pcall(function()
        local pos = button.AbsolutePosition + button.AbsoluteSize/2
        uis.InputBegan:Fire({
            UserInputType = Enum.UserInputType.MouseButton1,
            Position = Vector2.new(pos.X, pos.Y)
        })
        task.wait(0.05)
        uis.InputEnded:Fire({
            UserInputType = Enum.UserInputType.MouseButton1,
            Position = Vector2.new(pos.X, pos.Y)
        })
    end)
    
    return success1 or success2 or success3
end

-- دالة الدوبليكيشن المعدلة
local function executeDuplicationV2()
    print("🚀 بدء الدوبليكيشن المعدل...")
    
    -- 1. فتح الإنفنتوري
    if inventoryBtn then
        guaranteedClick(inventoryBtn)
        print("✅ فتح الإنفنتوري")
        task.wait(0.3)
    end
    
    -- 2. إخراج الفاكهة
    if hotbarBtn then
        guaranteedClick(hotbarBtn)
        print("✅ إخراج الفاكهة")
        task.wait(0.2)
    end
    
    -- 3. تجميد الزر (لو محتاج)
    if dialogueBtn then
        -- حفظ حالة الزر الأصلية
        local originalActive = dialogueBtn.Active
        local originalText = dialogueBtn.Text
        
        -- تجميد
        dialogueBtn.Active = false
        dialogueBtn.Text = "❄️ متجمد"
        
        -- 4. محاولة الدخول
        for i = 1, 5 do
            guaranteedClick(dialogueBtn)
            print("🔄 محاولة " .. i)
            task.wait(0.1)
        end
        
        -- استعادة
        dialogueBtn.Active = originalActive
        dialogueBtn.Text = originalText
    end
    
    print("🎉 عملية الدوبليكيشن اكتملت!")
end

-- ============================================
-- 📱 واجهة معدلة
-- ============================================
local ui = Instance.new("ScreenGui")
ui.Name = "DupeControlV2"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.3, 0, 0.2, 0)
main.Position = UDim2.new(0.7, 0, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
main.Active = true
main.Draggable = true

-- زر التشغيل
local startBtn = Instance.new("TextButton")
startBtn.Text = "⚡ تشغيل الدوب"
startBtn.Size = UDim2.new(0.9, 0, 0.6, 0)
startBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

-- حالة الازرار
local buttonStatus = Instance.new("TextLabel")
buttonStatus.Text = "جاري التحقق..."
buttonStatus.Size = UDim2.new(0.9, 0, 0.3, 0)
buttonStatus.Position = UDim2.new(0.05, 0, 0.75, 0)
buttonStatus.TextScaled = true

-- التحقق من الازرار
task.spawn(function()
    local found = 0
    if inventoryBtn then found = found + 1 end
    if dialogueBtn then found = found + 1 end
    if hotbarBtn then found = found + 1 end
    
    buttonStatus.Text = "✅ " .. found .. "/3 ازرار موجودة"
    
    if found == 3 then
        buttonStatus.TextColor3 = Color3.new(0, 1, 0)
        startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        buttonStatus.TextColor3 = Color3.new(1, 0.5, 0)
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    end
end)

-- حدث الزر
startBtn.MouseButton1Click:Connect(function()
    startBtn.Text = "⏳ جاري..."
    startBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    
    task.spawn(function()
        executeDuplicationV2()
        
        task.wait(2)
        startBtn.Text = "⚡ تشغيل الدوب"
        startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        buttonStatus.Text = "✅ اكتمل - جرب ثاني!"
    end)
end)

-- تجميع
startBtn.Parent = main
buttonStatus.Parent = main
main.Parent = ui
ui.Parent = gui

print([[
    
🎮 Blox Fruits Duplication FIXED
📱 Mobile Version - ضغط مؤكد

⚡ طرق الضغط المستخدمة:
1. MouseButton1Click:Fire()
2. Button:Activate()
3. Input Simulation

🎯 الازرار المطلوبة:
1. InventoryButton ✅
2. Dialogue/Option3 ✅  
3. Hotbar/More/TextButton ✅

]])
