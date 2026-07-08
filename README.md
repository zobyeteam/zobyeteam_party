# 👥 ZOBYETEAM Party System (v2.0.7) - Open Source Version

ยินดีต้อนรับสู่ **ZOBYETEAM Party System**! 🎉 
ระบบปาร์ตี้ (Party/Group) สำหรับเซิร์ฟเวอร์ GTA V FiveM (ESX) ที่ปัจจุบันเปิดให้ใช้งานในรูปแบบ **Open Source** เรียบร้อยแล้ว สคริปต์นี้ถูกพัฒนาขึ้นเพื่อให้เซิร์ฟเวอร์ต่างๆ สามารถนำไปใช้งาน ปรับแต่ง และต่อยอดพัฒนาต่อได้อย่างอิสระโดยไม่มีค่าใช้จ่าย

ช่วยให้ผู้เล่นในเซิร์ฟเวอร์ของคุณรวมกลุ่มกันแชร์ของฟาร์ม ทำกิจกรรมร่วมกัน เก็บเลเวลปาร์ตี้ และคุยกันผ่านหน้าต่างแชทส่วนตัวแบบเรียลไทม์

---

## 🚀 ฟีเจอร์เด่นของระบบ (Features)

*   **สร้างปาร์ตี้ส่วนตัวหรือสาธารณะ:** ตั้งชื่อกลุ่ม กำหนดรหัสผ่านล็อกห้อง หรือเปิดให้ผู้เล่นอื่นกดขอเข้าร่วมได้
*   **ระบบจำกัดสมาชิกตามไอเทม (Dynamic Slot Limits):** จำนวนสมาชิกสูงสุดในปาร์ตี้จะขึ้นอยู่กับไอเทมที่คนสร้างมีอยู่ในตัว ณ ตอนสร้าง (เช่น มีน้ำสร้างได้ 20 คน, มีขนมปังสร้างได้ 15 คน, ไม่มีไอเทมเลยสร้างได้ 10 คนเป็นค่าเริ่มต้น) และระบบจะหักไอเทมนั้นออกเมื่อสร้างสำเร็จ
*   **ระบบแชร์/ส่งไอเทมให้เพื่อนในปาร์ตี้ (Item Sharing & Target Selection):**
    *   ผู้เล่นสามารถเลือก "ผู้รับไอเทมหลัก (Target Give)" ใน UI ได้
    *   เมื่อไปทำกิจกรรม เช่น ฟาร์มผัก ขุดแร่ หรือตกปลา (ที่เชื่อมกับ Export ของสคริปต์นี้) ไอเทมที่ได้จะเด้งไปเข้าตัวเพื่อนที่เราเลือกไว้ทันที
    *   **ระบบป้องกันการแชร์ข้ามโลก:** มีการตรวจเช็คระยะห่างระหว่างคนฟาร์มและคนรับ (เช่น ต้องอยู่ห่างกันไม่เกิน 30 เมตร) หากอยู่ไกลเกินระยะ ไอเทมจะเข้าตัวคนฟาร์มแทนโดยอัตโนมัติ เพื่อป้องกันการเอาตัวรองไปฟาร์มแล้วส่งของเข้าตัวหลักระยะไกล
