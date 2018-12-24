hook.Add("OnPlayerChangedTeam","anti_job_change_abuse",function(ply,old,new)
	if GAMEMODE.CivilProtection[old]!=GAMEMODE.CivilProtection[new] then
		timer.Simple(0.1,function()
			if ply and ply:IsValid() and ply:Alive() then
				ply:Spawn()
			end
		end)
	end
end)