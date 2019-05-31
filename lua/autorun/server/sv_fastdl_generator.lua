local blacklist={
	["1314177388"]=true, --aTags [Tags Creator] 0 models
	["442358710"]=true, --Server Chat Tags 0 models
	["857951403"]=true, --DarkRP ULX Rank & Job Chat Tags 0 models
	["226312488"]=true, --APromoteGUI 0 models
	["1153306104"]=true, --</DLib> 0 models
	["635501783"]=true, --Pointshop System 0 models
	["272591265"]=true, --Chat Tags (ULX Only) 2 0 models
	["637963433"]=true, --Ulx !tpr (teleport request) 0 models
	["948692202"]=true, --Ultimate Logs 0 models
	["930906919"]=true, --Derpy's ULX Commands 0 models
	["504945881"]=true, --Enhanced PlayerModel Selector 0 models
	["104604709"]=true, --Easy Animation Tool 0 models
	["296157984"]=true, --Calladmin for All Gamemodes 0 models
	["412608410"]=true, --Auto-Cleaning Decals [No ULX and more admins mod] 0 models
	["458361904"]=true, --ULX PoliceTicket 0 models
	["353489796"]=true, --RDM Reporter Plus 0 models
	["104607712"]=true, --Extended Properties 0 models
	["125628460"]=true, --Adminstick 0 models
	["973145750"]=true, --Addon Share 0 models
	["882463775"]=true, --Outfitter: Choose your player model 0 models
	["115753588"]=true, --Fading door tool 0 models
	["112806637"]=true, --Gmod Legs 3 0 models
	["105955548"]=true, --No Collide Everything 0 models
	["105841291"]=true, --More Materials! 0 models
	["104603291"]=true, --Extended Spawnmenu 0 models
	["825240170"]=true, --ulx Physgun Freeze Script 0 models
	["746615375"]=true, --Blink SWEP 0 models
	["157748952"]=true, --DogBite 0 models
	["366071718"]=true, --Stealth Camo 0 models
	["113495466"]=true, --Climb SWEP 2 0 models
	["455285809"]=true, --Shadow Knife 0 models
	["1146362924"]=true, --ULX DarkRP Commands 0 models
	["658835196"]=true, --ULX FPP Cleanup Commands 0 models
	["1149344121"]=true, --DarkRP Full Classic Advert 0 models
	["264467687"]=true, --Improved Stacker 0 models
	["657474627"]=true, --UTime 0 models
	["388335851"]=true, --Blacklist & Remove 0 models
	["217722743"]=true, --TylerB's Shipment E2 Functions (v1]=true, 0 models
	["660900580"]=true, --ULX Spray Remover 0 models
	["116892991"]=true, --Resizer 0 models
	["416733036"]=true, --E2 Viewer 0 models
	["259174593"]=true, --TylerB's moneyRequest E2 Functions (v1]=true, 0 models
	["112423325"]=true, --URS 0 models
	["328695238"]=true, --Pro Keypad Cracker 0 models
	["774121349"]=true, --Pro Lockpick 0 models
	["742507930"]=true, --Handies | Dab & More! 0 models
	["220336312"]=true, --PermaProps 0 models
	["686055179"]=true, --ULX++ - New Commands and More! 0 models
	["108424005"]=true, --Keypad Tool + Cracker 0 models
	["207948202"]=true, --Simple Thirdperson 0 models
	["407236638"]=true, --Fading Door Tool - Fixed 0 models
	["104815552"]=true, --SmartSnap 0 models
	["773402917"]=true, --Advanced Duplicator 2 0 models
	["109643223"]=true, --3D2D Textscreens 0 models
	["557962238"]=true, --ULib 0 models
	["557962280"]=true, --ULX 0 models
	["1169579845"]=true, --Fps Booster 0 models
	["718665054"]=true, --Custom Commands 0 models
	["308977650"]=true, --Active Camouflage 0 models
	["279079869"]=true, --Advanced Bone Tool 0 models
	["126101775"]=true, --Joint Tool 0 models
	["104604943"]=true, --Easy Bodygroup Tool 0 models
	["104482086"]=true, --Precision Tool 0 models
	["389445061"]=true, --[DarkRP] Bank Robbery System 0 models
}
local maps={
	["1568720448"]=true, --rp_downtown_em_hs_16 0 models
	["625091269"]=true, --rp_rockford_open 0 models
	["328735857"]=true, --RP Rockford (Models/Materials Only) 193 models
	["918642421"]=true, --rp_downtown_v4c_v2 Map 0 models
	["296399858"]=true, --Choas City Content Part 3 0 models
	["702195281"]=true, --Choas City Content Part 2 400 models
	["296391343"]=true, --Choas City Content Part 1 0 models
	["720186204"]=true, --rp_chaos_city_v33x_03_edited 0 models
}
concommand.Add("generate_fastdl",function(ply,cmd,args)
	if ply and ply:IsValid() and !ply:IsSuperAdmin() then return end
	local addons=engine.GetAddons()
	local str=''
	for k,v in ipairs(addons) do
		if v.mounted and !blacklist[v.wsid] and !maps[v.wsid] then
			if v.models==0 then
				str='	resource.AddWorkshop("'..v.wsid..'") --'..v.title..' '..v.models..' models\n'..str
			else
				str=str..'	resource.AddWorkshop("'..v.wsid..'") --'..v.title..' '..v.models..' models\n'
			end
		end
	end
file.Write('sv_fastdl.txt',
[[if true then
]]..str..
[[end
local function init()
	local MAP=game.GetMap()
	if MAP=="rp_downtown_v4c_v2" then
		resource.AddWorkshop("918642421") --rp_downtown_v4c_v2 Map 0 models
	elseif MAP=="rp_chaos_city_v33x_03" then
		resource.AddWorkshop("296399858") --Choas City Content Part 3 0 models
		resource.AddWorkshop("702195281") --Choas City Content Part 2 400 models
		resource.AddWorkshop("296391343") --Choas City Content Part 1 0 models
		resource.AddWorkshop("720186204") --rp_chaos_city_v33x_03_edited 0 models
	elseif MAP=="rp_rockford_open" then
		resource.AddWorkshop("625091269") --rp_rockford_open 0 models
		resource.AddWorkshop("328735857") --RP Rockford (Models/Materials Only) 193 models
	end
end
hook.Add("Initialize","fastdl_init",init)
if GAMEMODE and GAMEMODE.Config or player.GetAll()[1] then init() end]])
	if ply and ply:IsValid() then
		ply:PrintMessage(HUD_PRINTCONSOLE,'check the server\'s data folder, there should be a file named "sv_fastdl.txt"')
		ply:PrintMessage(HUD_PRINTCONSOLE,'Rename it to sv_fastdl.lua and put it in the "garrysmod/lua/autorun/server"')
	else
		print'check the server\'s data folder, there should be a file named "sv_fastdl.txt"'
		print'Rename it to sv_fastdl.lua and put it in the "garrysmod/lua/autorun/server"'
	end
end)