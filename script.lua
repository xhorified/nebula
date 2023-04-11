local usernames= {
    "Player Name",
    "dumpthatknocka" -- Username to the player you are gonna whitelist.
}
 
game.Players.PlayerAdded:Connect(function(plr)
    for i, v in pairs(usernames) do
        if v == plr.Name then
            print("Whitelisted")
                
            local Prey = nil
local Prey2  = nil
local DetectedDesync       = false
local DetectedDesyncV2     = false
local DetectedUnderGround  = false
local DetectedUnderGround2 = false
local DetectedFreeFall     = false
local OldSilentAimPart     = getgenv().nebula.Silent.Part
local Script               = {Functions = {}}

local Players, Client, Mouse, RS, Camera =
    game:GetService("Players"),
    game:GetService("Players").LocalPlayer,
    game:GetService("Players").LocalPlayer:GetMouse(),
    game:GetService("RunService"),
    game:GetService("Workspace").CurrentCamera

local Circle          = Drawing.new("Circle")
local AimAssistCircle = Drawing.new("Circle")

Circle.Color           = Color3.new(1,1,1)
Circle.Thickness       = 1
AimAssistCircle.Color     = Color3.new(1,1,1)
AimAssistCircle.Thickness = 1

Script.Functions.UpdateFOV = function ()
    if (not Circle and not AimAssistCircle) then
        return Circle and AimAssistCircle
    end
    AimAssistCircle.Visible      = getgenv().nebula.AimAssistFOV.Visible
    if getgenv().nebula.AimAssistFOV.Radius then
    AimAssistCircle.Radius       = getgenv().nebula.AimAssistFOV.Radius * 3
    end
    AimAssistCircle.Filled       = getgenv().nebula.AimAssistFOV.Filled
    AimAssistCircle.Color        = getgenv().nebula.AimAssistFOV.Color
    AimAssistCircle.Transparency = getgenv().nebula.AimAssistFOV.Transparency
    AimAssistCircle.Position      = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
    
    Circle.Visible      = getgenv().nebula.SilentFOV.Visible
    if getgenv().nebula.SilentFOV.Radius then
    Circle.Radius       = getgenv().nebula.SilentFOV.Radius * 3
    end
    Circle.Color        = getgenv().nebula.SilentFOV.Color
    Circle.Filled       = getgenv().nebula.SilentFOV.Filled
    Circle.Transparency = getgenv().nebula.SilentFOV.Transparency
    Circle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
    return Circle and AimAssistCircle
end

Script.Functions.Alive = function (plr)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("Head") ~= nil then
        return true
    end
    return false
end

Script.Functions.WTS = function (Object)
    local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
    return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

Script.Functions.OnScreen = function (Object)
    local _, screen
    _, screen = Camera:WorldToScreenPoint(Object.Position)
    if screen then
        return true
    end
    return false
end

Script.Functions.IsOnScreen = function (Object)
    local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
    return IsOnScreen
end

Script.Functions.VisibleCheck = function (Part, PartDescendant)
    local Character = Client.Character or Client.CharacterAdded.Wait(Client.CharacterAdded)
    local Origin = Camera.CFrame.Position
    local _, OnScreen = Camera.WorldToViewportPoint(Camera, Part.Position)

    if (OnScreen) then
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {Character, Camera}

        local Result = Workspace.Raycast(Workspace, Origin, Part.Position - Origin, raycastParams)

        if (Result) then
            local PartHit = Result.Instance
            local Visible = (not PartHit or Instance.new("Part").IsDescendantOf(PartHit, PartDescendant))
            
            return Visible
        end
    end
    return false
end

Script.Functions.FilterObjs = function (Object)
    if string.find(Object.Name, "Gun") then
        return
    end
    if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
        return true
    end
end

Script.Functions.GetClosestBodyPart = function (character)
    local ClosestDistance = 1/0
    local BodyPart = nil
    
    if (character and character:GetChildren()) then
        for _,  x in next, character:GetChildren() do
            if Script.Functions.FilterObjs(x) and Script.Functions.IsOnScreen(x) then
                local Distance = (Script.Functions.WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Distance < ClosestDistance) then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end
    return BodyPart
end

Script.Functions.CalculateChance = function(percentage)
    percentage = math.floor(percentage)

    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100

    return chance <= percentage / 100
end

Script.Functions.ClosestPrey2FromMouse = function()
    local Target, Closest = nil, 1 / 0
    local HitChance = Script.Functions.CalculateChance(getgenv().nebula.Silent.HitChance)

    if not HitChance then
        Target = nil
        return Target
    end
    for _, v in pairs(Players:GetPlayers()) do
        if getgenv().nebula.Silent.WallCheck then
            if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                if
                    Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position) and
                        Script.Functions.VisibleCheck(v.Character.HumanoidRootPart, v.Character)
                 then
                    local GetClosPart = tostring(Script.Functions.GetClosestBodyPart(v.Character))
                    local Position = Camera:WorldToScreenPoint(v.Character[GetClosPart].Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if GetClosPart ~= nil then
                        if (Circle.Radius > Distance and Distance < Closest) then
                            Closest = Distance
                            Target = v
                        end
                    end
                end
            end
        else
            if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                if Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position) then
                    local GetClosPart = tostring(Script.Functions.GetClosestBodyPart(v.Character))
                    local Position = Camera:WorldToScreenPoint(v.Character[GetClosPart].Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if GetClosPart ~= nil then
                        if (Circle.Radius > Distance and Distance < Closest) then
                            Closest = Distance
                            Target = v
                        end
                    end
                end
            end
        end
    end
    if getgenv().nebula.Silent.CheckIf_KO == true and Script.Functions.Alive(Target) and Target.Character:FindFirstChild("BodyEffects") then
        local KOd = Target.Character.BodyEffects:FindFirstChild("K.O").Value
        local Grabbed = Target.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
        if KOd or Grabbed then
            Target = nil
            return Target
        end
    end
    if getgenv().nebula.Silent.CheckIf_TargetDeath == true and Script.Functions.Alive(Target) then
        if Target.Character.Humanoid.health < 4 then
            Target = nil
            return Target
        end
    end
    if getgenv().nebula.Both.VisibleCheck == true and Script.Functions.Alive(Target) then
        if Target.Character.Head.Transparency == 1 then
            Target = nil
            return Target
        end
    end
    if getgenv().nebula.Both.CrewCheck == true 
        and Script.Functions.Alive(Target) 
        and Script.Functions.Alive(Client) 
        and Target:FindFirstChild("DataFolder")
        and Target.DataFolder:FindFirstChild("Information") 
        and Target.DataFolder.Information:FindFirstChild("Crew")
        and Client:FindFirstChild("DataFolder")
        and Client.DataFolder:FindFirstChild("Information") 
        and Client.DataFolder.Information:FindFirstChild("Crew") then
        if Target.DataFolder.Information:FindFirstChild("Crew").Value == Client.DataFolder.Information:FindFirstChild("Crew").Value then
            Target = nil
            return Target
        end
    end
    if getgenv().nebula.Both.TeamCheck == true and Target then
        if Target.Team == Client.Team then
            Target = nil
            return Target
        end
    end
    return Target
end



Script.Functions.ClosestPrey2FromMouse2 = function()
    local Target, Closest = nil, 1 / 0

    for _, v in pairs(Players:GetPlayers()) do
        if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
            if getgenv().nebula.AimAssist.UseCircleRadius then
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if
                    (AimAssistCircle.Radius > Distance and Distance < Closest and OnScreen) and
                        Script.Functions.VisibleCheck(v.Character.HumanoidRootPart, v.Character)
                 then
                    Closest = Distance
                    Target = v
                end
            elseif getgenv().nebula.AimAssist.WallCheck then
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                if
                    (Distance < Closest and OnScreen) and
                        Script.Functions.VisibleCheck(v.Character.HumanoidRootPart, v.Character)
                 then
                    Closest = Distance
                    Target = v
                end
            else
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                if (Distance < Closest and OnScreen) then
                    Closest = Distance
                    Target = v
                end
            end
        end
    end
    if getgenv().nebula.Both.TeamCheck == true and Target then
        if Target.Team == Client.Team then
            Target = nil
            return Target
        end
    end
    if getgenv().nebula.Both.CrewCheck == true 
        and Script.Functions.Alive(Target) 
        and Script.Functions.Alive(Client) 
        and Target:FindFirstChild("DataFolder")
        and Target.DataFolder:FindFirstChild("Information") 
        and Target.DataFolder.Information:FindFirstChild("Crew")
        and Client:FindFirstChild("DataFolder")
        and Client.DataFolder:FindFirstChild("Information") 
        and Client.DataFolder.Information:FindFirstChild("Crew") then
        if Target.DataFolder.Information:FindFirstChild("Crew").Value == Client.DataFolder.Information:FindFirstChild("Crew").Value then
            Target = nil
            return Target
        end
    end
    if getgenv().nebula.Both.VisibleCheck == true and Script.Functions.Alive(Target) then
        if Target.Character.Head.Transparency == 1 then
            Target = nil
            return Target
        end
    end
    return Target
end


Script.Functions.getToolName = function(name)
    local split = string.split(string.split(name, "[")[2], "]")[1]
    return split
end

Script.Functions.getEquippedWeaponName = function()
    if (Client.Character) and Client.Character:FindFirstChildWhichIsA("Tool") then
       local Tool =  Client.Character:FindFirstChildWhichIsA("Tool")
       if string.find(Tool.Name, "%[") and string.find(Tool.Name, "%]") and not string.find(Tool.Name, "Wallet") and not string.find(Tool.Name, "Phone") then
          return Script.Functions.getToolName(Tool.Name)
       end
    end
    return nil
end

Mouse.KeyDown:Connect(function(Key)
    local Keybind = getgenv().nebula.AimAssist.Key:lower()
    if (Key == Keybind) then
        if getgenv().nebula.AimAssist.Enabled == true then
            IsTargetting = not IsTargetting
            if IsTargetting then
                Prey2 = Script.Functions.ClosestPrey2FromMouse2()
            else
                if Prey2 ~= nil then
                    Prey2 = nil
                    IsTargetting = false
                end
            end
        end
    end
end)

Mouse.KeyUp:Connect(function(Key)
    local Keybind = getgenv().nebula.AimAssist.Key:lower()
    if (Key == Keybind) then
        if getgenv().nebula.AimAssist.Enabled == true and getgenv().nebula.AimAssist.HoldMode == true then
            Prey2 = nil
            IsTargetting = false
        end
    end
end)


Mouse.KeyDown:Connect(
    function(Key)
        local Keybind = getgenv().nebula.Silent.TriggerBotKey:lower()
        if (Key == Keybind) and getgenv().nebula.Silent.UseTriggerBotKeybind == true then
            getgenv().nebula.Silent.TriggerBot = not getgenv().nebula.Silent.TriggerBot
            if getgenv().nebula.Both.SendNotification then
                game.StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "nebula",
                        Text = "TriggerBot = " .. tostring(getgenv().nebula.Silent.TriggerBot),
                        Icon = "",
                        Duration = 1
                    }
                )
            end
        end
        local Keybind2 = getgenv().nebula.Silent.Keybind:lower()
        if (Key == Keybind2) and getgenv().nebula.Silent.UseKeybind == true then
            getgenv().nebula.Silent.Enabled = not getgenv().nebula.Silent.Enabled
            if getgenv().nebula.Both.SendNotification then
                game.StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "nebula",
                        Text = "Silent Aim = " .. tostring(getgenv().nebula.Silent.Enabled),
                        Icon = "",
                        Duration = 1
                    }
                )
            end
        end
        local Keybind3 = getgenv().nebula.Both.UnderGroundKey:lower()
        if (Key == Keybind3) and getgenv().nebula.Both.UseUnderGroundKeybind == true then
            getgenv().nebula.Both.DetectUnderGround = not getgenv().nebula.Both.DetectUnderGround
            if getgenv().nebula.Both.SendNotification then
                game.StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "nebula",
                        Text = "UnderGround Resolver = " .. tostring(getgenv().nebula.Both.DetectUnderGround),
                        Icon = "",
                        Duration = 1
                    }
                )
            end
        end
        local Keybind4 = getgenv().nebula.Both.DetectDesyncKey:lower()
        if (Key == Keybind4) and getgenv().nebula.Both.UsDetectDesyncKeybind == true then
            getgenv().nebula.Both.DetectDesync = not getgenv().nebula.Both.DetectDesync
            if getgenv().nebula.Both.SendNotification then
                game.StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "nebula",
                        Text = "Desync Resolver = " .. tostring(getgenv().nebula.Both.DetectDesync),
                        Icon = "",
                        Duration = 1
                    }
                )
            end
        end
    end
)


