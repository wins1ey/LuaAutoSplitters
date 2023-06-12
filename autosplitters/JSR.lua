processID('jetsetradio.exe')

local prevLoading
local prevNewGame
local prevRankingScreen
local prevBossGraffiti

local baseAddress = 0x00400000

while true do
    local loading = readAddress(8, 0x58FAAC, baseAddress)
    local newGame = readAddress(8, 0x75A278, baseAddress)
    local rankingScreen = readAddress(8, 0x58FB1C, baseAddress)
    local bossGraffiti = readAddress(8, 0x55D2B8, baseAddress)

    if loading == 1 and prevLoading ~= 1 then
        sendCommand('pausegametime\r\n')
    elseif loading == 0 and prevLoading ~= 0 then
        sendCommand('unpausegametime\r\n')
    end
    prevLoading = loading

    if newGame ~= 1 and prevNewGame == 1 then
        sendCommand('starttimer\r\n')
    end
    prevNewGame = newGame

    if bossGraffiti == 7 and prevBossGraffiti ~= 7 then
        sendCommand('split\r\n')
    elseif rankingScreen == 1 and prevRankingScreen ~= 1 then
        sendCommand('split\r\n')
    end
    prevRankingScreen = rankingScreen
    prevBossGraffiti = bossGraffiti

end
