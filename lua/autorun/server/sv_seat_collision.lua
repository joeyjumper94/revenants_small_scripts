hook.Add("PlayerEnteredVehicle","player_collision",function(ply,veh,role)
	timer.Simple(0.1,function()
		if ply:IsValid() and ply:GetVehicle()==veh then
			ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end
	end)
end)