local grmt = getrawmetatable(game)
local backupindex = grmt.__index
setreadonly(grmt, false)

grmt.__index =
    newcclosure(
    function(self, v)
        if (getgenv().nebula.Silent.Enabled and not checkcaller() and Mouse and tostring(v) == "Hit") then
            if getgenv().nebula.Silent.FastRender == true then
                Prey = Script.Functions.ClosestPrey2FromMouse()
            end
            if Prey and Prey.Character and Prey.Character:FindFirstChild("Humanoid") then
                local OldVelocity = game.Players[tostring(Prey)].Character.HumanoidRootPart.Velocity
                if DetectedDesync then
                    local PreyMoveDirection = (game.Players[tostring(Prey)].Character.Humanoid.MoveDirection * 16)
                    local endpoint =
                        game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Part].CFrame +
                        (PreyMoveDirection * getgenv().nebula.Silent.PredictionVelocity)
                    return (tostring(v) == "Hit" and endpoint)
                elseif DetectedUnderGround then
                    local endpoint =
                        game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Part].CFrame +
                        (Vector3.new(OldVelocity.X, 0, OldVelocity.Z) *
                            getgenv().nebula.Silent.PredictionVelocity)
                    return (tostring(v) == "Hit" and endpoint)
                elseif DetectedFreeFall then
                    local endpoint =
                        game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Part].CFrame +
                        (Vector3.new(
                            OldVelocity.X,
                            (OldVelocity.Y * getgenv().nebula.Silent.AntiGroundValue),
                            OldVelocity.Z
                        ) *
                            getgenv().nebula.Silent.PredictionVelocity)
                elseif getgenv().nebula.Silent.PredictMovement then
                    if getgenv().nebula.Silent.Humanize then
                        local endpoint =
                            game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Part].CFrame +
                            (Vector3.new(
                                math.random(
                                    -getgenv().nebula.Silent.HumanizeValue,
                                    getgenv().nebula.Silent.HumanizeValue
                                ),
                                math.random(
                                    -getgenv().nebula.Silent.HumanizeValue,
                                    getgenv().nebula.Silent.HumanizeValue
                                ),
                                math.random(
                                    -getgenv().nebula.Silent.HumanizeValue,
                                    getgenv().nebula.Silent.HumanizeValue
                                )
                            ) *
                                0.01) +
                            (Vector3.new(OldVelocity.X, (OldVelocity.Y * 0.5), OldVelocity.Z) * getgenv().nebula.Silent.PredictionVelocity)
                        return (tostring(v) == "Hit" and endpoint)
                    else
                        local endpoint =
                            game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Part].CFrame +
                            (Vector3.new(OldVelocity.X, (OldVelocity.Y * 0.5), OldVelocity.Z) * getgenv().nebula.Silent.PredictionVelocity)
                        return (tostring(v) == "Hit" and endpoint)
                    end
                else
                    if getgenv().nebula.Silent.Humanize then
                        local endpoint =
                            game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Part].CFrame +
                            (Vector3.new(
                                math.random(
                                    -getgenv().nebula.Silent.HumanizeValue,
                                    getgenv().nebula.Silent.HumanizeValue
                                ),
                                math.random(
                                    -getgenv().nebula.Silent.HumanizeValue,
                                    getgenv().nebula.Silent.HumanizeValue
                                ),
                                math.random(
                                    -getgenv().nebula.Silent.HumanizeValue,
                                    getgenv().nebula.Silent.HumanizeValue
                                )
                            ) *
                                0.01)
                        return (tostring(v) == "Hit" and endpoint)
                    else
                        local endpoint =
                            game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Part].CFrame
                        return (tostring(v) == "Hit" and endpoint)
                    end
                end
            end
        end
        return backupindex(self, v)
    end
)


