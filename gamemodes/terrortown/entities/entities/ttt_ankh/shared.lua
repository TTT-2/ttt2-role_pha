if SERVER then
	AddCSLuaFile()
end

ENT.Type = 'anim'
ENT.Model = Model('models/props_lab/reciever01b.mdl')
ENT.CanHavePrints = true
ENT.CanUseKey = true


--TODO
function ENT:LightUp(color)
	if SERVER then return end

	local dlight = DynamicLight(self:EntIndex())

	dlight.r = color.r
	dlight.g = color.g
	dlight.b = color.b

	dlight.brightness = 5
	dlight.Decay = 1000
	dlight.Size = 256
	dlight.DieTime = CurTime() + 1
	dlight.Pos = self:GetPos() + Vector(0,0,10)
end

------------------------

function ENT:Initialize()
	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self:WeldToGround(true)

	if SERVER then
		self:SetMaxHealth(GetGlobalInt('ttt_ankh_health'))

		self:SetUseType(CONTINUOUS_USE)
	end

	self:SetHealth(GetGlobalInt('ttt_ankh_health'))

	-- can pick this up if we own it
	if SERVER then
		local weptbl = util.WeaponForClass('weapon_ttt_ankh')

		if weptbl and weptbl.Kind then
			self.WeaponKind = weptbl.Kind
		else
			self.WeaponKind = WEAPON_EQUIP2
		end
	end

	-- start ankh handling
	PHARAOH_HANDLER:PlacedAnkh(self, self:GetOwner())
end

--[[
function ENT:Use(activator)
	if not IsValid(activator) then return end

	-- transfer ownership after a certain time has passed and the key was pressed down
	if not self:GetAdversary() or activator ~= self:GetAdversary() then return end

	if not self.t_transfer_start then
		t_transfer_start = CurTime()
	end

	if CurTime() - self.t_transfer_start > GetGlobalInt('ttt_ankh_conversion_time') then
		PHARAOH_HANDLER:TransferAnkhOwnership(self, activator)

		-- set progress to be available for clients
		self:SetNWInt('conversion_progress', (CurTime() - self.t_transfer_start) / GetGlobalInt('ttt_ankh_conversion_time') * 100)
	end
end
--]]

-- called on key release
function ENT:UseOverride(activator)
	print(tostring(activator))
	print(tostring(self:GetOwner()))

	if not IsValid(activator) then return end


	-- activator is owner --> pick up
	if self:GetOwner() and activator == self:GetOwner() then
		-- picks up weapon, switches if possible and needed, returns weapon if successful
		local wep = activator:PickupWeaponClass('weapon_ttt_ankh', true)

		if not IsValid(wep) then
			LANG.Msg(activator, 'ankh_no_room')

			return
		end

		PHARAOH_HANDLER:RemovedAnkh(self)
		self:Remove()
	end

	-- key is released and transfer process should be stopped
	if self:GetAdversary() and self:GetAdversary() == activator then
		self.t_transfer_start = nil
	end
end

local zapsound = Sound('npc/assassin/ball_zap1.wav')

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())

	if self:Health() > 0 then return end

	PHARAOH_HANDLER:DestroyAnkh(self, dmginfo:GetAttacker())

	local effect = EffectData()
	effect:SetOrigin(self:GetPos())
	util.Effect('cball_explode', effect)

	sound.Play(zapsound, self:GetPos())

	-- notify the current owner and his adversary that the ankh was broken
	if IsValid(self:GetOwner()) then
		LANG.Msg(self:GetOwner(), 'ankh_broken')
	end

	if IsValid(self:GetAdversary()) then
		LANG.Msg(self:GetAdversary(), 'ankh_broken_adv')
	end
end

function ENT:SetAdversary(ply)
	self.adversary = ply
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
		constraint.RemoveConstraints(self, 'Weld')

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(true)
			phys:SetMass(self.OrigMass or 10)
		end
	end
end

if CLIENT then
	local TryT = LANG.TryTranslation
	local ParT = LANG.GetParamTranslation

	-- handle looking at ankh
	hook.Add('TTTRenderEntityInfo', 'HUDDrawTargetIDAnkh', function(data, params)
		local client = LocalPlayer()

		if not IsValid(client) or not client:IsTerror() or not client:Alive()
		or data.distance > 100 or data.ent:GetClass() ~= 'ttt_ankh' then
			return
		end

		params.drawInfo = true
		params.displayInfo.title.text = TryT('ttt2_weapon_ankh_name')

		if client == data.ent:GetNWEntity('pharaoh', nil) then
			params.displayInfo.key = input.GetKeyCode(input.LookupBinding('+use'))

			params.displayInfo.subtitle.text = TryT('target_pickup')
		elseif client == data.ent:GetNWEntity('pharaoh', nil) then
			params.displayInfo.key = input.GetKeyCode(input.LookupBinding('+use'))

			params.displayInfo.subtitle.text = TryT('ank_convert')
		else
			params.displayInfo.icon[#params.displayInfo.icon + 1] = {
				material = PHARAOH.iconMaterial,
				color = PHARAOH.bgcolor
			}
		end

		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = TryT('ankh_short_desc')
		}

		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = ParT('ankh_health_points', {health = data.ent:Health(), maxhealth = GetGlobalInt('ttt_ankh_health')})
		}

		params.drawOutline = true
		params.outlineColor = client:GetRoleColor()
	end)
end
