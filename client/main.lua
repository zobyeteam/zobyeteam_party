ESX = ClientESX()

myParty = nil
targetGive = nil

local isShowPartyShortcut = Config.showPartyLevelAllTheTime

function openParty(openByKey)
    if openByKey and not Config.openKey then return end
    if IsEntityDead(PlayerPedId()) then return end

    loadData(true)
    openDisplay()
end
exports('openParty', openParty)

if Config.openKey then
    RegisterCommand('openPartyInternal', function()
        openParty(true)
    end, false)
    RegisterKeyMapping('openPartyInternal', 'open party', 'keyboard', Config.openKey)
end
if Config.openCommand then
    RegisterCommand(Config.openCommand, function()
        openParty(false)
    end, false)
end

if Config.togglePartyLevelCommand then
    RegisterCommand(Config.togglePartyLevelCommand, function()
        isShowPartyShortcut = not isShowPartyShortcut

        SendNUIMessage({
            action = 'togglePartyShortcut',
            isShowPartyShortcut = isShowPartyShortcut
        })
    end, false)
end

function openDisplay()
    SendNUIMessage({
        action = 'openDisplay'
    })
    SetNuiFocus(true, true)
end

function closeDisplay()
    SendNUIMessage({
        action = 'closeDisplay'
    })
    SetNuiFocus(false, false)
end
RegisterNUICallback('closeDisplay', closeDisplay)

function loadData(withPartyList)
    local playerData = ESX.GetPlayerData()

    local levelDetail = myParty and Config.level[myParty.level]

    SendNUIMessage({
        action = 'loadData',
        type = 'myParty',
        myParty = myParty,
        maxExp = (myParty and levelDetail) and levelDetail.exp or -1,
        isHeader = myParty and myParty.playerList[1].identifier == playerData.identifier,
        myId = GetPlayerServerId(PlayerId()),
        imagePath = ('%s%s.png'):format(Config.imagePath, (myParty and levelDetail) and levelDetail.receive.name or ''),

        showShortcutDisplayAllTheTime = isShowPartyShortcut
    })

    if not withPartyList then return end

    ESX.TriggerServerCallback('zobyeteam_party:getPartyList', function(partyList)
        SendNUIMessage({
            action = 'loadData',
            type = 'partyList',
            partyList = partyList,
        })
    end)
end

function getMaxPartySlot()
    local inventory = ESX.GetPlayerData().inventory

    local maxPartySlot = 0
    local createBy = nil

    for itemName, item in pairs(Config.maxPartySlot) do
        for _, itemData in ipairs(inventory) do
            if itemData.name == itemName then
                if itemData.count > 0 then
                    if item.maxSlot > maxPartySlot then
                        maxPartySlot = item.maxSlot
                        createBy = itemName
                    end
                end
                break
            end
        end
    end

    if maxPartySlot == 0 then
        maxPartySlot = Config.maxPartySlot['default'].maxSlot
    end

    return maxPartySlot, createBy
end

