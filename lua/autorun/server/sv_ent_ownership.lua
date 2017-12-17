local ent_ownership_list={--add an entity class as the key in this table and assign the value of true to add it to this list
	["entityclass"]=true,--copy this template and replace entityclass with whatever you want to have on the list
}
local table_is_blacklist=true--set this line to equal false or remove this line if you want the table above to be a whitelist

--no need to touch anything below here
hook.Add("playerBoughtAmmo","playerBoughtAmmo",function(ply,ammoTable,ent,price)
	if ent and ply and ent_ownership_list and ply:IsValid() and ent:IsValid() and ply:IsPlayer() then--nilchecking is habitual
		if tobool(ent_ownership_list[ent:GetClass()])!=tobool(table_is_blacklist) then--tobool returns false if the imput equals nil or false.
			ent:CPPISetOwner(ply)--if the booleans are not equal then CPPISetOwner will make fpp recognize the entity as being owned by the player
		end
	end
end)
hook.Add("playerBoughtCustomEntity","playerBoughtCustomEntity",function(ply,entityTable,ent,price)
	if ent and ply and ent_ownership_list and ply:IsValid() and ent:IsValid() and ply:IsPlayer() then--nilchecking is habitual
		if tobool(ent_ownership_list[ent:GetClass()])!=tobool(table_is_blacklist) then--tobool returns false if the imput equals nil or false.
			ent:CPPISetOwner(ply)--if the booleans are not equal then CPPISetOwner will make fpp recognize the entity as being owned by the player
		end
	end
end)
hook.Add("playerBoughtPistol","playerBoughtPistol",function(ply,weaponTable,ent,price)
	if ent and ply and ent_ownership_list and ply:IsValid() and ent:IsValid() and ply:IsPlayer() then--nilchecking is habitual
		if tobool(ent_ownership_list[ent:GetClass()])!=tobool(table_is_blacklist) then--tobool returns false if the imput equals nil or false.
			ent:CPPISetOwner(ply)--if the booleans are not equal then CPPISetOwner will make fpp recognize the entity as being owned by the player
		end
	end
end)
hook.Add("playerBoughtShipment","playerBoughtShipment",function(ply,shipmentTable,ent,price)
	if ent and ply and ent_ownership_list and ply:IsValid() and ent:IsValid() and ply:IsPlayer() then--nilchecking is habitual
		if tobool(ent_ownership_list[ent:GetClass()])!=tobool(table_is_blacklist) then--tobool returns false if the imput equals nil or false.
			ent:CPPISetOwner(ply)--if the booleans are not equal then CPPISetOwner will make fpp recognize the entity as being owned by the player
		end
	end
end)