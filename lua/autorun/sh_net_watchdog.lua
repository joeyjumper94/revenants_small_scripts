if CLIENT then 
	
	
	return 
end
local NOLOG={--list of names to not log
	armdupe=true,
	["DPP.UpdateLang"]=true
}
local int=0
local months={"january","febuary","march","april","may","june","july","august","September","october","november","december"}
local days={"1st","2nd","3rd","4rth","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"}
local time=function()
--	local year=tonumber( os.date("20%y",os.time()) )
	local month=tonumber( os.date("%m",os.time()) )
	local day=tonumber( os.date("%d",os.time()) )
--	local hour=tonumber( os.date("%H",os.time()) )
--	local minute=tonumber( os.date("%M",os.time()) )
--	local second=tonumber( os.date("%S",os.time()) )
	return os.date("%Y-"..months[month].."-"..days[day].." %H:%M:%S ",os.time()).." "..os.date("",os.time())..": "
end
local write=function(string)
	file.Append(net_watchdog_FILE,time()..string.."\n")
end
hook.Add("Initialize","net_watchdog",function()
	file.CreateDir("net_watchdog_files")
	local FILES,FOLDERS=file.Find("net_watchdog_files/*.txt","DATA")
	for INT,FIL in ipairs(FILES) do
		if not file.Exists("net_watchdog_files/log"..(INT)..".txt","DATA") then
			file.Write("net_watchdog_files/log"..(INT)..".txt","DELETED FILE")
		end
	end
	FILES,FOLDERS=file.Find("net_watchdog_files/*.txt","DATA")
	net_watchdog_FILE="net_watchdog_files/log"..(#FILES+1)..".txt"
	file.Write(net_watchdog_FILE,"")
	if write then
		write("server has started/restarted")
	end
end)
hook.Add("ShutDown","net_watchdog",function()
	if write then
		write("server cleanly shut down")
	end
end)
gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect","net_watchdog",function( data )
	local name = data.name			// Same as Player:Nick()
	local steamid = data.networkid		// Same as Player:SteamID()
	local id = data.userid			// Same as Player:UserID()
	local bot = data.bot			// Same as Player:IsBot()
	local reason = data.reason		// Text reason for disconnected such as "Kicked by console!", "Timed out!", etc...
	if write then--and not reason:find"kick"and not reason:find"map"and not reason:find"ban"and not reason:find"disconnect"then
		write(name.." ("..steamid..") left the game ("..reason..")")
	end
end)
function net.Incoming( len, ply )
	ply.NET_MESSAGE=(ply.NET_MESSAGE or 0)+1
	if ply.NET_MESSAGE==1 then
		timer.Simple(10,function()
			if ply and ply:IsValid() then
				ply.NET_MESSAGE=0
			end
		end)
	elseif ply.NET_MESSAGE>=1000 then
		if ply.NET_MESSAGE>=10000 then
			ply:Kick(ply.NET_MESSAGE.." net messages")
		end
		return
	end
	local INT=net.ReadHeader()
	local NAME=util.NetworkIDToString(INT)
	if !NAME then return end
	local func = net.Receivers[ NAME:lower() ]
	if not NOLOG[NAME] and write then
		write("net message received. Sender's steamID is ("..ply:SteamID()..") Net message's name is "..NAME)-- log it
	end
	if !func then return end
	len=len-16
	local success,error=pcall(func,len,ply)
	if !success then
		ply.NET_ERRORS=(ply.NET_ERRORS or 0)+1
		if ply.NET_ERRORS==1 then
			timer.Simple(1,function()
				if ply and ply:IsValid() then
					ply.NET_ERRORS=0
				end
			end)
		elseif ply.NET_ERRORS>=100 then
			ply:Kick("too many net errors, sorry")
		end
	end
	if NOLOG and NOLOG[NAME] then return end
	if !success and write then--is my logger script on?
		write("error message is: "..error)-- log it
	elseif write then
		write("funcion successfully ran")-- log it
	end
end