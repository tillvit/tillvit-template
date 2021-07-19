dependency ({"common_aliases"},"modcore")

if Tweens == nil then
    msg("The Tweens namespace doesn't exist! (requires build 4.9.7+)")
end

local currently_active_mods = {{},{}}
local curmod = 1;
local mods = {}
local curaction = 1
local actions = {}
local perframes = {}

local eases = {
    linear=Tweens.easeLinear,
    inquad=Tweens.easeInQuad,
    outquad=Tweens.easeOutQuad,
    inoutquad=Tweens.easeInOutQuad,
    outinquad=function(t,b,c,d)
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d
            return -c * t * (t - 2) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            return c * math.pow(t, 2) + b
        end
    end,
    incubic=Tweens.easeInCubic,
    outcubic=Tweens.easeOutCubic,
    inoutcubic=Tweens.easeInOutCubic,
    outincubic=function(t,b,c,d)
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d - 1
            return c * (math.pow(t, 3) + 1) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            return c * math.pow(t, 3) + b
        end
    end,
    inquart=Tweens.easeInQuart,
    outquart=Tweens.easeOutQuart,
    inoutquart=Tweens.easeInOutQuart,
    outinquart=function(t,b,c,d)
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d - 1
            return -c * (math.pow(t, 4) - 1) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            return c * math.pow(t, 4) + b
        end
    end,
    inquint=Tweens.easeInQuint,
    outquint=Tweens.easeOutQuint,
    inoutquint=Tweens.easeInOutQuint,
    outinquint=function(t,b,c,d)
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d - 1
            return c * (math.pow(t, 5) + 1) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            return c * math.pow(t, 5) + b
        end
    end,
    insine=Tweens.easeInSine,
    outsine=Tweens.easeOutSine,
    inoutsine=Tweens.easeInOutSine,
    outinsine=function(t,b,c,d)
        if t < d / 2 then
            t = t * 2
            c = c / 2
            return c * math.sin(t / d * (math.pi / 2)) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            return -c * math.cos(t / d * (math.pi / 2)) + c + b
        end
    end,
    inexpo=Tweens.easeInExpo,
    outexpo=Tweens.easeOutExpo,
    inoutexpo=Tweens.easeInOutExpo,
    outinexpo=function(t,b,c,d)
        if t < d / 2 then
            t = t * 2
            c = c / 2
            if t == d then
                return b + c
            else
                return c * 1.001 * (-math.pow(2, -10 * t / d) + 1) + b
            end
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            if t == 0 then
                return b
            else
                return c * math.pow(2, 10 * (t / d - 1)) + b - c * 0.001
            end
        end
    end,
    incirc=Tweens.easeInCirc,
    outcirc=Tweens.easeOutCirc,
    inoutcirc=Tweens.easeInOutCirc,
    outincirc=function(t,b,c,d)
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d - 1
            return (c * math.sqrt(1 - math.pow(t, 2)) + b)
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            return (-c * (math.sqrt(1 - math.pow(t, 2)) - 1) + b)
        end
    end,
    inbounce=function(t, b, c, d)
        t = d - t
        t = t / d
        if t < 1 / 2.75 then
            return c - (c * (7.5625 * t * t)) + b
        elseif t < 2 / 2.75 then
            t = t - (1.5 / 2.75)
            return c - (c * (7.5625 * t * t + 0.75)) + b
        elseif t < 2.5 / 2.75 then
            t = t - (2.25 / 2.75)
            return c - (c * (7.5625 * t * t + 0.9375)) + b
        else
            t = t - (2.625 / 2.75)
            return  c - (c * (7.5625 * t * t + 0.984375)) + b
        end
    end,
    outbounce=function(t, b, c, d)
        t = t / d
        if t < 1 / 2.75 then
            return c * (7.5625 * t * t) + b
        elseif t < 2 / 2.75 then
            t = t - (1.5 / 2.75)
            return c * (7.5625 * t * t + 0.75) + b
        elseif t < 2.5 / 2.75 then
            t = t - (2.25 / 2.75)
            return c * (7.5625 * t * t + 0.9375) + b
        else
            t = t - (2.625 / 2.75)
            return c * (7.5625 * t * t + 0.984375) + b
        end
    end,
    inoutbounce=function(t, b, c, d)
        if t < d / 2 then
            t = t * 2
            t = d - t
            t = t / d
            if t < 1 / 2.75 then
                return 0.5 * (c - (c * (7.5625 * t * t))) + b
            elseif t < 2 / 2.75 then
                t = t - (1.5 / 2.75)
                return  0.5 * (c - (c * (7.5625 * t * t + 0.75))) + b
            elseif t < 2.5 / 2.75 then
                t = t - (2.25 / 2.75)
                return  0.5 * (c - (c * (7.5625 * t * t + 0.9375))) + b
            else
                t = t - (2.625 / 2.75)
                return  0.5 * (c - (c * (7.5625 * t * t + 0.984375))) + b
            end
        else
            t = t * 2 - d
            t = t / d
            if t < 1 / 2.75 then
                return (c * (7.5625 * t * t)) * 0.5 + c * .5 + b
            elseif t < 2 / 2.75 then
                t = t - (1.5 / 2.75)
                return (c * (7.5625 * t * t + 0.75)) * 0.5 + c * .5 + b
            elseif t < 2.5 / 2.75 then
                t = t - (2.25 / 2.75)
                return (c * (7.5625 * t * t + 0.9375)) * 0.5 + c * .5 + b
            else
                t = t - (2.625 / 2.75)
                return (c * (7.5625 * t * t + 0.984375)) * 0.5 + c * .5 + b
            end
        end
    end,
    outinbounce=function(t, b, c, d)
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d
            if t < 1 / 2.75 then
                return c * (7.5625 * t * t) + b
            elseif t < 2 / 2.75 then
                t = t - (1.5 / 2.75)
                return c * (7.5625 * t * t + 0.75) + b
            elseif t < 2.5 / 2.75 then
                t = t - (2.25 / 2.75)
                return c * (7.5625 * t * t + 0.9375) + b
            else
                t = t - (2.625 / 2.75)
                return c * (7.5625 * t * t + 0.984375) + b
            end
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = d - t
            t = t / d
            if t < 1 / 2.75 then
                return c - (c * (7.5625 * t * t)) + b
            elseif t < 2 / 2.75 then
                t = t - (1.5 / 2.75)
                return c - (c * (7.5625 * t * t + 0.75)) + b
            elseif t < 2.5 / 2.75 then
                t = t - (2.25 / 2.75)
                return c - (c * (7.5625 * t * t + 0.9375)) + b
            else
                t = t - (2.625 / 2.75)
                return c - (c * (7.5625 * t * t + 0.984375)) + b
            end
        end
    end,
}

