local flags={FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE}
local ShouldQuit=CreateConVar("sv_restart_should_quit","0",flags,[[set to 1 to make the server close completely when empty, set to 2 to always close the server.
Only use when the server can restart automatically if it was shut down]]):GetInt()
local SuperAdminUp=CreateConVar("sv_restart_superadmin_only","0",flags,[[set to 1 to make restarting the server via command SuperAdmin Only]]):GetBool()
local Shouldcrash=CreateConVar("sv_restart_should_crash","0",flags,[[set to 1 to make the restarter crash the server if empty, set to 2 to always crash the server,
Only use when the server can restart automatically if it was crashed]]):GetInt()
local notifyAll=function(type,time,msg)
	if msg then
		print(msg)
		if type and time and DarkRP and DarkRP.notifyAll then
			DarkRP.notifyAll(type,time,msg)
		else
			PrintMessage(HUD_PRINTTALK,msg)
		end
	end
end

local RestartFn=function(type,time,msg)
	notifyAll(type,time,msg)
	timer.Simple(time,function()
		if !game.IsDedicated() then
			RunConsoleCommand("changelevel",game.GetMap())--by changing the level to the current map, we effectively restart the server
		elseif #player.GetHumans()==0 and ShouldQuit==1 or ShouldQuit>1 then
			RunConsoleCommand("_restart")--this actually closes the server
		elseif #player.GetHumans()==0 and Shouldcrash==1 or Shouldcrash>1 then
			ents.Create("worldspawn"):Remove()--this will crash the server
		else
			RunConsoleCommand("changelevel",game.GetMap())--by changing the level to the current map, we effectively restart the server
		end
	end)
end

hook.Add("Initialize","sv_restart_Initialize",function(ply)
	timer.Simple(1,function()
		hook.Add("PlayerDisconnected","sv_restart_empty_server",function(ply)
			timer.Simple(0.1,function()--delay for a tenth of a second
				if (player.GetCount())==0 then--the server is now empty?
					timer.Create("sv_restart_empty_server_timer",598,1,function()--after 10 minutes of being empty we execute a function
						RestartFn(1,2,"server was restarted for being idle too long")
					end)
				end
			end)
		end)
	end)
end)

hook.Add("PlayerInitialSpawn","sv_restart_player_join",function(ply)--called when someone joins
	timer.Remove("sv_restart_empty_server_timer")--stop the empty server timer
	local cur_uptime=cur_uptime or 0--we want to define cur_uptime only when the first player joins
	local max_uptime=1440--define how long we can have the server run before a restart, 1440 minutes is one day
	timer.Create("sv_restart_uptime_tracker",60,0,function()--runs a function every minute

		cur_uptime=cur_uptime+1--increment the uptime counter

		if max_uptime-cur_uptime==30 then--30 minutes left
			notifyAll(3,8,"30 minutes till auto restart!")
		elseif max_uptime-cur_uptime==10 then--10 minutes left
			notifyAll(3,8,"10 minutes till auto restart!")
		elseif max_uptime-cur_uptime==5 then-- 5 minutes left
			notifyAll(3,8," 5 minutes till auto restart!")
		elseif max_uptime-cur_uptime==1 then-- 1  minute left
			notifyAll(3,8," 1 minute  till auto restart!")
		elseif max_uptime-cur_uptime<=0 then-- 0 minutes left
			RestartFn(1,3," 0 minutes till auto restart!")
		end
	end)
end)

concommand.Add("sv_restart_now",function(ply)
	if ply and IsValid(ply) and !ply:IsSuperAdmin() and SuperAdminUp then
		ply:SendLua([[print('Unknown command "sv_restart_now"')]])--make it seem like the command doesn't exist
		--DarkRP.notify(ply,1,4,"Only SuperAdmins can that command")--tell them why it failed
	elseif ply and IsValid(ply) and !ply:IsAdmin() then
		ply:SendLua([[print('Unknown command "sv_restart_now"')]])--make it seem like the command doesn't exist
		--DarkRP.notify(ply,1,4,"Only admins and up can use that command")--tell them why it failed
	elseif ply and IsValid(ply) then--so a player ran the command
		RestartFn(1,3,ply:Nick().." ("..ply:SteamID()..") restarted the server")
	else--it was run from the server console
		RestartFn(1,3,"CONSOLE (nil) restarted the server")
	end
end)
