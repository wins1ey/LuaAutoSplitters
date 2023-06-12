processID('AmidEvil-Win64-Shipping.exe')

local baseAddress = 0x140000000

local prevStart
local prevLoading
local prevMenuStage
local prevPaused

lasPrint('AMID EVIL\n')
lasPrint('Mode: ')

local mode
while mode ~= 1 and mode ~= 2 do
    print('\n1. Full game\n2. Episodes\nSelect a mode: ')
    mode = tonumber(io.read())
end

if mode == 1 then
    lasPrint('Full game\n')
elseif mode == 2 then
    lasPrint('Episodes\n')
end

while true do
    local start = readAddress(8, baseAddress, 0x2BAFFD0)
    local loading = readAddress(8, baseAddress, 0x2E76B0C)
    local menuStage = readAddress(8, baseAddress, 0x2F75F14)
    local paused = readAddress(8, baseAddress, 0x2B95A68)

    if mode == 2 and (loading == 0 and prevLoading == 1) then
        sendCommand('starttimer\r\n')
    elseif start == 0 and prevStart == 2 then
        sendCommand('starttimer\r\n')
    end

    if (loading == 1 and prevLoading == 0) or (menuStage == 3 and paused == 4) and (prevMenuStage ~= 3 or prevPaused ~= 4) then
        sendCommand('pausegametime\r\n')
    elseif (loading ~= 1 and prevLoading == 1) and (menuStage ~= 3 or paused ~= 4) then
        sendCommand('unpausegametime\r\n')
    end

    if (menuStage == 3 and prevMenuStage == 2) and paused ~= 28 and paused ~= 3 then
        sendCommand('split\r\n')
    end

    prevStart = start
    prevLoading = loading
    prevMenuStage = menuStage
    prevPaused = paused
end
