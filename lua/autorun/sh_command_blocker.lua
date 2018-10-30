--if true then return end
local sv_block={--commands that cannot be run with lua on the server
--	["command"]=true,
}
local sh_block={--commands that cannot be run with lua on the server or client
--	["command"]=true,
}
local cl_block={--commands that cannot be run with lua on the client
	["connect"]=true,
	["_restart"]=true,
}
--no need to touch anything below here
RCC=RCC or RunConsoleCommand
function RunConsoleCommand(a,b,c,d,e,f,g,h,i)
	local A=string.lower(a)
	if sh_block[A] or SERVER and sv_block[A] or CLIENT and cl_block[A] then
		if SERVER then
			for k,v in ipairs(player.GetAll()) do
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"someone check the server console")
				end
			end
		end
		error([[blocked ]]..A..[[,
the third part of the stack should say where this function was called from.]])
	end
	RCC(a,b,c,d,e,f,g,h,i)
end

local meta = FindMetaTable( "Player" )
meta.oldConCommand=meta.oldConCommand or meta.ConCommand
function meta.ConCommand(self,cmd)
	local tbl=string.Split(cmd," ")
	if cl_block[string.lower(tbl[1])] then
		if SERVER then
			for k,v in ipairs(player.GetAll()) do
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"someone check the server console")
				end
			end
		end
		error([[blocked ]]..tbl[1]..[[,
the third part of the stack should say where this function was called from.]])
	end
	meta.oldConCommand(self,cmd)
end

if SERVER then
	game_ConsoleCommand=game_ConsoleCommand or game.ConsoleCommand
	function game.ConsoleCommand(cmd)
		local start=string.lower(string.Split(string.Split(cmd,"\n")[1]," ")[1])
		if sv_block[start] then
			for k,v in ipairs(player.GetAll()) do
				if v:IsAdmin() then
					v:PrintMessage(HUD_PRINTTALK,"someone check the server console")
				end
			end
			error([[blocked ]]..start..[[,
the third part of the stack should say where this function was called from.]])
		end
		game_ConsoleCommand(cmd)
	end
end