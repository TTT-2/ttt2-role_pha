if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Model = Model("models/pharaohs_ankh/pharaohs_ankh/pharaohs_ankh.mdl")
ENT.CanHavePrints = true
ENT.CanUseKey = true

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(0.15)
	self:SetAngles(Angle(1, 0, 0))

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self:WeldToGround(true)

	if SERVER then
		self:SetMaxHealth(GetConVar("ttt_ankh_health"):GetInt())

		self:SetUseType(CONTINUOUS_USE)
	end

	self.low_health_threshold = GetConVar("ttt_ankh_health"):GetInt() * 0.1

	-- start ankh handling
	if SERVER then
		PHARAOH_HANDLER:PlacedAnkh(self, self:GetOwner())
	end
	self:SetNWBool("isReviving", false)

	-- set up fingerprints
	self.fingerprints = {}

	if SERVER then
		self:CallOnRemove("AnkhCallOnRemove", function(ent)
			--If the owner is just picking it up or the round is over, then don't perform any theatrics. Just remove the entity
			if self.picking_up or GetRoundState() ~= ROUND_ACTIVE then
				return
			end

			--Otherwise the ankh is being removed via being damaged or being destroyed through 3rd party software (ex. Prop Exploder)
			PHARAOH_HANDLER:DestroyAnkh(self, self.destroyer)
		end)
	end
end

function ENT:UpdateProgress()
	local elapsed_time = self.t_transfer_start and (CurTime() - self.t_transfer_start) or 0

	self:SetNWInt("conversion_progress", math.Round(elapsed_time / GetConVar("ttt_ankh_conversion_time"):GetInt() * 100, 0))
end

if SERVER then
	function ENT:HandleCloseRange()
		if not IsValid(self:GetOwner()) then return end

		local plys = player.GetAll()
		local ply

		for i = 1, #plys do
			if plys[i] == self:GetOwner() and self:GetPos():Distance(plys[i]:GetPos()) < 100 then
				ply = plys[i]

				break
			end
		end

		if not IsValid(ply) then return end

		-- heal ent
		if GetConVar("ttt_ankh_heal_ankh"):GetBool() and (not self.t_heal_ent or CurTime() > self.t_heal_ent) then
			self:SetHealth(math.min(self:GetMaxHealth(), self:Health() + 1))

			if self:Health() <= self.low_health_threshold then
				self.t_heal_ent = CurTime() + 0.1
			else
				self.t_heal_ent = CurTime() + 0.5
			end
		end

		-- heal player
		if GetConVar("ttt_ankh_heal_owner"):GetBool() and self:Health() > self.low_health_threshold
		and (not self.t_heal_ply or CurTime() > self.t_heal_ply) then
			ply:SetHealth(math.min(ply:GetMaxHealth(), ply:Health() + 1))

			self.t_heal_ply = CurTime() + 1.5
		end
	end

	function ENT:Think()
		self:HandleCloseRange()

		if not IsValid(self.last_activator) then return end

		local tr = util.TraceLine({
			start = self.last_activator:GetShootPos(),
			endpos = self.last_activator:GetShootPos() + self.last_activator:GetAimVector() * 100,
			filter = self.last_activator,
			mask = MASK_SHOT
		})

		if tr.Entity ~= self or not self.last_activator:KeyDown(IN_USE) then
			self.last_activator = nil
			self.t_transfer_start = nil

			-- set progress to be available for clients
			self:UpdateProgress()

			PHARAOH_HANDLER:CancelConversion(self, self:GetOwner())
		end
	end
end

