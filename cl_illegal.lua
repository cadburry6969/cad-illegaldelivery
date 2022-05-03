local QBCore = exports["qb-core"]:GetCoreObject()
local isDeliveryActive = false
local CurrentDeliveryBlip = 0
local CurrentDeliveryValue = 1
local CurrentDeliveryLocation = nil
local CurrentDeliveries = 0
local PlayerData

-- / Events \ --
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
	PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('illegaldelivery:NextDelivery', function()	
	ClearBlips()  
	CurrentDeliveryValue = CurrentDeliveryValue + 1
	CurrentDeliveryLocation = Config.DeliveryLocations[CurrentDeliveryValue]
	AddBlips() 	
end)

-- / Functions \ --
function AddBlips()
    ClearBlips()
    CurrentDeliveryBlip = AddBlipForCoord(CurrentDeliveryLocation.x,CurrentDeliveryLocation.y,CurrentDeliveryLocation.z)
    SetBlipSprite(CurrentDeliveryBlip, 514)
    SetBlipScale(CurrentDeliveryBlip, 0.9)
	SetBlipColour(CurrentDeliveryBlip, 3)
    SetBlipAsShortRange(CurrentDeliveryBlip, true)	
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Package Delivery")
    EndTextCommandSetBlipName(CurrentDeliveryBlip)	
end

function ClearBlips()
    RemoveBlip(CurrentDeliveryBlip)
    CurrentDeliveryBlip = 0
end

function PoliceAlert()
	-- Add Your Police Alert Here	
end

function StartDelivery()	
    isDeliveryActive = true
    local timelong = 0
	CurrentDeliveryValue = math.random(1, #Config.DeliveryLocations)
	CurrentDeliveryLocation = Config.DeliveryLocations[CurrentDeliveryValue]	
	AddBlips() 
	TriggerEvent("QBCore:Notify", "Your deliveries are marked on map")
    while isDeliveryActive do
        Wait(1)		         
		local inRange = false
		if CurrentDeliveries <= Config.MaxDeliveries then
			local plyCoords = GetEntityCoords(PlayerPedId())
			local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)			  
			local distance = #(CurrentDeliveryLocation - plyCoords)
			if distance < 8.0 then           			
				inRange = true				
				if distance < 2.0 and not inVehicle then           			
					QBCore.Functions.DrawText3D(CurrentDeliveryLocation.x,CurrentDeliveryLocation.y,CurrentDeliveryLocation.z, "[E] Knock Door")
					if IsControlJustReleased(0, 38) and isDeliveryActive then
						local success = exports['qb-lock']:StartLockPickCircle(2, 8, success)	
						PoliceAlert()
						if success then
							AttemptDelivery()						
						end
					end		
				end
			end
			timelong = timelong + 1
			if timelong > Config.MaxDeliveryTime then
				TriggerEvent("QBCore:Notify", "You didnot reach the destination on time")
				EndDelivery()
			end
		else
			EndDelivery()
		end		
		if not inRange then
			Wait(1000)
		end
    end
end

function AttemptDelivery()
	QBCore.Functions.Progressbar("deliver_illegal", "Delivering Package", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "timetable@jimmy@doorknock@",
		anim = "knockdoor_idle",
		flags = 16,
	}, {}, {}, function() -- Done
		CurrentDeliveries = CurrentDeliveries + 1 			
		local plycoords = GetEntityCoords(PlayerPedId())
		local Chance = math.random(1, 100)	
		if Chance >= 30 and Chance <= 80 then
			TriggerServerEvent("illegaldelivery:AttemptDelivery", true)	
		else				
			PoliceAlert()	
			TriggerServerEvent("illegaldelivery:AttemptDelivery", false)	
		end
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle", 1.0)		
	end)	
end

function EndDelivery()
    ClearBlips()    
    isDeliveryActive = false          	
	TriggerEvent("QBCore:Notify", "Your deliveries are done")
	CurrentDeliveries = 0
    CurrentDeliveryLocation = nil
    Wait(1000)
    ClearBlips()
end

RegisterNetEvent("cad-illegal:startwork", function()
	if not isDeliveryActive then
		Config.MaxDeliveries = math.random(3, 8)					
		StartDelivery()	
	else
		TriggerEvent("QBCore:Notify", "Already doing work!", "error")
	end
end)

CreateThread(function()
	Wait(100)
	exports['qb-target']:AddTargetModel('s_m_m_linecook', {
        options = {
            {                
				event = "cad-illegal:startwork",
				icon = "fas fa-truck-loading", 
				label = "Sign In", 
				canInteract = function()
					if not isDeliveryActive and #(Config.StartLocation - GetEntityCoords(PlayerPedId())) < 4 then return true end
					return false
				end,
            },
			{                				
				icon = "fas fa-truck-loading", 
				label = "Sign Out", 
				canInteract = function()
					if isDeliveryActive and #(Config.StartLocation - GetEntityCoords(PlayerPedId())) < 4 then return true end
					return false
				end,
				action = function()					
					EndDelivery()					
				end,
            },
        },
        distance =  1.5
    })
	
end)

