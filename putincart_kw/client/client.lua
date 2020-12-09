
-----------------------------Place Animals /peds in cart nearby
local prompt = false
local AnimalPrompt


local cart = {
   "huntercart01",
    "ArmySupplyWagon",
    "buggy01",
    "buggy02",
    "buggy03",
    "cart01",
    "cart02",
    "cart03",
    "cart04",
    "cart05",
    "cart06",
    "cart07",
    "cart08",
    "chuckwagon000x",
    "chuckwagon002x",
    "gatchuck",
    "utilliwag",
    "wagon02x",
    "wagon03x",
    "wagon04x",
    "wagon05x",
    "wagon06x",
    "coach2",
    "coach3",
    "coach4",
    "coach5",
    "coach6",
    "coal_wagon",
    "logwagon",
    "logwagon2",
    "oilWagon01x",
    "oilWagon02x",
    "stagecoach001x",
    "stagecoach002x",
    "stagecoach003x",
    "stagecoach004x",
    "stagecoach005x",
    "stagecoach006x",
    "supplywagon",
    "supplywagon2",
    "wagonarmoured01x",
    "wagonCircus01x",
    "wagonCircus02x",
    "wagondairy01x",
    "wagondoc01x",
    "wagonPrison01x",
    "wagontraveller01x",
    "wagonwork01x",
 }



function SetupAnimalPrompt()
    Citizen.CreateThread(function()
        local str = 'Put in cart'
        AnimalPrompt = PromptRegisterBegin()
        PromptSetControlAction(AnimalPrompt, 0xE8342FF2)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(AnimalPrompt, str)
        PromptSetEnabled(AnimalPrompt, false)
        PromptSetVisible(AnimalPrompt, false)
        PromptSetHoldMode(AnimalPrompt, true)
        PromptRegisterEnd(AnimalPrompt)

    end)
end

Citizen.CreateThread(function()
	SetupAnimalPrompt()
	while true do 
		Wait(100)
		local ped = PlayerPedId()
		coords = GetEntityCoords(ped)
		forwardoffset = GetOffsetFromEntityInWorldCoords(ped,0.0,2.0,0.0)
		local Pos2 = GetEntityCoords(ped)
		local targetPos = GetOffsetFromEntityInWorldCoords(obj3, -0.0, 1.1,-0.1)
		local rayCast = StartShapeTestRay(Pos2.x, Pos2.y, Pos2.z, forwardoffset.x, forwardoffset.y, forwardoffset.z,-1,ped,7)
		local A,hit,C,C,spot = GetShapeTestResult(rayCast) 
		local veh = GetVehiclePedIsIn(ped, true) 

		--local model = veh
		local model = GetEntityModel(spot)
		cartcoords = GetEntityCoords(spot)
		for i,v in pairs(cart) do
			if model == GetHashKey(v) then
		--if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, cartcoords.x, cartcoords.y, cartcoords.z,  true) < 5.0 then
			--print('asdsads')
				if model ~= nil then --1347283941 : cart03 --1758092337 : WAGON05X
					local animal = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
					if animal ~= false then
						if prompt == false then
							PromptSetEnabled(AnimalPrompt, true)
							PromptSetVisible(AnimalPrompt, true)
							prompt = true
						end
						if PromptHasHoldModeCompleted(AnimalPrompt) then
							PromptSetEnabled(AnimalPrompt, false)
							wdwwromptSetVisible(AnimalPrompt, false)
							prompt = false
							animalcheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
							pedid = NetworkGetNetworkIdFromEntity(animalcheck)
							Citizen.InvokeNative(0xC7F0B43DCDC57E3D, PlayerPedId(), animalcheck, GetEntityCoords(PlayerPedId()), 10.0, true)
							--DoScreenFadeOut(1800)
							Wait(2000)
							TriggerServerEvent('EveryoneTeleportEntity',pedid,cartcoords.x,cartcoords.y,cartcoords.z+1.5)
							SetEntityCoords(animalcheck,cartcoords.x,cartcoords.y,cartcoords.z+1.5,false)
							--DoScreenFadeIn(3000)
							Wait(2000)
						end

						forwardoffset = GetOffsetFromEntityInWorldCoords(ped,0.0,2.0,0.0)
						local Pos2 = GetOffsetFromEntityInWorldCoords(ped, -0.0, 0.0,0.5)
						local targetPos = GetOffsetFromEntityInWorldCoords(obj3, -0.0, 1.1,-0.1)
						local rayCast = StartShapeTestRay(Pos2.x, Pos2.y, Pos2.z, forwardoffset.x, forwardoffset.y, forwardoffset.z,-1,ped,7)
						A,hit,B,C,spot = GetShapeTestResult(rayCast)
						NetworkRequestControlOfEntity(animalcheck)
						model = GetEntityModel(spot)
					else
						PromptSetEnabled(AnimalPrompt, false)
						PromptSetVisible(AnimalPrompt, false)
						prompt = false
					end
				else
					PromptSetEnabled(AnimalPrompt, false)
					PromptSetVisible(AnimalPrompt, false)
					prompt = false
				end
			end
		end
		-- else
		-- 		PromptSetEnabled(AnimalPrompt, false)
		-- 		PromptSetVisible(AnimalPrompt, false)
		-- 		prompt = false
		-- end
	end
end)


RegisterNetEvent('EveryoneTeleportEntity')
AddEventHandler('EveryoneTeleportEntity', function(netid,x,y,z)
	ent = NetworkGetEntityFromNetworkId(netid)
	Wait(150)
	SetEntityCoords(ent,x,y,z)
end)
----------------------------------------------------------------------------------------




