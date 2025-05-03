-- Khai báo biến toàn cục cần thiết
_G.Dark = Color3.fromRGB(24, 24, 26)
_G.Primary = Color3.fromRGB(30, 30, 30)
_G.Third = Color3.fromRGB(50, 50, 50)

-- Xóa các UI cũ nếu tồn tại
if (game:GetService("CoreGui")):FindFirstChild("VxezeHub") and (game:GetService("CoreGui")):FindFirstChild("ScreenGui") then
    (game:GetService("CoreGui")).VxezeHub:Destroy();
    (game:GetService("CoreGui")).ScreenGui:Destroy();
end;

-- Hàm tạo góc bo tròn
function CreateRounded(Parent, Size)
    local Rounded = Instance.new("UICorner");
    Rounded.Name = "Rounded";
    Rounded.Parent = Parent;
    Rounded.CornerRadius = UDim.new(0, Size);
    return Rounded;
end;

-- Khai báo các service
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local ContentProvider = game:GetService("ContentProvider");
local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");

-- Hàm làm cho cửa sổ có thể di chuyển
function MakeDraggable(topbarobject, object)
    local Dragging = nil;
    local DragInput = nil;
    local DragStart = nil;
    local StartPosition = nil;
    
    local function Update(input)
        local Delta = input.Position - DragStart;
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y);
        local Tween = TweenService:Create(object, TweenInfo.new(0.15), {
            Position = pos
        });
        Tween:Play();
    end;
    
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true;
            DragStart = input.Position;
            StartPosition = object.Position;
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false;
                end;
            end);
        end;
    end);
    
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input;
        end;
    end);
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input);
        end;
    end);
end;

-- Tạo nút mở UI
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local existingGui = playerGui:FindFirstChild("CustomScreenGui");
if existingGui then
    existingGui:Destroy();
end;

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "CustomScreenGui";
ScreenGui.Parent = playerGui;

local Button = Instance.new("ImageButton");
Button.Name = "CustomButton";
Button.Parent = ScreenGui;
Button.Size = UDim2.new(0, 50, 0, 50);
Button.Position = UDim2.new(0.015, 0, 0.02, 20);
Button.BackgroundTransparency = 1;
Button.Image = "rbxassetid://91347148253026";

local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(1, 0);
UICorner.Parent = Button;

local imageLoaded = false;
ContentProvider:PreloadAsync({Button.Image}, function()
    imageLoaded = true;
end);

Button.MouseButton1Click:Connect(function()
    if not imageLoaded then return end;
    
    local VirtualInputManager = game:GetService("VirtualInputManager");
    if VirtualInputManager then
        task.defer(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game);
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game);
        end);
    end;
end);

-- Hệ thống thông báo
local NotificationFrame = Instance.new("ScreenGui");
NotificationFrame.Name = "NotificationFrame";
NotificationFrame.Parent = game.CoreGui;
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global;

local NotificationList = {};

local function RemoveOldestNotification()
    if #NotificationList > 0 then
        local removed = table.remove(NotificationList, 1);
        removed[1]:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "Out", "Quad", 0.4, true, function()
            removed[1]:Destroy();
        end);
    end;
end;

spawn(function()
    while wait(2) do
        if #NotificationList > 0 then
            RemoveOldestNotification();
        end;
    end;
end);

-- Module chính
local Update = {};

