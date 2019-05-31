hook.Add("PlayerSay","no_hard_rs_please",function(ply,text,teamonly)
	text=text:lower()
	if text:StartWith"/a " or text:StartWith"//" or text:StartWith"/ooc " or text:StartWith"@ " then--speaking in OOC?
		text=text:Replace("3","e")
		text=text:Replace("1","i")
		text=text:Replace("4","a")
		text=text:Replace("a","e")
		if text:find"nigger" or text:find"niger" then--said a very bad word into OOC
			if ply.swear then
				if ply.jailed and timer.Timeleft(ply:SteamID64().."ulxJailTimer")<=120 then
					return ""
				end
				RunConsoleCommand("ulx","jailroom","$"..ply:SteamID(),"120","Don't say the N word")
			else
				RunConsoleCommand("ulx","psay","$"..ply:SteamID(),"Don't say the N word")
				ply.swear=true
			end
			return ""
		end
	end
end)