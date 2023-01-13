
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
    end
}