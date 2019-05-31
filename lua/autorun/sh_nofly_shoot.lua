local nofly_shoot=CreateConVar("sv_nofly_shoot","1",bit.bor(FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED),"if set to 1, shooting a gun will end flight"):GetBool()
cvars.AddChangeCallback("sv_nofly_shoot",function(v,o,n)
	nofly_shoot=n!="0"
	if SERVER then
		PrintMessage(HUD_PRINTTALK,"Server cvar '"..v.."' changed to "..n)
	end
end,"sv_nofly_shoot")
local yes={
}
local no={
}
hook.Add("KeyPress","nofly_shoot",function(ply,key)
	if SERVER and nofly_shoot and key==IN_ATTACK and ply:GetMoveType()==MOVETYPE_FLY then
		local weapon=ply:GetActiveWeapon()
		weapon=weapon:IsValid() and weapon:GetClass() or "none"
		print(weapon)
		if yes[weapon] then
			ply:SetMoveType(MOVETYPE_WALK)
			ply.DoubleJump=-1
		elseif !no[weapon] then
			if weapon:StartWith("cw_") or weapon:StartWith'khr_' then
				ply:SetMoveType(MOVETYPE_WALK)
				ply.DoubleJump=-1
				yes[weapon]=true
			else
				no[weapon]=true
			end
		end
	end
end)