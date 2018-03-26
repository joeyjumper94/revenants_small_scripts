local ScreenshotRequested=nil
concommand.Add("make_screenshot",function(ply,cmd,args)
	ScreenshotRequested=tonumber(args[1])
	if ScreenshotRequested==nil or ScreenshotRequested==0 then
		ScreenshotRequested=100
	end
end)
local months={"january","febuary","march","april","may","june","july","august","September","october","november","december"}
local days={
	"01st","02nd","03rd","04th","05th","06th","07th","08th","09th","10th",
	"11th","12th","13th","14th","15th","16th","17th","18th","19th","20th",
	"21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th",
	"31st"
}
local function locale()
	return 
end
hook.Add("PostRender","example_screenshot",function()
	if !ScreenshotRequested then return end
	local DIR="screenshots/"..os.date("%Y",os.time()).."/"..months[tonumber(os.date("%m",os.time()))].."/"..days[tonumber(os.date("%d",os.time()))]
	local FILE="/"..os.date("%H-%M-%S.png",os.time())
	local data = render.Capture({
		format = "jpeg",
		quality = math.Clamp(tonumber(ScreenshotRequested),1,100),
		h = ScrH(),
		w = ScrW(),
		x = 0,
		y = 0,
	})
	if !file.Exists(DIR,"DATA") then
		file.CreateDir(DIR)
	end
	file.Write(DIR..FILE,data)
	timer.Simple(0,function()
		LocalPlayer():PrintMessage(HUD_PRINTTALK,"screenshot saved in garrysmod/data/"..DIR..FILE)
	end)
	ScreenshotRequested = nil
end)