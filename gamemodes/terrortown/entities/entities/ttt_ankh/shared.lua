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

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
	end

	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	if SERVER then
		self:SetMaxHealth(500)

		self:SetUseType(CONTINUOUS_USE)
	end

	self:SetHealth(500)

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

-- called on key release
function ENT:UseOverride(activator)
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

	PHARAOH_HANDLER:RemovedAnkh(self)
	self:Remove()

	local effect = EffectData()
	effect:SetOrigin(self:GetPos())
	util.Effect('cball_explode', effect)

	sound.Play(zapsound, self:GetPos())

	if IsValid(self:GetOwner()) then
		LANG.Msg(self:GetOwner(), 'ankh_broken')
	end
end

function ENT:SetAdversary(ply)
	self.adversary = ply
end

function ENT:GetAdversary()
	return self.adversary
end

if CLIENT then
	local TryT = LANG.TryTranslation

	-- handle looking at ankh
	hook.Add('TTTRenderEntityInfo', 'HUDDrawTargetIDAnkh', function(data, params)
		local client = LocalPlayer()

		if not IsValid(client) or not client:IsTerror() or not client:Alive()
		or data.distance > 100 or data.ent:GetClass() ~= 'ttt_ankh' then
			return
		end

		params.drawInfo = true
		params.displayInfo.key = input.GetKeyCode(input.LookupBinding('+use'))
		params.displayInfo.title.text = TryT('ttt2_weapon_ankh_name')

		params.displayInfo.subtitle.text = TryT('target_pickup')

		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = TryT('ankh_short_desc')
		}

		params.drawOutline = true
		params.outlineColor = client:GetRoleColor()
	end)
end
