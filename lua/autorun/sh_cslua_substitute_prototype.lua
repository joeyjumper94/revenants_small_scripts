if SERVER then
	return--no need for the server to read anything after here
end
local blacklist={--if someone's usergoup is in here, they will not be able to use this bypasser at all
	["banned"]=true,
	["minge"]=true,
	["noaccess"]=true,
	["noscripts"]=true,
	["user"]=true,
}
timer.Simple(3,function()
	if !blacklist[LocalPlayer():GetUserGroup()] then
		local files={}--for the autocomplete function of lua_openscript_substitute
		timer.Simple(10,function()--this timer is so that the parts of this script are not done all at once
			local filesL1, foldersL1 = file.Find("*", "LUA")
			for key, fileL1 in ipairs(filesL1) do
				table.insert(files," "..fileL1)
			end
			for key, folderL1 in ipairs(foldersL1) do
				local filesL2,foldersL2=file.Find(folderL1.."/*", "LUA")
				for key, fileL2 in ipairs(filesL2) do
					table.insert(files," "..folderL1.."/"..fileL2)
				end
				for key, folderL2 in ipairs(foldersL2) do
					local filesL3,foldersL3=file.Find(folderL1.."/"..folderL2.."/*", "LUA")
					for key, fileL3 in ipairs(filesL3) do
						table.insert(files," "..folderL1.."/"..folderL2.."/"..fileL3)
					end
					for key, folderL3 in ipairs(foldersL3) do
						local filesL4,foldersL4=file.Find(folderL1.."/"..folderL2.."/"..folderL3.."/*", "LUA")
						for key, fileL4 in ipairs(filesL4) do
							table.insert(files," "..folderL1.."/"..folderL2.."/"..folderL3.."/"..fileL4)
						end
					end
				end
			end
		end)
		concommand.Add("lua_openscript_substitute",function(ply,cmd,args)
			if blacklist[ply:GetUserGroup()] then
				RunConsoleCommand("retry")
			elseif args and args[1] and args[1]!="" then--are they using invalid arguements?
				include(args[1])
			else
				print('Executes a Lua script relative to the /lua/ folder, if you have the perms to.\nexamples:\nlua_openscript_substitute autorun/client/falcoutilities.lua')
			end
		end,
		function(cmd,typed)--autocomplete
			local  tbl={}
			for k,v in pairs(files) do
				if string.StartWith(v,tostring(typed)) then
					table.insert(tbl,cmd..v)
				end
			end
			return tbl
		end,'Executes a Lua script relative to the /lua/ folder.\nexample:\nlua_openscript_substitute autorun/client/falcoutilities.lua')
		concommand.Add("lua_run_substitute",function(ply,cmd,args)
			if blacklist[ply:GetUserGroup()] then
				RunConsoleCommand("retry")
			elseif args and args[1] and args[1]!="" then--are they using invalid arguements?
				RunString(table.concat(args," "))
			else
				print('run lua on yourself.\nexamples:\nlua_run_substitute print("hello world")\nlua_run_substitute print("my name is"..LocalPlayer():Nick()..".")')
			end
		end,'run lua on yourself.\nexamples:\nlua_run_substitute print("hello world")\nlua_run_substitute print("my name is"..LocalPlayer():Nick()..".")')
	end
end)