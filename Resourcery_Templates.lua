-- Author: Fiur#8658

resourcery.templates = {

    basic_window = {
        templates = {
            "close_button"
         },
         type = "Frame",
         
         size = {x=384, y=512},
         moveable = true,
         
         hit_rect={0, 33, 0, 70},

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
               point={"BOTTOMLEFT", 0, 0},
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
                name="$parent_title",
                point={"TOPLEFT", "$parent", "TOPLEFT",0,-12},
                size={"$parent", 24},
                font={size=14},
                justify_h="CENTER",
                text="Example frame"
            }
         },
         
         frames = {
            close_button = {
               point= {x=-30, y=-8},
               size={x=32,y=32}
            }
         }
    },

    overlay={
        name="overlay",
        type="Frame",
        size={"$parent", "$parent"},
        backdrop = {
            bg_file = "Interface/CHATFRAME/CHATFRAMEBACKGROUND.blp"
        },
        backdrop_color={0,0,0, 0.75},   
    },
    backdrop_1={
        backdrop={
            bg_file="Interface/CHATFRAME/CHATFRAMEBACKGROUND.blp",
            edge_file="Interface/DialogFrame/UI-DialogBox-Border",
            edge_size=16,
            insets={5,5,5,5}
        },
        backdrop_color={0,0,0},
    },
    backdrop_2={
        templates={"backdrop_1"},
        backdrop={
            edge_file="Interface/PVPFrame/UI-Character-PVP-Highlight",
            insets={7,7,7,7}
        },
    },
    backdrop_3={
        templates={"backdrop_1"},
        backdrop={
            edge_file="Interface/Tooltips/UI-Tooltip-Border",
            insets={3,3,3,3}
        }
    },
    -- Resets parent model frame
    reset_model_button={
        frames={
            refresh_model_button={
                type="Button",
                name="$parent_refresh_model_button",
                size={x=36,y=36},
                normal_texture="Interface/BUTTONS/UI-RotationRight-Button-Up",
    
                scripts={
                    OnMouseUp=function(s) 
                        local p = s:GetParent() 
                        if(p)then
                            p:SetFacing(0)
                            p:SetPosition(0,0,0)
                        end
                    end
                }
            }
        }
    },
    editbox_base={
        type="EditBox",

        scripts={
            OnEscapePressed = function(s) s:SetAutoFocus(false) s:ClearFocus()  end
        }
    },
    input_base={

        type="Frame",
        size={x=150, y=30},
        enable_mouse = true,
        
        scripts={
            OnMouseDown=function(s) s.frames.editbox:SetFocus() end
        },

        frames={
            editbox={
                templates={"editbox_base"},
                name="$parent_editbox",
                size={x="$parent - 20", y="$parent - 5"},
                point={"CENTER", "$parent"}
            }
        },

    },
    -- A frame with backdrop (bg and border) and an editbox as a sub-frame.
    input_1={
        templates={"input_base", "backdrop_1"},
        name="input_1",
    },
    input_2={
        templates={"input_base", "backdrop_2"},
        name="input_2",
        size={x=160, y=35},
    },
    input_3={
        templates={"input_base", "backdrop_3"},
        name="input_3",
    },
    input_box_1={
        templates={"input_base", "backdrop_1"},
        name="input_box_1",
        size={x=250,y=200},
        frames={
            editbox={
                multi_line=true,
                size={x="$parent - 20", y="$parent - 5"},
                justify_v="TOP",
                point={"TOP", 0, -8}
            }
        },
    },
    input_box_2={
        templates={"input_box_1", "backdrop_2"},
        name="input_box_2",
        frames={
            editbox={
                size={x="$parent - 22"},
                point={"TOP", 0, -11}
            }
        },
    },
    input_box_3={
        templates={"input_box_2", "backdrop_3"},
        name="input_box_3",
        backdrop={
            edge_file="Interface/Tooltips/UI-Tooltip-Border",
            insets={3,3,3,3}
        },
    },
    -- Checkbox base
    checkbutton_base={
        type="CheckButton",
        size={x=30, y=30},

        strings={
            text={
                text="Check Button!",
                size={x="$parent + 200", y="$parent"},
                point={anchor_point="TOPLEFT", x=33},
                font_object=GameFontHighlight,
                color={1,0.82,0},
                justify_h="LEFT"
            }
        },

    },
    -- Standard blizzard checkbox with custom text
    checkbutton_1={
        templates={"checkbutton_base"},
        inherits="UICheckButtonTemplate",
        checked=true
    },
    -- With select area as well on the right side of the checkbox
    checkbutton_2={
        templates={"checkbutton_base"},
        inherits="InterfaceOptionsCheckButtonTemplate",
    },
    model_base={
        type="Model",
        name="model_base",
        size={x=150,y=150},
        camera=0,
    },
    player_model_base={
        templates={"model_base"},
        type="PlayerModel",
        name="player_model_base"
    },
    model_box={
        templates={"player_model_base"},
        model="World\\Generic\\human\\passive doodads\\peasantlumber\\peasantlumber01.m2",
        backdrop_color={0.7,0.7,0.7, 0.8},
        enable_mouse=true,
        enable_mouse_wheel=true,

        scripts={
            OnConjure=resourcery.scripts.ModelControls
        }
    },
    title_box={
        name="title_box",
        type="Frame",
        backdrop={
            bg_file = "Interface/CHARACTERFRAME/UI-Party-Background",
            edge_file = "Interface/DialogFrame/UI-DialogBox-Border",
            edge_size = 16,
            tile_size = 16,
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        },
        point={anchor_point="TOP"},

        size={180,30},

        strings={
            title={
                text="Test title!",
            }
        }

    },

    box_lite = {

        name = "box_lite_template",

        type = "Frame",

        size = {
            x = "$PlayerFrame",
            y = "$PlayerFrame"
        },
        moveable = true,
        clamped = true,

        --[[
            backdrop = {
                bg_file = "Interface/Tooltips/UI-Tooltip-Background",
                edge_file = "Interface/DialogFrame/UI-DialogBox-Border",
                edge_size = 20,
                insets = { left = 8, right = 8, top = 8, bottom = 8 }
            },
        ]]
        backdrop = {
            "Interface/Tooltips/UI-Tooltip-Background",
            "Interface/DialogFrame/UI-DialogBox-Border",
            28,
            false,
            0,
            {
                10,10,10,10
            }
        },
        backdrop_color = {1, 0, 0},

    },

    box_lite_1 = {

        name="box_lite_1_template",
        type="Frame",

        size={x=100, y=250},
        moveable=true,

        backdrop={
            bg_file = "Interface\\CHARACTERFRAME\\UI-Party-Background",
            edge_file = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
            edge_size = 16,
            tile_size = 16,
            insets = { left = 7, right = 7, top = 7, bottom = 7 }
        },

        point={anchor_point="TOPLEFT", x=0, y=0},
    },

    bar_base = {
        track="power",
        
        backdrop = {
            bg_file = "Interface/Tooltips/UI-Tooltip-Background",
            --edge_file = "Interface/DialogFrame/UI-DialogBox-Border",
            --edge_size = 5,
            --insets = { left = 4, right = 4, top = 4, bottom = 4 }
        },
    },
    bar_lite = {
        -- If disabled then frame wont be created
        --disabled = true, 

        -- What template(s) configurations it should inherit
        templates = {  
            "bar_base"
        },
        -- https://wowpedia.fandom.com/wiki/API_CreateFrame
        type = "Frame",
        name = "ThemeBarLite",
        -- https://wowpedia.fandom.com/wiki/API_Region_SetParent
        parent = "PlayerFrame",

        -- If it should be hidden by default, omit to show as default
        --hidden = "true", 

        -- https://wowpedia.fandom.com/wiki/API_Region_SetSize
        size = {
            x = "$PlayerFrameManaBar + 5",
            y = 16
        },
        -- https://wowpedia.fandom.com/wiki/API_Region_SetPoint
        point = {
            anchor_point = "TOPLEFT", 
            relative_frame = nil, 
            relative_point = nil, 
            x = 100, 
            y = -100
        },
        -- https://wowpedia.fandom.com/wiki/API_Frame_SetBackdrop

        backdrop = {
            bg_file = "Interface\\Tooltips\\UI-Tooltip-Background",
            edge_file = "Interface\\Tooltips\\UI-Tooltip-Border",
            edge_size = 12,
            insets = {4,4,4,4}
        },

        backdrop_color = { 0, 0, 0, 0.25 },
        -- https://wowpedia.fandom.com/wiki/Layer
        -- https://wowpedia.fandom.com/wiki/API_Frame_SetFrameStrata
        frame_strata = "HIGH",
        -- https://wowpedia.fandom.com/wiki/API_Frame_SetFrameLevel
        frame_level = 0,

        textures = { 
            bar = {
                size = {
                    "$parent - 7",
                    "$parent - 6.5"
                },
                texture = resourcery.BLP_BASE_PATH.."resource_bar",
                
                color = {0.1, 0.1, 1},

                point = {
                    anchor_point = "TOPLEFT", 
                    x = 3, 
                    y = -3
                },
            }
        },

        strings = {
            value = {
                size = {
                    "$parent",
                    "$parent"
                },
                text = "Hello",
                font = {
                    size = 10
                }
            }
        },

    },

    moveable = {
        moveable = true
    },

    -- Is a sub-frame
    close_button = {
        
        frames = {
            close_button = {
                type = "Button",
                name = "$parent_close_button",
                parent = "$parent",
                inherits = "UIPanelCloseButton",
                size = {
                    x = 35,
                    y = 35
                },
                point = {
                    anchor_point = "TOPRIGHT",
                    x = 10,
                    y = 10
                },
                raise = true
            }

        }
    },

    -- Not a sub-frame
    close_btn = {
        
        type = "Button",
        inherits = "UIPanelCloseButton",
        size = {
            x = 35,
            y = 35
        },
        point = {
            anchor_point = "TOPRIGHT",
            x = 10,
            y = 10
        },
        raise = true
    },

    server_restart = {
   
        type="Frame",
        name = "serverRestart",

        size={160, 42},
        point={"TOP",0,-5},
        moveable=true,
        
        backdrop = {
           bg_file = "Interface/Tooltips/UI-Tooltip-Background",
           edge_file = "Interface/Tooltips/UI-Tooltip-Border",
           edge_size = 14,
           insets = { left = 2, right = 2, top = 2, bottom = 2 }
        },
        backdrop_color = {0,0,0, 0.7},
        
        strings = {
           timer = {
              font={size=14},
              size={"$parent", "$parent"},
              justify_h="CENTER",
              justify_v="CENTER"
           }
        },
        
        vars={
           time=10*60,
        },
        
        scripts={
           OnUpdate=resourcery.scripts.ServerCountdown
        }
    },

    button_base = {
        type="Button",
        size={30, 30},
        normal_texture="Interface/Icons/INV_Misc_QuestionMark.blp"
    },

    blizz_button = {
        type = "Button",
        inherits = "UIPanelButtonTemplate",
        size = {100, 30},
        point = {"TOPLEFT",0,0},
        text="Button"
    },
    
    frame_toggler = {
   
        frames = {
           frameToggler = {
              type = "Button",
              name = "$parent_toggler",
              moveable = true,
              size = {30, 30},
              point = {"CENTER", UIParent, "CENTER", -300, 0},
              normal_texture = "Interface/Icons/ABILITY_SEAL.BLP",
              
              scripts = {
                OnConjure=resourcery.scripts.ToggleInitiate,
                OnClick = resourcery.scripts.ToggleParentFrame,
                OnMouseDown = resourcery.scripts.PushTexture,
                OnMouseUp = resourcery.scripts.ReleaseTexture
              }
           }
        }
        
    },
    sf_mouse_drag={
        enable_mouse = true,

        scripts={   
            OnConjure=resourcery.scripts.FrameCuller, -- TODO: Do we need this?
            OnMouseDown=function(container, button)
                if(button=="LeftButton")then
                    local cursor_direction={GetCursorPosition()}
                    local scrollFrame = container:GetParent()

                    resourcery.scripts.SetScrollData(scrollFrame)

                    -- If we fetch child frames before we run the update script 
                    --  then the frameculler later on wont re-fetch all children for each tick.
                    container.children = {container:GetChildren()}
                    resourcery.scripts.CalculateScrollRange(scrollFrame)

                    container:SetScript("OnUpdate", function(container)

                        local cursorPos = {GetCursorPosition()}
                        local scaleModifier = (1 / container.effective_scale)
                        -- Drag direction
                        cursor_direction[1] = ((cursor_direction[1] - cursorPos[1]) * scaleModifier)*-1
                        cursor_direction[2] = (cursor_direction[2] - cursorPos[2]) * scaleModifier
                        -- Calc new value for the setscrollvalue
                        local values = resourcery.scripts.GetScrollValues(scrollFrame)
                        -- scroll range bugs if it is 0
                        local newValues = {
                            x = (scrollFrame.scroll_range.x ~= 0 and (cursor_direction[1]/(scrollFrame.scroll_range.x or 1)) + values.x) or 0,
                            y = (scrollFrame.scroll_range.y ~= 0 and (cursor_direction[2]/(scrollFrame.scroll_range.y or 1)) + values.y) or 0
                        }
                        resourcery.scripts.SetScrollValue(scrollFrame, newValues)
                        
                        -- Reset mouse position
                        cursor_direction[1] = cursorPos[1]
                        cursor_direction[2] = cursorPos[2]
                        
                    end)                  
                end
            end,
            OnMouseUp=function(s)
                s:SetScript("OnUpdate", nil)
            end
         }
    },
    sf_zoom={
        enable_mouse_wheel=true,

        scripts={
            OnConjure=resourcery.scripts.FrameCuller,
            OnMouseWheel=function(container, direction)

                container.scale = container:GetScale()
                
                local scrollFrame = container:GetParent()
                scrollFrame.size = {scrollFrame:GetSize()}

                -- Direction intensity
                if(not(scrollFrame.vars))then
                    scrollFrame.vars = {}
                end
                direction = direction * ((scrollFrame.vars.zoom_intensity or 0.2) * -1)
                if(scrollFrame.vars.reverse_zoom)then
                    direction = direction * -1
                end
                
                -- if we reached min/max zoom already
                if( container.b_max_zoomed and direction > 0 or
                    scrollFrame.vars.max_zoom_in == container.scale and direction < 0 or
                    scrollFrame.vars.max_zoom_out == container.scale and direction > 0
                )then
                    return
                else
                    container.b_max_zoomed = false
                end

                -- For new scale and setting scale min/max if exceeding limits
                container.scale = container.scale - direction
                if(scrollFrame.vars.max_zoom_in and container.scale >= scrollFrame.vars.max_zoom_in)then
                    container.scale = scrollFrame.vars.max_zoom_in
                elseif(scrollFrame.vars.max_zoom_out and container.scale <= scrollFrame.vars.max_zoom_out)then
                    container.scale = scrollFrame.vars.max_zoom_out
                end

                container:SetScale(container.scale)
                resourcery.scripts.SetScrollData(scrollFrame)

                -- We use the rect of container and scrollframe to see if its out of bounds.
                container.rect={
                    [1]=container:GetLeft()*container.scale,
                    [2]=container:GetRight()*container.scale,
                    [3]=container:GetTop()*container.scale,
                    [4]=container:GetBottom()*container.scale
                }
                scrollFrame.rect = {
                    [1]=scrollFrame:GetLeft(),
                    [2]=scrollFrame:GetRight(),
                    [3]=scrollFrame:GetTop(),
                    [4]=scrollFrame:GetBottom()
                }

                -- Check Horizontal, left and right
                if( 
                    (container.rect[2] - container.rect[1]) < scrollFrame.size[1]
                    or (container.rect[3] - container.rect[4]) < scrollFrame.size[2]
                )then

                    if ( scrollFrame.width / container.width ) >= ( scrollFrame.height / container.height ) then
                        scrollFrame.scale = (scrollFrame.width / container.width)
                        container:SetScale(scrollFrame.scale)
                        resourcery.scripts.SetScrollValue(scrollFrame, {0, scrollFrame.vars.values.y})
                    else
                        scrollFrame.scale = (scrollFrame.height / container.height)
                        container:SetScale(scrollFrame.scale)
                        resourcery.scripts.SetScrollValue(scrollFrame, {scrollFrame.vars.values.x, 0})
                    end

                    --resourcery.scripts.TransformToParentFrame(container, "FIT")
                    container.b_max_zoomed = true
                    container.rect={
                        [1]=container:GetLeft()*container.scale,
                        [2]=container:GetRight()*container.scale,
                        [3]=container:GetTop()*container.scale,
                        [4]=container:GetBottom()*container.scale
                    }
                    resourcery.scripts.SetScrollData(scrollFrame)
                end
                -- Align left
                if(container.rect[1] - direction > scrollFrame.rect[1])then
                    --resourcery.scripts.TransformToParentFrame(container, "LEFT")
                    resourcery.scripts.SetScrollValue(scrollFrame, {0, scrollFrame.vars.values.y})
                -- Align right
                elseif(container.rect[2] - direction < scrollFrame.rect[2])then
                    --resourcery.scripts.TransformToParentFrame(container, "RIGHT")
                    resourcery.scripts.SetScrollValue(scrollFrame, {1, scrollFrame.vars.values.y})
                end
                -- Aligh top
                if(container.rect[3] - direction < scrollFrame.rect[3])then
                    --resourcery.scripts.TransformToParentFrame(container, "TOP")
                    resourcery.scripts.SetScrollValue(scrollFrame, {scrollFrame.vars.values.x, 0})
                -- Aligh bottom
                elseif(container.rect[4] - direction > scrollFrame.rect[4])then
                    --resourcery.scripts.TransformToParentFrame(container, "BOTTOM")
                    resourcery.scripts.SetScrollValue(scrollFrame, {scrollFrame.vars.values.x, 1})
                end

                resourcery.scripts.FrameCuller(container)
                resourcery.scripts.CalculateScrollValues(scrollFrame)
                if(scrollFrame.frames.slider or scrollFrame.frames.slider_horizontal)then
                    resourcery.scripts.CheckArrowStatus(scrollFrame.frames.slider or scrollFrame.frames.slider_horizontal)
                    resourcery.scripts.SetSliderThumbRelatedToContainer(container)
                end
            end
        }
    },
    sf_mouse_scroll={
        enable_mouse_wheel=true,

        scripts={
            OnMouseWheel=function(container, direction)

                local scrollFrame = container:GetParent()
                resourcery.scripts.SetScrollData(scrollFrame)

                direction = direction * (scrollFrame.vars.scroll_intensity or 0.1)
                if(scrollFrame.vars and scrollFrame.vars.reverse_scroll) then
                    direction = direction * -1
                end
                local value = (not(scrollFrame.vars.horizontal_scroll) and scrollFrame.vars.values.y or scrollFrame.vars.values.x) - direction
                if(value < 0)then
                    value = 0
                elseif(value > 1)then
                    value = 1
                end

                if(scrollFrame.vars.horizontal_scroll)then
                    scrollFrame.vars.values.x = value
                else
                    scrollFrame.vars.values.y = value
                end

                resourcery.scripts.SetScrollValue(scrollFrame, {scrollFrame.vars.values.x, scrollFrame.vars.values.y})
                -- We are running an OnUpdate here since the container's children positions aren't updated by the time FrameCuller is run
                container:SetScript("OnUpdate", function(s, e)
                    s.time = (s.time and s.time + e or 0)
                    if(s.time > 0)then
                        resourcery.scripts.FrameCuller(container)
                        s.time = 0
                        s:SetScript("OnUpdate", nil)
                    end
                end)
            end,
         }
    },
    slider_thumb={
        textures={
            thumb={
                name="$parent_thumb",
                type="Texture",
                size={30, 30},
                texture="Interface/BUTTONS/UI-Quickslot-Depress.blp",
                point={"TOP", "$parent", "TOP", 0, 0}
            },
        }
    },
    slider_thumb_horizontal={
        textures={
            thumb_horizontal={
                name="$parent_thumb_horizontal",
                type="Texture",
                size={30, 30},
                texture="Interface/BUTTONS/UI-Quickslot-Depress.blp",
                point={"LEFT", "$parent", "LEFT", 0, 0}
            },
        }
    },
    slider_up={
        frames={
            up={
                templates={"button_base"},
                name="$parent_up",
                point={"TOP", "$parent", "TOP", 0, 0},

                normal_texture="Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Up.blp",
                disabled_texture="Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Disabled.blp",

                scripts={
                    OnMouseDown=function(up)
                        local slider = up:GetParent()
                        local scrollFrame = slider:GetParent()
                        resourcery.scripts.SetScrollData(scrollFrame)
                        local scrollValue = scrollFrame.vars.values.y - (scrollFrame.vars.value_step or 0.2)
                        
                        resourcery.scripts.SetScrollValue(scrollFrame, {scrollFrame.vars.values.x, scrollValue})
                        PlaySound("UChatScrollButton")
                    end
                }
            },
        }
    },
    slider_down={
        frames={
            down={
                templates={"button_base"},
                name="$parent_down",
                point={"BOTTOM", "$parent", "BOTTOM"},
    
                normal_texture="Interface/BUTTONS/UI-ScrollBar-ScrollDownButton-Up.blp",
                disabled_texture="Interface/BUTTONS/UI-ScrollBar-ScrollDownButton-Disabled.blp",
    
                scripts={
                    OnMouseDown=function(down)
                        local slider = down:GetParent()
                        local scrollFrame = slider:GetParent()
                        resourcery.scripts.SetScrollData(scrollFrame)
                        
                        local scrollValue = scrollFrame.vars.values.y + (scrollFrame.vars.value_step or 0.2)
                        resourcery.scripts.SetScrollValue(scrollFrame, {scrollFrame.vars.values.x, scrollValue})
                        PlaySound("UChatScrollButton")
                    end
                }
            },
        }
    },
    slider_left={
        frames={
           left={
                templates={"button_base"},
                name="$parent_left",
                point={"LEFT", "$parent", "LEFT", 3, 1},
                normal_texture="Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Up.blp",
                disabled_texture="Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Disabled.blp",

                scripts={
                    OnMouseDown=function(left)
                        local slider = left:GetParent()
                        local scrollFrame = slider:GetParent()
                        resourcery.scripts.SetScrollData(scrollFrame)
                        
                        local scrollValue = scrollFrame.vars.values.x - (scrollFrame.vars.value_step or 0.2)
                        resourcery.scripts.SetScrollValue(scrollFrame, {scrollValue, scrollFrame.vars.values.y})
                        PlaySound("UChatScrollButton")
                    end
                }
           }
        }
    },
    slider_right={
        frames={
            right={
                templates={"button_base"},
                name="$parent_right",
                point={"RIGHT", "$parent", "RIGHT", -3, 0},
                normal_texture="Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Up.blp",
                disabled_texture="Interface/BUTTONS/UI-ScrollBar-ScrollUpButton-Disabled.blp",

                scripts={
                    OnMouseDown=function(right)
                        local slider = right:GetParent()
                        local scrollFrame = slider:GetParent()
                        resourcery.scripts.SetScrollData(scrollFrame)
                        
                        local scrollValue = scrollFrame.vars.values.x + (scrollFrame.vars.value_step or 0.2)
                        resourcery.scripts.SetScrollValue(scrollFrame, {scrollValue, scrollFrame.vars.values.y})
                        PlaySound("UChatScrollButton")
                    end
                }
            }
        }
    },
    slider_left_rotated={
        templates={"slider_left"},
        frames={
           left={
                scripts={
                    OnConjure=function(left)
                        local size = {left:GetSize()}
                        -- We have to increase the size of the frame since the texture will change its size thanks to SetRotation(SetTexCoord)
                        left:SetSize(size[1]*1.41, size[2]*1.41)
        
                        -- The hitrect will need to be edited to match its new look
                        local hitRect = (1-((size[1]/math.sqrt(2))/size[1]))
                        left:SetHitRectInsets(
                            hitRect,
                            hitRect,
                            hitRect,
                            hitRect
                        )
        
                        left:GetNormalTexture():SetRotation(math.rad(90))
                        left:GetDisabledTexture():SetRotation(math.rad(90))
                        left:GetHighlightTexture():SetRotation(math.rad(90))
                        left:GetPushedTexture():SetRotation(math.rad(90))
        
                        local point = {left:GetPoint()}

                        left:SetPoint(
                            point[1],
                            point[4] - size[1]*hitRect,
                            point[5]
                        )
                        
                    end
                }
           }
        }
    },
    slider_right_rotated={
        templates={"slider_right"},
        frames={
            right={
                scripts={
                    OnConjure=function(left)
                        local size = {left:GetSize()}
                        -- We have to increase the size of the frame since the texture will change its size thanks to SetRotation(SetTexCoord)
                        left:SetSize(size[1]*1.41, size[2]*1.41)

                        -- The hitrect will need to be edited to match its new look
                        local hitRect = (1-((size[1]/math.sqrt(2))/size[1]))
                        local hitRectCalc = -(hitRect*size[1])
                        left:SetHitRectInsets( -- TODO this is not working
                            hitRectCalc,
                            hitRectCalc,
                            hitRectCalc,
                            hitRectCalc
                        )

                        left:GetNormalTexture():SetRotation(math.rad(-90))
                        left:GetDisabledTexture():SetRotation(math.rad(-90))
                        left:GetHighlightTexture():SetRotation(math.rad(-90))
                        left:GetPushedTexture():SetRotation(math.rad(-90))

                        local point = {left:GetPoint()}

                        left:SetPoint(
                            point[1],
                            point[4] + size[1]*hitRect,
                            point[5]
                        )
                        
                    end
                }
            }
        }
    },
    slider_scripts={
        scripts={
            -- Move thumb to below of the top button
            OnConjure=function(slider)
                local scrollFrame = slider:GetParent()

                if(not(scrollFrame.frames.container))then
              
                    slider.time = 0
                    slider:SetScript("OnUpdate", function(s, elapsed)
                        s.time = s.time + elapsed

                        if(s.time > 2 or scrollFrame.frames.container)then
                            s:SetScript("OnUpdate", nil)
                            if(scrollFrame.frames.container)then
                                resourcery.scripts.SetScrollData(scrollFrame)
                                local values = {
                                    x = scrollFrame.vars and scrollFrame.vars.values.x or 0,
                                    y = scrollFrame.vars and scrollFrame.vars.values.y or 0
                                }
                                resourcery.scripts.SetScrollValue(scrollFrame, values)
                            end
                        end
                    end)
                else
                    resourcery.scripts.SetScrollData(scrollFrame)
                    local values = {
                        x = scrollFrame.vars and scrollFrame.vars.values.x or 0,
                        y = scrollFrame.vars and scrollFrame.vars.values.y or 0
                    }
                    resourcery.scripts.SetScrollValue(scrollFrame, values)
                end
            end,
            OnMouseDown=function(slider)
                local scrollFrame = slider:GetParent()

                resourcery.scripts.SetScrollData(scrollFrame)
                slider:SetScript("OnUpdate", function()
                    local currentValue = resourcery.scripts.GetScrollClickValue(slider)
                    resourcery.scripts.SetScrollValue(slider:GetParent(), {scrollFrame.vars.values.x, currentValue})
                end)
            end,
            OnMouseUp=function(s)
                s:SetScript("OnUpdate", nil)
            end
        }
    },
    slider={

        frames={
            slider={
                templates={"slider_scripts", "slider_thumb", "slider_up", "slider_down", "backdrop_3"},
                name="$parent_slider",
                type="Frame",
                size={30, "$parent + 4"},
                point={"LEFT", "$parent", "RIGHT", -1, 0},

                enable_mouse=true,
            }
        }
    },
    slider_horizontal={
        frames={
            slider_horizontal={
                templates={"slider_scripts", "slider_thumb_horizontal", "slider_left", "slider_right", "backdrop_3"},
                name="$parent_slider_horizontal",
                type="Frame",
                size={ "$parent + 4" , 30},
                point={"TOP", "$parent", "BOTTOM", 0, 1},
                parent="$parent",

                enable_mouse=true,
    
                scripts={
                    OnMouseDown=function(slider)
                        local scrollFrame = slider:GetParent()
        
                        resourcery.scripts.SetScrollData(scrollFrame)
                        slider:SetScript("OnUpdate", function()
                            local currentValue = resourcery.scripts.GetScrollClickValue(slider)
                            resourcery.scripts.SetScrollValue(slider:GetParent(), {currentValue, scrollFrame.vars.values.y})
                        end)
                    end,
                }
            },
        },
    },
    slider_horizontal_rotated_buttons={
        templates={"slider_horizontal"},
        
        frames={
            slider_horizontal={
                templates={"slider_scripts", "slider_thumb_horizontal", "slider_left_rotated", "slider_right_rotated", "backdrop_3"},
            }
        }
    },
    slider_no_buttons={

        frames={
            slider={
                templates={"slider_scripts", "slider_thumb", "backdrop_3"},
                name="$parent_slider",
                type="Frame",
                size={30, "$parent + 4"},
                point={"LEFT", "$parent", "RIGHT", -1, 0},

                enable_mouse=true,
            }
        }
    },
    slider_horizontal_no_buttons={
        frames={
            slider_horizontal={
                templates={"slider_scripts", "slider_thumb_horizontal", "backdrop_3"},
                name="$parent_slider_horizontal",
                type="Frame",
                size={ "$parent + 4" , 30},
                point={"TOP", "$parent", "BOTTOM", 0, 1},

                enable_mouse=true,

                scripts={
                    OnMouseDown=function(slider)
                        local scrollFrame = slider:GetParent()
        
                        resourcery.scripts.SetScrollData(scrollFrame)
                        slider:SetScript("OnUpdate", function()
                            local currentValue = resourcery.scripts.GetScrollClickValue(slider)
                            resourcery.scripts.SetScrollValue(slider:GetParent(), {currentValue, scrollFrame.vars.values.y})
                        end)
                    end,
                }
            }
        }
    },
    container_base={
        type="Frame",
        name="$parent_container",
        size={"$parent", "$parent + 200"},
        point={"CENTER", "$parent", "CENTER", 0, 0},
        child_to="$parent",

        backdrop={
            bg_file="Interface/TALENTFRAME/DruidRestoration-TopLeft.blp",
            insets={0,0,0,0}
        },
    },
    container_basic={

        frames={
            container={
                templates={"container_base", "sf_mouse_drag", "sf_mouse_scroll"},
            }
        }
    },
    container_1={ -- this is container_basic
        templates={"container_basic"}
    },
    container_scroll={

        frames={
            container={
                templates={"container_base", "sf_mouse_scroll"},
            }
        }
    },
    container_2={ -- this is container_scroll
        templates={"container_scroll"}
    },
    container_drag={

        frames={
            container={
                templates={"container_base", "sf_mouse_drag"},
            }
        }
    },
    container_3={ -- this is container_drag
        templates={"container_drag"}
    },
    container_zoom={

        frames={
            container={
                templates={"container_base", "sf_zoom"},
            }
        }
    },
    container_4={ -- this is container_zoom
        templates={"container_zoom"}
    },
    container_drag_zoom={
        
        frames={
            container={
                templates={"container_base", "sf_mouse_drag", "sf_zoom"},
            }
        }
    },
    container_zoom_drag={ -- this is container_drag_zoom
        templates={"container_drag_zoom"}
    },
    container_5={ -- this is container_drag_zoom
        templates={"container_drag_zoom"}
    },
    container_drag_scroll={ -- this is container_basic
        templates={"container_basic"}
    },
    container_scroll_drag={ -- this is container_basic
        templates={"container_basic"}
    },
    -- A ScrollFrame with a basic vertical slider
    scrollframe={
        templates={"slider"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_1={ -- this is scrollframe
        templates={"scrollframe"},
    },
    -- A ScrollFrame with a basic vertical slider and no buttons
    scrollframe_no_buttons={
        templates={"slider_no_buttons"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_2={ -- this is scrollframe_no_buttons
        templates={"scrollframe_no_buttons"},
    },
    -- A ScrollFrame with a basic horizontal slider
    scrollframe_horizontal={
        templates={"slider_horizontal"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_3={ -- this is scrollframe_horizontal
        templates={"scrollframe_horizontal"},
    },
    -- A ScrollFrame with a basic horizontal slider
    scrollframe_horizontal_no_buttons={
        templates={"slider_horizontal_no_buttons"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_4={ -- this is scrollframe_horizontal_no_buttons
        templates={"scrollframe_horizontal_no_buttons"},
    },
    -- A ScrollFrame with a basic horizontal slider
    scrollframe_horizontal_rotated={
        templates={"slider_horizontal_rotated_buttons"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_5={ -- this is scrollframe_horizontal_rotated
        templates={"scrollframe_horizontal_rotated"},
    },
    -- A ScrollFrame with a basic horizontal and vertical sliders
    scrollframe_sliders={
        templates={"slider", "slider_horizontal"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_6={ -- this is scrollframe_sliders
        templates={"scrollframe_sliders"},
    },
    -- A ScrollFrame with a basic horizontal (rotated buttons) and vertical sliders
    scrollframe_sliders_horizontal_rotated={
        templates={"slider", "slider_horizontal_rotated_buttons"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_7={ -- this is scrollframe_sliders_horizontal_rotated
        templates={"scrollframe_sliders_horizontal_rotated"},
    },
    -- A ScrollFrame with a basic horizontal and vertical sliders, no buttons
    scrollframe_sliders_no_buttons={
        templates={"slider_no_buttons", "slider_horizontal_no_buttons"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_8={ -- this is scrollframe_sliders_no_buttons
        templates={"scrollframe_sliders_no_buttons"},
    },
    -- A ScrollFrame with a basic horizontal (no buttons) and vertical sliders
    scrollframe_sliders_horizontal_no_buttons={
        templates={"slider", "slider_horizontal_no_buttons"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_9={ -- this is scrollframe_sliders_horizontal_no_buttons
        templates={"scrollframe_sliders_horizontal_no_buttons"},
    },
    -- A ScrollFrame with a basic horizontal and vertical (no buttons) sliders
    scrollframe_sliders_vertical_no_buttons={
        templates={"slider_no_buttons", "slider_horizontal"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_10={ -- this is scrollframe_sliders_vertical_no_buttons
        templates={"scrollframe_sliders_vertical_no_buttons"},
    },
    -- A ScrollFrame with a basic horizontal (rotated buttons) and vertical (no buttons) sliders
    scrollframe_sliders_vertical_no_buttons_horizontal_rotated={
        templates={"slider_no_buttons", "slider_horizontal_rotated_buttons"},
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_11={ -- this is scrollframe_sliders_vertical_no_buttons_horizontal_rotated
        templates={"scrollframe_sliders_vertical_no_buttons_horizontal_rotated"},
    },
    -- A ScrollFrame with no horizontal and no vertical sliders
    scrollframe_no_sliders={
        type="ScrollFrame",
        name="scrollframe_base",
        size={500, 250},

        frames={
            container={
                templates={"container_base"}
            }
        }
    },
    scrollframe_12={ -- this is scrollframe_no_sliders
        templates={"scrollframe_no_sliders"},
    },
    scrollframe_border_1={

        frames={
            border={
                templates={"backdrop_1"},
                type="Frame",
                name="$parent_border",
                backdrop={
                    bg_file="",
                    edge_size=22
                },
                size={"$parent + 10", "$parent + 10"},
                point={x=-3,y=3}
            }
        }
    },
    scrollframe_border_2={

        frames={
            border={
                templates={"backdrop_2"},
                type="Frame",
                name="$parent_border",
                backdrop={
                    bg_file="",
                    edge_size=22
                },
                size={"$parent + 19", "$parent + 21"},
                point={anchor_point="TOPLEFT",x=-10,y=10}
            }
        }
    },
    scrollframe_border_3={

        frames={
            border={
                templates={"backdrop_3"},
                type="Frame",
                name="$parent_border",
                backdrop={
                    bg_file="",
                    edge_size=18
                },
                size={"$parent + 9", "$parent + 9"},
                point={anchor_point="TOPLEFT",x=-5,y=5}
            }
        }
    }
}