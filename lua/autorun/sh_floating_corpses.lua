local accelaration=CreateConVar("sv_floating_ragdolls","1",bit.bor(FCVAR_ARCHIVE,FCVAR_NOTIFY,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED),"the rate at which death ragdolls accelarate"):GetFloat()
cvars.AddChangeCallback("sv_floating_ragdolls",function(v,o,n)
	accelaration=tonumber(n)
	if SERVER then
		PrintMessage(HUD_PRINTTALK,"Server cvar '"..v.."' changed to "..n)
	end
end,"sv_floating_ragdolls")
timer.Create("floating_ragdolls",0,0,function()
	for k,v in ipairs(player.GetAll())do
		local Entity=v.RAG
		if Entity and Entity:IsValid() then
			for i=0,Entity:GetPhysicsObjectCount()-1 do
				local PhysObj=Entity:GetPhysicsObjectNum(i)
				PhysObj:Wake()
				PhysObj:ApplyForceCenter(PhysObj:GetVelocity()*accelaration*0.01)
				if PhysObj:GetVelocity():DistToSqr(vector_origin)<0.1 then
					PhysObj:ApplyForceCenter(Vector(math.Rand(-1000,1000),math.Rand(-1000,1000),math.Rand(-1000,1000)))
					v.RAG=nil
				end
			end
		else
			Entity=v:GetRagdollEntity()
			if Entity and Entity:IsValid() then
				for i=0,Entity:GetPhysicsObjectCount()-1 do
					local PhysObj=Entity:GetPhysicsObjectNum(i)
					PhysObj:EnableGravity(false)
				end
				v.RAG=Entity
			end
		end
	end
end)