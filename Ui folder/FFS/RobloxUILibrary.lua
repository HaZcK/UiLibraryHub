--[[
    UI Library Roblox - Lengkap dengan Komponen
    Dibuat untuk memudahkan pembuatan GUI di Roblox
    
    Fitur:
    - Window dengan Draggable
    - Multiple Tabs
    - Button, Toggle, Slider, Dropdown, Textbox, Keybind
    - Notifications
    - Responsive dan Modern Design
]]

local UILibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Fungsi Utility untuk Tweening
local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Fungsi untuk membuat draggable frame
local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

-- Fungsi utama untuk membuat Window
function UILibrary:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "UI Library"
    local windowSize = config.Size or UDim2.new(0, 550, 0, 400)
    
    -- ScreenGui utama
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary_" .. windowName
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Cek apakah menggunakan CoreGui atau PlayerGui
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = windowSize
    MainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    -- Title Cover (untuk membuat sudut bawah square)
    local TitleCover = Instance.new("Frame")
    TitleCover.Size = UDim2.new(1, 0, 0, 8)
    TitleCover.Position = UDim2.new(0, 0, 1, -8)
    TitleCover.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    TitleCover.BorderSizePixel = 0
    TitleCover.Parent = TitleBar
    
    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    MinimizeButton.Text = "—"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 14
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TitleBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -180, 1, -50)
    ContentContainer.Position = UDim2.new(0, 170, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Draggable
    MakeDraggable(MainFrame, TitleBar)
    
    -- Close Button Function
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Minimize Function
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(0, windowSize.X.Offset, 0, 40)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Tween(MainFrame, {Size = windowSize}, 0.3)
            MinimizeButton.Text = "—"
        end
    end)
    
    -- Hover effects
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
    end)
    
    -- Window Object
    local Window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TabContainer = TabContainer,
        ContentContainer = ContentContainer,
        Tabs = {}
    }
    
    -- Fungsi untuk membuat Tab
    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "_Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentList.Padding = UDim.new(0, 8)
        TabContentList.Parent = TabContent
        
        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.PaddingTop = UDim.new(0, 10)
        TabContentPadding.PaddingLeft = UDim.new(0, 10)
        TabContentPadding.PaddingRight = UDim.new(0, 10)
        TabContentPadding.PaddingBottom = UDim.new(0, 10)
        TabContentPadding.Parent = TabContent
        
        -- Auto Canvas Size
        TabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 50), TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.2)
            end
            
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(70, 130, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end)
        
        -- Hover Effect
        TabButton.MouseEnter:Connect(function()
            if TabContent.Visible == false then
                Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabContent.Visible == false then
                Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}, 0.2)
            end
        end)
        
        -- Tab Object
        local Tab = {
            Button = TabButton,
            Content = TabContent,
            Elements = {}
        }
        
        table.insert(Window.Tabs, Tab)
        
        -- Set first tab as active
        if #Window.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        -- Fungsi untuk menambah Section
        function Tab:AddSection(sectionName)
            local Section = Instance.new("TextLabel")
            Section.Name = "Section"
            Section.Size = UDim2.new(1, 0, 0, 30)
            Section.BackgroundTransparency = 1
            Section.Text = sectionName
            Section.TextColor3 = Color3.fromRGB(255, 255, 255)
            Section.TextSize = 16
            Section.Font = Enum.Font.GothamBold
            Section.TextXAlignment = Enum.TextXAlignment.Left
            Section.Parent = TabContent
            
            return Section
        end
        
        -- Fungsi untuk menambah Label
        function Tab:AddLabel(labelText)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = labelText
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = TabContent
            
            return Label
        end
        
        -- Fungsi untuk menambah Button
        function Tab:AddButton(config)
            config = config or {}
            local buttonName = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            Button.Text = buttonName
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Font = Enum.Font.Gotham
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.1)
                wait(0.1)
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.1)
                callback()
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
            end)
            
            return Button
        end
        
        -- Fungsi untuk menambah Toggle
        function Tab:AddToggle(config)
            config = config or {}
            local toggleName = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleName
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleButton.BackgroundColor3 = default and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(60, 60, 80)
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                end
                
                callback(toggled)
            end)
            
            local Toggle = {
                Frame = ToggleFrame,
                Button = ToggleButton,
                Value = toggled
            }
            
            function Toggle:SetValue(value)
                toggled = value
                Toggle.Value = value
                
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                end
                
                callback(toggled)
            end
            
            return Toggle
        end
        
        -- Fungsi untuk menambah Slider
        function Tab:AddSlider(config)
            config = config or {}
            local sliderName = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or 50
            local increment = config.Increment or 1
            local callback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -60, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderName
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -55, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Color3.fromRGB(70, 130, 255)
            SliderValue.TextSize = 13
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            SliderBar.Position = UDim2.new(0, 10, 1, -15)
            SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar
            
            local dragging = false
            local value = default
            
            local function updateSlider(input)
                local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor((min + (max - min) * relativeX) / increment + 0.5) * increment
                value = math.clamp(value, min, max)
                
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
                callback(value)
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            local Slider = {
                Frame = SliderFrame,
                Value = value
            }
            
            function Slider:SetValue(newValue)
                value = math.clamp(newValue, min, max)
                Slider.Value = value
                local relativeX = (value - min) / (max - min)
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.2)
                callback(value)
            end
            
            return Slider
        end
        
        -- Fungsi untuk menambah Dropdown
        function Tab:AddDropdown(config)
            config = config or {}
            local dropdownName = config.Name or "Dropdown"
            local options = config.Options or {"Option 1", "Option 2", "Option 3"}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 35)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -60, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = dropdownName
            DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownValue = Instance.new("TextLabel")
            DropdownValue.Size = UDim2.new(0, 100, 0, 35)
            DropdownValue.Position = UDim2.new(1, -110, 0, 0)
            DropdownValue.BackgroundTransparency = 1
            DropdownValue.Text = default
            DropdownValue.TextColor3 = Color3.fromRGB(70, 130, 255)
            DropdownValue.TextSize = 13
            DropdownValue.Font = Enum.Font.Gotham
            DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
            DropdownValue.Parent = DropdownFrame
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 0, 35)
            DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            DropdownArrow.TextSize = 10
            DropdownArrow.Font = Enum.Font.Gotham
            DropdownArrow.Parent = DropdownFrame
            
            local OptionsList = Instance.new("ScrollingFrame")
            OptionsList.Size = UDim2.new(1, 0, 0, 0)
            OptionsList.Position = UDim2.new(0, 0, 0, 35)
            OptionsList.BackgroundTransparency = 1
            OptionsList.BorderSizePixel = 0
            OptionsList.ScrollBarThickness = 2
            OptionsList.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
            OptionsList.Parent = DropdownFrame
            
            local OptionsListLayout = Instance.new("UIListLayout")
            OptionsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsListLayout.Parent = OptionsList
            
            local expanded = false
            local selectedOption = default
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptionButton.TextSize = 13
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Parent = OptionsList
                
                OptionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    DropdownValue.Text = option
                    callback(option)
                    
                    expanded = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(55, 55, 75)}, 0.1)
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}, 0.1)
                end)
            end
            
            OptionsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                OptionsList.CanvasSize = UDim2.new(0, 0, 0, OptionsListLayout.AbsoluteContentSize.Y)
            end)
            
            DropdownButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                
                if expanded then
                    local contentHeight = math.min(#options * 30, 120)
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35 + contentHeight)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 180}, 0.2)
                    OptionsList.Size = UDim2.new(1, 0, 0, contentHeight)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                end
            end)
            
            local Dropdown = {
                Frame = DropdownFrame,
                Value = selectedOption
            }
            
            function Dropdown:SetValue(option)
                if table.find(options, option) then
                    selectedOption = option
                    Dropdown.Value = option
                    DropdownValue.Text = option
                    callback(option)
                end
            end
            
            return Dropdown
        end
        
        -- Fungsi untuk menambah Textbox
        function Tab:AddTextbox(config)
            config = config or {}
            local textboxName = config.Name or "Textbox"
            local default = config.Default or ""
            local placeholder = config.Placeholder or "Enter text..."
            local callback = config.Callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = "Textbox"
            TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            TextboxFrame.Parent = TabContent
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 6)
            TextboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = textboxName
            TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(1, -20, 0, 25)
            Textbox.Position = UDim2.new(0, 10, 0, 28)
            Textbox.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            Textbox.Text = default
            Textbox.PlaceholderText = placeholder
            Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            Textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            Textbox.TextSize = 13
            Textbox.Font = Enum.Font.Gotham
            Textbox.ClearTextOnFocus = false
            Textbox.Parent = TextboxFrame
            
            local TextboxInputCorner = Instance.new("UICorner")
            TextboxInputCorner.CornerRadius = UDim.new(0, 4)
            TextboxInputCorner.Parent = Textbox
            
            local TextboxPadding = Instance.new("UIPadding")
            TextboxPadding.PaddingLeft = UDim.new(0, 8)
            TextboxPadding.PaddingRight = UDim.new(0, 8)
            TextboxPadding.Parent = Textbox
            
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(Textbox.Text)
                end
            end)
            
            local TextboxObject = {
                Frame = TextboxFrame,
                Textbox = Textbox,
                Value = default
            }
            
            function TextboxObject:SetValue(text)
                Textbox.Text = text
                TextboxObject.Value = text
                callback(text)
            end
            
            return TextboxObject
        end
        
        -- Fungsi untuk menambah Keybind
        function Tab:AddKeybind(config)
            config = config or {}
            local keybindName = config.Name or "Keybind"
            local default = config.Default or Enum.KeyCode.E
            local callback = config.Callback or function() end
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = "Keybind"
            KeybindFrame.Size = UDim2.new(1, 0, 0, 35)
            KeybindFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            KeybindFrame.Parent = TabContent
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 6)
            KeybindCorner.Parent = KeybindFrame
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = keybindName
            KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindLabel.TextSize = 14
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 70, 0, 25)
            KeybindButton.Position = UDim2.new(1, -75, 0.5, -12.5)
            KeybindButton.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            KeybindButton.Text = default.Name
            KeybindButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            KeybindButton.TextSize = 12
            KeybindButton.Font = Enum.Font.Gotham
            KeybindButton.Parent = KeybindFrame
            
            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 4)
            KeybindButtonCorner.Parent = KeybindButton
            
            local currentKey = default
            local listening = false
            
            KeybindButton.MouseButton1Click:Connect(function()
                listening = true
                KeybindButton.Text = "..."
                Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    KeybindButton.Text = input.KeyCode.Name
                    Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 48)}, 0.2)
                end
                
                if not gameProcessed and input.KeyCode == currentKey then
                    callback()
                end
            end)
            
            local Keybind = {
                Frame = KeybindFrame,
                Button = KeybindButton,
                Key = currentKey
            }
            
            function Keybind:SetKey(key)
                currentKey = key
                Keybind.Key = key
                KeybindButton.Text = key.Name
            end
            
            return Keybind
        end
        
        return Tab
    end
    
    -- Fungsi untuk membuat Notification
    function Window:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local content = config.Content or "This is a notification"
        local duration = config.Duration or 3
        
        local NotifContainer = Instance.new("Frame")
        NotifContainer.Size = UDim2.new(0, 300, 0, 0)
        NotifContainer.Position = UDim2.new(1, -310, 1, -10)
        NotifContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        NotifContainer.BorderSizePixel = 0
        NotifContainer.Parent = ScreenGui
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 8)
        NotifCorner.Parent = NotifContainer
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -20, 0, 25)
        NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifTitle.TextSize = 15
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = NotifContainer
        
        local NotifContent = Instance.new("TextLabel")
        NotifContent.Size = UDim2.new(1, -20, 1, -35)
        NotifContent.Position = UDim2.new(0, 10, 0, 28)
        NotifContent.BackgroundTransparency = 1
        NotifContent.Text = content
        NotifContent.TextColor3 = Color3.fromRGB(200, 200, 200)
        NotifContent.TextSize = 13
        NotifContent.Font = Enum.Font.Gotham
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.TextYAlignment = Enum.TextYAlignment.Top
        NotifContent.TextWrapped = true
        NotifContent.Parent = NotifContainer
        
        -- Calculate height based on text
        local textSize = game:GetService("TextService"):GetTextSize(
            content,
            13,
            Enum.Font.Gotham,
            Vector2.new(280, math.huge)
        )
        
        local finalHeight = math.max(60, textSize.Y + 40)
        
        -- Animate in
        Tween(NotifContainer, {Size = UDim2.new(0, 300, 0, finalHeight)}, 0.3)
        
        wait(duration)
        
        -- Animate out
        Tween(NotifContainer, {
            Size = UDim2.new(0, 300, 0, 0),
            Position = UDim2.new(1, -310, 1, -10)
        }, 0.3)
        
        wait(0.3)
        NotifContainer:Destroy()
    end
    
    return Window
end

return UILibrary
