dependency ({"common_aliases"}, "vertexfield")

local uniqueaftid = 0

VertexField = {
    bonedata = {},
    triangles = {},
    fakeArrows = {},
    fakeReceptors = {},
    notedata = {},
    screenTex = "",
    aft = {},
    player = nil,
    settings = {
        show = {
            aft = false,
            structure = false,
            mesh = true,
            bones = false,
            receptors = false
        },
        meshtexture = true,
        drawpastreceptors = true
    },

    boneTransform = function(arrowindex, bones, arrowx, arrowy, arrowz, data)
    end,
    receptorTransform = function(arrowindex, bones, arrowx, arrowy, arrowz, data)
    end
}
local rotates = {0, -math.pi / 2, math.pi / 2, math.pi}

function VertexField:new(a)
    o = {}
    o.bonedata = a.bones or {{-32, 0}, {0, 32}, {14, 19}, {5, 10}, {30, 10}, {30, -10}, {5, -10}, {14, -19}, {0, -32}};
    o.triangles = a.triangles or {{1, 2, 4}, {2, 3, 4}, {1, 4, 7}, {1, 7, 9}, {7, 8, 9}, {4, 6, 7}, {4, 5, 6}};
    o.notedata = a.notedata or {};
    o.playerNum = a.player
    o.aft = {}
    o.settings = {
        show = {
            aft = false,
            structure = false,
            mesh = true,
            bones = false,
            receptors = false
        },
        meshtexture = true,
        drawpastreceptors = true
    }
    uniqueaftid = uniqueaftid + 1
    o.screenTex = "vtfieldtex" .. uniqueaftid
    self.__index = self
    setmetatable(o, self)
    o:createAft()
    o:generate(o.notedata, o.screenTex)
    o:subscribe()
    return o
end

