AddCSLuaFile()
local CATEGORY_NAME = "JailSystem"
function ulx.jailroom(ply, target, seconds, reason, unjail)
	for i=1, #target do
		if unjail == false then
			local v = target
			JailRoom(v, seconds)
			if reason == "" then
				local str = "#A jailed #T for #i seconds without reason"
				ulx.fancyLogAdmin(ply, str, target, seconds)
			else
				
				local str = "#A jailed #T for #i seconds. Reason: #s"
				ulx.fancyLogAdmin(ply, str, target, seconds, reason)
				target:SetNWInt("ulxJailReason",reason)--set a networked string to show the reason
			end
		else
			local v = target
			local str = "#A unjailed #T"
			ulx.fancyLogAdmin(ply, str, target)
			UnJail(v)
		end
	end
end
local jailroom = ulx.command(CATEGORY_NAME, "ulx jailrom", ulx.jailroom, "!jailroom")
jailroom:addParam{ type=ULib.cmds.PlayersArg }
jailroom:addParam{ type=ULib.cmds.NumArg, min=0, default=0, hint="seconds", ULib.cmds.round, ULib.cmds.optional }
jailroom:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine}
jailroom:addParam{ type=ULib.cmds.BoolArg, invisible=true }
jailroom:defaultAccess( ULib.ACCESS_ADMIN )
jailroom:help( "Jail player in jailroom " )
jailroom:setOpposite( "ulx unjailroom", {_, _, _, _, true}, "!unjailroom" )
function JailRoom(ply,seconds)
	if ply.jailed then return end
	ply.jailed = true
	ply.timer = seconds
	--ply:KillSilent()
	ply:SetPos(Vector(-3482.346436, -4608.569824, 904.031250))
	ply:StripWeapons()
	if timer.Exists(ply:UniqueID().."ulxJailTimer") then
		timer.Remove(ply:UniqueID().."ulxJailTimer")
	end
	timer.Create(ply:UniqueID().."ulxJailTimer",1,seconds,function()
		if ply:IsValid() then
			local time_left=timer.RepsLeft(ply:UniqueID().."ulxJailTimer")
			ply:SetNWInt("ulxJailTimer",time_left)
			if time_left>1 then
				UnJail(ply, true)
			end
		end
	end)
end

function UnJail(ply)
	if ply.jailed then
		ply:SetNWInt("ulxJailTimer",0)
		ply:SetNWInt("ulxJailReason","")
		ply.jailed = false
		timer.Remove(ply:UniqueID().."ulxJailTimer")
		ply:KillSilent()
		DarkRP.notify(ply, 2, 8,  "You have been unjailed")
	end
end

hook.Add("PlayerSpawn","ulxSpawnInJailIfDead",function(ply)
	if ply.jailed then
		timer.Simple(1,function()
			ply:SetPos(Vector(-3482.346436, -4608.569824, 904.031250))
		end)
	end
end)

hook.Add("CanPlayerSuicide","ulxSuicedeCheck",function(ply)
	if ply.jailed then
		return false
	end
end)
hook.Add("PlayerSpawnProp","ulxBlockSpawnIfInJail",function(ply)
	if ply.jailed then
		return false
	end
end)
hook.Add("canBuyVehicle","ulxcanbuyveh",function(ply)
	if ply.jailed then
		return false
	end
end)
hook.Add("PlayerCanPickupWeapon","ulxcanuseswep",function(ply)
	if ply.jailed then
		return false
	end
end)
hook.Add("canBuyShipment","ulxcanbuyshipment",function(ply)
	if ply.jailed then
		return false
	end
end)
hook.Add("canBuyPistol","ulxcanbuypistol",function(ply)
	if ply.jailed then
		return false
	end
end)
hook.Add("canBuyCustomEntity","ulxcanbuyentity",function(ply)
	if ply.jailed then
		return false
	end
end)
hook.Add("canBuyAmmo","ulxcanbuyammo",function(ply)
	if ply.jailed then
		return false
	end
end)
hook.Add("PlayerCanPickupItem","ulxPickUpRest",function(ply)
	if ply.jailed then
		return false
	end
end)

if SERVER then
	hook.Add("PlayerDisconnected","ulxColumntIfNeed",function(ply)
		if ply.jailed then
			ULib.ban(ply,480,"disconnecting while admin jailed")
			DarkRP.notifyAll(0,4,"Player "..ply:Nick()..", ("..ply:SteamID()..") was banned for disconnecting while admin jailed")
		end
	end)
	return
end
hook.Add("PreDrawHUD","jail_time_hud",function()
	local ply=LocalPlayer()
	local time_left=ply:GetNWInt("ulxJailTimer",0)
	local reason=ply:GetNWInt("ulxJailReason","none given")
	if ply.jailed then
		if time_left>0 then
			draw.SimpleText(
[[you are jailed.
time left: ]]..time_left..[[
Reason: ]]..reason,"DermaDefault",ScrW()*0.5,ScrH()*0.5,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
end)