# comboview
This module will force the position of the judgement and combo sprites using ActorProxies.

## Usage

    module "comboview"
    ...
    --Hides the judgeent and combo at beat 16
    action ({16, function()
	    p1judg:visible(false)
	    p1combo:visible(false)
	    p2judg:visible(false)
	    p2combo:visible(false)
    end})

## Dependencies
This module has no dependencies.
