local QBCore = exports["qb-core"]:GetCoreObject()
-- / Events \ --
RegisterNetEvent('illegaldelivery:AttemptDelivery', function(gotchance)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)	
	local payment = 0
    if gotchance then        
        if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
            for k, v in pairs(Player.PlayerData.items) do 
                if Player.PlayerData.items[k] ~= nil then 
                    if Config.DeliveryItems[Player.PlayerData.items[k].name] ~= nil then 
                        payment = payment + Config.DeliveryItems[Player.PlayerData.items[k].name]
                        Player.Functions.RemoveItem(Player.PlayerData.items[k].name, 1, k)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Player.PlayerData.items[k].name], 'remove')
                    end
                end
            end
            if Config.GiveBonusOnPolice then
                if GetDeliveryCops() > 0 and GetDeliveryCops() < 3 then
                    payment = payment * 1.2
                elseif GetDeliveryCops() >= 3 and GetDeliveryCops() <= 6 then
                    payment = payment * 1.5
                elseif GetDeliveryCops() >= 7 and GetDeliveryCops() <= 10 then
                    payment = payment * 2.0            
                end
            end
            Player.Functions.AddMoney("cash", math.ceil(payment), "sold-delivery-items")                        
        else		
            TriggerClientEvent('QBCore:Notify', src, "You don't have any items on you")                
        end
    else        
        Player.Functions.AddMoney("cash", 10, "got-nothing")     
        TriggerClientEvent('QBCore:Notify', src, "Person dint take your stuff, you got nothing")   
    end
    TriggerClientEvent("illegaldelivery:NextDelivery", src)
end)

-- / Functions \ --
function GetDeliveryCops()
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
                amount = amount + 1
            end
        end
	end
    return amount
end