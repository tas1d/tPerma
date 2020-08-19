tperma = tperma or {}

local main_folder = "tperma"

if SERVER then
    AddCSLuaFile(main_folder.."/config.lua")
end
include(main_folder.."/config.lua")

for _, F in SortedPairs(file.Find(main_folder .. "/sh_*.lua", "LUA"), true) do
    if SERVER then
        AddCSLuaFile(main_folder .. "/" .. F)
    end

    include(main_folder .. "/" .. F)
end

if SERVER then
    for _, F in SortedPairs(file.Find(main_folder .. "/sv_*.lua", "LUA"), true) do
        include(main_folder .. "/" .. F)
    end
end

for _, F in SortedPairs(file.Find(main_folder .. "/cl_*.lua", "LUA"), true) do
    if SERVER then
        AddCSLuaFile(main_folder .. "/" .. F)
    else
        include(main_folder .. "/" .. F)
    end
end
