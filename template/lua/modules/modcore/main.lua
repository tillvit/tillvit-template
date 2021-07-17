local currently_active_mods_1 = {};
local currently_active_mods_2 = {};
local curmod = 1;
local mods = {}
local curaction = 1
local actions = {}
local perframes = {}
-- ----------- EASING FUNCTIONS -----------

-- -- Adapted from
-- -- Tweener's easing functions (Penner's Easing Equations)
-- -- and  w (jstweener javascript version)
-- --

-- --[[
-- Disclaimer for Robert Penner's Easing Equations license:

-- TERMS OF USE - EASING EQUATIONS

-- Open source under the BSD License.

-- Copyright © 501 Robert Penner
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

-- * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
-- * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
-- * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- ]]

-- -- For all easing functions:
-- -- t = elapsed time
-- -- b = begin
-- -- c = change == ending - beginning
-- -- d = duration (total time)

local function calculateEase(t, b, c, d, ease)
    local mod_value = 0
    if ease == "linear" then
        mod_value = c * t / d + b
    elseif ease == "inQuad" then
        t = t / d
        mod_value = c * math.pow(t, 2) + b
    elseif ease == "outQuad" then
        t = t / d
        mod_value = -c * t * (t - 2) + b
    elseif ease == "inOutQuad" then
        t = t / d * 2
        if t < 1 then
            mod_value = c / 2 * math.pow(t, 2) + b
        else
            mod_value = -c / 2 * ((t - 1) * (t - 3) - 1) + b
        end
    elseif ease == "outInQuad" then
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d
            mod_value = -c * t * (t - 2) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            mod_value = c * math.pow(t, 2) + b
        end
    elseif ease == "inCubic" then
        t = t / d
        mod_value = c * math.pow(t, 3) + b
    elseif ease == "outCubic" then
        t = t / d - 1
        mod_value = c * (math.pow(t, 3) + 1) + b
    elseif ease == "inOutCubic" then
        t = t / d * 2
        if t < 1 then
            mod_value = c / 2 * t * t * t + b
        else
            t = t - 2
            mod_value = c / 2 * (t * t * t + 2) + b
        end
    elseif ease == "outInCubic" then
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d - 1
            mod_value = c * (math.pow(t, 3) + 1) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            mod_value = c * math.pow(t, 3) + b
        end
    elseif ease == "inQuart" then
        t = t / d
        mod_value = c * math.pow(t, 4) + b
    elseif ease == "outQuart" then
        t = t / d - 1
        mod_value = -c * (math.pow(t, 4) - 1) + b
    elseif ease == "inOutQuart" then
        t = t / d * 2
        if t < 1 then
            mod_value = c / 2 * math.pow(t, 4) + b
        else
            t = t - 2
            mod_value = -c / 2 * (math.pow(t, 4) - 2) + b
        end
    elseif ease == "outInQuart" then
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d - 1
            mod_value = -c * (math.pow(t, 4) - 1) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            mod_value = c * math.pow(t, 4) + b
        end
    elseif ease == "inQuint" then
        t = t / d
        mod_value = c * math.pow(t, 5) + b
    elseif ease == "outQuint" then
        t = t / d - 1
        mod_value = c * (math.pow(t, 5) + 1) + b
    elseif ease == "inOutQuint" then
        t = t / d * 2
        if t < 1 then
            mod_value = c / 2 * math.pow(t, 5) + b
        else
            t = t - 2
            mod_value = c / 2 * (math.pow(t, 5) + 2) + b
        end
    elseif ease == "outInQuint" then
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d - 1
            mod_value = c * (math.pow(t, 5) + 1) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            mod_value = c * math.pow(t, 5) + b
        end
    elseif ease == "inSine" then
        mod_value = -c * math.cos(t / d * (math.pi / 2)) + c + b
    elseif ease == "outSine" then
        mod_value = c * math.sin(t / d * (math.pi / 2)) + b
    elseif ease == "inOutSine" then
        mod_value = -c / 2 * (math.cos(math.pi * t / d) - 1) + b
    elseif ease == "flipSine" then
        c = 100
        mod_value = (-1 * math.abs(-c * math.cos(t * math.pi / d)) + c)
    elseif ease == "outInSine" then
        if t < d / 2 then
            t = t * 2
            c = c / 2
            mod_value = c * math.sin(t / d * (math.pi / 2)) + b
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            mod_value = -c * math.cos(t / d * (math.pi / 2)) + c + b
        end
    elseif ease == "inExpo" then
        if t == 0 then
            mod_value = b
        else
            mod_value = c * math.pow(2, 10 * (t / d - 1)) + b - c * 0.001
        end
    elseif ease == "outExpo" then
        if t == d then
            mod_value = b + c
        else
            mod_value = c * 1.001 * (-math.pow(2, -10 * t / d) + 1) + b
        end
    elseif ease == "inOutExpo" then
        if t == 0 then
            mod_value = b
        end
        if t == d then
            mod_value = b + c
        end
        t = t / d * 2
        if t < 1 then
            mod_value = c / 2 * math.pow(2, 10 * (t - 1)) + b - c * 0.0005
        else
            t = t - 1
            mod_value = c / 2 * 1.0005 * (-math.pow(2, -10 * t) + 2) + b
        end
    elseif ease == "outInExpo" then
        if t < d / 2 then
            t = t * 2
            c = c / 2
            if t == d then
                mod_value = b + c
            else
                mod_value = c * 1.001 * (-math.pow(2, -10 * t / d) + 1) + b
            end
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            if t == 0 then
                mod_value = b
            else
                mod_value = c * math.pow(2, 10 * (t / d - 1)) + b - c * 0.001
            end
        end
    elseif ease == "inCirc" then
        t = t / d
        mod_value = (-c * (math.sqrt(1 - math.pow(t, 2)) - 1) + b)
    elseif ease == "outCirc" then
        t = t / d - 1
        mod_value = (c * math.sqrt(1 - math.pow(t, 2)) + b)
    elseif ease == "inOutCirc" then
        t = t / d * 2
        if t < 1 then
            mod_value = -c / 2 * (math.sqrt(1 - t * t) - 1) + b
        else
            t = t - 2
            mod_value = c / 2 * (math.sqrt(1 - t * t) + 1) + b
        end
    elseif ease == "outInCirc" then
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d - 1
            mod_value = (c * math.sqrt(1 - math.pow(t, 2)) + b)
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = t / d
            mod_value = (-c * (math.sqrt(1 - math.pow(t, 2)) - 1) + b)
        end
    elseif ease == "outBounce" then
        t = t / d
        if t < 1 / 2.75 then
            mod_value = c * (7.5625 * t * t) + b
        elseif t < 2 / 2.75 then
            t = t - (1.5 / 2.75)
            mod_value = c * (7.5625 * t * t + 0.75) + b
        elseif t < 2.5 / 2.75 then
            t = t - (2.25 / 2.75)
            mod_value = c * (7.5625 * t * t + 0.9375) + b
        else
            t = t - (2.625 / 2.75)
            mod_value = c * (7.5625 * t * t + 0.984375) + b
        end
    elseif ease == "inBounce" then
        t = d - t
        t = t / d
        if t < 1 / 2.75 then
            mod_value = c - (c * (7.5625 * t * t)) + b
        elseif t < 2 / 2.75 then
            t = t - (1.5 / 2.75)
            mod_value = c - (c * (7.5625 * t * t + 0.75)) + b
        elseif t < 2.5 / 2.75 then
            t = t - (2.25 / 2.75)
            mod_value = c - (c * (7.5625 * t * t + 0.9375)) + b
        else
            t = t - (2.625 / 2.75)
            mod_value = c - (c * (7.5625 * t * t + 0.984375)) + b
        end
    elseif ease == "inOutBounce" then
        if t < d / 2 then
            t = t * 2
            t = d - t
            t = t / d
            if t < 1 / 2.75 then
                mod_value = 0.5 * (c - (c * (7.5625 * t * t))) + b
            elseif t < 2 / 2.75 then
                t = t - (1.5 / 2.75)
                mod_value = 0.5 * (c - (c * (7.5625 * t * t + 0.75))) + b
            elseif t < 2.5 / 2.75 then
                t = t - (2.25 / 2.75)
                mod_value = 0.5 * (c - (c * (7.5625 * t * t + 0.9375))) + b
            else
                t = t - (2.625 / 2.75)
                mod_value = 0.5 * (c - (c * (7.5625 * t * t + 0.984375))) + b
            end
        else
            t = t * 2 - d
            t = t / d
            if t < 1 / 2.75 then
                mod_value = (c * (7.5625 * t * t)) * 0.5 + c * .5 + b
            elseif t < 2 / 2.75 then
                t = t - (1.5 / 2.75)
                mod_value = (c * (7.5625 * t * t + 0.75)) * 0.5 + c * .5 + b
            elseif t < 2.5 / 2.75 then
                t = t - (2.25 / 2.75)
                mod_value = (c * (7.5625 * t * t + 0.9375)) * 0.5 + c * .5 + b
            else
                t = t - (2.625 / 2.75)
                mod_value = (c * (7.5625 * t * t + 0.984375)) * 0.5 + c * .5 + b
            end
        end
    elseif ease == "outInBounce" then
        if t < d / 2 then
            t = t * 2
            c = c / 2
            t = t / d
            if t < 1 / 2.75 then
                mod_value = c * (7.5625 * t * t) + b
            elseif t < 2 / 2.75 then
                t = t - (1.5 / 2.75)
                mod_value = c * (7.5625 * t * t + 0.75) + b
            elseif t < 2.5 / 2.75 then
                t = t - (2.25 / 2.75)
                mod_value = c * (7.5625 * t * t + 0.9375) + b
            else
                t = t - (2.625 / 2.75)
                mod_value = c * (7.5625 * t * t + 0.984375) + b
            end
        else
            t = (t * 2) - d
            b = b + c / 2
            c = c / 2
            t = d - t
            t = t / d
            if t < 1 / 2.75 then
                mod_value = c - (c * (7.5625 * t * t)) + b
            elseif t < 2 / 2.75 then
                t = t - (1.5 / 2.75)
                mod_value = c - (c * (7.5625 * t * t + 0.75)) + b
            elseif t < 2.5 / 2.75 then
                t = t - (2.25 / 2.75)
                mod_value = c - (c * (7.5625 * t * t + 0.9375)) + b
            else
                t = t - (2.625 / 2.75)
                mod_value = c - (c * (7.5625 * t * t + 0.984375)) + b
            end
        end
    else
        mod_value = c * t / d + b
    end
    return mod_value
