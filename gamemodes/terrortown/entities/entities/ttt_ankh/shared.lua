if SERVER then
	AddCSLuaFile()
end

ENT.Type = 'anim'
ENT.Model = Model('models/props_lab/reciever01b.mdl')
ENT.CanHavePrints = false
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

	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

	if SERVER then
		self:SetMaxHealth(100)
	end

	self:SetHealth(100)

	-- can pick this up if we own it
	if SERVER then
		self:SetUseType(SIMPLE_USE)

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

function ENT:UseOverride(activator)
	if not IsValid(activator) then return end

	-- picks up weapon, switches if possible and needed, returns weapon if successful
	local wep = activator:PickupWeaponClass('weapon_ttt_ankh', true)

	if not IsValid(wep) then
		LANG.Msg(activator, 'ankh_no_room')

		return
	end

	PHARAOH_HANDLER:RemovedAnkh(self)
	self:Remove()
end

local zapsound = Sound('npc/assassin/ball_zap1.wav')

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())

	if self:Health() > 0 then return end

	self:Remove()

	local effect = EffectData()
	effect:SetOrigin(self:GetPos())

	util.Effect('cball_explode', effect)
	sound.Play(zapsound, self:GetPos())

	if IsValid(self:GetOwner()) then
		LANG.Msg(self:GetOwner(), 'ankh_broken')
	end
end

function ENT:OnRemove()
	if not IsValid(self:GetOwner()) then return end

	self:GetOwner().ankh = nil
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
