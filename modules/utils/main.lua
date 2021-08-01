-- returns 1 if i is odd and -1 if i is even
function parity(i)
    return ((i % 2) - 0.5) * 2
end

-- rotates the table of points around (0,0) with angle theta
function rotatePoints(points, theta)
    local newPoints = {}
    for i, point in ipairs(points) do
        table.insert(newPoints, rotatePoint(point, theta))
    end
    return newPoints
end

-- rotates the point around (0,0) with angle theta
function rotatePoint(point, theta)
    local p = {0, 0}
    p[1] = math.cos(theta) * point[1] - math.sin(theta) * point[2]
    p[2] = math.sin(theta) * point[1] + math.cos(theta) * point[2]
    return p
end

function addtotable(t, n) 
    local nextTable = {}
    for i, value in ipairs(t) do
        table.insert(nextTable, value + n)
    end
    return nextTable
end

function range(s, e, step)
    local t = {}
    for i= s, e, step do
        table.insert(t,i)
    end
    return t
end

local seed = 182943
function random()
    seed = (seed * 2835013 + 20759) % 7923103
    return seed/7923103
end