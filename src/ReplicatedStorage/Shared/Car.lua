local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local SharedConfig = require(SharedModules.SharedConfig)
local DebugService = require(SharedModules.DebugService)
local Maid = require(SharedModules.Maid)
local Gizmos = require(SharedModules.Gizmos)

local Car = {
    Cars = {}
}
Car.__index = Car

function Car._new(position)
    local NewCar = {}
    setmetatable(NewCar, Car)

    NewCar.Maid = Maid.new()
    NewCar.Model = Assets.Car:Clone()
    NewCar.PhysicsRig = NewCar.Model.PhysicsRig

    NewCar.Model.PrimaryPart.Position = position
    NewCar.Model.Parent = game.Workspace

    NewCar.Model.PrimaryPart:SetNetworkOwner(nil)

    NewCar.Maid:GiveTask(RunService.Stepped:Connect(function(dt)
		NewCar:update(dt)
	end))
    
    table.insert(Car.Cars, NewCar)

    NewCar.Maid.Car = NewCar.Model

    return NewCar
end

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

local PreviousSuspensionLengths = {
    ["Front_L"] = 0.05,
    ["Front_R"] = 0.05,
    ["Rear_L"] = 0.05,
    ["Rear_R"] = 0.05,
}

local SuspensionMaxLength = 4
local SuspensionLength = 1.5
local Stiffness = 3
local Damper = .4
local WheelRadius = 0.5

function Car:update(delta)
    raycastParams.FilterDescendantsInstances = {self.Model}

    for _, attatchment in pairs(self.PhysicsRig.Rig:GetChildren()) do
        if attatchment:IsA("Attachment") then
            local raycastResult = workspace:Raycast(attatchment.WorldPosition, -attatchment.CFrame.UpVector * (SuspensionMaxLength + WheelRadius) , raycastParams)

            if raycastResult then						
                local rayLength = (attatchment.WorldPosition - raycastResult.Position).magnitude
        
                local springLength = math.clamp(rayLength - WheelRadius, 0, SuspensionMaxLength)
                local stiffnessForce = Stiffness * (SuspensionLength - springLength)
                local damperForce = Damper * ((PreviousSuspensionLengths[attatchment.Name] - springLength) / delta)
                local suspensionForce = attatchment.CFrame.UpVector * (stiffnessForce + -damperForce)
                
                PreviousSuspensionLengths[attatchment.Name] = springLength

                attatchment.BillboardGui.TextLabel.Text = suspensionForce.Y
				self.PhysicsRig.Visuals[attatchment.Name].WorldPosition = raycastResult.Position
				attatchment.VectorForce.Force = suspensionForce

                local wheel = self.Model.Model.Wheels[attatchment.Name]
                wheel.Position = raycastResult.Position
            else
				attatchment.VectorForce.Force = Vector3.new()
            end
        end
    end
end

function Car:destroy()
    self.Maid:DoCleaning()
end

return Car
