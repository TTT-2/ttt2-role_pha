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
		self:SetMaxHealth(GetGlobalInt("ttt_ankh_health"))

		self:SetUseType(CONTINUOUS_USE)
	end

	-- can pick this up if we own it
	if SERVER then
		local weptbl = util.WeaponForClass("weapon_ttt_ankh")

		if weptbl and weptbl.Kind then
			self.WeaponKind = weptbl.Kind
		else
			self.WeaponKind = WEAPON_EQUIP2
		end
	end

	-- start ankh handling
	PHARAOH_HANDLER:PlacedAnkh(self, self:GetOwner())
	self:GetOwner().ankh_data = nil

	-- set up fingerprints
	self.fingerprints = {}
end

function ENT:UpdateProgress()
	local elapsed_time = self.t_transfer_start and (CurTime() - self.t_transfer_start) or 0

	self:SetNWInt("conversion_progress", math.Round(elapsed_time / GetGlobalInt("ttt_ankh_conversion_time", 0) * 100, 0))
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
		if GetGlobalBool("ttt_ankh_heal_ankh", false) and (not self.t_heal_ent or CurTime() > self.t_heal_ent) then
			self:SetHealth(math.min(self:GetMaxHealth(), self:Health() + 1))

			if self:Health() <= GetGlobalInt("ttt_ankh_low_health", 0) then
				self.t_heal_ent = CurTime() + 0.1
			else
				self.t_heal_ent = CurTime() + 0.5
			end
		end

		-- heal player
		if GetGlobalBool("ttt_ankh_heal_owner", false) and self:Health() > GetGlobalInt("ttt_ankh_low_health", 0)
		and (not self.t_heal_ply or CurTime() > self.t_heal_ply) then
			ply:SetHealth(math.min(ply:GetMaxHealth(), ply:Health() + 1))

			self.t_heal_ply = CurTime() + 1.5
		end
	end

	function ENT:Think()
		self:HandleCloseRange()

		if not IsValid(self.last_activatotor) then return end

		local tr = util.TraceLine({
			start = self.last_activatotor:GetShootPos(),
			endpos = self.last_activatotor:GetShootPos() + self.last_activatotor:GetAimVector() * 100,
			filter = self.last_activatotor,
			mask = MASK_SHOT
		})

		if tr.Entity ~= self or not self.last_activatotor:KeyDown(IN_USE) then
			self.last_activatotor = nil
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
	if not self:GetAdversary() or activator ~= self:GetAdversary() then return end

	-- set last activator to detect release of use key after he lost focus
	self.last_activatotor = activator

	if not self.t_transfer_start then
		self.t_transfer_start = CurTime()

		PHARAOH_HANDLER:StartConversion(self, self:GetOwner())
	end

	if CurTime() - self.t_transfer_start > GetGlobalInt("ttt_ankh_conversion_time", 0) then
		PHARAOH_HANDLER:TransferAnkhOwnership(self, activator)
		self.t_transfer_start = nil
	end

	-- set progress to be available for clients
	self:UpdateProgress()
end

-- called on key release
function ENT:UseOverride(activator)
	if not IsValid(activator) then return end

	-- make sure activator is owner
	if not IsValid(self:GetOwner()) or activator ~= self:GetOwner() then return end

	-- do not pick up if player was previously converting the ankh
	if self.last_activatotor then return end

	-- check if this roles is allowed to pick up
	if activator == self:GetNWEntity("pharaoh", nil) and not GetGlobalBool("ttt_ankh_pharaoh_pickup", false) then return end
	if activator == self:GetNWEntity("graverobber", nil) and not GetGlobalBool("ttt_ankh_graverobber_pickup", false) then return end

	-- make sure that the activator has one of the two allowed roles
	if activator:GetSubRole() ~= ROLE_PHARAOH and activator:GetSubRole() ~= ROLE_GRAVEROBBER then return end

	-- picks up weapon, switches if possible and needed, returns weapon if successful
	local wep = activator:PickupWeaponClass("weapon_ttt_ankh", true)

	-- pickup failed because there was no room free in the inventory
	if not IsValid(wep) then
		LANG.Msg(activator, "pickup_no_room")

		return
	end

	PHARAOH_HANDLER:RemovedAnkh(self)

	activator.ankh_data = {
		pharaoh = self:GetNWEntity("pharaoh", nil),
		graverobber = self:GetNWEntity("graverobber", nil),
		owner = self:GetOwner(),
		adversary = self:GetNWEntity("adversary", nil),
		health = self:Health()
	}

	self:Remove()
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")

