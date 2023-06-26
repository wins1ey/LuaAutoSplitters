process('jetsetradio.exe')

sendCommand('initgametime')

local old = {loading, newGame, rankingScreen, bossGraffiti}

while true do
    local current = {
        loading = readAddress('bool', 0x58FAAC),
        newGame = readAddress('bool', 0x75A278),
        rankingScreen = readAddress('bool', 0x58FB1C),
        bossGraffiti = readAddress('int', 0x55D2B8)
    }

    if current.loading and not old.loading then
        sendCommand('pausegametime')
    elseif not current.loading and old.loading then
        sendCommand('unpausegametime')
    end

    if old.newGame and not current.newGame then
        sendCommand('starttimer')
    end

    if current.bossGraffiti == 7 and old.bossGraffiti ~= 7 or not old.rankingScreen and current.rankingScreen then
        sendCommand('split')
    end

    old = current
end