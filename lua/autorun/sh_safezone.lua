local MAP=game.GetMap():lower()
local line1="Revenant's safe zone"
local color1=Color(255,255,255,255)

local line2="you are free of all damage"
local color2=Color(255,255,255,255)

local line3=""
local color3=Color(255,255,255,255)

local line4=""
local color4=Color(255,255,255,255)

local line5=""
local color5=Color(255,255,255,255)
--end of config

local safe={--the min values must be first
-- players will be safe from damage if they are inside a box defined by these two vectors
	Vector(-2340.81,-2008.91,-203.71),
	Vector(-1468.72,-1132.25,100),
}
local spawn={--the min values must be first
--	players will spawn somewhere inside a box defined by these two vectors
	Vector(-2203,-1861,96),
	Vector(-1608,-1282,96)
}
if MAP=="rp_downtown_v6_dtg_c" then
	safe={
		Vector(-2279.9,-1947.88,-203.71),Vector(-1544.99,-1192.07,-27)
	}
	spawn=nil
	local remove=function()
		for k,v in ipairs(ents.FindByClass'info_player_start')do
			if!v:GetPos():WithinAABox(Vector(-2279.9,-1947.88,-203.71),Vector(-1544.99,-1192.07,-27))then
				v:Remove()
			end
		end
	end
	hook.Add("InitPostEntity","revenants_safezone",remove)
	hook.Add("PostCleanupMap","revenants_safezone",remove)
elseif MAP:find("rockford") then
	safe={
		Vector(-4951.59, -5453.62, -13887.97),
		Vector(-4581.62, -5221.24, -13810.13),
	}
	spawn=nil
elseif MAP=="rp_oceanic_city" then
	spawn=nil
elseif MAP=="rp_genova_ob_04" then
	spawn=nil
	safe={
		Vector(1430.2,1173.18,-1.63),
		Vector(4465.82,2066.7,478.47),
	}
	local remove=function()
		for k,v in ipairs(ents.GetAll())do
			if v:GetPos():WithinAABox(Vector(1663.968750,1536.000000,92.000000)+Vector(1,1,1),Vector(1663.968750,1536.000000,92.000000)-Vector(1,1,1))then
				v:Remove()
			end
		end
	end
	hook.Add("InitPostEntity","revenants_safezone",remove)
	hook.Add("PostCleanupMap","revenants_safezone",remove)
	
	

elseif !MAP:find("downtown_v4c") and MAP!="oceanic_city" and !MAP:find("rockford") and MAP!="rp_downtown_v6_dtg_c" then
	return
end
hook.Add("PlayerSpawn","revenants_safezone",function(ply)
	if spawn and spawn[1] and spawn[2] then
		timer.Simple(0.1,function()
			if ply and ply:IsValid() and ply:IsPlayer() then
				if dweller_system and dweller_system[MAP] and dweller_system[MAP].spawns and dweller_system[MAP].spawns[1] then
					if ply:IsPursuant() or ply:IsDweller() then return end--don't send dwellers or pursuants to the fountain
				end
				if DarkRP and ply:isArrested() then return end--don't send arrested players to the fountain
				ply:SetPos(Vector(math.random(spawn[1].x,spawn[2].x),math.random(spawn[1].y,spawn[2].y),math.random(spawn[1].z,spawn[2].z)))
			end
		end)
	end
end)

hook.Add("EntityTakeDamage","revenants_safezone",function(ply,CTakeDamageInfo)
	local attacker=CTakeDamageInfo:GetInflictor():CPPIGetOwner() and CTakeDamageInfo:GetInflictor():CPPIGetOwner():IsValid() and CTakeDamageInfo:GetInflictor():CPPIGetOwner() or CTakeDamageInfo:GetAttacker()
	if attacker and attacker:IsValid() and attacker:GetPos():WithinAABox(safe[1],safe[2]) then--is the attacker in spawn?
		CTakeDamageInfo:SetDamage(0) -- prevent spawn abuse
		CTakeDamageInfo:SetDamageType(DMG_FALL) -- fall damage doesn't take away armor
	elseif ply and ply:IsPlayer() and ply:GetPos():WithinAABox(safe[1],safe[2]) then--is the player in spawn?
		if ply.IsDweller and ply:IsDweller() then return end--no protection for dwellers
		if ply.IsCuffed and ply:IsCuffed() then return end--no protection for cuffed players either
		CTakeDamageInfo:SetDamage(0) -- block damage
		CTakeDamageInfo:SetDamageType(DMG_FALL) -- fall damage doesn't take away armor
	end
end)
hook.Add("HUDPaint","revenants_safezone",function()
	local ply=LocalPlayer()
	if ply.IsDweller and ply:IsDweller() then return end--no protection for dwellers
	if ply.IsCuffed and ply:IsCuffed() then return end--no protection for cuffed players either
	if ply:GetPos():WithinAABox(safe[1],safe[2]) then
		if RSP and RSP.Data then
			local w = ScrW()
			local h = ScrH()
			draw.SimpleTextOutlined( "Wolven Territory's Safe Zone", "SafeZoneBig", w/2, 60, Color( 255, 0, 0 ), 1, 1, 2, color_black )
			draw.SimpleTextOutlined( "You are free of ALL damage. THIS IS A NO RP ZONE!", "SafeZoneSmall", w/2, 100, Color( 250, 255, 255 ), 1, 1, 1, color_black )
		else
			draw.DrawText(""..line1.."\n\n\n\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color1,TEXT_ALIGN_CENTER)
			draw.DrawText("\n"..line2.."\n\n\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color2,TEXT_ALIGN_CENTER)
			draw.DrawText("\n\n"..line3.."\n\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color3,TEXT_ALIGN_CENTER)
			draw.DrawText("\n\n\n"..line4.."\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color4,TEXT_ALIGN_CENTER)
			draw.DrawText("\n\n\n\n"..line5.."","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.1,color5,TEXT_ALIGN_CENTER)
		end
	end
end)