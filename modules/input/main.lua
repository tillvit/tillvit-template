
local InputHandler = function( event )
	if not event then return end

	if event.type == "InputEventType_FirstPress" then
        if event.PlayerNumber == "PlayerNumber_P1" then
		    emit("P1"..event.button.."Press")
            emit("P1Press")
        elseif event.PlayerNumber == "PlayerNumber_P2" then
		    emit("P2"..event.button.."Press")
            emit("P2Press")
        end
        emit("StepPressed")
	end
	
	if event.type == "InputEventType_Release" then
		if event.PlayerNumber == "PlayerNumber_P1" then
		    emit("P1"..event.button.."Release")
            emit("P1Release")
        elseif event.PlayerNumber == "PlayerNumber_P2" then
		    emit("P2"..event.button.."Release")
            emit("P2Release")
        end
        emit("StepReleased")
	end
end

on('on', function() 
    SCREENMAN:GetTopScreen():AddInputCallback( InputHandler )
end)

on('end', function() 
    if SCREENMAN:GetTopScreen() then SCREENMAN:GetTopScreen():RemoveInputCallback( InputHandler ); end
end)