function Update:Notify(desc)
    local Frame = Instance.new("Frame");
    local Image = Instance.new("ImageLabel");
    local Title = Instance.new("TextLabel");
    local Desc = Instance.new("TextLabel");
    local OutlineFrame = Instance.new("Frame");
    
    OutlineFrame.Name = "OutlineFrame";
    OutlineFrame.Parent = NotificationFrame;
    OutlineFrame.ClipsDescendants = true;
    OutlineFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    OutlineFrame.AnchorPoint = Vector2.new(0.5, 1);
    OutlineFrame.BackgroundTransparency = 0.4;
    OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0);
    OutlineFrame.Size = UDim2.new(0, 412, 0, 72);
    
    Frame.Name = "Frame";
    Frame.Parent = OutlineFrame;
    Frame.ClipsDescendants = true;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = _G.Dark;
    Frame.BackgroundTransparency = 0.1;
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.Size = UDim2.new(0, 400, 0, 60);
    
    Image.Name = "Icon";
    Image.Parent = Frame;
    Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Image.BackgroundTransparency = 1;
    Image.Position = UDim2.new(0, 8, 0, 8);
    Image.Size = UDim2.new(0, 45, 0, 45);
    Image.Image = "rbxassetid://13940080072";
    
    Title.Parent = Frame;
    Title.BackgroundColor3 = _G.Primary;
    Title.BackgroundTransparency = 1;
    Title.Position = UDim2.new(0, 55, 0, 14);
    Title.Size = UDim2.new(0, 10, 0, 20);
    Title.Font = Enum.Font.GothamBold;
    Title.Text = "Vxeze Hub";
    Title.TextColor3 = Color3.fromRGB(255, 255, 255);
    Title.TextSize = 16;
    Title.TextXAlignment = Enum.TextXAlignment.Left;
    
    Desc.Parent = Frame;
    Desc.BackgroundColor3 = _G.Primary;
    Desc.BackgroundTransparency = 1;
    Desc.Position = UDim2.new(0, 55, 0, 33);
    Desc.Size = UDim2.new(0, 10, 0, 10);
    Desc.Font = Enum.Font.GothamSemibold;
    Desc.TextTransparency = 0.3;
    Desc.Text = desc;
    Desc.TextColor3 = Color3.fromRGB(200, 200, 200);
    Desc.TextSize = 12;
    Desc.TextXAlignment = Enum.TextXAlignment.Left;
    
    CreateRounded(Frame, 10);
    CreateRounded(OutlineFrame, 12);
    
    OutlineFrame:TweenPosition(UDim2.new(0.5, 0, 0.1 + (#NotificationList) * 0.1, 0), "Out", "Quad", 0.4, true);
    table.insert(NotificationList, {OutlineFrame, "Vxeze Hub"});
end;

-- Hệ thống cài đặt
local SettingsLib = {
    SaveSettings = true,
    LoadAnimation = true
};

function LoadConfig()
    if readfile and writefile and isfile and isfolder then
        if not isfolder("Vxeze Hub") then
            makefolder("Vxeze Hub");
        end;
        
        if not isfolder("Vxeze Hub/Library/") then
            makefolder("Vxeze Hub/Library/");
        end;
        
        if not isfile("Vxeze Hub/Library/" .. game.Players.LocalPlayer.Name .. ".json") then
            writefile("Vxeze Hub/Library/" .. game.Players.LocalPlayer.Name .. ".json", HttpService:JSONEncode(SettingsLib));
        else
            local Decode = HttpService:JSONDecode(readfile("Vxeze Hub/Library/" .. game.Players.LocalPlayer.Name .. ".json"));
            for i, v in pairs(Decode) do
                SettingsLib[i] = v;
            end;
        end;
    else
        warn("Status: Undetected Executor");
    end;
end;

function SaveConfig()
    if readfile and writefile and isfile and isfolder then
        if not isfile("Vxeze Hub/Library/" .. game.Players.LocalPlayer.Name .. ".json") then
            LoadConfig();
        else
            local Decode = HttpService:JSONDecode(readfile("Vxeze Hub/Library/" .. game.Players.LocalPlayer.Name .. ".json"));
            local Array = {};
            for i, v in pairs(SettingsLib) do
                Array[i] = v;
            end;
            writefile("Vxeze Hub/Library/" .. game.Players.LocalPlayer.Name .. ".json", HttpService:JSONEncode(Array));
        end;
    else
        warn("Status: Undetected Executor");
    end;
end;

LoadConfig();

function Update:SaveSettings()
    return SettingsLib.SaveSettings;
end;

function Update:LoadAnimation()
    return SettingsLib.LoadAnimation;
end;

-- Tạo cửa sổ chính
function Update:Window(Config)
    assert(Config.SubTitle, "v4");
    
    local WindowConfig = {
        Size = Config.Size or UDim2.new(0, 500, 0, 350),
        TabWidth = Config.TabWidth or 100
    };
    
    local osfunc = {};
    local uihide = false;
    local abc = false;
    local currentpage = "";
    local keybind = Config.keybind or Enum.KeyCode.RightControl;
    
    local VxezeHub = Instance.new("ScreenGui");
    VxezeHub.Name = "VxezeHub";
    VxezeHub.Parent = game.CoreGui;
    VxezeHub.DisplayOrder = 999;
    
    local OutlineMain = Instance.new("Frame");
    OutlineMain.Name = "OutlineMain";
    OutlineMain.Parent = VxezeHub;
    OutlineMain.ClipsDescendants = true;
    OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5);
    OutlineMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    OutlineMain.BackgroundTransparency = 0.4;
    OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0);
    OutlineMain.Size = UDim2.new(0, 0, 0, 0);
    CreateRounded(OutlineMain, 15);
    
    local Main = Instance.new("Frame");
    Main.Name = "Main";
    Main.Parent = OutlineMain;
    Main.ClipsDescendants = true;
    Main.AnchorPoint = Vector2.new(0.5, 0.5);
    Main.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
    Main.BackgroundTransparency = 0;
    Main.Position = UDim2.new(0.5, 0, 0.5, 0);
    Main.Size = WindowConfig.Size;
    
    OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15), "Out", "Quad", 0.4, true);
    CreateRounded(Main, 12);
    
    -- Phần còn lại của UI (Tab, Button, Toggle, v.v.)
    -- ... (giữ nguyên như trong code gốc)
    
    local uitab = {};
    
    function uitab:Tab(text, img)
        -- Triển khai tab UI
        -- ... (giữ nguyên như trong code gốc)
        
        local main = {};
        
        function main:Button(text, callback)
            -- Triển khai button
            -- ... (giữ nguyên như trong code gốc)
        end;
        
        function main:Toggle(text, config, desc, callback)
            -- Triển khai toggle
            -- ... (giữ nguyên như trong code gốc)
        end;
        
        function main:Dropdown(text, option, var, callback)
            -- Triển khai dropdown
            -- ... (giữ nguyên như trong code gốc)
        end;
        
        function main:Slider(text, min, max, set, callback)
            -- Triển khai slider
            -- ... (giữ nguyên như trong code gốc)
        end;
        
        function main:Textbox(text, disappear, callback)
            -- Triển khai textbox
            -- ... (giữ nguyên như trong code gốc)
        end;
        
        function main:Label(text)
            -- Triển khai label
            -- ... (giữ nguyên như trong code gốc)
        end;
        
        function main:Seperator(text)
            -- Triển khai separator
            -- ... (giữ nguyên như trong code gốc)
        end;
        
        function main:Line()
            -- Triển khai line
            -- ... (giữ nguyên như trong code gốc)
        end;
        
        return main;
    end;
    
    return uitab;
end;

return Update;