task.spawn(function ()
    while task.wait() do
        if getgenv().nebula.Silent.Enabled and getgenv().nebula.Silent.FastRender == false then
            Prey = Script.Functions.ClosestPrey2FromMouse()
        end
        if Prey2 then
            if getgenv().nebula.AimAssist.Enabled and (Prey2.Character) and getgenv().nebula.AimAssist.ClosestPart then
                getgenv().nebula.AimAssist.Part = tostring(Script.Functions.GetClosestBodyPart(Prey2.Character))
            end
        end
    	if getgenv().nebula.Silent.Enabled then
    		if getgenv().nebula.SilentAutoPrediction.Enable then
                local ping = Client:GetNetworkPing() * 2000
    		    if ping > 160 then
    		        getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["Over"]
    		    elseif ping < 160 then
    		        getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["160"]
    		    elseif ping < 150 then
    		        getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["150"]
    		    elseif ping < 140 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["140"]
                elseif ping < 130 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["130"]
                elseif ping > 120 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["120"]
                elseif ping < 110 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["110"]
                elseif ping < 100 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["100"]
                elseif ping < 90 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["90"]
                elseif ping < 80 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["80"]
                elseif ping < 70 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["70"]
                elseif ping < 60 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["60"]
                elseif ping < 50 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["50"]
                elseif ping < 40 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["40"]
                elseif ping < 30 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["30"]
                elseif ping < 20 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["20"]
                elseif ping < 10 then
                    getgenv().nebula.Silent.PredictionVelocity = getgenv().nebula.SilentAutoPrediction["10"]
                end
            end
    	end
    end
end)

