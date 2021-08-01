# vertexfield
This module is very powerful; it allows easy creation of luafields by using AFTs and gives the modder access to each arrow as an Actor. Each arrow also can have bones attached to it, and each bone may be moved to imitate a vertex shader. Showcase video here: [Youtube](https://www.youtube.com/watch?v=slrIPcsuc1w)  

The vertexfield module only supports taps, holds, and rolls currently.  
    
## Usage

    module "vertexfield"
    
    local notedata = {
	    {0.000, 0, 1},
	    {1.000, 1, 1},
	    {2.000, 2, 1},
	    {3.000, 3, 1}
    }
    
    --Create the VertexField with the player number 1 and
    --using the above notedata
    local vf = VertexField:new{notedata = notedata, player=1}
    
    --Draw the receptors of the playfield
    vf:toggleVisible("receptors", true)
    
    --Set the transform functions for the bones
    vf:SetBoneTransform(function(arrowindex, bones, arrowx, arrowy, arrowz, data)
		for i=1,#bones do
			--move all bones right by 100 pixels (essentially moving all the notes right by 100 pixels
			bones[i]:addx(100)
		end
	end)
	vf:SetReceptorTransform(function(arrowindex, bones, arrowx, arrowy, arrowz, data)
		for i=1,#bones do
			bones[i]:addx(100)
		end
	end)

    --get the actorframe containing all the arrows/receptors: vf.af
    

## Dependencies

 - common_aliases

## Mod Conflicts

VertexField doesn't work with the following mods:

 - Z-Pos mods
 - NoteSkew
 - Mini, TinyX/Y
 - CenteredPath
 - Centered, MoveX/Y (probably, haven't testied)

## VertexField Class

   `VertexField:new(table obj)`

Creates a new VertexField object with the inputs in the table obj. Accepted inputs are: 

 - bones: positioning of the bones relative to the center of the arrow
 - triangles: describes the triangles that are drawn using the indecies of the bones
 - notedata: the notedata of the playfield. if not specified, grabs the player's notedata. notedata input is 0-indexed (use notitg c2l)
 - player (required): the number of the player that shall be proxied
 - drawsizebeats: the number of beats before the receptors that the vertexfield will draw. defaults to 5
 - drawsizebackbeats: the number of beats past the receptors that the vertexfield will draw. defaults to 0
 
  `VertexField:toggleVisible(string setting, bool visible)`  
  
  Sets the visibility of the setting to the boolean given. Valid settings include:
  
 - mesh: Draws the final arrow mesh. Defaults to true.
 - bones: Draws the bones of the arrow using small white squares. Defaults to false.
 - receptors: Renders the receptors in the same fashion as the arrows. Defaults to false.
 
 
   `VertexField:SetDrawSizeBackBeats(number b)`  
 
Sets the drawsizebackbeats to b
 
 
   `VertexField:SetDrawSizeBeats(number b)`  
  
Sets the drawsizebeats to b


   `VertexField:SetBoneTransform(function f)`  
  
Sets the transform function that is used for the arrows.  


   `VertexField:SetReceptorTransform(function f)`  

Sets the transform function that is used for the receptors.  


   `VertexField:SetNoteData(table t)`  

Sets the notedata (notedata should be in notitg c2l format)

## Transform functions

Transform functions are called before the mesh is drawn. They should always return the same number of points they are given.  
Here is an example of a transform function:

    --move all bones by +100 in the x axis
    function transform(bones, arrow, notedata, isHold)
	    for i=1,#bones do
		    bones[i][1] = bones[i][1] + 100
	    end
        return bones
    end
   
  Parameters of the function:
  

 - bones: a table of bone positions. Move these bones around to affect how the arrow is drawn. bones is in the format { {x1, y1, z1}, {x2, y2, z2} ...}
 - arrow: the position of the center of this arrow. to get the positions, use arrow.x, arrow.y, arrow.z
 - notedata: the notedata of this arrow: {beat, column, type}. Column is 0 indexed. Type is 1 for taps, 2 for holds, 4 for rolls
 - isHold: whether or not the bones represent a hold. drawing a hold uses two transform calls: one for the tap and one for the hold. both calls have isHold set to
   true.
