if true then return end--remove this line to activate the script
local class_restricted_ents={
	["class1"]={--this is the entity class
		[TEAM_1]=true,--this decides what teams can have it
		[TEAM_2]=true,--this decides what teams can have it
	},
	["class2"]={--this is the entity class
		[TEAM_1]=true,--this decides what teams can have it
		[TEAM_2]=true,--this decides what teams can have it
	},
}
hook.Add("OnPlayerChangedTeam","remove_team_restricted_entities",function(ply,old,new)
	for k,ent in ipairs(ents.GetAll()) do
		if ent and class_restricted_ents[ent:GetClass()] and ent:CPPIGetOwner()==ply then
			if !allowed[ent:GetClass()][new] then
				ent:Remove()
			end
		end
	end
end)
hook.Add("canPocket","pocket_team_restricted_entities",function(ply,ent)
	if ent and class_restricted_ents[ent:GetClass()] then
		return false,[[to ensure you don't keep team restricted enitites by pocketing them,
we have blocked you from pocketing said entities]]
	end
end)