local username = game:GetService("Players").LocalPlayer.Name
local userid = game:GetService("Players").LocalPlayer.UserId



local function inventoryAlert(itemname, rarity, shiny, color, petimage, eggs, chance)
    if string.find(petimage, "rbxassetid://") then petimage = string.sub(petimage, 14, #petimage) end
    if string.find(petimage, "http://") then petimage = string.sub(petimage, 33, #petimage) end
    petimage = "http://www.roblox.com/asset-thumbnail/image?assetId=" .. petimage .. "&width=420&height=420&format=png"
    
    
    local OSTime = os.time();
    local Time = os.date('!*t', OSTime);
    
    local icon = "https://www.roblox.com/headshot-thumbnail/image?userId="..userid.."&width=420&height=420&format=png";
    local Content = _G.optionalContent
    local Embed = {
        color = '3454955';
        title =  'just hatched a '..rarity..' '..itemname;
        footer = { text = ..eggs..'th' };
        author = {
            name = username;
            url = 'https://web.roblox.com/games/2512643572/CARNIVAL-Bubble-Gum-Simulator?refPageId=51a580e2-e5b9-4171-b016-db97b0e8cb0d';
            icon_url = icon;
        };
        thumbnail = {url = petimage};
        timestamp = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec);
    };
        
    if shiny then
        Embed.title = 'Hatched a **Shiny** '..rarity..' '..itemname;
    end
        
    if rarity == "SECRET" then
        Embed.color = 0xFF0064;
    elseif string.find(itemname, "Mythic") then
        Embed.color = 0x0239E7;
    elseif shiny then
        Embed.color = 0xFFFF00;
    elseif color == "blue" then
        Embed.color = 0x00FFFF;
    elseif color == "green" then
        Embed.color = 0x00FF00;
    end
        
    if chance ~= nil and shiny then
        chance = chance / 100;
        Embed.title =  'Hatched a SHINY '..rarity..' '..itemname..'** ('..chance..'%)**';
    elseif chance ~= nil then
        Embed.title =  'Hatched a '..rarity..' '..itemname..'** ('..chance..'%)**';
    end

    (syn and syn.request or http_request) {
        Url = _G.webhookUrl;
        Method = 'POST';
        Headers = {
            ['Content-Type'] = 'application/json';
        };
        Body = game:GetService'HttpService':JSONEncode( { content = Content; embeds = { Embed } } );
    };

end


local f = debug.getupvalues(require(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ClientScript.Modules.InputService).UpdateClickDelay)[1]
repeat
    wait(.1)
    f = debug.getupvalues(require(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ClientScript.Modules.InputService).UpdateClickDelay)[1]
until f ~= nil

local cccc = require(game:GetService("ReplicatedStorage").Assets.Modules.EggService)
repeat
    wait()
    cccc = require(game:GetService("ReplicatedStorage").Assets.Modules.EggService)
until cccc ~= nil


local Module = game:GetService("ReplicatedStorage").Assets.Modules.ImageService
local pets = debug.getupvalues(require(Module))[1]

local petlist = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemDataService.PetModule)
local hatlist = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemDataService.HatModule)
local Eggs = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemDataService.EggModule)
local Crates = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemDataService.CrateModule)
local EasyLeg = {}
local BlueLeg = {}
local GreenLeg = {}
local HEasyLeg = {}
local HBlueLeg = {}
local HGreenLeg = {}

_G.itemInv = {}

local function GetRarity(name)
    local entry = petlist[name]
    if entry ~= nil then
        return petlist[name]['Rarity']
    else
        return hatlist[name]['Rarity']
    end
end

local function GetChance(name)
    local mythic = false
    if string.find(name, "Mythic") then
        name = string.sub(name, 8, #name)
        mythic = true
    end
    for i,v in pairs(Eggs) do 
        for x,y in pairs(v.Rarities) do
            if y[1] == name and mythic then
                return y[2] / 200
            elseif y[1] == name then
                return y[2]
            end
        end
    end
    for i,v in pairs(Crates) do 
        for x,y in pairs(v.Rarities) do
            if y[1] == name and mythic then
                return y[2] / 200
            elseif y[1] == name then
                return y[2]
            end
        end
    end
end

for i , v in pairs(Eggs) do 
    for i , v in pairs(v.Rarities) do
        if GetRarity(v[1]) == 'Legendary' and v[2] >= 0.04 then
            table.insert(EasyLeg,v[1])
        end
        
        if GetRarity(v[1]) == 'Legendary' and v[2] >= 0.005 and v[2] <= 1.0 then
            table.insert(BlueLeg,v[1])
        elseif GetRarity(v[1]) == 'Legendary' and v[2] >= 0.0005 and v[2] <= 0.004 then
            table.insert(GreenLeg,v[1])
        end
    end
end

for i , v in pairs(Crates) do 
    for i , v in pairs(v.Rarities) do
        if GetRarity(v[1]) == 'Legendary' and v[2] >= 0.04 then
            table.insert(HEasyLeg,v[1])
        end
        
        if GetRarity(v[1]) == 'Legendary' and v[2] >= 0.005 and v[2] <= 1.0 then
            table.insert(HBlueLeg,v[1])
        elseif GetRarity(v[1]) == 'Legendary' and v[2] >= 0.0005 and v[2] <= 0.004 then
            table.insert(HGreenLeg,v[1])
        end
    end
end

    cccc.HatchEgg =	function(a1, a2, a3, a4, a5, a6, a7, a8, a9)
                        local name = a3
                        local eggsOpenedindex = require(game:GetService("ReplicatedStorage").Assets.Modules.Library.index)["EGGS_OPENED"]
                        local e = f:InvokeServer("GetPlayerData")
                        local eggsFormatted = e[eggsOpenedindex]
                        local rarity = GetRarity(name)
                        local isShiny = a7
                        local petimage
                        local skipAlert = false
                        for x,y in pairs(pets) do
                            if x == name then
                                petimage = y
                            end
                        end
                        local chance = GetChance(name)
                        local legendColor = ""
                        for i , v in pairs(GreenLeg) do 
                            if v == name then
                                legendColor = "green"
                            end
                        end
                        for i , v in pairs(BlueLeg) do 
                            if v == name then
                                legendColor = "blue"
                            end
                        end
                        for i , v in pairs(HGreenLeg) do 
                            if v == name then
                                legendColor = "green"
                            end
                        end
                        for i , v in pairs(HBlueLeg) do 
                            if v == name then
                                legendColor = "blue"
                            end
                        end
                        if a6 ~= nil then
                            eggsFormatted = eggsFormatted - 3 + a6
                        end
                        while true do  
                            eggsFormatted, k = string.gsub(eggsFormatted, "^(-?%d+)(%d%d%d)", '%1,%2')
                            if (k==0) then
                                break
                            end
                        end

                        for i,v in pairs(_G.SkipRarities) do
                            if rarity == v then
                                skipAlert = true
                            end
                        end

                        if _G.SkipPets ~= nil then
                            for i,v in pairs(_G.SkipPets) do
                                if v == name then
                                    skipAlert = true
                                end
                            end
                        end
                                                    
                        if cccc:IsSecretItem(name) then
                            rarity = "SECRET"
                        end			
                        
                        if not skipAlert then
                            inventoryAlert(name, rarity, isShiny, legendColor, petimage, eggsFormatted, chance)
                            --print(name, rarity, isShiny, legendColor, petimage, eggsFormatted, chance)
                        end
                        
                    end


print('Pet Hatch Alert Is Now On..')