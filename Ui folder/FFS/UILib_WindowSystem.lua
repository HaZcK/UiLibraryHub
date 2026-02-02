--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║          ADVANCED ROBLOX UI LIBRARY - WINDOW SYSTEM           ║
    ║       Resizable, Transparent, Maximizable Windows             ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local UILib_Core = require(script.Parent.UILib_Core)
local Utility = UILib_Core.Utility
local ThemeManager = UILib_Core.ThemeManager
local SoundManager = UILib_Core.SoundManager
local IconManager = UILib_Core.IconManager

-- ═══════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local WindowSystem = {}
WindowSystem.__index = WindowSystem

-- ═══════════════════════════════════════════════════════════════
-- RESIZE HANDLE SYSTEM
-- ═══════════════════════════════════════════════════════════════
local ResizeHandle = {}
ResizeHandle.__index = ResizeHandle

function ResizeHandle.new(parent, position, cursor)
    local self = setmetatable({}, ResizeHandle)
    
    self.Handle = Instance.new("Frame")
    self.Handle.Size = UDim2.new(0, 10, 0, 10)
    self.Handle.Position = position
    self.Handle.BackgroundTransparency = 1
    self.Handle.ZIndex = 100
    self.Handle.Parent = parent
    
    -- Visual indicator (appears on hover)
    self.Indicator = Instance.new("Frame")
    self.Indicator.Size = UDim2.new(1, -4, 1, -4)
    self.Indicator.Position = UDim2.new(0, 2, 0, 2)
    self.Indicator.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    self.Indicator.BackgroundTransparency = 1
    self.Indicator.BorderSizePixel = 0
    self.Indicator.Parent = self.Handle
    
    Utility.CreateCorner(2).Parent = self.Indicator
    
    -- Cursor type
    self.CursorType = cursor or "rbxasset://SystemCursors/SizeNWSE"
    
    -- Hover effects
    self.Handle.MouseEnter:Connect(function()
        Utility.Tween(self.Indicator, {BackgroundTransparency = 0.3}, 0.15)
    end)
    
    self.Handle.MouseLeave:Connect(function()
        Utility.Tween(self.Indicator, {BackgroundTransparency = 1}, 0.15)
    end)
    
    return self
end

-- ═══════════════════════════════════════════════════════════════
-- DRAGGABLE SYSTEM
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
            local newPos = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
            Utility.Tween(frame, {Position = newPos}, 0.05)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- RESIZABLE SYSTEM
-- ═══════════════════════════════════════════════════════════════
local function MakeResizable(frame, minSize, maxSize)
    minSize = minSize or Vector2.new(400, 300)
    maxSize = maxSize or Vector2.new(1920, 1080)
    
    -- Create resize handles
    local handles = {
        -- Corners
        BottomRight = ResizeHandle.new(frame, UDim2.new(1, -5, 1, -5), "rbxasset://SystemCursors/SizeNWSE"),
        BottomLeft = ResizeHandle.new(frame, UDim2.new(0, -5, 1, -5), "rbxasset://SystemCursors/SizeNESW"),
        TopRight = ResizeHandle.new(frame, UDim2.new(1, -5, 0, -5), "rbxasset://SystemCursors/SizeNESW"),
        TopLeft = ResizeHandle.new(frame, UDim2.new(0, -5, 0, -5), "rbxasset://SystemCursors/SizeNWSE"),
        
        -- Edges
        Right = ResizeHandle.new(frame, UDim2.new(1, -5, 0.5, -5), "rbxasset://SystemCursors/SizeEW"),
        Left = ResizeHandle.new(frame, UDim2.new(0, -5, 0.5, -5), "rbxasset://SystemCursors/SizeEW"),
        Bottom = ResizeHandle.new(frame, UDim2.new(0.5, -5, 1, -5), "rbxasset://SystemCursors/SizeNS"),
        Top = ResizeHandle.new(frame, UDim2.new(0.5, -5, 0, -5), "rbxasset://SystemCursors/SizeNS"),
    }
    
    -- Edge handles should be larger for easier grabbing
    for name, handle in pairs(handles) do
        if name == "Right" or name == "Left" then
            handle.Handle.Size = UDim2.new(0, 10, 0, 100)
            handle.Handle.Position = UDim2.new(
                handle.Handle.Position.X.Scale,
                handle.Handle.Position.X.Offset,
                0.5,
                -50
            )
        elseif name == "Bottom" or name == "Top" then
            handle.Handle.Size = UDim2.new(0, 100, 0, 10)
            handle.Handle.Position = UDim2.new(
                0.5,
                -50,
                handle.Handle.Position.Y.Scale,
                handle.Handle.Position.Y.Offset
            )
        end
    end
    
    -- Resize logic for each handle
    local resizeConnections = {}
    
    local function setupResize(handleName, handle)
        local resizing = false
        local startMousePos
        local startSize
        local startPos
        
        handle.Handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                startMousePos = input.Position
                startSize = frame.Size
                startPos = frame.Position
            end
        end)
        
        handle.Handle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
        
        table.insert(resizeConnections, UserInputService.InputChanged:Connect(function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - startMousePos
                local newWidth = startSize.X.Offset
                local newHeight = startSize.Y.Offset
                local newX = startPos.X.Offset
                local newY = startPos.Y.Offset
                
                -- Calculate new size based on handle position
                if handleName:find("Right") then
                    newWidth = startSize.X.Offset + delta.X
                elseif handleName:find("Left") then
                    newWidth = startSize.X.Offset - delta.X
                    newX = startPos.X.Offset + delta.X
                end
                
                if handleName:find("Bottom") then
                    newHeight = startSize.Y.Offset + delta.Y
                elseif handleName:find("Top") then
                    newHeight = startSize.Y.Offset - delta.Y
                    newY = startPos.Y.Offset + delta.Y
                end
                
                -- Clamp to min/max size
                newWidth = Utility.Clamp(newWidth, minSize.X, maxSize.X)
                newHeight = Utility.Clamp(newHeight, minSize.Y, maxSize.Y)
                
                -- Apply new size and position
                frame.Size = UDim2.new(0, newWidth, 0, newHeight)
                
                if handleName:find("Left") or handleName:find("Top") then
                    frame.Position = UDim2.new(0, newX, 0, newY)
                end
            end
        end))
    end
    
    for name, handle in pairs(handles) do
        setupResize(name, handle)
    end
    
    return handles, resizeConnections
