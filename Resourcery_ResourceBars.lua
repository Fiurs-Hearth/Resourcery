-- Author: Fiur#8658

local power, maxPower
local resourceBars = {}
-- Generate one resource bar.
function resourcery.CreateResourceBar(power, colorTable, event)

    local frame = resourcery.StartConjuring({
        templates = {"bar_lite"},
        name = "bar_"..power,
        point = {
            relative_frame = "UIParent"
        },
        textures = {
            bar = {
                color = colorTable
            }
        }
    })


    local function startUpdate(frame)

        local time = 0
        frame:SetScript("OnUpdate", function(self)
            
            time = time + arg1
            if(time > 0.1)then
                time = 0
                unitPower = UnitPower("player", power)
                maxPower = UnitPowerMax("player", power)
                self.strings.value:SetText(unitPower.."/"..maxPower)
                currentPower = frame['maxWidth'] * (unitPower/maxPower)
                if(currentPower <= 0)then
                    self.textures.bar:SetWidth(0.001)
                else
                    self.textures.bar:SetWidth(currentPower)    
                end
                if(UnitPower("player", power) >= UnitPowerMax("player", power)) then
                    self:SetScript("OnUpdate", nil)
                end
            end
            
        end)
    end
    
    unitPower = UnitPower("player", power)
    maxPower = UnitPowerMax("player", power)
    
    frame['maxWidth'] = frame.textures.bar:GetWidth()
    frame.strings.value:SetText(unitPower.."/"..maxPower)
    frame.textures.bar:SetWidth(frame['maxWidth'] * (unitPower/maxPower) + 0.001)
    
    if(unitPower < maxPower) then
        startUpdate(frame)
    end

    frame:SetScript("OnEvent", function(self)

        if(not(self:GetScript("OnUpdate")) and UnitPower("player", power) < UnitPowerMax("player", power)) then            
            startUpdate(self)
        end
    end)
    frame:RegisterEvent(event)
    
    return frame
end

-- Create resource bars if not already created
if( not(_G['resourceBars']) ) then

    local dummyFrame = CreateFrame("Frame")
    dummyFrame:SetScript("OnEvent", function(self, event)
    
        resourceBars.red = {1, 0.1, 0.1}
        resourceBars.blue = {0.1, 0.1, 1}
        resourceBars.yellow = {1, 1, 0.1}
    
        _G['bar_0'] = resourcery.CreateResourceBar(0, resourceBars.blue, "UNIT_MANA")
        _G['bar_1'] = resourcery.CreateResourceBar(1, resourceBars.red, "UNIT_RAGE")  
        _G['bar_3'] = resourcery.CreateResourceBar(3, resourceBars.yellow, "UNIT_ENERGY")
    
        resourceBars = resourcery.StartConjuring({
            frame_type = "Frame",
            name = "resourceBars",
            size = {
                "$bar_0", 
                "$bar_0 + $bar_1 + $bar_3"
            },
            parent = "PlayerFrame",
            point = {
                relative_frame = "PlayerFrame",
                ofsx = 28,
                ofsy = -80,
                clear = true
            },
            moveable = true
        })
        resourceBars.mana = _G['bar_0']
        resourceBars.rage = _G['bar_1']
        resourceBars.energy = _G['bar_3']
        
        resourceBars.mana:SetParent(resourceBars)
        resourceBars.mana:SetPoint("TOPLEFT", resourceBars, "TOPLEFT", 0, 0)
        resourceBars.rage:SetParent(resourceBars)
        resourceBars.rage:SetPoint("TOPLEFT", resourceBars, "TOPLEFT", 0, -16)
        resourceBars.energy:SetParent(resourceBars)
        resourceBars.energy:SetPoint("TOPLEFT", resourceBars, "TOPLEFT", 0, -32)

    end)
    dummyFrame:RegisterEvent("PLAYER_ENTERING_WORLD")


end