function ENT:Use(activator, caller, type, value)
	if not IsValid(activator) then return end

	-- transfer ownership after a certain time has passed and the key was pressed down
	if activator:GetSubRole() ~= ROLE_GRAVEROBBER and activator:GetSubRole() ~= ROLE_PHARAOH then
		return
	end

	-- Players can only control one Ankh, and may not convert another until they use the one they control
	if PHARAOH_HANDLER:PlayerControlsAnAnkh(activator) then
		return
	end

	--Pharaohs may only convert ankhs that have been stolen from them.
	if activator:GetSubRole() == ROLE_PHARAOH and not PHARAOH_HANDLER:PlayerIsOriginalOwnerOfThisAnkh(activator, self) then
		return
	end

	-- set last activator to detect release of use key after he lost focus
	self.last_activator = activator

	if self:GetNWBool("isReviving", false) then
		return
	end

	if not self.t_transfer_start then
		self.t_transfer_start = CurTime()

		PHARAOH_HANDLER:StartConversion(self, activator)
	end

	if CurTime() - self.t_transfer_start > GetConVar("ttt_ankh_conversion_time"):GetInt() then
		PHARAOH_HANDLER:TransferAnkhOwnership(self, activator)
		self.t_transfer_start = nil
	end

	-- set progress to be available for clients
	self:UpdateProgress()
end

-- called on key release
function ENT:UseOverride(activator)
	if not IsValid(activator) then return end

	-- do not pick up if player was previously converting the ankh
	if self.last_activator then return end

	if not PHARAOH_HANDLER:CanPickUpAnkh(self, activator) then
		return
	end

	-- picks up weapon, switches if possible and needed, returns weapon if successful
	local wep = activator:SafePickupWeaponClass("weapon_ttt_ankh", true)

	-- pickup failed because there was no room free in the inventory
	if not IsValid(wep) then
		LANG.Msg(activator, "pickup_no_room")

		return
	end

	PHARAOH_HANDLER:RemovedAnkh(self)

	self.picking_up = true
	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()

	---
	-- @note Special roles that deal no damage to players shouldn't be able to damage the ankh (leads to griefing)
	-- @realm server
	if hook.Run("TTT2PharaohPreventDamageToAnkh", attacker) then
		return
	end

	self:SetHealth(self:Health() - dmginfo:GetDamage())

	if self:Health() > 0 then return end

	self.destroyer = attacker
	self:Remove()
end