Script.Functions.ResolverFunc = function ()
	if getgenv().nebula.Silent.Enabled then
	    if Prey then
    	    if Script.Functions.Alive(Prey) then
    	        if Prey.Character:FindFirstChild(getgenv().nebula.Silent.Part)then
                    if getgenv().nebula.Both.DetectDesync == true then
                        if Prey.Character.HumanoidRootPart.Velocity.magnitude > getgenv().nebula.Both.DesyncDetection or (Prey.Character.HumanoidRootPart.Velocity.magnitude < 1 and Prey.Character.Humanoid.MoveDirection.magnitude > 0.1) then            
                            DetectedDesync = true
                        else
                            DetectedDesync = false
                        end
                    else
                        if DetectedDesync ~= false then
                            DetectedDesync = false
                        end
                    end
                    if getgenv().nebula.Silent.AntiGroundShots == true then
                        if Prey.Character.HumanoidRootPart.Velocity.Y < getgenv().nebula.Silent.WhenAntiGroundActivate then
                            DetectedFreeFall = true
                        else
                            if DetectedFreeFall ~= false then
                                DetectedFreeFall = false
                            end
                        end
                    end
                    if getgenv().nebula.Both.DetectUnderGround == true then 
                        if Prey.Character.HumanoidRootPart.Velocity.Y < getgenv().nebula.Both.UnderGroundDetection then            
                            DetectedUnderGround = true
                        else
                            DetectedUnderGround = false
                        end
                    else
                        if DetectedUnderGround ~= false then
                            DetectedUnderGround = false
                        end
                    end
    	        end
                if getgenv().nebula.Silent.ClosestPart then
                    getgenv().nebula.Silent.Part = tostring(Script.Functions.GetClosestBodyPart(Prey.Character))
                end
                if getgenv().nebula.Silent.UseAirPart == true then
                    if Prey.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                        getgenv().nebula.Silent.Part = getgenv().nebula.Silent.AirPart
                    else
                        getgenv().nebula.Silent.Part = OldSilentAimPart
                    end
                end
                 if getgenv().nebula.Silent.TriggerBot == true  then
					mouse1click()
				end
    	    end
	    end
	end
    if getgenv().nebula.AimAssist.Enabled == true then
        if Prey2 then
            if Script.Functions.Alive(Prey2) then
                if getgenv().nebula.Both.DetectDesync == true then
                    if Prey2.Character.HumanoidRootPart.Velocity.magnitude > getgenv().nebula.Both.DesyncDetection or (Prey2.Character.HumanoidRootPart.Velocity.magnitude < 1 and Prey2.Character.Humanoid.MoveDirection.magnitude > 0.1)then
                        DetectedDesyncV2 = true
                    else
                        DetectedDesyncV2 = false
                    end
                else
                    if DetectedDesyncV2 ~= false then
                        DetectedDesyncV2 = false
                    end
                end
                if getgenv().nebula.Both.DetectUnderGround == true and Prey2.Character:FindFirstChild("HumanoidRootPart") then 
                    if Prey2.Character.HumanoidRootPart.Velocity.Y < getgenv().nebula.Both.UnderGroundDetection then            
                            DetectedUnderGround2 = true
                    else
                        DetectedUnderGround2 = false
                    end
                else
                    if DetectedUnderGround2 ~= false then
                        DetectedUnderGround2 = false
                    end
                end
            end
        end
    end
