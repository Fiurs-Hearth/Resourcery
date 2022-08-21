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

    local coords = {[1]=x, [2]=y}

    for i, coord in pairs(coords)do

        if(type(coord) == "string")then

            if(coord.find(coord, "$"))then
                -- Select words starting with $
                for match in coord:gmatch("(%$[^%s]+)") do -- (%$%a+)
                    -- replace $match with its size(width or height) depending if you want parent's size or another frame's size
                    coord = coord:gsub( 
                        match, 
                        select( i, ((match == "$parent") and frame:GetParent() or _G[match:gsub("%$", "")]):GetSize() )
                    )
                end
            end
            -- Calculate it
            calcFunc = loadstring("return "..coord)
            coords[i] = calcFunc()

        end

    end

    return coords

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
    if( templateData.templates and templateData.templates[index] and not(frameData.templates[index+1] and type(frameData.templates[index+1]) == "boolean" ) )then
        for i=1, #templateData.templates do
            newData = resourcery.ApplyTemplateSettings(newData, templateData, i)
        end
    end

    return newData
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
        frame:SetParent( (data.parent or (parentData and parentData.name or frame:GetParent()) or "UIParent") )
    end
    -- :SetAlpha()
    if(data.alpha) then
        frame:SetAlpha(data.alpha)
    end
    -- :Hide()
    if(data.hidden)then
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

        frame:SetPoint(
            (data.point['anchor_point'] or data.point[1] or "CENTER"),
            (
                (type(data.point['relative_frame']) == "string" and _G[data.point['relative_frame']]) or data.point['relative_frame']
                or _G[data.point[2]] or data.point[2]
                or frame:GetParent() 
            ),
            (data.point['relative_point'] or data.point[3] or (data.point['anchor_point'] or data.point[1] or "CENTER")),
            (data.point['ofsx'] or data.point[4] or 0), 
            (data.point['ofsy'] or data.point[5] or 0)
        )
    else
        frame:SetPoint("TOPLEFT", 0, 0)
    end
    -- :SetID()
    if(data.id)then
        frame:SetID(data.id)
    end

end

