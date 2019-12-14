if SERVER then return end

gsdraw = gsdraw or {}

gsdraw.func = gsdraw.func or {}

gsdraw.func.SetupSafeScroll = function(menu)
    local safe_scroll = vgui.Create( "DScrollPanel", menu )
    safe_scroll:Dock( FILL )
    safe_scroll:GSDrawScrollBar(Color(36,36,36), Color(46,46,46), 8)
    return safe_scroll
end

gsdraw.func.SimpleAsk = function(menu,title,def_text, func, close)
    menu:SetVisible(false)
    local ask_main = vgui.Create("DFrame")
    ask_main:SetSize(ScrW()*0.3, ScrH()*0.16)
    ask_main:SetTitle(title)
    ask_main:Center()
    ask_main:SetDraggable(false)
    ask_main:MakePopup()
    ask_main:MenuPaint(Color(46,46,46), 5)

    local safe_scroll = gsdraw.func.SetupSafeScroll(ask_main)
    safe_scroll:Dock(FILL)

    local text_ent = safe_scroll:Add( "DTextEntry") 
    text_ent:Dock(TOP)
    text_ent:SetSize(ask_main:GetWide(), ask_main:GetTall()*0.2)
    text_ent:SetPlaceholderText(def_text)

    local accept = safe_scroll:Add("DButton")
	accept:SetText( "" )					
    accept:Dock(TOP)
    accept:DockMargin(20,25,20,5)
    accept:SetSize(ScrW()*0.3, ScrH()*0.05)
    accept:SetEnabled(true)
    accept:DrawTextPanel(Color(36,36,36), 8, Color(225,225,225), "Подтвердить", "town_budget_small" )
    accept.DoClick = function()
        ask_main:Close()
        func(text_ent:GetValue())
        if close then
            menu:Close()
        end
    end

    menu.OnClose = function()
        if ask_main:IsValid() then
            ask_main:Close()
        end
    end
    ask_main.OnClose = function()
        menu:SetVisible(true)
    end
end

gsdraw.func.DrawBlur = function(panel, amount, color)

    if color == nil then
        color = Color(0,0,0,0)
    end

    local blur = Material("pp/blurscreen")

    local bg = vgui.Create("DPanel")
    bg:SetSize(ScrW(), ScrH())
    bg:SetPos(0,0)

    function bg:Paint( w, h )
        draw.RoundedBox( 8, 0, 0, w, h, color )
        local x, y = bg:LocalToScreen(0, 0)
        local scrW, scrH = ScrW(), ScrH()
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)
        for i = 1, 3 do
            blur:SetFloat("$blur", (i / 3) * (amount or 6))
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
        end
    end

    panel.OnClose = function()
        bg:Remove()
    end

    panel.OnRemove = function()
        bg:Remove()
    end

    return bg

end

gsdraw.func.DrawNotify = function(text, color, pos, bgColor)
    --LocalPlayer().GSNotifies = LocalPlayer().GSNotifies or {}
    local t_l = utf8.len(text)
    if LocalPlayer().GSNotify != nil then
        LocalPlayer().GSNotify:Remove()
    end
    local notify = vgui.Create( "DNotify" )
    LocalPlayer().GSNotify = notify
    notify.OnRemove = function()
        if LocalPlayer().GSNotify == notify then
            LocalPlayer.GSNotify = nil 
        end
    end
    -- notify.Think = function()
    --     if !table.HasValue(LocalPlayer().GSNotifies, notify) then
    --         notify:Remove()
    --     end
    -- end

    -- table.insert(LocalPlayer().GSNotifies, notify)

    -- timer.Simple(2, function()
    --     if notify:IsValid() then
    --         table.RemoveByValue(LocalPlayer().GSNotifies, notify)
    --     end
    -- end)

    local background = vgui.Create("DPanel", notify)
    background:GSMenuPaint(bgColor, 1)

    local notify_lbl = vgui.Create( "DLabel", background )
    notify_lbl:SetText( text )
    notify_lbl:SetFont( "GModNotify" )
    notify_lbl:SizeToContents()
    notify_lbl:SetColor(color)

    background:SetSize( notify_lbl:GetWide()+ScrW()*0.05, notify_lbl:GetTall()+ScrH()*0.03 )
    notify:SetSize( background:GetWide(), background:GetTall() )
    notify_lbl:Center()
    notify:Center()

    local def_x, def_y = notify:GetPos()
    local n_w, n_h = notify:GetSize()

    if pos == 5 then
        notify:SetPos(def_x, def_y)
    elseif pos == 2 then
        notify:SetPos(def_x, def_y-ScrH()*0.4)
    elseif pos == 8 then
        notify:SetPos(def_x, def_y+ScrH()*0.4)
    elseif pos == 1 then
        notify:SetPos(ScrW()*0.02, def_y-ScrH()*0.4)
    elseif pos == 3 then
        notify:SetPos(ScrW() - (n_w+ScrW()*0.02), def_y-ScrH()*0.4)
    elseif pos == 7 then
        notify:SetPos(ScrW()*0.02, def_y+ScrH()*0.4)
    elseif pos == 9 then
        notify:SetPos(ScrW() - (n_w+ScrW()*0.02), def_y+ScrH()*0.4)
    elseif pos == 4 then
        notify:SetPos(ScrW()*0.02, def_y)
    elseif pos == 6 then
        notify:SetPos(ScrW() - (n_w+ScrW()*0.02), def_y)
    end

    -- local upper = { 7, 8, 9 }
    -- local down = { 1, 2, 3, 4, 5, 6 }
    -- local notify_x, notify_y = notify:GetPos()
    -- for k, v in pairs(LocalPlayer().GSNotifies) do
    --     if table.Count(LocalPlayer().GSNotifies) == 1 then break end
    --     local last_notify = LocalPlayer().GSNotifies[table.Count(LocalPlayer().GSNotifies)-1]
    --     local lst_nt_x, lst_nt_y = last_notify:GetPos()
    --     if table.HasValue(upper, pos) then
    --         notify:MoveTo(notify_x, lst_nt_y-ScrH()*0.05, 0.5, 0)
    --     elseif table.HasValue(down, pos) then
    --         notify:MoveTo(notify_x, lst_nt_y+ScrH()*0.05, 0.5, 0)
    --     end
    -- end

    notify:AddItem( background )
end

-- FUNCTION (Player notify)
net.Receive("gsdraw_player_notify", function(len, ply) 

    local text = net.ReadString()
    local colors = net.ReadTable()
    local pos = net.ReadInt(5)

    gsdraw.func.DrawNotify( text, colors.text_color, pos, colors.background_color )

end)