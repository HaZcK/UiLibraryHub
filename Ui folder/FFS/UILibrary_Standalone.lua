--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║        ADVANCED ROBLOX UI LIBRARY - ALL-IN-ONE VERSION        ║
    ║                     Version 2.0.0                             ║
    ║                                                               ║
    ║  Complete library in single file for easy executor usage     ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local UILibrary = {}
UILibrary.Version = "2.0.0"

-- ═══════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════
-- CONSTANTS & DEFAULTS
-- ═══════════════════════════════════════════════════════════════
local DEFAULTS = {
    MinWindowSize = Vector2.new(400, 300),
    MaxWindowSize = Vector2.new(1920, 1080),
    DefaultWindowSize = UDim2.new(0, 600, 0, 450),
    
    AccentColor = Color3.fromRGB(88, 101, 242),
    BackgroundColor = Color3.fromRGB(20, 20, 30),
    SecondaryBackground = Color3.fromRGB(30, 30, 45),
    TertiaryBackground = Color3.fromRGB(40, 40, 60),
    TextColor = Color3.fromRGB(255, 255, 255),
    SecondaryTextColor = Color3.fromRGB(180, 180, 200),
    
    FastAnimation = 0.15,
    MediumAnimation = 0.25,
    SlowAnimation = 0.4,
    
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out,
    
    SoundEnabled = true,
    SoundVolume = 0.5,
}

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════
local Utility = {}

function Utility.Tween(instance, properties, duration, easingStyle, easingDirection, callback)
    duration = duration or DEFAULTS.MediumAnimation
    easingStyle = easingStyle or DEFAULTS.EasingStyle
    easingDirection = easingDirection or DEFAULTS.EasingDirection
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    tween:Play()
    return tween
end

function Utility.CreateSound(soundId, volume, parent)
    if not DEFAULTS.SoundEnabled then return nil end
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = volume or DEFAULTS.SoundVolume
    sound.Parent = parent or game:GetService("SoundService")
    return sound
end

function Utility.PlaySound(sound)
    if sound and DEFAULTS.SoundEnabled then
        sound:Play()
        game:GetService("Debris"):AddItem(sound, sound.TimeLength + 0.1)
    end
end

