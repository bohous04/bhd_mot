local Bridge = exports["bhd_bridge"]:getBridge()

Citizen.CreateThread(function()
    Wait(5000)
    Bridge = exports["bhd_bridge"]:getBridge()
end)

RegisterNetEvent("bhd_mot:server:make_certificate", function (data)
    local source = source
    local job = Bridge.GetJob(source).name
    local zone = false
    local ped = GetPlayerPed(source)
    local pedCoords = GetEntityCoords(ped)
    for k, v in pairs(Config.Zones) do
        if v.groups[job] then
            zone = v.coords
            break
        end
    end
    if not zone then
        Bridge.Ban(source, "MOT: No zone found")
        return
    end
    local distance = #(pedCoords - zone)
    if distance > 100 then
        Bridge.Ban(source, "MOT: Player is too far from the zone")
        return
    end
    local status = data.illegalData
    if not status then 
        status = locale("passed")
    else
        status = locale("failed", data.illegalData)
    end
    local today = os.date("*t")
    local issued = string.format("%02d-%02d-%04d", today.day, today.month, today.year)

    local expireMonth = today.month + 3
    local expireYear = today.year
    if expireMonth > 12 then
        expireMonth = expireMonth - 12
        expireYear = expireYear + 1
    end

    local expire = string.format("%02d-%02d-%04d", today.day, expireMonth, expireYear)
    if data.illegalData then
        expire = locale("expire_fail")
    end
    Bridge.AddItem(source, Config.ItemName, 1, {
        description = locale("item_description", data.plate, issued, expire, status),
    })
end)