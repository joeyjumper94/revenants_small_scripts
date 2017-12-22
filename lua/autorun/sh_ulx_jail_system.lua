AddCSLuaFile()
local jailpos=Vector(0,0,0)
local CATEGORY_NAME="Revenant's ulx extensions"

concommand.Add("jailtest",function(ply,cmd,args)
	print("jailpos=Vector("..jailpos.x..","..jailpos.y..","..jailpos.z..")")
	if ply and ply:IsValid() and !ply:IsSuperAdmin() then
	elseif true then
	print(CATEGORY_NAME)
	elseif false then
		RunConsoleCommand("bot")
		timer.Simple(1,function()
			RunConsoleCommand("ulx","jailroom","*","30","test")
		end)
	end
end)
timer.Create("jail_system_loader",5,5,function()
	if ulx then
		timer.Remove("jail_system_loader")

		if file.Exists("ulx_jailroom_pos/"..game.GetMap()..".txt","DATA") then
			data=util.JSONToTable(file.Read("ulx_jailroom_pos/"..game.GetMap()..".txt","DATA"))
			if data and data["x"] and data["y"] and data["z"] then
				jailpos=Vector(data["x"],data["y"],data["z"])
			end
		end


		function ulx.jailroomset(ply)
			if ply and ply:IsValid() and ply:IsPlayer() then
				local str="#A set the jailroom position for "..game.GetMap()
				ulx.fancyLogAdmin(ply,str)
				jailpos=ply:GetPos()
				file.CreateDir("ulx_jailroom_pos")
				local data={
					["x"]=jailpos.x,
					["y"]=jailpos.y,
					["z"]=jailpos.z,
				}
				print(util.TableToJSON(data))
				file.Write("ulx_jailroom_pos/"..game.GetMap()..".txt",util.TableToJSON(data))
			else
				print"you cannot use the position of someone who is are everywhere and nowhere at the same time"
			end
		end
		local jailroomset=ulx.command(CATEGORY_NAME,"ulx jailroomset",ulx.jailroomset,"!jailroomset")
		jailroomset:defaultAccess(ULib.ACCESS_SUPERADMIN)
		jailroomset:help("set the position of the jailroom for the current map")


		function ulx.jailroom(ply,target,seconds,reason,unjail)
			for i=1,#target do
				local v=target[i]
				if unjail==false then
					JailRoom(v,seconds)
					if reason=="" then
						local str="#A sent #T to the jailroom #i seconds without reason"
						ulx.fancyLogAdmin(ply,str,target,seconds)
					else
						local str="#A sent #T to the jailroom for #i seconds. Reason: #s"
						ulx.fancyLogAdmin(ply,str,target,seconds,reason)
						v:SetNWString("ulxJailReason",reason)--set a networked string to show the reason
					end
				else
					local str="#A released #T from the jailroom"
					ulx.fancyLogAdmin(ply,str,target)
					UnJail(v)
				end
			end
		end
		local jailroom=ulx.command(CATEGORY_NAME,"ulx jailroom",ulx.jailroom,"!jailroom")
		jailroom:addParam{type=ULib.cmds.PlayersArg}
		jailroom:addParam{type=ULib.cmds.NumArg,min=0,default=0,hint="seconds",ULib.cmds.round,ULib.cmds.optional}
		jailroom:addParam{type=ULib.cmds.StringArg,hint="reason",ULib.cmds.optional,ULib.cmds.takeRestOfLine}
		jailroom:addParam{type=ULib.cmds.BoolArg,invisible=true}
		jailroom:defaultAccess(ULib.ACCESS_ADMIN)
		jailroom:help("Jail player in jailroom ")
		jailroom:setOpposite("ulx unjailroom",{_,_,_,_,true},"!unjailroom")
		function JailRoom(ply,seconds)
			if ply.jailed then return end
			ply.jailed=true
			ply.timer=seconds
			--ply:KillSilent()
			
			ply:SetPos(jailpos)
			ply:StripWeapons()
			if timer.Exists(ply:SteamID64().."ulxJailTimer") then
				timer.Remove(ply:SteamID64().."ulxJailTimer")
			end
			ply:SetNWInt("ulxJailTimer",seconds)
			timer.Create(ply:SteamID64().."ulxJailTimer",1,seconds,function()
				if ply:IsValid() then
					local time_left=timer.RepsLeft(ply:SteamID64().."ulxJailTimer")
					ply:SetNWInt("ulxJailTimer",time_left)
					if time_left<1 then
						UnJail(ply,true)
					end
				end
			end)
		end

		function UnJail(ply)
			if ply.jailed then
				ply:SetNWInt("ulxJailTimer",0)
				ply:SetNWString("ulxJailReason","")
				ply.jailed=false
				timer.Remove(ply:SteamID64().."ulxJailTimer")
				ply:KillSilent()
				if DarkRP then
					DarkRP.notify(ply,2,8,"You have been unjailed")
				else
					ply:PrintMessage(HUD_PRINTTALK,"You have been unjailed")
				end
			end
		end

		if SERVER then
			hook.Add("PlayerNoClip","ulxBlockNoclipIfInJail",function(ply,desiredState)
				if desiredState==true and ply.jailed then
					return false
				end
			end)
			hook.Add("PlayerSpawn","ulxSpawnInJailIfDead",function(ply)
				if ply.jailed then
					timer.Simple(0,function()
						ply:SetPos(jailpos)
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
			hook.Add("PlayerDisconnected","ulxColumntIfNeed",function(ply)
				if ply.jailed then
					ULib.ban(ply,480,"disconnecting while admin jailed")
					if darkrp then
						DarkRP.notifyAll(1,4,"Player "..ply:Nick()..", ("..ply:SteamID()..") was banned for disconnecting while admin jailed")
					else
						PrintMessage(HUD_PRINTTALK,"Player "..ply:Nick()..", ("..ply:SteamID()..") was banned for disconnecting while admin jailed")
					end
				end
			end)
			print"loaded ulx_jailsystem"
			return
		end

		hook.Add("HUDPaint","jail_time_hud",function()
			local ply=LocalPlayer()
			local time_left=ply:GetNWInt("ulxJailTimer",0)
			local reason=ply:GetNWString("ulxJailReason","none given")
			if time_left>0 then
				draw.DrawText('you are jailed.\ntime left: '..time_left..'\nReason: '..reason.."\nDisconnecting will result in a ban","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.425,Color(255,255,255,255),TEXT_ALIGN_CENTER)
			end
		end)
	elseif timer.RepsLeft("jail_system_loader")==1 then
		error("ulx and ulib MUST be installed")
	end
end)