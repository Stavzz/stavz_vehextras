-- vehicle_extras.lua

QBCore = exports['qb-core']:GetCoreObject()

-- Function to open the menu and show vehicle extras
function OpenVehicleExtrasMenu()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        local menu = {
            {
                header = "Vehicle Extras",
                isMenuHeader = true
            }
        }

        for i = 1, 20 do
            if DoesExtraExist(vehicle, i) then
                local extraState = IsVehicleExtraTurnedOn(vehicle, i)
                table.insert(menu, {
                    header = "Extra " .. i,
                    txt = extraState and "Turn Off" or "Turn On",
                    params = {
                        event = "toggleVehicleExtra",
                        args = {
                            vehicle = vehicle,
                            extraID = i,
                            state = extraState
                        }
                    }
                })
            end
        end

        table.insert(menu, {
            header = "Close",
            txt = "",
            params = {
                event = "qb-menu:client:closeMenu"
            }
        })

        exports['qb-menu']:openMenu(menu)
    else
        QBCore.Functions.Notify('You are not in a vehicle', 'error')
    end
end

-- Event to toggle vehicle extras
RegisterNetEvent('toggleVehicleExtra')
AddEventHandler('toggleVehicleExtra', function(data)
    local vehicle = data.vehicle
    local extraID = data.extraID
    local state = data.state

    if state then
        SetVehicleExtra(vehicle, extraID, 1)
        QBCore.Functions.Notify('Extra ' .. extraID .. ' turned off', 'success')
    else
        SetVehicleExtra(vehicle, extraID, 0)
        QBCore.Functions.Notify('Extra ' .. extraID .. ' turned on', 'success')
    end

    OpenVehicleExtrasMenu()
end)

-- Command to open the vehicle extras menu
RegisterCommand('extras', function()
    OpenVehicleExtrasMenu()
end, false)

-- Command suggestion
TriggerEvent('chat:addSuggestion', '/extras', 'Open vehicle extras menu')