local function applymod(str, pn)
    poptions[pn]:FromString(str)
end

local function applyplayeractormod(value, mod, actor)
    if actor ~= nil then
        if mod == "rotationx" then
            actor:rotationx(value)
        end
        if mod == "rotationy" then
            actor:rotationy(value)
        end
        if mod == "rotationz" then
            actor:rotationz(value)
        end
        if mod == "x" then
            actor:x(value)
        end
        if mod == "y" then
            actor:y(value)
        end
        if mod == "zoom" then
            actor:zoomz(value)
        end
        if mod == "zoomx" then
            actor:zoomx(value)
        end
        if mod == "zoomy" then
            actor:zoomy(value)
        end
        if mod == "zoomz" then
            actor:zoomz(value)
        end
    end
end

local function getModString(mod, percentage, player) 
    local perc = math.round(percentage*1000)/1000
    if mod == "XMod" or mod == "CMod" or mod == "MMod" then
        -- ew xmod cmod mmod different format ew
        if mod == "XMod" then
            return '*10000 ' .. perc / 100 .. "x"
        else
            return '*10000 ' .. string.sub(mod, 1, 1) .. perc
        end
    else
        applyplayeractormod(perc, mod, tillvit["P"..player])
        if (mod ~= "x") then
            return '*10000 ' .. perc .. ' ' .. mod
        end
    end
    return nil
