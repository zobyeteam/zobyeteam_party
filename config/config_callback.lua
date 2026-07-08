--[[
    ZOBYETEAM_PARTY
    Version : 2.0.7
    Written By : TAKZOBYE (ZOBYETEAM)
    This system is copyrighted.
    ( ระบบนี้ได้ทำการจดทะเบียนลิขสิทธิ์เรียบร้อย )
]]

function ClientESX()
    return exports["es_extended"]:getSharedObject()
end

function ServerESX()
    return exports["es_extended"]:getSharedObject()
end

function ClientNotify(type, content) -- client side
    exports['zobyeteam_notify']:send({type = type, content = content})
end

function ServerNotify(playerId, type, content) -- server side
    TriggerClientEvent('zobyeteam_notify:send', playerId, {type = type, content = content})
end