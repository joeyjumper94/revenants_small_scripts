local example={
	["SteamID64"]="owner",
	["SteamID64"]="co-owner",
	["SteamID64"]="operator",
	["SteamID64"]="superadmin",
	["SteamID64"]="head-admin",
	["SteamID64"]="admin",
	["SteamID64"]="moderator",
	["SteamID64"]="legendary",
	["SteamID64"]="mega",
	["SteamID64"]="veteran",
	["SteamID64"]="vip",
	["SteamID64"]="trusted",
	["SteamID64"]="root member",
	["SteamID64"]="member",
	["SteamID64"]="user",
	["SteamID64"]="noaccess",
}
local whitelist={
	["76561198051306817"]="operator",--Revenant Moon
	["76561197963299583"]="owner",--RainbowThunderInfiniteMLP
	["76561193987039740"]="co-owner",--amber strike
	["76561198027247892"]="superadmin",--pizza pone
	["76561193872492992"]="superadmin",--not musical
}
concommand.Add("generate_whitelist",function(ply,cmd,args)
	if game.IsDedicated() then
		if ply:IsValid() and !ply:IsSuperAdmin() then return end
	elseif ply.IsListerServerHost then
		if ply:IsValid() and !ply:IsSuperAdmin() and !ply:IsListerServerHost() then return end
	end
	if ply:IsValid() then
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
hook.Add("CheckPassword"," sv_onnection_whitelist",function(steamid64,ip,password,clpassword,name)
	if whitelist and whitelist[steamid64] then
		return true
	end
end)
concommand.Add("rank",function(ply,cmd,args)
	local id,group=ply:SteamID(),whitelist and whitelist[ply:SteamID64()]
	if group then
		ULib.ucl.addUser(id,allows,denies,group)
		ply:PrintMessage(HUD_PRINTCONSOLE,group)
	end
end)