local example={
	["SteamID64"]="owner",
	["SteamID64"]="staffmanager",
	["SteamID64"]="superadmin",
	["SteamID64"]="admin",
	["SteamID64"]="mod",
	["SteamID64"]="tmod",
	["SteamID64"]="helper",
	["SteamID64"]="user",
	["SteamID64"]="noaccess",
}
local whitelist={
	["76561198075529998"]="superadmin",--Azhdonv 
	["76561198149369636"]="staffmanager",--spike
	["76561198273953632"]="superadmin",--kilper gilgus
	["76561198141583333"]="superadmin",--Fenix
	["76561198286150125"]="staffmanager",--pepsi
	["76561198109245578"]="owner",--hawkren
	["76561198051306817"]="superadmin",--Revenant Moon
	["76561198193878353"]="admin",--Mr.Grim
	["76561198169591129"]="superadmin",--Dom (Anima Vestra)
	["76561198069995669"]="owner",--Magical
	["76561198268959284"]="superadmin",--Gimpy
--	["76561198390809362"]="staffmanager", --Lphfghtrs --he quit, and proceeded to crash the US server
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