local version = "0.4b"

local function LoadGSDraw()
    local files, dirs = file.Find("gsdrawlib/*", "LUA")
    for _, v in pairs(files) do  
        if string.find(v, "_sh") then
            if SERVER then
                include("gsdrawlib/"..v)
                AddCSLuaFile("gsdrawlib/"..v)
            else
                include("gsdrawlib/"..v)
            end
        elseif string.find(v, "_sv") then
            include("gsdrawlib/"..v)
        elseif string.find(v, "_cl") then
            if SERVER then
                AddCSLuaFile("gsdrawlib/"..v)
            else
                include("gsdrawlib/"..v)
            end
        end
    end
end

local function PrintInfo()
    if SERVER then
        MsgC(Color(0, 194, 103),"/#/------------------------------------------------")
        MsgC(Color(0, 194, 103),"\n".."/#/ gsdraw was fully loaded")
        MsgC(Color(0, 194, 103),"\n".."/#/ Version "..version)
        MsgC(Color(0, 194, 103),"\n".."/#/ Author: TeraByte")
        MsgC(Color(0, 194, 103),"\n".."/#/------------------------------------------------".."\n")
    end
end

hook.Add("Initialize", "gsdraw_init", function()
    LoadGSDraw()
    PrintInfo()
end)