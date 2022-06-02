 --[[
     This is probably the last update i'm gonna do, I've been updating this for half a year. If it gets patched I won't care so don't PM me.
 ]]
 
 local function GetService(Name)
    return game:GetService(Name)
 end;
 
 local Players = GetService("Players");
 local RunService = GetService("RunService");
 local LocalPlayer = Players.LocalPlayer;
 local Mouse = LocalPlayer:GetMouse();
 local NetworkManager = require(LocalPlayer.PlayerScripts.LocalManager.NetworkManager);
 local Camera = workspace.CurrentCamera;
 local Zombies = workspace.Zombies;
 local Part;
 
 local function WTS(Object)
    local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
    return Vector2.new(ObjectVector.X, ObjectVector.Y)
 end;
 
 local function PositionToRay(Origin, Position)
    return Ray.new(Origin, (Position - Origin).Unit * 600)
 end;
 
 local function GetClosestZombieFromCursor()
    local ClosestDistance = math.huge
    for i,  v in next, Zombies:GetChildren() do
       if v ~= nil and v:FindFirstChild("Head") and v:FindFirstChild("Zombie") then
          if v.Zombie.Health ~= 0 then
             local Magnitude = (WTS(v.Head) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
             if Magnitude <= ClosestDistance then
                Part = v.Head;
                ClosestDistance = Magnitude;
             end;
          end;
       end;
    end;
 end;

 local OldHook; OldHook = hookfunc(NetworkManager.PassData, function(Self, ...)
    local Arguments = {...}
    if tostring(Arguments[1]) == "WeaponAttack" and Arguments[2][3].SA2 ~= nil then
        Arguments[2][3].SA2 = false -- Quote: Improved anti-cheat (B_Ketchup)
    end;
    return OldHook(Self, ...)
 end);
 
 local oldNameCall; oldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    if Method == "Kick" then
        return
    end
    if Method == "FindPartOnRayWithIgnoreList" and typeof(Arguments[1]) == "Ray" and Part then
       Arguments[1] = PositionToRay(Camera.CFrame.Position, Part.Position)
       return oldNameCall(Self, unpack(Arguments))
    end;
    return oldNameCall(Self, ...)
 end));

 RunService:BindToRenderStep("Silent Aim", 120, GetClosestZombieFromCursor);
 
