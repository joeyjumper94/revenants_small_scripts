local blacklist={
	["STEAM_0:1:148750445"]={--4evolution
		admin="(Console)",
		reason="extremely toxic",
		time=os.time(),
		unban=0,
	},
	["STEAM_0:0:127519646"]={--Rj
		admin="(Console)",
		reason="extremely toxic",
		time=os.time(),
		unban=0,
	},
	["STEAM_0:1:162942198"]={--Pepsi,
		admin="(Console)",
		reason="Very Petty",
		time=os.time(),
		unban=0,
	},
	["76561193775028373"]={--Ms Magical,
		admin="(Console)",
		reason="Very Petty",
		time=os.time(),
		unban=0,
	},
	["STEAM_0:0:0"]={
		admin="hardwired ban",
		reason="example banid",
		time=os.time(),
		unban=0,
	},
	["00000000000000000"]={
		admin="hardwired ban",
		reason="example banid64",
		time=os.time(),
		unban=0,
	},
	["0.0.0.0"]={
		admin="hardwired ban",
		reason="example banip",
		time=os.time(),
		unban=0,
	},
}

local banmsgf=file.Read("ulx/banmessage.txt") or ""
banmsgf=banmsgf:Split([[; The two steam ID vairables are useful for constructing URLs for appealing bans
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
		hook.Remove("CheckPassword","ULibBanCheck")
		return 
	end
	local steamid = util.SteamIDFrom64( steamid64 )
	local banData = ULib.bans[ steamid ]
	if !banData then
		banData=blacklist[ip:Split":"[1]] or blacklist[steamid64] or blacklist[steamid]
		if banData then
			local time,reason,name=0,banData.reason,banData.name or name
			ULib.addBan(steamid,time,reason,name,admin)
		end
	end
	if !banData then return end -- Not banned
	blacklist[ip:Split":"[1]]=banData
	local banmsg=banmsgf
	local unbanStr = "(Permaban)"
	local unban = tonumber( banData.unban )
	if unban and unban > 0 then
		local left=unban-os.time()
		if left<0 then 
			return--expired
		end
		unbanStr = ULib.secondsToStringTime(left)
	end
	banmsg=banmsg:Replace("{{TIME_LEFT}}",unbanStr)
	banmsg=banmsg:Replace("{{STEAMID64}}",steamid64)
	banmsg=banmsg:Replace("{{IP}}",ip)
	banmsg=banmsg:Replace("{{STEAMID}}",steamid)

	local admin = "Console"
	if banData.admin and banData.admin ~= "" then
		admin = banData.admin
	end
	banmsg=banmsg:Replace("{{BANNED_BY}}",admin)

	local reason = "(None given)"
	if banData.reason and banData.reason ~= "" then
		reason = banData.reason
	end
	banmsg=banmsg:Replace("{{REASON}}",reason)

	local time=os.date("%m/%d/%y %H:%M:%S",os.time())
	if banData.time then
		time=os.date("%m/%d/%y %H:%M:%S",banData.time)
	end
	banmsg=banmsg:Replace("{{BAN_START}}",time)
	
	Msg(string.format("%s (%s)<%s> was kicked by ULib because they are on the ban list\n", name, steamid, ip))
	return false,banmsg
end)