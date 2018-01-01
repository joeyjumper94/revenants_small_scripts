local banmsgf=file.Read("ulx/banmessage.txt") or ""
banmsg=string.Split(banmsgf,[[; The two steam ID vairables are useful for constructing URLs for appealing bans
]])[2] or [[-------===== [ BANNED ] =====-------

---= Reason =---
{{REASON}}

---= Time Left =---
{{TIME_LEFT}}]]

hook.Add("CheckPassword","ULibBanCheck",function(steamid64,ip,password,clpassword,name)
	if !ULib then
		for k,v in ipairs(player.GetAll()) do
			if v and v:IsValid() and v:IsAdmin() then
				PrintMessage(HUD_PRINTTALK,"sv_ban_msg only works if ULib is installed") 
			end
		end
		hook.Remove("ULibBanCheck")
		return 
	end

	local steamid = util.SteamIDFrom64( steamid64 )
	local banData = ULib.bans[ steamid ]
	if !banData then return end -- Not banned

	PrintTable(banData)

	banmsg=string.Replace(banmsg,"{{STEAMID64}}",steamid64)
	banmsg=string.Replace(banmsg,"{{STEAMID}}",steamid)

	local admin = "Console"
	if banData.admin and banData.admin ~= "" then
		admin = banData.admin
	end
	banmsg=string.Replace(banmsg,"{{BANNED_BY}}",admin)

	local reason = "(None given)"
	if banData.reason and banData.reason ~= "" then
		reason = banData.reason
	end
	banmsg=string.Replace(banmsg,"{{REASON}}",reason)

	local time=os.date("%m/%d/%y %H:%M:%S",os.time())
	if banData.time then
		time=os.date("%m/%d/%y %H:%M:%S",banData.time)
	end
	banmsg=string.Replace(banmsg,"{{BAN_START}}",time)


	local unbanStr = "(Permaban)"
	local unban = tonumber( banData.unban )
	if unban and unban > 0 then
		unbanStr = ULib.secondsToStringTime( unban - os.time() )
	end
	banmsg=string.Replace(banmsg,"{{TIME_LEFT}}",unbanStr)
	
	Msg(string.format("%s (%s)<%s> was kicked by ULib because they are on the ban list\n", name, steamid, ip))
	return false,banmsg
end)