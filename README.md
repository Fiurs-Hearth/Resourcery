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
  
Examples:  
```lua
-- Will create a basic frame and name it "testFrame"
resourcery.StartConjuring({
  templates={"basic_window"},
  name="testFrame"
})

frameData={
   templates={"basic_window"},
   name="testFrame",
   
   strings={
      title={
         text="This text will be replaced before creation."
      }
   }
}
-- Overwrite the text for the string 'title'.
local myFrame = resourcery.StartConjuring(frameData, {
      strings={
         title={
            text="A cool new frame" 
         }
      }
})
```
  
You can access a frame's sub-frames, textures, strings and variables by doing this:  
```lua
myFrame.frames['frame_name'] -- This method works the same as the one below
myFrame.textures.texture_name -- This method works the same as the one above
myFrame.vars['var_name']
myFrame.strings.string_name
```  
  
### Using WoW API with Resourcery  
If you want to use for example:  
`frame:SetFrameStrata("BORDER")`  
Then you write `frame_strata="BORDER"`.  
  
If you want to use a function that accepts multiple arguments (for example `frame:SetBackdrop`) then you can do this:  
```lua
backdrop={
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  tile = true,
  tileSize = 32,
  edgeSize = 32,
  insets = {
    left = 11,
    right = 12,
    top = 12,
    bottom = 11,
  }
}
```  
Or you can do this:  
```lua
backdrop={ 
  "Interface\\DialogFrame\\UI-DialogBox-Background",
  "Interface\\DialogFrame\\UI-DialogBox-Border"
}
```  
The table values follow the same order as the function so in this case the first one is the `bgFile` and the second one is `edgeFile` but their key is `[1]` and `[2]`.  
You can also set specific key values like this:  
```lua
backdrop={ 
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeSize = 12
}
```  
Or like this:  
```lua
backdrop={ 
  [2] = "Interface\\DialogFrame\\UI-DialogBox-Background",
  [3] = 12
}
```  
Resourcery will prioritize key-value pairs over index-value pairs.  
For example, if backdrop's key named `edgeFile`is set but also the index key `[2]` is set then it will prioritize the named key.
  
### Creating templates  
You can either store templates in the file `Resourcery_Templates.lua`  
or you can store them wherever you want with `resourcery.templates.template_name`.  
  
Here is an example of a template that creates a basic window with a close button:  
```lua
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

--When we have a template we can just use StartConjuring()
resourcery.StartConjuring({
  templates={"basic_window"},
  name="testFrame"
})
```
