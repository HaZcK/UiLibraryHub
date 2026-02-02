--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║          ADVANCED ROBLOX UI LIBRARY - TAB SYSTEM              ║
    ║              Tabs with Folders and Icons                      ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local UILib_Core = require(script.Parent.UILib_Core)
local Utility = UILib_Core.Utility

local TabSystem = {}

function TabSystem.Setup(Window)
    -- Tab Container (Left Sidebar)
    Window.TabContainer = Instance.new("ScrollingFrame")
    Window.TabContainer.Name = "TabContainer"
    Window.TabContainer.Size = UDim2.new(0, 160, 1, -55)
    Window.TabContainer.Position = UDim2.new(0, 10, 0, 50)
    Window.TabContainer.BackgroundColor3 = Window.ThemeManager.CurrentTheme.SecondaryBackground
    Window.TabContainer.BackgroundTransparency = Window.Transparency
    Window.TabContainer.BorderSizePixel = 0
    Window.TabContainer.ScrollBarThickness = 4
    Window.TabContainer.ScrollBarImageColor3 = Window.ThemeManager.CurrentTheme.AccentColor
    Window.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    Window.TabContainer.Parent = Window.MainFrame
    
    Utility.CreateCorner(8).Parent = Window.TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.Parent = Window.TabContainer
    
    Utility.CreatePadding(10, 10, 10, 10).Parent = Window.TabContainer
    
    -- Auto-resize canvas
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Window.TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Content Container (Right Side)
    Window.ContentContainer = Instance.new("Frame")
    Window.ContentContainer.Name = "ContentContainer"
    Window.ContentContainer.Size = UDim2.new(1, -190, 1, -55)
    Window.ContentContainer.Position = UDim2.new(0, 180, 0, 50)
    Window.ContentContainer.BackgroundTransparency = 1
    Window.ContentContainer.Parent = Window.MainFrame
end

function TabSystem.CreateTab(Window, config)
    config = config or {}
    
    local Tab = {
        Name = config.Name or "Tab",
        Icon = config.Icon,
        Folders = {},
        Elements = {},
        Visible = false,
    }
    
    -- Tab Button
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = Tab.Name
    Tab.Button.Size = UDim2.new(1, 0, 0, 40)
    Tab.Button.BackgroundColor3 = Window.ThemeManager.CurrentTheme.TertiaryBackground
    Tab.Button.BackgroundTransparency = Window.Transparency
    Tab.Button.BorderSizePixel = 0
    Tab.Button.Text = ""
    Tab.Button.AutoButtonColor = false
    Tab.Button.LayoutOrder = #Window.Tabs + 1
    Tab.Button.Parent = Window.TabContainer
    
    Utility.CreateCorner(6).Parent = Tab.Button
    
    -- Selection Indicator
    Tab.Indicator = Instance.new("Frame")
    Tab.Indicator.Size = UDim2.new(0, 3, 0, 0)
    Tab.Indicator.Position = UDim2.new(0, 0, 0.5, 0)
    Tab.Indicator.AnchorPoint = Vector2.new(0, 0.5)
    Tab.Indicator.BackgroundColor3 = Window.ThemeManager.CurrentTheme.AccentColor
    Tab.Indicator.BorderSizePixel = 0
    Tab.Indicator.Parent = Tab.Button
    
    Utility.CreateCorner(2).Parent = Tab.Indicator
    
    -- Icon
    if Tab.Icon then
        Tab.IconImage = Window.IconManager:CreateIcon(Tab.Icon, UDim2.new(0, 20, 0, 20), Tab.Button)
        Tab.IconImage.Position = UDim2.new(0, 12, 0.5, -10)
        Tab.IconImage.ImageColor3 = Window.ThemeManager.CurrentTheme.SecondaryTextColor
        Tab.IconImage.ImageTransparency = Window.Transparency
    end
    
    -- Label
    Tab.Label = Instance.new("TextLabel")
    Tab.Label.Size = UDim2.new(1, Tab.Icon and -45 or -15, 1, 0)
    Tab.Label.Position = UDim2.new(0, Tab.Icon and 40 or 12, 0, 0)
    Tab.Label.BackgroundTransparency = 1
    Tab.Label.Text = Tab.Name
    Tab.Label.TextColor3 = Window.ThemeManager.CurrentTheme.SecondaryTextColor
    Tab.Label.TextSize = 13
    Tab.Label.Font = Enum.Font.Gotham
    Tab.Label.TextXAlignment = Enum.TextXAlignment.Left
    Tab.Label.TextTransparency = Window.Transparency
    Tab.Label.Parent = Tab.Button
    
    -- Content Frame
    Tab.Content = Instance.new("ScrollingFrame")
    Tab.Content.Name = Tab.Name .. "_Content"
    Tab.Content.Size = UDim2.new(1, 0, 1, 0)
    Tab.Content.BackgroundTransparency = 1
    Tab.Content.BorderSizePixel = 0
    Tab.Content.ScrollBarThickness = 4
    Tab.Content.ScrollBarImageColor3 = Window.ThemeManager.CurrentTheme.AccentColor
    Tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tab.Content.Visible = false
    Tab.Content.Parent = Window.ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = Tab.Content
    
    Utility.CreatePadding(10, 10, 10, 10).Parent = Tab.Content
    
    -- Auto-resize canvas
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Tab.Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Click handler
    Tab.Button.MouseButton1Click:Connect(function()
        TabSystem.SelectTab(Window, Tab)
        Window.SoundManager:Play("Click")
    end)
    
    -- Hover effects
    Tab.Button.MouseEnter:Connect(function()
        if not Tab.Visible then
            Window.SoundManager:Play("Hover")
            Utility.Tween(Tab.Button, {BackgroundColor3 = Color3.fromRGB(
                Window.ThemeManager.CurrentTheme.TertiaryBackground.R * 255 + 10,
                Window.ThemeManager.CurrentTheme.TertiaryBackground.G * 255 + 10,
                Window.ThemeManager.CurrentTheme.TertiaryBackground.B * 255 + 10
            )}, 0.15)
        end
    end)
    
    Tab.Button.MouseLeave:Connect(function()
        if not Tab.Visible then
            Utility.Tween(Tab.Button, {BackgroundColor3 = Window.ThemeManager.CurrentTheme.TertiaryBackground}, 0.15)
        end
    end)
    
    -- Add to window
    table.insert(Window.Tabs, Tab)
    
    -- Select first tab automatically
    if #Window.Tabs == 1 then
        TabSystem.SelectTab(Window, Tab)
    end
    
    -- Add folder creation method
    Tab.CreateFolder = function(folderConfig)
        return TabSystem.CreateFolder(Window, Tab, folderConfig)
    end
    
    return Tab
