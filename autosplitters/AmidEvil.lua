process('AmidEvil-Win64-Shipping.exe')

sendCommand('initgametime')

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

local old = {start, loading, menuStage, paused}

while true do

    local current = {
        start = readAddress('byte', 0x2BAFFD0),
        loading = readAddress('byte', 0x2E76B0C),
        menuStage = readAddress('byte', 0x2F75F14),
        paused = readAddress('byte', 0x2B95A68)
    }

    if mode == 2 and (current.loading == 0 and old.loading == 1) then
        sendCommand('starttimer')
    elseif current.start == 0 and old.start == 2 then
        sendCommand('starttimer')
    end

    if (current.loading == 1 and old.loading == 0) or (current.menuStage == 3 and current.paused == 4) and (old.menuStage ~= 3 or old.paused ~= 4) then
        sendCommand('pausegametime')
    elseif (current.loading ~= 1 and old.loading == 1) and (current.menuStage ~= 3 or current.paused ~= 4) then
        sendCommand('unpausegametime')
    end

    if (current.menuStage == 3 and old.menuStage == 2) and current.paused ~= 28 and current.paused ~= 3 then
        sendCommand('split')
    end

    old = current
end