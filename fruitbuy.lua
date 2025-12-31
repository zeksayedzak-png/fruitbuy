-- Gift System Finder
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer

-- كلمات البحث عن الهدايا
local GIFT_KEYWORDS = {
    "christmas", "xmas", "holiday", "gift",
    "present", "reward", "claim", "open",
    "santa", "festive", "winter", "newyear"
}

local function findGiftSystems()
    local giftSystems = {}
    
    print("🔍 يبحث عن أنظمة الهدايا...")
    
    -- البحث في ReplicatedStorage
    local repStorage = game:GetService("ReplicatedStorage")
    
    local function searchInObject(obj, path)
        for _, child in pairs(obj:GetChildren()) do
            -- إذا كان RemoteEvent أو RemoteFunction
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local lowerName = child.Name:lower()
                
                -- تحقق من الكلمات المفتاحية
                for _, keyword in ipairs(GIFT_KEYWORDS) do
                    if lowerName:find(keyword) then
                        table.insert(giftSystems, {
                            name = child.Name,
                            type = child.ClassName,
                            path = path .. child.Name,
                            object = child
                        })
                        break
                    end
                end
            end
            
            -- البحث في الأطفال
            searchInObject(child, path .. child.Name .. ".")
        end
    end
    
    -- بدء البحث
    searchInObject(repStorage, "ReplicatedStorage.")
    
    -- البحث في RobloxReplicatedStorage أيضًا
    if game:FindFirstChild("RobloxReplicatedStorage") then
        searchInObject(game.RobloxReplicatedStorage, "RobloxReplicatedStorage.")
    end
    
    return giftSystems
end

-- عرض النتائج
local function displayResults(systems)
    if #systems == 0 then
        print("❌ لم يتم العثور على أنظمة هدايا")
        return
    end
    
    print("\n🎁 أنظمة الهدايا الموجودة:")
    for i, system in ipairs(systems) do
        print(string.format("%d. %s (%s)", i, system.name, system.type))
        print("   المسار: " .. system.path)
    end
end

-- دالة نسخ للحافظة
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    elseif writeclipboard then
        writeclipboard(text)
        return true
    end
    return false
end

-- واجهة موبايل بسيطة
local function createGiftUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GiftFinder"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🎁 Gift System Finder"
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- زر البحث
    local searchBtn = Instance.new("TextButton")
    searchBtn.Text = "🔍 بحث عن الهدايا"
    searchBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
    searchBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    searchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    searchBtn.TextColor3 = Color3.new(1, 1, 1)
    searchBtn.Font = Enum.Font.SourceSansBold
    
    -- زر النسخ الجديد
    local copyBtn = Instance.new("TextButton")
    copyBtn.Text = "📋 نسخ النتائج"
    copyBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
    copyBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
    copyBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    copyBtn.TextColor3 = Color3.new(1, 1, 1)
    copyBtn.Font = Enum.Font.SourceSansBold
    copyBtn.Visible = false
    
    -- النتائج
    local resultLabel = Instance.new("TextLabel")
    resultLabel.Text = "اضغط للبحث عن أنظمة الهدايا"
    resultLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
    resultLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
    resultLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    resultLabel.TextColor3 = Color3.new(1, 1, 1)
    resultLabel.TextWrapped = true
    
    -- حدث البحث
    searchBtn.MouseButton1Click:Connect(function()
        searchBtn.Text = "⏳ جاري البحث..."
        resultLabel.Text = "🔍 يبحث عن أنظمة الهدايا..."
        
        task.spawn(function()
            local systems = findGiftSystems()
            
            if #systems == 0 then
                resultLabel.Text = "❌ لم يتم العثور على أنظمة هدايا"
                resultLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
                copyBtn.Visible = false
            else
                local text = "✅ وجد " .. #systems .. " نظام:\n\n"
                for i, system in ipairs(systems) do
                    if i <= 3 then -- عرض أول 3 فقط
                        text = text .. i .. ". " .. system.name .. "\n"
                    end
                end
                if #systems > 3 then
                    text = text .. "... والمزيد في الكونسول"
                end
                
                resultLabel.Text = text
                resultLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                copyBtn.Visible = true
                
                -- تخزين النتائج للنسخ
                local copyText = "🎁 أنظمة الهدايا:\n"
                for i, system in ipairs(systems) do
                    copyText = copyText .. i .. ". " .. system.name .. " (" .. system.type .. ")\n"
                    copyText = copyText .. "   المسار: " .. system.path .. "\n\n"
                end
                
                copyBtn.MouseButton1Click:Connect(function()
                    if copyToClipboard(copyText) then
                        copyBtn.Text = "✅ تم النسخ!"
                        task.wait(1)
                        copyBtn.Text = "📋 نسخ النتائج"
                    else
                        copyBtn.Text = "❌ فشل النسخ"
                        task.wait(1)
                        copyBtn.Text = "📋 نسخ النتائج"
                    end
                end)
            end
            
            searchBtn.Text = "🔍 بحث عن الهدايا"
        end)
    end)
    
    -- التجميع
    title.Parent = mainFrame
    searchBtn.Parent = mainFrame
    copyBtn.Parent = mainFrame
    resultLabel.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
end

-- البحث التلقائي عند التشغيل
task.spawn(function()
    task.wait(2)
    print("\n🎁 البحث التلقائي عن أنظمة الهدايا...")
    local systems = findGiftSystems()
    displayResults(systems)
end)

createGiftUI()

print([[
    
🎁 Gift System Finder
🔍 للبحث عن أنظمة الكريسماس والهدايا

الكلمات المفتاحية:
• Christmas, Xmas, Holiday
• Gift, Present, Reward
• Claim, Open, Santa
• Festive, Winter, NewYear

- تم إضافة زر نسخ النتائج ✓
]])