end

local function mod_internal(str, pn)
    local ps = GAMESTATE:GetPlayerState(pn)
    local pmods = ps:GetPlayerOptionsString('ModsLevel_Song')
    ps:SetPlayerOptions('ModsLevel_Song', pmods .. ', ' .. str)
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
local function execute_mods()
    local mods_this_frame = {}
    local p1toremove = {}
    for i, mod in ipairs(currently_active_mods_1) do
        local cbeat = beat
        -- calculate easing variables
        local t = beat - (mod[5] - mod[1])
        local b = mod[6]
        local c = mod[2] - mod[6]
        local d = mod[1]
        if (mod[5] - mod[1]) > beat then

        else
            if beat > mod[5] or t < 0 then
                -- activate mod if time passed
                if mod[3] == "XMod" or mod[3] == "CMod" or mod[3] == "MMod" then
                    -- ew xmod cmod mmod different format ew
                    if mod[3] == "XMod" then
                        table.insert(mods_this_frame, '*999999 ' .. mod[2] / 100 .. string.sub(mod[3], 1, 1))
                    else
                        table.insert(mods_this_frame, '*999999 ' .. string.sub(mod[3], 1, 1) .. mod[2])
                    end
                else
                    applyplayeractormod(mod[2], mod[3], P1)
                    if (mod[3] ~= "x") then
                        table.insert(mods_this_frame, '*999999 ' .. mod[2] .. ' ' .. mod[3])
                    end
                end
                table.insert(p1toremove, i)
            else
                -- activate mod with eases since the mod is still running
                local mod_value = calculateEase(t, b, c, d, mod[4])
                if mod[3] == "XMod" or mod[3] == "CMod" or mod[3] == "MMod" then
                    if mod[3] == "XMod" then
                        table.insert(mods_this_frame, '*999999 ' .. mod_value / 100 .. string.sub(mod[3], 1, 1))
                    else
                        table.insert(mods_this_frame, '*999999 ' .. string.sub(mod[3], 1, 1) .. mod_value)
                    end
                else
                    applyplayeractormod(mod_value, mod[3], P1)
                    if mod[3] ~= "x" then
                        table.insert(mods_this_frame, '*999999 ' .. mod_value .. ' ' .. mod[3])
                    end
                end
            end
        end
    end
    -- get rid of currently active mods
    if #p1toremove > 0 then
        table.sort(p1toremove, function(a, b)
            return a > b
        end)
        for i, remove in ipairs(p1toremove) do
            table.remove(currently_active_mods_1, remove)
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
        mod_internal(total_mod_str, 'PlayerNumber_P1')
    end

    -- now do the same thing but player 2
    mods_this_frame = {}
    local p2toremove = {}
    for i, mod in ipairs(currently_active_mods_2) do
        if beat > mod[5] then
            if mod[3] == "XMod" or mod[3] == "CMod" or mod[3] == "MMod" then
                if mod[3] == "XMod" then
                    table.insert(mods_this_frame, '*999999 ' .. mod[2] / 100 .. string.sub(mod[3], 1, 1))
                else
                    table.insert(mods_this_frame, '*999999 ' .. string.sub(mod[3], 1, 1) .. mod[2])
                end
            else
                applyplayeractormod(mod[2], mod[3], P2)
                if mod[3] ~= "x" then
                    table.insert(mods_this_frame, '*999999 ' .. mod[2] .. ' ' .. mod[3])
                end
            end
            table.insert(p2toremove, i)
        else
            local t = beat - (mod[5] - mod[1])
            local b = mod[7]
            local c = mod[2] - mod[7]
            local d = mod[1]
            local mod_value = calculateEase(t, b, c, d, mod[4])
            if mod[3] == "XMod" or mod[3] == "CMod" or mod[3] == "MMod" then
                if mod[3] == "XMod" then
                    table.insert(mods_this_frame, '*999999 ' .. mod_value / 100 .. string.sub(mod[3], 1, 1))
                else
                    table.insert(mods_this_frame, '*999999 ' .. string.sub(mod[3], 1, 1) .. mod_value)
                end
            else
                applyplayeractormod(mod_value, mod[3], P2)
                if mod[3] ~= "x" then
                    table.insert(mods_this_frame, '*999999 ' .. mod_value .. ' ' .. mod[3])
                end
            end
        end
    end
    if #p2toremove > 0 then
        table.sort(p2toremove, function(a, b)
            return a > b
        end)
        for i, remove in ipairs(p2toremove) do
            table.remove(currently_active_mods_2, remove)
        end
    end
    if #mods_this_frame > 0 then
        local total_mod_str = ""
        for i, ms in ipairs(mods_this_frame) do
            if #total_mod_str > 0 then
                total_mod_str = total_mod_str .. ", "
            end
            total_mod_str = total_mod_str .. ms
        end
        mod_internal(total_mod_str, 'PlayerNumber_P2')
    end
