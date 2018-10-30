hook.Add("PlayerNoClip","ulx_noclip_hook",function(ply,enter)
	if ULib and ULib.ucl.query(ply,"ulx noclip") then
		return true
	end
end)
--[[
local 
blacklist={dronesrewrite_nukedr=true}hook.Add("OnEntityCreated","banned_ents",function(ent)timer.Simple(0,function()if ent and ent:IsValid()and blacklist[ent:GetClass()]then ent:Remove()end end)end)
--]]