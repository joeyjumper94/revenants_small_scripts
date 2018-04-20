concommand.Add("generate_fastdl",function(ply,cmd,args)
	if ply and ply:IsValid() and !ply:IsSuperAdmin() and !ply:IsListerServerHost() then return end
	local addons=engine.GetAddons()
	local str=''
	for k,v in ipairs(addons) do
		if v.mounted then
			if v.models==0 then
				str='	resource.AddWorkshop("'..v.wsid..'") --'..v.title..' '..v.models..' models\n'..str
			else
				str=str..'	resource.AddWorkshop("'..v.wsid..'") --'..v.title..' '..v.models..' models\n'
			end
		end
	end
file.Write('revenants_fastdl.txt',
[[if true then
]]..str..
[[end
local loaded=loaded or GAMEMODE and GAMEMODE.Config
local function init()
	loaded=true
	local MAP=game.GetMap()
	if MAP=="" then
		resource.AddWorkshop("") --, 0 models
	end
end
hook.Add("Initialize","fastdl_init",init)
if loaded then init() end]])
	if ply and ply:IsValid() and !ply:IsListerServerHost() then
		ply:PrintMessage(HUD_PRINTCONSOLE,'check the server\'s data folder, there should be a file named "revenants_fastdl.txt"')
		ply:PrintMessage(HUD_PRINTCONSOLE,'Rename it to revenants_fastdl.lua and put it in the "garrysmod/lua/autorun/server"')
	else
		print'check the server\'s data folder, there should be a file named "revenants_fastdl.txt"'
		print'Rename it to revenants_fastdl.lua and put it in the "garrysmod/lua/autorun/server"'
	end
end)