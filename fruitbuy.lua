-- ============================================
-- 🔄 FRUIT TRANSFORMATION EXPLOIT
-- ============================================

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui
local rs = game:GetService("ReplicatedStorage")

-- الأزرار المهمة
local inventoryBtn = gui:WaitForChild("Main"):WaitForChild("InventoryButton")
local moveBtn = gui:FindFirstChild("MoveToInventoryButton") or 
                gui:FindFirstChild("TransferButton") or
                gui:FindFirstChild("Option3") -- زر النقل

local hotbarBtn = gui:WaitForChild("Backpack"):WaitForChild("Hotbar"):WaitForChild("Container"):WaitForChild("More"):WaitForChild("TextButton")

-- نظام تحويل الفاكهة
local FruitTransformer = {
    weakFruit = "Spin-Fruit",      -- الفاكهة الضعيفة اللي عندك
    strongFruit = "Leopard-Fruit", -- الفاكهة القوية اللي عايزها
    transformationActive = false,
    
    -- قائمة الفواكه من الأضعف للأقوى
    fruits = {
        "Spin-Fruit", "Chop-Fruit", "Spring-Fruit", "Kilo-Fruit", "Smoke-Fruit",
        "Spike-Fruit", "Bomb-Fruit", "Flame-Fruit", "Falcon-Fruit", "Ice-Fruit",
        "Sand-Fruit", "Dark-Fruit", "Diamond-Fruit", "Light-Fruit", "Rubber-Fruit",
        "Barrier-Fruit", "Ghost-Fruit", "Magma-Fruit", "Quake-Fruit", "Buddha-Fruit",
        "Love-Fruit", "Spider-Fruit", "Sound-Fruit", "Phoenix-Fruit", "Portal-Fruit",
        "Rumble-Fruit", "Pain-Fruit", "Blizzard-Fruit", "Gravity-Fruit", "Venom-Fruit",
        "Shadow-Fruit", "Dragon-Fruit", "Dough-Fruit", "Leopard-Fruit"
    },
    
    -- إيجاد فاكهة قوية أعلى من عندك
    findUpgrade = function(self, currentFruit)
        local currentIndex = nil
        for i, fruit in ipairs(self.fruits) do
            if fruit == currentFruit then
                currentIndex = i
                break
            end
        end
        
        if currentIndex and currentIndex < #self.fruits then
            return self.fruits[currentIndex + 1] -- الفاكهة التالية
        end
        
        return self.fruits[#self.fruits] -- أقوى فاكهة
    end
}

-- ============================================
-- 🎯 الخطة: التحويل أثناء النقل
-- ============================================

local function executeFruitTransformation()
    print("🔄 بدء تحويل الفاكهة أثناء النقل...")
    
    -- 🔄 الخطوة 1: فتح الإنفنتوري والباك باك
    print("1. 📦 فتح الإنفنتوري والباك باك...")
    guaranteedClick(inventoryBtn)
    task.wait(0.3)
    
    -- 🔄 الخطوة 2: اختيار فاكهة سيئة من الباك باك
    print("2. 🎯 اختيار فاكهة سيئة (" .. FruitTransformer.weakFruit .. ")...")
    -- هنا لازم تختار الفاكهة السيئة يدوياً أولاً
    
    -- 🔄 الخطوة 3: الضغط على زر النقل + تغيير البيانات
    print("3. ⚡ الضغط على زر النقل مع تغيير البيانات...")
    
    FruitTransformer.transformationActive = true
    
    -- قبل الضغط، نجهز البيانات المزيفة
    local fakeFruitData = {
        fruitName = FruitTransformer.strongFruit, -- الفاكهة القوية
        rarity = "Legendary",
        value = 5000000,
        originalFruit = FruitTransformer.weakFruit, -- الفاكهة الأصلية
        timestamp = os.time(),
        player = plr.Name,
        exploit = "mid_transfer_transform"
    }
    
    -- 🔄 الخطوة 4: إرسال بيانات التحويل مع النقل
    coroutine.wrap(function()
        -- إرسال بيانات الفاكهة القوية
        for i = 1, 5 do
            pcall(function()
                rs.InventorySystem:FireServer("TransferFruit", fakeFruitData)
            end)
            task.wait(0.01)
        end
    end)()
    
    -- 🔄 الخطوة 5: الضغط الفعلي على زر النقل
    if moveBtn then
        for i = 1, 3 do
            guaranteedClick(moveBtn)
            task.wait(0.05)
        end
    end
    
    -- 🔄 الخطوة 6: إرسال بيانات تأكيد
    task.wait(0.1)
    local confirmData = {
        action = "confirm_transfer",
        fruit = FruitTransformer.strongFruit,
        success = true,
        system_time = os.time()
    }
    
    for i = 1, 3 do
        pcall(function()
            rs.InventorySystem:FireServer("ConfirmTransfer", confirmData)
        end)
        task.wait(0.05)
    end
    
    FruitTransformer.transformationActive = false
    
    -- 🔄 الخطوة 7: التحقق
    print("4. ✅ اكتمل التحويل!")
    print("   📊 من: " .. FruitTransformer.weakFruit)
    print("   🎯 إلى: " .. FruitTransformer.strongFruit)
    print("   🔍 تحقق من الإنفنتوري!")
end

-- ============================================
-- 🎯 الخطة: Packet Injection
-- ============================================

local function packetInjectionTransformation()
    print("💉 حقن باكيتات تحويل...")
    
    -- إيجاد الـ RemoteEvents المسؤولة
    local transferRemotes = {}
    for _, remote in pairs(rs:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("transfer") or name:find("move") or name:find("inventory") then
                table.insert(transferRemotes, remote)
            end
        end
    end
    
    -- باكيتات التحويل
    local transformationPackets = {
        -- باكيت 1: بداية النقل (فاكهة سيئة)
        {
            packet_id = "TRANSFER_START",
            fruit = FruitTransformer.weakFruit,
            source = "backpack",
            target = "inventory",
            time = os.time()
        },
        
        -- باكيت 2: أثناء النقل (تغيير البيانات)
        {
            packet_id = "MID_TRANSFER",
            fruit = FruitTransformer.strongFruit,
            original_fruit = FruitTransformer.weakFruit,
            transformed = true,
            time = os.time() + 0.001
        },
        
        -- باكيت 3: تأكيد النقل (فاكهة قوية)
        {
            packet_id = "TRANSFER_COMPLETE",
            fruit = FruitTransformer.strongFruit,
            location = "inventory",
            time = os.time() + 0.002
        }
    }
    
    -- إرسال الباكيتات بسرعة
    for _, remote in pairs(transferRemotes) do
        for _, packet in pairs(transformationPackets) do
            pcall(function()
                remote:FireServer(packet)
            end)
            task.wait(0.001) -- فرق توقيت بسيط جداً
        end
    end
end

-- ============================================
-- 🎯 الخطة: Memory Rewrite
-- ============================================

local function memoryRewrite()
    print("🧠 إعادة كتابة الذاكرة...")
    
    -- نظرية: تغيير بيانات الفاكهة في الذاكرة
    
    -- 1. جعل النظام ينسخ الفاكهة الأصلية
    local copyPacket = {
        action = "copy_fruit_data",
        source_fruit = FruitTransformer.weakFruit,
        timestamp = os.time()
    }
    
    -- 2. تغيير البيانات أثناء النسخ
    local rewritePacket = {
        action = "rewrite_fruit_data",
        original = FruitTransformer.weakFruit,
        new = FruitTransformer.strongFruit,
        attributes = {
            rarity = "Legendary",
            value = 5000000,
            abilities = {"Transformation", "Upgrade"}
        }
    }
    
    -- 3. إرسال متسلسل سريع
    local remotes = {"InventorySystem", "FruitSystem", "DataSystem"}
    
    for _, remoteName in pairs(remotes) do
        local remote = rs:FindFirstChild(remoteName)
        if remote and remote:IsA("RemoteEvent") then
            -- إرسال النسخ
            remote:FireServer(copyPacket)
            task.wait(0.001)
            
            -- إرسال التغيير
            remote:FireServer(rewritePacket)
            task.wait(0.001)
            
            -- تأكيد
            remote:FireServer({
                action = "confirm_rewrite",
                fruit = FruitTransformer.strongFruit,
                success = true
            })
        end
    end
end

-- ============================================
-- 📱 واجهة التحكم
-- ============================================

local transformUI = Instance.new("ScreenGui")
transformUI.Name = "FruitTransformerUI"
transformUI.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.4, 0, 0.35, 0)
main.Position = UDim2.new(0.55, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
main.Active = true
main.Draggable = true

-- اختيار الفاكهة
local weakLabel = Instance.new("TextLabel")
weakLabel.Text = "الفاكهة السيئة: " .. FruitTransformer.weakFruit
weakLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
weakLabel.Position = UDim2.new(0.05, 0, 0.05, 0)

local strongLabel = Instance.new("TextLabel")
strongLabel.Text = "الفاكهة القوية: " .. FruitTransformer.strongFruit
strongLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
strongLabel.Position = UDim2.new(0.05, 0, 0.17, 0)

-- زر البحث عن ترقية
local findUpgradeBtn = Instance.new("TextButton")
findUpgradeBtn.Text = "🔍 إيجاد ترقية"
findUpgradeBtn.Size = UDim2.new(0.9, 0, 0.1, 0)
findUpgradeBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
findUpgradeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

-- زر التحويل الأساسي
local transformBtn = Instance.new("TextButton")
transformBtn.Text = "🔄 تحويل أثناء النقل"
transformBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
transformBtn.Position = UDim2.new(0.05, 0, 0.43, 0)
transformBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)

-- زر حقن الباكيتات
local injectBtn = Instance.new("TextButton")
injectBtn.Text = "💉 حقن باكيتات"
injectBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
injectBtn.Position = UDim2.new(0.05, 0, 0.61, 0)
injectBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)

