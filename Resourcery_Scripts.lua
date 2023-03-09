
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
            print("not")
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

    end
}