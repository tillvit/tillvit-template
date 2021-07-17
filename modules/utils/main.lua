-- returns 1 if i is odd and -1 if i is even
function parity(i)
    return ((i % 2) - 0.5) * 2
end

-- rotates the table of points around (0,0) with angle theta
function rotatePoints(points, theta)
    newPoints = {}
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