end

Script.Functions.AimAssistFunc = function ()
    if getgenv().nebula.AimAssist.Enabled == true then
        if Prey2 then
            if Script.Functions.Alive(Prey2) then
        		if getgenv().nebula.AimAssist.DisableTargetDeath == true then
        			if Prey2.Character.Humanoid.health < 4 then
        				Prey2 = nil
        				IsTargetting = false
        			end
        		end
        		if getgenv().nebula.AimAssist.DisableLocalDeath == true and Script.Functions.Alive(Client) then
        			if Client.Character.Humanoid.health < 4 then
        				Prey2 = nil
        				IsTargetting = false
        			end
        		end
                if getgenv().nebula.AimAssist.DisableOn_KO == true and Prey2.Character:FindFirstChild("BodyEffects") then 
                    local KOd = Prey2.Character.BodyEffects:FindFirstChild("K.O").Value
                    local Grabbed = Prey2.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                    if KOd or Grabbed then
        				Prey2 = nil
        				IsTargetting = false
                    end
                end
                if getgenv().nebula.AimAssist.DisableOutSideCircle == true then
                    if
                    AimAssistCircle.Radius <
                        (Vector2.new(
                            Camera:WorldToScreenPoint(Prey2.Character.HumanoidRootPart.Position).X,
                            Camera:WorldToScreenPoint(Prey2.Character.HumanoidRootPart.Position).Y
                        ) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                     then
                        Prey2 = nil
                        IsTargetting = false
                    end
                end
                if Script.Functions.Alive(Prey2) and Script.Functions.OnScreen(Prey2.Character[getgenv().nebula.AimAssist.Part]) then
					if
						DetectedDesyncV2 and Prey2.Character:FindFirstChild(getgenv().nebula.AimAssist.Part) and
							getgenv().nebula.AimAssist.PredictMovement == true
					 then
						local Prey2MoveDirection = (Prey2.Character.Humanoid.MoveDirection * 16)
						local Vector =
							Camera:WorldToScreenPoint(
							Prey2.Character[getgenv().nebula.AimAssist.Part].Position +
								(Prey2MoveDirection * getgenv().nebula.AimAssist.PredictionVelocity)
						)
						local incrementX = (Vector.X - Mouse.X) * getgenv().nebula.AimAssist.Smoothnes
						local incrementY = (Vector.Y - Mouse.Y) * getgenv().nebula.AimAssist.Smoothnes
						mousemoverel(incrementX, incrementY)
					elseif
						DetectedUnderGround2 and Prey2.Character:FindFirstChild(getgenv().nebula.AimAssist.Part) and
							getgenv().nebula.AimAssist.PredictMovement == true
					 then
						local Vector =
							Camera:WorldToScreenPoint(
							Prey2.Character[getgenv().nebula.AimAssist.Part].Position +
								(Vector3.new(
									Prey2.Character[getgenv().nebula.AimAssist.Part].Velocity.X,
									0,
									Prey2.Character[getgenv().nebula.AimAssist.Part].Velocity.Z
								) *
									getgenv().nebula.AimAssist.PredictionVelocity)
						)
						local incrementX = (Vector.X - Mouse.X) * getgenv().nebula.AimAssist.Smoothnes
						local incrementY = (Vector.Y - Mouse.Y) * getgenv().nebula.AimAssist.Smoothnes
						mousemoverel(incrementX, incrementY)
					elseif
						getgenv().nebula.AimAssist.PredictMovement and
							Prey2.Character:FindFirstChild(getgenv().nebula.AimAssist.Part)
					 then
						if getgenv().nebula.AimAssist.UseShake then
							local Vector =
								Camera:WorldToScreenPoint(
								Prey2.Character[getgenv().nebula.AimAssist.Part].Position +
									Prey2.Character[getgenv().nebula.AimAssist.Part].Velocity *
										getgenv().nebula.AimAssist.PredictionVelocity +
									Vector3.new(
										math.random(
											-getgenv().nebula.AimAssist.ShakeValue,
											getgenv().nebula.AimAssist.ShakeValue
										),
										math.random(
											-getgenv().nebula.AimAssist.ShakeValue,
											getgenv().nebula.AimAssist.ShakeValue
										),
										math.random(
											-getgenv().nebula.AimAssist.ShakeValue,
											getgenv().nebula.AimAssist.ShakeValue
										)
									) *
										0.1
							)
							local incrementX = (Vector.X - Mouse.X) * getgenv().nebula.AimAssist.Smoothnes
							local incrementY = (Vector.Y - Mouse.Y) * getgenv().nebula.AimAssist.Smoothnes
							mousemoverel(incrementX, incrementY)
						else
							local Vector =
								Camera:WorldToScreenPoint(
								Prey2.Character[getgenv().nebula.AimAssist.Part].Position +
									Prey2.Character[getgenv().nebula.AimAssist.Part].Velocity *
										getgenv().nebula.AimAssist.PredictionVelocity
							)
							local incrementX = (Vector.X - Mouse.X) * getgenv().nebula.AimAssist.Smoothnes
							local incrementY = (Vector.Y - Mouse.Y) * getgenv().nebula.AimAssist.Smoothnes
							mousemoverel(incrementX, incrementY)
						end
					elseif
						getgenv().nebula.AimAssist.PredictMovement == false and
							Prey2.Character:FindFirstChild(getgenv().nebula.AimAssist.Part)
					 then
						if getgenv().nebula.AimAssist.UseShake then
							local Vector =
								Camera:WorldToScreenPoint(
								Prey2.Character[getgenv().nebula.AimAssist.Part].Position +
									Vector3.new(
										math.random(
											-getgenv().nebula.AimAssist.ShakeValue,
											getgenv().nebula.AimAssist.ShakeValue
										),
										math.random(
											-getgenv().nebula.AimAssist.ShakeValue,
											getgenv().nebula.AimAssist.ShakeValue
										),
										math.random(
											-getgenv().nebula.AimAssist.ShakeValue,
											getgenv().nebula.AimAssist.ShakeValue
										)
									) *
										0.1
							)
							local incrementX = (Vector.X - Mouse.X) * getgenv().nebula.AimAssist.Smoothnes
							local incrementY = (Vector.Y - Mouse.Y) * getgenv().nebula.AimAssist.Smoothnes
							mousemoverel(incrementX, incrementY)
						else
							local Vector = Camera:WorldToScreenPoint(Prey2.Character[getgenv().nebula.AimAssist.Part].Position)
							local incrementX = (Vector.X - Mouse.X) * getgenv().nebula.AimAssist.Smoothnes
							local incrementY = (Vector.Y - Mouse.Y) * getgenv().nebula.AimAssist.Smoothnes
							mousemoverel(incrementX, incrementY)
						end
					end
				end
			end
		end
	end
end

Script.Functions.GunFovFunc = function ()
    if getgenv().nebula.GunFOV.Enabled == true then
        local WeaponSettings = getgenv().nebula.GunFOV[Script.Functions.getEquippedWeaponName()]
        if WeaponSettings ~= nil then
            getgenv().nebula.SilentFOV.Radius = WeaponSettings.FOV
        else
            getgenv().nebula.SilentFOV.Radius = getgenv().nebula.SilentFOV.Radius
        end
    end
    if getgenv().nebula.RangeFOV.Enabled == true then
        local WeaponSettingsV2 = getgenv().nebula.RangeFOV[Script.Functions.getEquippedWeaponName()]
        if WeaponSettingsV2 ~= nil and Prey then
            if Script.Functions.Alive(Prey) then
                if (Prey.Character.HumanoidRootPart.Position - Client.Character.HumanoidRootPart.Position).Magnitude < getgenv().nebula.RangeFOV.Close_Activation then
                	getgenv().nebula.SilentFOV.Radius = WeaponSettingsV2.CLOSE
                elseif (Prey.Character.HumanoidRootPart.Position - Client.Character.HumanoidRootPart.Position).Magnitude < getgenv().nebula.RangeFOV.Medium_Activation then
                	getgenv().nebula.SilentFOV.Radius = WeaponSettingsV2.MED
                elseif (Prey.Character.HumanoidRootPart.Position - Client.Character.HumanoidRootPart.Position).Magnitude < getgenv().nebula.RangeFOV.Far_Activation then
                	getgenv().nebula.SilentFOV.Radius = WeaponSettingsV2.FAR
                end
            end
        end
    end
end

RS.Heartbeat:Connect(Script.Functions.GunFovFunc)

RS.Heartbeat:Connect(Script.Functions.AimAssistFunc)

RS.Heartbeat:Connect(Script.Functions.ResolverFunc)

RS.Heartbeat:Connect(Script.Functions.UpdateFOV)
        else
            print("Not whitelisted")
            plr:Kick("Not whitelisted") -- Kick message.
        end
    end
end)
