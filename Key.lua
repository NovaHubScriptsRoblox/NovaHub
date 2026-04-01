local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local SERVER_URL = "http://85.215.229.230:9814/verify?key="

local function loadSystem()
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 300, 0, 150)
    Main.Position = UDim2.new(0.5, -150, 0.5, -75)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

    local Input = Instance.new("TextBox", Main)
    Input.Size = UDim2.new(0, 250, 0, 40)
    Input.Position = UDim2.new(0.5, -125, 0.2, 0)
    Input.PlaceholderText = "Enter Key From Bot..."

    local Submit = Instance.new("TextButton", Main)
    Submit.Size = UDim2.new(0, 100, 0, 40)
    Submit.Position = UDim2.new(0.5, -50, 0.6, 0)
    Submit.Text = "Verify"

    Submit.MouseButton1Click:Connect(function()
        -- This will return the actual code of Main.Lua if the key is valid
        local success, result = pcall(function()
            return game:HttpGet(SERVER_URL .. Input.Text)
        end)

        if success and not result:find("Invalid") then
            ScreenGui:Destroy()
            local func, err = loadstring(result)
            if func then 
                func() 
            else 
                warn("Error loading Main.Lua: " .. tostring(err))
            end
        else
            Input.Text = ""
            Input.PlaceholderText = "WRONG KEY"
        end
    end)
end

loadSystem()
