hook.Add('CanProperty','nostrip',function(ply,property,ent)
    if ent and ent:IsValid() and !ent:GetPhysicsObject():IsValid() and !ply:IsAdmin() then
	--first 2 checks make sure the entity is valid, 3rd check sees if the ent has no physics object, such as a weapon, 4th check is if the player is not an admin
		ply:PrintMessage(HUD_PRINTTALK,'you connot use "'..property..'" on "'..ent:GetClass()..'"!')
        return false
    end
end)