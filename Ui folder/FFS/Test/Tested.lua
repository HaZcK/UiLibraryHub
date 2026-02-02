--[[
    CONTOH PENGGUNAAN UI LIBRARY ROBLOX
    
    Cara menggunakan:
    1. Copy script UILibrary ke executor Anda
    2. Copy script ini dan jalankan setelah library dimuat
    3. Sesuaikan setiap komponen sesuai kebutuhan
]]

-- Load UI Library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/HaZcK/UiLibraryHub/refs/heads/main/Ui%20folder/FFS/RobloxUILibrary.lua"))()
-- ATAU jika sudah disimpan secara lokal:
-- local UILibrary = require(script.RobloxUILibrary)

-- Membuat Window utama
local Window = UILibrary:CreateWindow({
    Name = "Script Hub Premium",  -- Nama window
    Size = UDim2.new(0, 550, 0, 400)  -- Ukuran window (opsional)
})

-- ========================================
-- TAB 1: MAIN (Tab Utama)
-- ========================================
local MainTab = Window:CreateTab("Main")

-- Menambahkan Section (Header/Pemisah)
MainTab:AddSection("⚡ Main Features")

-- Menambahkan Label (Teks Informasi)
MainTab:AddLabel("Welcome to Script Hub! Pilih fitur di bawah:")

-- Menambahkan Button
MainTab:AddButton({
    Name = "Auto Farm",
    Callback = function()
        print("Auto Farm Activated!")
        Window:Notify({
            Title = "Auto Farm",
            Content = "Auto Farm telah diaktifkan!",
            Duration = 3
        })
        -- Kode auto farm Anda di sini
    end
})

-- Menambahkan Toggle (Switch ON/OFF)
local AutoCollectToggle = MainTab:AddToggle({
    Name = "Auto Collect Coins",
    Default = false,  -- Default state (false = OFF)
    Callback = function(value)
        print("Auto Collect:", value)
        if value then
            -- Kode ketika toggle ON
            print("Mulai mengumpulkan coins...")
        else
            -- Kode ketika toggle OFF
            print("Berhenti mengumpulkan coins...")
        end
    end
})

-- Mengubah toggle secara programmatic
-- AutoCollectToggle:SetValue(true)  -- Set ke ON

