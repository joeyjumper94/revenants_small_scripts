--[[
	demote=true,boolean, must be true for demotetime,demoteto,killedmsg, and diedmsg to work
	demoteto=TEAM_CITIZEN,--number, what job to set someone to, if blank or the job is full, the will go to the default job
	demotetime=30,--number, how long to demote
	killedmsg="job was killed",--string, can also be a function(Killer,Weapon,CTakeDamageInfo)
	diedmsg="job has died",--string, can also be a function(Killer,Weapon,CTakeDamageInfo)
	reset_laws_on_death=true,--if set to true, the laws will reset when they die, usefull on mayors.
	spiter=true,--boolean, will killing this player cause the attacker to lose health
	martyr=true,-- boolean, when killed, anyone within 240 HU of this player will have all HP restored.
--]]
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
	if not DarkRP then return end
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
		ply:teamBan(ply:Team(),JobTable.demotetime)
		timer.Simple(0,function()
			local max=JobTable.demoteto and RPExtraTeams[JobTable.demoteto] and RPExtraTeams[JobTable.demoteto].max
			local Cur = max and team.NumPlayers(JobTable.demoteto)
			if !max then
				ply:changeTeam(GAMEMODE.DefaultTeam,true)
			elseif max==0 then
				ply:changeTeam(JobTable.demoteto,true)
			elseif max>1 and Cur<max then
				ply:changeTeam(JobTable.demoteto,true)
			elseif max<1 and(Cur+1)/player.GetCount()>max then
				ply:changeTeam(JobTable.demoteto,true)
			else
				ply:changeTeam(GAMEMODE.DefaultTeam,true)
			end
		end)
		if killer:IsPlayer() or killer:IsNPC() or weapon:CPPIGetOwner() and weapon:CPPIGetOwner():IsValid() then
			if JobTable.killedmsg then
				if type(JobTable.killedmsg)=="function"then
					local msg=JobTable.killedmsg(ply,_,CTakeDamageInfo)
					if msg then
						DarkRP.notifyAll(0,4,tostring(msg))
					end
				else
					DarkRP.notifyAll(0,4,tostring(JobTable.killedmsg))
				end
			elseif JobTable.diedmsg then
				if type(JobTable.diedmsg)=="function"then
					local msg=JobTable.diedmsg(ply,_,CTakeDamageInfo)
					if msg then
						DarkRP.notifyAll(0,4,tostring(msg))
					end
				else
					DarkRP.notifyAll(0,4,tostring(JobTable.diedmsg))
				end
				DarkRP.notifyAll(0,4,JobTable.diedmsg)
			elseif string.lower(ply:getDarkRPVar("job"))!=string.lower(team.GetName(ply:Team())) then
				DarkRP.notifyAll(0, 4, "The "..ply:getDarkRPVar("job").." ("..team.GetName(ply:Team())..") was killed and is therefore demoted.")
			else
				DarkRP.notifyAll(0, 4, "The "..ply:getDarkRPVar("job").." was killed and is therefore demoted.")
			end
		else
			if JobTable.diedmsg then
				if type(JobTable.diedmsg)=="function"then
					local msg=JobTable.killedmsg(ply,_,CTakeDamageInfo)
					if msg then
						DarkRP.notifyAll(0,4,tostring(msg))
					end
				else
					DarkRP.notifyAll(0,4,tostring(JobTable.diedmsg))
				end
			elseif JobTable.killedmsg then
				if type(JobTable.killedmsg)=="function"then
					local msg=JobTable.diedmsg(ply,_,CTakeDamageInfo)
					if msg then
						DarkRP.notifyAll(0,4,tostring(msg))
					end
				else
					DarkRP.notifyAll(0,4,tostring(JobTable.killedmsg))
				end
			elseif string.lower(ply:getDarkRPVar("job"))!=string.lower(team.GetName(ply:Team())) then
				DarkRP.notifyAll(0, 4, "The "..ply:getDarkRPVar("job").." ("..team.GetName(ply:Team())..") has died and is therefore demoted.")
			else
				DarkRP.notifyAll(0, 4, "The "..ply:getDarkRPVar("job").." has died and is therefore demoted.")
			end
		end
	end
	if JobTable.reset_laws_on_death then
		hook.Run("resetLaws",ply)
		DarkRP.resetLaws()
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
