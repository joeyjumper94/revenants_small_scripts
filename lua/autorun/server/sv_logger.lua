local months={"january","febuary","march","april","may","june","july","august","september","october","november","december"}
local days={"1st","2nd","3rd","4rth","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"}

function sv_log_func(name,raw)
	local hour=tonumber( os.date("20%y",os.time()) )
	local month=tonumber( os.date("%m",os.time()) )
	local day=tonumber( os.date("%d",os.time()) )
	local hour=tonumber( os.date("%H",os.time()) )
	local minute=tonumber( os.date("%M",os.time()) )
	local second=tonumber( os.date("%S",os.time()) )

	local DIR="sv_logs/"..os.date("20%y/"..months[month].."/"..days[day],os.time())
	local FILE=DIR.."/"..tostring(name)..".txt"

	text=os.date("%H:%M: ",os.time())..raw
	if file.Exists(FILE,"DATA") then
		file.Append(FILE,text.."\n")
	elseif file.IsDir(DIR,"DATA") then
		file.Write(FILE,text.."\n")
	else
		file.CreateDir(DIR)
		file.Write(FILE,text.."\n")
	end
end

concommand.Add("sv_log_test",function(ply,cmd,args)
	if #args<2 then return end
--	local location=args[1]
--	local text=table.concat(args," ",2,#args)
	sv_log_func(args[1],table.concat(args," ",2,#args))
end)

local Dyear=17
local Dmonth=12
local Dday=17
local Dname="test"
for k,v in ipairs({'/20'..Dyear..'/'..months[Dmonth].."/"..days[Dday]..'/'..Dname..'.txt','/20'..Dyear..'/'..months[Dmonth].."/"..days[Dday],'/20'..Dyear..'/'..months[Dmonth],'/20'..Dyear,''}) do
	file.Delete('sv_logs'..v) 
end