dependency({"common_aliases"}, "vertexfield")

local uniqueaftid = 0
local arrowoffset = (THEME:GetMetric("Player","ReceptorArrowsYStandard") + THEME:GetMetric("Player","ReceptorArrowsYReverse")) / 2

VertexField = {
    bonedata = {},
    triangles = {},
    arrow = {},
    notedata = {},
    screenTex = "",
    aft = {},
    player = nil,
    settings = {
        show = {
            mesh = true,
            bones = false,
            receptors = false
        },
    },
    af=nil;
    boneTransform = function(bones, arrow, notedata, isHold)
        return bones
    end,
    receptorTransform = function(bones, arrow, notedata)
        return bones
    end
}

local rotates = {0, -math.pi / 2, math.pi / 2, math.pi}

function VertexField:new(a)
    o = {}
    o.bonedata = a.bones or {{-32, 0}, {0, 32}, {14, 19}, {5, 10}, {30, 10}, {30, -10}, {5, -10}, {14, -19}, {0, -32}};
    o.triangles = a.triangles or {{1, 2, 4}, {2, 3, 4}, {1, 4, 7}, {1, 7, 9}, {7, 8, 9}, {4, 6, 7}, {4, 5, 6}};
    o.notedata = a.notedata or {};
    o.playerNum = a.player
    o.drawsizebeats = a.drawsizebeats or 5
    o.drawsizebackbeats = a.drawsizebackbeats or 0
    o.aft = {}
    o.lastArrowDrawn = 1;
    --create actorframe that holds everything.
    o.af = Def.ActorFrame {
        InitCommand=function(self)
            o.af = self;
        end,
        Def.Quad{
            OnCommand=function(self)
                self:visible(false)
            end
        }
    }
    o.settings = {
        show = {
            mesh = true,
            bones = false,
            receptors = false
        },
    }
    uniqueaftid = uniqueaftid + 1
    o.screenTex = "vtfieldtex" .. uniqueaftid
    self.__index = self
    setmetatable(o, self)
    o:createAft()
    o:generate()
    o:subscribe()
    add(o.af)
    return o
end

--make the aft that proxies player
function VertexField:createAft()
    -- the Texture of the Screen
    local vf = self
    local texName = self.screenTex
    add( Def.ActorFrameTexture {
        InitCommand = function(self)
            self:SetTextureName(texName)
            self:SetWidth(sw);
            self:SetHeight(sh);
            self:EnableAlphaBuffer(true);
            self:Create();
            vf.aft.aft = self
        end,
        Def.Quad {
            InitCommand = function(self)
                vf.aft.quad = self
            end,
            OnCommand = function(self)
                self:x(scx):y(scy):zoomto(sw, sh):diffuse(1, 1, 1, 0)
            end
        },
        Def.ActorProxy {
            InitCommand = function(self)
                vf.aft.proxy = self
            end,
            OnCommand = function(self)
                self:x(scx);
                self:y(scy);
                self:visible(true)
                self:zoom(sh / 480);
            end
        }
    })
end

--generate actors
function VertexField:generate()
    local arrow = {}
    local numTriangles = #self.triangles
    self.af[#self.af+1] = Def.Quad {
        InitCommand = function(self)
            arrow.bone = self
        end,
        OnCommand = function(self)
            self:diffuse(1, 1, 1, 0.5)
            self:zoomto(10, 10)
            self:visible(true)
        end
    }
    -- mesh
    self.af[#self.af+1] = Def.ActorMultiVertex {
        Texture = self.screenTex,
        InitCommand = function(self)
            arrow.mesh = self
        end,
        OnCommand = function(self)
            self:SetDrawState({
                Mode = "DrawMode_Triangles",
                First = 1,
                Num = -1
            })
            self:SetNumVertices(numTriangles * 3)
            self:x(0):y(0):visible(true)
        end
    }
    -- mesh
    self.af[#self.af+1] = Def.ActorMultiVertex {
        Texture = self.screenTex,
        InitCommand = function(self)
            arrow.holdmesh = self
        end,
        OnCommand = function(self)
            self:SetDrawState({
                Mode = "DrawMode_Quads",
                First = 1,
                Num = -1
            })
            self:SetNumVertices(4)
            self:x(0):y(0):visible(true)
        end
    }
    self.arrow = arrow;
