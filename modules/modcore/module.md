# modcore
This module creates the basic mod and action handler. It includes easing and allows manipulation of both players. Capitalization of the mods doesn't matter. Conversion between XMod, CMod, and MMod is slightly broken.

This module also has a function to hide all overlay elements and another function to display the current modlist on screen.

## Usage

    module "modcore"
    
    --These functions need to be called during the oncommand event
    on('on', function()
	    --hide overlay elements
	    hideObjects()
	    --show mods list
	    toggleModsListVisible(true)
    end)
    
    --Activate 100% Beat and -100% Tornado with an ease length of 
    --1 beat at beat 4 for both players.
    mod ({4,0,{
	    {1,100,"Beat","outExpo"},
	    {1,-100,"Tornado","inExpo"},
    }})
    
    --Activate -100% Beat with an ease length of 
    --2 beats at beat 7 for player 1.
    mod ({7,1,{
	    {1,-100,"Beat","linear"},
    }})
    
    --Zoom P2 to 2x with an ease length of 
    --1 beats at beat 8 for player 2.
    mod ({8,2,{
	    {1,2,"zoom","outSine"},
    }})
    
    --Hide P1 at beat 0
    action ({0, function()
	    P1:visible(false)
    end})
    
    
## Dependencies

 - common_aliases

## Valid Eases
 - linear
 - (in/out/inOut/outIn)(Quad/Cubic/Quart/Quint/Expo/Sine/Circ/Bounce)

## Mod Format

    {beat,player,{
	    {ease_time, value, mod, ease},
	    {ease_time, value, mod, ease},
	    ...
    }}}

beat: when this mod will activate  
player: which player this mod will apply to (1=P1, 2=P2, defaults to both)  
ease_time: time in beats for easing  
value: value of the mod  
mod: string name of mod applied  
ease: string name of ease used for easing  