RegisterNUICallback('createParty', function(data)
    -- data = {
    --     name = 'zobyeteam',
    --     password = '123456',
    --     public = true
    -- }

    if myParty then
        return ClientNotify('warning', 'คุณมีปาร์ตี้อยู่แล้ว')
    end

    if not data.name or data.name == '' then
        return ClientNotify('warning', 'คุณยังไม่ได้ตั้งชื่อปาร์ตี้')
    end

    if not data.public and (not data.password or data.password == '' or #data.password < 2 or #data.password > 8) then
        return ClientNotify('warning', 'รหัสผ่านของคุณไม่ถูกต้อง')
    end

    local maxPartySlot, itemName = getMaxPartySlot()

    if not maxPartySlot then
        return ClientNotify('warning', 'คุณไม่มีไอเทมในการสร้างปาร์ตี้')
    end

    TriggerServerEvent('zobyeteam_party:createParty', data.name, data.password, data.public, maxPartySlot, itemName)
end)

RegisterNetEvent('zobyeteam_party:createdParty', function(partyName, partyPassword, playerName, maxPartySlot)
    local playerData = ESX.GetPlayerData()
    local playerId = GetPlayerServerId(PlayerId())

    myParty = {
        name = partyName,
        id = playerId,
        password = partyPassword,
        level = 1,
        maxLevel = Config.level and #Config.level or -1,
        exp = 0,
        maxSlot = maxPartySlot,
        chat = {},
        request = {},
        playerList = {
            {
                name = playerName,
                identifier = playerData.identifier,
                id = playerId,
                active = true
            }
        }
    }

    loadData(true)
end)

RegisterNUICallback('disbandParty', function()
    if not myParty then return end

    TriggerServerEvent('zobyeteam_party:disbandParty', myParty.id)
end)

RegisterNetEvent('zobyeteam_party:disbandedParty', function()
    myParty = nil

    loadData(true)
end)

RegisterNUICallback('joinParty', function(data)
    if myParty then return end

    TriggerServerEvent('zobyeteam_party:joinParty', data.targetId, data.password)
end)

RegisterNetEvent('zobyeteam_party:joinedParty', function(playerName, identifier, playerId)
    if myParty then
        myParty.playerList[#myParty.playerList + 1] = {
            name = playerName,
            identifier = identifier,
            id = playerId,
            active = true
        }
    end

    loadData()
end)

RegisterNetEvent('zobyeteam_party:sendMyParty', function(party)
    myParty = party
    myParty.maxLevel = Config.level and #Config.level

    loadData()
end)

RegisterNUICallback('leaveParty', function()
    if not myParty then return end

    TriggerServerEvent('zobyeteam_party:leaveParty')
end)

RegisterNetEvent('zobyeteam_party:leftParty', function(targetId)
    if not myParty then return end

    if targetId == GetPlayerServerId(PlayerId()) then
        myParty = nil

        loadData(true)
    else
        for playerIndex, playerData in ipairs(myParty.playerList) do
            if playerData.id == targetId then
                table.remove(myParty.playerList, playerIndex)

                loadData()

                break
            end
        end
    end
end)

RegisterNUICallback('kickOff', function(data)
    if not myParty then return end

    if data.targetId == myParty.playerList[1].id then
        return
    end

    TriggerServerEvent('zobyeteam_party:kickOff', data.targetId)
end)

RegisterNetEvent('zobyeteam_party:kickedOff', function(targetId)
    if not myParty then return end

    local playerId = GetPlayerServerId(PlayerId())

    if targetId == playerId then
        myParty = nil
        loadData(true)

        ClientNotify('warning', 'คุณถูกเตะออกจากปาร์ตี้')
    else
        for playerIndex, playerData in ipairs(myParty.playerList) do
            if playerData.id == targetId then
                table.remove(myParty.playerList, playerIndex)

                loadData(true)

                break
            end
        end
    end
end)

RegisterNetEvent('zobyeteam_party:updatePlayerActive', function(identifier, playerId, active)
    for _, playerData in ipairs(myParty.playerList) do
        if identifier == playerData.identifier then
            playerData.active = active

            if active then
                playerData.id = playerId
            end
            
            break
        end
    end
end)

RegisterNetEvent('zobyeteam_party:levelUpgraded', function(level, exp)
    if not myParty then return end

    myParty.level = level
    myParty.exp = exp
    loadData()

    ClientNotify('success', 'ปาร์ตี้ของคุณได้เลื่อนเลเวลแล้ว')
end)

RegisterNetEvent('zobyeteam_party:updateExp', function(exp)
    if not myParty then return end

    myParty.exp = exp

    loadData()
end)

RegisterNUICallback('sendMessage', function(data)
    data.message = ESX.Math.Trim(data.message)
    if not (data.message and data.message ~= '' and myParty) then return end

    TriggerServerEvent('zobyeteam_party:sendMessage', data.message)
end)

RegisterNetEvent('zobyeteam_party:sentMessage', function(senderId, sender, message)
    if not myParty then return end

    myParty.chat[#myParty.chat + 1] = {
        senderId = senderId,
        sender = sender,
        message = message,
    }

    loadData()
end)

RegisterNUICallback('sendRequest', function(data)
    if myParty or not data.targetId then
        return
    end

    SendNUIMessage({
        action = 'sendRequest'
    })
    
    TriggerServerEvent('zobyeteam_party:sendRequest', data.targetId)
end)

RegisterNetEvent('zobyeteam_party:sentRequest', function(name, playerId)
    if not myParty then return end

    myParty.request[#myParty.request + 1] = {
        name = name,
        id = playerId,
    }

    loadData()
end)

RegisterNUICallback('acceptRequest', function(data)
    if not myParty and data.targetId then return end
    
    if myParty.playerList[1].identifier ~= ESX.GetPlayerData().identifier then return end

    TriggerServerEvent('zobyeteam_party:acceptRequest', data.targetId)
end)

RegisterNUICallback('declineRequest', function(data)
    if not myParty and data.targetId then return end

    if myParty.playerList[1].identifier ~= ESX.GetPlayerData().identifier then return end

    TriggerServerEvent('zobyeteam_party:declineRequest', data.targetId)
end)

RegisterNetEvent('zobyeteam_party:declinedRequest', function(targetId)
    if not myParty and data.targetId then return end

    for requestIndex, requestData in ipairs(myParty.request) do
        if requestData.id == targetId then

            table.remove(myParty.request, requestIndex)

            break
        end
    end

    loadData()
end)

RegisterNuiCallback('changeTargetGive', function(data)
    if not myParty and data.targetId then return end

    local newTargetGive = data and data.targetId or GetPlayerServerId(PlayerId())

    if targetGive == newTargetGive then
        return ClientNotify('warning', 'คุณได้เลือกอยู่แล้ว')
    end

    targetGive = newTargetGive

    SendNUIMessage({
        action = 'changeTargetGive',
        targetGive = targetGive
    })
end)

RegisterNUICallback('alreadyHaveParty', function()
    ClientNotify('warning', 'คุณมีปาร์ตี้อยู่แล้ว')
end)

function addInventoryItem(itemName, amount, isCheckDistance)
    if not (itemName and amount) then return end
    if not myParty then return end

    local targetId = targetGive
    local playerServerId = GetPlayerServerId(PlayerId())

    if targetGive ~= playerServerId then
        if isCheckDistance then
            local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
            local targetCoords = GetEntityCoords(targetPed)

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
    
            local distance = #(playerCoords - targetCoords)

            if not Config.maxDistance or distance > Config.maxDistance then
                targetId = playerServerId
            end
        end
    end

    TriggerServerEvent('zobyeteam_party:addInventoryItem', itemName, amount, targetId)
end
exports('addInventoryItem', addInventoryItem)
RegisterNetEvent('zobyeteam_party:addInventoryItem', addInventoryItem)

function getTargetGive(isCheckDistance)
    local playerServerId = GetPlayerServerId(PlayerId())

    if not myParty or not targetGive then
        targetGive = playerServerId
        return targetGive
    end

    if targetGive ~= playerServerId then
        if isCheckDistance then
            local targetPed = GetPlayerPed(GetPlayerFromServerId(targetGive))
            local targetCoords = GetEntityCoords(targetPed)

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
    
            local distance = #(playerCoords - targetCoords)

            if not Config.maxDistance or distance > Config.maxDistance then
                return playerServerId
            end
        end
    end

    return targetGive
end
exports('getTargetGive', getTargetGive)

function isHasParty()
    return myParty and true or false
end
exports('isHasParty', isHasParty)

function getPartyMemberCount()
    if not myParty then
        return 0
    end

    if not Config.countOnlyClosePlayer then
        return #myParty.playerList
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local memberCount = 1 -- ค่าเริ่มต้นเป็น 1 เนื่องจากนับตัวเองเลย

    for _, playerData in ipairs(myParty.playerList) do
        local targetPed = GetPlayerPed(GetPlayerFromServerId(playerData.id))
        local targetCoords = GetEntityCoords(targetPed)

        if targetPed ~= playerPed then
            local distance = #(playerCoords - targetCoords)

            if distance <= Config.maxDistance then
                memberCount = memberCount + 1
            end
        end
    end

    return memberCount
end
exports('getPartyMemberCount', getPartyMemberCount)

function getPartyMembers(maxDistance)
    if not myParty then
        return {}
    end

    if not Config.countOnlyClosePlayer then
        return #myParty.playerList
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local members = {}

    for _, playerData in ipairs(myParty.playerList) do
        local targetPed = GetPlayerPed(GetPlayerFromServerId(playerData.id))
        local targetCoords = GetEntityCoords(targetPed)

        if targetPed == playerPed then
            members[#members + 1] = playerData
        else
            local distance = #(playerCoords - targetCoords)

            if distance <= (maxDistance or Config.maxDistance) and distance > 0.01 then
                members[#members + 1] = playerData
            end
        end
    end

    return members
end
exports('getPartyMembers', getPartyMembers)

function getIsPartyHeader()
    if not myParty then
        return false
    end

    return myParty.playerList[1] and myParty.playerList[1].id == GetPlayerServerId(PlayerId())
end
exports('getIsPartyHeader', getIsPartyHeader)

function getPartyName()
    if not myParty then return end

    return myParty.name
end
exports('getPartyName', getPartyName)

function addInventoryItem(itemName, amount, isCheckDistance)
    if not (itemName and amount) then return end
    if not myParty then return end

    local targetId = targetGive

    if targetGive ~= playerServerId then
        if isCheckDistance then
            local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
            local targetCoords = GetEntityCoords(targetPed)

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
    
            local distance = #(playerCoords - targetCoords)

            if not Config.maxDistance or distance > Config.maxDistance then
                targetId = playerServerId
            end
        end
    end

    TriggerServerEvent('zobyeteam_party:addInventoryItem', targetId, itemName, amount)
end
exports('addInventoryItem', addInventoryItem)
RegisterNetEvent('zobyeteam_party:addInventoryItem', addInventoryItem)