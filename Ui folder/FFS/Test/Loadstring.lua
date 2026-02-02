--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║     ADVANCED UI LIBRARY - COMPREHENSIVE USAGE EXAMPLE         ║
    ║                                                               ║
    ║  This example demonstrates ALL features:                      ║
    ║  ✓ Resizable Windows                                          ║
    ║  ✓ Transparency Control                                       ║
    ║  ✓ Maximize/Minimize                                          ║
    ║  ✓ Custom Icons & Folders                                     ║
    ║  ✓ Gradient Backgrounds                                       ║
    ║  ✓ Image Backgrounds                                          ║
    ║  ✓ Sound Effects                                              ║
    ║  ✓ Color Customization                                        ║
    ║  ✓ Themes                                                     ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

-- Load the library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/HaZcK/UiLibraryHub/refs/heads/main/Ui%20folder/FFS/UILibrary_Main.lua"))()

-- ═══════════════════════════════════════════════════════════════
-- 1. CREATE WINDOW WITH ADVANCED OPTIONS
-- ═══════════════════════════════════════════════════════════════
local Window = UILibrary:CreateWindow({
    -- Basic Settings
    Name = "🚀 Advanced Script Hub",
    Subtitle = "v2.0.0 - Premium Edition",
    Icon = "Home",
    
    -- Window Size
    Size = UDim2.new(0, 650, 0, 500),
    MinSize = Vector2.new(500, 400),
    MaxSize = Vector2.new(1200, 800),
    
    -- Appearance
    Transparency = 0, -- 0 = opaque, 1 = fully transparent
    Resizable = true, -- Enable resize handles
    
    -- Background Options
    UseGradient = true,
    GradientColors = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 20, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 30, 40))
    }),
    GradientRotation = 45,
    
    -- Uncomment to use background image instead
    -- BackgroundImage = "123456789", -- Asset ID
    -- BackgroundImageTransparency = 0.7,
})

-- ═══════════════════════════════════════════════════════════════
-- 2. CUSTOMIZE WINDOW APPEARANCE
-- ═══════════════════════════════════════════════════════════════

-- Set custom accent color
Window:SetAccentColor(Color3.fromRGB(138, 43, 226)) -- Purple

-- Set custom background (alternative to gradient)
-- Window:SetBackgroundImage("1234567890", 0.6)

-- Adjust transparency dynamically
-- Window:SetTransparency(0.2)

-- Apply preset theme
-- Window:SetTheme("Ocean") -- Options: Default, Dark, Light, Ocean, Sunset, Forest

-- Configure sounds
Window:SetSoundsEnabled(true)
Window:SetSoundVolume(0.3)

-- Add custom icons
Window:AddIcon("Rocket", "rbxassetid://123456")
Window:AddIcon("Star", "rbxassetid://789012")

-- ═══════════════════════════════════════════════════════════════
-- 3. CREATE TABS WITH ICONS
-- ═══════════════════════════════════════════════════════════════

local HomeTab = Window:CreateTab("Home", "Home")
local CombatTab = Window:CreateTab("Combat", "Target")
local MovementTab = Window:CreateTab("Movement", "Zap")
local VisualTab = Window:CreateTab("Visual", "Eye")
local MiscTab = Window:CreateTab("Misc", "Settings")

-- ═══════════════════════════════════════════════════════════════
-- 4. HOME TAB - Welcome & Features Overview
-- ═══════════════════════════════════════════════════════════════

HomeTab:AddSection("👋 Welcome")

HomeTab:AddLabel("Welcome to Advanced Script Hub!")
HomeTab:AddLabel("This UI features resizable windows, transparency,")
HomeTab:AddLabel("custom colors, gradients, and much more!")

HomeTab:AddSection("🎨 Appearance Settings")

-- Color Picker for Accent Color
HomeTab:AddColorPicker({
    Name = "Accent Color",
    Default = Color3.fromRGB(138, 43, 226),
    Callback = function(color)
        Window:SetAccentColor(color)
        Window:Notify({
            Title = "Color Changed",
            Content = "Accent color updated!",
            Duration = 2
        })
    end
})

