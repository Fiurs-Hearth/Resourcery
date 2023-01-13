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
        
     }

}