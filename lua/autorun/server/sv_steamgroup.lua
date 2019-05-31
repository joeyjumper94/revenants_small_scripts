local rank="trusted"--rank to set a player to if in steamgroup
local URL="http://steamcommunity.com/groups/"--url of the steamgroup
hook.Add("PlayerSay","SteamGroupMemberCheck",function(ply,text)
	text=text:lower()
	if text:StartWith"!steam"or text:StartWith"/steam"then
		local id=ply:SteamID64()
		timer.Create("SteamGroupMemberCheck"..id,6,10,function()
			if ply:IsValid() and !ply:CheckGroup(rank)then--ignore they leave or if already that rank or above it
				http.Fetch(URL.."/memberslistxml/?xml=1&lolwat="..os.time(),function(b)
					if b:find(id) and ply:IsValid() then
						RunConsoleCommand("ulx","adduserid",ply:SteamID(),rank)
						"SteamGroupMemberCheck"..id
					end
				end,function(error)
					print("error checking membership of "..id)
					print(error)
				end)
			elseif !ply:IsValid() then
				timer.Remove("SteamGroupMemberCheck"..id)
			end
		end)
	end
end)
hook.Add("PlayerInitialSpawn","SteamGroupMemberCheck",function(ply)
	local id=ply:SteamID64()
	timer.Create("SteamGroupMemberCheck"..id,6,10,function()
		if ply:IsValid() and !ply:CheckGroup(rank)then--ignore they leave or if already that rank or above it
			http.Fetch(URL.."/memberslistxml/?xml=1&lolwat="..os.time(),function(b)
				if b:find(id) and ply:IsValid() then
					RunConsoleCommand("ulx","adduserid",ply:SteamID(),rank)
					"SteamGroupMemberCheck"..id
				end
			end,function(error)
				print("error checking membership of "..id)
				print(error)
			end)
		else
			timer.Remove("SteamGroupMemberCheck"..id)
		end
	end)
end)