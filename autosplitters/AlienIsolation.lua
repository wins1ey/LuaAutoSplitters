process('AI.exe')

sendCommand('initgametime')

lasPrint('Alien: Isolation\n')

local vars = {final = false, mission = nil}
local old = {fadeState, fadeNum, gameFlowState, levelManagerState, missionNum}

while true do
    local current = {
        fadeState = readAddress('int', 0x15D24B4),
        fadeNum = readAddress('float', 0x15D24B8),
        gameFlowState = readAddress('byte', 0x12F0C88, 0x48, 0x8),
        levelManagerState = readAddress('int', 0x12F0C88, 0x3C, 0x4C),
        missionNum = readAddress('int', 0x17E4814, 0x4, 0x4E8)
    }

    if current.fadeState == 2 and current.fadeNum > 0 or old.gameFlowState == 6 and current.gameFlowState == 4 then
        sendCommand('starttimer')
    end

    if old.levelManagerState == 5 and current.levelManagerState == 7 or current.gameFlowState == 6 then
        sendCommand('pausegametime')
    elseif current.fadeState == 2 and old.fadeNum < 0.2 and current.fadeNum > 0.2 then
        sendCommand('unpausegametime')
    end

    if current.missionNum == 19 and current.fadeState == 2 and old.fadeNum < 0.5 and current.fadeNum > 0.5 then
        vars.final = true
    end

    if vars.mission == nil and current.fadeState == 2 and old.fadeNum < 0.5 and current.fadeNum > 0.5 then
        vars.mission = current.missionNum
    end

    if vars.mission ~= nil and current.missionNum > vars.mission then
        vars.mission = current.missionNum
        sendCommand('split')
    elseif vars.final == true and current.fadeState == 1 and current.gameFlowState == 4 then
        vars.final = false
        sendCommand('split')
    end

    old = current
end