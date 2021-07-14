
local function GetService(Name)
    return game:GetService(Name)
end

local Players = GetService("Players")
local RunService = GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local Sharks = workspace.Sharks
local Body

local function WTS(Object)
    local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
    return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local function PositionToRay(Origin, Position)
    return Ray.new(Origin, (Position - Origin).Unit * 600)
end

local function GetClosestSharkFromCursor()
    local ClosestDistance = math.huge
    for i,  v in next, Sharks:GetChildren() do
        if v:IsA("Model") and v:FindFirstChild("Body") then
            local Distance = (WTS(v.Body) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if Distance <= ClosestDistance then
                Body = v.Body
                ClosestDistance = Distance
            end
        end
    end
end

local oldNameCall;
oldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    if Method == "FindPartOnRay" and Body then
        Arguments[1] = PositionToRay(workspace.CurrentCamera.CFrame.Position, Body.Position)
        return oldNameCall(Self, unpack(Arguments))
    end
    return oldNameCall(Self, ...)
end)

RunService:BindToRenderStep("Silent Aim", 120, GetClosestSharkFromCursor)
 
