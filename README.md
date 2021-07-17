
# tillvit-template
Template for OutFox Modding

it's like Node but Not Really

## Environment

All variables in a file will be defined under _G.tillvit.\<variable_name\>. No global variables will be defined, but defining them with _G is still possible.

## Modules

Modules can be imported by placing the module folder into the lua/modules folder. To import a module, write `module 'modulename'` or `module('modulename')`. These imports should be called first. For dependencies, the order of the imported modules matters, as you need to import the dependencies *before* inputting the module.

## Events
To register a listener, use the `on(string event, function f)` function.
To emit an event, use the `emit(string event)` function.
Predefined events include:

 - preinit: called on InitCommand. Use this to register any variables or functions that require InitCommand
 - init: called after preinit.
 - preon: called on OnCommand. Use this to register any variables or functions that require OnCommand (like players)
	 - preon is used by the module common_aliases to create the variables P1 and P2
  - on: called after preon 
  - update: called using the updatefunction

## ActorFrame Methods

To add an Actor to the ActorFrame, use the `add(Actor a)` function.

    add (Def.Quad {
	    OnCommand=function(self)
		    self:zoomto(64,64)
	    end
    })
To access the ActorFrame directly for methods, the variable is named "af".

## Other Methods

`msg(m)`: prints out the message to the screen. tostring is used here.

`setEditor(bool b)`: set whether the player is in edit mode for testing (will be removed when 2 player support comes out)

`setBeatOffset(float f)`: sets the beat offset for modding. This will modify the current beat and all mods will be affected.