end

function TabSystem.SelectTab(Window, selectedTab)
    -- Deselect all tabs
    for _, tab in ipairs(Window.Tabs) do
        tab.Visible = false
        tab.Content.Visible = false
        
        Utility.Tween(tab.Button, {BackgroundColor3 = Window.ThemeManager.CurrentTheme.TertiaryBackground}, 0.2)
        Utility.Tween(tab.Label, {TextColor3 = Window.ThemeManager.CurrentTheme.SecondaryTextColor}, 0.2)
        Utility.Tween(tab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
        
        if tab.IconImage then
            Utility.Tween(tab.IconImage, {ImageColor3 = Window.ThemeManager.CurrentTheme.SecondaryTextColor}, 0.2)
        end
    end
    
    -- Select this tab
    selectedTab.Visible = true
    selectedTab.Content.Visible = true
    
    Utility.Tween(selectedTab.Button, {BackgroundColor3 = Window.ThemeManager.CurrentTheme.AccentColor}, 0.2)
    Utility.Tween(selectedTab.Label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    Utility.Tween(selectedTab.Indicator, {Size = UDim2.new(0, 3, 1, -10)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    if selectedTab.IconImage then
        Utility.Tween(selectedTab.IconImage, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end
end

function TabSystem.CreateFolder(Window, Tab, config)
    config = config or {}
    
    local Folder = {
        Name = config.Name or "Folder",
        Icon = config.Icon or "Folder",
        Expanded = config.DefaultExpanded or false,
        Elements = {},
    }
    
    -- Folder Container
    Folder.Container = Instance.new("Frame")
    Folder.Container.Name = "Folder_" .. Folder.Name
    Folder.Container.Size = UDim2.new(1, 0, 0, 40)
    Folder.Container.BackgroundColor3 = Window.ThemeManager.CurrentTheme.SecondaryBackground
    Folder.Container.BackgroundTransparency = Window.Transparency
    Folder.Container.BorderSizePixel = 0
    Folder.Container.ClipsDescendants = true
    Folder.Container.LayoutOrder = config.LayoutOrder or 999
    Folder.Container.Parent = Tab.Content
    
    Utility.CreateCorner(8).Parent = Folder.Container
    
    -- Folder Header
    Folder.Header = Instance.new("TextButton")
    Folder.Header.Size = UDim2.new(1, 0, 0, 40)
    Folder.Header.BackgroundTransparency = 1
    Folder.Header.Text = ""
    Folder.Header.AutoButtonColor = false
    Folder.Header.Parent = Folder.Container
    
    -- Expand Icon
    Folder.ExpandIcon = Window.IconManager:CreateIcon(
        Folder.Expanded and "ChevronDown" or "ChevronRight",
        UDim2.new(0, 18, 0, 18),
        Folder.Header
    )
    Folder.ExpandIcon.Position = UDim2.new(0, 10, 0.5, -9)
    Folder.ExpandIcon.ImageColor3 = Window.ThemeManager.CurrentTheme.AccentColor
    Folder.ExpandIcon.ImageTransparency = Window.Transparency
    
    -- Folder Icon
    Folder.IconImage = Window.IconManager:CreateIcon(Folder.Icon, UDim2.new(0, 20, 0, 20), Folder.Header)
    Folder.IconImage.Position = UDim2.new(0, 35, 0.5, -10)
    Folder.IconImage.ImageColor3 = Window.ThemeManager.CurrentTheme.TextColor
    Folder.IconImage.ImageTransparency = Window.Transparency
    
    -- Folder Label
    Folder.Label = Instance.new("TextLabel")
    Folder.Label.Size = UDim2.new(1, -70, 1, 0)
    Folder.Label.Position = UDim2.new(0, 62, 0, 0)
    Folder.Label.BackgroundTransparency = 1
    Folder.Label.Text = Folder.Name
    Folder.Label.TextColor3 = Window.ThemeManager.CurrentTheme.TextColor
    Folder.Label.TextSize = 14
    Folder.Label.Font = Enum.Font.GothamBold
    Folder.Label.TextXAlignment = Enum.TextXAlignment.Left
    Folder.Label.TextTransparency = Window.Transparency
    Folder.Label.Parent = Folder.Header
    
    -- Content Container
    Folder.Content = Instance.new("Frame")
    Folder.Content.Size = UDim2.new(1, -10, 1, -45)
    Folder.Content.Position = UDim2.new(0, 5, 0, 42)
    Folder.Content.BackgroundTransparency = 1
    Folder.Content.ClipsDescendants = true
    Folder.Content.Parent = Folder.Container
    
    local FolderLayout = Instance.new("UIListLayout")
    FolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    FolderLayout.Padding = UDim.new(0, 6)
    FolderLayout.Parent = Folder.Content
    
    -- Auto-resize
    FolderLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Folder.Expanded then
            Utility.Tween(Folder.Container, {
                Size = UDim2.new(1, 0, 0, FolderLayout.AbsoluteContentSize.Y + 50)
            }, 0.2)
        end
    end)
    
    -- Click to expand/collapse
    Folder.Header.MouseButton1Click:Connect(function()
        Folder.Expanded = not Folder.Expanded
        Window.SoundManager:Play(Folder.Expanded and "Expand" or "Collapse")
        
        if Folder.Expanded then
            -- Update icon
            Folder.ExpandIcon.Image = Window.IconManager:Get("ChevronDown")
            
            -- Expand
            local targetHeight = FolderLayout.AbsoluteContentSize.Y + 50
            Utility.Tween(Folder.Container, {
                Size = UDim2.new(1, 0, 0, targetHeight)
            }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            -- Rotate icon
            Utility.Tween(Folder.ExpandIcon, {Rotation = 0}, 0.3)
        else
            -- Update icon
            Folder.ExpandIcon.Image = Window.IconManager:Get("ChevronRight")
            
            -- Collapse
            Utility.Tween(Folder.Container, {
                Size = UDim2.new(1, 0, 0, 40)
            }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            -- Rotate icon
            Utility.Tween(Folder.ExpandIcon, {Rotation = -90}, 0.3)
        end
    end)
    
    -- Hover effect
    Folder.Header.MouseEnter:Connect(function()
        Utility.Tween(Folder.Header, {BackgroundColor3 = Window.ThemeManager.CurrentTheme.TertiaryBackground}, 0.15)
        Folder.Header.BackgroundTransparency = 0.5
    end)
    
    Folder.Header.MouseLeave:Connect(function()
        Utility.Tween(Folder.Header, {BackgroundTransparency = 1}, 0.15)
    end)
    
    -- Initialize state
    if not Folder.Expanded then
        Folder.ExpandIcon.Rotation = -90
    end
    
    -- Add to tab
    table.insert(Tab.Folders, Folder)
    
    return Folder
end

return TabSystem
