# vertexfield
This module is very powerful; it allows easy creation of luafields by using AFTs and gives the modder access to each arrow as an Actor. Each arrow also can have bones attached to it, and each bone may be moved to imitate a vertex shader. Showcase video here: [Youtube](https://www.youtube.com/watch?v=slrIPcsuc1w)  

The vertexfield module does not support holds currently.  
    
## Usage

    module "vertexfield"
    
    local notedata = {
	    {0.000, 1},
	    {1.000, 2},
	    {2.000, 3},
	    {3.000, 4}
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
    

## Dependencies

 - common_aliases

## Mod Conflicts

VertexField doesn't work with the following mods:

 - Orient
 - NoteSkew
 - Mini, TinyX/Y

## VertexField Class

   `VertexField:new(table obj)`

Creates a new VertexField object with the inputs in the table obj. Accepted inputs are: 

 - bones: positioning of the bones relative to the center of the arrow
 - triangles: describes the triangles that are drawn using the indecies of the bones
 - notedata (required): the notedata of the playfield
 - player (required): the number of the player that shall be proxied
 
  `VertexField:toggleVisible(string setting, bool visible)`  
  
  Sets the visibility of the setting to the boolean given. Valid settings include:
  
 - aft: Draws the a square aft over the playfield. Defaults to false.
 - structure: Draws the outline of the transformed arrow. Defaults to false.
 - mesh: Draws the final arrow mesh. Defaults to true.
 - bones: Draws the bones of the arrow using small white squares. Defaults to false.
 - receptors: Renders the receptors in the same fashion as the arrows. Defaults to false.
 
 
 `VertexField:drawTexturedMesh(bool b)`  
 
 Toggle if the mesh is textured using an AFT or using a grayscale color scheme. Defaults to true.  
 
 
  `VertexField:HidePastReceptors(bool b)`  
  
Determines whether arrows will be drawn after they have passed the receptors. Defaults to false. 


  `VertexField:SetBoneTransform(function f)`  
  
Sets the transform function that is used for the arrows.  


`VertexField:SetReceptorTransform(function f)`  

Sets the transform function that is used for the receptors.  

## Transform functions

Transform functions are called before the mesh is drawn. Here is an example of a transform function:

    function(arrowindex, bones, arrowx, arrowy, arrowz, data)
	    for i=1,#bones do
		    bones:addx(-100)
	    end
    end
   
  Parameters of the function:
  

 - arrowindex: the index of this arrow in the notedata
 - bones: a table of bones (Quads) describing the arrow. Move these bones around to affect how the arrow is drawn
 - arrowx: the x position of the center of this arrow 
 - arrowy: the y position of the center of this arrow
 - arrowz: the z position of the center of this arrow
 - data: a table that includes the beat and column of this arrow: {beat, column}
