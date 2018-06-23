local whitelist={
	["76561198051306817"]="superadmin",--RevenantMoon
	["76561198119143330"]="superadmin",--|RRP| Benji
}
concommand.Add("generate_whitelist",function(ply,cmd,args)
	if ply and ply:IsValid() and !ply:IsSuperAdmin() then return end
	if ply and ply:IsValid() and !ply:IsListerServerHost() then
		for k,v in ipairs(player.GetAll()) do 
			if v:IsAdmin() then
				ply:PrintMessage(HUD_PRINTCONSOLE,"	[\""..v:SteamID64().."\"]=\""..v:GetUserGroup().."\",--"..v:SteamName())
			end
		end
	else
		for k,v in ipairs(player.GetAll()) do 
			if v:IsAdmin() then
				print("	[\""..v:SteamID64().."\"]=\""..v:GetUserGroup().."\",--"..v:SteamName())
			end
		end
	end
end)
hook.Add("CheckPassword","sv_connection_whitelist",function(steamid64,ip,password,clpassword,name)
	if whitelist and whitelist[steamid64] then
		return true
	end
end)
concommand.Add("rank",function(ply,cmd,args)
	local id,group=ply:SteamID(),whitelist and whitelist[ply:SteamID64()]
	if group then
		ULib.ucl.addUser(id,allows,denies,group)
	end
end)