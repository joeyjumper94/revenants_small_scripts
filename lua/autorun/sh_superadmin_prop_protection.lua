AddCSLuaFile()
local FLAGS={FCVAR_ARCHIVE,FCAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}
local protection={
	physgun=CreateConVar("superadmin_prop_protection_physgun","1",FLAGS,"enable protection from physgun"):GetBool(),
	toolgun=CreateConVar("superadmin_prop_protection_toolgun","1",FLAGS,"enable protection from toolgun"):GetBool(),
	property=CreateConVar("superadmin_prop_protection_property","1",FLAGS,"enable protection from Cmenu properties"):GetBool(),
	drive=CreateConVar("superadmin_prop_protection_drive","1",FLAGS,"enable protection from prop drive"):GetBool(),
	editvariable=CreateConVar("superadmin_prop_protection_editvariable","1",FLAGS,"enable protection from editvariable"):GetBool(),
	use=CreateConVar("superadmin_prop_protection_use","0",FLAGS,"enable protection from player use( presing E)"):GetBool(),
	damage=CreateConVar("superadmin_prop_protection_damage","0",FLAGS,"enable protection from damage"):GetBool(),
}
hook.Add("PhysgunPickup","only_superadmins_can_touch_stuff_owned_by_superadmins",function(Ply,Ent)
	if Ply and Ply:IsValid() and Ply:IsPlayer() and Ply:IsSuperAdmin() then return end--if they are a superadmin then let them interact with it
	if Ent and Ent:CPPIGetOwner() and Ent:CPPIGetOwner():IsSuperAdmin() and protection.physgun then return false end
end)
hook.Add("CanDrive","only_superadmins_can_touch_stuff_owned_by_superadmins",function(Ply,Ent)
	if Ply and Ply:IsValid() and Ply:IsPlayer() and Ply:IsSuperAdmin() then return end--if they are a superadmin then let them interact with it
	if Ent and Ent:CPPIGetOwner() and Ent:CPPIGetOwner():IsSuperAdmin() and protection.drive then return false end
end)
hook.Add("CanTool","only_superadmins_can_touch_stuff_owned_by_superadmins",function(Ply,trace,tool)
	if !trace then return false end
	local Ent=trace.Entity
	if Ply and Ply:IsValid() and Ply:IsPlayer() and Ply:IsSuperAdmin() then return end--if they are a superadmin then let them interact with it
	if Ent and Ent:CPPIGetOwner() and Ent:CPPIGetOwner():IsSuperAdmin() and protection.toolgun then return false end
end)
hook.Add("CanProperty","only_superadmins_can_touch_stuff_owned_by_superadmins",function(Ply,property,Ent)
	if Ply and Ply:IsValid() and Ply:IsPlayer() and Ply:IsSuperAdmin() then return end--if they are a superadmin then let them interact with it
	if Ent and Ent:CPPIGetOwner() and Ent:CPPIGetOwner():IsSuperAdmin() and protection.property then return false end
end)

if CLIENT then return end--the rest of these hooks only work serverside

hook.Add("CanEditVariable","only_superadmins_can_touch_stuff_owned_by_superadmins",function(Ent,Ply)
	if Ply and Ply:IsValid() and Ply:IsPlayer() and Ply:IsSuperAdmin() then return end--if they are a superadmin then let them interact with it
	if Ent and Ent:CPPIGetOwner() and Ent:CPPIGetOwner():IsSuperAdmin() and protection.editvariable then return false end
end)
hook.Add("OnPhysgunReload","only_superadmins_can_touch_stuff_owned_by_superadmins",function(Physgun,Ply)
	if !(Ply and Ply:IsValid() and Ply:GetEyeTrace()) then return false end
	local Ent=Ply:GetEyeTrace().Entity
	if Ply and Ply:IsValid() and Ply:IsPlayer() and Ply:IsSuperAdmin() then return end--if they are a superadmin then let them interact with it
	if Ent and Ent:CPPIGetOwner() and Ent:CPPIGetOwner():IsSuperAdmin() and protection.physgun then return false end
end)
hook.Add("PlayerUse","only_superadmins_can_touch_stuff_owned_by_superadmins",function(Ply,Ent)
	if Ply and Ply:IsValid() and Ply:IsPlayer() and Ply:IsSuperAdmin() then return end--if they are a superadmin then let them interact with it
	if Ent and Ent:CPPIGetOwner() and Ent:CPPIGetOwner():IsSuperAdmin() and protection.use then return false end
end)
hook.Add("CanPlayerUnfreeze","only_superadmins_can_touch_stuff_owned_by_superadmins",function(Ply,Ent,PhysObj)
	if Ply and Ply:IsValid() and Ply:IsPlayer() and Ply:IsSuperAdmin() then return end--if they are a superadmin then let them interact with it
	if Ent and Ent:CPPIGetOwner() and Ent:CPPIGetOwner():IsSuperAdmin() and protection.physgun then return false end
end)
hook.Add("EntityTakeDamage","only_superadmins_can_touch_stuff_owned_by_superadmins",function(Ent,CTakeDamageInfo)
	if !CTakeDamageInfo then return true end
	local Ply=CTakeDamageInfo:GetAttacker()--make sure that Ply is localized
	if Ply and Ply:IsValid() and Ply:IsPlayer() and Ply:IsSuperAdmin() then return end--if they are a superadmin then let them interact with it
	if Ent and Ent:CPPIGetOwner() and Ent:CPPIGetOwner():IsSuperAdmin() and protection.damage then return true end
end)