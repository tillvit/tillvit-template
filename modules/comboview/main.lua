local p1judg = nil
local p1combo = nil
local p2judg = nil
local p2combo = nil

on('on', function()
    if P1 then
        P1:GetChild("Combo"):visible(false):addx(10000):sleep(9e9)
        P1:GetChild("Judgment"):visible(false):addx(10000):sleep(9e9)
    end
    if P2 then
        P2:GetChild("Combo"):visible(false):addx(10000):sleep(9e9)
        P2:GetChild("Judgment"):visible(false):addx(10000):sleep(9e9)
    end
end)

on('update', function()
    local pss = {STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1),
                 STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2)}
    -- show combo
    if pss[1]:GetCurrentCombo() > 3 or pss[1]:GetCurrentMissCombo() > 3 then
        p1combo:visible(true)
    else
        p1combo:visible(false)
    end
    -- show combo
    if pss[2]:GetCurrentCombo() > 3 or pss[2]:GetCurrentMissCombo() > 3 then
        p2combo:visible(true)
    else
        p2combo:visible(false)
    end
end)

add(Def.ActorProxy {
    OnCommand = function(self)
        if P1 then
            self:SetTarget(P1:GetChild('Judgment'));
        end
        self:x(sw / 4 - 10000);
        self:y(SCREEN_CENTER_Y);
        self:visible(true)
        self:z(3)
        p1judg = self
    end
})

add(Def.ActorProxy {
    OnCommand = function(self)
        if P2 then
            self:SetTarget(P2:GetChild('Judgment'));
        end
        self:x(sw / 4 * 3 - 10000);
        self:y(SCREEN_CENTER_Y);
        self:visible(true)
        self:z(3)
        p2judg = self
    end
})
add(Def.ActorProxy {
    OnCommand = function(self)
        if P1 then
            self:SetTarget(P1:GetChild('Combo'));
        end
        self:x(sw / 4 - 10000);
        self:y(SCREEN_CENTER_Y);
        self:visible(true)
        self:z(3)
        p1combo = self
    end
})

add(Def.ActorProxy {
    OnCommand = function(self)
        if P2 then
            self:SetTarget(P2:GetChild('Combo'));
        end
        self:x(sw / 4 * 3 - 10000);
        self:y(SCREEN_CENTER_Y);
        self:visible(true)
        self:z(3)
        p2combo = self
    end
})
