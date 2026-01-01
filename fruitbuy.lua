-- 🎯 TOOL COPY-PASTE SYSTEM
-- Mobile Version
-- loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

-- تخزين البيانات
local copiedData = nil
local copiedToolName = ""

-- جلب الأداة من إيدك
local function getToolInMyHand()
    local char = plr.Character
    if not char then return nil end
    
    -- إبحث في الإيدين
    local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    local leftHand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
    
    if rightHand then
        for _, child in pairs(rightHand:GetChildren()) do
            if child:IsA("Tool") then
                return child
            end
        end
    end
    
    if leftHand then
        for _, child in pairs(leftHand:GetChildren()) do
            if child:IsA("Tool") then
                return child
            end
        end
    end
    
    return nil
end

-- زر 1: نسخ كل حاجة من الأداة
local function copyEverythingFromTool()
    local tool = getToolInMyHand()
    if not tool then
        return false, "❌ ما في أداة في إيدك"
    end
    
    copiedToolName = tool.Name
    copiedData = {
        name = tool.Name,
        class = tool.ClassName,
        properties = {},
        attributes = {},
        scripts = {}
    }
    
    -- 1. نسخ الخصائص
    local propsToCopy = {
        "ToolTip", "TextureId", "Grip", "GripForward", "GripPos",
        "GripRight", "GripUp", "Enabled", "CanBeDropped", "RequiresHandle"
    }
    
    for _, prop in ipairs(propsToCopy) do
        pcall(function()
            copiedData.properties[prop] = tool[prop]
        end)
    end
    
    -- 2. نسخ ال Attributes
    for _, attr in pairs(tool:GetAttributes()) do
        copiedData.attributes[attr] = tool:GetAttribute(attr)
    end
    
    -- 3. نسخ السكربتات (الأكواد)
    for _, script in pairs(tool:GetDescendants()) do
        if script:IsA("Script") or script:IsA("LocalScript") then
            table.insert(copiedData.scripts, {
                name = script.Name,
                source = script.Source or "",
                class = script.ClassName
            })
        end
    end
    
    return true, "✅ نسخت: " .. tool.Name .. " (" .. #copiedData.scripts .. " سكربت)"
end

-- زر 2: نسخ للحافظة
local function copyToClipboard()
    if not copiedData then
        return false, "❌ ما في بيانات منسوخة"
    end
    
    local text = "📋 بيانات الأداة:\n"
    text = text .. "🔧 الإسم: " .. copiedData.name .. "\n"
    text = text .. "📁 النوع: " .. copiedData.class .. "\n"
    text = text .. "🏷️ عدد الـ Attributes: " .. #copiedData.attributes .. "\n"
    text = text .. "📜 عدد السكربتات: " .. #copiedData.scripts .. "\n\n"
    
    -- إضافة Attributes
    text = text .. "Attributes:\n"
    for attr, value in pairs(copiedData.attributes) do
        text = text .. "- " .. attr .. ": " .. tostring(value) .. "\n"
    end
    
    -- إضافة أسماء السكربتات
    if #copiedData.scripts > 0 then
        text = text .. "\nالسكربتات:\n"
        for i, script in ipairs(copiedData.scripts) do
            text = text .. i .. ". " .. script.name .. " (" .. script.class .. ")\n"
        end
    end
    
    -- النسخ للحافظة
    if setclipboard then
        setclipboard(text)
        return true, "✅ تم النسخ للحافظة!"
    else
        return false, "❌ النسخ للحافظة مش شغال"
    end
end

