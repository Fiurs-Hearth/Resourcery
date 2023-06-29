----------------------------
--       Resourcery       --
--                        --
--  Made for the project  --
--        Avalon          --
--  (Where heroes meet)   --
--    and for all other   --
--      WoW modders!      --
--                        --
--         Author         --
--       Fiur#8658        --
--                        --
--        Name idea       --
--       Zepol#8378       --
--                        --
--          Art           --
--      Alex💩#6969       --
--                        --
--     Special thanks     --
--     ForceMtn#1040      --
--                        --
--########################--

resourcery = {}
resourcery.BLP_BASE_PATH = "Interface\\Resourcery\\BLPs\\"

function resourcery.CopyTable(t)
    local t2 = {};
    for k,v in pairs(t) do
        if type(v) == "table" then
            t2[k] = resourcery.CopyTable(v);
        else
            t2[k] = v;
        end
    end
    return t2;
end

-- Check what kind of data size is and if we should get and return a frame's or several size(s)
function resourcery.ParseSizes(x, y, frame)

    local sizes = {[1]=x, [2]=y}

    for i, size in pairs(sizes)do
        if(type(size) == "string")then

            local parentFrame = frame:GetParent()
            if(not(parentFrame))then
                print("|c00ff0000NO PARENT FRAME SET FOR FRAME:", frame:GetName())
            end
            local parentName  = parentFrame:GetName()
            local calc = ""

            for word in size:gmatch("%S+") do
                if(  word:find("%$") )then
                    word = word:gsub("$parent", parentName)
                    word = word:gsub("%$", "")
                    calc = calc .. select(i, _G[word]:GetSize()) .. " "
                else
                    calc = calc .. word .. " "
                end
             end

            -- Calculate it
            local calcFunc = loadstring("return "..calc)
            sizes[i] = calcFunc()
        end
    end

    return sizes
end

function resourcery.ApplyTableData(newData, frameData)

    for k, v in pairs(frameData) do
        -- If we do not have the key name of k then we add it to our newData
        if(not(newData[k])) then
            newData[k] = v
        else
            if(type(v) == "table" and next(v)) then
                newData[k] = resourcery.ApplyTableData(newData[k], v)
            end
        end
    end

    return newData

end

-- Add data from target table to our table, don't overwrite data if our table has a value there already.
function resourcery.ApplyDuplicateSettings(newData, tableData)
    
    local targetData = tableData[newData.duplicate]

    if(targetData.duplicate) then
        resourcery.ApplyDuplicateSettings(targetData, tableData)
    end
    newData = resourcery.ApplyTableData(newData, targetData)
    return newData
end

