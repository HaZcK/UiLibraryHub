--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║        ADVANCED ROBLOX UI LIBRARY - TITLE BAR SYSTEM          ║
    ║    Minimize, Maximize, Close, Transparency Controls           ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local UILib_Core = require(script.Parent.UILib_Core)
local Utility = UILib_Core.Utility

local TitleBarSystem = {}

function TitleBarSystem.CreateTitleBar(Window)
    -- Title Bar Container
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Name = "TitleBar"
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 45)
    Window.TitleBar.BackgroundColor3 = Window.ThemeManager.CurrentTheme.SecondaryBackground
    Window.TitleBar.BorderSizePixel = 0
    Window.TitleBar.BackgroundTransparency = Window.Transparency
    Window.TitleBar.ZIndex = 10
    Window.TitleBar.Parent = Window.MainFrame
    
    Utility.CreateCorner(Window.ThemeManager.CurrentTheme.BorderRadius).Parent = Window.TitleBar
    
    -- Cover for bottom corners
    local TitleCover = Instance.new("Frame")
    TitleCover.Size = UDim2.new(1, 0, 0, 10)
    TitleCover.Position = UDim2.new(0, 0, 1, -10)
    TitleCover.BackgroundColor3 = Window.ThemeManager.CurrentTheme.SecondaryBackground
    TitleCover.BorderSizePixel = 0
    TitleCover.BackgroundTransparency = Window.Transparency
    TitleCover.Parent = Window.TitleBar
    
    -- Accent Line
    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(1, 0, 0, 2)
    AccentLine.Position = UDim2.new(0, 0, 1, 0)
    AccentLine.BackgroundColor3 = Window.ThemeManager.CurrentTheme.AccentColor
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = Window.TitleBar
    
    -- Title Icon (optional)
    if Window.Icon then
        Window.TitleIcon = Window.IconManager:CreateIcon(Window.Icon, UDim2.new(0, 24, 0, 24), Window.TitleBar)
        Window.TitleIcon.Position = UDim2.new(0, 12, 0.5, -12)
        Window.TitleIcon.ImageColor3 = Window.ThemeManager.CurrentTheme.AccentColor
    end
    
    -- Title Text
    Window.TitleLabel = Instance.new("TextLabel")
    Window.TitleLabel.Name = "TitleLabel"
    Window.TitleLabel.Size = UDim2.new(1, -200, 1, 0)
    Window.TitleLabel.Position = UDim2.new(0, Window.Icon and 45 or 15, 0, 0)
    Window.TitleLabel.BackgroundTransparency = 1
    Window.TitleLabel.Text = Window.Name
    Window.TitleLabel.TextColor3 = Window.ThemeManager.CurrentTheme.TextColor
    Window.TitleLabel.TextSize = 16
    Window.TitleLabel.Font = Enum.Font.GothamBold
    Window.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    Window.TitleLabel.TextTransparency = Window.Transparency
    Window.TitleLabel.Parent = Window.TitleBar
    
    -- Subtitle (optional)
    if Window.Subtitle then
        Window.SubtitleLabel = Instance.new("TextLabel")
        Window.SubtitleLabel.Size = UDim2.new(1, -200, 0, 12)
        Window.SubtitleLabel.Position = UDim2.new(0, Window.Icon and 45 or 15, 0, 26)
        Window.SubtitleLabel.BackgroundTransparency = 1
        Window.SubtitleLabel.Text = Window.Subtitle
        Window.SubtitleLabel.TextColor3 = Window.ThemeManager.CurrentTheme.SecondaryTextColor
        Window.SubtitleLabel.TextSize = 11
        Window.SubtitleLabel.Font = Enum.Font.Gotham
        Window.SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        Window.SubtitleLabel.TextTransparency = Window.Transparency
        Window.SubtitleLabel.Parent = Window.TitleBar
    end
    
    -- Control Buttons Container
    local ControlsContainer = Instance.new("Frame")
    ControlsContainer.Size = UDim2.new(0, 150, 1, 0)
    ControlsContainer.Position = UDim2.new(1, -155, 0, 0)
    ControlsContainer.BackgroundTransparency = 1
    ControlsContainer.Parent = Window.TitleBar
    
    local ControlsLayout = Instance.new("UIListLayout")
    ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ControlsLayout.Padding = UDim.new(0, 5)
    ControlsLayout.Parent = ControlsContainer
    
    -- Helper function to create control buttons
    local function CreateControlButton(icon, color, hoverColor, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 35, 0, 35)
        Button.BackgroundColor3 = Window.ThemeManager.CurrentTheme.TertiaryBackground
        Button.BackgroundTransparency = Window.Transparency
        Button.BorderSizePixel = 0
        Button.Text = ""
        Button.AutoButtonColor = false
        Button.Parent = ControlsContainer
        
        Utility.CreateCorner(6).Parent = Button
        
        local Icon = Window.IconManager:CreateIcon(icon, UDim2.new(0, 18, 0, 18), Button)
        Icon.Position = UDim2.new(0.5, -9, 0.5, -9)
        Icon.ImageColor3 = Window.ThemeManager.CurrentTheme.TextColor
        Icon.ImageTransparency = Window.Transparency
        
        -- Hover effects
        Button.MouseEnter:Connect(function()
            Window.SoundManager:Play("Hover")
            Utility.Tween(Button, {BackgroundColor3 = hoverColor}, 0.15)
            Utility.Tween(Icon, {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0.5, -10, 0.5, -10)
            }, 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end)
        
        Button.MouseLeave:Connect(function()
            Utility.Tween(Button, {BackgroundColor3 = Window.ThemeManager.CurrentTheme.TertiaryBackground}, 0.15)
            Utility.Tween(Icon, {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0.5, -9, 0.5, -9)
            }, 0.15)
        end)
        
        Button.MouseButton1Click:Connect(function()
            Window.SoundManager:Play("Click")
            
            -- Click animation
            Utility.Tween(Button, {BackgroundColor3 = color}, 0.1)
            Utility.Tween(Icon, {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0.5, -8, 0.5, -8)
            }, 0.05)
            
            wait(0.1)
            
            Utility.Tween(Button, {BackgroundColor3 = Window.ThemeManager.CurrentTheme.TertiaryBackground}, 0.1)
            Utility.Tween(Icon, {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0.5, -9, 0.5, -9)
            }, 0.1)
            
            callback()
        end)
        
        return Button
    end
    
    -- Transparency Control Button
    Window.TransparencyButton = CreateControlButton(
        "Settings",
        Window.ThemeManager.CurrentTheme.AccentColor,
        Color3.fromRGB(100, 120, 255),
        function()
            -- Toggle transparency settings panel
            if Window.TransparencyPanel then
                Window.TransparencyPanel.Visible = not Window.TransparencyPanel.Visible
            else
                TitleBarSystem.CreateTransparencyPanel(Window)
            end
        end
    )
    
    -- Minimize Button
    Window.MinimizeButton = CreateControlButton(
        "Minimize",
        Color3.fromRGB(255, 200, 0),
        Color3.fromRGB(255, 220, 50),
        function()
            Window.Minimized = not Window.Minimized
            
            if Window.Minimized then
                Utility.Tween(Window.MainFrame, {
                    Size = UDim2.new(0, Window.Size.X.Offset, 0, 45)
                }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            else
                Utility.Tween(Window.MainFrame, {
                    Size = Window.Maximized and UDim2.new(1, 0, 1, 0) or Window.OriginalSize
                }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end
        end
    )
    
    -- Maximize Button
    Window.MaximizeButton = CreateControlButton(
        "Maximize",
        Color3.fromRGB(0, 200, 100),
        Color3.fromRGB(50, 220, 150),
        function()
            Window.Maximized = not Window.Maximized
            
            if Window.Maximized then
                -- Store current size before maximizing
                Window.OriginalSize = Window.MainFrame.Size
                Window.OriginalPosition = Window.MainFrame.Position
                
                -- Maximize to full screen
                Utility.Tween(Window.MainFrame, {
                    Size = UDim2.new(1, -20, 1, -20),
                    Position = UDim2.new(0, 10, 0, 10)
                }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                
                Window.SoundManager:Play("Expand")
            else
                -- Restore original size
                Utility.Tween(Window.MainFrame, {
                    Size = Window.OriginalSize,
                    Position = Window.OriginalPosition
                }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                
                Window.SoundManager:Play("Collapse")
            end
        end
    )
    
    -- Close Button
    Window.CloseButton = CreateControlButton(
        "X",
        Color3.fromRGB(220, 50, 50),
        Color3.fromRGB(255, 80, 80),
        function()
            -- Close animation
            Utility.Tween(Window.MainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            
            Utility.Tween(Window.Shadow, {ImageTransparency = 1}, 0.3)
            Utility.Tween(Window.Glow, {ImageTransparency = 1}, 0.3)
            
            wait(0.3)
            Window.ScreenGui:Destroy()
        end
    )
    
    -- Make draggable
    local dragging = false
    local dragInput, mousePos, framePos
    
    Window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not Window.Maximized then
            dragging = true
            mousePos = input.Position
            framePos = Window.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Window.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Utility.Tween(Window.MainFrame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.05)
        end
    end)
end

function TitleBarSystem.CreateTransparencyPanel(Window)
    Window.TransparencyPanel = Instance.new("Frame")
    Window.TransparencyPanel.Name = "TransparencyPanel"
    Window.TransparencyPanel.Size = UDim2.new(0, 250, 0, 120)
    Window.TransparencyPanel.Position = UDim2.new(1, -260, 0, 50)
    Window.TransparencyPanel.BackgroundColor3 = Window.ThemeManager.CurrentTheme.SecondaryBackground
    Window.TransparencyPanel.BorderSizePixel = 0
    Window.TransparencyPanel.ZIndex = 100
    Window.TransparencyPanel.Parent = Window.MainFrame
    
    Utility.CreateCorner(8).Parent = Window.TransparencyPanel
    Utility.CreateStroke(Window.ThemeManager.CurrentTheme.AccentColor, 1, 0.5).Parent = Window.TransparencyPanel
    
    -- Shadow for panel
    local PanelShadow = Instance.new("ImageLabel")
    PanelShadow.Size = UDim2.new(1, 20, 1, 20)
    PanelShadow.Position = UDim2.new(0, -10, 0, -10)
    PanelShadow.BackgroundTransparency = 1
    PanelShadow.Image = "rbxassetid://5554236805"
    PanelShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    PanelShadow.ImageTransparency = 0.5
    PanelShadow.ScaleType = Enum.ScaleType.Slice
    PanelShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    PanelShadow.ZIndex = 99
    PanelShadow.Parent = Window.TransparencyPanel
    
    -- Title
    local PanelTitle = Instance.new("TextLabel")
    PanelTitle.Size = UDim2.new(1, -20, 0, 25)
    PanelTitle.Position = UDim2.new(0, 10, 0, 10)
    PanelTitle.BackgroundTransparency = 1
    PanelTitle.Text = "Transparency Settings"
    PanelTitle.TextColor3 = Window.ThemeManager.CurrentTheme.TextColor
    PanelTitle.TextSize = 14
    PanelTitle.Font = Enum.Font.GothamBold
    PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
    PanelTitle.Parent = Window.TransparencyPanel
    
    -- Transparency Slider
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 40)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = "Window Transparency"
    SliderLabel.TextColor3 = Window.ThemeManager.CurrentTheme.SecondaryTextColor
    SliderLabel.TextSize = 12
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = Window.TransparencyPanel
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0, 40, 0, 20)
    SliderValue.Position = UDim2.new(1, -50, 0, 40)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(math.floor(Window.Transparency * 100)) .. "%"
    SliderValue.TextColor3 = Window.ThemeManager.CurrentTheme.AccentColor
    SliderValue.TextSize = 12
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = Window.TransparencyPanel
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 70)
    SliderBar.BackgroundColor3 = Window.ThemeManager.CurrentTheme.TertiaryBackground
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Window.TransparencyPanel
    
    Utility.CreateCorner(3).Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(Window.Transparency, 0, 1, 0)
    SliderFill.BackgroundColor3 = Window.ThemeManager.CurrentTheme.AccentColor
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    Utility.CreateCorner(3).Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 20)
    SliderButton.Position = UDim2.new(0, 0, 0, -10)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local dragging = false
    
    local function updateTransparency(input)
        local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        Window.Transparency = Utility.Round(relativeX, 2)
        
        SliderValue.Text = tostring(math.floor(Window.Transparency * 100)) .. "%"
        Utility.Tween(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
        
        -- Apply transparency to all window elements
        Window.MainFrame.BackgroundTransparency = Window.Transparency
        Window.TitleBar.BackgroundTransparency = Window.Transparency
        Window.TitleLabel.TextTransparency = Window.Transparency
        
        if Window.SubtitleLabel then
            Window.SubtitleLabel.TextTransparency = Window.Transparency
        end
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateTransparency(input)
        end
    end)
    
    SliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateTransparency(input)
        end
    end)
    
    -- Reset Button
    local ResetButton = Instance.new("TextButton")
    ResetButton.Size = UDim2.new(1, -20, 0, 25)
    ResetButton.Position = UDim2.new(0, 10, 1, -35)
    ResetButton.BackgroundColor3 = Window.ThemeManager.CurrentTheme.TertiaryBackground
    ResetButton.Text = "Reset to Default"
    ResetButton.TextColor3 = Window.ThemeManager.CurrentTheme.TextColor
    ResetButton.TextSize = 12
    ResetButton.Font = Enum.Font.Gotham
    ResetButton.AutoButtonColor = false
    ResetButton.Parent = Window.TransparencyPanel
    
    Utility.CreateCorner(6).Parent = ResetButton
    
    ResetButton.MouseButton1Click:Connect(function()
        Window.Transparency = 0
        SliderValue.Text = "0%"
        Utility.Tween(SliderFill, {Size = UDim2.new(0, 0, 1, 0)}, 0.2)
        
        Window.MainFrame.BackgroundTransparency = 0
        Window.TitleBar.BackgroundTransparency = 0
        Window.TitleLabel.TextTransparency = 0
        
        if Window.SubtitleLabel then
            Window.SubtitleLabel.TextTransparency = 0
        end
    end)
    
    -- Slide in animation
    Window.TransparencyPanel.Position = UDim2.new(1, -260, 0, 30)
    Window.TransparencyPanel.Size = UDim2.new(0, 250, 0, 0)
    Utility.Tween(Window.TransparencyPanel, {
        Position = UDim2.new(1, -260, 0, 50),
        Size = UDim2.new(0, 250, 0, 120)
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

return TitleBarSystem
