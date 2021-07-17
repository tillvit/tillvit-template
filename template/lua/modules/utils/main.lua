require({},'utils')

--returns 1 if i is odd and -1 if i is even
function parity(i) 
  return ((i%2)-0.5)*2
end

--rotates the table of points around (0,0) with angle theta
function rotatePoints(points, theta) 
  newPoints = {}
  for i, point in ipairs(points) do
    table.insert(newPoints, rotatePoint(point,theta))
  end
  return newPoints
end

--rotates the point around (0,0) with angle theta
function rotatePoint(point, theta) 
  local p = {0,0}
  p[1] = math.cos(theta) * point[1] - math.sin(theta) * point[2]
  p[2] = math.sin(theta) * point[1] + math.cos(theta) * point[2]
  return p
end

function tablestring(t, i) 
  local indent = i or 0
  local s = "{"
  local count = 0;
  for key, v in pairs(t) do
    if (key == '__index') then goto continue end
    count = count + 1
    s = s .. "\n"
    if type(v) == 'table' then
      if tablenumkeys(v) > 6 then
        s = s .. string.rep("    ", indent+1) .. key .. ":" .. 'table(' .. tablenumkeys(v) .. ')' .. ","
      else
        s = s .. string.rep("    ", indent+1) .. key .. ":" .. tablestring(v, indent+1)  .. ","
      end
    elseif type(v) == 'function' then
      s = s .. string.rep("    ", indent+1) .. key .. ":" .. "function"  .. ","
    elseif type(v) == 'boolean' then
      if v then
        s = s .. string.rep("    ", indent+1) .. key .. ":" .. "true"  .. ","
      else
        s = s .. string.rep("    ", indent+1) .. key .. ":" .. "false"  .. ","
      end
    else
      s = s .. string.rep("    ", indent+1) .. key .. ":" .. v  .. ","
    end
    ::continue::
  end
  s = s .. "\n"..string.rep("    ", indent).."}"
  if count == 0 then
    return '{}'
  end
  return s
end

function tablenumkeys(t) 
  a = 0
  for key, v in pairs(t) do
    if (key == '__index') then goto continue end
    a = a + 1
    ::continue::
  end
  return a
end