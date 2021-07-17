module 'common_aliases'
module 'modcore'
module 'utils'
module 'comboview'
module 'vertexfield'
setEditor(false)
setBeatOffset(0)

on('on', function()
  hideObjects()
  toggleModsListVisible(true)
end)



mod ({-5,0,{
  {0,0,'Tiny','outQuad'},
  {0,0,'Mini','outQuad'},
  {0,300,'CMod','outQuad'},
  {0,scx,'x','outQuad'},
  {0,scy,'y','outQuad'},
  {0,0,'rotationx','outQuad'},
  {0,0,'rotationy','outQuad'},
  {0,0,'rotationz','outQuad'},
  {0,1,'zoomx','outQuad'},
  {0,1,'zoomy','outQuad'},
  {0,1,'zoomz','outQuad'},
  {0,1,'zoom','outQuad'},
  {0,100,'DizzyHolds','outQuad'},
  {0,-99,'DrawSizeBack','outQuad'},
}})
mod ({0,0,{
  {0,100,'DizzyHolds','outQuad'},
}})
action ({0,function()
  P1:visible(false)
  P2:visible(false)
end})

local vf = VertexField:new{notedata = notedata, player=1}
vf:toggleVisible("mesh", true)
vf:toggleVisible("receptors", true)
vf:SetBoneTransform(function(arrowindex, bones, arrowx, arrowy, arrowz, data)
  for i=1,#bones do
    if parity(math.floor((beat*20+bones[i]:GetY())/200)) == -1 then
      if (data[2] == 1) then
        bones[i]:addx(192)
      elseif (data[2] == 2) then
        bones[i]:addx(64)
      elseif (data[2] == 3) then
        bones[i]:addx(-64)
      else
        bones[i]:addx(-192)
      end
    end
    bones[i]:addy(math.min(1-((1-(beat%1))*2),0)*30*math.cos((beat*10+bones[i]:GetY()*20)))
    bones[i]:addz(math.min(1-((1-(beat%1))*2),0)*100*math.cos((beat*10+bones[i]:GetY()*20)))
    bones[i]:addx(parity(math.floor((beat*300+bones[i]:GetY())/200))*128)
  end
end)
vf:SetReceptorTransform(function(arrowindex, bones, arrowx, arrowy, arrowz, data)
  for i=1,#bones do
    if parity(math.floor((beat*20+bones[i]:GetY())/200)) == -1 then
      if (data[2] == 1) then
        bones[i]:addx(192)
      elseif (data[2] == 2) then
        bones[i]:addx(64)
      elseif (data[2] == 3) then
        bones[i]:addx(-64)
      else
        bones[i]:addx(-192)
      end
    end
    bones[i]:addy(math.min(1-((1-(beat%1))*2),0)*30*math.cos((beat*10+bones[i]:GetY()*20)))
    bones[i]:addz(math.min(1-((1-(beat%1))*2),0)*100*math.cos((beat*10+bones[i]:GetY()*20)))
    bones[i]:addx(parity(math.floor((beat*300+bones[i]:GetY())/200))*128)
  end
end)

local vf2 = VertexField:new{notedata = notedata, player=2}
vf2:toggleVisible("mesh", true)
vf2:toggleVisible("receptors", true)
vf2:SetBoneTransform(function(arrowindex, bones, arrowx, arrowy, arrowz, data)
  for i=1,#bones do
    if parity(math.floor((beat*20+bones[i]:GetY())/200)) == -1 then
      if (data[2] == 1) then
        bones[i]:addx(192)
      elseif (data[2] == 2) then
        bones[i]:addx(64)
      elseif (data[2] == 3) then
        bones[i]:addx(-64)
      else
        bones[i]:addx(-192)
      end
    end
    bones[i]:addy(math.min(1-((1-(beat%1))*2),0)*30*math.cos((beat*10+bones[i]:GetY()*20)))
    bones[i]:addz(math.min(1-((1-(beat%1))*2),0)*100*math.cos((beat*10+bones[i]:GetY()*20)))
    bones[i]:addx(parity(math.floor((beat*300+bones[i]:GetY())/200))*-128)
  end
end)
vf2:SetReceptorTransform(function(arrowindex, bones, arrowx, arrowy, arrowz, data)
  for i=1,#bones do
    if parity(math.floor((beat*20+bones[i]:GetY())/200)) == 1 then
      if (data[2] == 1) then
        bones[i]:addx(192)
      elseif (data[2] == 2) then
        bones[i]:addx(64)
      elseif (data[2] == 3) then
        bones[i]:addx(-64)
      else
        bones[i]:addx(-192)
      end
    end
    bones[i]:addy(math.min(1-((1-(beat%1))*2),0)*30*math.cos((beat*10+bones[i]:GetY()*20)))
    bones[i]:addz(math.min(1-((1-(beat%1))*2),0)*100*math.cos((beat*10+bones[i]:GetY()*20)))
    bones[i]:addx(parity(math.floor((beat*300+bones[i]:GetY())/200))*-128)
  end
end)

-- if parity(math.floor((beat*20+bones[i]:GetY())/200)) == -1 then
    --   -- bones[i]:y(bones[i]:GetY()-arrowy + scy + (arrowy - scy)*-1)
    --   bones[i]:addx(parity(math.floor((beat*20+bones[i]:GetY())/200))*math.sin(beat)*100)
    --   bones[i]:addz(parity(math.floor((beat*20+bones[i]:GetY())/200))*math.cos(beat)*100)
    -- else
    --   bones[i]:addx(parity(math.floor((beat*20+bones[i]:GetY())/200))*math.sin(beat+math.pi)*100)
    --   bones[i]:addz(parity(math.floor((beat*20+bones[i]:GetY())/200))*math.cos(beat+math.pi)*100)
    -- end
    -- if parity(math.floor((beat*20+bones[i]:GetY())/200)) == -1 then
    --   if (data[2] == 1) then
    --     bones[i]:addx(64)
    --   elseif (data[2] == 2) then
    --     bones[i]:addx(-64)
    --   elseif (data[2] == 3) then
    --     bones[i]:addx(64)
    --   else
    --     bones[i]:addx(-64)
    --   end
    -- end
    -- bones[i]:addy(math.min(1-((1-(beat%1))*2),0)*30*math.cos((beat*10+bones[i]:GetY()*20)))
    -- bones[i]:addz(math.min(1-((1-(beat%1))*2),0)*100*math.cos((beat*10+bones[i]:GetY()*20)))


    -- bones[i]:addx(parity(math.floor((beat*50+bones[i]:GetY())/200))*math.sin(beat*math.pi/4)*100)
    -- bones[i]:addz(parity(math.floor((beat*50+bones[i]:GetY())/200))*math.cos(beat*math.pi/4)*100)
    -- bones[i]:addx(parity(math.floor((beat*50+bones[i]:GetY())/200))*100)