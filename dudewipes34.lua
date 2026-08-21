loadstring(game:HttpGet("https://scripts.wabisabi.mom/wabi-sabi-ui-lib.lua"))()
local Library = WabiSabi

version = 1.1

local Window = Library:CreateWindow({
    Title = "San Aurie | v"..tostring(version),
    SubTitle = game.Players.LocalPlayer.Name,
    Size = Vector2.new(580, 460),
    Resize = true,
})

local Car = Window:AddTab({ Title = "Car Options", Icon = "car" })
local World = Window:AddTab({ Title = "World Options", Icon = "globe" })
local Job = Window:AddTab({ Title = "Auto Options", Icon = "cog" })
local Settings = Window:AddTab({ Title = "Settings", Icon = "house" })

local UserInputService = game:GetService("UserInputService")
local DebrisService = game:GetService("Debris")
local RunService = game:GetService("RunService")
local carspeedEnabled = false
local carspeed = 20
local boostspeed = 20
terminate = false

local carTPs = {
    Dealership = CFrame.new(3771.96, 0.82, -392.02),
    Transit = CFrame.new(4163.10, 0.82, 977.51),
    Delivery = CFrame.new(4412.53, 0.82, 1603.18),
    RoadService = CFrame.new(4303.75, 0.81, 1208.98),
    Farm = CFrame.new(-1268.81, 0.78, 2564.53),
    Arcade = CFrame.new(2904.27, 0.82, 1692.29),
    Prison = CFrame.new(-1684.89, 1.05, 1186.17),
    Fish = CFrame.new(-65.94, -26.64, 1424.48),
    GunStore = CFrame.new(-315.74, 0.83, 27.48),
    Bank = CFrame.new(-669.17, 0.82, -63.56),
    Police = CFrame.new(3305.16, 0.83, -429.12),
    Fire = CFrame.new(3523.42, 0.87, 541.04),
    Hospital = CFrame.new(3860.53, 1.06, -188.50),
    PawnShop = CFrame.new(-192.03, 0.84, -122.52),
    Supermarket = CFrame.new(3934.38, 0.87, 1158.90),
    Sautoshop = CFrame.new(-396.72, 0.87, 6.37),
    Nautoshop = CFrame.new(2804.74, 0.86, -409.17),
    NorthDock = CFrame.new(4515.74, -26.86, -266.19),
    BlackMarket = CFrame.new(1112.16, -26.81, 1036.99),
    Race = CFrame.new(-854.14, 0.77, 2343.31),
    NWgas = CFrame.new(4500.20, -26.61, 113.21),
    Sgas = CFrame.new(-938.55, 0.83, 1113.19),
    SEgas = CFrame.new(-1626.49, 0.85, 1793.84),
    Cgas = CFrame.new(2252.09, 0.85, 96.93),
    SWgas = CFrame.new(1152.28, 0.84, -844.14),
    Sresidential = CFrame.new(-466.75, 1.04, 1319.56),
    Nresidential = CFrame.new(3688.47, 98.77, 1909.96)
}

-- Functions >~<

local car = nil
isDriving = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.W and car and car.Config.On.Value == true then
        isDriving = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        isDriving = false
    end
end)

function findCar()
    for i,v in pairs(game.Workspace.Gameplay.Vehicles:GetChildren()) do
        if string.find(tostring(v.Config.LastDrove.Value),game.Players.LocalPlayer.Name) then
            return v
        else
            continue
        end
    end
end

function carTP(Location,car)
    if car and car.Config.On.Value == true then
        car.PrimaryPart.CFrame = carTPs[Location]
        car.PrimaryPart.Velocity = Vector3.new(0,0,0)
    else
Library:Notify({
    Title = "Error",
    Content = "No Car to teleport",
    SubContent = "Get in a car to use this feature.",
    Duration = 4,
})
    end
end

function carBoost(car)
    if car and car.Config.On.Value == true then
        car.PrimaryPart.Velocity = car.PrimaryPart.Velocity + car.PrimaryPart.CFrame.LookVector * boostspeed
    else
