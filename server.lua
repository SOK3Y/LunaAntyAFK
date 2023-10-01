RegisterServerEvent('Luna:afk:kick')
AddEventHandler('Luna:afk:kick', function()
    DropPlayer(source, 'Kick - Anty AFK')
end)
