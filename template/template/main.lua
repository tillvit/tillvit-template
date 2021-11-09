_G.tillvit = {}
setmetatable(tillvit, {__index = _G})
setfenv(1, tillvit)

function definecontinuous(a)
    tillvit.continuous[a[2]] = a[1]
    tillvit[a[2]] = a[1]()
end

local function setup()
    listener = {}
    continuous = {}
    imported_modules = {}
    beatOffset = 0
    definecontinuous {function() return GAMESTATE:GetSongBeat() + beatOffset end, 'beat'}
end
setup()

function msg(msg)
    SCREENMAN:SystemMessage(tostring(msg))
end

function emit(event, args) 
    if listener[event] then
        for i, func in ipairs(listener[event]) do
            func(unpack(args or {}))
        end
    end
end

function on(event, func)
    if not listener[event] then
        listener[event] = {}
    end
    table.insert(listener[event], func)
end

function addbg(item)
    template_bg[#template_bg+1]=item
end

function add(item)
    template_af[#template_af+1]=item
end

function addfg(item)
    template_fg[#template_fg+1]=item
end

function getbg() return template_bg end
function getaf() return template_af end
function getfg() return template_fg end

function setBeatOffset(a)
    beatOffset = a;
end

function dependency(modules, as)
    for i, module in ipairs(modules) do
        if imported_modules[module] == nil then
            msg("Module " .. as .. ' requires the missing module ' .. module)
        end
    end
end

function module(module) 
    assert(loadfile(GAMESTATE:GetCurrentSong():GetSongDir()..'lua/modules/'..module..'/main.lua'))()
    imported_modules[module] = true
end

function load(file) 
    assert(loadfile(GAMESTATE:GetCurrentSong():GetSongDir()..file))()
end

local function init_command(self) 
    af = self
    emit 'preinit'
    emit 'init'
    emit 'postinit'
end

local function update(self, delta) 
    emit ('update',{delta})
    for key, value in pairs(continuous) do
        tillvit[key] = value()
    end
end

local function on_command(self)
    emit 'preon'
    emit 'on'
    self:fov(90);
    self:SetDrawByZPosition(false)
    self:SetUpdateFunction(update)
    self:sleep(0.1):queuecommand("Ready")
end

local function ready_command(self)
    emit 'ready'
end

local function end_command(self)
    emit 'end'
end

local r = Def.ActorFrame {
    InitCommand=init_command;
    OnCommand=on_command;
    ReadyCommand=ready_command;
    EndCommand=end_command;
    Def.Quad{
        InitCommand= function(self) self:visible(false) end,
        OnCommand= function(self) self:sleep(1000) end,
    },
}
template_bg = Def.ActorFrame{
    InitCommand=function(self)
        template_bg = self
    end
}
template_af = Def.ActorFrame{
    InitCommand=function(self)
        template_af = self
    end
}
template_fg = Def.ActorFrame{
    InitCommand=function(self)
        template_fg = self
    end
}
r[#r+1] = template_bg
r[#r+1] = template_af
r[#r+1] = template_fg

assert(loadfile(GAMESTATE:GetCurrentSong():GetSongDir()..'lua/default.lua'))()

return r