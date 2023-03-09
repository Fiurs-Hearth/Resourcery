-- Author: Fiur#8658

local power, maxPower
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

    local function updateResourceData(frame)
        unitPower = UnitPower("player", power)
        maxPower = UnitPowerMax("player", power)
        frame.strings.value:SetText(unitPower.."/"..maxPower)
        currentPower = frame['maxWidth'] * (unitPower/maxPower)
        if(currentPower <= 0)then
            frame.textures.bar:SetWidth(0.001)
        else
            frame.textures.bar:SetWidth(currentPower)    
        end
    end

    local function startUpdate(frame, e)

        local time = 0

        frame:SetScript("OnUpdate", function(self)
            time = time + arg1
            if(time > 0.1)then
                time = 0
                updateResourceData(self)
                
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

    frame:SetScript("OnEvent", function(self, e, u)

        if(e == "UNIT_AURA" and u ~= "player" or e == "UNIT_STATS" and u ~= "player") then
            return
        end
        if( not(self:GetScript("OnUpdate")) ) then            
            startUpdate(self, e)
        end
    end)
    frame:RegisterEvent(event)
    frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    frame:RegisterEvent("PLAYER_LEVEL_UP")
    frame:RegisterEvent("UNIT_STATS")
	frame:RegisterEvent("UNIT_AURA")
    
    return frame
end