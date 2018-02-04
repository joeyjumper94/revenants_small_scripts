local box={--the min values must be first
	Vector(-2340.81,-2008.91,-203.71),
	Vector(-1468.72,-1132.25,-36.87)
}

local line1="Equestrian Dreams Safe Zone"
local color1=Color(255,51,51)

local line2="you are free from all damage"
local color2=Color(204,204,204)

local line3="enjoy your stay"
local color3=Color(255,255,255)

local line4="you can read the rules by typing !motd"
local color4=Color(255,255,255)

hook.Add("EntityTakeDamage","revenants_safezone",function(ply,CTakeDamageInfo)
	local attacker=CTakeDamageInfo:GetAttacker() or CTakeDamageInfo:GetInflictor():CPPIGetOwner()

	if attacker and attacker:IsPlayer() and attacker:GetPos():WithinAABox(box[1],box[2]) then--is the attacker in spawn?
		CTakeDamageInfo:SetDamage(0) -- prevent spawn abuse
	elseif ply and ply:IsPlayer() and ply:GetPos():WithinAABox(box[1],box[2]) then--is the player in spawn?
		CTakeDamageInfo:SetDamage(0) -- block damage
	end
end)
hook.Add("HUDPaint","revenants_safezone",function()
	if LocalPlayer():GetPos():WithinAABox(box[1],box[2]) then
		draw.DrawText(line1.."\n".."\n\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.175,color1,TEXT_ALIGN_CENTER)
		draw.DrawText("\n"..line2.."\n\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.175,color2,TEXT_ALIGN_CENTER)
		draw.DrawText("\n\n"..line3.."\n","CloseCaption_Bold",ScrW()*0.5,ScrH()*0.175,color3,TEXT_ALIGN_CENTER)
		draw.DrawText("\n\n".."\n"..line4,"CloseCaption_Bold",ScrW()*0.5,ScrH()*0.175,color4,TEXT_ALIGN_CENTER)
	end
end)