end

function getArrowData(ps, notebeat, column, isHold)
    local rt = {}
    local isHold = isHold or false
    local beat2 = notebeat
    if isHold then beat2 = math.max(notebeat, beat) end
    local yOffset = ArrowEffects.GetYOffset(ps, column, beat2)
    rt.x = ArrowEffects.GetXPos(ps, column, yOffset) * sh / 480 + sw / 2
    rt.y = ArrowEffects.GetYPos(ps, column, yOffset) * sh / 480 + sh / 2
    rt.z = ArrowEffects.GetZPos(ps, column, yOffset)
    rt.rotz = ArrowEffects.GetRotationZ(ps, notebeat, isHold, column, yOffset)
    return rt
end

local function deepCopy(t)
	local copy = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

--draw an arrow
function VertexField:DrawArrow(notedata, isReceptor)
    if type(notedata[3]) == "string" then return end
    local bone = self.arrow.bone
    local mesh = self.arrow.mesh
    local holdmesh = self.arrow.holdmesh
    local isHold = notedata[3] == 2 or notedata[3] == 4

    local notebeat = notedata[1]
    local column = notedata[2] + 1
    
    local ps = GAMESTATE:GetPlayerState("PlayerNumber_P" .. self.playerNum)

    --get position of an arrow
    local arrow = getArrowData(ps, notebeat, column, isHold)

    --getting size doesn't work with ArrowEffects?????
    local tiny = math.pow(0.5, poptions[self.playerNum]:Tiny())

    -- get the coordinates for the bones based on rotation
    local rotatedbonepos = rotatePoints(self.bonedata, rotates[column] + arrow.rotz / 180 * math.pi)
    for i=1,#rotatedbonepos do
        rotatedbonepos[i][1] = (arrow.x + rotatedbonepos[i][1] * tiny * sh / 480)
        rotatedbonepos[i][2] = (arrow.y + rotatedbonepos[i][2] * tiny * sh / 480) + arrowoffset
        rotatedbonepos[i][3] = 0
    end

    --what is this
    local holdbonepos = {}

    if isHold then
        local numholdbones = math.floor(notedata.length / 0.1)*2 + 4
        --get pos of holds (every part except the tail)
        for j = 1, numholdbones - 4 do
            local holdbeat = math.max(notebeat + math.floor((j - 1) / 2) * 0.1, beat)
            local arrow = getArrowData(ps, holdbeat, column, true) 
            if (j % 2 == 1) then
                table.insert(holdbonepos, {arrow.x - ARROW_SIZE / 2 * tiny, arrow.y + arrowoffset, 0})
            else
                table.insert(holdbonepos, {arrow.x + ARROW_SIZE / 2 * tiny, arrow.y + arrowoffset, 0})
            end
        end
        --pos of hold tails (starting)
        for j = numholdbones - 3, numholdbones - 2 do
            local holdbeat = math.max(notebeat + notedata.length, beat)
            local arrow = getArrowData(ps, holdbeat, column, true) 
            if (j % 2 == 1) then
                table.insert(holdbonepos, {arrow.x - ARROW_SIZE / 2 * tiny, arrow.y + arrowoffset, 0})
            else
                table.insert(holdbonepos, {arrow.x + ARROW_SIZE / 2 * tiny, arrow.y + arrowoffset, 0})
            end
        end
        --pos of hold tails (ending)
        for j = numholdbones - 1, numholdbones do
            local holdbeat = math.max(notebeat + notedata.length, beat)
            local arrow = getArrowData(ps, holdbeat, column, true) 
            local hoffset = 30
            if ps:GetPlayerOptions("ModsLevel_Song"):Reverse() > 0.5 then hoffset = -30 end
            if (j % 2 == 1) then
                table.insert(holdbonepos, {arrow.x - ARROW_SIZE / 2 * tiny, arrow.y + arrowoffset + hoffset * tiny, 0})
            else
                table.insert(holdbonepos, {arrow.x + ARROW_SIZE / 2 * tiny, arrow.y + arrowoffset + hoffset * tiny, 0})
            end
        end
    end

    local transform = self.boneTransform
    if isReceptor then transform = self.receptorTransform end

    -- transform the arrows based on the given function
    local transformedbonepos = transform(deepCopy(rotatedbonepos), arrow, notedata, isHold)
    local transformedholdbonepos = {}
    --holds
    if (isHold) then transformedholdbonepos = transform(deepCopy(holdbonepos), arrow, notedata, isHold) end

    -- create the mesh!!
    if self.settings.show.mesh then
        local left, top, right, bottom = self.aft.aft:GetTexture():GetTextureCoordRect(0)
        for j, triangle in ipairs(self.triangles) do
            -- a lot of characters but it just Does Thing (maps coords on tex to screen based on the position of the bones)
            mesh:SetVertex(j * 3 - 2,
                {{transformedbonepos[triangle[1]][1], transformedbonepos[triangle[1]][2], transformedbonepos[triangle[1]][3]}, {1, 1, 1, 1},
                 {(rotatedbonepos[triangle[1]][1]) / sw * right,
                  (rotatedbonepos[triangle[1]][2]) / sh * bottom}})
            mesh:SetVertex(j * 3 - 1,
                {{transformedbonepos[triangle[2]][1], transformedbonepos[triangle[2]][2], transformedbonepos[triangle[2]][3]}, {1, 1, 1, 1},
                 {(rotatedbonepos[triangle[2]][1]) / sw * right,
                  (rotatedbonepos[triangle[2]][2]) / sh * bottom}})
            mesh:SetVertex(j * 3,
                {{transformedbonepos[triangle[3]][1], transformedbonepos[triangle[3]][2], transformedbonepos[triangle[3]][3]}, {1, 1, 1, 1},
                 {(rotatedbonepos[triangle[3]][1]) / sw * right,
                  (rotatedbonepos[triangle[3]][2]) / sh * bottom}})
                  
        end
        mesh:Draw()
        --same for holds
        if isHold then
            holdmesh:SetNumVertices(((math.floor(notedata.length / 0.1) * 2 + 4) / 2 - 1) * 4)
            for j = 1, #transformedholdbonepos - 2, 2 do
                local rectindex = (j - 1) / 2
                holdmesh:SetVertex(rectindex * 4 + 1,
                    {{transformedholdbonepos[j][1], transformedholdbonepos[j][2], transformedholdbonepos[j][3]}, {1, 1, 1, 1},
                        {(holdbonepos[j][1]) / sw * right, (holdbonepos[j][2]) / sh * bottom}})
                holdmesh:SetVertex(rectindex * 4 + 2,
                    {{transformedholdbonepos[j + 1][1], transformedholdbonepos[j + 1][2], transformedholdbonepos[j + 1][3]}, {1, 1, 1, 1},
                        {(holdbonepos[j + 1][1]) / sw * right, (holdbonepos[j + 1][2]) / sh * bottom}})
                holdmesh:SetVertex(rectindex * 4 + 4,
                    {{transformedholdbonepos[j + 2][1], transformedholdbonepos[j + 2][2], transformedholdbonepos[j + 2][3]}, {1, 1, 1, 1},
                        {(holdbonepos[j + 2][1]) / sw * right, (holdbonepos[j + 2][2]) / sh * bottom}})
                holdmesh:SetVertex(rectindex * 4 + 3,
                    {{transformedholdbonepos[j + 3][1], transformedholdbonepos[j + 3][2], transformedholdbonepos[j + 3][3]}, {1, 1, 1, 1},
                        {(holdbonepos[j + 3][1]) / sw * right, (holdbonepos[j + 3][2]) / sh * bottom}})
            end
            holdmesh:Draw()
        end
    end

    if self.settings.show.bones then
        bone:diffuse(1,1,1,0.5)
        for i, pos in ipairs(rotatedbonepos) do
            bone:x(pos[1]):y(pos[2]):z(pos[3]):Draw()
        end
        for i, pos in ipairs(holdbonepos) do
            bone:x(pos[1]):y(pos[2]):z(pos[3]):Draw()
        end
        bone:diffuse(1,0,0,0.5)
        for i, pos in ipairs(transformedbonepos) do
            bone:x(pos[1]):y(pos[2]):z(pos[3]):Draw()
        end
        for i, pos in ipairs(transformedholdbonepos) do
            bone:x(pos[1]):y(pos[2]):z(pos[3]):Draw()
        end
    end
