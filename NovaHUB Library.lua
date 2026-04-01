local NovaLibrary = {}

function NovaLibrary:CreateWindow(titleText)
    local Window = {}
    
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local lp = Players.LocalPlayer
    local playerGui = lp:WaitForChild("PlayerGui")

    -- ScreenGui Setup
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NovaHUB_Library"
    ScreenGui.ResetOnSpawn = false
    local success = pcall(function() ScreenGui.Parent = CoreGui end)
    if not success or not ScreenGui.Parent then ScreenGui.Parent = playerGui end
    Window.ScreenGui = ScreenGui

    -- Main Frame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local Glow = Instance.new("UIStroke", MainFrame)
    Glow.Color = Color3.fromRGB(170, 0, 255)
    Glow.Thickness = 2
    Glow.Transparency = 0.4

    -- Topbar
    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    Topbar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Topbar.BorderSizePixel = 0
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.RichText = true
    Title.Text = titleText or "<font color='#FFFFFF'>NovaHUB</font>"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 24
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local TitleGrad = Instance.new("UIGradient", Title)
    TitleGrad.Rotation = 90
    TitleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120))
    })

    -- Tab Container
    local TabContainer = Instance.new("Frame", Topbar)
    TabContainer.Size = UDim2.new(1, -210, 1, 0)
    TabContainer.Position = UDim2.new(0, 200, 0, 0)
    TabContainer.BackgroundTransparency = 1
    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.Padding = UDim.new(0, 4)

    -- Page Container
    local PageContainer = Instance.new("Frame", MainFrame)
    PageContainer.Size = UDim2.new(1, -20, 1, -60)
    PageContainer.Position = UDim2.new(0, 10, 0, 55)
    PageContainer.BackgroundTransparency = 1

    -- Dragging Logic
    local dragToggle, dragStart, startPos
    Topbar.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragToggle = true
            dragStart = i.Position
            startPos = MainFrame.Position 
        end 
    end)
    UserInputService.InputChanged:Connect(function(i) 
        if dragToggle and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end 
    end)
    UserInputService.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragToggle = false 
        end 
    end)

    Window.Pages = {}
    Window.FirstTab = true

    -- Watermark Function
    function Window:CreateWatermark(text, offset, isBold)
        local label = Instance.new("TextLabel", ScreenGui)
        label.Size = UDim2.new(0, 250, 0, 25)
        label.Position = UDim2.new(1, -260, 1, offset)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = isBold and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        label.Font = isBold and Enum.Font.GothamBold or Enum.Font.GothamMedium
        label.TextSize = isBold and 16 or 13
        label.TextXAlignment = Enum.TextXAlignment.Right
        label.TextStrokeTransparency = 0.6
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        return label
    end

    -- Tab Function
    function Window:CreateTab(tabName)
        local Tab = {}
        
        -- Create Page
        local page = Instance.new("ScrollingFrame", PageContainer)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = Window.FirstTab
        page.ScrollBarThickness = 2
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
        
        Window.Pages[tabName] = page

        -- Create Tab Button
        local btn = Instance.new("TextButton", TabContainer)
        btn.Size = UDim2.new(0, 75, 0, 32)
        btn.Text = tabName
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
        Instance.new("UICorner", btn)

        btn.MouseButton1Click:Connect(function()
            for name, p in pairs(Window.Pages) do
                p.Visible = (name == tabName)
            end
        end)

        Window.FirstTab = false

        -- Elements inside Tab
        function Tab:CreateToggle(text, defaultState, callback)
            local state = defaultState or false
            local tglBtn = Instance.new("TextButton", page)
            tglBtn.Size = UDim2.new(1, -10, 0, 40)
            tglBtn.Text = text .. (state and ": ON" or ": OFF")
            tglBtn.BackgroundColor3 = state and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(30, 30, 35)
            tglBtn.TextColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(200, 200, 200)
            tglBtn.Font = Enum.Font.GothamBold
            Instance.new("UICorner", tglBtn)

            tglBtn.MouseButton1Click:Connect(function()
                state = not state
                tglBtn.Text = text .. (state and ": ON" or ": OFF")
                tglBtn.BackgroundColor3 = state and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(30, 30, 35)
                tglBtn.TextColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(200, 200, 200)
                if callback then callback(state) end
            end)
        end

        function Tab:CreateSlider(text, min, max, defaultVal, callback)
            local currentVal = defaultVal or min
            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1, -10, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Instance.new("UICorner", frame)
            
            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.Text = text .. ": " .. tostring(currentVal)
            label.TextColor3 = Color3.new(1, 1, 1)
            label.BackgroundTransparency = 1
            
            local sliderBg = Instance.new("TextButton", frame)
            sliderBg.Size = UDim2.new(1, -20, 0, 10)
            sliderBg.Position = UDim2.new(0, 10, 0, 30)
            sliderBg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            sliderBg.Text = ""
            
            local fill = Instance.new("Frame", sliderBg)
            fill.Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
            
            local dragging = false
            sliderBg.InputBegan:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end 
            end)
            UserInputService.InputEnded:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
            end)
            RunService.RenderStepped:Connect(function() 
                if dragging then 
                    local pos = math.clamp((UserInputService:GetMouseLocation().X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + ((max - min) * pos))
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    label.Text = text .. ": " .. tostring(val)
                    if currentVal ~= val then
                        currentVal = val
                        if callback then callback(val) end
                    end
                end 
            end)
        end

        function Tab:CreateButton(text, color, callback)
            local btn = Instance.new("TextButton", page)
            btn.Size = UDim2.new(1, -10, 0, 40)
            btn.Text = text
            btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 50)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.GothamMedium
            Instance.new("UICorner", btn)
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            return btn
        end

        function Tab:CreateTextBox(placeholder, callback)
            local box = Instance.new("TextBox", page)
            box.Size = UDim2.new(1, -10, 0, 40)
            box.PlaceholderText = placeholder
            box.Text = ""
            box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.Font = Enum.Font.GothamMedium
            Instance.new("UICorner", box)
            
            box.FocusLost:Connect(function()
                if callback then callback(box.Text) end
            end)
            return box
        end

        return Tab
    end

    return Window
end

return NovaLibrary
