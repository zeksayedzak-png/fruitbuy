-- Trade System Analyzer
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer

-- System Information Collection
local function collectSystemInfo()
    local systems = {}
    
    -- Collect RemoteEvents
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(systems, {
                name = obj.Name,
                type = "RemoteEvent",
                path = obj:GetFullName(),
                object = obj
            })
        end
        
        if obj:IsA("RemoteFunction") then
            table.insert(systems, {
                name = obj.Name,
                type = "RemoteFunction",
                path = obj:GetFullName(),
                object = obj
            })
        end
    end
    
    return systems
end

-- Format Information for Display
local function formatSystemInfo(system)
    local text = ""
    text = text .. "📌 Name: " .. system.name .. "\n"
    text = text .. "📁 Type: " .. system.type .. "\n"
    text = text .. "📍 Path: " .. system.path .. "\n"
    text = text .. string.rep("-", 40) .. "\n"
    return text
end

-- Mobile Interface
local function createMobileInterface()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SystemAnalyzer"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "📊 System Analyzer"
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- Scan Button
    local scanBtn = Instance.new("TextButton")
    scanBtn.Text = "🔍 Scan Systems"
    scanBtn.Size = UDim2.new(0.9, 0, 0.1, 0)
    scanBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
    scanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    scanBtn.TextColor3 = Color3.new(1, 1, 1)
    scanBtn.Font = Enum.Font.SourceSansBold
    
    -- Results Display
    local resultsFrame = Instance.new("ScrollingFrame")
    resultsFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
    resultsFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
    resultsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    resultsFrame.BorderSizePixel = 1
    resultsFrame.ScrollBarThickness = 8
    resultsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local resultsLayout = Instance.new("UIListLayout")
    resultsLayout.Parent = resultsFrame
    
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = "Ready for scanning"
    statusLabel.Size = UDim2.new(1, 0, 0.08, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.96, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.TextWrapped = true
    
    -- Scan Function
    scanBtn.MouseButton1Click:Connect(function()
        scanBtn.Text = "⏳ Scanning..."
        statusLabel.Text = "Collecting system information..."
        
        -- Clear previous results
        for _, child in ipairs(resultsFrame:GetChildren()) do
            if not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end
        
        task.spawn(function()
            local systems = collectSystemInfo()
            
            -- Filter relevant systems
            local relevantSystems = {}
            for _, system in ipairs(systems) do
                local lowerName = system.name:lower()
                if lowerName:find("add") or 
                   lowerName:find("trade") or 
                   lowerName:find("item") or
                   lowerName:find("purchase") then
                    table.insert(relevantSystems, system)
                end
            end
            
            -- Display results
            if #relevantSystems == 0 then
                statusLabel.Text = "No relevant systems found"
                return
            end
            
            for _, system in ipairs(relevantSystems) do
                local infoFrame = Instance.new("Frame")
                infoFrame.Size = UDim2.new(1, 0, 0, 70)
                infoFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                
                local infoLabel = Instance.new("TextLabel")
                infoLabel.Text = formatSystemInfo(system)
                infoLabel.Size = UDim2.new(0.95, 0, 0.9, 0)
                infoLabel.Position = UDim2.new(0.025, 0, 0.05, 0)
                infoLabel.BackgroundTransparency = 1
                infoLabel.TextColor3 = Color3.new(1, 1, 1)
                infoLabel.TextXAlignment = Enum.TextXAlignment.Left
                infoLabel.TextWrapped = true
                
                infoLabel.Parent = infoFrame
                infoFrame.Parent = resultsFrame
            end
            
            statusLabel.Text = "Found " .. #relevantSystems .. " relevant systems"
            scanBtn.Text = "🔍 Scan Systems"
        end)
    end)
    
    -- Copy Button
    local copyBtn = Instance.new("TextButton")
    copyBtn.Text = "📋 Copy Info"
    copyBtn.Size = UDim2.new(0.44, 0, 0.08, 0)
    copyBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
    copyBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    copyBtn.TextColor3 = Color3.new(1, 1, 1)
    copyBtn.Visible = false
    
    -- Test Button
    local testBtn = Instance.new("TextButton")
    testBtn.Text = "⚡ Test System"
    testBtn.Size = UDim2.new(0.44, 0, 0.08, 0)
    testBtn.Position = UDim2.new(0.51, 0, 0.12, 0)
    testBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    testBtn.TextColor3 = Color3.new(1, 1, 1)
    testBtn.Visible = false
    
    -- Assembly
    title.Parent = mainFrame
    scanBtn.Parent = mainFrame
    copyBtn.Parent = mainFrame
    testBtn.Parent = mainFrame
    resultsFrame.Parent = mainFrame
    statusLabel.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- Console Commands
_G.Scan = function()
    local systems = collectSystemInfo()
    local count = 0
    for _, system in ipairs(systems) do
        local lowerName = system.name:lower()
        if lowerName:find("add") or lowerName:find("trade") or lowerName:find("item") then
            print("📌 " .. system.name .. " | " .. system.type .. " | " .. system.path)
            count = count + 1
        end
    end
    return "Found " .. count .. " relevant systems"
end

-- Startup
print([[
    
📊 System Analyzer
🔍 Tool for analyzing game systems

This tool helps identify and analyze
RemoteEvents and RemoteFunctions in
the current game environment.

Commands:
_G.Scan() - Scan for relevant systems

]])

createMobileInterface()
print("✅ System Analyzer ready")
