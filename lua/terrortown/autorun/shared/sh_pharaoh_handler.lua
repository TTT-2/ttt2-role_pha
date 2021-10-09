if SERVER then
	util.AddNetworkString("ttt2_net_pharaoh_spawn_effects")
	util.AddNetworkString("ttt2_net_pharaoh_wallack")
	util.AddNetworkString("ttt2_net_pharaoh_start_sound")
	util.AddNetworkString("ttt2_net_pharaoh_show_popup")
	util.AddNetworkString("ttt2_net_pharaoh_can_conv")
end

PHARAOH_HANDLER = {}

local zapsound = Sound("npc/assassin/ball_zap1.wav")

if SERVER then
	PHARAOH_HANDLER.ankhs = {}

	function PHARAOH_HANDLER:GetOwnedAnkhDataId(ply)
		-- "owner" is a concept that refers to up to two players: the pharaoh who placed the ankh and the graverobber who stole it
		local ply_id = ply:SteamID64()
		if self.ankhs[ply_id] then
			-- the player owns an ankh that they received upon becoming a pharaoh
			-- it may or may not have been stolen by a graverobber
			-- it may or may not be in their inventory or a graverobber's inventory
			return ply_id
		end

		for original_owner_id, ankh_data in pairs(self.ankhs) do
			if ankh_data.current_owner_id == ply_id then
				-- there is an ankh in this world that the player placed down which is currently under their ownership
				-- they may have stolen it from a pharaoh
				-- it may be in their inventory
				return original_owner_id
			end
		end

		return nil
	end

	function PHARAOH_HANDLER:PlayerIsOriginalOwnerOfAnAnkh(ply)
		if self.ankhs[ply:SteamID64()] then
			return true
		end

		return false
	end

	function PHARAOH_HANDLER:PlayerOwnsAnAnkh(ply)
		-- operates under a "dual ownership" philosophy (i.e. a thief and the player they stole the thing from)
		if self:GetOwnedAnkhDataId(ply) then
			return true
		end

		return false
	end

	function PHARAOH_HANDLER:PlayerControlsAnAnkh(ply)
		local original_owner_id = self:GetOwnedAnkhDataId(ply)
		if original_owner_id and self.ankhs[original_owner_id].current_owner_id == ply:SteamID64() then
			return true
		end

		return false
	end

	function PHARAOH_HANDLER:PlayerIsOriginalOwnerOfThisAnkh(ply, ent)
		local original_owner_id = self:GetOwnedAnkhDataId(ply)

		if original_owner_id and original_owner_id == ply:SteamID64() and self.ankhs[original_owner_id].ankh == ent then
			return true
		end

		return false
	end

	function PHARAOH_HANDLER:PlayerOwnsAnAnkhOutsideOfLoadout(ply)
		local original_owner_id = self:GetOwnedAnkhDataId(ply)

		if original_owner_id then
			--Player is the owner or the original owner of a placed ankh
			if IsValid(self.ankhs[original_owner_id].ankh) then
				return true
			end

			--Player is the original owner of a stolen ankh that is in some other player's inventory
			if original_owner_id == ply:SteamID64() and original_owner_id ~= self.ankhs[original_owner_id].current_owner_id then
				return true
			end
		end

		return false
	end

	function PHARAOH_HANDLER:PlayerCanReviveWithThisAnkhDataId(ply)
		-- Returns the id into PHARAOH_HANDLER.ankhs for the ankh that the player can use to revive.
		-- Returns -1 otherwise.
		local ply_id = ply:SteamID64()

		-- See if the player owns a valid Ankh entity that someone else is the originator of
		-- Prioritize stolen ankhs over originator ankhs to incentivize stealing
		for original_owner_id, ankh_data in pairs(self.ankhs) do
			if original_owner_id ~= ply_id and IsValid(ankh_data.ankh) and ankh_data.current_owner_id == ply_id then
				return original_owner_id
			end
		end

		-- See if the player owns a valid Ankh entity that they are the originator of
		if self.ankhs[ply_id] and IsValid(self.ankhs[ply_id].ankh) and self.ankhs[ply_id].current_owner_id == ply_id then
			return ply_id
		end

		return -1
	end

	function PHARAOH_HANDLER:CreateAnkhData(ent, placer)
		-- The key into ANKHS is the original owner's ID (The Pharaoh who first placed the Ankh)
		-- current_owner_id may update to reflect that a graverobber has stolen it.
		-- ankh is the entity in question, and may update to be nil if the ankh is taken back into the current owner's inventory
		local placer_id = placer:SteamID64()
		self.ankhs[placer_id] = {
			current_owner_id = placer_id,
			ankh = ent,
			health = GetGlobalInt("ttt_ankh_health")
		}
		self.ankhs[placer_id].ankh:SetNWBool("is_stolen", false)

		return placer_id
	end

	function PHARAOH_HANDLER:UpdateAnkhDataUponTransfer(ent, ply)
		for original_owner_id, ankh_data in pairs(self.ankhs) do
			if ankh_data.ankh == ent then
				ankh_data.current_owner_id = ply:SteamID64()
				ankh_data.ankh:SetNWBool("is_stolen", original_owner_id ~= ply:SteamID64())

				return original_owner_id
			end
		end
	end

	function PHARAOH_HANDLER:UpdateAnkhDataUponPlacement(ent, placer)
		-- This ankh previously existed before it was taken back into the current owner's inventory
		-- Now it has been placed into the world again
		for original_owner_id, ankh_data in pairs(self.ankhs) do
			if ankh_data.current_owner_id == placer:SteamID64() then
				ankh_data.ankh = ent
				ankh_data.ankh:SetNWBool("is_stolen", original_owner_id ~= placer:SteamID64())

				return original_owner_id
			end
		end
	end

	function PHARAOH_HANDLER:SetClientCanConvAnkh(ply)
		local can_conv = -2

		if PHARAOH_HANDLER:PlayerIsOriginalOwnerOfAnAnkh(ply) and not PHARAOH_HANDLER:PlayerControlsAnAnkh(ply) and IsValid(self.ankhs[ply:SteamID64()].ankh) then
			-- the player can only convert this particular ankh
			can_conv = self.ankhs[ply:SteamID64()].ankh:EntIndex()
		elseif ply:GetSubRole() == ROLE_GRAVEROBBER and not PHARAOH_HANDLER:PlayerOwnsAnAnkh(ply) then
			-- the player can convert any ankh
			can_conv = -1
		end

		net.Start("ttt2_net_pharaoh_can_conv")
		net.WriteInt(can_conv, 16)
		net.Send(ply)
	end

	function PHARAOH_HANDLER:UpdateAnkhDataUponRemoval(ent)
		-- Maintain the Ankh's health in case it is being picked up and may later be placed down again
		for original_owner_id, ankh_data in pairs(self.ankhs) do
			if ankh_data.ankh == ent then
				ankh_data.health = ent:Health()
				ankh_data.ankh = nil

				-- update all players on what ankh(s) they can convert, in case the entity index of their current target becomes stale.
				local plys = player.GetAll()
				for i = 1, #plys do
					PHARAOH_HANDLER:SetClientCanConvAnkh(plys[i])
				end

				return original_owner_id
			end
		end
	end

	function PHARAOH_HANDLER:RevertUnnecessaryGraverobbers()
		if #self.ankhs == 0 then
			-- now that all ankhs are gone, give back all graverobbers their original role if possible
			local plys = player.GetAll()
			for i = 1, #plys do
				local ply = plys[i]

				if ply:IsTerror() and ply:GetSubRole() == ROLE_GRAVEROBBER and ply.grav_prev_role then
					LANG.Msg(ply, "ankh_all_gone")
					ply:SetRole(ply.grav_prev_role, ply:GetTeam())
				end

				ply.grav_prev_role = nil
			end
		end
	end

	function PHARAOH_HANDLER:RemoveAnkhData(ply)
		-- explicitly check the validity of the player here, as they may have disconnected.
		if not IsValid(ply) then
			return
		end

		for original_owner_id, ankh_data in pairs(self.ankhs) do
			if ankh_data.current_owner_id == ply:SteamID64() then
				self.ankhs[original_owner_id] = nil
				PHARAOH_HANDLER:RevertUnnecessaryGraverobbers()
				break
			end
		end
	end

	function PHARAOH_HANDLER:PlacedAnkh(ent, placer)
		local id = 0

		-- first placement
		if placer:GetSubRole() == ROLE_PHARAOH and not PHARAOH_HANDLER:PlayerOwnsAnAnkh(placer) then
			-- selecting a graverobber, the adversary of the pharaoh
			local p_graverobber = self:SelectGraverobber()

			-- if a valid player is found, he should be converted
			if p_graverobber then
				p_graverobber.grav_prev_role = p_graverobber:GetSubRole()
				p_graverobber:SetRole(ROLE_GRAVEROBBER)
				SendFullStateUpdate()

				LANG.Msg(placer, "ankh_selected_graverobber")
			end

			id = self:CreateAnkhData(ent, placer)
		else
			id = self:UpdateAnkhDataUponPlacement(ent, placer)
		end

		-- update all players on what ankh(s) they can convert, in case the entity index of their current target becomes stale.
		local plys = player.GetAll()
		for i = 1, #plys do
			PHARAOH_HANDLER:SetClientCanConvAnkh(plys[i])
		end

		-- set the hp of the ankh
		ent:SetHealth(self.ankhs[id].health)

		-- drawing the decal on the ground
		self:AddDecal(ent, id)

		-- set owner of ankh
		ent:SetOwner(placer)

		-- add wallhack
		self:AddWallhack(ent, placer)

		-- add status icon to owner
		STATUS:AddStatus(placer, "ttt_ankh_status", 1)
	end

	function PHARAOH_HANDLER:TransferAnkhOwnership(ent, ply)
		if not IsValid(ply) then return end

		local id = self:UpdateAnkhDataUponTransfer(ent, ply)

		-- stop converting sound for old owner
		self:StopSound("ankh_converting", ent)

		-- play conversion sound for all players
		self:PlaySound("ankh_conversion", ent, player.GetAll())

		-- show conversion popup to old owner
		self:ShowPopup(ent:GetOwner(), "conversionSuccess")

		-- update status icons for both players
		STATUS:RemoveStatus(ent:GetOwner(), "ttt_ankh_status")
		STATUS:AddStatus(ply, "ttt_ankh_status", 1)

		-- trigger the event for the scoreboard
		events.Trigger(EVENT_ANKH_CONVERSION, ent:GetOwner(), ply)

		-- add fingerprints to the ent
		if not table.HasValue(ent.fingerprints, ply) then
			ent.fingerprints[#ent.fingerprints + 1] = ply
		end

		-- removing the decal on the ground since it will be replaced
		self:RemoveDecal(ent)
		self:AddDecal(ent, id)

		-- update wallhacks
		self:RemoveWallhack(ent, ent:GetOwner())
		self:AddWallhack(ent, ply)

		-- Update conversion info for the old and new owners
		PHARAOH_HANDLER:SetClientCanConvAnkh(ent:GetOwner())
		PHARAOH_HANDLER:SetClientCanConvAnkh(ply)

		-- finally transfer the ownership
		ent:SetOwner(ply)
	end

	function PHARAOH_HANDLER:RemoveAnkhDataFromLoadout(ply)
		-- if the player has an ankh in their inventory, remove it.
		for original_owner_id, ankh_data in pairs(self.ankhs) do
			if ankh_data.current_owner_id == ply:SteamID64() and not IsValid(ankh_data.ankh) then
				self.ankhs[original_owner_id] = nil
				PHARAOH_HANDLER:RevertUnnecessaryGraverobbers()
				break
			end
		end
	end

	function PHARAOH_HANDLER:DestroyAnkh(ent, destroyer)
		-- trigger the event for the scoreboard
		if not ent.using_to_revive then
			events.Trigger(EVENT_ANKH_DESTROYED, ent:GetOwner(), destroyer)
		end

		-- if a player is respawning with the use of the ankh, the popup
		-- has to be replaced
		if ent:GetNWBool("isReviving", false) and IsValid(ent.revivingPlayer) then
			self:RemovePopup(ent.revivingPlayer, "pharaohRevival")
			self:ShowPopup(ent.revivingPlayer, "pharaohRevivalCanceled")

			ent.revivingPlayer:CancelRevival()
		end

		self:RemovedAnkh(ent)

		-- replace removed decal with rune_neutral
		self:AddDecal(ent, -1)

		-- remove ankh data, which will allow the player to place another ankh down, should the opportunity arrive
		self:RemoveAnkhData(ent:GetOwner())

		local effect = EffectData()
		effect:SetOrigin(ent:GetPos())
		util.Effect("cball_explode", effect)
		sound.Play(zapsound, ent:GetPos())

		-- notify the current owner that the ankh was broken
		if IsValid(ent:GetOwner()) then
			LANG.Msg(ent:GetOwner(), "ankh_broken")
		end

		-- notify all graverobbers that an ankh was broken
		local plys = player.GetAll()
		for i = 1, #plys do
			local ply = plys[i]

			if ply:GetSubRole() == ROLE_GRAVEROBBER and ent:GetOwner() ~= ply then
				LANG.Msg(ply, "ankh_broken_adv")
			end
		end
	end

	function PHARAOH_HANDLER:RemovedAnkh(ent)
		-- replace decal with inactive decal
		self:RemoveDecal(ent)

		-- remove status icon
		STATUS:RemoveStatus(ent:GetOwner(), "ttt_ankh_status")

		-- stop all possible sounds
		self:StopSound("ankh_converting")
		self:StopSound("ankh_conversion")
		self:StopSound("ankh_respawn")

		-- remove wallhack
		self:RemoveWallhack(ent, ent:GetOwner())

		self:UpdateAnkhDataUponRemoval(ent)
	end
end

function PHARAOH_HANDLER:CanPickUpAnkh(ent, ply)
	if GetRoundState() ~= ROUND_ACTIVE then
		return false
	end

	-- make sure ply is owner
	-- do not need to reference self.ankhs in this function, because by the time we get here, there will only be at most one ankh that the player is marked the owner of.
	if not IsValid(ent:GetOwner()) or ply ~= ent:GetOwner() then
		return false
	end

	-- make sure that the ply has one of the two allowed roles
	if ply:GetSubRole() ~= ROLE_PHARAOH and ply:GetSubRole() ~= ROLE_GRAVEROBBER then
		return false
	end

	-- check if this roles is allowed to pick up
	if ply:GetSubRole() == ROLE_PHARAOH and not GetGlobalBool("ttt_ankh_pharaoh_pickup", false) then
		return false
	end
	if ply:GetSubRole() == ROLE_GRAVEROBBER and not GetGlobalBool("ttt_ankh_graverobber_pickup", false) then
		return false
	end

	return true
end

function PHARAOH_HANDLER:StartConversion(ent, ply)
	-- start converting sound for old owner
	self:PlaySound("ankh_converting", ent, {ent:GetOwner(), ply})

	-- update status icon
	STATUS:SetActiveIcon(ent:GetOwner(), "ttt_ankh_status", 2)
end

function PHARAOH_HANDLER:CancelConversion(ent, ply)
	-- stop converting sound for old owner
	self:StopSound("ankh_converting", ent)

	-- update status icon
	STATUS:SetActiveIcon(ent:GetOwner(), "ttt_ankh_status", 1)
end

function PHARAOH_HANDLER:AddWallhack(ent, ply)
	net.Start("ttt2_net_pharaoh_wallack")
	net.WriteBool(true)
	net.WriteEntity(ent)
	net.Send(ply)
end

function PHARAOH_HANDLER:RemoveWallhack(ent, ply)
	net.Start("ttt2_net_pharaoh_wallack")
	net.WriteBool(false)
	net.WriteEntity(ent)
	net.Send(ply)
end

function PHARAOH_HANDLER:AddDecal(ent, original_owner_id)
	-- determine the type of decal to add
	local decal_type = "rune_neutral"
	if self.ankhs[original_owner_id] then
		if ent:GetNWBool("is_stolen", false) then
			decal_type = "rune_graverobber"
		else
			decal_type = "rune_pharaoh"
		end
	end

	-- ignore the ankh at all players
	local filter = {ent}
	table.Add(filter, player.GetAll())

	-- store the decal id on this ent for easier removal
	-- Use EntIndex and CurTime() to ensure uniqueness (otherwise decal operations may affect multiple decals unwittingly).
	ent.decal_id = "ankh_decal_" .. tostring(ent:EntIndex()) .. "_" .. tostring(CurTime())

	-- shift decal to offset shift of model
	util.PaintDownRemovable(ent.decal_id, ent:GetPos() + Vector(7, 1, 20), decal_type, filter)
end

function PHARAOH_HANDLER:RemoveDecal(ent)
	if not ent.decal_id then return end

	util.RemoveDecal(ent.decal_id)

	ent.decal_id = nil
end

function PHARAOH_HANDLER:SpawnEffects(pos)
	if CLIENT then return end

	net.Start("ttt2_net_pharaoh_spawn_effects")
	net.WriteVector(pos)
	net.Broadcast()
end

function PHARAOH_HANDLER:ShowPopup(ply, id)
	net.Start("ttt2_net_pharaoh_show_popup")
	net.WriteString(id)
	net.WriteBool(true)
	net.Send(ply)
end

function PHARAOH_HANDLER:RemovePopup(ply, id)
	net.Start("ttt2_net_pharaoh_show_popup")
	net.WriteString(id)
	net.WriteBool(false)
	net.Send(ply)
end

function PHARAOH_HANDLER:PlaySound(soundname, target, listeners)
	if CLIENT then return end

	if not IsValid(target) then return end

	-- sending netmessages to the client since not every player should be able to hear it
	net.Start("ttt2_net_pharaoh_start_sound")
	net.WriteEntity(target)
	net.WriteString(soundname)
	net.Send(listeners)
end

function PHARAOH_HANDLER:StopSound(soundname, target)
	if CLIENT then return end

	if not IsValid(target) then return end

	-- the sound can be stopped on the server since it should stop
	-- for all players
	target:StopSound(soundname)
end

if CLIENT then
	local smokeparticles = {
		Model("particle/particle_smokegrenade"),
		Model("particle/particle_noisesphere")
	}

	net.Receive("ttt2_net_pharaoh_spawn_effects", function()
		local pos = net.ReadVector()

		-- spawn sound effect and destroy particless
		local effect = EffectData()
		effect:SetOrigin(pos)
		util.Effect("cball_explode", effect)

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

	net.Receive("ttt2_net_pharaoh_wallack", function()
		if net.ReadBool() then
			marks.Add({net.ReadEntity()}, LocalPlayer():GetRoleColor())
		else
			marks.Remove({net.ReadEntity()})
		end
	end)

	net.Receive("ttt2_net_pharaoh_start_sound", function()
		local target = net.ReadEntity()
		local soundname = net.ReadString()

		if not IsValid(target) then return end

		target:EmitSound(soundname, 160)
	end)

	net.Receive("ttt2_net_pharaoh_show_popup", function()
		local client = LocalPlayer()
		client.epopId = client.epopId or {}

		local id = net.ReadString()
		local shouldAdd = net.ReadBool()

		if shouldAdd then
			if id == "conversionSuccess" then
				client.epopId[id] = EPOP:AddMessage(
					{
						text = LANG.GetTranslation("ankh_popup_converted_title"),
						color = PHARAOH.ltcolor
					},
					LANG.GetTranslation("ankh_popup_converted_text"),
					6
				)
			elseif id == "pharaohRevival" then
				client.epopId[id] = EPOP:AddMessage(
					{
						text = LANG.GetTranslation("ankh_revival"),
						color = PHARAOH.ltcolor
					},
					LANG.GetParamTranslation("ankh_revival_text", {time = GetGlobalInt("ttt_ankh_respawn_time", 10)}),
					GetGlobalInt("ttt_ankh_respawn_time", 10)
				)
			elseif id == "pharaohRevivalCanceled" then
				client.epopId[id] = EPOP:AddMessage(
					{
						text = LANG.GetTranslation("ankh_revival_canceled"),
						color = GRAVEROBBER.ltcolor
					},
					LANG.GetTranslation("ankh_revival_canceled_text"),
					10
				)
			end
		else
			if client.epopId[id] then
				EPOP:RemoveMessage(client.epopId[id])
			end
		end
	end)

	net.Receive("ttt2_net_pharaoh_can_conv", function()
		local client = LocalPlayer()
		client.ankh_can_conv = net.ReadInt(16)
	end)

	hook.Add("TTTBeginRound", "ttt2_role_pharaoh_reset", function()
		local client = LocalPlayer()
		client.ankh_can_conv = nil
	end)
end

local function PlayerCanBeAGraverobber(ply)
	---
	-- @note Special Traitor roles can opt out of being selected to become Graverobbers (ex. Defective)
	-- @realm shared
	return ply:GetBaseRole() == ROLE_TRAITOR and ply:IsTerror() and not hook.Run("TTT2GraverobberPreventSelection", ply)
end

---
-- Returns a player that can be converted to a graverobber
-- Vanilla T players are preferred, other team traitor players are used as
-- a fallback
-- Does not select a graverobber if a graverobber already exists
function PHARAOH_HANDLER:SelectGraverobber()
	local p_vanilla_traitor = {}
	local p_team_traitor = {}

	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if ply:GetSubRole() == ROLE_GRAVEROBBER then
			return
		end

		if ply:GetSubRole() == ROLE_TRAITOR and ply:IsTerror() then
			p_vanilla_traitor[#p_vanilla_traitor + 1] = ply
		end

		if PlayerCanBeAGraverobber(ply) then
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
-- The ankh can only be placed if at least one traitor is still alive
function PHARAOH_HANDLER:CanPlaceAnkh(placer)
	local plys = player.GetAll()

	if GetRoundState() ~= ROUND_ACTIVE then
		return false
	end

	if self:PlayerOwnsAnAnkhOutsideOfLoadout(placer) then
		if SERVER then
			LANG.Msg(placer, "ankh_already_owned")
		end
		return false
	end

	for i = 1, #plys do
		local ply = plys[i]

		if PlayerCanBeAGraverobber(ply) then
			return true
		end
	end

	if SERVER then
		LANG.Msg(placer, "ankh_no_traitor_alive")
	end
	return false
end

function PHARAOH_HANDLER:GiveSpawnProtection(ply)
	local ent = ents.Create("prop_physics")

	ent:SetModel("models/hunter/tubes/tube1x1x2c.mdl")
	ent:SetPos(ply:EyePos() + Vector(0, 0, 35))
	ent:SetAngles(ply:EyeAngles() + Angle(160, 0, 0))
	ent:SetParent(ply)
	ent:Spawn()

	ent:SetMaterial("models/effects/splodearc_sheet")
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ent:SetMoveType(MOVETYPE_NONE)

	undo.Create("Shield")
	undo.AddEntity(ent)
	undo.Finish()

	ply.classPatronus_shield = ent

	timer.Simple(GetConVar("ttt_ankh_respawn_protection_time"):GetInt(), function()
		if not IsValid(ply) or not IsValid(ent) then return end

		ent:Remove("Shield")
	end)
end

if SERVER then
	---
	-- using TTT2PostPlayerDeath hook here, since it is called at the very last, addons like
	-- a second change are triggered prior to this hook (SERVER ONLY)
	hook.Add("TTT2PostPlayerDeath", "ttt2_role_pharaoh_death", function(victim, inflictor, attacker)
		if not IsValid(victim) then return end

		-- Any ankhs that the ply will have in their loadout will be removed when they die. So remove the associated ankh_data as well.
		PHARAOH_HANDLER:RemoveAnkhDataFromLoadout(victim)

		if GetRoundState() ~= ROUND_ACTIVE then return end

		-- victim must be either a pharaoh or graverobber with an ankh
		local id = PHARAOH_HANDLER:PlayerCanReviveWithThisAnkhDataId(victim)
		if not PHARAOH_HANDLER.ankhs[id] or not IsValid(PHARAOH_HANDLER.ankhs[id].ankh) then return end

		-- the victim must be the current owner of the ankh
		if victim:SteamID64() ~= PHARAOH_HANDLER.ankhs[id].current_owner_id then return end

		-- show a information popup to the victim
		PHARAOH_HANDLER:ShowPopup(victim, "pharaohRevival")

		-- set state to ank that a player is reviving
		PHARAOH_HANDLER.ankhs[id].ankh:SetNWBool("isReviving", true)
		PHARAOH_HANDLER.ankhs[id].ankh.revivingPlayer = victim

		local ankh_pos = PHARAOH_HANDLER.ankhs[id].ankh:GetPos() + Vector(0, 0, 2.5)

		victim:Revive(GetGlobalInt("ttt_ankh_respawn_time", 10),
			function(ply)
				-- set state to ank that a player is no longer reviving
				PHARAOH_HANDLER.ankhs[id].ankh:SetNWBool("isReviving", false)
				PHARAOH_HANDLER.ankhs[id].ankh.revivingPlayer = nil

				-- destroying the ankh on revival
				PHARAOH_HANDLER.ankhs[id].ankh.using_to_revive = true
				PHARAOH_HANDLER.ankhs[id].ankh:Remove()

				-- set player HP to 50
				ply:SetHealth(50)

				-- spawn smoke
				PHARAOH_HANDLER:SpawnEffects(ankh_pos)

				-- play sound
				sound.Play("ankh_respawn", ankh_pos, 200, 100, 1.0)

				-- remove popup
				PHARAOH_HANDLER:RemovePopup(ply, "pharaohRevival")

				-- give some spawn protextion
				PHARAOH_HANDLER:GiveSpawnProtection(ply)

				-- trigger the event for the scoreboard
				events.Trigger(EVENT_ANKH_REVIVE, ply)
			end,
			function(ply)
				-- make sure the revival is still valid
				return GetRoundState() == ROUND_ACTIVE and IsValid(ply) and not ply:Alive() and IsValid(PHARAOH_HANDLER.ankhs[id].ankh) and ply == PHARAOH_HANDLER.ankhs[id].ankh:GetOwner()
			end,
			false, -- no corpse needed for respawn
			true, -- force revival
			nil,
			ankh_pos
		)
	end)

	hook.Add("TTTBeginRound", "ttt2_role_pharaoh_reset", function()
		PHARAOH_HANDLER.ankhs = {}

		local plys = player.GetAll()
		for i = 1, #plys do
			plys[i].grav_prev_role = nil
		end
	end)
end