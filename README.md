# Resourcery
A framework prototype

## Introduction
I was tired of creating UI with XML and the standard WoW API so I created this as a test to feel around a bit.  
With Resourcery you can create Lua templates, more or less the same as the XML templates.  
  
As this is a prototype, not all frame types are supported (yet).  
  
**Supported frame types currently are:**  
- Frame
- Texture
- Button
- FontString  
  
**Other features are:**  
* Lua templates
* Duplicate
* Macros
* Scripts
* AIO usage  
  
## Installation  
* Add to the bottom of your `FrameXML.toc`:  
```
Resourcery.lua  
Resourcery_Scripts.lua  
Resourcery_Templates.lua  
```  
* Add the files to your patch at the same location as your FrameXML.toc  
   
Example:  
```
patch-I.mpq/Interface/FrameXML
```  
* (Optional) Add the AIO files to your `lua_scripts` folder on the server.
  
## How to use  
  
To conjure (create) frames you use the function:  
`resourcery.StartConjuring(tableData, mergeTableData)`  
`tableData` is a table with frame data.  
`mergeTableData` is a table with frame data that will merge with `tableData`.

  
### Creating templates  
You can either store templates in the file `Resourcery_Templates.lua`  
or you can store them wherever you want with `resourcery.templates.template_name`.  
  
Here is an example of a template that creates a basic window with a close button:  
```
resourcery.templates.basic_window = {
   
   templates = {
      "close_button"
   },
   type = "Frame",
   
   size = {x=384, y=512},
   moveable = true,
   
   textures = {
      topLeft = {
         size = {256, 256},
         point = {"TOPLEFT",0,0,},
         texture = "Interface/TAXIFRAME/UI-TaxiFrame-TopLeft.blp",
         draw_layer ="BORDER"
      },
      topRight = {
         size = {128,256},
         point = {"TOPRIGHT",0, 0},
         texture = "Interface/TAXIFRAME/UI-TaxiFrame-TopRight.blp",
         draw_layer ="BORDER",
      },
      bottomLeft = {
         duplicate = "topLeft",
         point={"BOTTOMLEFT", 0, 60},
         texture = "Interface/TAXIFRAME/UI-TaxiFrame-BotLeft.blp",
      },
      bottomRight = {
         duplicate = "bottomLeft",
         size = {128},
         point={"BOTTOMRIGHT"},
         texture="Interface/TAXIFRAME/UI-TaxiFrame-BotRight.blp",
      },
      icon={
         size={58,58},
         point={"TOPLEFT",10,-8},
         texture="Interface/FriendsFrame/FriendsFrameScrollIcon.blp",
         draw_layer="BACKGROUND"
      }
   },
   
   strings = {
      title={
         point={"TOPLEFT", "$parent", "TOPLEFT",0,-12},
         size={"$parent", 24},
         font={size=14},
         text="Example frame"
      }
   },
   
   frames = {
      close_button = {
         point= {x=-30, y=-8},
         size={x=32,y=32}
      }
   }
}
```
