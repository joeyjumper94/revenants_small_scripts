immunity_time=100

local endimmunity=function(ply,type,time,msg)
	if ply and ply:IsValid() and ply:IsPlayer() then--is it a valid player?
		if timer.Exists(ply:SteamID64().."'s immunity") then--is it an immune dictator?
			timer.Remove(ply:SteamID64().."'s immunity")
			if msg then
				PrintMessage(HUD_PRINTTALK,msg)
				if type and time then
					DarkRP.notifyAll(type,time,msg)
				end
			end
			timer.Simple(0,function()
				timer.Simple(0,function()
					if ply and ply:IsValid() then
						for k,v in pairs(ply:getJobTable().weapons) do
							ply:Give(v)
						end
					end
				end)
			end)
		end
	end
end

hook.Add("PlayerSay","dictator_immunity_ender",function(ply,text,teamChat)
	if ply and ply:IsValid() and ply:IsPlayer() and ply:getJobTable() then--is it a valid player?
		if ply:getJobTable().mayor then--and timer.Exists(ply:SteamID64().."'s immunity") then--is it an immune dictator?
			if string.lower(text):find("endimmunity") then
				endimmunity(ply,4,8,"the "..team.GetName(ply:Team()).." ended his immunity")
			end
		end
	end
end)

hook.Add("OnPlayerChangedTeam","dictator_immunity_starter",function(ply,before,after)
	if ply and ply:IsValid() and ply:IsPlayer() and ply:getJobTable() then--is it a valid player?
		if RPExtraTeams[after].mayor then--they became mayor
			timer.Create(ply:SteamID64().."'s immunity",immunity_time,1,function()
				endimmunity(ply,0,8,"the "..team.GetName(ply:Team()).." immunity ran out")
			end)
			PrintMessage(HUD_PRINTTALK,"the "..team.GetName(ply:Team()).." has been made immune for "..immunity_time.." seconds")
			DarkRP.notifyAll(0,8,"the "..team.GetName(ply:Team()).." is now immune")
		elseif timer.Exists(ply:SteamID64().."'s immunity") then--they switched out of dictator during their grace time
			endimmunity(ply,1,8,"the "..team.GetName(before).." switched teams")
		end
	end
end)

hook.Add("PlayerShouldTakeDamage","dictator_immunity_damage_blocker",function(ply,weapon)
	if ply and ply:IsValid() and ply:IsPlayer() and ply:getJobTable() then--is it a valid player?
		if ply:getJobTable().mayor and timer.Exists(ply:SteamID64().."'s immunity") then--is it an immune dictator?
			return false--returning false on this hook blocks damage
		end
	end
end)

hook.Add("PlayerDisconnected","dictator_immunity_disconnect_handler",function(ply) 
	if ply and ply:IsValid() and ply:IsPlayer() and ply:getJobTable() then--is it a valid player?
		if timer.Exists(ply:SteamID64().."'s immunity") then
			endimmunity(ply,1,8,"the "..team.GetName(ply:Team()).." left the server before his immunity ran out")
		end	
	end
end)

hook.Add("PlayerCanPickupWeapon","dictator_immunity_anti_abuse",function(ply,wep)
	if ply and ply:IsValid() and ply:IsPlayer() and ply:getJobTable() then--is it a valid player?
		if ply:getJobTable().mayor and timer.Exists(ply:SteamID64().."'s immunity") then--is it an immune mayor?
			local class=wep:GetClass()

			if wep:CPPIGetOwner() and wep:CPPIGetOwner():IsSuperAdmin() then-- a SuperAdmin gave a weapon
				DarkRP.notify(ply,0,8,"you got a "..class.." as a gift from the gods")
			elseif !table.HasValue(GAMEMODE.Config.AdminWeapons,class) and !table.HasValue(GAMEMODE.Config.DefaultWeapons,class) then
			--is it not something that everyone gets and not something that admins get?
				if timer.TimeLeft(ply:SteamID64().."'s immunity")<immunity_time then
					DarkRP.notify(ply,1,8,[[you can't equip weapons while immune,
you can end your immunity early by typing "endimmunity" into chat.
you have ]]..math.Round(timer.TimeLeft(ply:SteamID64().."'s immunity"),2).." seconds left")
				end
				return false--returning false on this hook blocks them from picking up a weapon
			end
		end
	end
end)