AddCSLuaFile()
local delay=delay or 30
timer.Simple(delay,function()
	delay=0	
	if ulx and ULib then
		local CATEGORY_NAME="Revenant's extensions"
		function ulx.cancelauth(calling_ply,target_ply)
			if target_ply and target_ply:IsValid() then
			
				if target_ply:IsListenServerHost() then
					ULib.tsayError(calling_ply,"This player is immune to kicking",true)
					return
				end
				ulx.fancyLogAdmin( calling_ply, "#A Canceled the steam auth ticket of #T", target_ply,true,true )
				target_ply:Kick("Client left game (Steam auth ticket has been canceled)")
			end
		end
		local cancel_auth=ulx.command(CATEGORY_NAME,"ulx cancel_auth",ulx.cancelauth,"!cancel_auth",false,false,true )
		cancel_auth:addParam{type=ULib.cmds.PlayerArg}
		cancel_auth:defaultAccess(ULib.ACCESS_ADMIN)
		cancel_auth:help("cancel someone's steam authentication ticket")

		print"loaded Revenant's steamauth extensions"
	else
		print"ULX and ULib MUST be installed"
	end
end)