*   **ระบบเลเวลและ EXP ปาร์ตี้ (Party Leveling):** เมื่อปาร์ตี้สะสม EXP จนเลเวลอัป สมาชิกทุกคนที่ออนไลน์อยู่ในปาร์ตี้จะได้รับไอเทมรางวัลตามที่ตั้งค่าไว้ (เช่น เลเวลอัปแล้วได้น้ำ/ขนมปังแจกให้ทุกคน)
*   **ระบบแชทในปาร์ตี้ (Party Chat UI):** หน้าต่าง UI แชทสีสันสวยงาม พูดคุยสื่อสารกันเฉพาะในกลุ่มได้สะดวกสบาย
*   **UI เลเวลข้างหน้าจอ (Shortcut UI):** แสดงสถานะเลเวลปาร์ตี้และแถบ EXP ปัจจุบันบริเวณข้างจอ สามารถพิมพ์คำสั่งเพื่อเปิด/ปิด UI นี้ได้ตลอดเวลา
*   **เป็นมิตรต่อประสิทธิภาพเซิร์ฟเวอร์ (Performance Friendly):**
    *   เก็บข้อมูลปาร์ตี้ใน Memory Runtime (ไม่ได้ใช้ SQL/Database) ทำให้ไม่มีภาระโหลดฐานข้อมูล
    *   ข้อมูลปาร์ตี้จะรีเซ็ตอัตโนมัติเมื่อผู้เล่นทุกคนในปาร์ตี้ออฟไลน์

---

## 📦 สิ่งที่ต้องใช้ก่อนติดตั้ง (Dependencies)

เพื่อให้สคริปต์ทำงานได้อย่างสมบูรณ์ เซิร์ฟเวอร์ของคุณต้องมีสคริปต์เหล่านี้ติดตั้งอยู่ก่อนแล้ว:

