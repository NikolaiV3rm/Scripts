local function GetService(Name)
   return game:GetService(Name)
end

local Players = GetService("Players")
local RunService = GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local Zombies = workspace.Zombies
local Part = nil

local function WTS(Object)
   local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
   return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local function PositionToRay(Origin, Position)
   return Ray.new(Origin, (Position - Origin).Unit * 600)
end

local function GetClosestZombieFromCursor()
   local ClosestDistance = math.huge
   for i,  v in next, Zombies:GetChildren() do
      if v ~= nil and v:FindFirstChild("Head") and v:FindFirstChild("Zombie") then
         if v.Zombie.Health ~= 0 then
            local Magnitude = (WTS(v.Head) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if Magnitude <= ClosestDistance then
               Part = v.Head
               ClosestDistance = Magnitude
            end
         end
      end
   end
end

local oldNameCall;
oldNameCall = hookmetamethod(game, "__namecall", function(...)
   local Method = getnamecallmethod()
   local Arguments = {...}
   if Method == "FindPartOnRayWithIgnoreList" and Part ~= nil then
      Arguments[2] = PositionToRay(Camera.CFrame.Position, Part.Position)
      return oldNameCall(unpack(Arguments))
   end
   return oldNameCall(...)
end)

RunService:BindToRenderStep("Silent Aim", 120, GetClosestZombieFromCursor)
