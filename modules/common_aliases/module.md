# common_aliases
This module defines many of the common variable aliases used in modding.
This module is used in many other modules, so this module is a must have and it should be defined first. 

## Usage

    module "common_aliases"
    
## Dependencies
This module has no dependencies.

## Defines

    scx = SCREEN_CENTER_X
    scy = SCREEN_CENTER_Y
    sw = SCREEN_WIDTH
    sh = SCREEN_HEIGHT
    scm = SCREENMAN
    poptions = <player options>
    topscreen = SCREENMAN:GetTopScreen()
    P1 = SCREENMAN:GetTopScreen():GetChild("PlayerP1")
    P2 = SCREENMAN:GetTopScreen():GetChild("PlayerP2")
    ARROW_SIZE = size of an arrow (scaled with 720p themes)



