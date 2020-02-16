if SERVER then
	AddCSLuaFile()

	resource.AddFile('materials/vgui/ttt/dynamic/roles/icon_pha.vmt')
end

ROLE.Base = 'ttt_role_base'

function ROLE:PreInitialize()
	self.color = Color(170, 180, 10, 255)

	self.abbr = 'pha'
	self.surviveBonus = 0
	self.scoreKillsMultiplier = 1
	self.scoreTeamKillsMultiplier = -16
	self.preventFindCredits = true
	self.preventKillCredits = true
	self.preventTraitorAloneCredits = true
	self.preventWin = false
	self.unknownTeam = true

	self.defaultTeam = TEAM_INNOCENT

	self.conVarData = {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		credits = 0, -- the starting credits of a specific role
		shopFallback = SHOP_DISABLED,
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 50
	}
end

if SERVER then
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		if not isRoleChange then return end

		ply:GiveEquipmentWeapon('weapon_ttt_ankh')
	end

	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon('weapon_ttt_ankh')
	end
end
