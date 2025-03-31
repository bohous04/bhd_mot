Bridge = {}
local isInspetingBody = false
local isInspetingEngine = false
local curentMOTStatus = {}
local waitTimes = {
	horn = math.floor((Config.CheckTimes.horn * 1000) / 750 + 0.5)
}
local zones = {}
Citizen.CreateThread(function ()
    Bridge = exports["bhd_bridge"]:getBridge()
	while not Bridge do
		Wait(100)
		Bridge = exports["bhd_bridge"]:getBridge()
	end
    for k,v in pairs(Config.Zones) do
		zones[#zones+1] = Bridge.AddBoxZone({
			debug = false,
			name = v.name,
			coords = v.coords,
			size = v.size,
			rotation = v.rotation,
			options = {
				{
					name = "mot_"..v.name,
					icon = "fa-solid fa-certificate",
					label = locale("target_open_mot"),
					groups = v.groups,
					distance = Config.TargetDistance,
					event = "bhd_mot:client:openMOT",
				}
			}
		})
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
		for k,v in pairs(zones) do
			Bridge.RemoveZone(v)
		end
	end
end)

function Notify(msg, type, time, title)
    if not type then type = locale("notify_type_info") end
    if not time then time = 5000 end
    if not title then title = locale("notify_title_default") end
    Bridge.Notify(title, msg, time, type)
end

function UpdateContext(veh)
	local certificate = true
	if curentMOTStatus[veh].horn and curentMOTStatus[veh].lights and curentMOTStatus[veh].neon and curentMOTStatus[veh].body and curentMOTStatus[veh].engine and curentMOTStatus[veh].tires then
		certificate = false
	end
	lib.registerContext({
		id = 'mot',
		title = locale("menu_title"),
		options = {
			{
				title = locale("menu_horn"),
				description = locale("menu_horn_desc"),
				icon = "fa-bullhorn",
				event = "bhd_mot:client:horn",
				disabled = curentMOTStatus[veh].horn,
			},
			{
				title = locale("menu_lights"),
				description = locale("menu_lights_desc"),
				icon = "fa-solid fa-lightbulb",
				event = "bhd_mot:client:lights",
				disabled = curentMOTStatus[veh].lights,
			},
			{
				title = locale("menu_neon"),
				description = locale("menu_neon_desc"),
				icon = "fa-code-branch",
				event = "bhd_mot:client:neon",
				disabled = curentMOTStatus[veh].neon,
			},
			{
				title = locale("menu_body"),
				description = locale("menu_body_desc"),
				icon = "fa-car-side",
				event = "bhd_mot:client:body",
				disabled = curentMOTStatus[veh].body,
			},
			{
				title = locale("menu_engine"),
				description = locale("menu_engine_desc"),
				icon = "fa-car-battery",
				event = "bhd_mot:client:engine",
				disabled = curentMOTStatus[veh].engine,
			},
			{
				title = locale("menu_tires"),
				description = locale("menu_tires_desc"),
				icon = "fa-circle",
				event = "bhd_mot:client:tires",
				disabled = curentMOTStatus[veh].tires,
			},
			{
				title = locale("make_certificate"),
				icon = "fa-stamp",
				event = "bhd_mot:client:makeCertificate",
				disabled = certificate,
			},
		}
	})
end

AddEventHandler("bhd_mot:client:makeCertificate", function (data)
	local veh = cache.vehicle
	if not veh then
		Notify(locale("no_vehicle"), locale("notify_type_error"))
		return
	end
	if curentMOTStatus[veh].horn and curentMOTStatus[veh].lights and curentMOTStatus[veh].neon and curentMOTStatus[veh].body and curentMOTStatus[veh].engine and curentMOTStatus[veh].tires then
		local illegalData = curentMOTStatus[veh].illegalData
		if illegalData == "" then
			illegalData = false
		end
		local plate = GetVehicleNumberPlateText(veh)
		local data = {
			plate = plate,
			illegalData = illegalData,
		}
		TriggerServerEvent("bhd_mot:server:make_certificate", data)
		curentMOTStatus[veh] = nil
		Notify(locale("certificate_made"), locale("notify_type_success"))
	else
		Notify(locale("not_all_checked"), locale("notify_type_error"))
	end
end)

AddEventHandler("bhd_mot:client:openMOT", function (data)
	local veh = cache.vehicle
	if not veh then
		Notify(locale("no_vehicle"), locale("notify_type_error"))
		return
	end
	if not curentMOTStatus[veh] then
		local bones = { "door_dside_f", "door_pside_f", "door_dside_r", "door_pside_r", "boot"}
		local numOfBodyChecks = 0
		for _, boneName in pairs(bones) do
			local bone = GetEntityBoneIndexByName(veh, boneName)
			if bone ~= -1 then
				numOfBodyChecks += 1
			end
		end
		curentMOTStatus[veh] = {
			horn = false,
			lights = false,
			neon = false,
			body = false,
			numOfBodyChecks = numOfBodyChecks,
			checkedBones = {},
			engine = false,
			tires = false,
			illegalData = "",
		}
	end
	
	UpdateContext(veh)
	Wait(100)
	lib.showContext('mot')
end)

