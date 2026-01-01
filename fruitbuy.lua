-- ============================================
-- 🧠 QUANTUM FRUIT DUPLICATION
-- ============================================

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local gui = plr.PlayerGui

-- إيجاد النظام الأساسي
local inventorySystem = rs:FindFirstChild("InventorySystem") 
local fruitSystem = rs:FindFirstChild("FruitSystem")
local dataSystem = rs:FindFirstChild("DataSystem")

-- الحالات الكمومية للفاكهة
local QuantumFruit = {
    states = {
        "Hotbar",      -- الحالة 1
        "Transition",  -- الحالة 2 (الحرجة)
        "Inventory"    -- الحالة 3
    },
    currentState = 1,
    superposition = false, -- تراكب كمي
    entangled = false      -- تشابك كمي
}

-- ============================================
-- 🎯 الخطة العميقة: Superposition
-- ============================================

local function quantumSuperposition()
    print("🌀 تفعيل التراكب الكمومي للفاكهة...")
    
    -- جعل الفاكهة في حالتين معاً
    QuantumFruit.superposition = true
    
    -- 1. أرسل للسيرفر إن الفاكهة في الهوتبار
    if inventorySystem then
        inventorySystem:FireServer("UpdateFruitLocation", {
            fruitName = "Dragon",
            location = "Hotbar",
            player = plr
        })
    end
    
    -- 2. في نفس الوقت، أرسل إنها في الشنطة
    task.spawn(function()
        inventorySystem:FireServer("UpdateFruitLocation", {
            fruitName = "Dragon", 
            location = "Inventory",
            player = plr
        })
    end)
    
    -- 3. جعل النظام في حيرة
    for i = 1, 10 do
        local randomState = math.random(1, 3)
        inventorySystem:FireServer("FruitState", {
            state = QuantumFruit.states[randomState],
            timestamp = os.time() + i * 0.001
        })
        task.wait(0.01)
    end
end

-- ============================================
-- 🎯 الخطة: Memory Address Freeze
-- ============================================

