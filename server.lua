ESX = exports["es_extended"]:getSharedObject()

local queueActive = false
local queueTime = 10
local queuePosition = 0

RegisterServerEvent('hw_waiting:notify')
AddEventHandler('hw_waiting:notify', function(message)
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
        print("^0[^1ERROR^0]: Queue is already ^2active^0.")
    end
end, true)

RegisterCommand('stopqueue', function(source, args, rawCommand)
    if queueActive then
        queueActive = false
        TriggerClientEvent('hw_waiting:notify', -1, "Queue is now inactive.")
    else
        print("^0[^1ERROR^0]: Queue is ^1not^0 active! For help use ^5/queuehelp")
    end
end, true)

RegisterCommand('queueinfo', function(source, args, rawCommand)
    if queueActive then
        queueTime = tonumber(args[1] or queueTime)
        TriggerClientEvent('hw_waiting:notify', -1, "Wachtrij ingesteld op:" ..queueTime .. " seconden.")
        print("^0[^2INFO^0]: Queue time is: ^5" .. queueTime .. "^0 seconds")
    else
        print("^0[^1ERROR^0]: Queue is ^1not^0 active! For help use ^5/queuehelp")
    end
end, true)

RegisterCommand('queuehelp', function(source, args, rawCommand)
    if queueActive then
        print("^0[^2INFO^0]: Use ^5/startqueue^0 to activate the queue. U can configure the time at ^5line 4^0 in server.lua")
    else
        print("^0[^2INFO^0]: Use ^5/startqueue^0 to activate the queue. U can configure the time at ^5line 4^0 in server.lua")
    end
end, true)


