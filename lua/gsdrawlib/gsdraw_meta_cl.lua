local panel = FindMetaTable("Panel")
-- FUNCTION (Easy menu paint)
function panel:GSMenuPaint(color, soft)
	self.PaintedColor = color
	self.PaintedSoft = soft
    function self:Paint(w,h)
        draw.RoundedBox(soft, 0, 0, w, h, color)
    end
end
-- FUNCTION (Make panel invisible)
function panel:GSMakeInvisible(bool)
	if bool then
	    function self:Paint(w,h)
	    end
	else
		function self:Paint(w,h)
	        draw.RoundedBox(self.PaintedSoft, 0, 0, w, h, self.PaintedColor)
	    end
	end
end
-- FUNCTION (Close menu when player die)
function panel:GSSUDeath()
    function self:Think()
        if self:IsValid() and ( !LocalPlayer():Alive() or ( LocalPlayer().BLBO_Stats != nil and !LocalPlayer().BLBO_Stats.cons ) ) then
            if self:GetClassName() == "DFrame" then
                self:Close()
            else
                self:Remove()
            end
        end
    end
end
-- FUNCTION (Make scrollbar invisible)
function panel:GSSetupInvisibleScroll()
    local bar_mod_2 = self:GetVBar()
    bar_mod_2:SetSize(0,0)
end
-- FUNCTION (Draw text panel)
function panel:GSDrawTextPanel(m_color, soft, t_color, text, font, alig)
    function self:Paint(w,h)
        draw.RoundedBox(soft, 0,0,w, h, m_color)
    end

    if alig == nil then
        alig = 5
    end

	self.TextPanelColor = m_color
	self.TextPanelSoft = soft

    local title = vgui.Create( "DLabel", self )
    title:SetText( text )
    title:SetTextColor(t_color)
    title:SetFont(font)
    title:SizeToContents()
    title.IsTextPanel = true
    title.Think = function()
        title:SizeToContents()
        title:SetSize(self:GetWide(),self:GetTall())
        title:SetContentAlignment(alig)
    end
end
-- FUNCTION (Get text from text panel)
function panel:GSGetTextPanelText()
    for _,v in pairs(self:GetChildren()) do
        if v.IsTextPanel then
            return v
        end
    end
end
-- FUNCTION (Draw scrollbar)
function panel:GSDrawScrollBar(m_color, g_color, m_soft, btn_up, btn_down)
    local def_btn_u = Color(200, 100, 0, 0)
    local def_btn_d = Color(200, 100, 0, 0)

    if btn_up != nil then
        def_btn_u = btn_up
    elseif btn_down != nil then
        def_btn_d = btn_down
    end

    local d_scroll = self:GetVBar()

    function d_scroll:Paint( w, h )
        draw.RoundedBox( 0, ScrW() * 0.005, 0, ScrW() * 0.005, h, m_color )
    end

    function d_scroll.btnUp:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, def_btn_u )
    end

    function d_scroll.btnDown:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, def_btn_d )
    end

    function d_scroll.btnGrip:Paint( w, h )
        draw.RoundedBox( m_soft, ScrW() * 0.005, 0, ScrW() * 0.005, h, g_color )
    end
end
-- FUNCTION (Setup autocontents)
function panel:GSAutoContents()
    local text_pnl = self:GSGetTextPanelText()
    if text_pnl != nil then
        self.Think = function()
            self:SetSize(self:GetWide(), text_pnl:GetTall())
        end
    end
end
-- FUNCTION (Make centered image)
function panel:GSMakeNiceImage(path, padding)
    local niceImage = vgui.Create("DImage", self)
    niceImage:SetImage(path)
    niceImage:Dock(FILL)

    self:DockPadding(padding[1], padding[2], padding[3], padding[4])
end
-- FUNCTION (Make panel hover)
function panel:GSMakeHover(m_color, text_color, text, alig, x, y, font, smooth)
  local text_panel = self:GSGetTextPanelText()
  if not x or not y then
    x, y = text_panel:GetPos()
  end
  self:GSMenuPaint(m_color, smooth)
  text_panel:SetText(text)
  text_panel:SetTextColor(text_color)
  text_panel:SetFont(font)
  text_panel:SetPos(x, y)
  text_panel.Think = function()
      text_panel:SizeToContents()
      text_panel:SetSize(self:GetWide(),self:GetTall())
      text_panel:SetContentAlignment(alig)
  end
end
-- FUNCTION (Make true sound)
function panel:GSSetupHoverSound(sound)
  self.OnCursorEntered = function()
    LocalPlayer():EmitSound(sound)
  end
end
