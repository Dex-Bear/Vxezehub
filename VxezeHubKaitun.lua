local gameId = game.PlaceId
if getgenv().ModeKaitun == "Kaitun Fishing" and (gameId == 2753915549 or gameId == 4442272183 or gameId == 7449423635) then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/KaitunFishing.lua"))()
elseif getgenv().ModeKaitun == "Farm Diamond" and (gameId == 79546208627805 or gameId == 126509999114328) then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubFarmDiamond.lua"))()
end
