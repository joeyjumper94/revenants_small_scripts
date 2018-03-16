local keypads={
	["keypad_wire"]=true,
	["keypad"]=true,
}
local function IsKeypad(e)
	if e:IsValid() and keypads[e:GetClass()] then
		return true
	end
	return false
end
hook.Add("ShouldCollide","no_keypad_crash",function(e1,e2)
	if IsKeypad(e1) and IsKeypad(e2) then
		return false
	end
end)
hook.Add("OnEntityCreated","no_keypad_crash",function(e)
	if IsKeypad(e) then
		e:SetCustomCollisionCheck(true)
		e:CollisionRulesChanged()
	end
end)