end

function VertexField:subscribe()
    --event cycles
    on('on', function()
        self.player = tillvit["P" .. self.playerNum]
        --set notedata if not set
        if #self.notedata == 0 then 
            local d = {}
            for key, data in pairs(self.player:GetNoteData()) do
                if data[3] == "TapNoteSubType_Hold" or data[3] == "TapNoteSubType_Roll" then
                    local type = 2;
                    if (data[3] == "TapNoteSubType_Roll") then type = 4; end
                    table.insert(d,{data[1],data[2]-1,type,length=data.length})
                elseif data[3] == "TapNoteType_Tap" then
                    table.insert(d,{data[1],data[2]-1,1})
                end
            end
            self.notedata = d
        end
        --set proxy target
        self.aft.proxy:SetTarget(self.player:GetChild('NoteField')):visible(true)

        --drawfunc
        self.af:SetDrawFunction(function() 
            if self.settings.show.mesh or self.settings.show.bones or self.settings.show.receptors then
                local first = -1;
                for i = self.lastArrowDrawn,#self.notedata do
                    local data = self.notedata[i]
                    if data[3] == 2 or data[3] == 4 then
                        if data[1] > beat + self.drawsizebeats then break end
                        if data[1] > beat - self.drawsizebackbeats - data.length then 
                            self:DrawArrow(data, false) 
                            if first > i or first == -1 then first = i; end 
                        end
                    else
                        if data[1] > beat + self.drawsizebeats then break end
                        if data[1] > beat - self.drawsizebackbeats then 
                            self:DrawArrow(data, false) 
                            if first > i or first == -1 then first = i; end 
                        end
                    end
                end
                if first ~= -1 then self.lastArrowDrawn = first end
                if self.settings.show.receptors then
                    for i=1,4 do
                        self:DrawArrow({beat, i-1, 1}, true) 
                    end
                end
            end
        end)
    end)
end

function VertexField:toggleVisible(actor, visible)
    if self.settings.show[actor] ~= nil then
        self.settings.show[actor] = visible
    else
        msg("VertexField: Couldn't find the actor " .. actor)
    end
end

function VertexField:SetDrawSizeBackBeats(b)
    if type(b) ~= "number" then msg(b .. " is not a valid number") return end
    self.settings.drawsizebackbeats = b
end

function VertexField:SetDrawSizeBeats(b)
    if type(b) ~= "number" then msg(b .. " is not a valid number") return end
    self.settings.drawsizebeats = b
end

function VertexField:SetBoneTransform(func)
    self.boneTransform = func
end

function VertexField:SetReceptorTransform(func)
    self.receptorTransform = func
end

function VertexField:SetNoteData(f)
    self.notedata = f
    self.lastArrowDrawn = 1;
end