function Utility.Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function Utility.Round(number, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(number * mult + 0.5) / mult
end

function Utility.CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

function Utility.CreatePadding(top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    return padding
end

function Utility.CreateStroke(color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

function Utility.CreateGradient(colorSequence, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence or ColorSequence.new(DEFAULTS.AccentColor)
    gradient.Rotation = rotation or 0
    return gradient
end

-- ═══════════════════════════════════════════════════════════════
-- ICON MANAGER
-- ═══════════════════════════════════════════════════════════════
local IconManager = {}

IconManager.Icons = {
    Home = "rbxassetid://10734896206",
    Settings = "rbxassetid://10734950309",
    User = "rbxassetid://10734896733",
    Search = "rbxassetid://10734898950",
    Plus = "rbxassetid://10734896206",
    Minus = "rbxassetid://10734883356",
    X = "rbxassetid://10747372500",
    Check = "rbxassetid://10734896206",
    ChevronDown = "rbxassetid://10709790948",
    ChevronUp = "rbxassetid://10709791437",
    ChevronLeft = "rbxassetid://10709791214",
    ChevronRight = "rbxassetid://10709791281",
    Maximize = "rbxassetid://10747381389",
    Minimize = "rbxassetid://10747384394",
    Menu = "rbxassetid://10723407389",
    Folder = "rbxassetid://10723404337",
    FolderOpen = "rbxassetid://10723404472",
    File = "rbxassetid://10723394478",
}

function IconManager:Get(iconName)
    return self.Icons[iconName] or self.Icons.File
end

function IconManager:Add(iconName, iconId)
    self.Icons[iconName] = iconId
end

function IconManager:CreateIcon(iconName, size, parent)
    local icon = Instance.new("ImageLabel")
    icon.Size = size or UDim2.new(0, 20, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Image = self:Get(iconName)
    icon.ImageColor3 = DEFAULTS.TextColor
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = parent
    return icon
end

-- ═══════════════════════════════════════════════════════════════
-- SOUND MANAGER
-- ═══════════════════════════════════════════════════════════════
local SoundManager = {}

SoundManager.Sounds = {
    Click = 6895079853,
    Hover = 6895079900,
    Toggle = 6895079853,
    Slide = 6895079853,
    Expand = 6895079853,
    Collapse = 6895079853,
    Notification = 6895079853,
    Success = 6895079853,
    Error = 6895079853,
    Warning = 6895079853,
}

SoundManager.Volume = DEFAULTS.SoundVolume
SoundManager.Enabled = DEFAULTS.SoundEnabled

function SoundManager:Play(soundName)
    if not self.Enabled then return end
    
    local soundId = self.Sounds[soundName]
    if soundId then
        local sound = Utility.CreateSound(soundId, self.Volume)
        Utility.PlaySound(sound)
    end
end

function SoundManager:SetVolume(volume)
    self.Volume = Utility.Clamp(volume, 0, 1)
end

function SoundManager:SetEnabled(enabled)
    self.Enabled = enabled
end

function SoundManager:SetSound(soundName, soundId)
    self.Sounds[soundName] = soundId
end

-- ═══════════════════════════════════════════════════════════════
-- THEME MANAGER
-- ═══════════════════════════════════════════════════════════════
local ThemeManager = {}

ThemeManager.CurrentTheme = {
    Name = "Default",
    AccentColor = DEFAULTS.AccentColor,
    BackgroundColor = DEFAULTS.BackgroundColor,
    SecondaryBackground = DEFAULTS.SecondaryBackground,
    TertiaryBackground = DEFAULTS.TertiaryBackground,
    TextColor = DEFAULTS.TextColor,
    SecondaryTextColor = DEFAULTS.SecondaryTextColor,
    UseGradient = false,
    GradientColors = nil,
    GradientRotation = 0,
    BackgroundImage = nil,
    BackgroundImageTransparency = 0.5,
    BorderRadius = 8,
    Transparency = 0,
}

ThemeManager.Themes = {
    Default = ThemeManager.CurrentTheme,
    Dark = {
        Name = "Dark",
        AccentColor = Color3.fromRGB(88, 101, 242),
        BackgroundColor = Color3.fromRGB(20, 20, 30),
        SecondaryBackground = Color3.fromRGB(30, 30, 45),
        TertiaryBackground = Color3.fromRGB(40, 40, 60),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(180, 180, 200),
    },
    Light = {
        Name = "Light",
        AccentColor = Color3.fromRGB(66, 133, 244),
        BackgroundColor = Color3.fromRGB(245, 245, 250),
        SecondaryBackground = Color3.fromRGB(235, 235, 245),
        TertiaryBackground = Color3.fromRGB(225, 225, 235),
        TextColor = Color3.fromRGB(30, 30, 40),
        SecondaryTextColor = Color3.fromRGB(100, 100, 120),
    },
    Ocean = {
        Name = "Ocean",
        AccentColor = Color3.fromRGB(0, 150, 200),
        BackgroundColor = Color3.fromRGB(10, 25, 40),
        SecondaryBackground = Color3.fromRGB(15, 35, 55),
        TertiaryBackground = Color3.fromRGB(20, 45, 70),
        TextColor = Color3.fromRGB(200, 230, 255),
        SecondaryTextColor = Color3.fromRGB(150, 190, 220),
    },
}

function ThemeManager:SetTheme(themeName)
    if self.Themes[themeName] then
        for key, value in pairs(self.Themes[themeName]) do
            self.CurrentTheme[key] = value
        end
        return true
    end
    return false
end

function ThemeManager:SetAccentColor(color)
    self.CurrentTheme.AccentColor = color
end

function ThemeManager:SetTransparency(transparency)
    self.CurrentTheme.Transparency = Utility.Clamp(transparency, 0, 1)
end

-- ═══════════════════════════════════════════════════════════════
-- DRAGGABLE FUNCTION
-- ═══════════════════════════════════════════════════════════════
local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    handle.InputBegan:Connect(function(input)
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
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Utility.Tween(frame, {
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

-- ═══════════════════════════════════════════════════════════════
-- RESIZE HANDLE SYSTEM
-- ═══════════════════════════════════════════════════════════════
local function CreateResizeHandle(parent, position)
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 10, 0, 10)
    handle.Position = position
    handle.BackgroundTransparency = 1
    handle.ZIndex = 100
    handle.Parent = parent
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(1, -4, 1, -4)
    indicator.Position = UDim2.new(0, 2, 0, 2)
    indicator.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    indicator.BackgroundTransparency = 1
    indicator.BorderSizePixel = 0
    indicator.Parent = handle
    
    Utility.CreateCorner(2).Parent = indicator
    
    handle.MouseEnter:Connect(function()
        Utility.Tween(indicator, {BackgroundTransparency = 0.3}, 0.15)
    end)
    
    handle.MouseLeave:Connect(function()
        Utility.Tween(indicator, {BackgroundTransparency = 1}, 0.15)
    end)
    
    return handle
end

local function MakeResizable(frame, minSize, maxSize)
    minSize = minSize or Vector2.new(400, 300)
    maxSize = maxSize or Vector2.new(1920, 1080)
    
    -- Create corner handles
    local handles = {
        BottomRight = CreateResizeHandle(frame, UDim2.new(1, -5, 1, -5)),
        BottomLeft = CreateResizeHandle(frame, UDim2.new(0, -5, 1, -5)),
        TopRight = CreateResizeHandle(frame, UDim2.new(1, -5, 0, -5)),
        TopLeft = CreateResizeHandle(frame, UDim2.new(0, -5, 0, -5)),
    }
    
    for name, handle in pairs(handles) do
        local resizing = false
        local startMousePos
        local startSize
        local startPos
        
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                startMousePos = input.Position
                startSize = frame.Size
                startPos = frame.Position
            end
        end)
        
        handle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - startMousePos
                local newWidth = startSize.X.Offset
                local newHeight = startSize.Y.Offset
                local newX = startPos.X.Offset
                local newY = startPos.Y.Offset
                
                if name:find("Right") then
                    newWidth = startSize.X.Offset + delta.X
                elseif name:find("Left") then
                    newWidth = startSize.X.Offset - delta.X
                    newX = startPos.X.Offset + delta.X
                end
                
                if name:find("Bottom") then
                    newHeight = startSize.Y.Offset + delta.Y
                elseif name:find("Top") then
                    newHeight = startSize.Y.Offset - delta.Y
                    newY = startPos.Y.Offset + delta.Y
                end
                
                newWidth = Utility.Clamp(newWidth, minSize.X, maxSize.X)
                newHeight = Utility.Clamp(newHeight, minSize.Y, maxSize.Y)
                
                frame.Size = UDim2.new(0, newWidth, 0, newHeight)
                
                if name:find("Left") or name:find("Top") then
                    frame.Position = UDim2.new(0, newX, 0, newY)
                end
            end
        end)
    end
    
    return handles
end

-- ═══════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ═══════════════════════════════════════════════════════════════
function UILibrary:CreateWindow(config)
    config = config or {}
    
    local Window = {
        Name = config.Name or "UI Library",
        Subtitle = config.Subtitle,
        Icon = config.Icon,
        Size = config.Size or DEFAULTS.DefaultWindowSize,
        MinSize = config.MinSize or DEFAULTS.MinWindowSize,
        MaxSize = config.MaxSize or DEFAULTS.MaxWindowSize,
        Transparency = config.Transparency or 0,
        Maximized = false,
        Minimized = false,
        Tabs = {},
        Folders = {},
    }
    
    -- Create ScreenGui
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "UILibrary_" .. Window.Name
    Window.ScreenGui.ResetOnSpawn = false
    Window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Window.ScreenGui.IgnoreGuiInset = true
    
    if syn and syn.protect_gui then
        syn.protect_gui(Window.ScreenGui)
        Window.ScreenGui.Parent = CoreGui
    elseif gethui then
        Window.ScreenGui.Parent = gethui()
    else
        Window.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Name = "MainFrame"
    Window.MainFrame.Size = Window.Size
    Window.MainFrame.Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    Window.MainFrame.BackgroundColor3 = ThemeManager.CurrentTheme.BackgroundColor
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.BackgroundTransparency = Window.Transparency
    Window.MainFrame.ClipsDescendants = false
    Window.MainFrame.Parent = Window.ScreenGui
    
    Utility.CreateCorner(ThemeManager.CurrentTheme.BorderRadius).Parent = Window.MainFrame
    
    -- Background Image (if provided)
    if config.BackgroundImage then
        Window.BackgroundImage = Instance.new("ImageLabel")
        Window.BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
        Window.BackgroundImage.BackgroundTransparency = 1
        Window.BackgroundImage.Image = "rbxassetid://" .. tostring(config.BackgroundImage)
        Window.BackgroundImage.ImageTransparency = config.BackgroundImageTransparency or 0.5
        Window.BackgroundImage.ScaleType = Enum.ScaleType.Crop
        Window.BackgroundImage.ZIndex = 0
        Window.BackgroundImage.Parent = Window.MainFrame
        Utility.CreateCorner(ThemeManager.CurrentTheme.BorderRadius).Parent = Window.BackgroundImage
    end
    
    -- Gradient (if enabled)
    if config.UseGradient then
        Window.Gradient = Utility.CreateGradient(config.GradientColors, config.GradientRotation)
        Window.Gradient.Parent = Window.MainFrame
    end
    
    -- Shadow Effect
    Window.Shadow = Instance.new("ImageLabel")
    Window.Shadow.Name = "Shadow"
    Window.Shadow.Size = UDim2.new(1, 40, 1, 40)
    Window.Shadow.Position = UDim2.new(0, -20, 0, -20)
    Window.Shadow.BackgroundTransparency = 1
    Window.Shadow.Image = "rbxassetid://5554236805"
    Window.Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Window.Shadow.ImageTransparency = 0.3
    Window.Shadow.ScaleType = Enum.ScaleType.Slice
    Window.Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Window.Shadow.ZIndex = -1
    Window.Shadow.Parent = Window.MainFrame
    
    Window.OriginalSize = Window.Size
    Window.OriginalPosition = Window.MainFrame.Position
    
    -- Make resizable
    if config.Resizable ~= false then
        Window.ResizeHandles = MakeResizable(Window.MainFrame, Window.MinSize, Window.MaxSize)
    end
    
    -- TITLE BAR
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Name = "TitleBar"
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 45)
    Window.TitleBar.BackgroundColor3 = ThemeManager.CurrentTheme.SecondaryBackground
    Window.TitleBar.BorderSizePixel = 0
    Window.TitleBar.BackgroundTransparency = Window.Transparency
    Window.TitleBar.ZIndex = 10
    Window.TitleBar.Parent = Window.MainFrame
    
    Utility.CreateCorner(ThemeManager.CurrentTheme.BorderRadius).Parent = Window.TitleBar
    
    local TitleCover = Instance.new("Frame")
    TitleCover.Size = UDim2.new(1, 0, 0, 10)
    TitleCover.Position = UDim2.new(0, 0, 1, -10)
    TitleCover.BackgroundColor3 = ThemeManager.CurrentTheme.SecondaryBackground
    TitleCover.BorderSizePixel = 0
    TitleCover.BackgroundTransparency = Window.Transparency
    TitleCover.Parent = Window.TitleBar
    
    -- Title Text
    Window.TitleLabel = Instance.new("TextLabel")
    Window.TitleLabel.Size = UDim2.new(1, -200, 1, 0)
    Window.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    Window.TitleLabel.BackgroundTransparency = 1
    Window.TitleLabel.Text = Window.Name
    Window.TitleLabel.TextColor3 = ThemeManager.CurrentTheme.TextColor
    Window.TitleLabel.TextSize = 16
    Window.TitleLabel.Font = Enum.Font.GothamBold
    Window.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    Window.TitleLabel.Parent = Window.TitleBar
    
    -- Control Buttons
    local function CreateControlButton(text, color, position, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 35, 0, 35)
        button.Position = position
        button.BackgroundColor3 = ThemeManager.CurrentTheme.TertiaryBackground
        button.Text = text
        button.TextColor3 = ThemeManager.CurrentTheme.TextColor
        button.TextSize = 16
        button.Font = Enum.Font.GothamBold
        button.AutoButtonColor = false
        button.Parent = Window.TitleBar
        
        Utility.CreateCorner(6).Parent = button
        
        button.MouseEnter:Connect(function()
            Utility.Tween(button, {BackgroundColor3 = color}, 0.15)
        end)
        
        button.MouseLeave:Connect(function()
            Utility.Tween(button, {BackgroundColor3 = ThemeManager.CurrentTheme.TertiaryBackground}, 0.15)
        end)
        
        button.MouseButton1Click:Connect(callback)
        
        return button
    end
    
    -- Close Button
    Window.CloseButton = CreateControlButton("×", Color3.fromRGB(220, 50, 50), UDim2.new(1, -40, 0, 5), function()
        SoundManager:Play("Click")
        Utility.Tween(Window.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        Window.ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    Window.MinimizeButton = CreateControlButton("—", Color3.fromRGB(255, 200, 0), UDim2.new(1, -80, 0, 5), function()
        SoundManager:Play("Click")
        Window.Minimized = not Window.Minimized
        
        if Window.Minimized then
            Utility.Tween(Window.MainFrame, {Size = UDim2.new(0, Window.Size.X.Offset, 0, 45)}, 0.3)
        else
            Utility.Tween(Window.MainFrame, {Size = Window.Maximized and UDim2.new(1, -20, 1, -20) or Window.OriginalSize}, 0.3)
        end
    end)
    
    -- Maximize Button
    Window.MaximizeButton = CreateControlButton("□", Color3.fromRGB(0, 200, 100), UDim2.new(1, -120, 0, 5), function()
        SoundManager:Play("Click")
        Window.Maximized = not Window.Maximized
        
        if Window.Maximized then
            Window.OriginalSize = Window.MainFrame.Size
            Window.OriginalPosition = Window.MainFrame.Position
            Utility.Tween(Window.MainFrame, {Size = UDim2.new(1, -20, 1, -20), Position = UDim2.new(0, 10, 0, 10)}, 0.3)
        else
            Utility.Tween(Window.MainFrame, {Size = Window.OriginalSize, Position = Window.OriginalPosition}, 0.3)
        end
    end)
    
    -- Make draggable
    MakeDraggable(Window.MainFrame, Window.TitleBar)
    
    -- TAB CONTAINER
    Window.TabContainer = Instance.new("ScrollingFrame")
    Window.TabContainer.Size = UDim2.new(0, 160, 1, -55)
    Window.TabContainer.Position = UDim2.new(0, 10, 0, 50)
    Window.TabContainer.BackgroundColor3 = ThemeManager.CurrentTheme.SecondaryBackground
    Window.TabContainer.BorderSizePixel = 0
    Window.TabContainer.ScrollBarThickness = 4
    Window.TabContainer.ScrollBarImageColor3 = ThemeManager.CurrentTheme.AccentColor
    Window.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    Window.TabContainer.Parent = Window.MainFrame
    
    Utility.CreateCorner(8).Parent = Window.TabContainer
    Utility.CreatePadding(10, 10, 10, 10).Parent = Window.TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.Parent = Window.TabContainer
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Window.TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- CONTENT CONTAINER
    Window.ContentContainer = Instance.new("Frame")
    Window.ContentContainer.Size = UDim2.new(1, -190, 1, -55)
    Window.ContentContainer.Position = UDim2.new(0, 180, 0, 50)
    Window.ContentContainer.BackgroundTransparency = 1
    Window.ContentContainer.Parent = Window.MainFrame
    
    -- Entrance animation
    Window.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Window.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Window.Shadow.ImageTransparency = 1
    
    wait(0.1)
    
    Utility.Tween(
        Window.MainFrame,
        {Size = Window.Size, Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)},
        0.5,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    
    Utility.Tween(Window.Shadow, {ImageTransparency = 0.3}, 0.5)
    
    return Window
end

return UILibrary
