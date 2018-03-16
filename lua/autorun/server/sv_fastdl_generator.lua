concommand.Add("generate_fastdl",function(ply,cmd,args)
	if ply and ply:IsValid() and !ply:IsSuperAdmin() and !ply:IsListerServerHost() then return end
	local addons=engine.GetAddons()
	local tbl={}
	for k,v in ipairs(addons) do
		if v.mounted then
			table.insert(tbl,'	resource.AddWorkshop("'..v.wsid..'") --'..v.title..' '..v.models..[[ models
]])
		end
	end
	local str=''
	for k,v in ipairs(tbl) do
		str=str..v
	end
	file.Write('revenants_fastdl.txt',str)
	if ply and ply:IsValid() and !ply:IsListerServerHost() then
		ply:PrintMessage(HUD_PRINTTALK,'check your data folder, there should be a file named "revenants_fastdl.txt"')
		ply:PrintMessage(HUD_PRINTTALK,'Rename it to revenants_fastdl.lua and put it in the "garrysmod/lua/autorun/server"')
	else
		print'check your data folder, there should be a file named "revenants_fastdl.txt"'
		print'Rename it to revenants_fastdl.lua and put it in the "garrysmod/lua/autorun/server"'
	end
end)