AddEventHandler("bhd_mot:client:horn", function (data)
	local veh = cache.vehicle
	if not veh then
		Notify(locale("no_vehicle"), locale("notify_type_error"))
		return
	end
	if curentMOTStatus[veh].horn then
		return
	end
	Citizen.CreateThread(function()
		lib.progressCircle({
			duration = Config.CheckTimes.horn * 1000,
			position = 'bottom',
			useWhileDead = false,
			canCancel = false,
			disable = {
				car = true,
				move = true,
			},
		})
	end)
	local horn = GetVehicleMod(veh, 14)
	for i = 1, waitTimes.horn do
		StartVehicleHorn(veh, 1000, "HELDDOWN", 1)
		Wait(750)
	end
	curentMOTStatus[veh].horn = true
	if Config.IllegalHorns[horn] then
		curentMOTStatus[veh].illegalData = curentMOTStatus[veh].illegalData..locale("horn").." "
		Notify(locale("horn_fail"), locale("notify_type_info"))
	else
		Notify(locale("horn_checked"), locale("notify_type_info"))
	end
end)

AddEventHandler("bhd_mot:client:lights", function (data)
	local veh = cache.vehicle
	if not veh then
		Notify(locale("no_vehicle"), locale("notify_type_error"))
		return
	end
	if curentMOTStatus[veh].lights then
		return
	end
	FreezeEntityPosition(veh, true)
	SetVehicleLights(veh, 2)
	SetVehicleFullbeam(veh, true)
	lib.progressCircle({
		duration = Config.CheckTimes.lights * 1000,
		position = 'bottom',
		useWhileDead = false,
		canCancel = false,
		disable = {
			car = true,
			move = true,
		},
	})
	SetVehicleFullbeam(veh, false)
	local color = GetVehicleXenonLightsColor(veh)
	if not Config.AllowedHornsHeadLights[color] then
		curentMOTStatus[veh].illegalData = curentMOTStatus[veh].illegalData..locale("lights").." "
		Notify(locale("lights_fail"), locale("notify_type_info"))
	else
		Notify(locale("lights_checked"), locale("notify_type_info"))
	end
	curentMOTStatus[veh].lights = true
	FreezeEntityPosition(veh, false)
end)

AddEventHandler("bhd_mot:client:neon", function (data)
	local veh = cache.vehicle
	if not veh then
		Notify(locale("no_vehicle"), locale("notify_type_error"))
		return
	end
	if curentMOTStatus[veh].neon then
		return
	end
	FreezeEntityPosition(veh, true)
	local illegalPlacement = false
	for i = 0, 3 do
		if Config.Neon.CheckPositions[i] then
			illegalPlacement = true
		end
		SetVehicleNeonLightEnabled(veh, i, true)
	end
	lib.progressCircle({
		duration = Config.CheckTimes.neon * 1000,
		position = 'bottom',
		useWhileDead = false,
		canCancel = false,
		disable = {
			car = true,
			move = true,
		},
	})
	local hasIllegalColor = false
	local red, green, blue = GetVehicleNeonLightsColour(veh)
	for _, v in pairs(Config.Neon.Colors) do
		if v.illegal and v.r == red and v.g == green and v.b == blue then
			hasIllegalColor = true
			break
		end
	end
	if illegalPlacement and hasIllegalColor then
		curentMOTStatus[veh].illegalData = curentMOTStatus[veh].illegalData..locale("neon").." "
		Notify(locale("neon_fail"), locale("notify_type_info"))
	else
		Notify(locale("neon_checked"), locale("notify_type_info"))
	end
	curentMOTStatus[veh].neon = true
	FreezeEntityPosition(veh, false)
end)

AddEventHandler("bhd_mot:client:body", function(data)
    local veh = cache.vehicle
    if not veh then
        Notify(locale("no_vehicle"), locale("notify_type_error"))
        return
    end
    if curentMOTStatus[veh].body then
        return
    end
	Bridge.AddGlobalVehicle({
		{
			name = 'bhd_mot_body_check',
			icon = 'fa-solid fa-clipboard-question',
			label = locale('target_check_door'),
			bones = { "door_dside_f", "door_pside_f", "door_dside_r", "door_pside_r", "boot"},
			distance = Config.TargetDistance,
			canInteract = function(entity, distance, coords, name)
				return isInspetingBody 
			end,
			event = "bhd_mot:client:bodyCheck",
		},
	})
	Notify(locale("go_out_check"), locale("notify_type_info"))
	isInspetingBody = true
	FreezeEntityPosition(veh, true)
end)

