scx = SCREEN_CENTER_X
scy = SCREEN_CENTER_Y
sw = SCREEN_WIDTH
sh = SCREEN_HEIGHT
scm = SCREENMAN
poptions = {GAMESTATE:GetPlayerState(0):GetPlayerOptions('ModsLevel_Song'),
            GAMESTATE:GetPlayerState(1):GetPlayerOptions('ModsLevel_Song')}
ARROW_SIZE = sh / 480 * 64
P = {}

on('preon', function()
    topscreen = SCREENMAN:GetTopScreen()
    P1 = topscreen:GetChild('PlayerP1')
    P2 = topscreen:GetChild('PlayerP2')
    P[1] = topscreen:GetChild('PlayerP1')
    P[2] = topscreen:GetChild('PlayerP2')
    if P[1] == nil then
        for _, actor in pairs(topscreen:GetChild('')) do
            if tostring(actor):find("Player") then
                P1 = actor;
                P[1] = actor
            end
        end
    end
end)

