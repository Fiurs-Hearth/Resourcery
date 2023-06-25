
resourcery.scripts = {
    -- Hide/Show 
    ToggleInitiate=function(self)
        if(not(self.targetFrame)) then
            if(self:GetParent():GetName())then
                self.targetFrame = self:GetParent():GetName()
            end
        end
        self:SetParent(UIParent)
    end,
    ToggleParentFrame = function(self)
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

        if(f == nil) then return end

        local b_noChildren = false

        if(not(f.children))then
            b_noChildren = true
            f.children = {f:GetChildren()}
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

        if(f.children) then
            for k,v in pairs(f.children) do
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
            f.children = nil
        end
    end,
    TransformToParentFrame=function(f, align) -- DEPRECATED

        if(type(align) ~= "string")then
            return
        end

        local currentScale=f:GetScale()
        local framePoint = {f:GetPoint()}
        local frameRect={
            [1]=tonumber(string.format("%.4f", f:GetLeft()*currentScale)),
            [2]=tonumber(string.format("%.4f", f:GetRight()*currentScale)),
            [3]=tonumber(string.format("%.4f", f:GetTop()*currentScale)),
            [4]=tonumber(string.format("%.4f", f:GetBottom()*currentScale)),
        }

        local parentFrame=f:GetParent()
        local parentFrameRect={
            [1]=tonumber(string.format("%.4f", parentFrame:GetLeft())),
            [2]=tonumber(string.format("%.4f", parentFrame:GetRight())),
            [3]=tonumber(string.format("%.4f", parentFrame:GetTop())),
            [4]=tonumber(string.format("%.4f", parentFrame:GetBottom())),
        }
        -- Used if aligning left, right, top or bottom
        local difference = {
            [1] = tonumber(string.format("%.4f", (parentFrameRect[1] - frameRect[1]) )),
            [2] = tonumber(string.format("%.4f", (parentFrameRect[2] - frameRect[2]) )),
            [3] = tonumber(string.format("%.4f", (parentFrameRect[3] - frameRect[3]) )),
            [4] = tonumber(string.format("%.4f", (parentFrameRect[4] - frameRect[4]) )),
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
                    framePoint[2], 
                    framePoint[3], 
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
                framePoint[2],
                framePoint[3],
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
    -- Prepare frames for scrollframe process
    SetScrollData=function(scrollFrame)
        -- Scrollframe
        scrollFrame.name = scrollFrame:GetName()
        scrollFrame.rect = {
            [1]=scrollFrame:GetLeft(),
            [2]=scrollFrame:GetRight(),
            [3]=scrollFrame:GetTop(),
            [4]=scrollFrame:GetBottom()
        }
        scrollFrame.top = scrollFrame:GetTop()
        scrollFrame.left = scrollFrame:GetLeft()
        scrollFrame.scale = scrollFrame:GetScale()
        scrollFrame.height = scrollFrame:GetHeight()
        scrollFrame.width = scrollFrame:GetWidth()

        if(not(scrollFrame.frames.container))then
            print("No container for scrollframe:", (scrollFrame:GetName() or "Unknown frame"))
            return
        end

        -- Container frame
        local container = scrollFrame.frames.container
        container.effective_scale = container:GetEffectiveScale()
        container.scale = scrollFrame.frames.container:GetScale()
        container.height = container:GetHeight()
        container.width = container:GetWidth()

        -- Calculate scroll range
        scrollFrame.scroll_range={
            x = (scrollFrame.width*(1/container.scale) - (container.width)),
            y = (scrollFrame.height*(1/container.scale) - (container.height)),
        }

        -- Slider (optional)
        if(scrollFrame.frames.slider)then
            local slider = scrollFrame.frames.slider
            slider.name = slider:GetName()
            slider.top = slider:GetTop()
            slider.bottom = slider:GetBottom()
    
            -- up button (optional)
            if(slider.frames)then
                if(slider.frames.up)then
                    slider.up = slider.frames.up
                    slider.up.bottom = slider.up:GetBottom()
                end
                -- down button (optional)
                if(slider.frames.down)then
                    slider.down = slider.frames.down
                    slider.down.top = slider.down:GetTop()
                end
            end

            -- thumb texture (optional)
            if(slider.textures.thumb)then
                slider.thumb = slider.textures.thumb
                slider.thumb.center_offset = slider.thumb:GetHeight()/2
            end
            
            -- Set scrollrange for slider if we have up and down arrows
            if(slider.up and slider.down)then
                slider.max_top = (slider.up.bottom - slider.thumb.center_offset + (scrollFrame.vars and scrollFrame.vars.slider_up_offset or 0))
                slider.max_bottom = (slider.down.top + slider.thumb.center_offset - (scrollFrame.vars and scrollFrame.vars.slider_down_offset or 0) + (scrollFrame.vars and scrollFrame.vars.slider_up_offset or 0))
                slider.scroll_range = {
                    y = (slider.max_top - slider.max_bottom) * (scrollFrame.scale)
                } 
            else
            -- Otherwise use entire slider as scrollrange
                slider.max_top = (slider.top - slider.thumb.center_offset) - (scrollFrame.vars and scrollFrame.vars.slider_up_offset or 0)
                slider.max_bottom = (slider.bottom + slider.thumb.center_offset) - (scrollFrame.vars and scrollFrame.vars.slider_down_offset or 0)
                slider.scroll_range = {
                    y = (slider.max_top - slider.max_bottom) * (scrollFrame.scale)
                } 
            end
        end

        if(scrollFrame.frames.slider_horizontal)then
            local slider = scrollFrame.frames.slider_horizontal
            slider.left_p = slider:GetLeft()
            slider.right_p = slider:GetRight()
            slider.width = slider:GetWidth()

            -- left button (optional)
            if(slider.frames)then
                if(slider.frames.left)then
                    slider.left = slider.frames.left
                    slider.left.right = slider.left:GetRight()
                end
                -- right button (optional)
                if(slider.frames.right)then
                    slider.right = slider.frames.right
                    slider.right.left = slider.right:GetLeft()
                end
            end
            -- thumb_horizontal texture (optional)
            if(slider.textures.thumb_horizontal)then
                slider.thumb_horizontal = slider.textures.thumb_horizontal
                slider.thumb_horizontal.center_offset = slider.thumb_horizontal:GetHeight()/2
            end

            -- Set scrollrange for slider if we have left and right arrows
            if(slider.left and slider.right)then
                slider.max_left = (slider.left.right + slider.thumb_horizontal.center_offset + (scrollFrame.vars and scrollFrame.vars.slider_left_offset or 0))
                slider.max_right = (slider.right.left - slider.thumb_horizontal.center_offset + (scrollFrame.vars and scrollFrame.vars.slider_right_offset or 0))
                if(not(slider.scroll_range))then
                    slider.scroll_range = {}
                end
                slider.scroll_range.x = ((slider.max_left - slider.max_right) * (scrollFrame.scale) )*-1
            else
            -- Otherwise use entire slider as scrollrange
                slider.max_left = (slider.left_p + slider.thumb_horizontal.center_offset) + (scrollFrame.vars and scrollFrame.vars.slider_left_offset or 0)
                slider.max_right = (slider.right_p - slider.thumb_horizontal.center_offset) + (scrollFrame.vars and scrollFrame.vars.slider_right_offset or 0)
                if(not(slider.scroll_range))then
                    slider.scroll_range = {}
                end
                slider.scroll_range.x = ((slider.max_left - slider.max_right) * (scrollFrame.scale))*-1
            end
        end

        if(not(scrollFrame.vars) or not(scrollFrame.vars.values))then
            resourcery.scripts.CalculateScrollValues(scrollFrame)
        end
        if(not(scrollFrame.scroll_range))then
            resourcery.scripts.CalculateScrollRange(scrollFrame)
        end

    end,
    --[[ 
        Sets the position for the thumb of a slider based on value (0 - 1),
        also moves the scrollframe container 
    ]]
    SetScrollValue=function(scrollFrame, values, updateSliderOnly)

        if(type(values) == "number") then
            values = {
                y = values,
                x = 0
            }
        elseif(values[1])then
            values.x = (values[1] or 0)
            values.y = (values[2] or 0)
        elseif(values[1] == nil and not(values.x))then
            values.x = 0
            values.y = 0
        end

        local slider, slider_h
        local scrollFrame_width = tonumber(string.format("%.3f", (scrollFrame.width)))
        local scrollFrame_height = tonumber(string.format("%.3f", (scrollFrame.height)))
        local container_width = tonumber(string.format("%.3f", (scrollFrame.frames.container.width*scrollFrame.frames.container.scale)))
        local container_height = tonumber(string.format("%.3f", (scrollFrame.frames.container.height*scrollFrame.frames.container.scale)))

        if( scrollFrame_width ~= container_width and scrollFrame.disabled_x) then
            scrollFrame.disabled_x = false
        end

        if( scrollFrame_height ~= container_height and scrollFrame.disabled_y) then
            scrollFrame.disabled_y = false
        end

        for k,value in pairs(values) do
            if(value > 1)then
                values[k] = 1
            elseif(value < 0)then
                values[k] = 0
            end
            values[k] = tonumber(tostring(values[k])) -- Fixes floating-point rounding precision error
        end

        -- Vertical slider
        if(scrollFrame.frames.slider)then
            slider = scrollFrame.frames.slider
            if(slider.frames)then
                -- up button (optional)
                if(slider.frames.up)then
                    slider.up = slider.frames.up
                end
                -- down button (optional)
                if(slider.frames.down)then
                    slider.down = slider.frames.down
                end
            end

            if( scrollFrame_height == container_height) then
                scrollFrame.disabled_y = true
                values.y = 0
            end

            -- thumb texture (optional)
            if(slider.textures.thumb and (not(slider.up) or slider.up:IsEnabled() == 1 or slider.down:IsEnabled() == 1) and slider.scroll_range) then
                slider.thumb = slider.textures.thumb

                slider.thumb.point = {slider.thumb:GetPoint()}
                slider.thumb:SetPoint(
                    slider.thumb.point[1],
                    slider.thumb.point[2],
                    slider.thumb.point[3],
                    slider.thumb.point[4],
                    -((slider.up and slider.top or 0) - (slider.up and slider.up.bottom or 0)) - (scrollFrame.vars and scrollFrame.vars.slider_up_offset or 0) - slider.scroll_range.y*values.y
                )
            end
        end

        -- Horizontal slider
        if(scrollFrame.frames.slider_horizontal and not(scrollFrame.disabled_x))then
            slider_h = scrollFrame.frames.slider_horizontal
            if(slider_h.frames)then
                -- left button (optional)
                if(slider_h.frames.left)then
                    slider_h.left = slider_h.frames.left
                end
                -- right button (optional)
                if(slider_h.frames.right)then
                    slider_h.right = slider_h.frames.right
                end
            end

            if( scrollFrame_width == container_width) then
                scrollFrame.disabled_x = true
                values.x = 0
            end

            -- thumb texture (optional)
            if(slider_h.textures.thumb_horizontal and (not(slider_h.left) or slider_h.left:IsEnabled() == 1 or slider_h.right:IsEnabled() == 1) and slider_h.scroll_range) then
                slider_h.thumb = slider_h.textures.thumb_horizontal

                slider_h.thumb.point = {slider_h.thumb:GetPoint()}
                slider_h.thumb:SetPoint(
                    slider_h.thumb.point[1],
                    slider_h.thumb.point[2],
                    slider_h.thumb.point[3],
                    (((slider_h.left and slider_h.left.right or 0) - (slider_h.left and slider_h.left_p or 0) ) + (scrollFrame.vars and scrollFrame.vars.slider_left_offset or 0) + slider_h.scroll_range.x*values.x), 
                    slider_h.thumb.point[5]
                )
            end
        end
        -- We have to do an OnUpdate and check if the container frame has been created yet.
        if( not(scrollFrame.container) )then
            scrollFrame.time = 0
            scrollFrame:SetScript("OnUpdate", function(s, elapsed)
                s.time = s.time + elapsed

                s.container = s.frames.container
               
                if(s.time > 2 or s.container)then
                    s:SetScript("OnUpdate", nil)
                    if(s.container)then
                        resourcery.scripts.SetScrollValue(s, values)
                    end
                end
            end)
        else
            if(scrollFrame.container and (updateSliderOnly == false or not(updateSliderOnly)) )then
                local container = scrollFrame.container
                container.point = {container:GetPoint()}
                container.top = container:GetTop()
                container.left = container:GetLeft()

                container.from_top = scrollFrame.top*(1/container.scale) - (container.top)
                container.from_left = scrollFrame.left*(1/container.scale) - (container.left)

                container:SetPoint(
                    container.point[1],
                    container.point[2],
                    container.point[3],
                    (scrollFrame.scroll_range.x == 0 and 0) or (container.point[4] + container.from_left + (scrollFrame.scroll_range.x * values.x)),
                    (scrollFrame.scroll_range.y == 0 and 0) or container.point[5] + container.from_top - (scrollFrame.scroll_range.y * values.y)
                )
            end

        end
        
        scrollFrame.vars.values.x = values.x
        scrollFrame.vars.values.y = values.y

        if(slider and slider.up)then
            resourcery.scripts.CheckArrowStatus(slider)
        end
        if(slider_h and slider_h.left)then
            resourcery.scripts.CheckArrowStatus(slider_h)
        end
        resourcery.scripts.FrameCuller(scrollFrame.container)            

    end,
    -- Get the scroll value of the slider, tries to find slider if frame passed was not slider.
    GetScrollValues=function(scrollFrame, axis)

        if(axis == "x")then
            return (scrollFrame.vars.values.x) or 0
        elseif(axis == "y")then
            return (scrollFrame.vars.values.y) or 0
        else
            local values = {
                x = scrollFrame.vars and scrollFrame.vars.values.x or 0,
                y = scrollFrame.vars and scrollFrame.vars.values.y or 0
            }
            return values
        end

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
    GetScrollClickValue=function(slider)

        local mousePosX, mousePosY = GetCursorPosition()
        if(slider.frames and slider.frames.up or slider.textures.thumb)then
            mousePosY = (mousePosY / slider:GetEffectiveScale())

            if(mousePosY > slider.max_top)then
                mousePosY = slider.max_top
            elseif(mousePosY < slider.max_bottom)then
                mousePosY = slider.max_bottom
            end
    
            local y = (slider.max_top - mousePosY)
            local currentValue = (y)/slider.scroll_range.y

            return currentValue
        elseif(slider.frames and slider.frames.left or slider.textures.thumb_horizontal)then
            mousePosX = (mousePosX / slider:GetEffectiveScale())

            if(mousePosX < slider.max_left)then
                mousePosX = slider.max_left
            elseif(mousePosX > slider.max_right)then
                mousePosX = slider.max_right
            end

            local x = (mousePosX - slider.max_left)
            local currentValue = (x)/slider.scroll_range.x

            return currentValue
        end
    end,
    -- Used from the scrollframe container frame.
    -- Returns the percentage scroll from top of its parent (scrollframe).
    SetSliderThumbRelatedToContainer=function(container)
        local scrollFrame = container:GetParent()
        if(scrollFrame.frames.slider)then
            local slider = scrollFrame.frames.slider
            resourcery.scripts.CalculateScrollRange(scrollFrame, container)
            local values = resourcery.scripts.GetScrollValues(scrollFrame)
            resourcery.scripts.SetScrollValue(scrollFrame, values, true)
        end
    end,
    CheckArrowStatus=function(slider)

        local scrollFrame = slider:GetParent()
        if(not(scrollFrame))then
            return
        end
        local container = scrollFrame.frames.container

        if(container and scrollFrame and slider.frames and slider.frames.up)then -- We check for parentframe incase we are running conjure again after already being conjured to fix an issue with the parent having being changed because of how blizzard code works.

            local containerTop = tonumber(string.format("%.2f", (container:GetTop()*container:GetScale())))
            local scrollFrameTop = tonumber(string.format("%.2f", (scrollFrame:GetTop())))

            local containerBottom = tonumber(string.format("%.2f", (container:GetBottom()*container:GetScale())))
            local scrollFrameBottom = tonumber(string.format("%.2f", (scrollFrame:GetBottom())))

            if( containerTop == scrollFrameTop and containerBottom == scrollFrameBottom )then
                slider.down:Disable()
                slider.up:Disable()
                return
            end
        elseif(container and scrollFrame and slider.frames and slider.frames.left)then
            local containerLeft = tonumber(string.format("%.2f", (container:GetLeft()*container:GetScale())))
            local scrollFrameLeft = tonumber(string.format("%.2f", (scrollFrame:GetLeft())))

            local containerRight = tonumber(string.format("%.2f", (container:GetRight()*container:GetScale())))
            local scrollFrameRight = tonumber(string.format("%.2f", (scrollFrame:GetRight())))

            if( containerLeft == scrollFrameLeft and containerRight == scrollFrameRight )then
                slider.left:Disable()
                slider.right:Disable()
                return
            end
        end

        if(slider.up and scrollFrame.vars.values.y <= 0)then
            slider.up:Disable()
        elseif(slider.up)then
            slider.up:Enable()
        end

        if(slider.down and scrollFrame.vars.values.y >= 1)then
            slider.down:Disable()
        elseif(slider.down)then
            slider.down:Enable()
        end

        if(slider.left and scrollFrame.vars.values.x <= 0)then
            slider.left:Disable()
        elseif(slider.left)then
            slider.left:Enable()
        end

        if(slider.right and scrollFrame.vars.values.x >= 1)then
            slider.right:Disable()
        elseif(slider.right)then
            slider.right:Enable()
        end
    end,
    -- Calculate scroll range for X and Y values
    CalculateScrollRange=function(scrollFrame, container)
        if(not(scrollFrame.frames.container) and container)then
            scrollFrame.frames.container = container
        end
        scrollFrame.scroll_range.x = (scrollFrame:GetWidth()*(1/scrollFrame.frames.container:GetScale()) - (scrollFrame.frames.container:GetWidth()))
        scrollFrame.scroll_range.y = (scrollFrame:GetHeight()*(1/scrollFrame.frames.container:GetScale()) - (scrollFrame.frames.container:GetHeight()))
    end,
    -- Calculates current scroll values
    CalculateScrollValues=function(scrollFrame)

        if(not(scrollFrame.scroll_range))then
            resourcery.scripts.CalculateScrollRange(scrollFrame)
        end

        if(not(scrollFrame.frames.container)) then
            return
        end
        local container = scrollFrame.frames.container
        container.left = container:GetLeft()
        container.top = container:GetTop()

        container.from_top = scrollFrame.top*(1/container.scale) - (container.top)
        container.from_left = scrollFrame.left*(1/container.scale) - (container.left)

        local values = {
            x =  container.from_left / scrollFrame.scroll_range.x*-1,
            y = container.from_top / scrollFrame.scroll_range.y
        }
        if(not(scrollFrame.vars))then
            scrollFrame.vars = {}
        end
        if(not(scrollFrame.vars.values))then
            scrollFrame.vars.values = {}
        end
        scrollFrame.vars.values.x = values.x
        scrollFrame.vars.values.y = values.y
    end
}

-- TODO: Test without thumb, without arrows, vert slider, hori slider, no sliders