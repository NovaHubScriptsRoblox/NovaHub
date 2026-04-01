local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Configuration
local SERVER_URL = "http://85.215.229.230:9814/verify?key="
local SCRIPT_BASE_URL = "http://85.215.229.230:9814/Scripts/" -- Change this to where your scripts are hosted

-- Add your games here
local Games = {
    ["Highway Legends"] = "HL.lua"
}

local function loadSystem()
    -- Main Container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystem"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 320, 0, 220) -- Slightly taller for the list
    Main.Position = UDim2.new(0.5, -160, 0.5, -110)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(45, 45, 45)
    UIStroke.Thickness = 2
    UIStroke.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "AUTHENTICATION"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Main

    -- Verification Group (Container for login elements)
    local LoginFrame = Instance.new("Frame")
    LoginFrame.Size = UDim2.new(1, 0, 1, -40)
    LoginFrame.Position = UDim2.new(0, 0, 0, 40)
    LoginFrame.BackgroundTransparency = 1
    LoginFrame.Parent = Main

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0, 260, 0, 40)
    Input.Position = UDim2.new(0.5, -130, 0.2, 0)
    Input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Input.PlaceholderText = "Enter Key From Bot..."
    Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    Input.Text = ""
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 14
    Input.Parent = LoginFrame

    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(0, 260, 0, 40)
    Submit.Position = UDim2.new(0.5, -130, 0.55, 0)
    Submit.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    Submit.Text = "Verify Key"
    Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    Submit.Font = Enum.Font.GothamBold
    Submit.TextSize = 14
    Submit.AutoButtonColor = false
    Submit.Parent = LoginFrame

    Instance.new("UICorner", Submit).CornerRadius = UDim.new(0, 6)

    -- Function to show game selector
    local function showGameSelector()
        LoginFrame:Destroy()
        Title.Text = "SELECT A GAME"
        
        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(0, 280, 0, 150)
        Scroll.Position = UDim2.new(0.5, -140, 0, 50)
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.ScrollBarThickness = 2
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto adjusts
        Scroll.Parent = Main

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 5)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Layout.Parent = Scroll

        for gameName, fileName in pairs(Games) do
            local GameBtn = Instance.new("TextButton")
            GameBtn.Size = UDim2.new(1, -10, 0, 35)
            GameBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            GameBtn.Text = gameName
            GameBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            GameBtn.Font = Enum.Font.Gotham
            GameBtn.TextSize = 13
            GameBtn.Parent = Scroll
            
            Instance.new("UICorner", GameBtn).CornerRadius = UDim.new(0, 4)

            GameBtn.MouseButton1Click:Connect(function()
                GameBtn.Text = "Loading..."
                local scriptSuccess, scriptResult = pcall(function()
                    return game:HttpGet(SCRIPT_BASE_URL .. fileName)
                end)

                if scriptSuccess then
                    ScreenGui:Destroy()
                    local func, err = loadstring(scriptResult)
                    if func then func() else warn("Script Error: " .. err) end
                else
                    GameBtn.Text = "Failed to load"
                    task.wait(1)
                    GameBtn.Text = gameName
                end
            end)
        end
        
        -- Adjust canvas size based on list content
        Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end

    -- Authentication Logic
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
            showGameSelector() -- Transition to the list
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