Library:Notify({
    Title = "Error",
    Content = "No Car to boost",
    SubContent = "Get in a car to use this feature.",
    Duration = 4,
})
    end
end

function verticalCBoost(car)
    	if car and car.Config.On.Value == true then
        	car.PrimaryPart.Velocity = car.PrimaryPart.Velocity + Vector3.new(0,1,0) * boostspeed
    	else
Library:Notify({
    Title = "Error",
    Content = "No Car to boost",
    SubContent = "Get in a car to use this feature.",
    Duration = 4,
})
    	end
end

function finishBusRoute(car)
    if car and car.Name == "New Flyer D40" and game.Workspace.Gameplay.Entities.ClientContent:FindFirstChildOfClass("Part") then
        repeat
        if terminate == true then
            break
        end
        car.PrimaryPart.CFrame = game.Workspace.Gameplay.Entities.ClientContent:FindFirstChildOfClass("Part").CFrame
        car.PrimaryPart.Velocity = Vector3.new(0,0,0)
        task.wait(7)
        until not game.Workspace.Gameplay.Entities.ClientContent:FindFirstChildOfClass("Part")
    else
Library:Notify({
    Title = "Error",
    Content = "No bus or route?",
    SubContent = "Get in a bus and start a route to use this feature.",
    Duration = 4,
})
    end
end

function finishPizza(car)
    if car and car.Name == "Vespa N 50" and game.Workspace.Gameplay.Entities.ClientContent:FindFirstChildOfClass("Part") then
        car.PrimaryPart.CFrame = game.Workspace.Gameplay.Entities.ClientContent:FindFirstChildOfClass("Part").CFrame
        car.PrimaryPart.Velocity = Vector3.new(0,0,0)
        task.wait(7)
        repeat
            if terminate == true then
                break
            end


        until not game.Workspace.Gameplay.Entities.ClientContent:FindFirstChildOfClass("Part")
        else
Library:Notify({
    Title = "Error",
    Content = "No pizza route?",
    SubContent = "Get in a Vespa and start a route to use this feature.",
    Duration = 4,
})
        end
end

RunService.RenderStepped:Connect(function(dt)
    if carspeedEnabled then
        local car = findCar()
        if car and car.Config.On.Value == true and isDriving then
            car.PrimaryPart.Velocity = car.PrimaryPart.CFrame.LookVector * carspeed

            else

        end


    end
end)

-- Vehicle options

local CarTeleport = Car:AddDropdown({
    Id = "cartp",
    Title = "Car Teleport",
    Values = {"Dealership", "Transit", "Delivery", "RoadService", "Farm", "Arcade", "Prison", "Fish", "GunStore", "Bank", "Police", "Fire", "Hospital", "PawnShop", "Supermarket", "Sautoshop", "Nautoshop", "NorthDock", "BlackMarket", "Race", "NWgas", "Sgas", "SEgas", "Cgas", "SWgas", "Sresidential", "Nresidential"},
    Default = "Dealership",
    Callback = function(value)
    local car = findCar()
    task.wait()
    if car and car.Config.On.Value == true then
        carTP(value,car)
    else
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = carTPs[value]
    end
end})

local CarBoost = Car:AddKeybind({
    Id = "carboost",
    Title = "Car Boost",
    Default = "Shift",
    --Mode = "Hold",
    Callback = function(state)

    local c = findCar()

    if c and c.Config.On.Value == true then
        c.PrimaryPart.Velocity =
        c.PrimaryPart.Velocity + c.PrimaryPart.CFrame.LookVector * boostspeed
    end
end
})

local CarBoost2 = Car:AddKeybind({
    Id = "carboost2",
    Title = "Negative Car Boost",
    Default = "Ctrl",
    --Mode = "Hold",
    Callback = function(state)

    local c = findCar()

    if c and c.Config.On.Value == true then
        c.PrimaryPart.Velocity =
        c.PrimaryPart.Velocity + c.PrimaryPart.CFrame.LookVector * -boostspeed
    end
end
})

