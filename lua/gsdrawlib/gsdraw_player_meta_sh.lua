if SERVER then
    util.AddNetworkString("gsdraw_player_notify")
end

local PLAYER = FindMetaTable("Player")

function PLAYER:GSDRAW_Notify(message, color, pos, bgColor)
    if message == nil or not message or color == nil or not color or pos == nil or not pos then return end
    local msg = tostring(message)
    if SERVER then
        net.Start("gsdraw_player_notify")
        net.WriteString(msg)
        net.WriteTable( { text_color = color, background_color = bgColor } )
        net.WriteInt(pos, 5)
        net.Send(self)
    else
        gsdraw.func.DrawNotify(message, color, pos, bgColor)
    end
end