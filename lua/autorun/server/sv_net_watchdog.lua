local NOLOG={--list of names to not log
	armdupe=true,
}
hook.Add("Initialize","net_watchdog",function()
	if sv_log_func then
		sv_log_func("net_watchdog","server has started/restarted")
	end
end)
hook.Add("ShutDown","net_watchdog",function()
	if sv_log_func then
		sv_log_func("net_watchdog","server cleanly shut down")
	end
end)
gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect","net_watchdog",function( data )
	local name = data.name			// Same as Player:Nick()
	local steamid = data.networkid		// Same as Player:SteamID()
	local id = data.userid			// Same as Player:UserID()
	local bot = data.bot			// Same as Player:IsBot()
	local reason = data.reason		// Text reason for disconnected such as "Kicked by console!", "Timed out!", etc...
	if sv_log_func and not reason:find"kick"and not reason:find"map"and not reason:find"ban"and not reason:find"disconnect"then
		sv_log_func("net_watchdog",name.." ("..steamid..") left the game ("..reason..")")
	end
end)
function net.Incoming( len, ply )
	ply.NET_MESSAGE=(ply.NET_MESSAGE or 0)+1
	if ply.NET_MESSAGE==1 then
		timer.Simple(10,function()
			if ply and ply:IsValid() then
				ply.NET_MESSAGE=0
			end
		end)
	elseif ply.NET_MESSAGE>=1000 then
		if ply.NET_MESSAGE>=10000 then
			ply:Kick(ply.NET_MESSAGE.." net messages")
		end
		return
	end
	local INT=net.ReadHeader()
	local NAME=util.NetworkIDToString(INT)
	if !NAME then return end
	local func = net.Receivers[ NAME:lower() ]
	if sv_log_func then
		sv_log_func("net_watchdog","net message received\nsender's steamID is "..ply:SteamID()..
			"\nnet message's name is "..NAME
		)-- log it
	end
	if !func then return end
	len=len-16
	local success,error=pcall(func,len,ply)
	if !success then
		ply.NET_ERRORS=(ply.NET_ERRORS or 0)+1
		if ply.NET_ERRORS==1 then
			timer.Simple(1,function()
				if ply and ply:IsValid() then
					ply.NET_ERRORS=0
				end
			end)
		elseif ply.NET_ERRORS>=100 then
			ply:Kick("too many net errors, sorry")
		end
	end
	if NOLOG and NOLOG[NAME] then return end
	if !success and sv_log_func then--is my logger script on?
		sv_log_func("net_watchdog","error message is: "..error)-- log it
	elseif sv_log_func then
		sv_log_func("net_watchdog","funcion successfully ran")-- log it
	end
end