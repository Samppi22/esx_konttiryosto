ESX = nil
local alotettu = false
local cd = 0
local blip

local kontit = {
    [1] = {coords=vector3(518.35, -2721.79, 5.06), heading=150.65},
    [2] = {coords=vector3(513.44, -2719.23, 5.06), heading=150.65},
    [3] = {coords=vector3(514.5, -2723.27, 5.06), heading=150.65},
    [4] = {coords=vector3(817.74, -3074.55, 4.92), heading=264.25},
    [5] = {coords=vector3(816.65, -3077.29, 4.92), heading=264.25},
    [6] = {coords=vector3(816.57, -3082.56, 4.92), heading=264.25},
    [7] = {coords=vector3(816.61, -3079.88, 4.92), heading=264.25},
    [8] = {coords=vector3(51.15, -2479.5, 5.02), heading=229.22},
    [9] = {coords=vector3(49.64, -2481.67, 5.02), heading=229.22},
    [10] = {coords=vector3(48.03, -2483.85, 5.02), heading=229.22},
    [11] = {coords=vector3(46.58, -2486.0, 5.02), heading=229.22}
}


    
CreateThread(function()
    while ESX == nil do
        Wait(10)
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    end
    while true do
        local wait = 1800
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        for _,v in pairs(kontit) do
            local konttipos = v.coords
            if #(coords - konttipos) < 35.0 then
             wait = 0
             DrawMarker(25, konttipos.x, konttipos.y, konttipos.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 77, 0, 0, 150, false, true, 5, nil, nil, false)
                 if #(coords - konttipos) < 1.2 then
                     if not alotettu then
                         ESX.ShowHelpNotification("Paina ~INPUT_CONTEXT~ ronklataksesi konttia!")
                         if IsControlJustReleased(0, 38) then
                             if GetSelectedPedWeapon(playerPed) == GetHashKey("WEAPON_CROWBAR") then
                                 ronklausalotuslmfaokarpovelhokod(i)
                             else
                                 ESX.ShowNotification("Tarvitset sorkkaraudan!")
                             end
                         end
                     else
                         if IsPedDeadOrDying(playerPed, true) then
                             ClearPedTasks(playerPed)
                             alotettu = false
                             TriggerServerEvent('samppi_konttiryosto:keskeytetty')
                             ESX.ShowAdvancedNotification('Konttiryöstö', 'Murto keskeytyi!', "", "CHAR_CALL911", 1)
                         end
                     end
                 end
             end  
        end
        Wait(wait)
    end
end)


function ronklausalotuslmfaokarpovelhokod(kontti)
    ESX.TriggerServerCallback('samppi_konttiryosto:boliseja', function(bolis)
        if bolis >= Config.boliiseja then
            if cd <= 0 then
                anim(kontti)
                alotettu = true
                ESX.ShowAdvancedNotification('Konttiryöstö', 'Aloitit murron!', "", "CHAR_CALL911", 1)
                TriggerServerEvent('samppi_konttiryosto:poliisi', kontit[kontti].coords)
            else
                ESX.ShowNotification('Cooldown menossa!')
            end
        else
            ESX.ShowNotification('Ei tarpeeksi poliiseja!')
        end
    end)
end

function anim(kontti)
    SetEntityHeading(PlayerPedId(), kontit[kontti].heading)

    TriggerEvent("mythic_progbar:client:progress", {
        name = "ronklaus",
        duration = Config.kuinkauan*1000,
        label = "Aukaistaan konttia...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
        },

    }, function(canceled)
        if not canceled then
            ClearPedTasks(PlayerPedId())
            alotettu = false
            ESX.ShowAdvancedNotification('Konttiryöstö', 'Murto onnistui!', "", "CHAR_CALL911", 1)
            TriggerServerEvent('samppi_konttiryosto:ronklattupaskaks', kontti)
            cd = Config.cooldown * 1000 * 60
        else
            ClearPedTasks(PlayerPedId())
            alotettu = false
            TriggerServerEvent('samppi_konttiryosto:keskeytetty')
            ESX.ShowAdvancedNotification('Konttiryöstö', 'Murto keskeytyi!', "", "CHAR_CALL911", 1)
            cd = Config.cooldown * 1000 * 60
        end
    end)
end

CreateThread(function()
	while true do 
		Wait(5000)
		if cd > 0 then
			cd = cd - 5000
		end
	end
end)



--poliisi paskaa
RegisterNetEvent('samppi_konttiryosto:keskeytetty')
AddEventHandler('samppi_konttiryosto:keskeytetty', function()
    ESX.ShowAdvancedNotification('Konttiryöstö', 'Murto keskeytyi!', "", "CHAR_CALL911", 1)
    RemoveBlip(blip)
end)



RegisterNetEvent('samppi_konttiryosto:onnistu')
AddEventHandler('samppi_konttiryosto:onnistu', function()
    ESX.ShowAdvancedNotification('Konttiryöstö', 'Murto onnistui...', "", "CHAR_CALL911", 1)
	RemoveBlip(blip)
end)

RegisterNetEvent('samppi_konttiryosto:blipclient')
AddEventHandler('samppi_konttiryosto:blipclient', function(pos)
    ESX.ShowAdvancedNotification('Konttiryöstö', 'Hälytys laukaistu!', "", "CHAR_CALL911", 1)
	RemoveBlip(blip)
    blip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(blip , 306)
    SetBlipScale(blip , 1.0)
    SetBlipColour(blip, 4)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Konttiryöstö')
    EndTextCommandSetBlipName(blip)
end)
