hook.Add("EntityTakeDamage","Sitting_Blast_Damage",function(ent,dmg)--the hook and start of the function
	if ent and ent:IsValid() and dmg and dmg:GetDamage()!=nil and ent:IsPlayer() and ent:InVehicle() then--make sure we have damage and a player in a vehicle
		if dmg:IsDamageType(DMG_BLAST) or dmg:IsDamageType(DMG_BLAST_SURFACE) then--is it explosion damage?
			dmg:SetDamage(dmg:GetDamage()/1.75)--the hook is called twice so a sitting player would otherwise take 1.75 times the damage they should take
			dmg:SetDamageType(DMG_BULLET)--you know how you can shoot someone? here we make it so that it's the same as the damgage asociated with someone shooting you
		end
	end
end)