end

function mod(a)
    if #a < 3 then
        msg("Couldn't register mod! Too few arguments.")
        return
    end
    if type(t[1]) ~= "number" then
        msg("Couldn't register mod! Beat argument is not a number!")
        return
    end
    if type(t[2]) ~= "number" then
        msg("Couldn't register mod! Player argument is not a number!")
        return
    end
    if type(t[3]) ~= "table" then
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
    if type(t[1]) ~= "number" then
        msg("Couldn't register action! Beat argument is not a number!")
        return
    end
    if type(t[2]) ~= "function" then
        msg("Couldn't register actio! Second argument is not a function!")
        return
    end
    table.insert(actions, a)
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
            local mod_to_insert = mod
            table.insert(mod_to_insert, mods[curmod][1] + mod[1])

            local poptionsp1 = GAMESTATE:GetPlayerState(0):GetPlayerOptions('ModsLevel_Song')
            local poptionsp2 = GAMESTATE:GetPlayerState(1):GetPlayerOptions('ModsLevel_Song')
            local p1value = 0
            for i, c in ipairs(GAMESTATE:GetPlayerState(0):GetPlayerOptionsArray("ModsLevel_Song")) do
                if (not (string.find(string.lower(c), string.lower(mod[3])) == nil)) then
                    if (string.match(string.lower(c), string.lower(mod[3]) .. ".") == nil) then
                        if not (string.match(string.lower(c), "(%-?%d+)%%") == nil) then
                            p1value = string.match(string.lower(c), "(%-?%d+)%%")
                        else
                            p1value = 100
                        end
                    end
                end
            end
            local p2value = 0
            for i, c in ipairs(GAMESTATE:GetPlayerState(1):GetPlayerOptionsArray("ModsLevel_Song")) do
                if (not (string.find(string.lower(c), string.lower(mod[3])) == nil)) then
                    if (string.match(string.lower(c), string.lower(mod[3]) .. ".") == nil) then
                        if not (string.match(string.lower(c), "(%-?%d+)%%") == nil) then
                            p2value = string.match(string.lower(c), "(%-?%d+)%%")
                        else
                            p2value = 100
                        end
                    end
                end
            end

            check = {'RotationX', 'RotationY', 'RotationZ', 'X', 'Y', 'Zoom', 'ZoomX', 'ZoomY', 'ZoomZ'}
            found = false;
            for i, value in ipairs(check) do
                if string.lower(mod[3]) == string.lower(value) then
                    found = true
                    if (P1 ~= nil) then
                        table.insert(mod_to_insert, P1['Get' .. value](P1))
                    end
                    if (P2 ~= nil) then
                        table.insert(mod_to_insert, P2['Get' .. value](P2))
                    end
                    break
                end
            end

            if mod[3] == "XMod" then
                if poptionsp1:XMod() == nil then
                    table.insert(mod_to_insert, poptionsp1:CMod() / 100)
                else
                    table.insert(mod_to_insert, poptionsp1:XMod() * 100)
                end
                if poptionsp2:XMod() == nil then
                    table.insert(mod_to_insert, poptionsp2:CMod() / 100)
                else
                    table.insert(mod_to_insert, poptionsp2:XMod() * 100)
                end
            elseif mod[3] == "CMod" then
                if poptionsp1:CMod() == nil then
                    table.insert(mod_to_insert, poptionsp1:XMod() * 100)
                else
                    table.insert(mod_to_insert, poptionsp1:CMod() * 1)
                end
                if poptionsp2:CMod() == nil then
                    table.insert(mod_to_insert, poptionsp2:XMod() * 100)
                else
                    table.insert(mod_to_insert, poptionsp2:CMod() * 1)
                end
            elseif mod[3] == "MMod" then
                -- can't be bothered with mmod who uses it
                if poptionsp1:MMod() == nil then
                    table.insert(mod_to_insert, 100)
                else
                    table.insert(mod_to_insert, poptionsp1:MMod() * 100)
                end
                if poptionsp2:MMod() == nil then
                    table.insert(mod_to_insert, 100)
                else
                    table.insert(mod_to_insert, poptionsp2:MMod() * 100)
                end
            else
                table.insert(mod_to_insert, p1value)
                table.insert(mod_to_insert, p2value)
            end
            -- replace duplicates (mods with same mods that are already activated should be replaced with the newer version)
            if mods[curmod][2] == 1 then
                local foundDuplicate = false
                for i, activemod in ipairs(currently_active_mods_1) do
                    if mod[3] == activemod[3] then
                        currently_active_mods_1[i] = mod_to_insert
                        foundDuplicate = true
                    end
                end
                if not foundDuplicate then
                    table.insert(currently_active_mods_1, mod_to_insert)
                end
            elseif mods[curmod][2] == 2 then
                local foundDuplicate = false
                for i, activemod in ipairs(currently_active_mods_2) do
                    if mod[3] == activemod[3] then
                        currently_active_mods_2[i] = mod_to_insert
                        foundDuplicate = true
                    end
                end
                if not foundDuplicate then
                    table.insert(currently_active_mods_2, mod_to_insert)
                end
            else
                local foundDuplicate = false
                for i, activemod in ipairs(currently_active_mods_1) do
                    if mod[3] == activemod[3] then
                        currently_active_mods_1[i] = mod_to_insert
                        foundDuplicate = true
                    end
                end
                if not foundDuplicate then
                    table.insert(currently_active_mods_1, mod_to_insert)
                end
                foundDuplicate = false
                for i, activemod in ipairs(currently_active_mods_2) do
                    if mod[3] == activemod[3] then
                        currently_active_mods_2[i] = mod_to_insert
                        foundDuplicate = true
                    end
                end
                if not foundDuplicate then
                    table.insert(currently_active_mods_2, mod_to_insert)
                end
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

local mod1 = nil
local mod2 = nil

add(Def.BitmapText {
    Font = "Common normal",
    Text = "",
    InitCommand = function(self)
        self:visible(false):zoom(0.5):diffuse(1, 1, 1, 0.5)
        mod1 = self
    end
})

add(Def.BitmapText {
    Font = "Common normal",
    Text = "",
    InitCommand = function(self)
        self:visible(false):zoom(0.5):diffuse(1, 1, 1, 0.5)
        mod2 = self
    end
})

on('update', function()
    mod1:settext(table.concat(GAMESTATE:GetPlayerState(0):GetPlayerOptionsArray('ModsLevel_Song'), "\n"))
    mod2:settext(table.concat(GAMESTATE:GetPlayerState(1):GetPlayerOptionsArray('ModsLevel_Song'), "\n"))
    mod1:Center():addx(-150)
    mod2:Center():addx(150)

    for i, perframe in ipairs(perframes) do
        if (beat > perframe[1] and beat < perframe[2]) then
            perframe[3]()
        end
    end
end)

function toggleModsListVisible(b)
    mod1:visible(b)
    mod2:visible(b)
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
