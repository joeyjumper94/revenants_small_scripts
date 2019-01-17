local DisallowDrop={-- The list of weapons that players are not allowed to drop. Items set to true are not allowed to be dropped.
	arrest_stick = true,
	gmod_camera = true,
	gmod_tool = true,
	keys = true,
	pocket = true,
	stunstick = true,
	weapon_keypadchecker = true,
	weapon_physcannon = true,
	weapon_physgun = true,
	weaponchecker = true,
--	door_ram = true,
--	lockpick = true,
--	med_kit = true,
--	unarrest_stick = true,
}
smart_drop_blacklist=function()
	if GAMEMODE.Config then
		--make sure any admin, and default weapons are in the blacklist
		for k,v in ipairs(GAMEMODE.Config.DefaultWeapons) do
			DisallowDrop[v]=true
		end
		for k,v in ipairs(GAMEMODE.Config.AdminWeapons) do
			DisallowDrop[v]=true
		end
	else
		timer.Simple(0,function()
			for k,event in ipairs{
				"Initialize",
				"PlayerLoadout",
				"canDropWeapon",
			}do
				hook.Remove(event,"smart_drop_blacklist")
			end
		end)
	end
end
hook.Add("Initialize","smart_drop_blacklist",smart_drop_blacklist)
if GAMEMODE and GAMEMODE.Config then smart_drop_blacklist() end
hook.Add("PlayerLoadout","smart_drop_blacklist",function(ply)
	ply.DisallowDrop={}--a list of weapons a player received on spawn, they are not allowed to drop these
	local JobTable=ply:getJobTable()
	if JobTable and JobTable.weapons then
		for k,v in ipairs(JobTable.weapons)do
			ply.DisallowDrop[k]=true
		end
	end
end)
hook.Add("canDropWeapon","smart_drop_blacklist",function(ply,wep)
	local cls=ply and ply.DisallowDrop and wep and wep:IsValid() and wep:GetClass()
	if cls then
		if DisallowDrop[cls] or ply.DisallowDrop[cls] then
			return false
		end
	end
end)