end

local function execute_mods()
    for plr=1,2 do
        local mods_this_frame = {}
        for key, mod in pairs(currently_active_mods[plr]) do
            local t = beat - mod.startbeat
            local b = mod["currentvaluep"..plr]
            local c = mod.percentage - mod["currentvaluep"..plr]
            local d = mod.easelength
            if beat > mod.endeasebeat then
                -- activate mod if time passed
                local string = getModString(mod.mod, mod.percentage, plr)
                if string then table.insert(mods_this_frame, string) end
                currently_active_mods[plr][mod.mod] = nil
            else
                local ease = eases[string.lower(mod.ease)]
                if not ease then
                    ease = eases.linear
                    msg("Couldn't find ease " .. mod.ease)
                end
                local string = getModString(mod.mod, ease(t, b, c, d), plr)
                if string then table.insert(mods_this_frame, string) end
            end
        end
        -- concat mods on this frame and activate them
        if #mods_this_frame > 0 then
            local total_mod_str = ""
            for i, ms in ipairs(mods_this_frame) do
                if #total_mod_str > 0 then
                    total_mod_str = total_mod_str .. ", "
                end
                total_mod_str = total_mod_str .. ms
            end
            applymod(total_mod_str, plr)
        end
    end
end

local function getCurrentModValue(mod, plr) 
    --find normal mod
    for i, c in ipairs(GAMESTATE:GetPlayerState(plr-1):GetPlayerOptionsArray("ModsLevel_Song")) do
        if (not (string.find(string.lower(c), string.lower(mod)) == nil)) then
            if (string.match(string.lower(c), string.lower(mod) .. ".") == nil) then
                if not (string.match(string.lower(c), "(%-?%d+)%%") == nil) then
                    return string.match(string.lower(c), "(%-?%d+)%%")
                else
                    return 100
                end
            end
        end
    end
    
    --find player actor mod
    local playeractor = tillvit["P"..plr]
    local ActorTransforms = {'RotationX', 'RotationY', 'RotationZ', 'X', 'Y', 'Zoom', 'ZoomX', 'ZoomY', 'ZoomZ'}
    for i, value in ipairs(ActorTransforms) do
        if string.lower(mod) == string.lower(value) then
            if (playeractor ~= nil) then
                return playeractor['Get' .. value](playeractor)
            else
                return 0
            end
        end
    end

    --xmod cmod mmod exception
    if mod == "XMod" then
        if poptions[plr]:XMod() == nil then
            return poptions[plr]:CMod() / 100
        else
            return poptions[plr]:XMod() * 100
        end
    elseif mod == "CMod" then
        --fix conversion
        if poptions[plr]:CMod() == nil then
            return poptions[plr]:XMod() * 100
        else
            return poptions[plr]:CMod()
        end
    elseif mod == "MMod" then
        -- can't be bothered with mmod who uses it
        if poptions[plr]:MMod() == nil then
            return 100
        else
            return poptions[plr]:MMod() * 100
        end
    end
    return 0
end

function mod(a)
    if #a < 3 then
        msg("Couldn't register mod! Too few arguments.")
        return
    end
    if type(a[1]) ~= "number" then
        msg("Couldn't register mod! Beat argument is not a number!")
        return
    end
    if type(a[2]) ~= "number" then
        msg("Couldn't register mod! Player argument is not a number!")
        return
    end
    if type(a[3]) ~= "table" then
        msg("Couldn't register mod! Third argument is not a table!")
        return
    end
    table.insert(mods, a)
end

function action(a)
    if #a < 2 then
        msg("Couldn't register action! Too few arguments.")
        return
    end
    if type(a[1]) ~= "number" then
        msg("Couldn't register action! Beat argument is not a number!")
        return
    end
    if type(a[2]) ~= "function" then
        msg("Couldn't register action! Second argument is not a function!")
        return
    end
    table.insert(actions, a)
end

