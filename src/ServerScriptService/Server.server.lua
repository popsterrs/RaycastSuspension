local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local ServerModules = ServerStorage:WaitForChild("Modules")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local SharedConfig = require(SharedModules.SharedConfig)
local DebugService = require(SharedModules.DebugService)
local Car = require(SharedModules.Car)

local NewCar = Car._new(Vector3.new(0, 3, 0))

workspace.DescendantRemoving:Connect(function(descendant)
    if descendant == NewCar.PhysicsRig then
        print("s")
        NewCar:destroy()
        NewCar = Car._new(Vector3.new(0, 7, 0))
    end
end)

DebugService.DebugEnabled = true

