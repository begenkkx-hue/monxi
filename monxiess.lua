local KEYS = {
    ["monxiess123"] = true,
    ["monxiess456"] = true,
}
local LINK_KEY = "https://link-key-kamu.com" -- ganti link tempat ambil key
local NAMA_LAMA, NAMA_BARU = "OrusWare", "monxiess"
local URL = "https://raw.githubusercontent.com/XITHHUB/Main/refs/heads/main/AssassinLevelingHub.obf.lua"
local FILE_KEY = "monxiess_key.txt"

local TweenService = game:GetService("TweenService")

local function jalankanHub()
    loadstring(game:HttpGet(URL))()

    local function ganti(o)
        if not (o:IsA("TextLabel") or o:IsA("TextButton")) then return end
        local function fix()
            if o.Text:find(NAMA_LAMA) then
                o.Text = (o.Text:gsub(NAMA_LAMA, NAMA_BARU))
            end
        end
        fix()
        o:GetPropertyChangedSignal("Text"):Connect(fix)
    end

    local roots = {game:GetService("CoreGui"), game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")}
    pcall(function() table.insert(roots, gethui()) end)
    for _, root in ipairs(roots) do
        for _, o in ipairs(root:GetDescendants()) do ganti(o) end
        root.DescendantAdded:Connect(ganti)
    end
end

-- Login otomatis kalau key tersimpan masih valid
local tersimpan
pcall(function() tersimpan = readfile(FILE_KEY) end)
if tersimpan and KEYS[tersimpan] then
    jalankanHub()
    return
end

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "KeyMenu"
gui.ResetOnSpawn = false
local ok = pcall(function() gui.Parent = gethui() end)
if not ok or not gui.Parent then gui.Parent = game:GetService("CoreGui") end

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 250)
frame.Position = UDim2.new(0.5, -160, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
frame.BackgroundTransparency = 1
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(70, 130, 255)
stroke.Thickness = 1.5
stroke.Transparency = 1

local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new(Color3.fromRGB(32, 32, 42), Color3.fromRGB(18, 18, 24))
grad.Rotation = 90

local function label(text, size, y, font, color)
    local l = Instance.new("TextLabel", frame)
    l.Size = UDim2.new(1, -40, 0, size + 8)
    l.Position = UDim2.new(0, 20, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.new(1, 1, 1)
    l.Font = font or Enum.Font.Gotham
    l.TextSize = size
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local function tombol(text, y, warna)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -40, 0, 38)
    b.Position = UDim2.new(0, 20, 0, y)
    b.Text = text
    b.BackgroundColor3 = warna
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.AutoButtonColor = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

label("monxiess HUB", 20, 14, Enum.Font.GothamBold)
label("Masukkan key untuk melanjutkan", 12, 42, Enum.Font.Gotham, Color3.fromRGB(150, 150, 165))

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -38, 0, 10)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(45, 45, 56)
close.TextColor3 = Color3.fromRGB(255, 110, 110)
close.Font = Enum.Font.GothamBold
close.TextSize = 13
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -40, 0, 38)
box.Position = UDim2.new(0, 20, 0, 72)
box.PlaceholderText = "Tempel key di sini..."
box.PlaceholderColor3 = Color3.fromRGB(110, 110, 125)
box.Text = ""
box.ClearTextOnFocus = false
box.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.Gotham
box.TextSize = 14
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

local btnVerif = tombol("Verifikasi", 120, Color3.fromRGB(60, 120, 255))
local btnLink = tombol("Copy Link Key", 164, Color3.fromRGB(50, 50, 64))

local status = label("", 13, 210, Enum.Font.Gotham)
status.TextXAlignment = Enum.TextXAlignment.Center

local function setStatus(teks, warna)
    status.Text = teks
    status.TextColor3 = warna
end

btnLink.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(LINK_KEY)
        setStatus("Link key disalin!", Color3.fromRGB(80, 220, 120))
    else
        setStatus("Executor tidak support copy", Color3.fromRGB(255, 90, 90))
    end
end)

btnVerif.MouseButton1Click:Connect(function()
    local input = box.Text:gsub("%s+", "")
    if KEYS[input] then
        pcall(function() writefile(FILE_KEY, input) end)
        setStatus("Key benar, memuat...", Color3.fromRGB(80, 220, 120))
        task.wait(0.6)
        gui:Destroy()
        jalankanHub()
    else
        setStatus("Key salah!", Color3.fromRGB(255, 90, 90))
    end
end)

-- Animasi muncul
local info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(frame, info, {BackgroundTransparency = 0}):Play()
TweenService:Create(stroke, info, {Transparency = 0}):Play()
