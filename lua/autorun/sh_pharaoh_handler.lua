PHARAOH_HANDLER = {}

function PHARAOH_HANDLER:PlacedAnkh(ent, placer)
	if CLIENT then return end

	-- set new owner of ankh
	ent:SetOwner(placer)

	-- drawing the decal on the ground
	self:AddDecal(ent, 'rune_pharaoh')

	-- selecting a graverobber, the adversary of the pharaoh
	local p_graverobber = self:SelectGraverobber()

	-- if a valid player is found, he shoudl be converted
	if p_graverobber then
		p_graverobber:SetRole(ROLE_GRAVEROBBER)
	end

	-- setting the graverobber and pharao to this specific ankh
	ent.p_pharaoh = placer
	placer.ankh = ent

	if p_graverobber then
		ent.p_graverobber = p_graverobber
		p_graverobber.ankh = ent
	end
end

function PHARAOH_HANDLER:TransferAnkhOwnership(ent, ply)
	if CLIENT then return end

	if not IsValid(ply) or ply ~= ent.p_pharaoh or ply ~= ent.p_graverobber then return end

	ent:SetOwner(ply)

	-- removing the decal on the ground since it will be replaced
	self:RemoveDecal(ent)

	if ply == ent.p_pharaoh then
		self:AddDecal(ent, 'rune_pharaoh')
	end

	if ply == ent.p_graverobber then
		self:AddDecal(ent, 'rune_graverobber')
	end
end

function PHARAOH_HANDLER:DestroyAnkh(ent, ply)
	if CLIENT then return end

	-- replace decal with inactive decal
	self:RemoveDecal(ent)
	self:AddDecal(ent, 'rune_neutral')

	ent:Remove()
end

function PHARAOH_HANDLER:RemovedAnkh(ent)
	if CLIENT then return end

	-- removing the decal on the ground
	self:RemoveDecal(ent)
end

function PHARAOH_HANDLER:AddDecal(ent, type)
	-- ignore the ankh at all players
	local filter = {ent}
	table.Add(filter, player.GetAll())

	-- store the decal id on this ent for easier removal
	ent.decal_id = 'ankh_decal_' .. tostring(ent:EntIndex())

	util.PaintDownRemovable(ent.decal_id, ent:GetPos() + Vector(0, 0, 20), type, filter)
end

function PHARAOH_HANDLER:RemoveDecal(ent)
	if not ent.decal_id then return end

	util.RemoveDecal(ent.decal_id)

	ent.decal_id = nil
end

---
-- Returns a player that can be converted to a graverobber
-- Vanilla T players are preferred, other team traitor players are used as
-- a fallback
function PHARAOH_HANDLER:SelectGraverobber()
	local p_vanilla_traitor = {}
	local p_team_traitor = {}

	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if ply:GetSubRole() == ROLE_TRAITOR then
			p_vanilla_traitor[#p_vanilla_traitor + 1] = ply
		end

		if ply:GetTeam() == TEAM_TRAITOR then
			p_team_traitor[#p_team_traitor + 1] = ply
		end
	end

	if #p_vanilla_traitor > 0 then
		return p_vanilla_traitor[math.random(1, #p_vanilla_traitor)]
	end

	if #p_team_traitor > 0 then
		return p_team_traitor[math.random(1, #p_team_traitor)]
	end
end

---
-- using TTT2PostPlayerDeath hook here, since it is called at the very last, addons like
-- a second change are triggered prior to this hook
hook.Add('TTT2PostPlayerDeath', 'ttt2_role_pharaoh_death', function(victim, inflictor, attacker)
	if GetRoundState() ~= ROUND_ACTIVE then return end

	-- victim must be either a pharaoh or graverobber with an ankh
	if not IsValid(victim) or not victim.ankh then return end

	-- the victim must be the current owner of the ankh
	if victim ~= victim.ankh:GetOwner() then return end

	victim:Revive(10, function(ply)
		-- destroying the ankh on revival
		--PHARAOH_HANDLER:DestroyAnkh(ply.ankh, ply)
	end,
	function(ply)
		-- make sure the revival is still valid
		return GetRoundState() == ROUND_ACTIVE and IsValid(ply) and ply.ankh and ply == ply.ankh:GetOwner()
	end,
	false, true, -- there need to be your corpse and you don't prevent win
	function(ply)
		-- onn fail todo
	end)
end)
