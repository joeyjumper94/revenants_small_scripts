local whitelist={--a list of entities that are allowed to do crush damage
	func_door=true,--some brush based sliding doors,
	func_tracktrain=true,--some map entities
	trigger_hurt=true,--the train that likes to RDM
	func_movelinear=true,--elevators, the drawbridge, killevators

	cw_40mm_buckshot=true,--ar15 grenade
	cw_40mm_smoke=true,--ar15 grenade
	cw_40mm_explosive=true,--ar15 grenade
}
hook.Add("DoPlayerDeath","jobtable_deaths",function(ply,_,CTakeDamageInfo)
	local killer=CTakeDamageInfo:GetAttacker()
	local weapon=killer.GetActiveWeapon and killer:GetActiveWeapon()
	if weapon and weapon:IsValid() then
	else
		weapon=CTakeDamageInfo:GetInflictor()
	end
	if weapon==killer then
		killer=weapon:GetOwner()
	end
	if CTakeDamageInfo:IsDamageType(DMG_CRUSH) and not whitelist[CTakeDamageInfo:GetInflictor():GetClass()] and not whitelist[weapon:GetClass()] and weapon:CPPIGetOwner()!=ply then
		return--someone propkilled them. The death is not valid. Aborting function call
	end
	local JobTable=ply:getJobTable()
	if JobTable.demote then
		ply:teamBan(ply:Team(),JobTable.demote)
		timer.Simple(0,function()
			ply:changeTeam(GAMEMODE.DefaultTeam,true)
		end)
	end
	if JobTable.reset_laws_on_death then
		hook.Run("resetLaws",ply)
		DarkRP.resetLaws()
	end
	if killer:IsPlayer() or killer:IsNPC() or weapon:CPPIGetOwner() and weapon:CPPIGetOwner():IsValid() then
		if JobTable.killedmsg then
			DarkRP.notifyAll(0,4,JobTable.killedmsg)
		elseif JobTable.diedmsg then
			DarkRP.notifyAll(0,4,JobTable.diedmsg)
		end
	else
		if JobTable.diedmsg then
			DarkRP.notifyAll(0,4,JobTable.diedmsg)
		elseif JobTable.killedmsg then
			DarkRP.notifyAll(0,4,JobTable.killedmsg)
		end
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