function perframe(t)
    if #t < 3 then
        msg("Couldn't register perframe! Too few arguments.")
        return
    end
    if type(t[1]) ~= "number" or type(t[2]) ~= "number" then
        msg("Couldn't register perframe! Beat arguments are not numbers!")
        return
    end
    if type(t[3]) ~= "function" then
        msg("Couldn't register perframe! Third argument is not a function!")
        return
    end
    table.insert(perframes, t)
end

local function modtable_compare(a, b)
    return a[1] < b[1]
end

on('init', function()
    if table.getn(mods) > 1 then
        table.sort(mods, modtable_compare)
    end

    if table.getn(actions) > 1 then
        table.sort(actions, modtable_compare)
    end
end)

on('update', function()
    -- insert mods into currently_active_mods
    while curmod <= #mods and beat >= mods[curmod][1] do
        for i, mod in ipairs(mods[curmod][3]) do
            local mod_to_insert = {}
            mod_to_insert.easelength = mod[1]
            mod_to_insert.percentage = mod[2]
            mod_to_insert.mod = mod[3]
            mod_to_insert.ease = mod[4]
            mod_to_insert.endeasebeat = mods[curmod][1] + mod[1]
            mod_to_insert.currentvaluep1 = getCurrentModValue(mod[3],1)
            mod_to_insert.currentvaluep2 = getCurrentModValue(mod[3],2)
            mod_to_insert.startbeat = mods[curmod][1]
            
            if mods[curmod][2] == 1 then
                currently_active_mods[1][mod[3]] = mod_to_insert
            elseif mods[curmod][2] == 2 then
                currently_active_mods[2][mod[3]] = mod_to_insert
            else
                currently_active_mods[1][mod[3]] = mod_to_insert
                currently_active_mods[2][mod[3]] = mod_to_insert
            end
        end
        curmod = curmod + 1
    end
    execute_mods()

    while curaction <= #actions and beat >= actions[curaction][1] do
        if actions[curaction][3] and beat >= actions[curaction][1] + 5 then
            curaction = curaction + 1;
        else
            actions[curaction][2]()
            curaction = curaction + 1;
        end
    end
end)

function hideObjects()
    if P1 then
        P1:GetChild("Combo"):visible(false):addx(10000):sleep(9e9)
        P1:GetChild("Judgment"):visible(false):addx(10000):sleep(9e9)
    end
    if P2 then
        P2:GetChild("Combo"):visible(false):addx(10000):sleep(9e9)
        P2:GetChild("Judgment"):visible(false):addx(10000):sleep(9e9)
    end

    local hide = {'LifeP1', 'ScoreP1', 'LifeP2', 'ScoreP2', 'Overlay', 'Underlay', 'StageDisplay', 'SongTitle',
                  'SongMeterDisplayP1', 'SongMeterDisplayP2', 'StepsDisplayP1', 'StepsDisplayP2'}
    for i in pairs(hide) do
        if topscreen:GetChild(hide[i]) then
            topscreen:GetChild(hide[i]):visible(false)
        end
    end
end

local modlist1 = nil
local modlist2 = nil

add(Def.BitmapText {
    Font = "Common normal",
    Text = "",
    InitCommand = function(self)
        self:visible(false):zoom(0.5):diffuse(1, 1, 1, 0.5)
        modlist1 = self
    end
})

add(Def.BitmapText {
    Font = "Common normal",
    Text = "",
    InitCommand = function(self)
        self:visible(false):zoom(0.5):diffuse(1, 1, 1, 0.5)
        modlist2 = self
    end
})

on('update', function()
    modlist1:settext(table.concat(GAMESTATE:GetPlayerState(0):GetPlayerOptionsArray('ModsLevel_Song'), "\n"))
    modlist2:settext(table.concat(GAMESTATE:GetPlayerState(1):GetPlayerOptionsArray('ModsLevel_Song'), "\n"))
    modlist1:Center():addx(-150)
    modlist2:Center():addx(150)

    for i, perframe in ipairs(perframes) do
        if (beat > perframe[1] and beat < perframe[2]) then
            perframe[3]()
        end
    end
end)

function toggleModsListVisible(b)
    modlist1:visible(b)
    modlist2:visible(b)
end
