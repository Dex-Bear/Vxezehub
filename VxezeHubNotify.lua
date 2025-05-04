if getgenv().Team == "Marines" then
    if not game.Players.LocalPlayer.Team or game.Players.LocalPlayer.Team.Name ~= "Marines" then
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
    end
elseif getgenv().Team == "Pirates" then
    if not game.Players.LocalPlayer.Team or game.Players.LocalPlayer.Team.Name ~= "Pirates" then
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Ngunhuconcu/refs/heads/main/Notify"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/xSync-gg/VisionX/refs/heads/main/Notify.lua"))()
function Hop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
        local Site;
        if foundAnything=="" then
            Site=game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site=game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~="null" and Site.nextPageCursor ~=nil then
            foundAnything=Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID=tostring(v.id)
            if tonumber(v.maxPlayers)>tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~=0 then
                        if ID==tostring(Existing) then
                            Possible=false
                        end
                    else
                        if tonumber(actualHour) ~=tonumber(Existing) then
                            local delFile = pcall(function()
                                AllIDs={}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num=num+1
                end
                if Possible==true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait()
                end
            end
        end
    end

    function Teleport() 
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~="" then
                    TPReturner()
                end
            end)
        end
    end
    Teleport()
end
if not game:IsLoaded() then game.Loaded:Wait() end

local CoreGui = game:GetService("CoreGui")


pcall(function()
    for _, v in pairs(CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == "VxezeHubUI" then
            v:Destroy()
        end
    end
end)



local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "VxezeHubUI"
ScreenGui.IgnoreGuiInset = true


local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.3 
Frame.ZIndex = 10


local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Position = UDim2.new(0, 0, 0.26, 0)
Title.BackgroundTransparency = 1
Title.Text = "Vxeze Hub"
Title.TextColor3 = Color3.fromRGB(225, 222, 255)
Title.TextScaled = true
Title.Font = Enum.Font.FredokaOne
Title.ZIndex = 11

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Frame
Subtitle.Size = UDim2.new(1, 0, 0.05, 0)
Subtitle.Position = UDim2.new(0, 0, 0.45, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Reason: Vxeze Hub Hop Notify 💫"
Subtitle.TextColor3 = Color3.fromRGB(127, 128, 123)
Subtitle.TextScaled = true
Subtitle.Font = Enum.Font.FredokaOne
Subtitle.ZIndex = 10

function script()
Hop()
end
local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Frame
Subtitle.Size = UDim2.new(1, 0, 0.03, 0)
Subtitle.Position = UDim2.new(0, 0, 0.52, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Hopping Server Wait"
Subtitle.TextColor3 = Color3.fromRGB(127, 128, 123)
Subtitle.TextScaled = true
Subtitle.Font = Enum.Font.FredokaOne
Subtitle.ZIndex = 11
wait(1)
Subtitle.Text = "Hopping Server: 3s"
wait(1)
Subtitle.Text = "Hopping Server: 2s"
wait(1)
Subtitle.Text = "Hopping Server: 1s"
wait(1)
script()
