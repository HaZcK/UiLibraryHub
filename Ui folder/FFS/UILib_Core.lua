--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║              ADVANCED ROBLOX UI LIBRARY - CORE                ║
    ║                   Modern & Customizable                        ║
    ║                      Version 2.0                              ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    Features:
    • Resizable Windows with Handles
    • Transparency Control
    • Maximize/Minimize/Close
    • Custom Icons & Folders
    • Gradient & Image Backgrounds
    • Sound Effects
    • Advanced Animations
    • Color Customization
    • Scrollable Content
]]

local UILibrary = {}
UILibrary.__index = UILibrary
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
    
    -- Default Colors
    AccentColor = Color3.fromRGB(88, 101, 242),
    BackgroundColor = Color3.fromRGB(20, 20, 30),
    SecondaryBackground = Color3.fromRGB(30, 30, 45),
    TertiaryBackground = Color3.fromRGB(40, 40, 60),
    TextColor = Color3.fromRGB(255, 255, 255),
    SecondaryTextColor = Color3.fromRGB(180, 180, 200),
    
    -- Animation Durations
    FastAnimation = 0.15,
    MediumAnimation = 0.25,
    SlowAnimation = 0.4,
    
    -- Easing
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out,
    
    -- Sounds
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

function Utility.CreateGradient(colorSequence, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence or ColorSequence.new(DEFAULTS.AccentColor)
    gradient.Rotation = rotation or 0
    return gradient
end

function Utility.Lerp(a, b, t)
    return a + (b - a) * t
end

function Utility.Round(number, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(number * mult + 0.5) / mult
end

function Utility.Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function Utility.RGBToHex(color)
    return string.format("#%02X%02X%02X", 
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

function Utility.HexToRGB(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    )
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

-- ═══════════════════════════════════════════════════════════════
-- THEME MANAGER
-- ═══════════════════════════════════════════════════════════════
local ThemeManager = {}
ThemeManager.__index = ThemeManager

function ThemeManager.new()
    local self = setmetatable({}, ThemeManager)
    
    self.CurrentTheme = {
        Name = "Default",
        AccentColor = DEFAULTS.AccentColor,
        BackgroundColor = DEFAULTS.BackgroundColor,
        SecondaryBackground = DEFAULTS.SecondaryBackground,
        TertiaryBackground = DEFAULTS.TertiaryBackground,
        TextColor = DEFAULTS.TextColor,
        SecondaryTextColor = DEFAULTS.SecondaryTextColor,
        
        -- Gradient
        UseGradient = false,
        GradientColors = nil,
        GradientRotation = 0,
        
        -- Background Image
        BackgroundImage = nil,
        BackgroundImageTransparency = 0.5,
        
        -- Custom Properties
        BorderRadius = 8,
        Transparency = 0,
    }
    
    self.Themes = {
        Default = self.CurrentTheme,
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
        Sunset = {
            Name = "Sunset",
            AccentColor = Color3.fromRGB(255, 100, 100),
            BackgroundColor = Color3.fromRGB(30, 20, 40),
            SecondaryBackground = Color3.fromRGB(45, 30, 55),
            TertiaryBackground = Color3.fromRGB(60, 40, 70),
            TextColor = Color3.fromRGB(255, 220, 200),
            SecondaryTextColor = Color3.fromRGB(200, 180, 170),
        },
        Forest = {
            Name = "Forest",
            AccentColor = Color3.fromRGB(80, 200, 120),
            BackgroundColor = Color3.fromRGB(20, 30, 20),
            SecondaryBackground = Color3.fromRGB(30, 45, 30),
            TertiaryBackground = Color3.fromRGB(40, 60, 40),
            TextColor = Color3.fromRGB(220, 255, 220),
            SecondaryTextColor = Color3.fromRGB(170, 200, 170),
        }
    }
    
    return self
end

function ThemeManager:SetTheme(themeName)
    if self.Themes[themeName] then
        for key, value in pairs(self.Themes[themeName]) do
            self.CurrentTheme[key] = value
        end
        return true
    end
    return false
end

function ThemeManager:CreateCustomTheme(name, colors)
    self.Themes[name] = colors
    return true
end

function ThemeManager:SetAccentColor(color)
    self.CurrentTheme.AccentColor = color
end

function ThemeManager:SetBackgroundColor(color)
    self.CurrentTheme.BackgroundColor = color
end

function ThemeManager:SetGradient(enabled, colors, rotation)
    self.CurrentTheme.UseGradient = enabled
    if colors then
        self.CurrentTheme.GradientColors = colors
    end
    if rotation then
        self.CurrentTheme.GradientRotation = rotation
    end
end

function ThemeManager:SetBackgroundImage(imageId, transparency)
    self.CurrentTheme.BackgroundImage = imageId
    self.CurrentTheme.BackgroundImageTransparency = transparency or 0.5
end

function ThemeManager:SetTransparency(transparency)
    self.CurrentTheme.Transparency = Utility.Clamp(transparency, 0, 1)
end

-- ═══════════════════════════════════════════════════════════════
-- SOUND MANAGER
-- ═══════════════════════════════════════════════════════════════
local SoundManager = {}
SoundManager.__index = SoundManager

function SoundManager.new()
    local self = setmetatable({}, SoundManager)
    
    self.Sounds = {
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
    
    self.Volume = DEFAULTS.SoundVolume
    self.Enabled = DEFAULTS.SoundEnabled
    
    return self
end

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
-- ICON MANAGER
-- ═══════════════════════════════════════════════════════════════
local IconManager = {}
IconManager.__index = IconManager

function IconManager.new()
    local self = setmetatable({}, IconManager)
    
    -- Lucide Icons (rbxassetid format)
    self.Icons = {
        -- Basic
        Home = "rbxassetid://10723434711",
        Settings = "rbxassetid://10734950309",
        User = "rbxassetid://10734896733",
        Search = "rbxassetid://10734898950",
        Plus = "rbxassetid://10734896206",
        Minus = "rbxassetid://10734883356",
        X = "rbxassetid://10734896206",
        Check = "rbxassetid://10734896206",
        ChevronDown = "rbxassetid://10709790948",
        ChevronUp = "rbxassetid://10709791437",
        ChevronLeft = "rbxassetid://10709791214",
        ChevronRight = "rbxassetid://10709791281",
        
        -- UI Controls
        Maximize = "rbxassetid://10747381389",
        Minimize = "rbxassetid://10747384394",
        Menu = "rbxassetid://10723407389",
        MoreVertical = "rbxassetid://10723407389",
        MoreHorizontal = "rbxassetid://10734883548",
        
        -- Actions
        Play = "rbxassetid://10734896206",
        Pause = "rbxassetid://10734896733",
        Stop = "rbxassetid://10734896206",
        Refresh = "rbxassetid://10747372992",
        Download = "rbxassetid://10734896206",
        Upload = "rbxassetid://10734896733",
        
        -- Status
        Info = "rbxassetid://10734921036",
        Warning = "rbxassetid://10734896206",
        Error = "rbxassetid://10734896733",
        Success = "rbxassetid://10734896206",
        
        -- Folders
        Folder = "rbxassetid://10723404337",
        FolderOpen = "rbxassetid://10723404472",
        File = "rbxassetid://10723394478",
    }
    
    return self
end

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

-- Export managers
UILibrary.Utility = Utility
UILibrary.ThemeManager = ThemeManager
UILibrary.SoundManager = SoundManager
UILibrary.IconManager = IconManager

return UILibrary
