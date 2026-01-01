-- 🍭 CANDY AUTO FARM BOT
-- Mobile Version

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- إعدادات البوت
local CandyBot = {
    enabled = false,
    targetNPC = nil,
    candyCollected = 0,
    farmingSpot = 1
}

-- البحث عن أقرب NPC كريسماس
local function findNearestChristmasNPC()
    local closest = nil
    local closestDist = math.huge
    
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        local npcName = npc.Name:lower()
        if npcName:find("christmas") or npcName:find("santa") or 
           npcName:find("elf") or npcName:find("snow") then
            
            if npc:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                if dist < 100 and dist < closestDist then
                    closest = npc
                    closestDist = dist
                end
            end
        end
    end
    
    return closest
end

-- الهجوم على NPC
local function attackNPC(npc)
    if not npc or not npc:FindFirstChild("Humanoid") then return end
    
    -- التوجه نحو NPC
    char.HumanoidRootPart.CFrame = CFrame.new(
        npc.HumanoidRootPart.Position + Vector3.new(0, 0, 5),
        npc.HumanoidRootPart.Position
    )
    
    -- استخدام الهجوم
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
    
    -- إرسال طلب هجوم
    pcall(function()
        game:GetService("ReplicatedStorage").Combat:FireServer("Attack", npc)
    end)
    
    -- التحقق من موت NPC
    if npc.Humanoid.Health <= 0 then
        -- المطالبة بالـ Candy
        pcall(function()
            game:GetService("ReplicatedStorage").ChristmasEvents.ClaimCandy:FireServer(npc.Name)
            CandyBot.candyCollected = CandyBot.candyCollected + 1
        end)
    end
end

-- البحث عن صناديق
local function findChristmasBoxes()
    local boxes = {}
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:find("ChristmasBox") or obj.Name:find("Gift") then
            table.insert(boxes, obj)
        end
    end
    
    return boxes
end

-- فتح الصندوق
local function openBox(box)
    char.HumanoidRootPart.CFrame = box.CFrame * CFrame.new(0, 0, -3)
    
    pcall(function()
        game:GetService("ReplicatedStorage").ChristmasEvents.OpenGift:FireServer(box.Name)
        CandyBot.candyCollected = CandyBot.candyCollected + 5  -- كل صندوق يعطي 5 candy
    end)
end

-- دورة الفارم الرئيسية
local function farmingLoop()
    while CandyBot.enabled do
        -- 1. البحث عن NPC
        local npc = findNearestChristmasNPC()
        if npc then
            attackNPC(npc)
            task.wait(1)
        end
        
        -- 2. البحث عن صناديق
        local boxes = findChristmasBoxes()
        if #boxes > 0 then
            openBox(boxes[1])
            task.wait(0.5)
        end
        
        -- 3. إذا ما فيش حاجة، تحرك لمنطقة تانيه
        if not npc and #boxes == 0 then
            -- تحرك لمناطق الكريسماس
            local spots = {
                Vector3.new(100, 50, 100),   -- Santa's Workshop
                Vector3.new(-200, 20, 150),  -- Snowfield
                Vector3.new(0, 30, 0)        -- Christmas Village
            }
            
            char.HumanoidRootPart.CFrame = CFrame.new(spots[CandyBot.farmingSpot])
            CandyBot.farmingSpot = CandyBot.farmingSpot + 1
            if CandyBot.farmingSpot > 3 then CandyBot.farmingSpot = 1 end
        end
        
        task.wait(2)
    end
end

-- 📱 واجهة البوت
local ui = Instance.new("ScreenGui")
ui.Name = "CandyBot"
ui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0.35, 0, 0.3, 0)
main.Position = UDim2.new(0.6, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "🍭 CANDY FARM BOT"
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "▶ تشغيل البوت"
toggleBtn.Size = UDim2.new(0.9, 0, 0.3, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

local status = Instance.new("TextLabel")
status.Text = "Candy: 0\nالبوت متوقف"
status.Size = UDim2.new(0.9, 0, 0.35, 0)
status.Position = UDim2.new(0.05, 0, 0.6, 0)
status.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
status.TextWrapped = true

-- حدث التشغيل/الإيقاف
toggleBtn.MouseButton1Click:Connect(function()
    CandyBot.enabled = not CandyBot.enabled
    
    if CandyBot.enabled then
        toggleBtn.Text = "⏸ إيقاف البوت"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        status.Text = "البوت شغال...\nCandy: " .. CandyBot.candyCollected
        
        -- بدء الفارم
        task.spawn(farmingLoop)
    else
        toggleBtn.Text = "▶ تشغيل البوت"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        status.Text = "البوت متوقف\nCandy: " .. CandyBot.candyCollected
    end
end)

-- تحديث العداد
game:GetService("RunService").Heartbeat:Connect(function()
    if CandyBot.enabled then
        status.Text = "البوت شغال...\nCandy: " .. CandyBot.candyCollected
    end
end)

-- التجميع
title.Parent = main
toggleBtn.Parent = main
status.Parent = main
main.Parent = ui
ui.Parent = plr.PlayerGui

print("🍭 CANDY FARM BOT - READY!")
print("🎯 يصطاد NPCs كريسماس")
print("🎁 يفتح صناديق الهدايا")
print("💰 يجمع Candy تلقائياً")