function ENT:OnTakeDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())

	if self:Health() > 0 then return end

	PHARAOH_HANDLER:DestroyAnkh(self, dmginfo:GetAttacker())

	local effect = EffectData()
	effect:SetOrigin(self:GetPos())
	util.Effect("cball_explode", effect)

	sound.Play(zapsound, self:GetPos())

	-- notify the current owner and his adversary that the ankh was broken
	if IsValid(self:GetOwner()) then
		LANG.Msg(self:GetOwner(), "ankh_broken")
	end

	if IsValid(self:GetAdversary()) then
		LANG.Msg(self:GetAdversary(), "ankh_broken_adv")
	end
end

function ENT:SetAdversary(ply)
	self.adversary = ply
	self:SetNWEntity("adversary", ply)
end

function ENT:GetAdversary()
	return self.adversary
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
		if self:Health() <= GetGlobalInt("ttt_ankh_low_health", 0) and CurTime() > self.light_next_state then
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

		if self:GetNWEntity("pharaoh", nil) == self:GetOwner() then
			color = PHARAOH.color
		elseif self:GetNWEntity("pharaoh", nil) == self:GetOwner() then
			color = GRAVEROBBER.color
		end

		-- if the ent has no owner, it shouldn't light up
		if not color then return end

		-- calculate the brightness, if the owner is in close range, it should light up brighter
		local brightness = 2

		if GetGlobalBool("ttt_ankh_light_up", false) then
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
			if (client == ent:GetNWEntity("pharaoh", nil) and GetGlobalBool("ttt_ankh_pharaoh_pickup", false)
				or client == ent:GetNWEntity("graverobber", nil) and GetGlobalBool("ttt_ankh_graverobber_pickup", false))
				and client:GetSubRole() == ROLE_PHARAOH or client:GetSubRole() == ROLE_GRAVEROBBER
			then
				tData:SetKeyBinding("+use")

				tData:SetSubtitle(LANG.GetParamTranslation("target_pickup", {usekey = Key("+use", "USE")}))
			else
				tData:AddIcon(
					PHARAOH.iconMaterial,
					PHARAOH.ltcolor
				)

				tData:SetSubtitle(LANG.TryTranslation("ankh_no_pickup"))
			end
		elseif client == ent:GetNWEntity("adversary", nil) then
			tData:SetKeyBinding("+use")
			tData:SetSubtitle(LANG.GetParamTranslation("ankh_convert", {usekey = Key("+use", "USE")}))

			tData:AddDescriptionLine(
				LANG.GetParamTranslation("ankh_progress", {progress = ent:GetNWInt("conversion_progress", 0)}),
				client:GetRoleColor()
			)
		else
			tData:AddIcon(
				PHARAOH.iconMaterial,
				PHARAOH.ltcolor
			)

			tData:SetSubtitle(LANG.TryTranslation("ankh_unknown_terrorist"))
		end

		tData:AddDescriptionLine(
			LANG.GetParamTranslation("ankh_health_points", {health = ent:Health(), maxhealth = GetGlobalInt("ttt_ankh_health")}),
			ent:Health() > GetGlobalInt("ttt_ankh_low_health", 0) and DETECTIVE.ltcolor or COLOR_ORANGE
		)
	end)
end