-- Apply template settings and overwrite template settings if needed.
function resourcery.ApplyTemplateSettings(newData, frameData, index)

    local templateData = {}
    -- Copy of the the template data
    templateData = resourcery.CopyTable(resourcery.templates[frameData.templates[index]]) -- << doesnt copy a table with only tables?
    resourcery.ApplyTableData(newData, templateData)
    
    -- If template also have templates, apply its settings
    if( templateData.templates and not(frameData.templates[index+1] and type(frameData.templates[index+1]) == "boolean" ) )then
        local templateNr
        for i=1, #templateData.templates do
            templateNr = (#templateData.templates - (i-1))
            newData = resourcery.ApplyTemplateSettings(newData, templateData, templateNr)
        end
    end
    return newData
end

-- Attempt to fix problem caused by what I assume is Blizzard's garbage collecter.
function resourcery.ReApplyParents(frame, data)
    local parentFrame = frame
    local subFrame

    if(data.child_to)then
        parentFrame:GetParent():SetScrollChild(parentFrame)
    end

    if(data.frames)then 
        -- Frames
        for k,d in pairs(data.frames)do
            subFrame = _G[d.name or k]
            if(subFrame)then -- Will be false if there is data but no frame. (Can happen if the data is empty.)

                subFrame:SetParent(
                    (_G[d.parent] or parentFrame or UIParent)       
                )
                -- if(d.frames)then
                resourcery.ReApplyParents(subFrame, d)
                --end
            end
        end
    end
    -- textures
    if(data.textures)then 
        for k,d in pairs(data.textures)do
            subFrame = _G[d.name or k]
            if(subFrame)then -- Will be false if there is data but no frame. (Can happen if the data is empty.)
                subFrame:SetParent(
                    (_G[d.parent] or parentFrame or UIParent)       
                )
            end
        end
    end
    -- Strings
    if(data.strings)then 
        for k,d in pairs(data.strings)do
            subFrame = _G[d.name or k]
            if(subFrame)then -- Will be false if there is data but no frame. (Can happen if the data is empty.)
                subFrame:SetParent(
                    (_G[d.parent] or parentFrame or UIParent)       
                )
            end
        end
    end
    -- TODO: This part moved here until we fix the issue with garbage collection.
    -- Scripts
    if(data.scripts and next(data.scripts))then
        for k,v in pairs(data.scripts) do
            if(k == "events")then
                for kk,vv in pairs(v) do
                    frame:RegisterEvent(vv)
                end
            else
                -- Run function once tied to OnConjure after the frame is created.
                if(k == "OnConjure")then
                    v(frame)
                else
                    frame:SetScript(k, v)
                end
            end
        end
    end
end

-- Apply settings that are in common with most(all?) Frame types
function resourcery.ConstructBase(frame, data, parentData)

    --[[
        :Hide()         hide
        :SetSize()      size
        :SetParent()    parent
        :SetPoint()     point
        :SetAllPoints() set_all_points
        :SetAlpha()     alpha
        :SetID()        id
    ]]
    -- :SetParent()
    if(frame:GetObjectType() == "Texture")then
        if(data.parent)then
            if(data.parent == "$parent" and parentData.name)then
                data.parent = parentData.name
            end
            frame:SetParent(data.parent)
        end
    else    
        if(data.parent == "$parent" and parentData.name)then
            data.parent = parentData.name
        end
        if(frame:GetName() ~= "UIParent")then
            frame:SetParent(_G[data.parent] or _G[(parentData and parentData.name)] or UIParent)
        end
    end
    -- :SetAlpha()
    if(data.alpha) then
        frame:SetAlpha(data.alpha)
    end
    -- :Hide()
    if(data.hidden or data.hide)then
        frame:Hide()
    end
    -- :SetAllPoints()
    if(data.set_all_points) then
        if(data.set_all_points == "")then
            frame:SetAllPoints() -- default to parent frame
        else
            frame:SetAllPoints(data.set_all_points)
        end
    end
    -- :SetSize()
    frame:SetSize((frame:GetWidth() or 0), (frame:GetHeight() or 0)) -- default to 0,0 if no size
    if(data.size and data.size['x'] and data.size['y'] or data.size and data.size[1] and data.size[2]) then
        frame:SetSize(unpack(resourcery.ParseSizes((data.size['x'] or data.size[1]), (data.size['y'] or data.size[2]), frame)))
    end
    -- :SetPoint()
    if(data.point)then
        if(data.point and data.point['clear'] or data.point and data.point[6])then
            frame:ClearAllPoints()
        end
        -- Find $parent and replace it with parent name.
        if( type(data.point['relative_frame']) == "string" and string.find(data.point['relative_frame'], "$parent") )then
            data.point['relative_frame'] = data.point['relative_frame'].gsub(data.point['relative_frame'], "$parent", frame:GetParent():GetName())
        elseif( type(data.point[2]) == "string" and string.find(data.point[2], "$parent")  )then
            data.point[2] = data.point[2].gsub(data.point[2], "$parent", frame:GetParent():GetName())
        end
        frame:SetPoint(
            (data.point['anchor_point'] or data.point[1] or "TOPLEFT"),
            (
                (type(data.point['relative_frame']) == "string" and _G[data.point['relative_frame']]) 
                or data.point['relative_frame']
                or (type(data.point[2]) == "string" and _G[data.point[2]]) 
                or type(data.point[2]) == "table" and data.point[2]
                or frame:GetParent() 
            ),
            (data.point['relative_point'] or (type(data.point[3]) == "string" and data.point[3]) or (data.point['anchor_point'] or data.point[1] or "TOPLEFT")),
            (data.point['x'] or (type(data.point[2]) == "number" and data.point[2]) or data.point[4] or 0),  
            (data.point['y'] or (type(data.point[3]) == "number" and data.point[3]) or data.point[5] or 0)
        )
    else
        if( not(frame:GetPoint()) )then
            frame:SetPoint("TOPLEFT", 0, 0)
        end
    end
    -- :SetID()
    if(data.id)then
        frame:SetID(data.id)
    end
end

function resourcery.ConstructTypeFrame(frame, data, parentData)

    --[[
        :SetFrameStrata()           frame_strata
        :SetFrameLevel()            frame_level
        :IsToplevel()               top_level
        :Raise()                    raise
        :Lower()                    lower
        :SetBackdrop()              backdrop
        :SetBackdropColor()         backdrop_color
        :SetBackdropBorderColor()   backdrop_border_color
        :SetHitRectInsets()         hit_rect
        :EnableMouse()              enable_mouse
        :EnableMouseWheel()         enable_mouse_wheel
        :SetMovable()               movable
                                    moveable
                                    child_to
    ]]

    -- :SetFrameStrata()
    if(data.frame_strata)then
        frame:SetFrameStrata(data.frame_strata)
    end
    -- :SetFrameLevel()
    if(data.frame_level)then
        frame:SetFrameLevel(data.frame_level)
    end
    -- :IsToplevel()
    if(data.top_level)then
        frame:IsToplevel()
    end
    -- :Raise()
    if(data.raise)then
        frame:Raise()
    end
    -- :Lower()
    if(data.lower)then
        frame:Lower()
    end
    -- :SetBackdrop()
    if(data.backdrop and next(data.backdrop))then
        if(data.backdrop.insets or data.backdrop[6])then
             frame:SetBackdrop({
                bgFile    = (data.backdrop.bg_file   or data.backdrop[1] or ""),
                edgeFile  = (data.backdrop.edge_file or data.backdrop[2] or ""),
                edgeSize  = (data.backdrop.edge_size or data.backdrop[3] or 0),
                tile      = (data.backdrop.tile      or data.backdrop[4] or false),
                tile_size = (data.backdrop.tile_size or data.backdrop[5] or 0),
                insets = { 
                    left   = ( (data.backdrop.insets and data.backdrop.insets.left)   or (data.backdrop.insets and data.backdrop.insets[1]) or (data.backdrop[6] and data.backdrop[6][1]) or 0),
                    right  = ( (data.backdrop.insets and data.backdrop.insets.right)  or (data.backdrop.insets and data.backdrop.insets[2]) or (data.backdrop[6] and data.backdrop[6][2]) or 0), 
                    top    = ( (data.backdrop.insets and data.backdrop.insets.top)    or (data.backdrop.insets and data.backdrop.insets[3]) or (data.backdrop[6] and data.backdrop[6][3]) or 0), 
                    bottom = ( (data.backdrop.insets and data.backdrop.insets.bottom) or (data.backdrop.insets and data.backdrop.insets[4]) or (data.backdrop[6] and data.backdrop[6][4]) or 0)
                }
            })
        elseif(type(data.backdrop) == "string") then
            frame:SetBackdrop(data.backdrop)
        else
            frame:SetBackdrop({
                bgFile    = (data.backdrop.bg_file   or data.backdrop[1] or  ""),
                edgeFile  = (data.backdrop.edge_file or data.backdrop[2] or  ""),
                edgeSize  = (data.backdrop.edge_size or data.backdrop[3] or  0),
                tile      = (data.backdrop.tile      or data.backdrop[4] or  false),
                tile_size = (data.backdrop.tile_size or data.backdrop[5] or  0),
            })
        end
    end
    -- :SetBackdropColor()
    if(data.backdrop_color)then
        frame:SetBackdropColor(
            (data.backdrop_color['red']   or data.backdrop_color[1]),
            (data.backdrop_color['green'] or data.backdrop_color[2]),
            (data.backdrop_color['blue']  or data.backdrop_color[3]),
            (data.backdrop_color['alpha'] or data.backdrop_color[4] or 1)
        )
    end
    -- :SetBackdropBorderColor()
    if(data.backdrop_border_color)then
        frame:SetBackdropBorderColor(
            (data.backdrop_border_color['red']   or data.backdrop_border_color[1]),
            (data.backdrop_border_color['green'] or data.backdrop_border_color[2]),
            (data.backdrop_border_color['blue']  or data.backdrop_border_color[3]),
            (data.backdrop_border_color['alpha'] or data.backdrop_border_color[4] or 1)
        )
    end
    -- :SetHitRectInsets()
    if(data.hit_rect)then
        frame:SetHitRectInsets(
            (data.hit_rect["left"]   or data.hit_rect[1]),
            (data.hit_rect["right"]  or data.hit_rect[2]),
            (data.hit_rect["top"]    or data.hit_rect[3]),
            (data.hit_rect["bottom"] or data.hit_rect[4])
        )
    end
    -- :EnableMouse()
    if(data.enable_mouse)then
        frame:EnableMouse(data.enable_mouse)
    end
    -- :EnableMouseWheel()
    if(data.enable_mouse_wheel)then
        frame:EnableMouseWheel(data.enable_mouse_wheel)
    end
    -- :SetMovable()
    if(data.movable)then
        frame:SetMovable(data.movable)
    end
    -- Enable moveable frame
    if(data.moveable or data.clamped)then

        frame:SetMovable(true)
        frame:EnableMouse(true)

        if(type(data.moveable) == "table") then
            frame:RegisterForDrag(unpack(data.moveable))
        else
            frame:RegisterForDrag("LeftButton")
        end

        frame:SetScript("OnDragStart", function(self)
            self:StartMoving()  
        end)
        frame:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
        end)
        if(data.clamped)then
            frame:SetClampedToScreen(true)
            if(type(data.clamped) == "table") then
                frame:SetClampRectInsets(
                    (data.clamped["left"]   or data.clamped[1] or 0),
                    (data.clamped["right"]  or data.clamped[2] or 0),
                    (data.clamped["top"]    or data.clamped[3] or 0),
                    (data.clamped["bottom"] or data.clamped[4] or 0)
                )
            end
        end
    end

    -- child_to
    if(data.child_to)then
        if(data.child_to == "$parent" and parentData.name) then
            data.child_to = _G[parentData.name]
        end
        local parentFrame = ( (type(data.child_to)=="string" and _G[data.child_to]) or data.child_to or (parentData and parentData.name) or frame:GetParent() )
        local framePoint = {frame:GetPoint()}
        parentFrame:SetScrollChild(frame)
        frame:ClearAllPoints()
        frame:SetPoint(
            framePoint[1],
            framePoint[2],
            framePoint[3],
            framePoint[4],
            framePoint[5]
        )
    elseif(parentData and parentData.type == "ScrollFrame" and parentData.name) then
        local framePoint = {frame:GetPoint()}
        _G[parentData.name]:SetScrollChild(frame)
        frame:ClearAllPoints()
        frame:SetPoint(
            framePoint[1],
            framePoint[2],
            framePoint[3],
            framePoint[4],
            framePoint[5]
        )
    end