-- إضافة العناصر
weakLabel.Parent = main
strongLabel.Parent = main
findUpgradeBtn.Parent = main
transformBtn.Parent = main
injectBtn.Parent = main
main.Parent = transformUI
transformUI.Parent = gui

-- الأحداث
findUpgradeBtn.MouseButton1Click:Connect(function()
    local upgrade = FruitTransformer:findUpgrade(FruitTransformer.weakFruit)
    FruitTransformer.strongFruit = upgrade
    strongLabel.Text = "الفاكهة القوية: " .. upgrade
end)

transformBtn.MouseButton1Click:Connect(function()
    transformBtn.Text = "⚡ جاري التحويل..."
    task.spawn(function()
        executeFruitTransformation()
        task.wait(3)
        transformBtn.Text = "🔄 تحويل أثناء النقل"
    end)
end)

injectBtn.MouseButton1Click:Connect(function()
    injectBtn.Text = "💉 جاري الحقن..."
    task.spawn(function()
        packetInjectionTransformation()
        memoryRewrite()
        task.wait(2)
        injectBtn.Text = "💉 حقن باكيتات"
    end)
end)

print([[
    
🔄 FRUIT TRANSFORMATION EXPLOIT:

الفكرة: تغيير الفاكهة أثناء نقلها من الباك باك للإنفنتوري

🎯 الخطوات:
1. اختار فاكهة سيئة من الباك باك
2. اضغط زر النقل
3. أثناء النقل، نغير بيانات الفاكهة
4. النظام هيحسب إنك نقلت فاكهة قوية

💡 النصيحة: ابدأ بفاكهة سيئة عندك
            وحولها لأقوى فاكهة!

]])
