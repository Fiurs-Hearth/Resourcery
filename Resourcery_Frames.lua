-- Author: Fiur#8658

resourcery.frames = {

    -- Created by using a template
    box_test = {
        templates = {"box_lite", "moveable", "close_button"},
        name = "boxTest",

        backdrop_color = {1, 1, 0},

        point = {
            "TOPLEFT", PlayerFrame, "BOTTOMRIGHT", 0, -100
        },
    },

    mana_bar = {
        templates = { 
            "bar_lite"
        },

        name="NewManaBar",
        
        point= {
            ofsy = -100
        },
    },
    energy_bar = {
        templates = { 
            "bar_lite"
        },

        name="NewEnergyBar",

        point= {
            ofsy = -200
        },
        
        frames = {
            close2 = {
                templates = {"close_btn"},
                point = {
                    anchor_point = "TOPLEFT"
                }
            }
        },
    },
    
}