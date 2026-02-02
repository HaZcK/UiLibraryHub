--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║           ADVANCED ROBLOX UI LIBRARY - MAIN MODULE            ║
    ║                     Version 2.0.0                             ║
    ║                                                               ║
    ║  Features:                                                    ║
    ║  • Resizable Windows with Handles                             ║
    ║  • Transparency Control                                       ║
    ║  • Maximize/Minimize/Close                                    ║
    ║  • Custom Icons & Folders                                     ║
    ║  • Gradient & Image Backgrounds                               ║
    ║  • Sound Effects                                              ║
    ║  • Advanced Animations                                        ║
    ║  • Full Color Customization                                   ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

-- Load all modules
local UILib_Core = loadstring(game:HttpGet("YOUR_CORE_URL"))()
local UILib_WindowSystem = loadstring(game:HttpGet("YOUR_WINDOW_URL"))()
local UILib_TitleBar = loadstring(game:HttpGet("YOUR_TITLEBAR_URL"))()
local UILib_TabSystem = loadstring(game:HttpGet("YOUR_TABSYSTEM_URL"))()
local UILib_Components = loadstring(game:HttpGet("YOUR_COMPONENTS_URL"))()

local UILibrary = {}
UILibrary.Version = "2.0.0"

-- ═══════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ═══════════════════════════════════════════════════════════════
function UILibrary:CreateWindow(config)
    config = config or {}
    
    -- Create window using WindowSystem
    local Window = UILib_WindowSystem.CreateWindow(config)
    
    -- Setup title bar
    UILib_TitleBar.CreateTitleBar(Window)
    
    -- Setup tab system
    UILib_TabSystem.Setup(Window)
    
    -- Make window resizable if enabled
    if config.Resizable ~= false then
        local handles, connections = UILib_WindowSystem.MakeResizable(
            Window.MainFrame,
            Window.MinSize,
            Window.MaxSize
        )
        Window.ResizeHandles = handles
        Window.ResizeConnections = connections
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- WINDOW METHODS
    -- ═══════════════════════════════════════════════════════════
    
    -- Create Tab
    function Window:CreateTab(name, icon)
        return UILib_TabSystem.CreateTab(Window, {
            Name = name,
            Icon = icon
        })
    end
    
    -- Set Theme
    function Window:SetTheme(themeName)
        return Window.ThemeManager:SetTheme(themeName)
    end
    
    -- Set Accent Color
    function Window:SetAccentColor(color)
        Window.ThemeManager:SetAccentColor(color)
        -- Update all UI elements with new accent color
        -- (This would need to be implemented to update existing elements)
    end
    
    -- Set Background Color
    function Window:SetBackgroundColor(color)
        Window.ThemeManager:SetBackgroundColor(color)
        Window.MainFrame.BackgroundColor3 = color
    end
    
    -- Set Background Gradient
    function Window:SetGradient(enabled, colors, rotation)
        Window.ThemeManager:SetGradient(enabled, colors, rotation)
        
        if enabled then
            if not Window.Gradient then
                Window.Gradient = UILib_Core.Utility.CreateGradient(colors, rotation)
                Window.Gradient.Parent = Window.MainFrame
            else
                Window.Gradient.Color = colors
                Window.Gradient.Rotation = rotation or 0
            end
        elseif Window.Gradient then
            Window.Gradient:Destroy()
            Window.Gradient = nil
        end
    end
    
    -- Set Background Image
    function Window:SetBackgroundImage(imageId, transparency)
        Window.ThemeManager:SetBackgroundImage(imageId, transparency)
        
        if imageId then
            if not Window.BackgroundImage then
                Window.BackgroundImage = Instance.new("ImageLabel")
                Window.BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
                Window.BackgroundImage.BackgroundTransparency = 1
                Window.BackgroundImage.ZIndex = 0
                Window.BackgroundImage.Parent = Window.MainFrame
                UILib_Core.Utility.CreateCorner(Window.ThemeManager.CurrentTheme.BorderRadius).Parent = Window.BackgroundImage
            end
            
            Window.BackgroundImage.Image = "rbxassetid://" .. tostring(imageId)
            Window.BackgroundImage.ImageTransparency = transparency or 0.5
        elseif Window.BackgroundImage then
            Window.BackgroundImage:Destroy()
            Window.BackgroundImage = nil
        end
    end
    
    -- Set Transparency
    function Window:SetTransparency(transparency)
        Window.ThemeManager:SetTransparency(transparency)
        Window.Transparency = UILib_Core.Utility.Clamp(transparency, 0, 1)
        
        -- Apply to window elements
        Window.MainFrame.BackgroundTransparency = Window.Transparency
        Window.TitleBar.BackgroundTransparency = Window.Transparency
        Window.TabContainer.BackgroundTransparency = Window.Transparency
        Window.TitleLabel.TextTransparency = Window.Transparency
        
        if Window.SubtitleLabel then
            Window.SubtitleLabel.TextTransparency = Window.Transparency
        end
    end
    
    -- Enable/Disable Sounds
    function Window:SetSoundsEnabled(enabled)
        Window.SoundManager:SetEnabled(enabled)
    end
    
    -- Set Sound Volume
    function Window:SetSoundVolume(volume)
        Window.SoundManager:SetVolume(volume)
    end
    
    -- Add Custom Icon
    function Window:AddIcon(name, iconId)
        Window.IconManager:Add(name, iconId)
    end
    
    -- Create Notification
    function Window:Notify(config)
        return UILib_Components.CreateNotification(Window, config)
    end
    
    -- Destroy Window
    function Window:Destroy()
        -- Disconnect all connections
        for _, connection in pairs(Window.Connections) do
            connection:Disconnect()
        end
        
        if Window.ResizeConnections then
            for _, connection in pairs(Window.ResizeConnections) do
                connection:Disconnect()
            end
        end
        
        -- Destroy GUI
        Window.ScreenGui:Destroy()
    end
    
    -- Toggle Window Visibility
    function Window:Toggle()
        Window.MainFrame.Visible = not Window.MainFrame.Visible
    end
    
    -- Show Window
    function Window:Show()
        Window.MainFrame.Visible = true
    end
    
    -- Hide Window
    function Window:Hide()
        Window.MainFrame.Visible = false
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- ENTRANCE ANIMATION
    -- ═══════════════════════════════════════════════════════════
    
    -- Start hidden and small
    Window.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Window.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Window.Shadow.ImageTransparency = 1
    Window.Glow.ImageTransparency = 1
    
    -- Animate entrance
    wait(0.1)
    
    UILib_Core.Utility.Tween(
        Window.MainFrame,
        {
            Size = Window.Size,
            Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
        },
        0.5,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    
    UILib_Core.Utility.Tween(Window.Shadow, {ImageTransparency = 0.3}, 0.5)
    UILib_Core.Utility.Tween(Window.Glow, {ImageTransparency = 0.8}, 0.5)
    
    Window.SoundManager:Play("Success")
    
    return Window
end

-- ═══════════════════════════════════════════════════════════════
-- EXPORT
-- ═══════════════════════════════════════════════════════════════
return UILibrary
