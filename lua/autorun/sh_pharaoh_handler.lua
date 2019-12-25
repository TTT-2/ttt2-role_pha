if SERVER then
	util.AddNetworkString('ttt2_net_pharaoh_spawn_effects')
end

PHARAOH_HANDLER = {}

function PHARAOH_HANDLER:PlacedAnkh(ent, placer)
	if CLIENT then return end

	-- drawing the decal on the ground
	self:AddDecal(ent, 'rune_pharaoh')

	-- selecting a graverobber, the adversary of the pharaoh
	local p_graverobber = self:SelectGraverobber()

	-- if a valid player is found, he shoudl be converted
	if p_graverobber then
		p_graverobber:SetRole(ROLE_GRAVEROBBER)
	end

	-- setting the graverobber and pharao to this specific ankh
	ent:SetNWEntity('pharaoh', placer)
	ent:SetNWEntity('graverobber', p_graverobber)

	-- set new owner of ankh
	ent:SetOwner(placer)
	ent:SetAdversary(p_graverobber)

	-- store ankh information to the players as well
	placer.ankh = ent
	if p_graverobber then
		p_graverobber.ankh = ent
	end
end

function PHARAOH_HANDLER:TransferAnkhOwnership(ent, ply)
	if CLIENT then return end

	if not IsValid(ply) then return end

	ent:SetAdversary(ent:GetOwner())
	ent:SetOwner(ply)

	-- removing the decal on the ground since it will be replaced
	self:RemoveDecal(ent)

	if ply == ent:GetNWEntity('pharaoh') then
		self:AddDecal(ent, 'rune_pharaoh')
	end

	if ply == ent:GetNWEntity('graverobber') then
		self:AddDecal(ent, 'rune_graverobber')
	end
end

function PHARAOH_HANDLER:DestroyAnkh(ent, ply)
	if CLIENT then return end

	self:RemovedAnkh(ent)
	self:AddDecal(ent, 'rune_neutral')

	ent:Remove()
end

function PHARAOH_HANDLER:RemovedAnkh(ent)
	if CLIENT then return end

	-- replace decal with inactive decal
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

function PHARAOH_HANDLER:SpawnEffects(pos)
	if CLIENT then return end

	net.Start('ttt2_net_pharaoh_spawn_effects')
	net.WriteVector(pos)
	net.Broadcast()
end

if CLIENT then
	local zapsound = Sound('npc/assassin/ball_zap1.wav')

	local smokeparticles = {
		Model('particle/particle_smokegrenade'),
		Model('particle/particle_noisesphere')
	}

	net.Receive('ttt2_net_pharaoh_spawn_effects', function()
		local pos = net.ReadVector()

		-- spawn sound effect and destroy particless
		local effect = EffectData()
		effect:SetOrigin(pos)
		util.Effect('cball_explode', effect)

		sound.Play(zapsound, pos)

		-- smoke spawn code by Alf21
		local em = ParticleEmitter(pos)
		local r = 1.5 * 64

		for i = 1, 75 do
			local prpos = VectorRand() * r
			prpos.z = prpos.z + 332
			prpos.z = math.min(prpos.z, 52)

			local p = em:Add(table.Random(smokeparticles), pos + prpos)
			if p then
				local gray = math.random(125, 255)
				p:SetColor(gray, gray, gray)
				p:SetStartAlpha(200)
				p:SetEndAlpha(0)
				p:SetVelocity(VectorRand() * math.Rand(900, 1300))
				p:SetLifeTime(0)

				p:SetDieTime(10)

				p:SetStartSize(math.random(140, 150))
				p:SetEndSize(math.random(1, 40))
				p:SetRoll(math.random(-180, 180))
				p:SetRollDelta(math.Rand(-0.1, 0.1))
				p:SetAirResistance(600)

				p:SetCollide(true)
				p:SetBounce(0.4)

				p:SetLighting(false)
			end
		end

		em:Finish()
	end)
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
-- a second change are triggered prior to this hook (SERVER ONLY)
hook.Add('TTT2PostPlayerDeath', 'ttt2_role_pharaoh_death', function(victim, inflictor, attacker)
	if GetRoundState() ~= ROUND_ACTIVE then return end

	-- victim must be either a pharaoh or graverobber with an ankh
	if not IsValid(victim) or not victim.ankh then return end

	-- the victim must be the current owner of the ankh
	if victim ~= victim.ankh:GetOwner() then return end

	victim:Revive(10, function(ply)
		local ankh_pos = ply.ankh:GetPos() + Vector(0, 0, 2.5)

		-- destroying the ankh on revival
		PHARAOH_HANDLER:DestroyAnkh(ply.ankh, ply)

		-- porting the player to the ankh
		ply:SetPos(ankh_pos)

		-- et player HP to 50
		ply:SetHealth(50)

		-- spawn smoke
		PHARAOH_HANDLER:SpawnEffects(ankh_pos)
	end,
	function(ply)
		-- make sure the revival is still valid
		return GetRoundState() == ROUND_ACTIVE and IsValid(ply) and ply.ankh and ply == ply.ankh:GetOwner()
	end,
	false, -- no corpse needed for respawn
	true, -- force revival
	function(ply)
		-- on fail todo
	end)
end)
