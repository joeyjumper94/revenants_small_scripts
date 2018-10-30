immunity_time=100
local endimmunity=function(ply,type,time,msg)
	if ply and ply.getJobTable and ply:getJobTable() then -- is the player valid?
		if timer.Exists(ply:SteamID64().."'s immunity") then--is it an immune dictator?
			timer.Remove(ply:SteamID64().."'s immunity")
			if msg then
				PrintMessage(HUD_PRINTTALK,msg)
				if type and time then
					DarkRP.notifyAll(type,time,msg)
				end
			end
			timer.Simple(0,function()--delay by 2 frames
				timer.Simple(0,function()
					if ply and ply:IsValid() then
						for k,v in pairs(ply:getJobTable().weapons) do--loop over the weapons that come with their job
							ply:Give(v)--the them said weapons
						end
					end
				end)
			end)
		end
	end
end

hook.Add("PlayerSay","mayor_immunity",function(ply,text,teamChat)
	if ply and ply.getJobTable and ply:getJobTable() then -- is the player valid?
		if ply:getJobTable().mayor then--and timer.Exists(ply:SteamID64().."'s immunity") then--is it an immune dictator?
			if string.lower(text):find("endimmunity") then--they are trying to end their immunity
				endimmunity(ply,4,8,"the "..team.GetName(ply:Team()).." ended his immunity")
			end
		end
	end
end)

hook.Add("OnPlayerChangedTeam","mayor_immunity",function(ply,before,after)
	if ply and ply.getJobTable and ply:getJobTable() then -- is the player valid?
		if RPExtraTeams[after].mayor then--they became mayor
			timer.Create(ply:SteamID64().."'s immunity",immunity_time,1,function()
				endimmunity(ply,0,8,"the "..team.GetName(ply:Team()).."'s immunity ran out")
			end)
			PrintMessage(HUD_PRINTTALK,"the "..team.GetName(ply:Team()).." has been made immune for "..immunity_time.." seconds")
			DarkRP.notifyAll(0,8,"the "..team.GetName(ply:Team()).." is now immune")
		elseif timer.Exists(ply:SteamID64().."'s immunity") then--they switched out of dictator during their grace time
			endimmunity(ply,1,8,"the "..team.GetName(before).." switched teams")
		end
	end
end)

hook.Add("EntityTakeDamage","dictator_immunity_damage_blocker",function(ply,CTakeDamageInfo)
	if ply and ply.getJobTable and ply:getJobTable() then -- is the player valid?
		if ply:getJobTable().mayor and timer.Exists(ply:SteamID64().."'s immunity") then--is it an immune dictator?
			CTakeDamageInfo:SetDamageType(DMG_FALL) --fall damage won't affect armor
			CTakeDamageInfo:SetDamage(0) --set the damage to 0
		end
	end
end)

hook.Add("PlayerDisconnected","mayor_immunity",function(ply) 
	if ply and ply:IsValid() and ply:IsPlayer() and ply:getJobTable() then--is it a valid player?
		if timer.Exists(ply:SteamID64().."'s immunity") then
			endimmunity(ply,1,8,"the "..team.GetName(ply:Team()).." left the server before his immunity ran out")
		end	
	end
end)

local allowed_weapons={}--this table will contain a list of weapons that admins will alway be given on spawn
local populate_list=function()--this function populates the allowed_weapons table
	if GAMEMODE.Config then
		for k,v in ipairs(GAMEMODE.Config.DefaultWeapons) do
			allowed_weapons[v]=true
		end
		for k,v in ipairs(GAMEMODE.Config.AdminWeapons) do
			allowed_weapons[v]=true
		end
	else
		for k,event in ipairs{
			"EntityTakeDamage",
			"Initialize",
			"OnPlayerChangedTeam",
			"PlayerCanPickupWeapon",
			"PlayerDisconnected",
			"PlayerSay",
		}do
			hook.Remove(event,"mayor_immunity")
		end
	end
end
hook.Add("PlayerCanPickupWeapon","mayor_immunity",function(ply,wep)
	if ply and ply.getJobTable and ply:getJobTable() then--is it a valid player?
		if ply:getJobTable().mayor and timer.Exists(ply:SteamID64().."'s immunity") then--is it an immune mayor?
			local class=wep:GetClass()

			if wep:CPPIGetOwner() and wep:CPPIGetOwner():IsSuperAdmin() then-- a SuperAdmin gave a weapon
				DarkRP.notify(ply,0,8,"you got a "..class.." as a gift from the gods")
			elseif !allowed_weapons[class] then
			--is it not something that everyone gets and not something that admins get?
				if timer.TimeLeft(ply:SteamID64().."'s immunity")<immunity_time then
					DarkRP.notify(ply,1,8,[[you can't equip weapons while immune,
type "endimmunity" into chat to end your immunity early.
you have ]]..math.Round(timer.TimeLeft(ply:SteamID64().."'s immunity"),2).." seconds left")
				end
				return false--returning false on this hook blocks them from picking up a weapon
			end
		end
	end
end)
hook.Add("Initialize","mayor_immunity",populate_list)--this calls the populate_list function when the gamemode loads
if GAMEMODE and GAMEMODE.Config and GAMEMODE.Config.DefaultWeapons or player.GetAll()[1] then populate_list() end--this does the same as the hook but only after the gamemode has loaded
