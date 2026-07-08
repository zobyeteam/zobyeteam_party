--[[
    ZOBYETEAM_PARTY
    Version : 2.0.7
    Written By : TAKZOBYE (ZOBYETEAM)
    This system is copyrighted.
    ( ระบบนี้ได้ทำการจดทะเบียนลิขสิทธิ์เรียบร้อย )
]]

Config = {}

Config.Token = 'Your_Token'

Config.ESXType = 2                                  -- 0 = limit, 1 = weight, 2 = both (weight and limit)

Config.eventList = {                                -- ตั้งค่าอีเวนต์
    ['getSharedObject'] = 'esx:getSharedObject',
    ['playerLoaded'] = 'esx:playerLoaded'
}

Config.showPartyLevelAllTheTime = false             -- แสดง ui level ของปาร์ตี้ตลอดเวลา (ui ฝั่งซ้าย)
Config.togglePartyLevelCommand = 'hidePartyLevel'   -- คำสั่งสำหรับเปิด/ปิด ui level ของปาร์ตี้ (ui ฝั่งซ้าย)

Config.openCommand = 'openParty'
Config.openKey = nil                                -- nil เมื่อต้องการปิดปุ่ม

Config.countOnlyClosePlayer = true                  -- เมื่อใช้ exports function 'getPartyMemberCount' จะนับเฉพาะคนที่อยู่ในระยะ Config.maxDistance เท่านั้น
Config.maxDistance = 30.0                           -- ระยะในการ add ของให้เพื่อน

Config.imagePath = 'nui://zobyeteam_inventory/interface/image/items/'

Config.maxPartySlot = {
    ['water'] = {
        maxSlot = 20,
        remove = true
    },
    ['bread'] = {
        maxSlot = 15,
        remove = true
    },
    ['default'] = {
        maxSlot = 10,                               -- จำนวนสมาชิกสูงสุดในปาร์ตี้สำหรับคนที่สร้างโดยไม่มี item ใน Config.createPartyItem ถ้าตั้งเป็น nil จะไม่สามารถสร้างปาร์ตี้โดยไม่มีไอเทมได้
    }
}

Config.level = {
    {
        exp = 3,
        receive = {
            name = 'water',
            amount = 1
        }
    },
    {
        exp = 3,
        receive = {
            name = 'water',
            amount = 1
        }
    },
    {
        exp = 3,
        receive = {
            name = 'bread',
            amount = 1
        }
    },
    {
        exp = 3,
        receive = {
            name = 'bread',
            amount = 1
        }
    },
    {
        exp = 3,
        receive = {
            name = 'bread',
            amount = 2
        }
    },
}