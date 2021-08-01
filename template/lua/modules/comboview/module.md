# comboview
This module will force the position of the judgement and combo sprites using ActorProxies.

## Usage

    module "comboview"
    ...
    --Hides the judgement and combo at beat 16
    action ({16, function()
	    combovisible = false
    end})

## Dependencies
This module has no dependencies.
