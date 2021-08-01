p1judg = nil
p1combo = nil
p2judg = nil
p2combo = nil
combovisible = true

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
    if (combovisible) then
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
    else
        p1combo:visible(false)
        p2combo:visible(false)
        p1judg:visible(false)
        p2judg:visible(false)
    end
end)

add(Def.ActorProxy {
    InitCommand=function(self)
        p1judg = self
    end,
    OnCommand = function(self)
        if P1 then
            self:SetTarget(P1:GetChild('Judgment'));
        end
        self:x(sw / 4 - 10000);
        self:y(SCREEN_CENTER_Y);
        self:visible(true)
        self:z(3)
    end
})

add(Def.ActorProxy {
    InitCommand=function(self)
        p2judg = self
    end,
    OnCommand = function(self)
        if P2 then
            self:SetTarget(P2:GetChild('Judgment'));
        end
        self:x(sw / 4 * 3 - 10000);
        self:y(SCREEN_CENTER_Y);
        self:visible(true)
        self:z(3)
    end
})
add(Def.ActorProxy {
    InitCommand=function(self)
        p1combo = self
    end,
    OnCommand = function(self)
        if P1 then
            self:SetTarget(P1:GetChild('Combo'));
        end
        self:x(sw / 4 - 10000);
        self:y(SCREEN_CENTER_Y);
        self:visible(true)
        self:z(3)
    end
})

add(Def.ActorProxy {
    InitCommand=function(self)
        p2combo = self
    end,
    OnCommand = function(self)
        if P2 then
            self:SetTarget(P2:GetChild('Combo'));
        end
        self:x(sw / 4 * 3 - 10000);
        self:y(SCREEN_CENTER_Y);
        self:visible(true)
        self:z(3)
    end
})
