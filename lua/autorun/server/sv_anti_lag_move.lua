hook.Add("StartCommand","anti_lag_move",function(Player,CUserCmd)
	if CUserCmd:IsForced() then
		CUserCmd:ClearMovement()
	end
end)
