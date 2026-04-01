local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- CONFIGURATION
local BASE_URL = "http://85.215.229.230:9814"
local VERIFY_URL = BASE_URL .. "/verify?key="
local SCRIPT_URL = BASE_URL .. "/scripts/"

-- ADD YOUR GAMES HERE
local Games = {
    ["Highway Legends"] = "HL.lua",
    ["Deathrun RNG"] = "DRRNG.lua"
}

local SavedKey = ""

local function loadSystem()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NovaHUB_Loader"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 320, 0, 220)
    Main.Position = UDim2.new(0.5, -160, 0.5, -110)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(50, 50, 50)
    Stroke.Thickness = 2

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Text = "NovaHUB | AUTHENTICATION"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = Main

    -- LOGIN UI CONTAINER
    local LoginFrame = Instance.new("Frame")
    LoginFrame.Size = UDim2.new(1, 0, 1, -45)
    LoginFrame.Position = UDim2.new(0, 0, 0, 45)
    LoginFrame.BackgroundTransparency = 1
    LoginFrame.Parent = Main

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0, 260, 0, 40)
    Input.Position = UDim2.new(0.5, -130, 0.2, 0)
    Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Input.PlaceholderText = "Enter Key..."
    Input.Text = ""
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.Font = Enum.Font.Gotham
    Input.Parent = LoginFrame
    Instance.new("UICorner", Input)

    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(0, 260, 0, 40)
    Submit.Position = UDim2.new(0.5, -130, 0.55, 0)
    Submit.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    Submit.Text = "Verify"
    Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    Submit.Font = Enum.Font.GothamBold
    Submit.Parent = LoginFrame
    Instance.new("UICorner", Submit)

    -- GAME SELECTION LOGIC
    local function showGameSelector()
        LoginFrame:Destroy()
        Title.Text = "NovaHUB | SELECT GAME"

        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(0, 280, 0, 150)
        Scroll.Position = UDim2.new(0.5, -140, 0, 55)
        Scroll.BackgroundTransparency = 1
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.ScrollBarThickness = 3
        Scroll.Parent = Main

        local Layout = Instance.new("UIListLayout", Scroll)
        Layout.Padding = UDim.new(0, 8)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        for name, file in pairs(Games) do
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Btn.Text = name
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.Parent = Scroll
            Instance.new("UICorner", Btn)

            Btn.MouseButton1Click:Connect(function()
                Btn.Text = "Fetching..."
                -- REQUEST WITH KEY AND ROBLOX USER-AGENT
                local success, scriptData = pcall(function()
                    return game:HttpGet(SCRIPT_URL .. file .. "?key=" .. SavedKey)
                end)

                if success and not scriptData:find("Access Denied") then
                    ScreenGui:Destroy()
                    loadstring(scriptData)()
                else
                    Btn.Text = "Error Loading!"
                    task.wait(1)
                    Btn.Text = name
                end
            end)
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end

    Submit.MouseButton1Click:Connect(function()
        Submit.Text = "Checking..."
        local success, result = pcall(function()
            return game:HttpGet(VERIFY_URL .. Input.Text)
        end)

        if success and result == "Success" then
            SavedKey = Input.Text
            Submit.Text = "Verified!"
            Submit.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            task.wait(0.5)
            showGameSelector()
        else
            Submit.Text = "Invalid Key"
            Submit.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            task.wait(1)
            Submit.Text = "Verify"
            Submit.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
        end
    end)
end

loadSystem()