-- Theme Selector
HomeTab:AddDropdown({
    Name = "Select Theme",
    Options = {"Default", "Dark", "Light", "Ocean", "Sunset", "Forest"},
    Default = "Default",
    Callback = function(theme)
        Window:SetTheme(theme)
        Window:Notify({
            Title = "Theme Changed",
            Content = "Applied " .. theme .. " theme",
            Duration = 2
        })
    end
})

-- Transparency Slider
HomeTab:AddSlider({
    Name = "Window Transparency",
    Min = 0,
    Max = 100,
    Default = 0,
    Increment = 5,
    Callback = function(value)
        Window:SetTransparency(value / 100)
    end
})

-- Background Image Input
HomeTab:AddTextbox({
    Name = "Background Image (Asset ID)",
    Placeholder = "Enter image asset ID...",
    Callback = function(text)
        local assetId = tonumber(text)
        if assetId then
            Window:SetBackgroundImage(assetId, 0.6)
            Window:Notify({
                Title = "Background Set",
                Content = "Background image applied!",
                Duration = 2
            })
        end
    end
})

-- Remove Background Button
HomeTab:AddButton({
    Name = "Remove Background Image",
    Callback = function()
        Window:SetBackgroundImage(nil)
        Window:Notify({
            Title = "Background Removed",
            Content = "Background image removed",
            Duration = 2
        })
    end
})

HomeTab:AddSection("🔊 Sound Settings")

HomeTab:AddToggle({
    Name = "Enable Sounds",
    Default = true,
    Callback = function(enabled)
        Window:SetSoundsEnabled(enabled)
    end
})

HomeTab:AddSlider({
    Name = "Sound Volume",
    Min = 0,
    Max = 100,
    Default = 30,
    Increment = 5,
    Callback = function(value)
        Window:SetSoundVolume(value / 100)
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 5. COMBAT TAB - With Folders
-- ═══════════════════════════════════════════════════════════════

-- Create Folder for Auto Farm
local AutoFarmFolder = CombatTab:CreateFolder({
    Name = "Auto Farm",
    Icon = "Zap",
    DefaultExpanded = true
})

AutoFarmFolder:AddToggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(enabled)
        _G.AutoFarm = enabled
        print("Auto Farm:", enabled)
    end
})

AutoFarmFolder:AddSlider({
    Name = "Farm Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Increment = 0.5,
    Callback = function(value)
        _G.FarmSpeed = value
    end
})

AutoFarmFolder:AddDropdown({
    Name = "Farm Type",
    Options = {"Nearest", "Strongest", "Weakest", "Random"},
    Default = "Nearest",
    Callback = function(option)
        _G.FarmType = option
    end
})

-- Create Folder for Combat
local CombatFolder = CombatTab:CreateFolder({
    Name = "Combat Settings",
    Icon = "Sword",
    DefaultExpanded = false
})

CombatFolder:AddToggle({
    Name = "Auto Attack",
    Default = false,
    Callback = function(enabled)
        _G.AutoAttack = enabled
    end
})

CombatFolder:AddToggle({
    Name = "Auto Block",
    Default = false,
    Callback = function(enabled)
        _G.AutoBlock = enabled
    end
})

CombatFolder:AddSlider({
    Name = "Attack Range",
    Min = 10,
    Max = 100,
    Default = 50,
    Increment = 5,
    Callback = function(value)
        _G.AttackRange = value
    end
})

-- Create Folder for Target Selection
local TargetFolder = CombatTab:CreateFolder({
    Name = "Target Settings",
    Icon = "Target",
    DefaultExpanded = false
})

TargetFolder:AddDropdown({
    Name = "Target Priority",
    Options = {"Nearest", "Lowest HP", "Highest Level", "Team"},
    Default = "Nearest",
    Callback = function(option)
        _G.TargetPriority = option
    end
})

TargetFolder:AddToggle({
    Name = "Lock Target",
    Default = false,
    Callback = function(enabled)
        _G.LockTarget = enabled
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 6. MOVEMENT TAB - Player Modifications
-- ═══════════════════════════════════════════════════════════════

MovementTab:AddSection("🏃 Movement")

MovementTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

MovementTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 10,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

MovementTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(enabled)
        _G.InfJump = enabled
    end
})

MovementTab:AddSection("✈️ Flight")

local FlyEnabled = false
MovementTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(enabled)
        FlyEnabled = enabled
        -- Fly code here
    end
})

MovementTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Increment = 5,
    Callback = function(value)
        _G.FlySpeed = value
    end
})

MovementTab:AddKeybind({
    Name = "Toggle Fly",
    Default = Enum.KeyCode.F,
    Callback = function()
        FlyEnabled = not FlyEnabled
        print("Fly toggled:", FlyEnabled)
    end
})

MovementTab:AddSection("🚫 Exploits")

MovementTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(enabled)
        _G.NoClip = enabled
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 7. VISUAL TAB - ESP & Rendering
-- ═══════════════════════════════════════════════════════════════

VisualTab:AddSection("👁️ ESP Settings")

VisualTab:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(enabled)
        _G.PlayerESP = enabled
    end
})

VisualTab:AddToggle({
    Name = "Name ESP",
    Default = false,
    Callback = function(enabled)
        _G.NameESP = enabled
    end
})

VisualTab:AddToggle({
    Name = "Health ESP",
    Default = false,
    Callback = function(enabled)
        _G.HealthESP = enabled
    end
})

VisualTab:AddToggle({
    Name = "Distance ESP",
    Default = false,
    Callback = function(enabled)
        _G.DistanceESP = enabled
    end
})

VisualTab:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        _G.ESPColor = color
    end
})

VisualTab:AddSection("🎨 Rendering")

VisualTab:AddToggle({
    Name = "Fullbright",
    Default = false,
    Callback = function(enabled)
        -- Fullbright code
    end
})

VisualTab:AddSlider({
    Name = "FOV",
    Min = 70,
    Max = 120,
    Default = 70,
    Increment = 1,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 8. MISC TAB - Utilities
-- ═══════════════════════════════════════════════════════════════

MiscTab:AddSection("⚙️ Utilities")

MiscTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            game.Players.LocalPlayer
        )
    end
})

MiscTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        -- Server hop code
        Window:Notify({
            Title = "Server Hop",
            Content = "Searching for new server...",
            Duration = 3
        })
    end
})

MiscTab:AddTextbox({
    Name = "Custom Message",
    Placeholder = "Type message...",
    Callback = function(text)
        Window:Notify({
            Title = "Message",
            Content = text,
            Duration = 3
        })
    end
})

MiscTab:AddSection("🎹 Keybinds")

MiscTab:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        Window:Toggle()
    end
})

MiscTab:AddSection("💾 Configuration")

MiscTab:AddButton({
    Name = "Save Configuration",
    Callback = function()
        -- Save config code
        Window:Notify({
            Title = "Success",
            Content = "Configuration saved!",
            Duration = 2,
            Type = "Success"
        })
    end
})

MiscTab:AddButton({
    Name = "Load Configuration",
    Callback = function()
        -- Load config code
        Window:Notify({
            Title = "Success",
            Content = "Configuration loaded!",
            Duration = 2,
            Type = "Success"
        })
    end
})

MiscTab:AddSection("ℹ️ Information")

MiscTab:AddLabel("Script Version: 2.0.0")
MiscTab:AddLabel("Created by: YourName")
MiscTab:AddLabel("Discord: discord.gg/yourserver")

MiscTab:AddButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/yourserver")
        Window:Notify({
            Title = "Copied!",
            Content = "Discord link copied to clipboard",
            Duration = 2
        })
    end
})

MiscTab:AddButton({
    Name = "Destroy GUI",
    Callback = function()
        Window:Notify({
            Title = "Goodbye!",
            Content = "GUI will be destroyed in 2 seconds...",
            Duration = 2
        })
        wait(2)
        Window:Destroy()
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 9. WELCOME NOTIFICATION
-- ═══════════════════════════════════════════════════════════════
Window:Notify({
    Title = "🚀 Welcome!",
    Content = "Advanced Script Hub loaded successfully!\nDrag to move • Corners to resize • Settings for transparency",
    Duration = 5,
    Type = "Success"
})

-- Show tips after 3 seconds
wait(3)
Window:Notify({
    Title = "💡 Pro Tip",
    Content = "Click the settings button (⚙️) in title bar to adjust window transparency!",
    Duration = 4,
    Type = "Info"
})

print("✅ Advanced UI Library loaded successfully!")
print("📝 Version:", UILibrary.Version)
print("🎮 Ready to use!")
