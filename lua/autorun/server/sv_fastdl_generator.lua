concommand.Add("generate_fastdl",function(ply,cmd,args)
	if ply and ply:IsValid() and !ply:IsSuperAdmin() and !ply:IsListerServerHost() then return end
	local addons=engine.GetAddons()
	local str=''
	for k,v in ipairs(addons) do
		if v.mounted then
			str=str..'	resource.AddWorkshop("'..v.wsid..'") --'..v.title..' '..v.models..' models\n'
		end
	end
	file.Write('revenants_fastdl.txt',str)
	if ply and ply:IsValid() and !ply:IsListerServerHost() then
		ply:PrintMessage(HUD_PRINTTALK,'check the server\'s data folder, there should be a file named "revenants_fastdl.txt"')
		ply:PrintMessage(HUD_PRINTTALK,'Rename it to revenants_fastdl.lua and put it in the "garrysmod/lua/autorun/server"')
	else
		print'check server\'s data folder, there should be a file named "revenants_fastdl.txt"'
		print'Rename it to revenants_fastdl.lua and put it in the "garrysmod/lua/autorun/server"'
	end
end)