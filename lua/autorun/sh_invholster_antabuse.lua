local DELAY=CreateConVar("sv_itemstore_antabuse","3",bit.bor(FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED),"after getting hurt by a player, you must wait this long before you can /invholster"):GetFloat()
cvars.AddChangeCallback("sv_itemstore_antabuse",function(v,o,n)
	if PrintMessage then
		PrintMessage(HUD_PRINTTALK,"Server cvar '"..v.."' changed to "..n)
	end
	DELAY=tonumber(n)
end,"sv_itemstore_antabuse")
hook.Add("EntityTakeDamage","invholster_antabuse",function(Entity,CTakeDamageInfo)
	local attacker=CTakeDamageInfo:GetAttacker()
	if Entity:IsValid() and attacker:IsValid() and Entity:IsPlayer() and attacker:IsPlayer() then
		Entity.invholster_antabuse=CurTime()
	end
end)
hook.Add("caninvholster","invholster_antabuse",function(Player,Weapon)
	if Player.tazed_police or Player.tazed_civilian then
		return false,DarkRP.getPhrase("unable",GAMEMODE.Config.chatCommandPrefix.."invholster","while tased")
	elseif Player.invholster_antabuse and Player.invholster_antabuse+DELAY>CurTime() then
		return false,DarkRP.getPhrase("have_to_wait",math.Round(Player.invholster_antabuse+DELAY-CurTime(),2),GAMEMODE.Config.chatCommandPrefix.."invholster")
	end
end)
