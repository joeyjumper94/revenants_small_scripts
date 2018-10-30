hook.Add("OnPlayerChangedTeam","remembered_job",function(ply,old,new)
	timer.Simple(0.1,function()
		if ply and ply:IsValid() then
--			ply:SetPData("remembered_job",new)
			if RPExtraTeams and old and new and RPExtraTeams[old] and RPExtraTeams[new] and RPExtraTeams[old].category!=RPExtraTeams[new].category then
				ply:Spawn()
			end
		end
	end)
end)
hook.Add("PlayerInitialSpawn","remembered_job",function(ply)
	timer.Simple(0.1,function()
		if ply and ply:IsValid() then
			local new=tonumber(ply:GetPData("remembered_job"))
			if new then
				ply:changeTeam(new,true)
			end
		end
	end)
end)