-- Copy pasted from C4
function ENT:WeldToGround(state)
	if self.IsOnWall then return end

	if state then
		-- getgroundentity does not work for non-players
		-- so sweep ent downward to find what we're lying on
		local ignore = player.GetAll()
		ignore[#ignore + 1] = self

		local tr = util.TraceEntity({
			start = self:GetPos(),
			endpos = self:GetPos() - Vector(0, 0, 16),
			filter = ignore,
			mask = MASK_SOLID
		}, self)

		-- Start by increasing weight/making uncarryable
		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			-- Could just use a pickup flag for this. However, then it's easier to
			-- push it around.
			self.OrigMass = phys:GetMass()

			phys:SetMass(150)
		end

		if tr.Hit and (IsValid(tr.Entity) or tr.HitWorld) then
			-- "Attach" to a brush if possible
			if IsValid(phys) and tr.HitWorld then
				phys:EnableMotion(false)
			end

			-- Else weld to objects we cannot pick up
			local entphys = tr.Entity:GetPhysicsObject()

			if IsValid(entphys) and entphys:GetMass() > CARRY_WEIGHT_LIMIT then
				constraint.Weld(self, tr.Entity, 0, 0, 0, true)
			end

			-- Worst case, we are still uncarryable
		end
	else
		constraint.RemoveConstraints(self, "Weld")

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(true)
			phys:SetMass(self.OrigMass or 10)
		end
	end
end

if CLIENT then
	function ENT:LightUp(color, brightness)
		-- make sure initial values are set
		if not self.light_next_state then
			self.light_next_state = CurTime()
			self.light_state = brightness
		end

		-- if the ankhs HP is low, let the light flicker
		if self:Health() <= self.low_health_threshold and CurTime() > self.light_next_state then
			self.light_next_state = CurTime() + math.Rand(0, 0.5)

			if self.light_state > 2 then
				self.light_state = brightness * 0.25
			else
				self.light_state = brightness
			end
		else
			self.light_state = brightness
		end

		local dlight = DynamicLight(self:EntIndex())

		dlight.r = color.r
		dlight.g = color.g
		dlight.b = color.b

		dlight.brightness = self.light_state
		dlight.Decay = 1000
		dlight.Size = 200
		dlight.DieTime = CurTime() + 0.1
		dlight.Pos = self:GetPos() + Vector(0, 0, 35)
	end

	function ENT:Think()
		if not IsValid(self:GetOwner()) then return end

		-- get the color the ent should light up
		local color

		if self:GetNWBool("is_stolen", false) then
			color = GRAVEROBBER.color
		else
			color = PHARAOH.color
		end

		-- if the ent has no owner, it shouldn't light up
		if not color then return end

		-- calculate the brightness, if the owner is in close range, it should light up brighter
		local brightness = 2

		if GetConVar("ttt_ankh_light_up"):GetBool() then
			local plys = player.GetAll()
			for i = 1, #plys do
				if plys[i] == self:GetOwner() and self:GetPos():Distance(plys[i]:GetPos()) < 100 then
					brightness = 4

					break
				end
			end
		end

		self:LightUp(color, brightness)
	end

	-- handle looking at ankh
	hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDAnkh", function(tData)
		local client = LocalPlayer()
		local ent = tData:GetEntity()

		if not PHARAOH then return end

		if not IsValid(client) or not client:IsTerror() or not client:Alive()
		or tData:GetEntityDistance() > 80 or not IsValid(ent) or ent:GetClass() ~= "ttt_ankh" then
			return
		end

		-- enable targetID rendering
		tData:EnableText()
		tData:EnableOutline()
		tData:SetOutlineColor(client:GetRoleColor())

		tData:SetTitle(LANG.TryTranslation("ttt2_weapon_ankh_name"))
		tData:AddDescriptionLine(LANG.TryTranslation("ankh_short_desc"))

		if client == ent:GetOwner() then
			if PHARAOH_HANDLER:CanPickUpAnkh(ent, client) and not ent:GetNWBool("isReviving", false) then
				tData:SetKeyBinding("+use")

				tData:SetSubtitle(LANG.GetParamTranslation("target_pickup", {usekey = Key("+use", "USE")}))
			else
				tData:AddIcon(
					PHARAOH.iconMaterial,
					PHARAOH.ltcolor
				)

				tData:SetSubtitle(LANG.TryTranslation("ankh_no_pickup"))
			end
		elseif client:GetSubRole() == ROLE_PHARAOH or client:GetSubRole() == ROLE_GRAVEROBBER then
			if ent:GetNWBool("isReviving", false) then
				tData:AddIcon(
					PHARAOH.iconMaterial,
					PHARAOH.ltcolor
				)
				tData:SetSubtitle(LANG.TryTranslation("ankh_no_convert"))

				tData:AddDescriptionLine(
					LANG.TryTranslation("ankh_owner_is_reviving"),
					client:GetRoleColor()
				)
			elseif client.ankh_can_conv == -1 or client.ankh_can_conv == ent:EntIndex() then
				tData:SetKeyBinding("+use")
				tData:SetSubtitle(LANG.GetParamTranslation("ankh_convert", {usekey = Key("+use", "USE")}))

				tData:AddDescriptionLine(
					LANG.GetParamTranslation("ankh_progress", {progress = ent:GetNWInt("conversion_progress", 0)}),
					client:GetRoleColor()
				)
			end
		else
			tData:AddIcon(
				PHARAOH.iconMaterial,
				PHARAOH.ltcolor
			)

			tData:SetSubtitle(LANG.TryTranslation("ankh_unknown_terrorist"))
		end

		tData:AddDescriptionLine(
			LANG.GetParamTranslation("ankh_health_points", {health = ent:Health(), maxhealth = GetConVar("ttt_ankh_health"):GetInt()}),
			ent:Health() > ent.low_health_threshold and DETECTIVE.ltcolor or COLOR_ORANGE
		)
	end)
end
