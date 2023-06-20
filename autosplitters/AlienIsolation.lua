process('AI.exe')

sendCommand('initgametime')

lasPrint('Alien: Isolation\n')

local final = false
local mission = nil

local prevFadeNum
local prevGameFlowState
local prevLevelManagerState

while true do
    local fadeState = readAddress("int", 0x15D24B4)
    local fadeNum = readAddress("float", 0x15D24B8)
    local gameFlowState = readAddress("byte", 0x12F0C88, 0x48, 0x8)
    local levelManagerState = readAddress("int", 0x12F0C88, 0x3C, 0x4C)
    local missionNum = readAddress("int", 0x17E4814, 0x4, 0x4E8)

    if fadeState == 2 and fadeNum > 0 or prevGameFlowState == 6 and gameFlowState == 4 then
        sendCommand('starttimer')
    end

    if prevLevelManagerState == 5 and levelManagerState == 7 or gameFlowState == 6 then
        sendCommand('pausegametime')
    elseif fadeState == 2 and prevFadeNum < 0.2 and fadeNum > 0.2 then
        sendCommand('unpausegametime')
    end

    if missionNum == 19 and fadeState == 2 and prevFadeNum < 0.5 and fadeNum > 0.5 then
        final = true
    end

    if mission == nil and fadeState == 2 and prevFadeNum < 0.5 and fadeNum > 0.5 then
        mission = missionNum
    end

    if mission ~= nil and missionNum > mission then
        mission = missionNum
        sendCommand('split')
    elseif final == true and fadeState == 1 and gameFlowState == 4 then
        final = false
        sendCommand('split')
    end

    prevFadeNum = fadeNum
    prevGameFlowState = gameFlowState
    prevLevelManagerState = levelManagerState
end