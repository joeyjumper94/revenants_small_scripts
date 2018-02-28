local ent_ownership_list={--add an entity class as the key in this table and assign the value of true to add it to this list
	["entityclass"]=true, --copy this template and replace entityclass with whatever you want to have on the list
}
local table_is_blacklist=true --remove this line if you want the table above to be a whitelist

--no need to touch anything below here
local function init()
	if !CPPISetOwner then
		print'you need a prop protection addon that uses CPPI.'
	--	return
	end
	local function owned_ent(ply,ammoTable,ent,price)
		if ent and ply and ent_ownership_list and ply:IsValid() and ent:IsValid() and ply:IsPlayer() then --nilchecking is habitual
			if ent_ownership_list[ent:GetClass()]!=table_is_blacklist then
				ent:CPPISetOwner(ply) --if the booleans are not equal then CPPISetOwner will make fpp recognize the entity as being owned by the player
			end
		end
	end
	hook.Add("playerBoughtAmmo","ent_ownership",ent_ownership)
	hook.Add("playerBoughtCustomEntity","ent_ownership",ent_ownership)
	hook.Add("playerBoughtPistol","ent_ownership",ent_ownership)
	hook.Add("playerBoughtShipment","ent_ownership",ent_ownership)
end
hook.Add("Initialize","ent_ownership",init)
if loaded then init() end