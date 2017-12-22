TIMER_NAME="cancel_auth_loader"
timer.Create(TIMER_NAME,5,5,function()
	if ulx then
		timer.Remove("cancel_auth_loader")
		function ulx.cancelauth(calling_ply,target_ply)
			if target_ply and target_ply:IsValid() then
			
				if target_ply:IsListenServerHost() then
					ULib.tsayError(calling_ply,"This player is immune to kicking",true)
					return
				end
				ulx.fancyLogAdmin( calling_ply, "#A Canceled the steam auth ticket of #T", target_ply,true,true )
				ULib.kick(target_ply,"Client left game (Steam auth ticket has been canceled)")
			end
		end
		local cancel_auth=ulx.command("Revenant's ulx extensions","ulx cancel_auth",ulx.cancelauth,"!cancel_auth")
		cancel_auth:addParam{type=ULib.cmds.PlayerArg}
		cancel_auth:defaultAccess(ULib.ACCESS_ADMIN)
		cancel_auth:help("cancel someone's steam authentication ticket")
		print"loaded ulx cancel auth"
	elseif timer.RepsLeft(TIMER_NAME)==1 then
		error("ulx and ulib MUST be installed")
	end
end)