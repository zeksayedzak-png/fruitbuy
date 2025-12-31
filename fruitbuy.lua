-- 🎯 ADDITEM INFO STEALER
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer

-- 🔍 البحث عن AddItem RemoteEvent
local function findAddItemRemote()
    print("🔍 يبحث عن AddItem RemoteEvent...")
    
    -- المسار المباشر
    local path = "ReplicatedStorage.GameEvents.TradeEvents.AddItem"
    local pathParts = path:split(".")
    local current = game
    
    for i = 2, #pathParts do
        if current:FindFirstChild(pathParts[i]) then
            current = current[pathParts[i]]
        else
            print("❌ جزء مفقود: " .. pathParts[i])
            return nil
        end
    end
    
    if current and current:IsA("RemoteEvent") then
        print("✅ وجد AddItem RemoteEvent!")
        return current
    else
        print("❌ AddItem مش RemoteEvent")
        return nil
    end
end

-- 🕵️‍♂️ جمع معلومات عن AddItem
local function gatherAddItemInfo()
    local addItemRemote = findAddItemRemote()
    if not addItemRemote then
        return nil, "❌ AddItem مش موجود"
    end
    
    print("🕵️‍♂️ يجمع معلومات AddItem...")
    
    local info = {
        name = addItemRemote.Name,
        fullPath = addItemRemote:GetFullName(),
        className = addItemRemote.ClassName,
        parent = addItemRemote.Parent and addItemRemote.Parent.Name,
        ancestry = {}
    }
    
    -- جمع مسار الآباء
    local current = addItemRemote.Parent
    while current and current ~= game do
        table.insert(info.ancestry, current.Name)
        current = current.Parent
    end
    
    -- تحليل الاتصالات (إذا كان في scripts تستخدمه)
    local connectionsInfo = {
        serverScripts = 0,
        clientScripts = 0,
        localScripts = 0
    }
    
    -- ابحث عن scripts تستخدم AddItem
    for _, script in pairs(game:GetDescendants()) do
        if script:IsA("Script") or script:IsA("LocalScript") then
            local source = script.Source
            if source:find("AddItem") then
                if script:IsA("Script") then
                    connectionsInfo.serverScripts = connectionsInfo.serverScripts + 1
                elseif script:IsA("LocalScript") then
                    connectionsInfo.clientScripts = connectionsInfo.clientScripts + 1
                end
            end
        end
    end
    
    info.connections = connectionsInfo
    
    -- محاولة فهم payload الشكل (عن طريق التدقيق في scripts)
    local possiblePayloads = {}
    
    -- البحث عن أمثلة لاستخدام AddItem
    for _, script in pairs(game:GetDescendants()) do
        if (script:IsA("Script") or script:IsA("LocalScript")) and script.Source:find("AddItem") then
            local source = script.Source
            -- ابحث عن patterns
            if source:find("FireServer") and source:find("AddItem") then
                -- حاول استخراج payload أمثلة
                local lines = string.split(source, "\n")
                for _, line in ipairs(lines) do
                    if line:find("AddItem") and line:find("FireServer") then
                        -- استخراج ما بين القوسين
                        local startPos = line:find("%(")
                        local endPos = line:find("%)")
                        if startPos and endPos then
                            local args = line:sub(startPos + 1, endPos - 1)
                            table.insert(possiblePayloads, "مثال: AddItem:FireServer(" .. args .. ")")
                        end
                    end
                end
            end
        end
    end
    
    info.exampleUsage = possiblePayloads
    
    -- تحليل الأسماء المحيطة لفهم النظام
    local nearbyItems = {}
    local parent = addItemRemote.Parent
    if parent then
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                table.insert(nearbyItems, {
                    name = child.Name,
                    type = child.ClassName
                })
            end
        end
    end
    
    info.nearbyRemotes = nearbyItems
    
    return info, "✅ تم جمع المعلومات"
end

