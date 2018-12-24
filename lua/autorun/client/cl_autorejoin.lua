local last=CurTime()
local max=120
timer.Create("autorejoin",0,0,function()
	last=CurTime()+0.03
end)
local autorejoin=function()
	hook.Add("DrawOverlay","autorejoin",function()
		local since=math.Round(CurTime()-last,4)
		if since>max then
--			hook.Remove("DrawOverlay","autorejoin")
			RunConsoleCommand("retry")
		elseif since>1 then
			cam.Start2D()
			hook.Run("autorejoin",since,max)
			if hook.Run("HUDShouldDraw","autorejoin")!=false then
				draw.DrawText("Uh oh, the server may have crashed\nWe'll reconnect you in "..math.floor(max-since),"CloseCaption_Bold",ScrW()*0.5,ScrH()*.5,Color(255,255,255),TEXT_ALIGN_CENTER)
			end
			cam.End2D()
		end
	end)
end
if GAMEMODE and GAMEMODE.Config or player.GetAll()[1] then autorejoin() end
hook.Add("HUDPaint","autorejoin",function()
	last=CurTime()+30
	hook.Remove("HUDPaint","autorejoin")
	autorejoin()
end)