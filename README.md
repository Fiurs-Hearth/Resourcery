# Resourcery
A framework for wotlk 3.3.5

![resoucery](https://user-images.githubusercontent.com/97316608/212414504-04eb15e7-b912-4d77-b372-be024c9b4d57.png)  

## Introduction
I was tired of creating UI with XML and the standard WoW API so I created this as a test to see if this was fun to work with.  
With Resourcery you can create Lua templates, more or less the same as the XML templates.  
  
As this is a prototype, not all frame types are supported (yet).  
  
Video:  
[Resourcery Video](https://www.youtube.com/watch?v=WQJALHQe2Cc)  

**Supported frame types currently are:**  
- Frame
- Texture
- Button
- CheckButton
- EditBox
- Model
- PlayerModel
- ScrollFrame
- Slider
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
  
Resourcery will try and default values that you otherwise must type in to use.  
For example:  
```lua
frameData={
  size={x=100}
}
```  
In this example it will default the 'y' value to either the frame's current height.
  
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
  
### Duplicate feature  
You can use the `duplicate` feature to duplicate settings of another frame/string/texture in the same contained table.  
For example:  
```lua
strings={
    title={
       point={"TOPLEFT", "$parent", "TOPLEFT",0,-12},
       size={"$parent", 24},
       font={size=14},
       text="Example frame"
    },
   secondText={
      duplicate="title",
      point={[1]="TOPLEFT",[3]="LEFT"},
      text="TEST"
   }
}
```  
Here we duplicate the data of 'title' into 'secondText' and then we overwrite some of that data.  
You can do this with frames, strings and textures.  
  
### Macros  
With some frame type attributes you can use macros to fetch data.  
With `name` you can use `$parent` to get the parent frame's name and you can add more text to it:  
```lua
{
  templates={"basic_window"},
  name="$parent_subFrame" -- if the parent's name is "frame_test" then the name will become "frame_test_subFrame"
}
```
With `size` you can fetch a frame's X or Y size by doing this:  
```lua
{
  templates={"basic_window"},
  size={
    x="$parent", -- Gets the width of the parent frame.
    y="$PlayerFrame + $parent - 35" -- Gets Height of PlayerFrame, add with the parent frame and subtracts that result with 35.
  }
}
```  
With `parent` you can use `$parent`, used for when you have subframes but it will default to parent anyway so its used to clarify.  
With `point['relative_frame']` you can use `$parent`.
  
### Scripts  
You can add scripts like this:  
```lua
button={
  templates={"blizz_button"},
  
  scripts={
      OnClick=function()
        print("Button clicked!")
      end,
      OnLeave=myFunction
  }
}
```  
You can register and use events like this:  
```lua
frameData={
  templates={"blizz_button"},
  
  scripts={
      OnEvent=function(self, event, unit)
        if(event == "UNIT_HEALTH" and unit == "player") then
          print("Your health changed!")
        end
      end,
      events={
        "UNIT_HEALTH"
      }
  }
}
```  
#### OnConjure  
Run attached function when frame is created, example:
```lua
local button={
   templates={"blizz_button"},
   name="button_example",
   
   point={"CENTER"},
   
   scripts={
      OnConjure=function(self)
         local color = (UnitClass("player") == "Paladin" and "|c00F48CBA" or "|c00C69B6D")
         self:SetText(color.."Button")
      end,
      OnLeave=myFunction
   }
}
resourcery.StartConjuring(button)
```
  
### AIO Usage
With AIO we can create/edit frames live for all online players if you run the code as a GM like this:  
```lua
local data = {
   templates={"basic_window"},
   name="aio_window",
   
   strings={
      title={
         text="Created via AIO"
      }
   }
}
AIO.Handle("AIO_resourcery", "UpdateUI", data)
```  
It is also possible to make changes to the data and then update the target frame live as well.  
You can NOT add functions through the AIO method (at least to my knowledge).  
One option is to create the functions before and add that function to a template and then add it to the client's patch.  
I have done this with the function: `resourcery.StartServerCountdown()`.  
  
### ScrollFrame & Container templates  
Watch the [Video](https://www.youtube.com/watch?v=boX92JL-FpU) to see what the different templates do
#### ScrollFrame
These scrollframes comes with different types of sliders or no sliders at all and they all come with a container frame you parent frames to.  
  
A list of different scrollframe templates, left column is the same as the right column.  
```
scrollframe_1	  scrollframe							
scrollframe_2	  scrollframe_no_buttons				
scrollframe_3	  scrollframe_horizontal				
scrollframe_4	  scrollframe_horizontal_no_buttons	
scrollframe_5	  scrollframe_horizontal_rotated		
scrollframe_6	  scrollframe_sliders					
scrollframe_7	  scrollframe_sliders_horizontal_rotated		
scrollframe_8	  scrollframe_sliders_no_buttons				
scrollframe_9	  scrollframe_sliders_horizontal_no_buttons	
scrollframe_10	  scrollframe_sliders_vertical_no_buttons		
scrollframe_11	  scrollframe_sliders_vertical_no_buttons_horizontal_rotated	
scrollframe_12	  scrollframe_no_sliders		
```

#### Container  
The container frame is the frame you want to set as parent to frames who will be inside of the scrollframe.  

A list of different container templates with scripts, left column is the same as the right column.
```
container_1      container_basic / container_drag_scroll / container_scroll_drag	
container_2	 container_scroll		
container_3	 container_drag			
container_4	 container_zoom			
container_5	 container_drag_zoom / container_zoom_drag
```
  
### Template structures  
The structure for the different templates related to scrollframe, container and sliders.  
Relevant if you want to edit the templates.  
```lua
scrollframe={
   type="Frame",
 
   frames={
      slider={
         type="Frame",

         backdrop={
            bg_file="Interface/CHATFRAME/CHATFRAMEBACKGROUND.blp",
            edge_file="Interface/Tooltips/UI-Tooltip-Border",
            edge_size=16,
            insets={3,3,3,3}
         },
         frames={
            up={
               type="Button",
               normal_texture="Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Up.blp",
               disabled_texture="Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Disabled.blp",
            },
            down={
               -- Same as up
            }
         }
         texture={
            thumb={
               texture="Interface/BUTTONS/UI-Quickslot-Depress.blp"
            }
         },
      },
      slider_horizontal={
         -- Same as slider
         frames={
            left={
               -- Same as up
            },
            right={
               -- Same as up
            }
         },
         texture={
            -- Same as thumb
         }
      },
      container={
         type="Frame"
      }
   }
}
```

  
#### Example
Here is an example that creates a basic window with a scrollframe and slider.  
The scripts attached to the container frame lets you scroll up, down and drag the frame by holding and moving your mouse.
```lua
local data={
   templates={"basic_window"},
   name="scroll_frame_example",
   point={"CENTER", -300},
   
   frames={
      scrollframe={
         templates={"scrollframe_1", "container_drag_scroll"},
         size={"$parent - 86", "$parent - 156"},
         
         name="$parent_scrollframe",
         point={x=20, y=-74},
      }
   }
}
resourcery.StartConjuring(data)
```
  
### Extra attributes
There are some extra attributes you can use when writing data for a frame.  
For example:  
```lua
frameData={
  moveable=true
}
```  
This will make the frame moveable. Also works with using `clamped` and its values.  
  
If you use `disabled = true` then you can temporarily disable a frame or a texture.  

If you add `true` after a template then you don't inherit that template's templates, for example:
```lua
 templates={"basic_window", true},
   name="test",
```
