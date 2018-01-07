local rda_blocker_arrests_without_mayor=CreateConVar("rda_blocker_arrests_without_mayor","5",FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,"how many people can you arrest in a given time when there's mo mayor?"):GetInt()
local rda_blocker_time=CreateConVar("rda_blocker_time","60",FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,"how long is a given time?"):GetFloat()
local rda_blocker_arrests_when_mayor=CreateConVar("rda_blocker_ignore_when_mayor","15",FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,"how many people can you arrest when there is a mayor?"):GetInt()
local rda_blocker_text=CreateConVar("rda_blocker_text","you shouldn't be arresting so many people",FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,"the text to show when someone arrests to many people"):GetString()
local rda_blocker_demote_time=CreateConVar("rda_blocker_demote_time","-1",FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,"how long should someone e demoted for? set to -1 to use the value from daarkrpmodification"):GetInt()
local rda_blocker_list={}
local function rda_blocker_mayor_present()
	for k,v in ipairs(player.GetAll()) do
		if v:isMayor() then
			return true
		end
	end
	return false
end
timer.Create("rda_blocker_initialize",1,0,function()
	if GAMEMODE then
		timer.Remove("rda_blocker_initialize")
		if rda_blocker_demote_time<0 then rda_blocker_demote_time=GAMEMODE.Config.demotetime or 120 end
		hook.Add("canArrest","rda_blocker_arrest",function(cop,criminal)
			if cop and criminal and cop:IsValid() and criminal:IsValid() and cop:IsPlayer() and criminal:IsPlayer() and cop:SteamID64() and criminal:SteamID64() and cop:isCP() then
				cop.rda_blocker_count=cop.rda_blocker_count or 0
				rda_blocker_list=rda_blocker or {}
				cop.rda_blocker_count=cop.rda_blocker_count+1
				if cop.rda_blocker_count>rda_blocker_arrests_without_mayor and !rda_blocker_mayor_present() then 
					cop:teamBan(cop:Team(),rda_blocker_demote_time)
					for k,ply in ipairs(player.GetAll()) do
						if ply and ply:isArrested() and ply.rda_blocker_list==cop then
							ply:unArrest(cop)
						end
					end
					if rda_blocker_text!="" then
						DarkRP.notify(cop,1,8,rda_blocker_text)
					end
					DarkRP.log(cop:Nick().." ("..cop:SteamID()..") was demoted for arresting too many people")
					cop.rda_blocker_count=nil
					cop:changeTeam(GAMEMODE.DefaultTeam, true)
					return false
				elseif cop.rda_blocker_count>rda_blocker_arrests_when_mayor then
					cop:teamBan(cop:Team(),rda_blocker_demote_time)
					for k,ply in ipairs(player.GetAll()) do
						if v and v:isArrested() and v.rda_blocker_list==cop then
							v:unArrest(cop)
						end
					end
					if rda_blocker_text!="" then
						DarkRP.notify(cop,1,8,rda_blocker_text)
					end
					DarkRP.log(cop:Nick().." ("..cop:SteamID()..") was demoted for arresting too many people")
					cop.rda_blocker_count=nil
					cop:changeTeam(GAMEMODE.DefaultTeam, true)
					return false
				end
				print("rda_blocker_list["..tostring(criminal).."]="..tostring(cop))
				criminal.rda_blocker_list=cop
				print("rda_blocker_list["..tostring(criminal).."]="..tostring(rda_blocker_list[criminal]))
				timer.Simple(rda_blocker_time,function()
					if cop and cop:IsValid() and cop:IsPlayer() and cop.rda_blocker_count and cop.rda_blocker_count>0 then
						cop.rda_blocker_count=cop.rda_blocker_count-1
					end
				end)
			end
		end)
		hook.Add("PlayerDisconnect","rda_blocker_disconnect",function(criminal)
			if criminal and criminal:IsValid() and criminal:IsPlayer() and criminal:SteamID64() and rda_blocker_list then
				rda_blocker_list[criminal:SteamID64()]=nil
			end
		end)
		hook.Add("playerUnArrested","rda_blocker_unarrest",function(criminal,cop)
			if criminal and criminal:IsValid() and criminal:IsPlayer() and criminal:SteamID64() and rda_blocker_list then
				rda_blocker_list[criminal:SteamID64()]=nil
			end
		end)
		print("loaded rda_blocker")

		concommand.Add("rda_blocker_list_arrests",function(ply,cmd,args)
			if ply and IsValid(ply) and !ply:IsAdmin() then
				
			elseif ply and ply:IsValid() then
				for k,v in ipairs(player.GetAll()) do
					if k.rda_blocker_list then
						ply:PrintMessage(HUD_PRINTTALK,k:Nick().."is arrested by "..k.rda_blocker_list:Nick().." ("..k.rda_blocker_list:SteamID()..")")
					end
				end
			else
				for k,v in ipairs(player.GetAll()) do
					if k.rda_blocker_list then
						print(k:Nick().."is arrested by "..k.rda_blocker_list:Nick().." ("..k.rda_blocker_list:SteamID()..")")
					end
				end
			end
		end)
	end
end)
