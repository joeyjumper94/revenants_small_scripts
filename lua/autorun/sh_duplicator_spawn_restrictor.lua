local RANK=CreateConVar("duplicator_restrict_spawns", "trusted", {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED},'decides what rank can spawn dupes, case sensitive, use "none", "nil", "false", "0", or "" for unrestricted'):GetString()
hook.Add("CanTool","duplicator_restrictor",function(ply,trace,tool)
	if ply and tool then
		if tool=="duplicator" and !ply:CheckGroup(RANK) and !ply:IsSuperAdmin() and ply:KeyPressed(IN_ATTACK) and RANK!="nil" and RANK!="" and RANK!="none" and tobool(RANK) then
		--the first check returns true if the player is using duplicator
		--the second check returns true if the player's rank neither matches nor inherits from trusted. ULX is required
		--the third check returns true if the player is not an admin
		--the fourth check returns true if the player clicks their mouse as if trying to spawn a dupe
		--the remaining checks are for deactivation of the restriction
			ply:PrintMessage(HUD_PRINTTALK, "only SuperAdmins and users with a ulx rank that matches or inherits from "..RANK.." can spawn dupes")
			--tell them why the tool failed
			return false
			--this line here is what actaully blocks the tool from working
		end
	else
		return false
	end
end)