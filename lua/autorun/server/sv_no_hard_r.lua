local cfg={
	starts={--a list of 
		"/a ",--global OOC
		"// ",--global OOC
--		"/// ",--to admins via FAdmin
		"/ooc ",--global OOC
--		"@ ",--to admins via ULX
		"/advert ",--adchat
	},
	bads={--saying these words into global chat 
		"nigger",--the N word
--		"fuck",--the F word
--		"shit",--the S word
	}
}
hook.Add("PlayerSay","no_hard_bad_words_please",function(ply,text,teamonly)
	if #cfg.bads!=0 then
		text=text:lower()
		local start=#cfg.starts==0
		for k,v in ipairs(cfg.starts)do
			if text:StartWith(v)then
				start=v
				break
			end
		end
		if start then
			text=text:Replace("1","i")--1 could be used instead of I
			text=text:Replace("3","e")--3 could be used instead of E
--			text=text:Replace("4","a")--4 could be used instead of A
--			text=text:Replace("$","s")--$ could be used instead of S
			local found=false
			for k,v in ipairs(cfg.bads) do
				if text:find(" "..v) then
					if ply.swear then
						if ply.jailed and timer.Timeleft(ply:SteamID64().."ulxJailTimer")<=120 then
							return ""
						end
						RunConsoleCommand("ulx","ban","$"..ply:SteamID(),"1w","saying bad words ")
					else
						RunConsoleCommand("ulx","psay","$"..ply:SteamID(),"Don't say "..table.concat(cfg.bads,", "))
						ply.swear=true
					end
					return ""
				end
			end
		end
	end
end)