end

function resourcery.ConstructTypeTexture(tex, data)

    --[[
        :SetTexture()               texture
        :SetVertexColor()           color
        :SetDrawLayer()             draw_layer
        :SetBlendMode()             blend_mode
        :SetDesaturated()           desaturated
        :SetGradient()              gradient
        :SetGradientAlpha()         gradient_alpha
        :SetNonBlocking()           non_blocking
        :SetRotation()              rotation
        :SetTexCoord()              tex_coord
        :SetTexCoordModifiesRect()  tex_coord_modifies_rect
    ]]

    -- :SetTexCoordModifiesRect()
    if(data.tex_coord_modifies_rect)then
        tex:SetTexCoordModifiesRect()
    end
    -- :SetTexture()
    if(type(data.texture) == "string") then
        tex:SetTexture(data.texture)
    elseif(type(data.texture) == "table") then
        tex:SetTexture(
            ( data.texture.red     or data.texture[1] or 1),
            ( data.texture.green   or data.texture[2] or 1),
            ( data.texture.blue    or data.texture[3] or 1),
            ( data.texture.alpha   or data.texture[4] or 1)
        )
    end
    -- :SetVertexColor()
    if( data.color and next(data.color)) then
        tex:SetVertexColor(
            ( data.color.red     or data.color[1] or 1),
            ( data.color.green   or data.color[2] or 1),
            ( data.color.blue    or data.color[3] or 1),
            ( data.color.alpha   or data.color[4] or 1)
        )
    end
    -- :SetDrawLayer()
    if(data.draw_layer) then
        tex:SetDrawLayer(data.draw_layer)
    end
    -- :SetBlendMode()
    if(data.blend_mode)then
        tex:SetBlendMode(data.blend_mode)
    end
    -- :SetDesaturated()
    if(data.desaturated)then
        tex:SetDesaturated(data.desaturated);
    end
    -- :SetGradient()
    if(data.gradient)then
        tex:SetGradient(
            (data.gradient.orientation  or data.gradient[1] or "HORIZONTAL"),
            (data.gradient.start_r      or data.gradient[2] or 1),
            (data.gradient.start_g      or data.gradient[3] or 1),
            (data.gradient.start_b      or data.gradient[4] or 1),
            (data.gradient.end_r        or data.gradient[5] or 1),
            (data.gradient.end_g        or data.gradient[6] or 1),
            (data.gradient.end_b        or data.gradient[7] or 1)
        )
    end
    -- :SetGradientAlpha()
    if(data.gradient_alpha)then
        tex:SetGradientAlpha(
            (data.gradient.orientation  or data.gradient[1] or "HORIZONTAL"),
            (data.gradient.start_r      or data.gradient[2] or 1),
            (data.gradient.start_g      or data.gradient[3] or 1),
            (data.gradient.start_b      or data.gradient[4] or 1),
            (data.gradient.start_alpha  or data.gradient[5] or 1),
            (data.gradient.end_r        or data.gradient[6] or 1),
            (data.gradient.end_g        or data.gradient[7] or 1),
            (data.gradient.end_b        or data.gradient[8] or 1),
            (data.gradient.end_alpha    or data.gradient[9] or 1)
        )
    end
    -- :SetNonBlocking()
    if(data.non_blocking)then
        tex:SetNonBlocking(data.non_blocking)
    end
    -- :SetRotation()
    if(data.rotation)then
        tex:SetRotation(data.rotation)
    end
    -- :SetTexCoord()
    if(data.tex_coord)then
        if(#data.tex_coord > 4) then
            tex:SetTexCoord(
                (data.tex_coord.ULx or data.tex_coord[1] or 0),
                (data.tex_coord.ULy or data.tex_coord[2] or 1),
                (data.tex_coord.LLx or data.tex_coord[3] or 0),
                (data.tex_coord.LLy or data.tex_coord[4] or 1),
                (data.tex_coord.URx or data.tex_coord[5] or 0),
                (data.tex_coord.URy or data.tex_coord[6] or 1),
                (data.tex_coord.LRx or data.tex_coord[7] or 0),
                (data.tex_coord.LRy or data.tex_coord[8] or 1)
            )
        else
            tex:SetTexCoord(
                (data.tex_coord.left   or data.tex_coord[1] or 0),
                (data.tex_coord.right  or data.tex_coord[2] or 1),
                (data.tex_coord.bottom or data.tex_coord[3] or 0),
                (data.tex_coord.top    or data.tex_coord[4] or 1)
            )
        end
    end
end

function resourcery.ConstructTypeString(str, data, parentData, isString)

    --[[
        :SetFont()              font
        :SetFontObject()        font_object
        :SetJustifyH()          justify_h
        :SetJustifyV()          justify_v
        :SetShadowColor()       shadow_color
        :SetShadowOffset()      shadow_offset
        :SetSpacing()           spacing
        :SetTextColor()         color
        :SetText()              text
        
        :SetNonSpaceWrap()      non_space_wrap
        :SetWordWrap()          word_wrap
        :SetAlphaGradient()     alpha_gradient
        :SetFormattedText()     formatted_text
        :SetMultilineIndent()   multiline_indent
        :SetTextHeight()        text_height
    ]]

    -- :SetFont()
    if(data.font)then
        str:SetFont(
            ( (data.font and data.font["font_file"]) or (data.font and data.font[1]) or "Fonts\\FRIZQT__.TTF"),
            ( (data.font and data.font["size"]) or (data.font and data.font["height"]) or (data.font and data.font[2]) or 12),
            ( (data.font and data.font['flags']) or (data.font and data.font[3]) or "")
        )
    end
    -- :SetFontObject()
    if(data.font_object)then
        str:SetFontObject(data.font_object)
    elseif(not(data.font_object) and not(data.font))then
        str:SetFontObject(ChatFontNormal)
    end
    -- :SetJustifyH()
    if(data.justify_h)then
        str:SetJustifyH(data.justify_h)
    else
        str:SetJustifyH("LEFT")
    end
    -- :SetJustifyV()
    if(data.justify_v)then
        str:SetJustifyV(data.justify_v)
    end
    -- :SetTextColor()
    if(data.color or data.text_color)then
        str:SetTextColor(
            ( data.color.red   or data.color[1] or 1),
            ( data.color.green or data.color[2] or 1),
            ( data.color.blue  or data.color[3] or 1),
            ( data.color.alpha or data.color[4] or 1)
        )
    end
    -- :SetShadowColor()
    if(data.shadow_color)then
        str:SetShadowColor(
            ( data.shadow_color.red   or data.shadow_color[1] or 1),
            ( data.shadow_color.green or data.shadow_color[2] or 1),
            ( data.shadow_color.blue  or data.shadow_color[3] or 1),
            ( data.shadow_color.alpha or data.shadow_color[4] or 1)
        )
    end
    -- :SetShadowOffset()
    if(data.shadow_offset)then
        str:SetShadowOffset(
            ( data.shadow_offset['x'] or data.shadow_offset[1] or 0),
            ( data.shadow_offset['y'] or data.shadow_offset[2] or 0)
        )
    end
    -- :SetSpacing()
    if(data.spacing)then
        str:SetSpacing(data.spacing)
    end
    -- :SetText()
    if(data.text)then
        str:SetText(data.text)
    end
    -- Check to only run if object is a string, some objects uses above functions but not the ones below.
    if(isString)then
        -- :SetNonSpaceWrap()
        if(data.non_space_wrap) then
            str:SetNonSpaceWrap()
        end
        -- :SetWordWrap()
        if(data.word_wrap) then
            str:SetWordWrap()
        end
        -- :SetAlphaGradient()
        if(data.alpha_gradient) then
            str:SetAlphaGradient(
                (data.alpha_gradient["start"] or data.alpha_gradient[1] or 0),
                (data.alpha_gradient["length"] or data.alpha_gradient[2] or (string.len(str:GetText()) - 6) (number))
            )
        end
        -- :SetFormattedText()
        if(data.formatted_text) then
            if(#data.formatted_text > 1)then
                str:SetFormattedText(
                    (data.formatted_text["format"] or data.formatted_text[1])
                )
            else
                str:SetFormattedText(
                    ((type(data.formatted_text) == "string" and data.formatted_text) or unpack(data.formatted_text))
                )
            end
        end
        -- :SetMultilineIndent()
        if(data.multiline_indent) then
            str:SetMultilineIndent()
        end
        -- :SetTextHeight()
        if(data.text_height)then
            str:SetTextHeight(data.text_height)
        end
    end

    -- Set size if none were set
    if(data.size == nil) then
        if(parentData ~= nil and parentData.size ~= nil) then
            str:SetSize(unpack(resourcery.ParseSizes((parentData.size['x'] or parentData.size[1]), (parentData.size['y'] or parentData.size[2]), str)))
        else
            str:SetSize(
                (100),
                (100)
            )
        end
    end
end

function resourcery.ConstructTypeButton(frame, data)

    --[[
        :Disable()              disable
        :Enable()               enable
        :LockHighlight()        lock_highlight
        :UnlockHightlight()     unlock_highlight
    ]]

    -- :Disable()
    if(data.disable) then
        frame:Disable()
    end
    -- :Enable()
    if(data.enable) then
        frame:Enable()
    end
    -- :LockHighlight()
    if(data.lock_highlight) then
        frame:LockHighlight()
    end
    -- :UnlockHightlight()
    if(data.unlock_highlight) then
        frame:UnlockHighlight()
    end
    -- :RegisterForClicks()
    if(data.register_for_clicks) then
        frame:RegisterForClicks( 
            (type(data.register_for_clicks)=="string" and data.register_for_clicks) or 
            (type(data.register_for_clicks)=="table"  and unpack(data.register_for_clicks))
        )
    end
    -- :SetButtonState()
    if(data.button_state) then
        frame:SetButtonState(
            (data.button_state['state'] or data.button_state[1] or "NORMAL"),
            (data.button_state['lock']  or data.button_state[2] or false) 
        )
    end
    -- :SetNormalTexture()
    if(data.normal_texture)then
        frame:SetNormalTexture((_G[data.normal_texture] or data.normal_texture))
    end
    -- :SetDisabledFontObject()
    if(data.disabled_font) then
        frame:SetDisabledFontObject(_G[data.disabled_font])
    end
    -- :SetDisabledTexture()
    if(data.disabled_texture or data.normal_texture) then
        frame:SetDisabledTexture(_G[data.disabled_texture] or data.disabled_texture or data.normal_texture)
    end
    -- :SetFontString()
    if(data.font or data.font_string) then
        frame:SetFontString(_G[data.font])
    end
    -- :SetHighlightTexture()
    if(data.highlight_texture or data.normal_texture) then
        if( type(data.highlight_texture) == "table" and next(data.highlight_texture) )then
            frame:SetHighlightTexture(
                (data.highlight_texture['file'] or data.highlight_texture[1] or data.normal_texture),
                (data.highlight_texture['mode'] or data.highlight_texture[2])
            )
        else
            frame:SetHighlightTexture(_G[data.highlight_texture] or data.highlight_texture or data.normal_texture)
        end
    end
    -- :SetNormalFontObject()
    if(data.normal_font)then
        frame:SetNormalFontObject(_G[data.normal_font])
    end
    -- :SetPushedTextOffset()
    if(data.pushed_text_offset)then
        frame:SetPushedTextOffset(
            (data.pushed_text_offset['x'] or data.pushed_text_offset[1] or 0),
            (data.pushed_text_offset['y'] or data.pushed_text_offset[2] or 0)
        )
    end
    -- :SetPushedTexture()
    if(data.pushed_texture or data.normal_texture) then
        frame:SetPushedTexture((_G[data.pushed_texture] or data.pushed_texture or data.normal_texture))
        if(not(data.pushed_texture))then -- Default pushed texture.
            local pushedTexture = frame:GetPushedTexture()
            if(pushedTexture)then
                pushedTexture:SetDesaturated(false)
                pushedTexture:SetVertexColor(0,0,0)
            end
        end
    end
    -- :SetText()
    if(data.text)then
        frame:SetText(data.text)
    end

end

function resourcery.ConstructEditBox(frame, data, parentData)
    
    --[[
        :SetAltArrowKeyMode()       alt_arrow_key_mode
        :SetAutoFocus()             auto_focus
        :SetBlinkSpeed()            blink_speed
        :SetCursorPosition()        cursor_position
        :SetFocus()                 focus
        :SetHistoryLines()          history_lines
        :SetIndentedWordWrap()      indented_word_wrap
        :SetMaxBytes()              max_bytes
        :SetMaxLetters()            max_letters
        :SetMultiLine()             multi_line
        :SetNumber()                number
        :SetNumeric()               numeric
        :SetPassword()              password
        :SetTextInsets()            text_insets
    ]]

    -- :SetAltArrowKeyMode() 
    if(data.alt_arrow_key_mode) then
        frame:SetAltArrowKeyMode(data.alt_arrow_key_mode)
    end
    -- :SetAutoFocus() 
    if(not(data.auto_focus))then
        frame:SetAutoFocus(false) -- default to false so we can press escape with script to remove focus properly.
    else
        frame:SetAutoFocus(data.auto_focus)
    end
    -- :SetBlinkSpeed()
    if(data.blink_speed)then
        frame:SetBlinkSpeed(data.blink_speed)
    end
    -- :SetCursorPosition
    if(data.cursor_position)then
        frame:SetCursorPosition(data.cursor_position)
    end
    -- :SetFocus()
    if(data.focus)then
        frame:SetFocus(data.focus)
    end
    -- :SetHistoryLines()
    if(data.history_lines)then
        frame:SetHistoryLines(data.history_lines)
    end
    -- :SetIndentedWordWrap()
    if(data.indented_word_wrap)then
        frame:SetIndentedWordWrap(data.indented_word_wrap)
    end
    -- :SetMaxBytes()
    if(data.max_bytes)then
        frame:SetMaxBytes(data.max_bytes)
    end
    -- :SetMaxLetters()
    if(data.max_letters)then
        frame:SetMaxLetters(data.max_letters)
    end
    -- :SetMultiLine()
    if(data.multi_line)then
        frame:SetMultiLine(data.multi_line)
    end
    -- :SetNumber()
    if(data.number)then
        frame:SetNumber(data.number)
    end
    -- :SetNumeric()
    if(data.numeric)then
        frame:SetNumeric(data.numeric)
    end
    -- :SetPassword()
    if(data.password)then
        frame:SetPassword(data.password)
    end
    -- :SetTextInsets()
    if(data.text_insets)then
        frame:SetTextInsets(
            (data.text_insets['left']   or data.text_insets[1] or 0),
            (data.text_insets['right']  or data.text_insets[2] or 0),
            (data.text_insets['top']    or data.text_insets[3] or 0),
            (data.text_insets['bottom'] or data.text_insets[4] or 0)
        )
    end
    -- Set black BG if no backdrop was set
    if(data.backdrop == nil and parentData == nil)then
        frame:SetBackdrop({
            bgFile = "Interface/CHARACTERFRAME/UI-Party-Background"
        })
    end

    -- Set size if none were set
    if(data.size == nil) then
        if(parentData ~= nil and parentData.size ~= nil) then
            frame:SetSize(
                (parentData.size.x or parentData.size[1]),
                (parentData.size.y or parentData.size[2])
            )
            data.size={
                x = parentData.size.x,
                y = parentData.size.y
            }
        else
            frame:SetSize(
                (100),
                (30)
            )
            data.size={
                x = 100,
                y = 30
            }
        end
    end

end

function resourcery.ConstructCheckButton(frame, data)
    
    --[[
        :SetChecked()                   checked
        :SetCheckedTexture()            checked_texture
        :SetDisabledCheckedTexture()    disabled_checked_texture
    ]]
    -- :SetChecked()
    if(data.checked)then
        frame:SetChecked(data.checked)
    end
    -- :SetCheckedTexture()
    if(data.checked_texture)then
        frame:SetCheckTexture(
            (_G[data.checked_texture['texture']] or data.checked_texture['texture'] or data.checked_texture[1] or ""),
            (data.checked_texture['filename'] or data.checked_texture[2] or "")
        )
    end
    -- :SetDisabledCheckedTexture()
    if(data.disabled_checked_texture)then
        frame:SetDisabledCheckedTexture(
            (_G[data.disabled_checked_texture['texture']] or data.disabled_checked_texture['texture'] or data.disabled_checked_texture[1] or ""),
            (data.disabled_checked_texture['filename'] or data.disabled_checked_texture[2] or "")
        )
    end

end

function resourcery.ConstructTypeModel(frame, data)

    --[[
        :ClearFog()                 clear_fog
        :ReplaceIconTexture()       replace_icon_texture
        :SetCamera()                camera
        :SetFacing()                facing
        :SetFogColor()              fog_color
        :SetFogFar()                fog_far
        :SetFogNear()               fog_near
        :SetGlow()                  glow
        :SetLight()                 light
        :SetModel()                 model
        :SetModelScale()            model_scale
        :SetPosition()              position
        :SetSequence()              sequence
        :SetSequenceTime()          sequence_time
    ]]

    -- :ClearFog()  
    if(data.clear_fog)then
        frame:ClearFog()
    end
    -- :ReplaceIconTexture()
    if(data.replace_icon_texture)then
        frame:ReplaceIconTexture(data.replace_icon_texture)
    end
    -- :SetCamera()
    if(data.camera)then
        frame:SetCamera(data.camera)
    end
    -- :SetFacing()
    if(data.facing)then
        frame:SetFacing(data.facing)
    end
    -- :SetFogColor()
    if(data.fog_color)then
        frame:SetFogColor(
            (data.fog_color['red']   or data.fog_color[1] or 0),
            (data.fog_color['green'] or data.fog_color[2] or 0),
            (data.fog_color['blue']  or data.fog_color[3] or 0)
        )
    end
    -- :SetFogFar()
    if(data.fog_far)then
        frame:SetFogFar(data.fog_far)
    end
    -- :SetFogNear()
    if(data.fog_near)then
        frame:SetFogFar(data.fog_near)
    end
    -- :SetGlow()
    if(data.glow)then
        frame:SetGlow(data.glow)
    end
    -- :SetLight()
    if(data.light)then
        frame:SetLight(
            (data.light['enabled']       or data.light[1]  or 1),
            (data.light['omni']          or data.light[2]  or 1),
            (data.light['x']             or data.light[3]  or 0),
            (data.light['y']             or data.light[4]  or 0),
            (data.light['z']             or data.light[5]  or 0),
            (data.light['amb_intensity'] or data.light[6]  or 0),
            (data.light['amb_r']         or data.light[7]  or 0),
            (data.light['amb_g']         or data.light[8]  or 0),
            (data.light['amb_b']         or data.light[9]  or 0),
            (data.light['dir_intensity'] or data.light[10] or 0),
            (data.light['dir_r']         or data.light[11] or 0),
            (data.light['dir_g']         or data.light[12] or 0),
            (data.light['dir_b']         or data.light[13] or 0)
        ) 
    end
    -- :SetModel()
    if(data.model)then
        frame:SetModel(data.model)
    end
    -- :SetModelScale()
    if(data.model_scale)then
        frame:SetModelScale(data.model_scale)
    end
    -- :SetPosition
    if(data.position)then
        frame:SetPosition(
            (data.position['x'] or data.position[1] or 0),
            (data.position['y'] or data.position[2] or 0),
            (data.position['z'] or data.position[3] or 0)
        )
    end
    -- :SetSequence()
    if(data.sequence)then
        frame:SetSequence(data.sequence)
    end
    -- :SetSequenceTime()
    if(data.sequence_time)then
        frame:SetSequenceTime(
            (data.sequence_time['sequence'] or data.sequence_time[1] or 0),
            (data.sequence_time['time']     or data.sequence_time[2] or 0)
        )
    end


end

function resourcery.ConstructTypePlayerModel(frame, data)
    --[[
        :SetCreature()      creature
        :SetRotation()      rotation
        :SetUnit()          unit
    ]]

    -- :SetCreature()
    if(data.creature)then
        frame:SetCreature(data.creature)
    end
    -- :SetRotation()
    if(data.rotation)then
        frame:SetRotation(data.rotation)
    end
    -- :SetUnit
    if(data.unit)then
        frame:SetUnit(data.unit)
    end
end

-- Page 1206
function resourcery.ConstructTypeScrollFrame(frame, data)

    --[[
        :SetHorizontalScroll()      horizontal_scroll
        :SetVerticalScroll()        vertical_scroll
        :SetScrollChild()           scroll_child
    ]]

    -- :SetHorizontalScroll()
    if(data.horizontal_scroll)then
        frame:SetHorizontalScroll(data.horizontal_scroll)
    end
    -- :SetVerticalScroll()
    if(data.vertical_scroll)then
        frame:SetVerticalScroll(data.vertical_scroll)
    end
    -- :SetScrollChild()
    if(data.scroll_child)then
        frame:SetScrollChild(data.scroll_child)
    end
end

function resourcery.ConstructTypeSlider(frame, data)

    --[[
        :Disable()              disable
        :Enable()               enable
        :SetMinMaxValues()      min_max_values
        :SetOrientation()       orientation
        :SetThumbTexture()      thumb_texture
        :SetValue()             value
        :SetValueStep()         value_step
    ]]

    -- :Disable()
    if(data.disable)then
        frame:Disable(data.disable)
    end
    -- :Enable() 
    if(data.enable)then
        frame:Enable(data.enable)
    end
    -- :SetMinMaxValues()
    if(data.min_max_values)then
        --[[
        frame:SetMinMaxValues(
            (data.min_max_values['min_value'] or data.min_max_values[1]),
            (data.min_max_values['max_value'] or data.min_max_values[2])
        )
        ]]
        frame:SetMinMaxValues(
            unpack(resourcery.ParseSizes(
                (data.min_max_values['min_value'] or data.min_max_values[1]),
                (data.min_max_values['max_value'] or data.min_max_values[2]),
                frame
            )))
    end
    -- :SetOrientation()
    if(data.orientation)then
        frame:SetOrientation(data.orientation)
    end
    -- :SetThumbTexture()
    if(data.thumb_texture)then
        frame:SetThumbTexture(data.thumb_texture)
    end
    -- :SetValue()
    if(data.value)then
        local tempPoint = {frame:GetPoint()} -- Store points since SetValue sets points to topleft
        frame:SetValue(data.value)
        -- Set point to original position by clearing all points first. (Part of an ugly fix)
        frame:ClearAllPoints()
        frame:SetPoint(
            tempPoint[1],
            tempPoint[2],
            tempPoint[3],
            tempPoint[4],
            tempPoint[5]
        )
    end
    -- :SetValueStep()
    if(data.value_step)then
        frame:SetValueStep(data.value_step)
    end
end

function resourcery.ConjureFrame(data, parentData)
        
    -- Check if data aleady exists
    local frame
        
    -- Find $parent and replace it with parent name.
    if(data.name and string.find(data.name, "$parent") and parentData.name)then
        data.name = data.name.gsub(data.name, "$parent", parentData.name)
    end

    if(_G[data.name] ) then
        frame = _G[data.name]
    else
        if( not(data.type) ) then
            print("No frame type for: "..(data.name or "Unknown"))
            return
        end

        frame = CreateFrame(
            data.type, 
            (data.name or nil ), 
            (_G[data.parent] or _G[(parentData and parentData.name)] or UIParent), 
            (data.inherits or nil)
        )
    end
    -- Add variables to the frame object
    if(data.vars and next(data.vars))then
        frame.vars = {}
        for k,v in pairs(data.vars) do
            frame.vars[k] = v
        end
    end

    resourcery.ConstructBase(frame, data, parentData)
    resourcery.ConstructTypeFrame(frame, data, parentData)
    if(data.type == "Button") then
        resourcery.ConstructTypeButton(frame, data)
    elseif(data.type == "EditBox") then
        resourcery.ConstructEditBox(frame, data, parentData)
        resourcery.ConstructTypeString(frame, data, parentData, false)
    elseif(data.type == "CheckButton")then
        resourcery.ConstructTypeButton(frame, data)
        resourcery.ConstructCheckButton(frame, data)
    elseif(data.type == "Model")then
        resourcery.ConstructTypeModel(frame, data)
    elseif(data.type == "PlayerModel")then
        resourcery.ConstructTypeModel(frame, data)
        resourcery.ConstructTypePlayerModel(frame, data)
    elseif(data.type == "ScrollFrame")then
        resourcery.ConstructTypeScrollFrame(frame, data)
    elseif(data.type == "Slider")then
        resourcery.ConstructTypeSlider(frame, data)
    end
    -- Frames
    if( data.frames and next(data.frames) )then
        if(not(frame.frames))then
            frame.frames = {}
        end
        for k, v in pairs(data.frames)do
            frame.frames[k] = resourcery.ConjureFrame(v, data)
        end
    end
    -- Textures
    if( data.textures and next(data.textures) )then
        
        if(not(frame.textures))then
            frame.textures={}
        end

        for k, textureData in pairs(data.textures)do

            -- Find $parent and replace it with this frame's name since this textures are connected to this frame.
            if(textureData.name and string.find(textureData.name, "$parent") and data.name)then
                textureData.name = textureData.name.gsub(textureData.name, "$parent", data.name)
            end
            
            if(textureData.name and not(_G[textureData.name]))then
                frame.textures[k] = frame:CreateTexture(textureData.name) -- I think this causes it
            elseif( not( _G[data.name.."_"..k]) and not(_G[textureData.name]) )then
                frame.textures[k] = frame:CreateTexture(data.name.."_"..k)
            end
            local tex = frame.textures[k] 
            
            if(not(textureData.parent))then
                textureData.parent = data.name or frame:GetName()
            end


            resourcery.ConstructBase(tex, textureData)
            resourcery.ConstructTypeTexture(tex, textureData)

        end
    end
    -- Strings
    if(data.strings and next(data.strings))then

        if(not(frame.strings))then
            frame.strings = {}
        end

        for k, strData in pairs(data.strings)do

            if( not( _G[data.name.."_"..k] )) then
                if(strData.name and data.name)then
                    strData.name = strData.name.gsub(strData.name, "$parent", data.name)
                else
                    strData.name = data.name.."_"..k
                end
                frame.strings[k] = frame:CreateFontString(strData.name)
            end
            local string = frame.strings[k] 
            
            if(not(strData.parent))then
                strData.parent = data.name or frame:GetName()
            end

            resourcery.ConstructBase(string, strData)
            resourcery.ConstructTypeString(string, strData, data, true)
        end

    end
    -- Scripts
    --[[TODO: MOVED TO REAPPLY PART FOR NOW, FIX LATER
    if(data.scripts and next(data.scripts))then
        for k,v in pairs(data.scripts) do
            if(k == "events")then
                for kk,vv in pairs(v) do
                    frame:RegisterEvent(vv)
                end
            else
                -- Run function once tied to OnConjure after the frame is created.
                if(k == "OnConjure")then
                    v(frame)
                else
                    frame:SetScript(k, v)
                end
            end
        end
    end
    ]]

    return frame
end

-- Create all frames from table.
function resourcery.CreateAllFrames(frames)

    local framesTable = {}
    for k, data in pairs(frames) do
         framesTable[k] = resourcery.StartConjuring(data)
    end
    return framesTable
end

-- Prepare a frame and its childrens by applying templates and/or duplicate settings.
function resourcery.PrepareFrame(newData, frameData)

    -- Loop through all templates and apply template settings.
    if(newData.templates and next(newData.templates))then
        local currentTemplate, templateNr
        for i = 1, #newData.templates do
            templateNr = (#newData.templates - (i-1))
            currentTemplate = newData.templates[templateNr]
            if(type(currentTemplate) == "string") then
                newData = resourcery.ApplyTemplateSettings(newData, newData, templateNr)
            end
        end
    end

    if(newData.disabled) then
        print("Frame disabled: "..(newData.name or "Unknown"))
        return nil
    end
    
    -- Apply duplicate texture settings 
    -- Loop through all textures and apply duplicate settings, if target texture also uses a duplicate then we get the target's target etc.
    if(newData.textures and next(newData.textures)) then
        for k, textureData in pairs(newData.textures)do
            if(textureData.disabled) then
                newData.textures[k]={}
            elseif(textureData.duplicate) then
                resourcery.ApplyDuplicateSettings(textureData, newData.textures)
            end
        end
    end

    -- Apply duplicate string settings 
    if(newData.strings and next(newData.strings)) then
        for k, stringData in pairs(newData.strings) do
            if(stringData.duplicate) then
                resourcery.ApplyDuplicateSettings(stringData, newData.strings)
            end
        end
    end
 
    -- Loop through all child frames of current frame and apply template settings.
    if(newData.frames and next(newData.frames)) then
        for k, sub_newData in pairs(newData.frames) do
            -- I move the ApplyDuplicate to before PrepareFrame to solve the issue with duplicate not working properly for frames (hopefully it fixes it).
            if(sub_newData.duplicate) then
                resourcery.ApplyDuplicateSettings(sub_newData, newData.frames)
            end
            newData.frames[k] = resourcery.PrepareFrame(sub_newData, newData.frames[k])
        end
    end

    return newData
end

function resourcery.StartConjuring(frameData, overwriteData)

    local frame
    local newData = {}
    newData = resourcery.CopyTable(frameData)
    newData = resourcery.PrepareFrame(newData)

    if(newData and not(newData.disabled)) then
        if(overwriteData)then
            newData = resourcery.ApplyTableData(overwriteData, newData)
        end
        frame = resourcery.ConjureFrame(newData)
        -- TODO: Do a proper fix
        -- Attempt to fix problem caused by what I assume is Blizzard's garbage collecter.
        resourcery.ReApplyParents(frame, newData)
    end

    return frame
end
