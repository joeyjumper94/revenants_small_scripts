gameevent.Listen( "player_connect" )
hook.Add( "player_connect", "player_connect_example", function( data )
	local name		= data.name		-- Same as Player:Nick()
	local steamid 	= data.networkid-- Same as Player:SteamID()
	local ip		= data.address	-- Same as Player:IPAddress()
	local id		= data.userid	-- Same as Player:UserID()
	local bot		= data.bot		-- Same as Player:IsBot()
	local index		= data.index	-- Same as Player:EntIndex()

	-- Player has connected; this happens instantly after they join -- do something..

	msg="Player "..name.." <"..steamid.."> joined the game."
	for k,v in ipairs(player.GetAll()) do
		if v and v:IsValid() and v:IsAdmin() then
			v:PrintMessage(HUD_PRINTTALK,msg.." (userip = "..ip..")")
		elseif v and v:IsValid() then
			v:PrintMessage(HUD_PRINTTALK,msg)
		end
	end
	ServerLog(msg.." (userip = "..ip..")".."\n")

end)

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "player_disconnect_example", function( data )
	local name		= data.name		-- Same as Player:Nick()
	local steamid	= data.networkid-- Same as Player:SteamID()
	local id		= data.userid	-- Same as Player:UserID()
	local bot		= data.bot		-- Same as Player:IsBot()
	local reason	= data.reason	-- Text reason for disconnected such as "Kicked by console!", "Timed out!", etc...
	-- Player has disconnected - this is more reliable than PlayerDisconnect
	msg="Player "..name.." <"..steamid.."> left the game. ("..reason..")"

	PrintMessage(HUD_PRINTTALK,msg)
	ServerLog(msg.."\n")
end )