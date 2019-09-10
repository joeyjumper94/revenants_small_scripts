--if true then return end
local sh_block={--commands that cannot be run with lua on the server or client
	gamemenucommand={
		quit=true,
		quitnoconfirm=true,
		disconnect=true,
	},
}
local sv_block={--commands that cannot be run with lua on the server
	ulx={
		adduser=true,
		adduserid=true,
		removeuser=true,
		removeuserid=true,
		userallow=true,
		userdeny=true,
		groupallow=true,
		groupdeny=true,
		kick=true,
		ban=true,
	}
}
local cl_block={--commands that cannot be run with lua on the client(will be shared with server if on a listen server)
	connect=true,
	_restart=true,
	disconnect=true,
	quit=true,
	retry=true,
}
--no need to touch anything below here
local blocked=sh_block
if SERVER then
	for k,v in pairs(sv_block)do
		blocked[k]=v
	end
else
	for k,v in pairs(cl_block)do
		blocked[k]=v
	end
end
local FN=function(ply)
	hook.Remove("PlayerSpawn","command_blocker")
	if ply:IsListenServerHost()then
		for k,v in pairs(cl_block)do
			blocked[k]=v
		end
	end
end
hook.Add("PlayerSpawn","command_blocker",FN)
if Entity(1) and Entity(1):IsValid() then
	FN(Entity(1))
end

OldConsoleCommand=OldConsoleCommand or RunConsoleCommand
function RunConsoleCommand(...)
	local tbl={...}
	local res={}
	for k,v in ipairs(tbl)do
		res=res[v] or blocked[v]
		if res==true then
			if SERVER then
				for k,v in ipairs(player.GetAll()) do
					if v:IsAdmin() then
						v:PrintMessage(HUD_PRINTTALK,"someone check the server console")
					end
				end
			end
			error([[blocked ]]..table.concat(tbl)..[[,
the third part of the stack should say where this function was called from.]])	
		elseif !res then
			break
		end
	end
	OldConsoleCommand(...)
end

local Player = FindMetaTable"Player"
Player.OldCommand=Player.OldCommand or Player.ConCommand
function Player.ConCommand(self,cmd)
	local tbl=string.Split(cmd," ")
	local res={}
	for k,v in ipairs(tbl)do
		res=res[v] or blocked[v]
		if res==true then
			if SERVER then
				for k,v in ipairs(player.GetAll()) do
					if v:IsAdmin() then
						v:PrintMessage(HUD_PRINTTALK,"someone check the server console")
					end
				end
			end
			error([[blocked ]]..table.concat(tbl)..[[,
the third part of the stack should say where this function was called from.]])	
		elseif !res then
			break
		end
	end
	Player.oldConCommand(self,cmd)
end

if SERVER then
	game_ConsoleCommand=game_ConsoleCommand or game.ConsoleCommand
	game.ConsoleCommand=function(cmd)
		local tbl=string.Split(cmd," ")
		local res={}
		for k,v in ipairs(tbl)do
			res=res[v] or blocked[v]
			if res==true then
				if SERVER then
					for k,v in ipairs(player.GetAll()) do
						if v:IsAdmin() then
							v:PrintMessage(HUD_PRINTTALK,"someone check the server console")
						end
					end
				end
				error([[blocked ]]..table.concat(tbl)..[[,
the third part of the stack should say where this function was called from.]])	
			elseif !res then
				break
			end
		end
		game_ConsoleCommand(cmd)
	end
end