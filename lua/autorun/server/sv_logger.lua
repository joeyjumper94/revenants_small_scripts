local months={"january","febuary","march","april","may","june","july","august","September","october","november","december"}
local days={"1st","2nd","3rd","4rth","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"}

function sv_log_func(name,raw_text)
	local hour=tonumber( os.date("20%y",os.time()) )
	local month=tonumber( os.date("%m",os.time()) )
	local day=tonumber( os.date("%d",os.time()) )
	local hour=tonumber( os.date("%H",os.time()) )
	local minute=tonumber( os.date("%M",os.time()) )
	local second=tonumber( os.date("%S",os.time()) )

	local DIR="sv_logs/"..os.date("%Y/"..months[month].."/"..days[day],os.time())
	local FILE=DIR.."/"..tostring(name)..".txt"
	local file_text=os.date("%H:%M:%S ",os.time())..raw_text

	if file.Exists(FILE,"DATA") then
		file.Append(FILE,file_text.."\n")
	elseif file.Exists(DIR,"DATA") then
		file.Write(FILE,file_text.."\n")
	else
		file.CreateDir(DIR)
		file.Write(FILE,file_text.."\n")
	end
end