local function memoryAddressFreeze()
    print("💾 تجميد عنوان الذاكرة...")
    
    -- نظرية: كل فاكهة ليها ID في الذاكرة
    -- لو وقفنا تحديث هذا ID، الفاكهة ممكن تتكرر
    
    -- 1. إيجاد الـ Remotes المسؤولة عن تحديث البيانات
    local updateRemotes = {}
    for _, obj in pairs(rs:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            if name:find("update") or name:find("refresh") then
                table.insert(updateRemotes, obj)
            end
        end
    end
    
    -- 2. إرسال بيانات تجميد
    local freezeData = {
        action = "freeze",
        timestamp = os.time(),
        duration = 999,
        target = "fruit_data"
    }
    
    for _, remote in pairs(updateRemotes) do
        for i = 1, 5 do
            remote:FireServer(freezeData)
            task.wait(0.02)
        end
    end
end

-- ============================================
-- 🎯 الخطة: Packet Interception & Duplication
-- ============================================

local function packetInterception()
    print("📦 اعتراض وتكرار الباكيتات...")
    
    -- نظرية: لو اعترضنا باكيت "الفاكهة خرجت" وكررناه
    -- النظام هيحسب إن الفاكهة اتكررت
    
    -- محاكاة اعتراض الباكيتات
    local interceptedPackets = {}
    
    -- مراقبة كل الـ Remotes
    for _, remote in pairs(rs:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            -- حفظ الوظيفة الأصلية
            local originalFire = remote.FireServer
            
            -- استبدالها بوظيفة تعترض
            remote.FireServer = function(self, ...)
                local args = {...}
                
                -- إذا كان الباكيت عن الفاكهة
                if type(args[1]) == "table" and args[1].fruit then
                    print("🎯 اعترض باكيت فاكهة:", args[1].fruit)
                    
                    -- حفظ الباكيت
                    table.insert(interceptedPackets, {
                        remote = remote,
                        data = args[1],
                        time = os.time()
                    })
                    
                    -- إرسال الباكيت الأصلي
                    originalFire(self, ...)
                    
                    -- بعد 0.05 ثانية، أرسل نسخة منه
                    task.wait(0.05)
                    print("🔄 إرسال نسخة مكررة...")
                    originalFire(self, ...)
                    
                    return
                end
                
                -- إرسال عادي لباقي الباكيتات
                originalFire(self, ...)
            end
        end
    end
end

-- ============================================
-- 🎯 الخطة: Time Glitch
-- ============================================

local function timeGlitch()
    print("⏰ خدعة الزمن...")
    
    -- خدعة: جعل النظام يحسب الوقت غلط
    
    -- 1. أرسل بيانات ب timestamp قديم
    local oldData = {
        action = "add_fruit",
        fruit = "Dragon",
        timestamp = os.time() - 3600, -- قبل ساعة
        location = "Inventory"
    }
    
    -- 2. أرسل بيانات بنفس timestamp الحالي
    local currentData = {
        action = "add_fruit", 
        fruit = "Dragon",
        timestamp = os.time(),
        location = "Inventory"
    }
    
    -- 3. النظام ممكن يحسب إنها فاكهتين مختلفتين
    for i = 1, 3 do
        inventorySystem:FireServer(oldData)
        inventorySystem:FireServer(currentData)
        task.wait(0.1)
    end
end

-- ============================================
-- 🎯 الخطة: Database Desync
-- ============================================

local function databaseDesync()
    print("🗄️ إحداث عدم تزامن في قاعدة البيانات...")
    
    -- جعل قاعدة بيانات الكلاينت تختلف عن السيرفر
    
    -- 1. تعديل بيانات الكلاينت محلياً
    local localFruitCount = 1
    local replicatedCount = 0
    
    -- 2. إرسال بيانات متناقضة
    local conflictingData = {
        -- نسخة 1: عندي فاكهة واحدة
        {
            fruitCount = 1,
            source = "client_cache",
            checksum = "WRONG_CHECKSUM_123"
        },
        
        -- نسخة 2: عندي فاكهتين  
        {
            fruitCount = 2,
            source = "client_memory", 
            checksum = "ANOTHER_WRONG_456"
        },
        
        -- نسخة 3: ما عنديش فاكهة
        {
            fruitCount = 0,
            source = "client_temp",
            checksum = "WRONG_AGAIN_789"
        }
    }
    
    -- 3. إرسال كل النسخ بسرعة
    for _, data in pairs(conflictingData) do
        inventorySystem:FireServer("UpdateFruitData", data)
        task.wait(0.03)
    end
end

-- ============================================
-- 📱 واجهة التحكم العميقة
-- ============================================

local deepUI = Instance.new("ScreenGui")
deepUI.Name = "QuantumDupeUI"
deepUI.ResetOnSpawn = false

local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.new(0.35, 0, 0.45, 0)
controlFrame.Position = UDim2.new(0.6, 0, 0.1, 0)
controlFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
controlFrame.Active = true
controlFrame.Draggable = true

-- عنوان
local title = Instance.new("TextLabel")
title.Text = "🧠 QUANTUM DUPLICATION"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
title.TextColor3 = Color3.fromRGB(150, 255, 150)

-- ازرار الخطط العميقة
local deepPlans = {
    {name = "🌀 التراكب الكمومي", func = quantumSuperposition, color = Color3.fromRGB(100, 0, 200)},
    {name = "💾 تجميد الذاكرة", func = memoryAddressFreeze, color = Color3.fromRGB(0, 100, 200)},
    {name = "📦 اعتراض الباكيتات", func = packetInterception, color = Color3.fromRGB(200, 100, 0)},
    {name = "⏰ خدعة الزمن", func = timeGlitch, color = Color3.fromRGB(200, 0, 100)},
    {name = "🗄️ عدم تزامن DB", func = databaseDesync, color = Color3.fromRGB(0, 200, 100)},
    {name = "💥 كل الخطط معاً", func = function()
        quantumSuperposition()
        task.wait(0.5)
        memoryAddressFreeze()
        task.wait(0.5)
        packetInterception()
        task.wait(0.5)
        timeGlitch()
        task.wait(0.5)
        databaseDesync()
    end, color = Color3.fromRGB(255, 50, 50)}
}

for i, plan in ipairs(deepPlans) do
    local btn = Instance.new("TextButton")
    btn.Text = plan.name
    btn.Size = UDim2.new(0.9, 0, 0.12, 0)
    btn.Position = UDim2.new(0.05, 0, 0.12 + (i * 0.13), 0)
    btn.BackgroundColor3 = plan.color
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    btn.MouseButton1Click:Connect(function()
        btn.Text = "⚡ جاري..."
        task.spawn(function()
            pcall(plan.func)
            task.wait(2)
            btn.Text = plan.name
        end)
    end)
    
    btn.Parent = controlFrame
end

title.Parent = controlFrame
controlFrame.Parent = deepUI
deepUI.Parent = gui

-- ============================================
-- 📢 التعليمات
-- ============================================
print([[
    
🧠 QUANTUM DUPLICATION SYSTEM:

🌀 التراكب الكمومي:
- جعل الفاكهة في حالات متعددة معاً
- النظام مش عارف هي فين

💾 تجميد الذاكرة:  
- وقف تحديث بيانات الفاكهة
- النظام يفضل يحسب البيانات القديمة

📦 اعتراض الباكيتات:
- تكرار إشارات نقل الفاكهة
- النظام يحسب إن الفاكهة اتنقلت مرتين

⏰ خدعة الزمن:
- إرسال بيانات ب timestamps مختلفة
- النظام يحسب كل مرة كفاكهة جديدة

🗄️ عدم تزامن DB:
- إرسال بيانات متناقضة
- قاعدة بيانات السيرفر تتشوش

🎯 الهدف: جعل النظام في حيرة كاملة
           عن حالة الفاكهة الحقيقية!

]])
