-- Author: Fiur#8658

resourcery.templates = {

    basic_window = {
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
    },

    test={
        size={x=1000,y=500}
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
                text="Check Box!",
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
    model_box_1={
        templates={"player_model_base", "reset_model_button"},
        model="World\\Generic\\human\\passive doodads\\peasantlumber\\peasantlumber01.m2",
        backdrop={
            bg_file="Interface/CHATFRAME/CHATFRAMEBACKGROUND.blp",
            edge_file="Interface/DialogFrame/UI-DialogBox-Border",
            edge_size=16,
            insets={5,5,5,5}
        },
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
                 OnClick = resourcery.scripts.ToggleParentFrame,
                 OnMouseDown = resourcery.scripts.PushTexture,
                 OnMouseUp = resourcery.scripts.ReleaseTexture
              }
           }
        }
        
    },

    scroll_test={
        --templates={"backdrop_1"},
        name="WIP",
        type="ScrollFrame",
        size={400,300},

        backdrop={
            bg_file="Interface/CHATFRAME/CHATFRAMEBACKGROUND.blp",
            edge_file="Interface/DialogFrame/UI-DialogBox-Border",
            edge_size=16,
            --insets={5,5,5,5}
        },
    },

    scroll_child={
        templates={"backdrop_2"},
        name="scroll_child_test",
        type="Frame",
        
        size={150,150},
        backdrop_color={1,1,0},
        raise=true,
        point={"TOP", 10, 100}
    },

    sf_mouse_drag={
        enable_mouse = true,

        scripts={   
            OnConjure=resourcery.scripts.FrameCuller,
            OnMouseDown=function(s, button)
                if(button=="LeftButton")then

                    local parentFrame = s:GetParent()
                    local parentFrameRect = {
                        [1]=parentFrame:GetLeft(),
                        [2]=parentFrame:GetRight(),
                        [3]=parentFrame:GetTop(),
                        [4]=parentFrame:GetBottom()
                    }

                    if(not(s.vars))then
                        s.vars={}
                    end
                    -- If we fetch child frames before we run the update script 
                    --  then the frameculler wont re-fetch all children for each tick.
                    s.vars.children = {s:GetChildren()}
                    local cursor_direction={GetCursorPosition()}

                    s:SetScript("OnUpdate", function(s)
                        local cursorPos = {GetCursorPosition()}
                        local currentScale = s:GetScale()

                        local frameRect={
                            [1]=s:GetLeft()*currentScale,
                            [2]=s:GetRight()*currentScale,
                            [3]=s:GetTop()*currentScale,
                            [4]=s:GetBottom()*currentScale
                        }
                        local scaleModifier = (1 / currentScale) * 1.1
                        cursor_direction[1] = (cursor_direction[1] - cursorPos[1]) * scaleModifier
                        cursor_direction[2] = (cursor_direction[2] - cursorPos[2]) * scaleModifier

                        local framePoint={s:GetPoint()}

                        if(
                            frameRect[1] - cursor_direction[1] > parentFrameRect[1] or
                            frameRect[2] - cursor_direction[1] < parentFrameRect[2] or
                            frameRect[3] - cursor_direction[2] < parentFrameRect[3] or 
                            frameRect[4] - cursor_direction[2] > parentFrameRect[4]
                        )then
                            local align = {}
                            if(frameRect[1] - cursor_direction[1] > parentFrameRect[1])then
                                table.insert(align, "LEFT")
                                cursor_direction[1] = 0
                            end
                            if(frameRect[2] - cursor_direction[1] < parentFrameRect[2])then
                                table.insert(align, "RIGHT")
                                cursor_direction[1] = 0
                            end
                            if(frameRect[3] - cursor_direction[2] < parentFrameRect[3])then
                                table.insert(align, "TOP")
                                cursor_direction[2] = 0
                            end
                            if(frameRect[4] - cursor_direction[2] > parentFrameRect[4])then
                                table.insert(align, "BOTTOM")
                                cursor_direction[2] = 0
                            end

                            -- We do this incase we are in a corner.
                            for k,v in pairs(align)do
                                resourcery.scripts.TransformToParentFrame(s, v)
                            end

                            framePoint={s:GetPoint()}
                            s:SetPoint(
                                framePoint[1],
                                framePoint[4] - cursor_direction[1],
                                framePoint[5] - cursor_direction[2]
                            )
                        else
                            s:SetPoint(
                                framePoint[1],
                                framePoint[4] - (cursor_direction[1]),
                                framePoint[5] - (cursor_direction[2])
                            )
                        end

                        cursor_direction[1] = cursorPos[1] -- reset it
                        cursor_direction[2] = cursorPos[2] -- reset it

                        resourcery.scripts.FrameCuller(s)
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

        vars={
            maxZoom_in=1.5,
            maxZoom_out=0.25,
            zoomIntensity = 0.1,
            reverseZoom = false
        },

        scripts={
            OnConjure=resourcery.scripts.FrameCuller,
            OnMouseWheel=function(s, direction)

                local parentFrame = s:GetParent()
                local scrollFrameSize = {parentFrame:GetSize()}
                local currentScale = s:GetScale()
                direction = direction * (s.vars.zoomIntensity * -1)
                if(s.vars.reverseZoom)then
                    direction = direction * -1
                end
                
                if(s.vars.b_maxZoomed and direction > 0)then
                    return
                else
                    s.vars.b_maxZoomed = false
                end

                currentScale = currentScale - direction
                if(currentScale >= s.vars.maxZoom_in)then
                    currentScale = s.vars.maxZoom_in
                elseif(currentScale <= s.vars.maxZoom_out)then
                    currentScale = s.vars.maxZoom_out
                end

                s:SetScale(currentScale)
                local frameRect={
                    [1]=s:GetLeft()*currentScale,
                    [2]=s:GetRight()*currentScale,
                    [3]=s:GetTop()*currentScale,
                    [4]=s:GetBottom()*currentScale
                }
                local parentFrameRect = {
                    [1]=parentFrame:GetLeft(),
                    [2]=parentFrame:GetRight(),
                    [3]=parentFrame:GetTop(),
                    [4]=parentFrame:GetBottom()
                }

                local framePoint={s:GetPoint()}
                
                -- Check Horizontal, left and right
                if( 
                    (frameRect[2] - frameRect[1]) < scrollFrameSize[1]
                    or (frameRect[3] - frameRect[4]) < scrollFrameSize[2]
                )then
                    resourcery.scripts.TransformToParentFrame(s, "FIT")
                    s.vars.b_maxZoomed = true
                    frameRect={
                        [1]=s:GetLeft()*currentScale,
                        [2]=s:GetRight()*currentScale,
                        [3]=s:GetTop()*currentScale,
                        [4]=s:GetBottom()*currentScale
                    }
                end
                -- Align left
                if(frameRect[1] - direction > parentFrameRect[1])then
                    resourcery.scripts.TransformToParentFrame(s, "LEFT")
                -- Align right
                elseif(frameRect[2] - direction < parentFrameRect[2])then
                    resourcery.scripts.TransformToParentFrame(s, "RIGHT")
                end
                -- Aligh top
                if(frameRect[3] - direction < parentFrameRect[3])then
                    resourcery.scripts.TransformToParentFrame(s, "TOP")
                -- Aligh bottom
                elseif(frameRect[4] - direction > parentFrameRect[4])then
                    resourcery.scripts.TransformToParentFrame(s, "BOTTOM")
                end

                resourcery.scripts.FrameCuller(s)
            end
        }
    },
    sf_mouse_scroll={
        enable_mouse_wheel=true,

        vars={
            scrollIntensity = 30,
            reverseZoom = false
        },

        scripts={
            OnMouseWheel=function(s, direction)

                local parentFrame = s:GetParent()
                direction = direction * s.vars.scrollIntensity
                if(s.vars.reverseZoom) then
                    direction = direction * -1
                end
                
                local point={s:GetPoint()}
                local currentScale = s:GetScale()
                local frameRect={
                    [1]=s:GetLeft()*currentScale,
                    [2]=s:GetRight()*currentScale,
                    [3]=s:GetTop()*currentScale,
                    [4]=s:GetBottom()*currentScale
                }
                local parentFrameRect = {
                    [3]=parentFrame:GetTop(),
                    [4]=parentFrame:GetBottom()
                }
                
                -- Aligh top
                if(frameRect[3] - direction < parentFrameRect[3])then
                    resourcery.scripts.TransformToParentFrame(s, "TOP")
                -- Aligh bottom
                elseif(frameRect[4] - direction > parentFrameRect[4])then
                    resourcery.scripts.TransformToParentFrame(s, "BOTTOM")
                else
                    s:SetPoint(
                        point[1],
                        point[4], 
                        point[5] - direction
                    )
                end
                
                resourcery.scripts.FrameCuller(s)
            end,
         }
    },
    sf_slider={

        frames={
            slider={
                templates={"backdrop_1"},
                name="$parent_slider",
                type="Slider",
                inherits="UIPanelScrollBarTemplate",
                size={30, "$parent + 10"},
                point={"LEFT", "WIP", "RIGHT", -30, 0},
                
                --orientation="VERTICAL",
                --min_max_values={0, "$parent + 100"}
            }
        },


        --SetMinMaxValues (WIP_container:GetHeight() - ( 1/WIP_container:GetScale()*WIP:GetHeight() ))
    },

}

--print(WIP_slider:GetParent())