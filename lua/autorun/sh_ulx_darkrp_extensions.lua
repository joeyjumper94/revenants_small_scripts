local TIMER_NAME="ulx_darkrp_extensions"
local CATEGORY_NAME="Revenant's ulx extensions"
timer.Create(TIMER_NAME,5,5,function()
	if ulx and ULib then
		timer.Remove(TIMER_NAME)

		local function date()
			local minute=60
			local hour=minute*60
			local day=hour*24
			local month={--we are counting how many days have elapsed since the start of the year
				0,--Jan
				day*31,--Feb, 
				day*(31+28),--Mar will lose one day at the close of febuary 29 AKA leap day
				day*(31+28+31),--Apr
				day*(31+28+31+30),--May
				day*(31+28+31+30+31),--Jun
				day*(31+28+31+30+31+30),--Jul
				day*(31+28+31+30+31+30+31),--Aug
				day*(31+28+31+30+31+30+31+31),--Sep
				day*(31+28+31+30+31+30+31+31+30),--Oct
				day*(31+28+31+30+31+30+31+31+30+31),--Nov
				day*(31+28+31+30+31+30+31+31+30+31+30),--Dec
			}
			local year=day*365

			local seconds=tonumber(os.date("%S",os.time()))
			local minutes=minute*tonumber(os.date("%M",os.time()))
			local hours=hour*tonumber(os.date("%H",os.time()))
			local days=day*tonumber(os.date("%d",os.time()))
			local months=month[tonumber(os.date("%m",os.time()))]
			local years=year*tonumber(os.date("%Y",os.time()))
			return seconds+minutes+hours+days+months+years
		end

		concommand.Add("print_time",function()
			print(date())
		end)

		hook.Add("playerCanChangeTeam","cp_ban_check",function(ply,TEAM,force)
			if ply and TEAM and ply:IsPlayer() and GAMEMODE.CivilProtection[TEAM] then--is it a player trying to become a civil protection?
				local time=tonumber(ply:GetPData("cp_ban_list","0"))
				if time!=0 then
					if time>date() then
						if time-date>604800 then--that's how many seconds are in a week
							return false,DarkRP.getPhrase("have_to_wait", math.ceil(time-date()), "/"..RPExtraTeams[TEAM].command..", "..DarkRP.getPhrase("banned_or_demoted"))
						end
						return false,DarkRP.getPhrase("unable", "/"..RPExtraTeams[TEAM].command, DarkRP.getPhrase("banned_or_demoted"))
					end
				end
				ply:SetPData("cp_ban_list","0")
			end
		end)

		function ulx.cpunban(calling_ply,target_ply)
			local str = "#A unbanned #T from being civil protection"
			ulx.fancyLogAdmin( calling_ply, str, target_ply)
			cp_ban_list[tonumber(target_ply:SteamID64())]=nil
		end
		local cp_unban=ulx.command( CATEGORY_NAME, "ulx cpunban", ulx.cpunban, "!cpunban", false, false, true )
		cp_unban:addParam{ type=ULib.cmds.PlayerArg }
		cp_unban:defaultAccess(ULib.ACCESS_ADMIN)
		cp_unban:help("unbans target from civil protection.")

		function ulx.cpban( calling_ply, target_ply, minutes, reason )

			local time = "for #s"
			if minutes == 0 then time = "permanently" end
			local str = "#A banned #T from being civil protection " .. time
			if reason and reason ~= "" then str = str .. " (#s)" end
			ulx.fancyLogAdmin( calling_ply, str, target_ply, minutes ~= 0 and ULib.secondsToStringTime( minutes * 60 ) or reason, reason )

			if GAMEMODE.CivilProtection[target_ply:Team()] then
				target_ply:changeTeam(GAMEMODE.DefaultTeam,true,true)
			end

			if tobool(minutes) then
				target_ply:SetPData("cp_ban_list",date()+minutes*60)
			else
				target_ply:SetPData("cp_ban_list",date()+9972201600)--316 years is a long time
			end
		end
		local cp_ban = ulx.command( CATEGORY_NAME, "ulx cpban", ulx.cpban, "!cpban", false, false, true )
		cp_ban:addParam{ type=ULib.cmds.PlayerArg }
		cp_ban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 means permanently", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
		cp_ban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
		cp_ban:defaultAccess(ULib.ACCESS_ADMIN)
		cp_ban:help("bans target from civil protection." )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		print("loaded "..TIMER_NAME)
	elseif timer.RepsLeft(TIMER_NAME)==1 then
		timer.Remove("ulx_team_ban_clock")
		error("ulx and ulib MUST be installed")
	end
end)