-- زر 3: نقل المعلومات لأداة تانيه
local function pasteToOtherTool()
    if not copiedData then
        return false, "❌ ما في بيانات منسوخة"
    end
    
    -- الحصول على الأدوات في الإيدين
    local tools = {}
    local char = plr.Character
    if char then
        local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
        local leftHand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        
        if rightHand then
            for _, child in pairs(rightHand:GetChildren()) do
                if child:IsA("Tool") then
                    table.insert(tools, child)
                end
            end
        end
        
        if leftHand then
            for _, child in pairs(leftHand:GetChildren()) do
                if child:IsA("Tool") then
                    table.insert(tools, child)
                end
            end
        end
    end
    
    if #tools < 2 then
        return false, "❌ تحتاج أداتين في إيديك"
    end
    
    -- الأداة الثانية (اللي هتنقل لها)
    local targetTool = tools[2]
    
    -- بدء النقل
    local changes = 0
    
    -- 1. تغيير الخصائص
    for prop, value in pairs(copiedData.properties) do
        pcall(function()
            if prop == "Name" then
                targetTool.Name = value .. "_COPY"
            else
                targetTool[prop] = value
            end
            changes = changes + 1
        end)
    end
    
    -- 2. نقل الـ Attributes
    for attr, value in pairs(copiedData.attributes) do
        pcall(function()
            targetTool:SetAttribute(attr, value)
            changes = changes + 1
        end)
    end
    
    -- 3. محاولة إضافة السكربتات
    for _, scriptData in ipairs(copiedData.scripts) do
        pcall(function()
            local newScript
            if scriptData.class == "LocalScript" then
                newScript = Instance.new("LocalScript")
            else
                newScript = Instance.new("Script")
            end
            
            newScript.Name = scriptData.name .. "_COPY"
            newScript.Source = scriptData.source
            newScript.Disabled = true
            newScript.Parent = targetTool
            changes = changes + 1
        end)
    end
    
    return true, "✅ تم النقل! (" .. changes .. " تغيير)"
end

-- ============================================
-- 📱 واجهة الهاتف
-- ============================================

local ui = Instance.new("ScreenGui")
ui.Name = "ToolCopyPaste"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.35, 0, 0.45, 0)
main.Position = UDim2.new(0.6, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
main.Active = true
main.Draggable = true -- تحريك بالإصبع

-- العنوان
local title = Instance.new("TextLabel")
title.Text = "🔄 نسخ ولصق الأدوات"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
title.TextColor3 = Color3.new(1, 1, 1)

-- زر 1: نسخ من الأداة
local btnCopy = Instance.new("TextButton")
btnCopy.Text = "1️⃣ نسخ من الأداة"
btnCopy.Size = UDim2.new(0.9, 0, 0.2, 0)
btnCopy.Position = UDim2.new(0.05, 0, 0.15, 0)
btnCopy.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
btnCopy.TextColor3 = Color3.new(1, 1, 1)

-- زر 2: نسخ للحافظة
local btnClipboard = Instance.new("TextButton")
btnClipboard.Text = "2️⃣ نسخ للحافظة"
btnClipboard.Size = UDim2.new(0.9, 0, 0.2, 0)
btnClipboard.Position = UDim2.new(0.05, 0, 0.4, 0)
btnClipboard.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
btnClipboard.TextColor3 = Color3.new(1, 1, 1)

-- زر 3: نقل لأداة تانيه
local btnPaste = Instance.new("TextButton")
btnPaste.Text = "3️⃣ نقل لأداة تانيه"
btnPaste.Size = UDim2.new(0.9, 0, 0.2, 0)
btnPaste.Position = UDim2.new(0.05, 0, 0.65, 0)
btnPaste.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
btnPaste.TextColor3 = Color3.new(1, 1, 1)

-- حالة النسخ
local status = Instance.new("TextLabel")
status.Text = "ضع أداة في إيدك واضغط 1️⃣"
status.Size = UDim2.new(0.9, 0, 0.2, 0)
status.Position = UDim2.new(0.05, 0, 0.88, 0)
status.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
status.TextColor3 = Color3.new(1, 1, 1)
status.TextWrapped = true

-- أحداث الأزرار
btnCopy.MouseButton1Click:Connect(function()
    btnCopy.Text = "⏳ جاري النسخ..."
    local success, message = copyEverythingFromTool()
    status.Text = message
    btnCopy.Text = "1️⃣ نسخ من الأداة"
end)

btnClipboard.MouseButton1Click:Connect(function()
    btnClipboard.Text = "⏳ جاري النسخ..."
    local success, message = copyToClipboard()
    status.Text = message
    task.wait(1)
    btnClipboard.Text = "2️⃣ نسخ للحافظة"
end)

btnPaste.MouseButton1Click:Connect(function()
    btnPaste.Text = "⚡ جاري النقل..."
    local success, message = pasteToOtherTool()
    status.Text = message
    btnPaste.Text = "3️⃣ نقل لأداة تانيه"
end)

-- تجميع الواجهة
title.Parent = main
btnCopy.Parent = main
btnClipboard.Parent = main
btnPaste.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = gui

print("🎯 TOOL COPY-PASTE SYSTEM")
print("📱 Mobile Version - Ready")
print("1️⃣ نسخ من الأداة في إيدك")
print("2️⃣ نسخ البيانات للحافظة")
print("3️⃣ نقل البيانات لأداة تانيه")
