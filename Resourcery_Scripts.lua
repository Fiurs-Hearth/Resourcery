
resourcery.scripts = {
    -- Hide/Show 
    ToggleParentFrame = function(self)
    
        if(not(self.targetFrame)) then
            if(self:GetParent():GetName())then
                self.targetFrame = self:GetParent():GetName()
            end
        end
        self:SetParent(UIParent)

        if(_G[self.targetFrame]:IsVisible()) then
            _G[self.targetFrame]:Hide()
        else
            _G[self.targetFrame]:Show()
        end
    end,
    -- Sets texture color to simulate a button press
    PushTexture = function(self)
        self:GetHighlightTexture():SetVertexColor(1,1,1,0)
        local pushed=self:GetPushedTexture()
        pushed:SetDesaturated(false)
        pushed:SetVertexColor(0.7,0.7,0.7)
    end,
    -- Sets texture to default color
    ReleaseTexture = function(self) 
        self:GetHighlightTexture():SetVertexColor(1,1,1,1)
    end,
    -- Used to countdown a string named timer
    ServerCountdown = function(self, elapsed)
        self.vars.time = self.vars.endTime - (time() - elapsed)
        if(self.vars.time < 0)then
           self.vars.time = 0
        end
        self.vars.timeText = (self.vars.time > 60 and math.floor(self.vars.time/60).."m " or "") .. (math.floor(self.vars.time%60)) .. "s"
        
        self.strings.timer:SetText("|cffecce87Server restarting in|r \n"..self.vars.timeText)
    end,
    StartServerCountdown = function(countdownTime)
        
        AIO.Handle("AIO_resourcery", "StartServerCountdown", {
            templates = {"server_restart"},
            vars={
                time=countdownTime,
                endTime=time()+countdownTime
            },
        })
        SendChatMessage(".server restart "..countdownTime ,"SAY")
    end,
    ModelControls=function(s)
        -- On mouse release
        s:SetScript('OnMouseUp', function(self)
            self:SetScript('OnUpdate', nil)
        end)
        -- While holding down mouse buttons.
        s:SetScript('OnMouseDown', function(self, button)
            local StartX, StartY = GetCursorPosition()
    
            local EndX, EndY, Z, X, Y
            if button == 'LeftButton' then
                self:SetScript('OnUpdate', function(self_u)
                    EndX, EndY = GetCursorPosition()
    
                    self_u.rotation = (EndX - StartX) / 34 + self_u:GetFacing()
    
                    self_u:SetFacing(self_u.rotation)
    
                    StartX, StartY = GetCursorPosition()
                end)
            elseif button == 'RightButton' then
                self:SetScript('OnUpdate', function(self_u)
                    EndX, EndY = GetCursorPosition()
    
                    Z, X, Y = self_u:GetPosition(Z, X, Y)
                    X = (EndX - StartX) / 45 + X
                    Y = (EndY - StartY) / 45 + Y
    
                    self_u:SetPosition(Z, X, Y)
                    StartX, StartY = GetCursorPosition()
                end)
            end
        end)

        -- Zoom in/out
        s:SetScript('OnMouseWheel', function(self, spining)
            local Z, X, Y = self:GetPosition()
            local zoom = arg1/4
            Z = Z + zoom
    
            self:SetPosition(Z, X, Y)
        end)

    end,
    FrameCuller=function(f)

        local b_noChildren = false

        if(not(f.vars))then
            f.vars = {}
        end
        if(not(f.vars.children))then
            b_noChildren = true
            f.vars.children = {f:GetChildren()}
        end
        local parentFrame = f:GetParent()
        if(not(parentFrame)) then
            parentFrame = _G[string.gsub(f:GetName(), "_container", "")]
        end
        local parentFrameRect={
            [1]=parentFrame:GetLeft(),
            [2]=parentFrame:GetRight(),
            [3]=parentFrame:GetTop(),
            [4]=parentFrame:GetBottom()
        }
    
        if(f.vars and f.vars.children) then
            for k,v in pairs(f.vars.children) do
                local rect  = {
                    [1]=v:GetLeft()*f:GetScale(),    -- left
                    [2]=v:GetRight()*f:GetScale(),   -- right
                    [3]=v:GetTop()*f:GetScale(),     -- top
                    [4]=v:GetBottom()*f:GetScale()   -- bottom
                }
                if( 
                    rect[2] < parentFrameRect[1] or -- Hide on reaching left
                    rect[1] > parentFrameRect[2] or -- Hide on reaching right
                    rect[4] > parentFrameRect[3] or -- Hide on reaching bottom
                    rect[3] < parentFrameRect[4]    -- Hide on reaching top
                )then   
                    v:Hide()
                else
                    v:Show()
                end
            end
        end

        if(b_noChildren)then
            f.vars.children = nil
        end
    end,
    TransformToParentFrame=function(f, align)

        if(type(align) ~= "string")then
            return
        end

        local currentScale=f:GetScale()
        local framePoint = {f:GetPoint()}
        local frameRect={
            [1]=f:GetLeft()*currentScale,
            [2]=f:GetRight()*currentScale,
            [3]=f:GetTop()*currentScale,
            [4]=f:GetBottom()*currentScale
        }

        local parentFrame=f:GetParent()
        local parentFrameRect={
            [1]=parentFrame:GetLeft(),
            [2]=parentFrame:GetRight(),
            [3]=parentFrame:GetTop(),
            [4]=parentFrame:GetBottom()
        }
        -- Used if aligning left, right, top or bottom
        local difference = {
            [1] = ((parentFrameRect[1] - frameRect[1]) ),
            [2] = ((parentFrameRect[2] - frameRect[2]) ),
            [3] = ((parentFrameRect[3] - frameRect[3]) ),
            [4] = ((parentFrameRect[4] - frameRect[4]) ),
        }

        if(align == "FIT")then
            if ( parentFrame:GetWidth() / f:GetWidth() ) >= ( parentFrame:GetHeight() / f:GetHeight() ) then
                currentScale = (parentFrame:GetWidth() / f:GetWidth())
                f:SetScale(currentScale)
                f:SetPoint(
                    framePoint[1], 
                    0,
                    framePoint[5]
                )
            else
                currentScale = (parentFrame:GetHeight() / f:GetHeight())
                f:SetScale(currentScale)
                f:SetPoint(
                    framePoint[1], 
                    framePoint[4],
                    0
                )
            end
        elseif(align == "LEFT")then
            f:SetPoint(
                framePoint[1], 
                framePoint[4] + (difference[1] / currentScale),
                framePoint[5]
            )  
        elseif(align == "RIGHT")then
            f:SetPoint(
                framePoint[1], 
                framePoint[4] + (difference[2] / currentScale),
                framePoint[5]
            )
        elseif(align == "TOP")then
            f:SetPoint(
                framePoint[1], 
                framePoint[4],
                framePoint[5] + (difference[3] / currentScale)
            )
        elseif(align == "BOTTOM")then
            f:SetPoint(
                framePoint[1], 
                framePoint[4],
                framePoint[5] + (difference[4] / currentScale)
            )
        end

    end,
    -- Sets the position for the thumb of a slider based on value (0 - 1), also moves the scrollframe container
    SetScrollValue=function(f, value, updateSliderOnly)

        local sName = f:GetName()
        local thumb = _G[sName.."_thumb"]
        thumb.center_offset = thumb:GetHeight()/2

        local maxTop = (_G[sName.."_up"]:GetBottom() - thumb.center_offset)
        local maxBottom = (_G[sName.."_down"]:GetTop() + thumb.center_offset)
        f.scrollRange = (maxTop - maxBottom) * (f:GetScale())

        if(value > 1)then
            value = 1
        elseif(value < 0)then
            value = 0
        end
        value = tonumber(tostring(value)) -- Fixes floating-point rounding precision error

        thumb.point = {thumb:GetPoint()}
        thumb:SetPoint(
            thumb.point[1],
            thumb.point[2],
            thumb.point[3],
            thumb.point[4],
            -(f:GetTop() - _G[sName.."_up"]:GetBottom()) - f.scrollRange*value
        )

        local parentFrame = f:GetParent()
        
        -- We have to do an OnUpdate and check if the container frame has been created yet.
        if( not(_G[parentFrame:GetName().."_container"]) )then
            f.time = 0
            f:SetScript("OnUpdate", function(s, e)
                s.time = s.time + e

                local containerFrame = _G[parentFrame:GetName().."_container"]
               
                if(s.time > 2 or containerFrame)then
                    s:SetScript("OnUpdate", nil)
                    if(containerFrame)then
                        resourcery.scripts.SetScrollValue(f, value)
                    end
                end
            end)
        else
            local containerFrame = _G[parentFrame:GetName().."_container"]
            if(containerFrame and (updateSliderOnly == false or not(updateSliderOnly)) )then
                local conPos = {containerFrame:GetPoint()}
                local fromTop = parentFrame:GetTop()*(1/containerFrame:GetScale()) - (containerFrame:GetTop())
                local scrollRangeCon = (parentFrame:GetHeight()*(1/containerFrame:GetScale()) - (containerFrame:GetHeight()))

                containerFrame:SetPoint(
                    conPos[1],
                    conPos[2],
                    conPos[3],
                    conPos[4],
                    conPos[5] + fromTop - (scrollRangeCon * value)
                )
            end

            resourcery.scripts.FrameCuller(containerFrame)
        end
        
        f.vars.value = value

        resourcery.scripts.CheckArrowStatus(f)
    end,
    -- Get the scroll value of the slider, tries to find slider if frame passed was not slider.
    GetScrollValue=function(f)

        if( not(string.sub(f:GetName(), -7) == "_slider") )then
            f = resourcery.scripts.FindSliderFrame(f)
        end

        return (f.vars and f.vars.value) or 0
    end,
    -- Try and find slider frame related to current frame. (WIP)
    FindSliderFrame=function(f)
        -- if we are not trying to get the scroll value on the slider then we try to find the slider
        local parent = f:GetParent()
        -- Check if parent is slider
        if(string.sub(parent:GetName(), -7) == "_slider")then
            f = parent
        else
        -- Check if the slider is a child of the parent
            local parentChildren = {parent:GetChildren()}
            -- If it has no children, check the this parent's parent for slider
            if(parentChildren)then
                for k,frame in pairs(parentChildren)do
                    if(type(frame) == "table" and string.find(frame:GetName(), "_slider"))then
                        f = frame
                    end
                end
            else
                parent = parent:GetParent()
                parentChildren = {parent:GetChildren()}
                if(parentChildren)then
                    for k,frame in pairs(parentChildren)do
                        if(type(frame) == "table" and string.find(frame:GetName(), "_slider"))then
                            f = frame
                        end
                    end
                end
            end
        end

        return f
    end,
    -- Get the percentage position for the mouse click for the slider.
    GetScrollClickValue=function(f)

        local __, mousePosY = GetCursorPosition()
        mousePosY = (mousePosY / f:GetEffectiveScale())

        if(mousePosY > f.maxTop)then
            mousePosY = f.maxTop
        elseif(mousePosY < f.maxBottom)then
            mousePosY = f.maxBottom
        end

        local y = (f.maxTop - mousePosY)
        local currentValue = (y)/f.scrollRange

        return currentValue
    end,
    -- Gets the frame's percentage position from top to bottom (0 - 1).
    GetFrameToSliderValue=function(f)
        if(not(f.scrollRange))then
            local slider = resourcery.scripts.FindSliderFrame(f)
            local sName = slider:GetName()
            local thumb = _G[sName.."_thumb"]
            thumb.center_offset = thumb:GetHeight()/2
    
            local maxTop = (_G[sName.."_up"]:GetBottom() - thumb.center_offset)
            local maxBottom = (_G[sName.."_down"]:GetTop() + thumb.center_offset)
            f.scrollRange = (maxTop - maxBottom) * (f:GetScale())
        end

        local value = (f:GetTop()*f:GetScale() - f:GetParent():GetTop()) / (f:GetHeight()*f:GetScale() - f:GetParent():GetHeight()) 
        f.containerScrollRange = value
        return value
    end,
    -- Used from the scrollframe container frame.
    -- Returns the percentage scroll from top of its parent (scrollframe).
    SetSliderThumbRelatedToContainer=function(f)
        -- TODO: Do we need to get name here???
        local parentFrameName = f:GetParent():GetName()
        if(_G[parentFrameName.."_slider"])then
            local slider = _G[parentFrameName.."_slider"]
            local containerValue = resourcery.scripts.GetFrameToSliderValue(f)
            resourcery.scripts.SetScrollValue(slider, containerValue, true)
        end
    end,
    CheckArrowStatus=function(f)

        local upArrow =  _G[f:GetName().."_up"]
        local downArrow =  _G[f:GetName().."_down"]

        local container = _G[f:GetParent():GetName().."_container"]

        if(container and container:GetParent())then -- We check for parentframe incase we are running conjure again after already being conjured to fix an issue with the parent having being changed because of how blizzard code works.

            local containerTop = tonumber(string.format("%.2f", (container:GetTop()*container:GetScale())))
            local scrollFrameTop = tonumber(string.format("%.2f", (container:GetParent():GetTop())))

            local containerBottom = tonumber(string.format("%.2f", (container:GetBottom()*container:GetScale())))
            local scrollFrameBottom = tonumber(string.format("%.2f", (container:GetParent():GetBottom())))

            if( containerTop == scrollFrameTop and containerBottom == scrollFrameBottom )then
                downArrow:Disable()
                upArrow:Disable()
                return
            end
        end

        if(upArrow and f.vars.value <= 0)then
            upArrow:Disable()
        elseif(upArrow)then
            upArrow:Enable()
        end

        if(downArrow and f.vars.value >= 1)then
            downArrow:Disable()
        elseif(downArrow)then
            downArrow:Enable()
        end
    end,
}