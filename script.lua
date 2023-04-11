local allowedUsers = {

    ["dumpthatknocka"] = true,
    ["person2"] = true,
    ["person3"] = true,
    ["person4"] = true,
}
 
game.Players.PlayerAdded:Connect(function(plr)
    if allowedUsers[plr.Name] then
        local Prey = nil
 local Plr  = nil
 
 local Players, Client, Mouse, RS, Camera =
     game:GetService("Players"),
     game:GetService("Players").LocalPlayer,
     game:GetService("Players").LocalPlayer:GetMouse(),
     game:GetService("RunService"),
     game:GetService("Workspace").CurrentCamera
 
 local Circle       = Drawing.new("Circle")
 local CamlockCircle = Drawing.new("Circle")
 
 Circle.Color           = Color3.new(125,100,255)
 Circle.Thickness       = 1.5
 CamlockCircle.Color     = Color3.new(125,100,255)
 CamlockCircle.Thickness = 1.5
 
 local UpdateFOV = function ()
     if (not Circle and not CamlockCircle) then
         return Circle and CamlockCircle
     end
     CamlockCircle.Visible  = getgenv().nebula.CamlockFOV.Visible
     CamlockCircle.Radius   = getgenv().nebula.CamlockFOV.Radius * 2
     CamlockCircle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
     
     Circle.Visible  = getgenv().nebula.SilentFOV.Visible
     Circle.Radius   = getgenv().nebula.SilentFOV.Radius * 2
     Circle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
     return Circle and CamlockCircle
 end
 
 RS.Heartbeat:Connect(UpdateFOV)
 
 local WallCheck = function(destination, ignore)
     local Origin    = Camera.CFrame.p
     local CheckRay  = Ray.new(Origin, destination - Origin)
     local Hit       = game.workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
     return Hit      == nil
 end
 
 local WTS = function (Object)
     local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
     return Vector2.new(ObjectVector.X, ObjectVector.Y)
 end
 
 local IsOnScreen = function (Object)
     local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
     return IsOnScreen
 end
 
 local FilterObjs = function (Object)
     if string.find(Object.Name, "Gun") then
         return
     end
     if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
         return true
     end
 end
 
 local ClosestPlrFromMouse = function()
     local Target, Closest = nil, 1/0
     
     for _ ,v in pairs(Players:GetPlayers()) do
         if getgenv().nebula.Silent.WallCheck then
             if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                 local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                 local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
     
                 if (Circle.Radius > Distance and Distance < Closest and OnScreen) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
                     Closest = Distance
                     Target = v
                 end
             end
         else
             if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                 local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                 local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
     
                 if (Circle.Radius > Distance and Distance < Closest and OnScreen) then
                     Closest = Distance
                     Target = v
                 end
             end
         end
     end
     return Target
 end
 
 local ClosestPlrFromMouse2 = function()
     local Target, Closest = nil, CamlockCircle.Radius * 1.5
     
     for _ ,v in pairs(Players:GetPlayers()) do
         if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
             if getgenv().nebula.Camlock.WallCheck then
                 local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                 local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
         
                 if (Distance < Closest and OnScreen) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
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
     return Target
 end
 
 local GetClosestBodyPart = function (character)
     local ClosestDistance = 1/0
     local BodyPart = nil
     
     if (character and character:GetChildren()) then
         for _,  x in next, character:GetChildren() do
             if FilterObjs(x) and IsOnScreen(x) then
                 local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                 if (Circle.Radius > Distance and Distance < ClosestDistance) then
                     ClosestDistance = Distance
                     BodyPart = x
                 end
             end
         end
     end
     return BodyPart
 end
 
 local GetClosestBodyPartV2 = function (character)
     local ClosestDistance = 1/0
     local BodyPart = nil
     
     if (character and character:GetChildren()) then
         for _,  x in next, character:GetChildren() do
             if FilterObjs(x) and IsOnScreen(x) then
                 local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                 if (Distance < ClosestDistance) then
                     ClosestDistance = Distance
                     BodyPart = x
                 end
             end
         end
     end
     return BodyPart
 end
 
 Mouse.KeyDown:Connect(function(Key)
     local Keybind = getgenv().nebula.Camlock.Keybind:lower()
     if (Key == Keybind) then
         if getgenv().nebula.Camlock.Enabled == true then
             IsTargetting = not IsTargetting
             if IsTargetting then
                 Plr = ClosestPlrFromMouse2()
             else
                 if Plr ~= nil then
                     Plr = nil
                     IsTargetting = false
                 end
             end
         end
     end
 end)
 
 Mouse.KeyDown:Connect(function(Key)
     local Keybind = getgenv().nebula.Silent.Keybind:lower()
     if (Key == Keybind) and getgenv().nebula.Silent.KeybindEnabled == true then
             if getgenv().nebula.Silent.Enabled == true then
                 getgenv().nebula.Silent.Enabled = false
                 if getgenv().nebula.Misc.SendNotifications then
                     game.StarterGui:SetCore(
                         "SendNotification",
                         {
                             Title = "nebula",
                             Text = "Disabled Silent Aim",
                             Icon = "",
                             Duration = 1
                         }
                     )
                 end
             else
                 getgenv().nebula.Silent.Enabled = true
                 if getgenv().nebula.Misc.SendNotifications then
                     game.StarterGui:SetCore(
                         "SendNotification",
                         {
                             Title = "nebula",
                             Text = "Enabled Silent Aim",
                             Icon = "",
                             Duration = 1
                         }
                     )
                 end
             end
         end
     end
 )
 
 
 
 local grmt = getrawmetatable(game)
 local backupindex = grmt.__index
 setreadonly(grmt, false)
 
 grmt.__index = newcclosure(function(self, v)
     if (getgenv().nebula.Silent.Enabled and Mouse and tostring(v) == "Hit") then
         if Prey and Prey.Character then
             if getgenv().nebula.Silent.PredictionEnabled then
                 local endpoint = game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Aimpart].CFrame + (
                     game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Aimpart].Velocity * getgenv().nebula.Silent.Prediction
                 )
                 return (tostring(v) == "Hit" and endpoint)
             else
                 local endpoint = game.Players[tostring(Prey)].Character[getgenv().nebula.Silent.Aimpart].CFrame
                 return (tostring(v) == "Hit" and endpoint)
             end
         end
     end
     return backupindex(self, v)
 end)
 
 
 
 RS.Heartbeat:Connect(function()
     if getgenv().nebula.Silent.Enabled then
         if Prey and Prey.Character and Prey.Character:WaitForChild(getgenv().nebula.Silent.Aimpart) then
             if getgenv().nebula.Misc.DesyncResolver == true and Prey.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude > getgenv().nebula.Misc.DesyncDetection then            
                 pcall(function()
                     local TargetVel = Prey.Character[getgenv().nebula.Silent.Aimpart]
                     TargetVel.Velocity = Vector3.new(0, 0, 0)
                     TargetVel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                 end)
             end
             if getgenv().nebula.Silent.AntiGroundShots == true and Prey.Character:FindFirstChild("Humanoid") == Enum.HumanoidStateType.Freefall then
                 pcall(function()
                     local TargetVelv5 = Prey.Character[getgenv().nebula.Silent.Aimpart]
                     TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.5), TargetVelv5.Velocity.Z)
                     TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.5), TargetVelv5.Velocity.Z)
                 end)
             end
             if getgenv().nebula.Misc.MainResolver == true then            
                 pcall(function()
                     local TargetVelv2 = Prey.Character[getgenv().nebula.Silent.Aimpart]
                     TargetVelv2.Velocity = Vector3.new(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
                     TargetVelv2.AssemblyLinearVelocity = Vector3.new(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
                 end)
             end
         end
     end
     if getgenv().nebula.Camlock.Enabled == true then
         if getgenv().nebula.Misc.DesyncResolver == true and Plr and Plr.Character and Plr.Character:WaitForChild(getgenv().nebula.Camlock.Aimpart) and Plr.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude > getgenv().nebula.Misc.DesyncDetection then
             pcall(function()
                 local TargetVelv3 = Plr.Character[getgenv().nebula.Camlock.Aimpart]
                 TargetVelv3.Velocity = Vector3.new(0, 0, 0)
                 TargetVelv3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
             end)
         end
         if getgenv().nebula.Misc.MainResolver == true and Plr and Plr.Character and Plr.Character:WaitForChild(getgenv().nebula.Camlock.Aimpart)then
             pcall(function()
                 local TargetVelv4 = Plr.Character[getgenv().nebula.Camlock.Aimpart]
                 TargetVelv4.Velocity = Vector3.new(TargetVelv4.Velocity.X, 0, TargetVelv4.Velocity.Z)
                 TargetVelv4.AssemblyLinearVelocity = Vector3.new(TargetVelv4.Velocity.X, 0, TargetVelv4.Velocity.Z)
             end)
         end
     end
 end)
 
 RS.RenderStepped:Connect(function()
     if getgenv().nebula.Silent.Enabled then
         if getgenv().nebula.Silent.CheckForTargetDeath == true and Prey and Prey.Character then 
             local KOd = Prey.Character:WaitForChild("BodyEffects")["K.O"].Value
             local Grabbed = Prey.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
             if KOd or Grabbed then
                 Prey = nil
             end
         end
     end
     if getgenv().nebula.Camlock.Enabled == true then
         if getgenv().nebula.Camlock.CheckForTargetDeath == true and Plr and Plr.Character then 
             local KOd = Plr.Character:WaitForChild("BodyEffects")["K.O"].Value
             local Grabbed = Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
             if KOd or Grabbed then
                 Plr = nil
                 IsTargetting = false
             end
         end
         if getgenv().nebula.Camlock.DisableOnTargetDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
             if Plr.Character.Humanoid.health < 4 then
                 Plr = nil
                 IsTargetting = false
             end
         end
         if getgenv().nebula.Camlock.DisableOnPlayerDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
             if Client.Character.Humanoid.health < 4 then
                 Plr = nil
                 IsTargetting = false
             end
         end
         if getgenv().nebula.Camlock.DisableOutSideOfFOV == true and Plr and Plr.Character and Plr.Character:WaitForChild("HumanoidRootPart") then
             if
             CamlockCircle.Radius <
                 (Vector2.new(
                     Camera:WorldToScreenPoint(Plr.Character.HumanoidRootPart.Position).X,
                     Camera:WorldToScreenPoint(Plr.Character.HumanoidRootPart.Position).Y
                 ) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
              then
                 Plr = nil
                 IsTargetting = false
             end
         end
         if getgenv().nebula.Camlock.PredictionEnabled and Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().nebula.Camlock.Aimpart) then
             if getgenv().nebula.Camlock.CamShake then
                 local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().nebula.Camlock.Aimpart].Position + Plr.Character[getgenv().nebula.Camlock.Aimpart].Velocity * getgenv().nebula.Camlock.Prediction +
                 Vector3.new(
                     math.random(-getgenv().nebula.Camlock.CamShakeValue, getgenv().nebula.Camlock.CamShakeValue),
                     math.random(-getgenv().nebula.Camlock.CamShakeValue, getgenv().nebula.Camlock.CamShakeValue),
                     math.random(-getgenv().nebula.Camlock.CamShakeValue, getgenv().nebula.Camlock.CamShakeValue)
                 ) * 0.1)
                 Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().nebula.Camlock.Smoothness / 2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
             else
                 local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().nebula.Camlock.Aimpart].Position + Plr.Character[getgenv().nebula.Camlock.Aimpart].Velocity * getgenv().nebula.Camlock.Prediction)
                 Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().nebula.Camlock.Smoothness / 2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
             end
         elseif getgenv().nebula.Camlock.PredictionEnabled == false and Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().nebula.Camlock.Aimpart) then
             if getgenv().nebula.Camlock.CamShake then
                 local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().nebula.Camlock.Aimpart].Position +
                 Vector3.new(
                     math.random(-getgenv().nebula.Camlock.CamShakeValue, getgenv().nebula.Camlock.CamShakeValue),
                     math.random(-getgenv().nebula.Camlock.CamShakeValue, getgenv().nebula.Camlock.CamShakeValue),
                     math.random(-getgenv().nebula.Camlock.CamShakeValue, getgenv().nebula.Camlock.CamShakeValue)
                 ) * 0.1)
                 Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().nebula.Camlock.Smoothness / 2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
             else
                 local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().nebula.Camlock.Aimpart].Position)
                 Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().nebula.Camlock.Smoothness / 2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
             end
         end
     end
 end)
 
 task.spawn(function ()
     while task.wait() do
         if getgenv().nebula.Silent.Enabled then
             Prey = ClosestPlrFromMouse()
         end
         if Plr then
             if getgenv().nebula.Camlock.Enabled and (Plr.Character) and getgenv().nebula.Camlock.ClosestPart then
                 getgenv().nebula.Camlock.Aimpart = tostring(GetClosestBodyPartV2(Plr.Character))
             end
         end
         if Prey then
             if getgenv().nebula.Silent.Enabled and (Prey.Character) and getgenv().nebula.Silent.ClosestPart then
                 getgenv().nebula.Silent.Aimpart = tostring(GetClosestBodyPart(Prey.Character))
             end
         end
     end
 end)
 
 local Script = {Functions = {}}
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
     RS.RenderStepped:Connect(function()
     if Script.Functions.getEquippedWeaponName() ~= nil then
         local WeaponSettings = getgenv().nebula.GunFOV[Script.Functions.getEquippedWeaponName()]
         if WeaponSettings ~= nil and getgenv().nebula.GunFOV.Enabled == true then
             getgenv().nebula.SilentFOV.Radius = WeaponSettings.FOV
         else
             getgenv().nebula.SilentFOV.Radius = getgenv().nebula.SilentFOV.Radius
         end
     end
 end)
 
 
     
 
 while getgenv().nebula.Silent.AutoPrediction == true do
     local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
     local pingValue = string.split(ping, " ")[1]
     local pingNumber = tonumber(pingValue)
    
     if pingNumber < 30 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP20)
     elseif pingNumber < 40 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP30)
     elseif pingNumber < 50 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP40)
     elseif pingNumber < 60 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP50)
     elseif pingNumber < 70 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP60)
     elseif pingNumber < 80 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP70)
     elseif pingNumber < 90 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP80)
     elseif pingNumber < 100 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP90)
     elseif pingNumber < 110 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP100)
          elseif pingNumber < 120 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP110)
          elseif pingNumber < 130 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP120)
          elseif pingNumber < 140 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP130)
          elseif pingNumber < 150 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP140)
          elseif pingNumber < 160 then
         nebula.Silent.Prediction = (getgenv().nebula.AutoPrediction.AutoP150)
     end
  
     wait(1)
 end
    else
        warn(plr.Name.." is not whitelisted.")
        plr:Kick("You are not whitelisted!")
    end
end)
