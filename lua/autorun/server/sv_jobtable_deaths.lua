local whitelist={--a list of entities that are allowed to do crush damage
	func_door=true,--some brush based sliding doors,
	trigger_hurt=true,--the train that likes to RDM
	func_movelinear=true,--elevators, the drawbridge, killevators
}
hook.Add("DoPlayerDeath","jobtable_deaths",function(ply,_,CTakeDamageInfo)
	local killer=CTakeDamageInfo:GetAttacker()
	local weapon=killer.GetActiveWeapon and killer:GetActiveWeapon()
	if weapon and weapon:IsValid() then
	else
		weapon=CTakeDamageInfo:GetInflictor()
	end
	if CTakeDamageInfo:IsDamageType(DMG_CRUSH) and not whitelist[weapon:GetClass()] and weapon:CPPIGetOwner()!=ply then
		return--someone propkilled them. The death is not valid. Aborting function call
	end
	local JobTable=ply:getJobTable()
	if JobTable.demote then
		ply:teamBan(ply:Team(),JobTable.demote)
		timer.Simple(0,function()
			ply:changeTeam(GAMEMODE.DefaultTeam,true)
		end)
	end
	if killer==ply then return end--suicides don't count past here
	if JobTable.spiter then
		if killer:Health() then
			local Cur=killer:Health()
			local new=math.floor(Cur*math.Rand(.10,.80))
			if ply:isArrested() or ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass()=="revenants_handcuffed" then
				new=math.max(new,1)--killing a cuffed/arrested spiter bottoms out at 1
			else
				new=math.max(new,20)--normally killing a spiter bottoms out at 20
			end
			if new<Cur then
				killer:SetHealth(new)
			end
		end
	end
	if JobTable.martyr then
		for k,v in ipairs(player.GetAll()) do
			if v:GetPos():DistToSqr(ply:GetPos())<57600 and v!=ply then
				v:SetHealth(math.max(v:Health(),v:GetMaxHealth()))
			end
		end
	end
end)
