local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

--local Car = require(SharedModules.Car)

local InputHandler = require(script.InputHandler)
local GUI = require(script.GUI)
local Sounds = require(script.Sounds)

local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()

local Mouse = Player:GetMouse()

local UI = Player.PlayerGui:WaitForChild("UserInterface")


GUI._init()
---InputHandler.BindAction("Switch1", Switch, Enum.KeyCode.One)