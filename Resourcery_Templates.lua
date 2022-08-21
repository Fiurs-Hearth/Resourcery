-- Author: Fiur#8658

resourcery.templates = {

    basic_window = {

    },

    box_lite = {

        name = "box_lite_template",

        frame_type = "Frame",

        size = {
            x = "$PlayerFrame",
            y = "$PlayerFrame"
        },

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
        frame_type = "Frame",
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
            ofsx = 100, 
            ofsy = -100
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
                    ofsx = 3, 
                    ofsy = -3
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

    close_button = {
        
        frames = {
            close = {
                frame_type = "Button",
                parent = "$parent",
                inherits = "UIPanelCloseButton",
                size = {
                    x = 35,
                    y = 35
                },
                point = {
                    anchor_point = "TOPRIGHT",
                    ofsx = 10,
                    ofsy = 10
                },
                raise = true
            }

        }
    },

    close_btn = {
        
        frame_type = "Button",
        inherits = "UIPanelCloseButton",
        size = {
            x = 35,
            y = 35
        },
        point = {
            anchor_point = "TOPRIGHT",
            ofsx = 10,
            ofsy = 10
        },
        raise = true
    }
}