end

-- ═══════════════════════════════════════════════════════════════
-- WINDOW CREATION
-- ═══════════════════════════════════════════════════════════════
function WindowSystem.CreateWindow(config)
    config = config or {}
    
    local Window = {
        Name = config.Name or "UI Library",
        Size = config.Size or UDim2.new(0, 600, 0, 450),
        MinSize = config.MinSize or Vector2.new(400, 300),
        MaxSize = config.MaxSize or Vector2.new(1920, 1080),
        
        -- Managers
        ThemeManager = ThemeManager.new(),
        SoundManager = SoundManager.new(),
        IconManager = IconManager.new(),
        
        -- State
        Maximized = false,
        Minimized = false,
        Transparency = config.Transparency or 0,
        
        -- Data
        Tabs = {},
        Folders = {},
        
        -- Connections
        Connections = {},
    }
    
    -- Create ScreenGui
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "UILibrary_" .. Window.Name
    Window.ScreenGui.ResetOnSpawn = false
    Window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Window.ScreenGui.IgnoreGuiInset = true
    
    -- Parent to appropriate location
    if syn and syn.protect_gui then
        syn.protect_gui(Window.ScreenGui)
        Window.ScreenGui.Parent = CoreGui
    elseif gethui then
        Window.ScreenGui.Parent = gethui()
    else
        Window.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main Container
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Name = "MainFrame"
    Window.MainFrame.Size = Window.Size
    Window.MainFrame.Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    Window.MainFrame.BackgroundColor3 = Window.ThemeManager.CurrentTheme.BackgroundColor
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.BackgroundTransparency = Window.Transparency
    Window.MainFrame.ClipsDescendants = false
    Window.MainFrame.Parent = Window.ScreenGui
    
    Utility.CreateCorner(Window.ThemeManager.CurrentTheme.BorderRadius).Parent = Window.MainFrame
    
    -- Background Image (if provided)
    if config.BackgroundImage then
        Window.BackgroundImage = Instance.new("ImageLabel")
        Window.BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
        Window.BackgroundImage.BackgroundTransparency = 1
        Window.BackgroundImage.Image = config.BackgroundImage
        Window.BackgroundImage.ImageTransparency = config.BackgroundImageTransparency or 0.5
        Window.BackgroundImage.ScaleType = Enum.ScaleType.Crop
        Window.BackgroundImage.ZIndex = 0
        Window.BackgroundImage.Parent = Window.MainFrame
        Utility.CreateCorner(Window.ThemeManager.CurrentTheme.BorderRadius).Parent = Window.BackgroundImage
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
    
    -- Glow Effect (animated)
    Window.Glow = Instance.new("ImageLabel")
    Window.Glow.Name = "Glow"
    Window.Glow.Size = UDim2.new(1, 60, 1, 60)
    Window.Glow.Position = UDim2.new(0, -30, 0, -30)
    Window.Glow.BackgroundTransparency = 1
    Window.Glow.Image = "rbxassetid://5554236805"
    Window.Glow.ImageColor3 = Window.ThemeManager.CurrentTheme.AccentColor
    Window.Glow.ImageTransparency = 0.8
    Window.Glow.ScaleType = Enum.ScaleType.Slice
    Window.Glow.SliceCenter = Rect.new(23, 23, 277, 277)
    Window.Glow.ZIndex = -2
    Window.Glow.Parent = Window.MainFrame
    
    -- Animate glow
    spawn(function()
        while Window.ScreenGui.Parent do
            Utility.Tween(Window.Glow, {ImageTransparency = 0.6}, 1.5)
            wait(1.5)
            Utility.Tween(Window.Glow, {ImageTransparency = 0.8}, 1.5)
            wait(1.5)
        end
    end)
    
    -- Store original size and position for maximize/minimize
    Window.OriginalSize = Window.Size
    Window.OriginalPosition = Window.MainFrame.Position
    
    return Window
end

return WindowSystem
