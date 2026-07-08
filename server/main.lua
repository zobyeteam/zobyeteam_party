ESX = ServerESX()

Parties = {}

RegisterNetEvent('zobyeteam_party:createParty', function(partyName, partyPassword, public, maxPartySlot, itemName)
    local playerId = source

    for _, v in ipairs(Parties) do
        if v.name == partyName then
            return ServerNotify(playerId, 'warning', 'ชื่อปาร์ตี้นี้ถูกใช้งานแล้ว')
        end
    end

    local xPlayer = ESX.GetPlayerFromId(playerId)

    local party = {
        name = partyName,
        id = playerId,
        password = not public and partyPassword or nil,
        level = 1,
        exp = 0,
        maxSlot = maxPartySlot,
        chat = {},
        request = {},
        playerList = {
            {
                name = xPlayer.getName(),
                identifier = xPlayer.getIdentifier(),
                id = playerId,
                active = true
            }
        }
    }

    Parties[#Parties + 1] = party

    TriggerClientEvent('zobyeteam_party:createdParty', playerId, partyName, partyPassword, xPlayer.getName(), maxPartySlot, itemName)

    if not itemName then return end

    local itemData = Config.maxPartySlot[itemName]
    if not (itemData and itemData.remove) then return end

    -- Remove Item
    xPlayer.removeInventoryItem(itemName, 1)
end)

RegisterNetEvent('zobyeteam_party:disbandParty', function(partyId)
    local playerId = source

    for partyIndex, party in ipairs(Parties) do
        if party.id == partyId then
            for _, playerData in ipairs(party.playerList) do
                TriggerClientEvent('zobyeteam_party:disbandedParty', playerData.id)
            end

            table.remove(Parties, partyIndex)
            break
        end
    end
end)

RegisterNetEvent('zobyeteam_party:joinParty', function(targetId, password, public)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local playerParty = getPlayerParty(playerId)

    if playerParty then return end

    for _, party in ipairs(Parties) do
        if party.id == targetId then
            if party.password and party.password ~= password then
                return ServerNotify(playerId, 'warning', 'รหัสผ่านไม่ถูกต้อง')
            end

            if #party.playerList >= party.maxSlot then
                return ServerNotify(playerId, 'warning', 'ปาร์ตี้นี้เต็มแล้ว')
            end

            local playerName = xPlayer.getName()
            local identifier = xPlayer.getIdentifier()

            for _, playerData in ipairs(party.playerList) do
                TriggerClientEvent('zobyeteam_party:joinedParty', playerData.id, playerName, identifier, playerId, public)
            end

            party.playerList[#party.playerList + 1] = {
                name = playerName,
                identifier = identifier,
                id = playerId,
                active = true
            }

        
            TriggerClientEvent('zobyeteam_party:sendMyParty', playerId, party)
        end
    end
end)

function getPlayerParty(targetId)
    if not Parties then
        return
    end

    for index, party in ipairs(Parties) do
        for _, playerData in ipairs(party.playerList) do
            if playerData.id == targetId then
                return party, index
            end
        end
    end
end

RegisterNetEvent('zobyeteam_party:leaveParty', function()
    local playerId = source
    local party, index = getPlayerParty(playerId)

    if not party then
        return
    end

    for memberIndex, memberData in ipairs(party.playerList) do
        if memberData.id == playerId then
            for _, playerData in ipairs(party.playerList) do
                TriggerClientEvent('zobyeteam_party:leftParty', playerData.id, playerId)
            end

            table.remove(party.playerList, memberIndex)
            break
        end
    end
end)

RegisterNetEvent('zobyeteam_party:kickOff', function(targetId)
    local playerId = source
    local party = getPlayerParty(playerId)

    if not party then return end

    for memberIndex, memberData in ipairs(party.playerList) do
        if memberData.id == targetId then
            for _, playerData in ipairs(party.playerList) do
                TriggerClientEvent('zobyeteam_party:kickedOff', playerData.id, targetId)
            end

            table.remove(party.playerList, memberIndex)
            break
        end
    end
end)

function addPartyExp(playerId, exp)
    playerId = playerId or source
    local party = getPlayerParty(playerId)

    if not party then return end

    if party.level == #Config.level and party.exp >= Config.level[party.level].exp then return end

    party.exp = party.exp + exp

    if party.exp >= Config.level[party.level].exp and party.level <= #Config.level then
        local level = party.level

        if level < #Config.level then
            party.level = level + 1
            party.exp = 0
        elseif party.exp > Config.level[level].exp then
            party.exp = Config.level[level].exp
        end

        for _, playerData in ipairs(party.playerList) do
            local xPlayer = ESX.GetPlayerFromId(playerData.id)
            if xPlayer then
                xPlayer.addInventoryItem(Config.level[level].receive.name, Config.level[level].receive.amount)
                TriggerClientEvent('zobyeteam_party:levelUpgraded', playerData.id, party.level, party.exp)
            end
        end
    else
        for _, playerData in ipairs(party.playerList) do
            TriggerClientEvent('zobyeteam_party:updateExp', playerData.id, party.exp)
        end
    end
end
exports('addPartyExp', addPartyExp) 

RegisterNetEvent(Config.eventList['playerLoaded'], function(playerId)
    Wait(2000)
    updatePlayerActive(playerId, true)
end)

RegisterNetEvent('playerDropped', function()
    updatePlayerActive(source, false)
end)

function updatePlayerActive(playerId, active)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    local identifier = xPlayer and xPlayer.getIdentifier() or nil

    for partyIndex, party in ipairs(Parties) do
        for _, playerData in ipairs(party.playerList) do
            if identifier == playerData.identifier or playerData.id == playerId then
                playerData.active = active

                if active then
                    playerData.id = playerId

                    TriggerClientEvent('zobyeteam_party:sendMyParty', playerId, party)
                end

                for _, playerData in ipairs(party.playerList) do
                    TriggerClientEvent('zobyeteam_party:updatePlayerActive', playerData.id, identifier, playerId, active)
                end

                return
            end
        end
    end
end

CreateThread(function()
    while not ESX do Wait(100) end

    ESX.RegisterServerCallback('zobyeteam_party:getPartyList', function(playerId, cb)
        local partyList = {}
    
        for partyIndex, party in ipairs(Parties) do
            partyList[#partyList + 1] = {
                name = party.name,
                id = party.id,
                slot = ('%s/%s'):format(#party.playerList, party.maxSlot),
                level = party.level,
                public = not party.password
            }
        end
    
        cb(partyList)
    end)
end)

RegisterNetEvent('zobyeteam_party:sendMessage', function(message)
    local playerId = source
    local party = getPlayerParty(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not party then return end

    local senderName = split(xPlayer.getName())[1]

    party.chat[#party.chat + 1] = {
        senderId = playerId,
        sender = senderName,
        message = message,
    }

    for _, playerData in ipairs(party.playerList) do
        TriggerClientEvent('zobyeteam_party:sentMessage', playerData.id, playerId, senderName, message)
    end
end)

RegisterNetEvent('zobyeteam_party:sendRequest', function(targetId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    for index, party in ipairs(Parties) do
        if party.id == targetId then
            for _, request in ipairs(party.request) do
                if request.id == playerId then return end
            end

            party.request[#party.request + 1] = {
                name = xPlayer.getName(),
                id = playerId   
            }

            TriggerClientEvent('zobyeteam_party:sentRequest', party.playerList[1].id, xPlayer.getName(), playerId)
            
            break
        end
    end
end)

RegisterNetEvent('zobyeteam_party:acceptRequest', function(targetId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    local party = getPlayerParty(playerId)
    if not party then return end
    
    if party.playerList[1].identifier ~= xPlayer.getIdentifier() then return end
    
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then return end

    local targetParty = getPlayerParty(targetId)
    if targetParty then return end

    if #party.playerList >= party.maxSlot then
        return
    end

    local playerName = xTarget.getName()
    local identifier = xTarget.getIdentifier()

    for _, playerData in ipairs(party.playerList) do
        TriggerClientEvent('zobyeteam_party:joinedParty', playerData.id, playerName, identifier, targetId)
    end

    party.playerList[#party.playerList + 1] = {
        name = playerName,
        identifier = identifier,
        id = targetId,
        active = true
    }

    for requestIndex, requestData in ipairs(party.request) do
        if requestData.id == targetId then
            for _, playerData in ipairs(party.request) do
                TriggerClientEvent('zobyeteam_party:declinedRequest', playerId, targetId)
            end

            table.remove(party.request, requestIndex)

            break
        end
    end

    TriggerClientEvent('zobyeteam_party:sendMyParty', targetId, party)
end)

RegisterNetEvent('zobyeteam_party:declineRequest', function(targetId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    local party = getPlayerParty(playerId)
    if not party then return end
    
    if party.playerList[1].identifier ~= xPlayer.getIdentifier() then return end

    local targetParty = getPlayerParty(targetId)
    if targetParty then return end

    if #party.playerList >= party.maxSlot then return end

    for requestIndex, requestData in pairs(party.request) do
        if requestData.id == targetId then
            for _, playerData in ipairs(party.request) do
                TriggerClientEvent('zobyeteam_party:declinedRequest', playerId, targetId)
            end

            table.remove(party.request, requestIndex)

            break
        end
    end
end)

function canCarryItem(xPlayer, itemName, amount)
    if Config.ESXType == 0 then
        local xItem = xPlayer.getInventoryItem(itemName)
        if not xItem.limit then
            Debug("Your server isn't limit system, please change Config.ESXType to weight system")
            return
        end
        return (xItem.limit == -1) or ((xItem.count + amount) <= xItem.limit)
        
    elseif Config.ESXType == 1 then
        return xPlayer.canCarryItem(itemName, amount)

    elseif Config.ESXType == 2 then
        local xItem = xPlayer.getInventoryItem(itemName)
        if not xItem.limit then
            Debug("Your server isn't both (limit and weight) system, please change Config.ESXType to weight system")
            return
        end
        
        return ((xItem.limit == -1) or ((xItem.count + amount) <= xItem.limit)) and xPlayer.canCarryItem(itemName, amount)
    end

    return false
end

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function addInventoryItem(targetId, itemName, amount, isCheckDistance)
    TriggerClientEvent('zobyeteam_party:addInventoryItem', targetId, itemName, amount, isCheckDistance)
end
exports('addInventoryItem', addInventoryItem)

RegisterNetEvent('zobyeteam_party:addInventoryItem', function(targetId, itemName, amount)
    targetId = targetId or source
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xTarget then return end

    if not canCarryItem(xTarget, itemName, amount) then return end

    xTarget.addInventoryItem(itemName, amount)
end)

function Debug(text, color, ...)
    color = color or '^2'
    print(string.format("%s[ZBT:PARTY] %s ^0", color, text), ...)
end