AddEventHandler("bhd_mot:client:bodyCheck", function (data)
	local veh = data.entity
	if not veh or not isInspetingBody or not curentMOTStatus[veh] then
		return 
	end
	local bone = GetClosestBone(veh, data.bones)
	if curentMOTStatus[veh].checkedBones[bone] then
		Notify(locale("already_checked"), locale("notify_type_error"))
		return
	end
	if lib.progressCircle({
		duration = Config.CheckTimes.door * 1000,
		position = 'bottom',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
			move = true,
		},
		anim = {
			dict = 'mini@repair',
			clip = 'fixing_a_ped'
		},
	}) then 
		curentMOTStatus[veh].checkedBones[bone] = true
		curentMOTStatus[veh].numOfBodyChecks = curentMOTStatus[veh].numOfBodyChecks - 1
		Notify(locale("bodypart_checked", curentMOTStatus[veh].numOfBodyChecks))
		if curentMOTStatus[veh].numOfBodyChecks == 0 then
			local bodyHealth = GetVehicleBodyHealth(veh)
			curentMOTStatus[veh].body = true
			if bodyHealth < Config.MinBodyHelthToPass then
				curentMOTStatus[veh].illegalData = curentMOTStatus[veh].illegalData..locale("body").." "
				Notify(locale("body_fail"), locale("notify_type_info"))
			else
				Notify(locale("body_checked"), locale("notify_type_info"))
			end
	
			isInspetingBody = false
			FreezeEntityPosition(veh, false)
			Bridge.RemoveGlobalVehicle("bhd_mot_body_check")
		end
	end
end)

function GetClosestBone(vehicle, bones)
	local closestBone, boneDistance
	local coords = GetEntityCoords(cache.ped, false)
	for j = 1, #bones do
		local boneId = GetEntityBoneIndexByName(vehicle, bones[j])

		if boneId ~= -1 then
			local dist = #(coords - GetEntityBonePosition_2(vehicle, boneId))
			if dist <= (boneDistance or 100) then
				closestBone = boneId
				boneDistance = dist
			end
		end
	end

	return closestBone
end

AddEventHandler("bhd_mot:client:engine", function (data)
	local veh = cache.vehicle
	if not veh then
		Notify(locale("no_vehicle"), locale("notify_type_error"))
		return
	end
	if curentMOTStatus[veh].engine then
		return
	end
	Bridge.AddGlobalVehicle({
		{
			name = 'bhd_mot_body_check',
			icon = 'fa-solid fa-clipboard-question',
			label = locale('target_check_engine'),
			bones = { "engine" },
			distance = Config.TargetDistance,
			canInteract = function(entity, distance, coords, name)
				return isInspetingBody 
			end,
			event = "bhd_mot:client:engineCheck",
		},
	})
	Notify(locale("go_out_check"), locale("notify_type_info"))
	isInspetingBody = true
	FreezeEntityPosition(veh, true)
end)

AddEventHandler("bhd_mot:client:engineCheck", function (data)
	local veh = data.entity
	if not veh or not isInspetingBody or not curentMOTStatus[veh] then
		return 
	end
	SetVehicleDoorOpen(veh, 4, true, true)
	Wait(200)
	if lib.progressCircle({
		duration = Config.CheckTimes.engine * 1000,
		position = 'bottom',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
			move = true,
		},
		anim = {
			dict = 'mini@repair',
			clip = 'fixing_a_ped'
		},
	}) then 
		local engineHealth = GetVehicleEngineHealth(veh)
		SetVehicleDoorShut(veh, 4, true)
		curentMOTStatus[veh].engine = true
		if engineHealth < Config.MinEngineHelthToPass then
			curentMOTStatus[veh].illegalData = curentMOTStatus[veh].illegalData..locale("engine").." "
			Notify(locale("engine_fail"), locale("notify_type_info"))
		else
			Notify(locale("engine_checked"), locale("notify_type_info"))
		end
		FreezeEntityPosition(veh, false)
		Bridge.RemoveGlobalVehicle("bhd_mot_body_check")
	end
end)

AddEventHandler("bhd_mot:client:tires", function (data)
	local veh = cache.vehicle
	if not veh then
		Notify(locale("no_vehicle"), locale("notify_type_error"))
		return
	end
	if curentMOTStatus[veh].tires then
		return
	end
	FreezeEntityPosition(veh, true)
	lib.progressCircle({
		duration = Config.CheckTimes.tires * 1000,
		position = 'bottom',
		useWhileDead = false,
		canCancel = false,
		disable = {
			car = true,
			move = true,
		},
	})
	local illegalTires = false
	local tireType = GetVehicleWheelType(veh)
	if Config.Tire.CheckTypes[tireType] then
		local model = GetEntityModel(veh)
		local class = GetVehicleClass(veh)
		if not Config.Tire.AllowedClasses[class] and not Config.Tire.AllowedModels[model] then
			illegalTires = true
		end
	end
	if illegalTires then
		curentMOTStatus[veh].illegalData = curentMOTStatus[veh].illegalData..locale("tires").." "
		Notify(locale("tires_fail"), locale("notify_type_info"))
	else
		Notify(locale("tires_checked"), locale("notify_type_info"))
	end
	curentMOTStatus[veh].tires = true
	FreezeEntityPosition(veh, false)
end)