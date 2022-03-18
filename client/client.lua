ESX = nil

Citizen.CreateThread(function() 
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(0) 
    end
end)

Streets = {["Enabled"] = false}

CreateThread(function()
    while true do
        local s = 1000;
        local gasolina = nil

        if IsPedInAnyVehicle(PlayerPedId()) then
            gasolina = GetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId()))
        else
            gasolina = 0
        end

        Data = {
            ["NUI"] =  {
                action = "showCarhud";
                unit = "KM/h";
                speed = (GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) * 3.6);
                fuel = gasolina;
                damage = GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId()));
            }
        }

        if IsPedInAnyVehicle(PlayerPedId()) then
            s = 150;
            SendNUIMessage(Data["NUI"])
        else
            SendNUIMessage({
                action = "hideCarhud";
            })
            s = 1000
        end
        Wait(s)
    end
end)
if Streets["Enabled"] then
    CreateThread(function()
        while Streets["Enabled"] do
            local msec = 1000
            local pedcoords = GetEntityCoords(PlayerPedId())
            local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pedcoords.x, pedcoords.y, pedcoords.z))

            Data = {
                ["Streets"] =  {
                    callesData = "calle";
                    streetName = streetName;
                }
            }

            SendNUIMessage(Data["Streets"])

            Wait(msec)
        end
    end)
else

    print("Streets doesn`t started because is off in config.")
end

local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

IsCar = function(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end	

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		wait = 1000
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		if IsPedInAnyVehicle(ped) then
            
            if car ~= 0 and (wasInCar or IsCar(car)) then
                wait = 5
                wasInCar = true
                
                if beltOn then DisableControlAction(0, 75) end
                
                speedBuffer[2] = speedBuffer[1]
                speedBuffer[1] = GetEntitySpeed(car)
                
                if speedBuffer[2] ~= nil 
                and not beltOn
                and GetEntitySpeedVector(car, true).y > 1.0  
                and speedBuffer[1] > 19.25
                and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
                
                    local co = GetEntityCoords(ped)
                    local fw = Fwv(ped)
                    SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                    SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                end
                    
                velBuffer[2] = velBuffer[1]
                velBuffer[1] = GetEntityVelocity(car)
                    
                if IsControlJustReleased(0, 20) then
                    beltOn = not beltOn
                    if beltOn then
						vehicleStatus = {
							action = 'vehicleStatus',
							seatbelt = true
						}
						SendNUIMessage(vehicleStatus)
						ExecuteCommand('me se pone el cinturon')
                    else
						vehicleStatus = {
							action = 'vehicleStatus',
							seatbelt = false
						}
						SendNUIMessage(vehicleStatus)
						ExecuteCommand('me se quita el cinturon')
                    end		  
                end
                
            elseif wasInCar then
                wasInCar = false
                beltOn = false
                speedBuffer[1], speedBuffer[2] = 0.0, 0.0
            end
        end
		Citizen.Wait(wait)
	end
end)

local damage = nil
RegisterCommand("motor", function()
    damage = not damage

    if damage then 
        dam = "motor"
    else
        dam = "noMotor"
    end

    SendNUIMessage({
        whenMotor = dam
    })
end)

local cinturon = nil
RegisterCommand("cinto", function()
    cinturon = not cinturon

    if cinturon then 
        cinto = "cinto"
    else
        cinto = "noCinto"
    end

    SendNUIMessage({
        whenCinto = cinto
    })
end)

RegisterKeyMapping('cinto', 'Ponte el cinturón', 'keyboard', 'z')
