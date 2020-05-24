if SERVER then
	AddCSLuaFile()
else -- CLIENT
	SWEP.PrintName = "ttt2_weapon_ankh_name"
	SWEP.Slot = 7

	SWEP.ViewModelFOV = 10
	SWEP.ViewModelFlip = false
	SWEP.DrawCrosshair = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "ttt2_weapon_ankh_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_ankh"
end

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "normal"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/props_lab/reciever01b.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EXTRA
SWEP.CanBuy = nil
SWEP.LimitedStock = true -- only buyable once

SWEP.AllowDrop = false
SWEP.NoSights = true

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if SERVER then
		self:AnkhStick()
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	if SERVER then
		self:AnkhStick()
	end
end

if SERVER then
	function SWEP:AnkhStick()
		local ply = self:GetOwner()

		if not IsValid(ply) then return end

		if not PHARAOH_HANDLER:CanPlaceAnkh() then
			LANG.Msg(ply, "ankh_no_traitor_alive")

			return
		end

		local spos = ply:GetShootPos()
		local epos = spos + ply:GetAimVector() * 100

		local ankhModelShift = Vector(-6, -1, 3.5)

		local CheckFilder = function(ent)
			if not IsValid(ent) or ent:IsPlayer() then
				return false
			end

			if ent == self then
				return false
			end

			if ent:HasPassableCollisionGrup() then
				return false
			end

			return true
		end

		local tr = util.TraceLine({
			start = spos,
			endpos = epos,
			filter = CheckFilder,
			mask = MASK_SOLID
		})

		if not tr.Hit then return end

		-- only allow placement on level ground
		local dot_a_b = tr.HitNormal:Dot(Vector(0, 0, 1))
		local len_a = tr.HitNormal:Length()
		local angle = math.acos(dot_a_b / len_a)

		if math.abs(angle) > 0.2 then
			LANG.Msg(ply, "ankh_too_steep")

			return
		end

		if not spawn.IsSpawnPointSafe(ply, tr.HitPos + ankhModelShift, false, {ply, self}) then
			LANG.Msg(ply, "ankh_insufficient_room")

			return
		end

		local ankh = ents.Create("ttt_ankh")
		if not IsValid(ankh) then return end

		ankh:PointAtEntity(ply)

		local tr_ent = util.TraceEntity({
			start = spos,
			endpos = epos,
			filter = CheckFilder,
			mask = MASK_SOLID
		}, ankh)

		if not tr_ent.HitWorld then return end

		local ang = tr_ent.HitNormal:Angle()

		-- shift ankh model since center is a bit offset
		ankh:SetPos(tr_ent.HitPos + ankhModelShift)
		ankh:SetAngles(ang)
		ankh:SetOwner(ply)
		ankh:Spawn()

		self:PlacedAnkh(ankh)
	end
end

function SWEP:PlacedAnkh(ankh)
	self:TakePrimaryAmmo(1)

	if not self:CanPrimaryAttack() then
		self:Remove()
	end
end

function SWEP:Reload()
	return false
end

if CLIENT then
	function SWEP:OnRemove()
		if not IsValid(self:GetOwner()) or self:GetOwner() ~= LocalPlayer() or not self:GetOwner():Alive() then return end

		RunConsoleCommand("lastinv")
	end

	function SWEP:Initialize()
		self:AddHUDHelp("weapon_ttt_ankh_help", nil, true)

		return self.BaseClass.Initialize(self)
	end
end

function SWEP:Deploy()
	self:GetOwner():DrawViewModel(false)

	return true
end

function SWEP:DrawWorldModel()
	if IsValid(self:GetOwner()) then return end

	self:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()

end
