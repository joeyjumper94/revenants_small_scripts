--[[local GRENADES={
	["40mm_buckshot"]=true,
	["40mm_smoke"]=true,
}--]]
hook.Add("EntityTakeDamage"," cw_grenade_fix",function(Entity,CTakeDamageInfo)
	local attacker=CTakeDamageInfo:GetAttacker()
	if attacker:IsValid() and attacker:GetClass():find'40mm_'then
		local weapon=CTakeDamageInfo:GetInflictor()
		local ply=weapon:IsValid() and weapon:GetOwner()
		if ply and ply:IsValid() then
			CTakeDamageInfo:SetAttacker(ply)
		end
	end
end)   
