if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_grav.vmt")
end

ROLE.Base = "ttt_role_base"

function ROLE:PreInitialize()
	self.color = Color(200, 100, 60, 255)

	self.abbr = "grav"
	self.score.surviveBonusMultiplier = 0.5
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -16
	self.score.bodyFoundMuliplier = 0
	self.preventFindCredits = false
	self.preventKillCredits = false
	self.preventTraitorAloneCredits = false
	self.notSelectable = true

	self.defaultTeam = TEAM_TRAITOR

	self.conVarData = {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		credits = 0, -- the starting credits of a specific role
		shopFallback = SHOP_FALLBACK_TRAITOR,
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		traitorButton = 1, -- can use traitor buttons
		random = 50
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_TRAITOR)
end

if SERVER then
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		PHARAOH_HANDLER:SetClientCanConvAnkh(ply)
	end

	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon('weapon_ttt_ankh')

		-- Since we're removing any ankh the graverobber happens to own, we need to remove the data as well.
		PHARAOH_HANDLER:RemoveAnkhDataFromLoadout(ply)
	end
end