local TIMER_NAME="ulx_crash_loader"
timer.Create(TIMER_NAME,5,5,function()
	if ulx and ULib then
		timer.Remove(TIMER_NAME)
		function ulx.crashkick( calling_ply, target_ply, reason )
			if target_ply:IsListenServerHost() then
				ULib.tsayError( calling_ply, "This player is immune to kicking", true )
				return
			end

			if reason and reason ~= "" then
				ulx.fancyLogAdmin( calling_ply, "#A crashed and kicked #T (#s)", target_ply, reason )
			else
				reason = nil
				ulx.fancyLogAdmin( calling_ply, "#A crashed and kicked #T", target_ply )
			end
			-- Delay by 1 frame to ensure the chat hook finishes with player intact. Prevents a crash.
			ULib.queueFunctionCall( ULib.kick, target_ply, reason, calling_ply )
			target_ply:SendLua("while true do cam.End3D() end")
			target_ply:SendLua("cam.End3D()")
		end
		local crash_kick = ulx.command( CATEGORY_NAME, "ulx crashkick", ulx.crashkick, "!crashkick" )
		crash_kick:addParam{ type=ULib.cmds.PlayerArg }
		crash_kick:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
		crash_kick:defaultAccess( ULib.ACCESS_SUPERADMIN)
		crash_kick:help("crash someone's game and kicks them from the server")

		function ulx.crashban( calling_ply, target_ply, minutes, reason )
			if target_ply:IsListenServerHost() or target_ply:IsBot() then
				ULib.tsayError( calling_ply, "This player is immune to banning", true )
				return
			end

			local time = "for #s"
			if minutes == 0 then time = "permanently" end
			local str = "#A crashed and banned #T " .. time
			if reason and reason ~= "" then str = str .. " (#s)" end
			ulx.fancyLogAdmin( calling_ply, str, target_ply, minutes ~= 0 and ULib.secondsToStringTime( minutes * 60 ) or reason, reason )
			-- Delay by 1 frame to ensure any chat hook finishes with player intact. Prevents a crash.
			ULib.queueFunctionCall( ULib.kickban, target_ply, minutes, reason, calling_ply )

			target_ply:SendLua("while true do cam.End3D() end")
			target_ply:SendLua("cam.End3D()")
		end
		local crash_ban = ulx.command( CATEGORY_NAME, "ulx crashban", ulx.crashban, "!crashban", false, false, true )
		crash_ban:addParam{ type=ULib.cmds.PlayerArg }
		crash_ban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
		crash_ban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
		crash_ban:defaultAccess(ULib.ACCESS_SUPERADMIN)
		crash_ban:help("crashes and bans target." )

		print("loaded "..TIMER_NAME)
	elseif timer.RepsLeft(TIMER_NAME)==1 then
		error("ulx and ulib MUST be installed")
	end
end)