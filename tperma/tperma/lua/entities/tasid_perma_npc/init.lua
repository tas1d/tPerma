AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/humans/group01/male_04.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE + CAP_TURN_HEAD)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()

	self:SetMaxYawSpeed(90)
end

function ENT:AcceptInput(name, activator, ply, data)
	if name != "Use" and !IsValid(ply) and !ply:IsPlayer() then return end

	net.Start("tperma_openmenu")
		net.WriteEntity(self)
		net.WriteTable(tperma.playerpurchases[ply:SteamID64()] or {})
	net.Send(ply)
end
