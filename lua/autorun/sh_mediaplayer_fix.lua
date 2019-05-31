if SERVER then
	hook.Add("playerBoughtCustomEntity","tv_ownership",function(ply,tbl,ent,price)
		if ply and ent and ply:IsValid() and ent:IsValid() and ply:IsPlayer() and ent:GetClass():StartWith"mediaplayer_" then
			ent:SetNWString("tv_owner_id",ply:SteamID())
			if ent.CPPISetOwner then
				ent:CPPISetOwner(ply)
			end
			if tbl and tbl.model then
				ent:SetModel(tbl.model)
				ent:PhysicsInit(SOLID_VPHYSICS)
			end
		end 
	end)
end
hook.Add("MediaPlayerIsPlayerPrivileged","tv_ownership",function(_,ply)
	if ply and ply:IsValid() then
		local ent=ply:GetEyeTrace().Entity
		if ent and ent:IsValid() and ent:GetClass():StartWith"mediaplayer_tv" then
			if ent.CPPIGetOwner and ent:CPPIGetOwner()==ply or ent:GetNWString("tv_owner_id","")==ply:SteamID() then
				return true
			end
		end
	end
end)
