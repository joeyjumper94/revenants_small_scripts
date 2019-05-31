local func=function()
	for k,v in ipairs(ents.GetAll())do
		if v:GetClass()=="prop_dynamic" and v:GetPos():WithinAABox(
		Vector(-2389,699,151),
		Vector(-3211,1147,308)) and v:GetModel()=="models/props_wasteland/prison_celldoor001a.mdl" then
			v:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		end
	end
end
hook.Add("Initialize","jail_door_collision",func)
hook.Add("InitPostEntity","jail_door_collision",func)
hook.Add("PostCleanupMap","jail_door_collision",func)
if GAMEMODE and GAMEMODE.Config or player.GetAll()[1] then func() end
--lua_openscript autorun/server/sv_jail_door_collisions.lua