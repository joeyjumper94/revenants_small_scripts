local fn=function()
	local a,b=file.Find("itemstore/*.txt","DATA")
	local k=1
	timer.Create("deletion",0,#a,function()
		local v=a[k]
		local text=file.Read("itemstore/"..v)
		if text=="[]"or not util.JSONToTable(text) then
			print("deleted empty file itemstore/"..v)
			file.Delete("itemstore/"..v)
		end
		k=k+1
	end)
end
hook.Add("Initalize","data_cleaner",fn)
if GAMEMODE and GAMEMODE.Config or player.GetAll()[1] then fn() end