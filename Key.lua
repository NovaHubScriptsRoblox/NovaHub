local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Configuration
local SERVER_URL = "http://85.215.229.230:9814/verify?key="

local function loadSystem()
    -- Main Container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystem"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 320, 0, 180)
    Main.Position = UDim2.new(0.5, -160, 0.5, -90)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    -- Styling: Rounded Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main

    -- Drop Shadow / Border Glow Effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(45, 45, 45)
    UIStroke.Thickness = 2
    UIStroke.Parent = Main

    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "AUTHENTICATION"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Main

    -- Input Field
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0, 260, 0, 40)
    Input.Position = UDim2.new(0.5, -130, 0.35, 0)
    Input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Input.BorderSizePixel = 0
    Input.PlaceholderText = "Enter Key From Bot..."
    Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    Input.Text = ""
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 14
    Input.Parent = Main

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = Input

    -- Submit Button
    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(0, 260, 0, 40)
    Submit.Position = UDim2.new(0.5, -130, 0.65, 0)
    Submit.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    Submit.BorderSizePixel = 0
    Submit.Text = "Verify Key"
    Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    Submit.Font = Enum.Font.GothamBold
    Submit.TextSize = 14
    Submit.AutoButtonColor = false
    Submit.Parent = Main

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 6)
    SubmitCorner.Parent = Submit

    -- Hover Animations
    Submit.MouseEnter:Connect(function()
        TweenService:Create(Submit, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 140, 255)}):Play()
    end)
    Submit.MouseLeave:Connect(function()
        TweenService:Create(Submit, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 120, 255)}):Play()
    end)

    -- Logic
    Submit.MouseButton1Click:Connect(function()
        Submit.Text = "Checking..."
        Submit.Active = false

        local success, result = pcall(function()
            return game:HttpGet(SERVER_URL .. Input.Text)
        end)

        if success and not result:find("Invalid") then
            Submit.Text = "Success!"
            Submit.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            task.wait(1)
            ScreenGui:Destroy()
            
            local func, err = loadstring(result)
            if func then 
                func() 
            else 
                warn("Error loading Main.Lua: " .. tostring(err))
            end
        else
            Submit.Text = "Invalid Key"
            Submit.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
            task.wait(1.5)
            Submit.Text = "Verify Key"
            Submit.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            Submit.Active = true
            Input.Text = ""
        end
    end)
end

loadSystem()
