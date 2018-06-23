local function func()
	if game.GetMap()!="rp_rockford_open" then return end
	for k,v in ipairs(ents.FindInSphere(Vector(-6400,-5528,-14402.559570313),20)) do
		if string.StartWith(v:GetClass(),"trigger_mul") then
			v:Remove()
		end
	end
end
func()
timer.Simple(0,func)
hook.Add("initialize","bye_trigger,",func)
hook.Add("InitPostEntity","bye_trigger",func)
hook.Add("PostCleanupMap","bye_trigger",func)