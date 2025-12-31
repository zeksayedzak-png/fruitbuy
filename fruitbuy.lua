-- RF/GiftFunction Info Grabber
-- يعمل على الهاتف

local rs = game:GetService("ReplicatedStorage")
local plr = game.Players.LocalPlayer

-- نجيب الريموت
local giftRemote
local success, err = pcall(function()
    giftRemote = rs:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/GiftFunction")
end)

-- نخزن المعلومات
local collectedInfo = ""

-- نعمل واجهة
local ui = Instance.new("ScreenGui")
ui.Name = "GiftInfo"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.9, 0, 0.45, 0)
main.Position = UDim2.new(0.05, 0, 0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 45)

local title = Instance.new("TextLabel")
title.Text = "🔍 RF/GiftFunction Info"
title.Size = UDim2.new(1, 0, 0.12, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold

local infoBox = Instance.new("TextLabel")
infoBox.Text = "جاري فحص الريموت..."
infoBox.Size = UDim2.new(1, 0, 0.58, 0)
infoBox.Position = UDim2.new(0, 0, 0.12, 0)
infoBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
infoBox.TextColor3 = Color3.new(1, 1, 1)
infoBox.TextWrapped = true
infoBox.TextXAlignment = Enum.TextXAlignment.Left
infoBox.TextYAlignment = Enum.TextYAlignment.Top

local testBtn = Instance.new("TextButton")
testBtn.Text = "🧪 تجربة الريموت"
testBtn.Size = UDim2.new(0.44, 0, 0.12, 0)
testBtn.Position = UDim2.new(0.03, 0, 0.72, 0)
testBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
testBtn.TextColor3 = Color3.new(1, 1, 1)

local copyBtn = Instance.new("TextButton") -- زر النسخ الجديد
copyBtn.Text = "📋 نسخ المعلومات"
copyBtn.Size = UDim2.new(0.44, 0, 0.12, 0)
copyBtn.Position = UDim2.new(0.53, 0, 0.72, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
copyBtn.TextColor3 = Color3.new(1, 1, 1)

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "❌ إغلاق"
closeBtn.Size = UDim2.new(0.9, 0, 0.12, 0)
closeBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)

-- نضيف للحافظة
title.Parent = main
infoBox.Parent = main
testBtn.Parent = main
copyBtn.Parent = main
closeBtn.Parent = main
main.Parent = ui
ui.Parent = plr:WaitForChild("PlayerGui")

-- دالة نسخ للحافظة
local function copyToClip(text)
    if setclipboard then
        setclipboard(text)
        return true
    end
    return false
end

-- دالة فحص الريموت
local function analyzeRemote()
    if not giftRemote then
        infoBox.Text = "❌ الريموت مش موجود!"
        return
    end
    
    local info = "📊 معلومات RF/GiftFunction:\n\n"
    
    -- معلومات أساسية
    info = info .. "🔹 النوع: " .. giftRemote.ClassName .. "\n"
    info = info .. "🔹 الاسم: " .. giftRemote.Name .. "\n\n"
    
    -- عدد المرات اللي اتصلت فيه
    local testResults = ""
    local argTests = {
        {},
        {"Gift"},
        {"ChristmasGift"},
        {"DailyGift"},
        {1},
        {true}
    }
    
    infoBox.Text = "🔬 جاري اختبار الريموت..."
    
    for i, args in ipairs(argTests) do
        local result = pcall(function()
            return giftRemote:InvokeServer(unpack(args))
        end)
        
        if result then
            testResults = testResults .. "✅ Test " .. i .. ": نجح\n"
        else
            testResults = testResults .. "❌ Test " .. i .. ": فشل\n"
        end
        
        task.wait(0.1)
    end
    
    info = info .. "📋 نتائج الاختبار:\n" .. testResults .. "\n"
    
    -- نعرض النتيجة
    collectedInfo = info
    infoBox.Text = info
end

-- أحداث الأزرار
testBtn.MouseButton1Click:Connect(function()
    testBtn.Text = "⏳ جاري الفحص..."
    task.spawn(analyzeRemote)
    testBtn.Text = "🧪 تجربة الريموت"
end)

copyBtn.MouseButton1Click:Connect(function() -- حدث زر النسخ
    if collectedInfo and collectedInfo ~= "" then
        if copyToClip(collectedInfo) then
            copyBtn.Text = "✅ تم النسخ!"
            task.wait(1)
            copyBtn.Text = "📋 نسخ المعلومات"
        else
            copyBtn.Text = "❌ فشل النسخ"
            task.wait(1)
            copyBtn.Text = "📋 نسخ المعلومات"
        end
    else
        copyBtn.Text = "⚠️ لا توجد معلومات"
        task.wait(1)
        copyBtn.Text = "📋 نسخ المعلومات"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    ui:Destroy()
end)

-- نبدأ الفحص التلقائي
task.wait(1)
analyzeRemote()
