process('jetsetradio.exe')

sendCommand('initgametime')

local prevLoading
local prevNewGame
local prevRankingScreen
local prevBossGraffiti

while true do
    local loading = readAddress('bool', 0x58FAAC)
    local newGame = readAddress('bool', 0x75A278)
    local rankingScreen = readAddress('bool', 0x58FB1C)
    local bossGraffiti = readAddress('int', 0x55D2B8)

    if loading and not prevLoading then
        sendCommand('pausegametime')
    elseif not loading and prevLoading then
        sendCommand('unpausegametime')
    end

    if prevNewGame and not newGame then
        sendCommand('starttimer')
    end

    if bossGraffiti == 7 and prevBossGraffiti ~= 7 or not prevRankingScreen and rankingScreen then
        sendCommand('split')
    end

    prevNewGame = newGame
    prevLoading = loading
    prevRankingScreen = rankingScreen
    prevBossGraffiti = bossGraffiti
end