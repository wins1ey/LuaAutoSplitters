processID('WildGunsReloaded.exe')

local baseAddress = 0x00400000

local prevPlayerSelected
local prevMultiPlayerSelected

while true do
    local playerSelected = readAddress(8, baseAddress, 0x01093FAC, 0x50, 0x4, 0x8, 0x8, 0x34);
    local multiPlayerSelected = readAddress(8, baseAddress, 0x0100CCA8, 0x30, 0x168, 0x16C, 0xC, 0x38, 0x2C);
    local goTitle = readAddress(8, baseAddress, 0x01093FAC, 0x40, 0x0, 0x8, 0x8, 0x6C)

    --if playerSelected ~= prevPlayerSelected or multiPlayerSelected ~= prevMultiPlayerSelected then
    print(playerSelected .. ' ' .. multiPlayerSelected)
    --end

    if playerSelected == 3 or multiPlayerSelected == 3 then
        sendCommand('starttimer\r\n')
    end

    prevPlayerSelected = playerSelected
    prevMultiPlayerSelected = multiPlayerSelected
end