process('AmidEvil-Win64-Shipping.exe')

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
local current = {start, loading, menuStage, paused}

function state()
    old.start = current.start
    old.loading = current.loading
    old.menuStage = current.menuStage
    old.paused = current.paused

    current.start = readAddress('byte', 0x2BAFFD0)
    current.loading = readAddress('byte', 0x2E76B0C)
    current.menuStage = readAddress('byte', 0x2F75F14)
    current.paused = readAddress('byte', 0x2B95A68)
end

function start()
    if mode == 2 and current.loading == 0 and old.loading == 1 then
        return true
    elseif current.start == 0 and old.start == 2 then
        return true
    end
end

function isLoading()
    return (current.loading == 1 or (current.menuStage == 3 and current.paused == 4))
end

function split()
    if (current.menuStage == 3 and old.menuStage == 2) and current.paused ~= 28 and current.paused ~= 3 then
        return true
    end
end