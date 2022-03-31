local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local Player = Players.LocalPlayer

local UI = Player.PlayerGui:WaitForChild("UserInterface")

local GuiService = {
    ProgressBar = require(script.ProgressBar),
}
GuiService.__index = GuiService

function GuiService._init()

end

return GuiService