-- 📋 عرض المعلومات بشكل منظم
local function formatAddItemInfo(info)
    if not info then return "❌ لا توجد معلومات" end
    
    local text = ""
    
    text = text .. "🎯 معلومات AddItem RemoteEvent:\n"
    text = text .. "=" .. string.rep("=", 40) .. "\n\n"
    
    text = text .. "📌 الأساسي:\n"
    text = text .. "• الاسم: " .. info.name .. "\n"
    text = text .. "• النوع: " .. info.className .. "\n"
    text = text .. "• المسار: " .. info.fullPath .. "\n"
    text = text .. "• الأب: " .. (info.parent or "غير معروف") .. "\n\n"
    
    if #info.ancestry > 0 then
        text = text .. "📂 مسار الآباء:\n"
        for i, ancestor in ipairs(info.ancestry) do
            text = text .. string.rep("  ", i) .. "└── " .. ancestor .. "\n"
        end
        text = text .. "\n"
    end
    
    text = text .. "🔗 الاتصالات:\n"
    text = text .. "• سكربتات السيرفر: " .. info.connections.serverScripts .. "\n"
    text = text .. "• سكربتات العميل: " .. info.connections.clientScripts .. "\n\n"
    
    if #info.exampleUsage > 0 then
        text = text .. "📝 أمثلة استخدام:\n"
        for i, example in ipairs(info.exampleUsage) do
            if i <= 3 then -- عرض أول 3 أمثلة فقط
                text = text .. i .. ". " .. example .. "\n"
            end
        end
        text = text .. "\n"
    end
    
    if #info.nearbyRemotes > 0 then
        text = text .. "📡 RemoteEvents/Function المجاورة:\n"
        for _, remote in ipairs(info.nearbyRemotes) do
            text = text .. "• " .. remote.name .. " (" .. remote.type .. ")\n"
        end
    end
    
    text = text .. "\n" .. string.rep("=", 40) .. "\n"
    
    return text
end

-- 📱 واجهة الموبايل
local function createMobileUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AddItemInfo"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.95, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.025, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🕵️‍♂️ ADDITEM INFO STEALER"
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- زر جمع المعلومات
    local gatherBtn = Instance.new("TextButton")
    gatherBtn.Text = "🔍 جمع معلومات AddItem"
    gatherBtn.Size = UDim2.new(0.9, 0, 0.12, 0)
    gatherBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
    gatherBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    gatherBtn.TextColor3 = Color3.new(1, 1, 1)
    gatherBtn.Font = Enum.Font.SourceSansBold
    
    -- زر نسخ المعلومات
    local copyBtn = Instance.new("TextButton")
    copyBtn.Text = "📋 نسخ المعلومات"
    copyBtn.Size = UDim2.new(0.44, 0, 0.1, 0)
    copyBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
    copyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
    copyBtn.TextColor3 = Color3.new(1, 1, 1)
    copyBtn.Visible = false
    
    -- زر إظهار في الكونسول
    local consoleBtn = Instance.new("TextButton")
    consoleBtn.Text = "📟 عرض في الكونسول"
    consoleBtn.Size = UDim2.new(0.44, 0, 0.1, 0)
    consoleBtn.Position = UDim2.new(0.51, 0, 0.3, 0)
    consoleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
    consoleBtn.TextColor3 = Color3.new(1, 1, 1)
    consoleBtn.Visible = false
    
    -- عرض المعلومات
    local infoFrame = Instance.new("ScrollingFrame")
    infoFrame.Size = UDim2.new(0.9, 0, 0.55, 0)
    infoFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
    infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    infoFrame.BorderSizePixel = 1
    infoFrame.ScrollBarThickness = 8
    infoFrame.Visible = false
    
    local infoText = Instance.new("TextLabel")
    infoText.Name = "InfoText"
    infoText.Size = UDim2.new(1, 0, 1, 0)
    infoText.BackgroundTransparency = 1
    infoText.TextColor3 = Color3.new(1, 1, 1)
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.TextWrapped = true
    infoText.Font = Enum.Font.SourceSans
    infoText.TextSize = 14
    
    -- المتغيرات
    local currentInfo = nil
    local currentInfoText = ""
    
    -- 🔍 حدث جمع المعلومات
    gatherBtn.MouseButton1Click:Connect(function()
        gatherBtn.Text = "⏳ يجمع معلومات..."
        
        task.spawn(function()
            local info, message = gatherAddItemInfo()
            
            if info then
                currentInfo = info
                currentInfoText = formatAddItemInfo(info)
                
                -- إظهار الأزرار
                copyBtn.Visible = true
                consoleBtn.Visible = true
                infoFrame.Visible = true
                
                -- عرض المعلومات
                infoText.Text = currentInfoText
                infoText.Parent = infoFrame
                
                gatherBtn.Text = "✅ تم الجمع"
                gatherBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                
                print("\n🎯 معلومات AddItem في الكونسول:")
                print(currentInfoText)
            else
                gatherBtn.Text = "❌ فشل الجمع"
                gatherBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                print("❌ " .. message)
            end
        end)
    end)
    
    -- 📋 حدث نسخ المعلومات
    copyBtn.MouseButton1Click:Connect(function()
        if not currentInfoText or currentInfoText == "" then return end
        
        -- للموبايل: اطبع في الكونسول للنسخ اليدوي
        print("\n📋 معلومات AddItem للنسخ:")
        print("=" .. string.rep("=", 50))
        print(currentInfoText)
        print("=" .. string.rep("=", 50))
        print("📱 على الموبايل: اضغط مطولاً على النص وانسخ")
        
        copyBtn.Text = "📋 انسخ من الكونسول"
        task.wait(1)
        copyBtn.Text = "📋 نسخ المعلومات"
    end)
    
    -- 📟 حدث العرض في الكونسول
    consoleBtn.MouseButton1Click:Connect(function()
        if not currentInfoText then return end
        
        print("\n" .. string.rep("=", 60))
        print("🎯 معلومات AddItem الكاملة:")
        print(string.rep("=", 60))
        print(currentInfoText)
        
        consoleBtn.Text = "✅ معروض"
        task.wait(1)
        consoleBtn.Text = "📟 عرض في الكونسول"
    end)
    
    -- زر اختبار AddItem
    local testBtn = Instance.new("TextButton")
    testBtn.Text = "⚡ اختبار AddItem"
    testBtn.Size = UDim2.new(0.9, 0, 0.1, 0)
    testBtn.Position = UDim2.new(0.05, 0, 0.88, 0)
    testBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    testBtn.TextColor3 = Color3.new(1, 1, 1)
    
    -- حدث اختبار AddItem
    testBtn.MouseButton1Click:Connect(function()
        local addItemRemote = findAddItemRemote()
        if not addItemRemote then
            print("❌ AddItem مش موجود للاختبار")
            return
        end
        
        print("\n🎯 جرب AddItem مع payloads مختلفة...")
        
        -- payloads اختبارية
        local testPayloads = {
            {itemId = "test_item_1", amount = 1},
            {item = "token", quantity = 100, player = player.Name},
            {id = "gem_001", count = 50, receiver = player.UserId},
            {itemType = "Token", amount = 1000, target = player}
        }
        
        for i, payload in ipairs(testPayloads) do
            print("\n🔧 جرب Payload " .. i .. "...")
            
            local success, result = pcall(function()
                addItemRemote:FireServer(payload)
                return "تم الإرسال"
            end)
            
            if success then
                print("✅ Payload " .. i .. " ناجح!")
            else
                print("❌ Payload " .. i .. " فشل")
            end
            
            task.wait(0.3)
        end
        
        testBtn.Text = "✅ تم الاختبار"
        task.wait(1)
        testBtn.Text = "⚡ اختبار AddItem"
    end)
    
    -- التجميع
    infoText.Parent = infoFrame
    title.Parent = mainFrame
    gatherBtn.Parent = mainFrame
    copyBtn.Parent = mainFrame
    consoleBtn.Parent = mainFrame
    infoFrame.Parent = mainFrame
    testBtn.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- أوامر الكونسول
