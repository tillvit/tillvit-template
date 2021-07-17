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
    SCREENMAN:SystemMessage(msg)
end

function emit(event) 
    if listener[event] then
        for i, func in ipairs(listener[event]) do
            func()
        end
    end
end

function on(event, func)
    if not listener[event] then
        listener[event] = {}
    end
    table.insert(listener[event], func)
end

function add(item)
    af[#af+1]=item
end

function setEditor(a) 
    isEditor = a
end

function setBeatOffset(a)
    beatOffset = a;
end

function require(modules, as)
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

local function init_command(self) 
    emit 'preinit'
    emit 'init'
end

local function update() 
    emit 'update'
    for key, value in pairs(continuous) do
        tillvit[key] = value()
    end
end

local function on_command(self)
    emit 'preon'
    emit 'on'
    self:fov(90);
    self:SetDrawByZPosition(true)
    self:SetUpdateFunction(update)
end

af = Def.ActorFrame {
    InitCommand=init_command;
    OnCommand=on_command;
    Def.Quad{
        InitCommand= function(self)
            self:visible(false)
        end,
        OnCommand= function(self)
            self:sleep(1000)
        end,
    },
}

assert(loadfile(GAMESTATE:GetCurrentSong():GetSongDir()..'lua/default.lua'))()

return af