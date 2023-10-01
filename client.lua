local afk = { currentPosition = nil, lastPosition = nil, currentHeading = nil, lastHeading = nil, timer = 0, bypass = false }

local afkMsc = 1000
local timeToKick = 600

local playerToKick = false

RegisterNetEvent("Luna:afk:bypass", function()
    afk.bypass = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(afkMsc)

        if afk.bypass then afkMsc = 60000*24 end

        local ped = PlayerPedId()
        if ped then
        
            afk.currentPosition = GetEntityCoords(ped, true)
            afk.currentHeading = GetEntityHeading(ped)

            if afk.currentPosition == afk.lastPosition and afk.currentHeading == afk.lastHeading then
                if afk.timer > 0 then
                    if afk.timer == math.ceil(timeToKick / 10) then
                        playerToKick = true
                        ESX.ShowNotification("Please move or you will be kicked from the server in 1 minute")
                    end
                    afk.timer = afk.timer - 1
                else
                    TriggerServerEvent("Luna:afk:kick")
                end
            else
                afk.timer = timeToKick
            end

            afk.lastPosition = afk.currentPosition
            afk.lastHeading = afk.currentHeading
        end
    end
end)

RegisterCommand("afk", function()
    if not playerToKick then return ESX.ShowNotification("You won't be kicked out of the server") end

    afk.timer = timeToKick
    ESX.ShowNotification('AFK time has been reset')
    playerToKick = false
end)