-- Menambahkan Slider
local SpeedSlider = MainTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,           -- Nilai minimum
    Max = 200,          -- Nilai maximum
    Default = 16,       -- Nilai default
    Increment = 1,      -- Setiap berapa nilai berubah
    Callback = function(value)
        print("Speed diubah ke:", value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Mengubah slider value secara programmatic
-- SpeedSlider:SetValue(50)

-- ========================================
-- TAB 2: TELEPORT
-- ========================================
local TeleportTab = Window:CreateTab("Teleport")

TeleportTab:AddSection("🚀 Teleport Locations")

-- Dropdown untuk teleport
local locations = {
    "Spawn",
    "Shop",
    "Arena",
    "Boss Room",
    "Secret Area"
}

local TeleportDropdown = TeleportTab:AddDropdown({
    Name = "Select Location",
    Options = locations,
    Default = "Spawn",
    Callback = function(selectedLocation)
        print("Teleporting to:", selectedLocation)
        
        -- Contoh koordinat teleport (sesuaikan dengan game Anda)
        local teleportPositions = {
            ["Spawn"] = Vector3.new(0, 10, 0),
            ["Shop"] = Vector3.new(100, 10, 0),
            ["Arena"] = Vector3.new(200, 10, 0),
            ["Boss Room"] = Vector3.new(300, 10, 0),
            ["Secret Area"] = Vector3.new(400, 10, 0)
        }
        
        local position = teleportPositions[selectedLocation]
        if position then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
            Window:Notify({
                Title = "Teleport",
                Content = "Berhasil teleport ke " .. selectedLocation,
                Duration = 2
            })
        end
    end
})

-- Mengubah dropdown value
-- TeleportDropdown:SetValue("Shop")

-- ========================================
-- TAB 3: PLAYER
-- ========================================
local PlayerTab = Window:CreateTab("Player")

PlayerTab:AddSection("👤 Player Settings")

-- Slider untuk Jump Power
PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 10,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

-- Toggle untuk Infinite Jump
local InfJumpEnabled = false
PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(value)
        InfJumpEnabled = value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- Toggle untuk NoClip
local NoClipEnabled = false
PlayerTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(value)
        NoClipEnabled = value
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if NoClipEnabled then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Toggle untuk Fly
local Flying = false
local FlySpeed = 50

PlayerTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(value)
        Flying = value
        
        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        
        if Flying then
            local BV = Instance.new("BodyVelocity")
            BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BV.Velocity = Vector3.new(0, 0, 0)
            BV.Parent = HumanoidRootPart
            BV.Name = "FlyVelocity"
            
            local BG = Instance.new("BodyGyro")
            BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            BG.CFrame = HumanoidRootPart.CFrame
            BG.Parent = HumanoidRootPart
            BG.Name = "FlyGyro"
            
            game:GetService("RunService").Heartbeat:Connect(function()
                if not Flying then return end
                
                local Camera = workspace.CurrentCamera
                local MoveDirection = Vector3.new(0, 0, 0)
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    MoveDirection = MoveDirection + (Camera.CFrame.LookVector)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    MoveDirection = MoveDirection - (Camera.CFrame.LookVector)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    MoveDirection = MoveDirection - (Camera.CFrame.RightVector)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    MoveDirection = MoveDirection + (Camera.CFrame.RightVector)
                end
                
                BV.Velocity = MoveDirection * FlySpeed
                BG.CFrame = Camera.CFrame
            end)
        else
            if HumanoidRootPart:FindFirstChild("FlyVelocity") then
                HumanoidRootPart.FlyVelocity:Destroy()
            end
            if HumanoidRootPart:FindFirstChild("FlyGyro") then
                HumanoidRootPart.FlyGyro:Destroy()
            end
        end
    end
})

-- ========================================
-- TAB 4: MISC (Lain-lain)
-- ========================================
local MiscTab = Window:CreateTab("Misc")

MiscTab:AddSection("⚙️ Miscellaneous")

-- Textbox untuk custom message
MiscTab:AddTextbox({
    Name = "Custom Message",
    Default = "",
    Placeholder = "Type your message...",
    Callback = function(text)
        print("Message:", text)
        Window:Notify({
            Title = "Message Sent",
            Content = text,
            Duration = 3
        })
    end
})

-- Keybind untuk toggle UI
MiscTab:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightControl,  -- Default key: Right Control
    Callback = function()
        Window.MainFrame.Visible = not Window.MainFrame.Visible
    end
})

-- Button untuk destroy GUI
MiscTab:AddButton({
    Name = "Destroy GUI",
    Callback = function()
        Window:Notify({
            Title = "Goodbye!",
            Content = "GUI akan dihapus dalam 2 detik...",
            Duration = 2
        })
        wait(2)
        Window.ScreenGui:Destroy()
    end
})

-- ========================================
-- TAB 5: CREDITS
-- ========================================
local CreditsTab = Window:CreateTab("Credits")

CreditsTab:AddSection("📜 Credits")
CreditsTab:AddLabel("Script dibuat oleh: YourName")
CreditsTab:AddLabel("UI Library: Custom Roblox UI")
CreditsTab:AddLabel("Versi: 1.0.0")
CreditsTab:AddLabel("")
CreditsTab:AddLabel("Terima kasih telah menggunakan script ini!")

-- Button untuk join Discord (contoh)
CreditsTab:AddButton({
    Name = "Join Discord Server",
    Callback = function()
        setclipboard("https://discord.gg/yourserver")  -- Ganti dengan link Discord Anda
        Window:Notify({
            Title = "Discord",
            Content = "Link Discord telah disalin!",
            Duration = 3
        })
    end
})

-- ========================================
-- NOTIFICATION SAAT LOAD
-- ========================================
Window:Notify({
    Title = "Script Loaded!",
    Content = "Script Hub berhasil dimuat. Selamat menggunakan!",
    Duration = 5
})

print("UI Library loaded successfully!")

