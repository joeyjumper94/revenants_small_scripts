
local flags=bit.bor(FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED)
local time=CreateConVar("sv_anti_mrdm_time","60",flags,"killing the required number of PK in this time will result in an auto want"):GetFloat()
local threshold=CreateConVar("sv_anti_mrdm_threshold","5",flags,"killing the required many PK in the required time will result in an auto want"):GetInt()
if CLIENT then return end
local record=threshold
cvars.AddChangeCallback("sv_anti_mrdm_time",function(v,o,n)
	time=tonumber(n)
	if SERVER then
		PrintMessage(HUD_PRINTTALK,"Server cvar '"..v.."' changed to "..n)
	end
end,"sv_anti_mrdm_time")
cvars.AddChangeCallback("sv_anti_mrdm_threshold",function(v,o,n)
	threshold=tonumber(n)
	if SERVER then
		PrintMessage(HUD_PRINTTALK,"Server cvar '"..v.."' changed to "..n)
	end
end,"sv_anti_mrdm_threshold")
hook.Add("DoPlayerDeath","anti_mrdm",function(ply,_,CTakeDamageInfo)
	local killer=CTakeDamageInfo:GetAttacker()
	local weapon=killer.GetActiveWeapon and killer:GetActiveWeapon() or CTakeDamageInfo:GetInflictor()
	if killer.CPPIGetOwner and killer:CPPIGetOwner() and killer:CPPIGetOwner():IsValid() then
		killer=killer:CPPIGetOwner()
	end
	if killer!=ply and killer:IsPlayer() and ply:isCP() then
		killer.cops_killed=(killer.cops_killed or 0)+1
		timer.Simple(time,function()
			if killer:IsValid() then
				killer.cops_killed=math.max(0,(killer.cops_killed or 0)-1)
			end
		end)
		if killer.cops_killed>=threshold then
			killer:wanted(nil,"detected as having killed "..killer.cops_killed.." pk in "..time.." seconds")
		end
		if killer.cops_killed>record then
			record=killer.cops_killed
			DarkRP.notifyAll(2,8,killer:Name().." broke today's record for most PK killed in "..time.." seconds")
		end
	end
end)