local CarBoost3 = Car:AddKeybind({
    Id = "carboost3",
    Title = "Vertical Car Boost",
    Default = "Alt",
    --Mode = "Hold",
    Callback = function(state)
    local c = findCar()
    if c and c.Config.On.Value == true then
        c.PrimaryPart.Velocity =
        c.PrimaryPart.Velocity + Vector3.new(0,-1,0) * -boostspeed
    end
end
})

local CarBoostSlider = Car:AddSlider({
    Id = "boostspeed",
    Title = "Boost Speed",
    Min = 1, Max = 300,
    Default = 20,
    Rounding = 0,
    Callback = function(value, oldValue)
    boostspeed = value
end})

local CarSpeedT = Car:AddToggle({
    Id = "carspeed",
    Title = "Car Speed",
    Default = false,
    Keybind = "F1",
Callback = function(value)
    carspeedEnabled = value
end})

local CarSpeedSlider = Car:AddSlider({
    Id = "carspeedslider",
    Title = "Car Speed",
    Min = 15, Max = 200,
    Default = 15,
    Rounding = 0,
    Callback = function(value, oldValue)
    carspeed = value
end})

local PlrTeleport = World:AddDropdown({
    Id = "plrtp",
    Title = "Player Teleport",
    Values = {"Dealership", "Transit", "Delivery", "RoadService", "Farm", "Arcade", "Prison", "Fish", "GunStore", "Bank", "Police", "Fire", "Hospital", "PawnShop", "Supermarket", "Sautoshop", "Nautoshop", "NorthDock", "BlackMarket", "Race", "NWgas", "Sgas", "SEgas", "Cgas", "SWgas", "Sresidential", "Nresidential"},
    Default = "Dealership",
    Callback = function(value)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = carTPs[value]
end})

local PanicTP = World:AddKeybind({
    Id = "panictp",
    Title = "Panic Teleport",
    Default = "Z",
    --Mode = "Hold",
    Callback = function(state)
        pcall(function()
            local c = findCar()
            if c and c.Config.On.Value == true then
                c.PrimaryPart.CFrame = CFrame.new(3071.32, 0.83, 45.07)
                c.PrimaryPart.Velocity = Vector3.new(0,0,0)
            else

            end

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3071.32, 0.83, 45.07)
    end)
end
})

-- Job options

local p = Job:AddParagraph({ Title = "⚠️~ All of this is under development and experimental ~⚠️", Content = "Don't use what isn't confirmed to be working", TitleAlignment = "Left", ContentAlignment = "Left" })
local p = Job:AddParagraph({ Title = "Terminate any active auto farms.", Content = "Do not spam!\nWait >10 seconds to start another farm.", TitleAlignment = "Left", ContentAlignment = "Left" })
Job:AddButton({
    Title = "Terminate Active Autos",
    Callback = function()
        terminate = true
        task.wait(10)
        terminate = false
    end,
})

local p = Job:AddParagraph({ Title = "Delivery Jobs.", Content = "Do not spam the buttons.", TitleAlignment = "Left", ContentAlignment = "Left" })

Job:AddButton({
    Title = "Finish Pizza route!",
    Callback = function()
        local car = findCar()
        finishPizza(car)
    end,
})

Job:AddButton({
    Title = "Finish Bus Route!",
    Callback = function()
        local car = findCar()
        finishBusRoute(car)
    end,
})

local FishFarm = Job:AddToggle({
    Id = "fishfarm",
    Title = "Fish Auto Farm",
    Default = false,
    Keybind = "F1",
Callback = function(value)
    
end})

Settings:AddButton({
	Title = "Unload",
	Description = "Close the menu",
	Callback = function()
		Window:Dialog({
			Title = "Unload?",
			Content = "This destroys the menu.",
			Buttons = {
				{ Title = "Unload", Callback = function() Library:Destroy() end },
				{ Title = "Cancel" },
			},
		})
	end,
})
