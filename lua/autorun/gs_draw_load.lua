local version = "0.3b"

local function LoadFiles()
    if SERVER then
        AddCSLuaFile("gsdrawlib/gsdraw_meta_cl.lua")
        AddCSLuaFile("gsdrawlib/gsdraw_functions_cl.lua")
    else
        include("gsdrawlib/gsdraw_meta_cl.lua")
        include("gsdrawlib/gsdraw_functions_cl.lua")
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
    LoadFiles()
    PrintInfo()
end)