function VertexField:createAft()
    -- the Texture of the Screen
    local vf = self
    local texName = self.screenTex
    add(Def.ActorFrameTexture {
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

function VertexField:generate()
    local fakeArrows = {}
    local numBones = #self.bonedata
    local numTriangles = #self.triangles
    for i, data in ipairs(self.notedata) do
        table.insert(fakeArrows, {})
        -- normal aft (aft is cropped and positioned, no amv)
        add(Def.Sprite {
            Texture = self.screenTex,
            InitCommand = function(self)
                fakeArrows[i].firstAft = self;
            end,
            OnCommand = function(self)
                self:diffuse(1, 1, 1, 1)
                self:visible(false)
            end
        })
        -- bones
        fakeArrows[i].bones = {}
        for j = 1, numBones do
            add(Def.Quad {
                InitCommand = function(self)
                    table.insert(fakeArrows[i].bones, self);
                end,
                OnCommand = function(self)
                    self:diffuse(1, 1, 1, 0.5)
                    self:zoomto(10, 10)
                    self:visible(false)
                end
            })
        end
        -- outline
        add(Def.ActorMultiVertex {
            Texture = "white.png",
            InitCommand = function(self)
                fakeArrows[i].structure = self
            end,
            OnCommand = function(self)
                self:SetDrawState({
                    Mode = "DrawMode_LineStrip",
                    First = 1,
                    Num = -1
                })
                self:SetNumVertices(numBones + 1)
                self:x(0):y(0):visible(false)
            end
        })
        -- mesh
        add(Def.ActorMultiVertex {
            Texture = self.screenTex,
            InitCommand = function(self)
                fakeArrows[i].mesh = self
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
        })
    end
    self.fakeArrows = fakeArrows
    local fakeReceptors = {}
    for i = 1, 4 do
        table.insert(fakeReceptors, {})
        -- normal aft (aft is cropped and positioned, no amv)
        add(Def.Sprite {
            Texture = self.screenTex,
            InitCommand = function(self)
                fakeReceptors[i].firstAft = self;
            end,
            OnCommand = function(self)
                self:diffuse(1, 1, 1, 1)
                self:visible(false)
            end
        })
        -- bones
        fakeReceptors[i].bones = {}
        for j = 1, numBones do
            add(Def.Quad {
                InitCommand = function(self)
                    table.insert(fakeReceptors[i].bones, self);
                end,
                OnCommand = function(self)
                    self:diffuse(1, 1, 1, 0.5)
                    self:zoomto(10, 10)
                    self:visible(false)
                end
            })
        end
        -- outline
        add(Def.ActorMultiVertex {
            Texture = "white.png",
            InitCommand = function(self)
                fakeReceptors[i].structure = self
            end,
            OnCommand = function(self)
                self:SetDrawState({
                    Mode = "DrawMode_LineStrip",
                    First = 1,
                    Num = -1
                })
                self:SetNumVertices(numBones + 1)
                self:x(0):y(0):visible(false)
            end
        })
        -- mesh
        add(Def.ActorMultiVertex {
            Texture = self.screenTex,
            InitCommand = function(self)
                fakeReceptors[i].mesh = self
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
        })
    end
    self.fakeReceptors = fakeReceptors
end

function VertexField:DrawArrow(obj, data, i, transform, yoffset)
    local firstAft = obj.firstAft
    local bones = obj.bones
    local structure = obj.structure
    local mesh = obj.mesh

    local offBeat = data[1]
    local column = data[2]
    local tiny = math.pow(0.5, poptions[1]:Tiny())

    local yOffset = ArrowEffects.GetYOffset(GAMESTATE:GetPlayerState("PlayerNumber_P" .. self.playerNum), column,
        offBeat)
    local arrowx = ArrowEffects.GetXPos(GAMESTATE:GetPlayerState("PlayerNumber_P" .. self.playerNum), column, yOffset) *
                       SCREEN_HEIGHT / 480 + SCREEN_WIDTH / 2
    local arrowy = ArrowEffects.GetYPos(GAMESTATE:GetPlayerState("PlayerNumber_P" .. self.playerNum), column, yOffset) *
                       SCREEN_HEIGHT / 480 + SCREEN_HEIGHT / 2 + yoffset
    local arrowz = ArrowEffects.GetZPos(GAMESTATE:GetPlayerState("PlayerNumber_P" .. self.playerNum), column, yOffset)
    -- i don't know what this 100 does but it said i needed a 4th number argument and it does not exist in the documentation
    local rotationz = ArrowEffects.GetRotationZ(GAMESTATE:GetPlayerState("PlayerNumber_P" .. self.playerNum), offBeat,
        false, 100)

    if (arrowy > sh + 50 or arrowy < -50) or (beat > offBeat and not self.settings.drawpastreceptors) then
        -- stop existing if off screen
        firstAft:visible(false)
        structure:visible(false)
        mesh:visible(false)
        for i = 1, #self.bonedata do
            bones[i]:visible(false)
        end
        return
    else
        firstAft:visible(self.settings.show.aft)
        structure:visible(self.settings.show.structure)
        mesh:visible(self.settings.show.mesh)
        for i = 1, #self.bonedata do
            bones[i]:visible(self.settings.show.bones)
        end
    end

    -- position the aft
    -- stolen from tillvit's abandoned file of theyaremanycolors
    firstAft:x(arrowx)
    firstAft:y(arrowy)
    if (firstAft:GetVisible()) then
        firstAft:rotationx(self.player:GetRotationX())
        firstAft:rotationy(self.player:GetRotationY())
        firstAft:align(arrowx / sw, arrowy / sh)
        firstAft:cropleft((arrowx - 32 * self.player:GetZoom() * tiny) / sw)
        firstAft:croptop((arrowy - 32 * self.player:GetZoom() * tiny) / sh)
        firstAft:cropright(((sw - arrowx) - 32 * self.player:GetZoom() * tiny) / sw)
        firstAft:cropbottom(((sh - arrowy) - 32 * self.player:GetZoom() * tiny) / sh)
    end

    -- get the coordinates for the bones based on rotation
    local newbonedata = rotatePoints(self.bonedata, rotates[column] + rotationz / 180 * math.pi)

    for j = 1, #self.bonedata do
        -- position the bones   
        bones[j]:x(firstAft:GetX() + newbonedata[j][1] * tiny * sh/480)
        bones[j]:y(firstAft:GetY() + newbonedata[j][2] * tiny * sh/480)
        bones[j]:z(0)
    end

    -- transform the arrows based on the given function
    transform(i, bones, arrowx, arrowy, arrowz, data)

    -- draw structure
    if structure:GetVisible() then
        for j = 0, #self.bonedata do
            structure:SetVertex(j + 1,
                {{bones[(j + 1) % #self.bonedata + 1]:GetX(), bones[(j + 1) % #self.bonedata + 1]:GetY(),
                  bones[(j + 1) % #self.bonedata + 1]:GetZ()}, {1, 1, 1, 1}, {0, 0}})
        end
    end

    -- create the mesh!!
    local left, top, right, bottom = self.aft.aft:GetTexture():GetTextureCoordRect(0)
    if mesh:GetVisible() then
        for j, triangle in ipairs(self.triangles) do
            -- showcasing (colors with no texture)
            col = 1
            if (not self.settings.meshtexture) then
                col = j / #self.triangles
            end
            -- a lot of characters but it just Does Thing (maps coords on tex to screen based on the position of the bones)
            mesh:SetVertex(j * 3 - 2,
                {{bones[triangle[1]]:GetX(), bones[triangle[1]]:GetY(), bones[triangle[1]]:GetZ()}, {col, col, col, 1},
                 {(firstAft:GetX() + tiny * sh/480 * newbonedata[triangle[1]][1]) / sw * right,
                  (firstAft:GetY() + tiny * sh/480 * newbonedata[triangle[1]][2]) / sh * bottom}})
            mesh:SetVertex(j * 3 - 1,
                {{bones[triangle[2]]:GetX(), bones[triangle[2]]:GetY(), bones[triangle[2]]:GetZ()}, {col, col, col, 1},
                 {(firstAft:GetX() + tiny * sh/480 * newbonedata[triangle[2]][1]) / sw * right,
                  (firstAft:GetY() + tiny * sh/480 * newbonedata[triangle[2]][2]) / sh * bottom}})
            mesh:SetVertex(j * 3,
                {{bones[triangle[3]]:GetX(), bones[triangle[3]]:GetY(), bones[triangle[3]]:GetZ()}, {col, col, col, 1},
                 {(firstAft:GetX() + tiny * sh/480 * newbonedata[triangle[3]][1]) / sw * right,
                  (firstAft:GetY() + tiny * sh/480 * newbonedata[triangle[3]][2]) / sh * bottom}})
        end
    end
end

function VertexField:subscribe()
    on('on', function()
        self.player = tillvit["P" .. self.playerNum]
        self.aft.proxy:SetTarget(self.player:GetChild('NoteField')):visible(self.settings.meshtexture)
    end)
    on('update', function()
        local offset = 0
        if sh == 480 then
            offset = 10
        end
        for i, data in ipairs(self.notedata) do
            self:DrawArrow(self.fakeArrows[i], data, i, self.boneTransform, offset)
        end
        if self.settings.show.receptors then
            local offset = 0
            if sh == 480 then
                offset = 16
            end
            for i = 1, 4 do
                self:DrawArrow(self.fakeReceptors[i], {beat, i}, i, self.receptorTransform, offset)
            end
        end
    end)
end

function VertexField:toggleVisible(actor, visible)
    if self.settings.show[actor] ~= nil then
        self.settings.show[actor] = visible
    else
        msg("VertexField: Couldn't find the actor " .. actor)
    end
end

function VertexField:drawTexturedMesh(bool)
    self.settings.meshtexture = bool
    self.aft.proxy:visible(self.settings.meshtexture)
end

function VertexField:HidePastReceptors(bool)
    self.drawpastreceptors = not bool
end

function VertexField:SetBoneTransform(func)
    self.boneTransform = func
end
function VertexField:SetReceptorTransform(func)
    self.receptorTransform = func
end