_G.GetAddItemInfo = function()
    local info, message = gatherAddItemInfo()
    if info then
        local text = formatAddItemInfo(info)
        print(text)
        return "✅ تم جمع المعلومات"
    else
        return "❌ " .. message
    end
end

_G.TestAddItem = function()
    local addItemRemote = findAddItemRemote()
    if not addItemRemote then return "❌ AddItem مش موجود" end
    
    print("🎯 جرب AddItem...")
    
    local payloads = {
        {itemId = "test_token", amount = 100},
        {item = "gem", quantity = 50, player = player.Name}
    }
    
    for i, payload in ipairs(payloads) do
        local success, _ = pcall(function()
            addItemRemote:FireServer(payload)
        end)
        
        if success then
            print("✅ Payload " .. i .. " ناجح")
        else
            print("❌ Payload " .. i .. " فشل")
        end
    end
    
    return "تم الاختبار"
end

-- تشغيل
print([[
    
🕵️‍♂️ ADDITEM INFO STEALER
🎯 جمع معلومات AddItem RemoteEvent

🔍 يبحث عن:
ReplicatedStorage.GameEvents.TradeEvents.AddItem

📋 المعلومات المجمعة:
1. المسار الكامل
2. الآباء والأجداد  
3. سكربتات متصلة
4. أمثلة استخدام
5. RemoteEvents مجاورة

⚡ الأوامر:
_G.GetAddItemInfo() - جمع وعرض المعلومات
_G.TestAddItem() - اختبار AddItem

]])

-- إنشاء الواجهة
createMobileUI()

-- البحث التلقائي
task.spawn(function()
    task.wait(2)
    local remote = findAddItemRemote()
    if remote then
        print("✅ AddItem موجود وجاهز للتحليل!")
    else
        print("❌ AddItem مش موجود في المسار المتوقع")
    end
end)

print("✅ AddItem Info Stealer جاهز!")
