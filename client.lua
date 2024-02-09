ESX = exports["es_extended"]:getSharedObject()
-- You can add your client-side code here
RegisterCommand('queueinfo', function()
    TriggerServerEvent('hw_waiting:notify', "This is a sample on-screen message.")
end, false)
