local CFrameUtils = {}

function CFrameUtils.FromAxisAngle(x, y, z)
    if not y then
		x,y,z=x.x,x.y,x.z
	end
	local m=(x*x+y*y+z*z)^0.5
	if m>1e-5 then
		local si=math.sin(m/2)/m
		return CFrame.new(0,0,0,si*x,si*y,si*z,math.cos(m/2))
	else
		return CFrame.new()
	end
end

function CFrameUtils.Snap(cframe, grid)
    local x = math.round(cframe.X/grid) * grid
    local z = math.round(cframe.Z/grid) * grid
    return CFrame.new(x, 0 ,z)
end


function CFrameUtils.Vector3ToAngles(vector)
	return CFrame.Angles(math.rad(vector.X), math.rad(vector.Y), math.rad(vector.Z))
end



return CFrameUtils