1.  **[es_extended](https://github.com/esx-framework/es_extended)** (ระบบ Framework หลักของเซิร์ฟเวอร์)
2.  **zobyeteam_notify** (ระบบแจ้งเตือนของ ZOBYETEAM)

---

## 🛠️ วิธีการติดตั้ง (Installation)

1.  ดาวน์โหลดหรือนำโฟลเดอร์ `zobyeteam_party` ไปวางไว้ในไดเรกทอรี `resources/` ของเซิร์ฟเวอร์ของคุณ (เช่น `resources/[scripts]/zobyeteam_party`)
2.  เปิดไฟล์ `server.cfg` ของเซิร์ฟเวอร์
3.  เพิ่มบรรทัดคำสั่งสตาร์ทสคริปต์ดังนี้:
    ```cfg
    ensure zobyeteam_party
    ```
4.  รีสตาร์ทเซิร์ฟเวอร์ หรือพิมพ์คำสั่ง `refresh` และ `ensure zobyeteam_party` ใน F8 Console/Server Console

---

## 📂 โครงสร้างโฟลเดอร์สำหรับนักพัฒนา (Folder Structure)

หากคุณต้องการนำโค้ดไปแก้ไข ดัดแปลง หรือแปล UI เป็นของตัวเอง:

*   📁 `client/` - ประกอบด้วย logic ฝั่งผู้เล่น (Client side) เช่น การเปิด/ปิด UI, การดึงพิกัด และการคำนวณระยะห่าง
*   📁 `server/` - ประกอบด้วย logic ฝั่งเซิร์ฟเวอร์ (Server side) เช่น การจัดเก็บข้อมูลปาร์ตี้ชั่วคราว, ระบบเลเวลอัป และการมอบไอเทม
*   📁 `config/` - ไฟล์ตั้งค่าระบบและการเรียกใช้ Callback ต่างๆ (ดึง ESX, ระบบ Notify)
*   📁 `interface/` - โค้ดของ UI หน้าต่างเมนูปาร์ตี้และแชท (พัฒนาด้วย HTML, CSS, JavaScript และ Tailwind) คุณสามารถมาแก้ไขดีไซน์และแปลภาษาของ UI ได้ที่นี่

---

## ⚙️ วิธีการกำหนดค่า (Configuration)

คุณสามารถตั้งค่าระบบได้ง่ายๆ ผ่าน 2 ไฟล์หลักในโฟลเดอร์ `config/` ดังนี้:

### 1. ไฟล์ `config/config.lua` (การตั้งค่าระบบและเงื่อนไข)

```lua
Config = {}

-- คีย์โทเค็นสำหรับเปิดใช้งานสคริปต์ (เปิดว่างไว้หรือใส่ค่าอะไรก็ได้ในรุ่น Open Source)
Config.Token = 'Your_Token'

-- รูปแบบระบบกระเป๋า ESX ที่คุณใช้
-- 0 = ระบบจำกัดจำนวน (Limit system)
-- 1 = ระบบน้ำหนัก (Weight system)
-- 2 = ใช้ทั้งสองระบบ (Weight และ Limit ควบคู่กัน)
Config.ESXType = 2 

-- ชื่ออีเวนต์ของ ESX หากเซิร์ฟเวอร์ของคุณมีการเปลี่ยนชื่ออีเวนต์หลัก
Config.eventList = {
    ['getSharedObject'] = 'esx:getSharedObject',
    ['playerLoaded'] = 'esx:playerLoaded'
}

-- การแสดงผล UI เลเวลปาร์ตี้ข้างหน้าจอ (ฝั่งซ้าย)
Config.showPartyLevelAllTheTime = false             -- true = แสดงตลอดเวลาตั้งแต่เริ่ม, false = ปิดไว้ก่อน (เปิดเองทีหลังได้)
Config.togglePartyLevelCommand = 'hidePartyLevel'   -- คำสั่งในแชทสำหรับเปิด/ปิด UI เลเวลข้างจอ (เช่นพิมพ์ /hidePartyLevel)

-- คำสั่งเปิด UI หลักของปาร์ตี้
Config.openCommand = 'openParty'                    -- คำสั่งเปิดเมนู (เช่นพิมพ์ /openParty)
Config.openKey = nil                                -- ปุ่มบนคีย์บอร์ดสำหรับกดเปิดเมนู (ตั้งเป็น nil หากต้องการใช้แค่คำสั่งพิมพ์ในช่องแชท)

-- การแชร์ไอเทมและระยะห่าง
Config.countOnlyClosePlayer = true                  -- ถ้ารัน export นับจำนวนคนในตี้ จะนับเฉพาะคนที่อยู่ใกล้ๆ เท่านั้น
Config.maxDistance = 30.0                           -- ระยะห่างสูงสุด (เมตร) สำหรับแชร์ของให้เพื่อน ถ้าห่างเกินของเข้าตัวคนฟาร์มแทน

-- ที่อยู่รูปภาพไอเทมที่ใช้ดึงมาแสดงในหน้า UI
Config.imagePath = 'nui://zobyeteam_inventory/interface/image/items/'

-- ตั้งค่าความจุสมาชิกสูงสุดของปาร์ตี้ (Slots) อิงตามไอเทมที่คนสร้างครอบครองอยู่
Config.maxPartySlot = {
    ['water'] = {
        maxSlot = 20,       -- ถ้ามีไอเทม water ในตัวตอนสร้าง จะสร้างปาร์ตี้ขนาดสูงสุดได้ 20 คน
        remove = true       -- หักไอเทม water ออก 1 ชิ้นหลังจากสร้างปาร์ตี้สำเร็จ
    },
    ['bread'] = {
        maxSlot = 15,       -- ถ้ามีไอเทม bread ในตัวตอนสร้าง จะสร้างปาร์ตี้ขนาดสูงสุดได้ 15 คน
        remove = true       -- หักไอเทม bread ออก 1 ชิ้นหลังจากสร้างปาร์ตี้สำเร็จ
    },
    ['default'] = {
        maxSlot = 10,       -- จำนวนคนสูงสุดกรณีสร้างปาร์ตี้ธรรมดาแบบไม่มีไอเทมใดๆ ด้านบนอยู่ในตัว (ตั้งเป็น nil เพื่อห้ามสร้างหากไม่มีไอเทม)
    }
}

-- ตั้งค่าระดับเลเวลของปาร์ตี้, EXP ที่ต้องการใช้ในการอัปเวล และของรางวัลที่ได้รับเมื่อเลเวลอัป
Config.level = {
    {
        exp = 3,            -- เลเวล 1 ไป 2 ใช้ 3 EXP
        receive = {
            name = 'water', -- เมื่อเลเวลอัป สมาชิกทุกคนในตี้จะได้ไอเทม water
            amount = 1      -- ได้รับจำนวน 1 ชิ้น
        }
    },
    {
        exp = 3,            -- เลเวล 2 ไป 3 ใช้ 3 EXP
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
        exp = 3,            -- เลเวล 5 (เลเวลสูงสุดในตัวอย่างนี้)
        receive = {
            name = 'bread',
            amount = 2
        }
    },
}
```

### 2. ไฟล์ `config/config_callback.lua` (การดึงฟังก์ชันและระบบแจ้งเตือน)
ใช้สำหรับกรณีปรับเปลี่ยน Framework หรือต้องการใช้ระบบแจ้งเตือน (Notify) ของสคริปต์อื่น:

```lua
-- ฟังก์ชันดึง Shared Object ของ ESX (ฝั่ง Client)
function ClientESX()
    return exports["es_extended"]:getSharedObject()
end

-- ฟังก์ชันดึง Shared Object ของ ESX (ฝั่ง Server)
function ServerESX()
    return exports["es_extended"]:getSharedObject()
end

-- ระบบแจ้งเตือนฝั่ง Client (แก้ไขหากต้องการใช้ Notify อื่น)
function ClientNotify(type, content)
    exports['zobyeteam_notify']:send({type = type, content = content})
end

-- ระบบแจ้งเตือนฝั่ง Server (แก้ไขหากต้องการใช้ Notify อื่น)
function ServerNotify(playerId, type, content)
    TriggerClientEvent('zobyeteam_notify:send', playerId, {type = type, content = content})
end
```

---

## 💻 สำหรับนักพัฒนา (Developer API & Exports)

คุณสามารถนำ Exports เหล่านี้ไปเชื่อมโยงกับสคริปต์อื่นๆ เช่น **สคริปต์ฟาร์ม, สคริปต์ขุดแร่, ตกปลา หรือระบบเควส** เพื่อให้ผู้เล่นแชร์ของรางวัลกัน หรือเพิ่ม EXP ให้ปาร์ตี้ได้

### 📍 Client-Side Exports

#### 1. ส่งไอเทมให้คนในปาร์ตี้ที่เลือกไว้
สั่งแอดไอเทมส่งไปยังผู้เล่นที่เป็น "เป้าหมายรับไอเทม" ที่เลือกไว้ใน UI ปาร์ตี้
```lua
-- exports['zobyeteam_party']:addInventoryItem(itemName, amount, isCheckDistance)
-- ตัวอย่าง: ได้รับไม้ 1 ชิ้น ส่งไปให้คนที่เราเลือกรับของในตี้ (เช็คระยะห่างด้วย)
exports['zobyeteam_party']:addInventoryItem('wood', 1, true)
```

#### 2. เช็คว่าผู้เล่นมีปาร์ตี้หรือไม่
```lua
-- คืนค่ากลับมาเป็น true หรือ false
local hasParty = exports['zobyeteam_party']:isHasParty()
if hasParty then
    print("ผู้เล่นนี้อยู่ในปาร์ตี้")
end
```

#### 3. ดึง ID ของเป้าหมายผู้รับไอเทม (Target Give)
```lua
-- คืนค่ากลับมาเป็น Server ID ของผู้เล่นที่เป็นเป้าหมายรับของในปาร์ตี้ (ถ้าไม่มีตี้หรืออยู่ไกลเกิน จะคืนค่าเป็น Server ID ของตนเอง)
local targetServerId = exports['zobyeteam_party']:getTargetGive(true)
```

#### 4. นับจำนวนสมาชิกในปาร์ตี้
```lua
-- คืนค่าเป็นตัวเลขจำนวนสมาชิกในปาร์ตี้ (หากเปิด Config.countOnlyClosePlayer จะนับเฉพาะคนที่อยู่ใกล้ในระยะ)
local memberCount = exports['zobyeteam_party']:getPartyMemberCount()
```

#### 5. เช็คว่าตัวเองเป็นหัวหน้าปาร์ตี้หรือไม่
```lua
-- คืนค่าเป็น true หรือ false
local isHeader = exports['zobyeteam_party']:getIsPartyHeader()
```

#### 6. ดึงชื่อปาร์ตี้
```lua
local partyName = exports['zobyeteam_party']:getPartyName()
```

---

### 📍 Server-Side Exports

#### 1. เพิ่ม EXP ให้ปาร์ตี้ของผู้เล่น
สั่งเพิ่มค่า EXP ให้กับปาร์ตี้ที่ผู้เล่นคนนั้นสังกัดอยู่ (เช่นเมื่อผู้เล่นทำงานเสร็จ)
```lua
-- exports['zobyeteam_party']:addPartyExp(sourcePlayerId, expAmount)
-- ตัวอย่าง: ทำงานส่งแก๊สเสร็จ เพิ่ม EXP ให้ปาร์ตี้ของผู้เล่นคนนี้ 1 หน่วย
exports['zobyeteam_party']:addPartyExp(source, 1)
```

#### 2. แอดไอเทมให้ผู้รับไอเทมโดยตรง (Server Side)
```lua
-- exports['zobyeteam_party']:addInventoryItem(targetPlayerId, itemName, amount)
exports['zobyeteam_party']:addInventoryItem(targetId, 'iron', 2)
```

---

### 📝 ตัวอย่างการประยุกต์ใช้งานในสคริปต์ฟาร์ม (Example Usage in Farm Script)

**ก่อนใช้ระบบแชร์ปาร์ตี้:**
```lua
-- เดิมทีแอดเข้าตัวผู้เล่นที่ฟาร์มตรงๆ
TriggerServerEvent('farm_script:giveItem', 'wood', 1)
```

**หลังใช้ระบบแชร์ปาร์ตี้ (Client Side):**
```lua
local itemName = 'wood'
local amount = 1

if exports['zobyeteam_party']:isHasParty() then
    -- ส่งไอเทมให้คนที่เลือกเป็นเป้าหมายในปาร์ตี้ (และเช็คระยะป้องกันการแชร์ข้ามแมพ)
    exports['zobyeteam_party']:addInventoryItem(itemName, amount, true)
else
    -- ถ้าไม่มีปาร์ตี้ ให้เข้าตัวเองตามปกติ
    TriggerServerEvent('farm_script:giveItem', itemName, amount)
end
```

---

## 🤝 การมีส่วนร่วมและพัฒนาต่อ (Contributing & Customization)

เนื่องจากสคริปต์นี้เป็น **Open Source** ทางเรายินดีเป็นอย่างยิ่งหากคุณต้องการร่วมพัฒนาหรือแก้ไขข้อผิดพลาด (Bugs):
1.  **Fork** รีโพสิทอรีนี้ไปที่บัญชีของคุณ
2.  สร้าง Branch ใหม่เพื่อเพิ่มฟีเจอร์หรือแก้ไขบั๊ก (`git checkout -b feature/AmazingFeature` หรือ `git checkout -b bugfix/FixSomeBug`)
3.  ทำการ **Commit** การเปลี่ยนแปลงที่คุณแก้ไข (`git commit -m 'Add some AmazingFeature'`)
4.  **Push** ขึ้น Branch ของคุณ (`git push origin feature/AmazingFeature`)
5.  ส่ง **Pull Request** กลับมาให้เราตรวจสอบและรวมโค้ด

---

## 📄 สัญญาอนุญาต (License)

สคริปต์นี้เผยแพร่ภายใต้สัญญาอนุญาต **MIT License**

```text
Copyright (c) 2026 ZOBYETEAM

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
