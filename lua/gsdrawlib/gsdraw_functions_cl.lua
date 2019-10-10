if SERVER then return end

gsdraw = {}

gsdraw.func = {}

gsdraw.func.SetupSafeScroll = function(menu)
    local safe_scroll = vgui.Create( "DScrollPanel", menu )
    safe_scroll:Dock( FILL )
    safe_scroll:DrawScrollBar(Color(36,36,36), Color(46,46,46), 8)
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

gsdraw.func.DrawBlur = function(panel, amount)

    local blur = Material("pp/blurscreen")

    local bg = vgui.Create("DPanel")
    bg:SetSize(ScrW(), ScrH())
    bg:SetPos(0,0)

    function bg:Paint( w, h )
        draw.RoundedBox( 8, 0, 0, w, h, Color( 36, 36, 36, 200 ) )
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

end