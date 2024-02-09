ESX = exports["es_extended"]:getSharedObject()

local queueActive = false
local queueTime = 10
local queuePosition = 0

RegisterServerEvent('queue:notify')
AddEventHandler('queue:notify', function(message)
    TriggerClientEvent('chatMessage', -1, '^1Queue System^7', {255, 255, 255}, message)
end)

RegisterServerEvent('playerConnecting')
AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    local source = source

    if queueActive then
        deferrals.defer()
        deferrals.update("Je zit in de wachtrij. Verstreken tijd: " .. queuePosition .. " seconden")

        while queueActive do
            Wait(1000)

            queueTime = queueTime - 1
            queuePosition = queuePosition + 1

            deferrals.update("Je zit in de wachtrij. Verstreken tijd: " .. queuePosition .. " seconden")

            if queueTime <= 0 then
                deferrals.done()
                break
            end
        end
    else
        deferrals.done()
    end
end)

RegisterCommand('startqueue', function(source, args, rawCommand)
    if not queueActive then
        queueActive = true
        queueTime = tonumber(args[1]) or queueTime
        queuePosition = 0
        TriggerClientEvent('hw_waiting:notify', -1, "Queue is now active. Estimated wait time: " .. queueTime .. " seconds.")
    else
        print("Queue is already active.")
    end
end, true)

RegisterCommand('stopqueue', function(source, args, rawCommand)
    if queueActive then
        queueActive = false
        TriggerClientEvent('queue:notify', -1, "Queue is now inactive.")
    else
        print("Queue is not active.")
    end
end, true)