function resourcery.ConstructTypeFrame(frame, data)

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
                                    moveable
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
    if(data.draw_layer and false) then
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
        if(type(data.tex_coord) and #data.tex_coord > 4) then
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
        elseif(type(data.tex_coord)) then
            tex:SetTexCoord(
                (data.tex_coord.left   or data.tex_coord[1] or 0),
                (data.tex_coord.right  or data.tex_coord[2] or 1),
                (data.tex_coord.bottom or data.tex_coord[3] or 0),
                (data.tex_coord.top    or data.tex_coord[4] or 1)
            )
        end
    end
end

function resourcery.ConstructTypeString(str, data)

    --[[
        :SetFont()              font
        :SetNonSpaceWrap()      non_space_wrap
        :SetWordWrap()          word_wrap
        :SetAlphaGradient()     alpha_gradient
        :SetFormattedText()     formatted_text
        :SetMultilineIndent()   multiline_indent
        :SetTextHeight()        text_height
        :SetFontObject()        font_object
        :SetJustifyH()          justify_h
        :SetJustifyV()          justify_v
        :SetShadowColor()       shadow_color
        :SetTextColor()         color
        :SetShadowOffset()      shadow_offset
        :SetSpacing()           spacing
        :SetText()              text
    ]]
    -- :SetFont()
    str:SetFont(
        ( (data.font and data.font["font_file"]) or (data.font and data.font[1]) or "Fonts\\FRIZQT__.TTF"),
        ( (data.font and data.font["size"]) or (data.font and data.font[2]) or 12),
        ( (data.font and data.font['flags']) or (data.font and data.font[3]) or "")
    )
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
    -- :SetFontObject()
    if(data.font_object)then
        str:SetFontObject(data.font_object)
    end
    -- :SetJustifyH()
    if(data.justify_h)then
        str:SetJustifyH(data.justify_h)
    end
    -- :SetJustifyV()
    if(data.justify_v)then
        str:SetJustifyV(data.justify_v)
    end
    -- :SetTextColor()
    if(data.color)then
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
end

function resourcery.ConstructTypeButton()

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
    -- :SetDisabledFontObject()
    if(data.disabled_font) then
        frame:SetDisabledFontObject(_G[data.disabled_font])
    end
    -- :SetDisabledTexture()
    if(data.disabled_texture) then
        frame:SetDisabledTexture(data.disabled_texture)
    end
    -- :SetFontString()
    if(data.font) then
        frame:SetFontString(_G[data.font])
    end
    -- :SetHighlightTexture()
    if(data.highlight_texture) then
        if( type(data.highlight_texture) == "table" and next(data.highlight_texture) )then
            frame:SetHighlightTexture(
                (data.highlight_texture['file'] or data.highlight_texture[1]),
                (data.highlight_texture['mode'] or data.highlight_texture[2])
            )
        else
            frame:SetHighlightTexture(data.highlight_texture)
        end
    end
    -- :SetNormalFontObject()
    if(data.normal_font)then
        frame:SetNormalFontObject(_G[data.normal_font])
    end
    -- :SetNormalTexture()
    if(data.normal_texture)then
        frame:SetNormalTexture((_G[data.normal_texture] or data.normal_texture))
    end
    -- :SetPushedTextOffset()
    if(data.pushed_offset)then
        frame:SetPushedTextOffset(
            (data.pushed_offset['x'] or data.pushed_offset[1] or 0),
            (data.pushed_offset['y'] or data.pushed_offset[2] or 0)
        )
    end
    -- :SetPushedTexture()
    if(data.pushed_texture)then
        frame:SetPushedTexture((_G[data.pushed_texture] or data.pushed_texture))
    end
    -- :SetText()
    if(data.text)then
        frame:SetText(data.text)
    end

end

function resourcery.ConjureFrame(data, parentData)
        
    -- Check if data aleady exists
    local frame
    if(_G[data.name] ) then
        frame = _G[data.name]
    else
        if( not(data.frame_type) ) then
            print("No frame type for: "..(data.name or "Unknown"))
            return
        end

        -- Find $parent and replace it with parent name.
        if(data.name and string.find(data.name, "$parent") and parentData.name)then
            data.name = data.name.gsub(data.name, "$parent", parentData.name)
        end

        frame = CreateFrame(
            data.frame_type, 
            (data.name or nil ), 
            (_G[data.parent] or _G[(parentData and parentData.name)] or UIParent), 
            (data.inherits or nil)
        )
    end

    -- Base main frame
    resourcery.ConstructBase(frame, data, parentData)
    resourcery.ConstructTypeFrame(frame, data)
    if(data.type == "Button") then
        resourcery.ConstructTypeButton(frame, data)
    end
    
    -- Textures
    if( data.textures and next(data.textures) )then
        
        frame.textures = CreateFrame("Frame", data.name.."_Textures", frame)
        frame.textures:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
        frame.textures:SetSize(frame:GetWidth(), frame:GetHeight())
        frame.textures:SetFrameLevel(frame.textures:GetParent():GetFrameLevel())

        for k, textureData in pairs(data.textures)do
            if(textureData.name)then
                frame.textures[k] = frame.textures:CreateTexture(data.name.."_Textures_"..textureData.name)
            else
                frame.textures[k] = frame.textures:CreateTexture(data.name.."_Textures_"..k)
            end
            local tex = frame.textures[k] 
            
            resourcery.ConstructBase(tex, textureData)
            resourcery.ConstructTypeTexture(tex, textureData)

        end
    end

    -- Strings
    if(data.strings and next(data.strings))then

        frame.strings = {}

        for k, strData in pairs(data.strings)do
            if(strData.name)then
                frame.strings[k] = frame:CreateFontString(data.name.."_Strings_"..strData.name)
            else
                frame.strings[k] = frame:CreateFontString(data.name.."_Strings_"..k)
            end
            local string = frame.strings[k] 
            
            resourcery.ConstructBase(string, strData)
            resourcery.ConstructTypeString(string, strData)
        end

    end

    if( data.frames and next(data.frames) )then
        frame.frames = {}
        for k, v in pairs(data.frames)do
            frame.frames[k] = resourcery.ConjureFrame(v, data)
        end
    end

    return frame
end

-- Prepare all frames by applying their template and/or duplicate settings.
function resourcery.PrepareAllFrames()

    for k, data in pairs(resourcery.frames) do

    end

end

-- Prepare a frame and its childrens by applying templates and/or duplicate settings.
function resourcery.PrepareFrame(newData, frameData)

    -- Loop through all templates and apply template settings.
    if(newData.templates and next(newData.templates))then
        for i = 1, #newData.templates do
            if(type(newData.templates[i]) == "string") then
                newData = resourcery.ApplyTemplateSettings(newData, newData, i)
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
                print("In Frame: "..(newData.name or "Unknown").." - Texture disabled: "..(k or "Unknown"))
                newData.textures[k]={}
            elseif(textureData.duplicate) then
                resourcery.ApplyDuplicateSettings(textureData, newData.textures)
            end
        end
    end
 
    -- Loop through all child frames of current frame and apply template settings.
    if(newData.frames and next(newData.frames)) then
        for k, sub_newData in pairs(newData.frames) do
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
    end

    return frame
end

-- TODO: CreateAllFrames function