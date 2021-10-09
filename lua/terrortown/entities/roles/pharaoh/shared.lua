if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_pha.vmt")
end

ROLE.Base = "ttt_role_base"

function ROLE:PreInitialize()
	self.color = Color(170, 180, 10, 255)

	self.abbr = "pha"
	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -8
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

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_INNOCENT)
end


if SERVER then
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		PHARAOH_HANDLER:SetClientCanConvAnkh(ply)

		if isRoleChange then
			if not PHARAOH_HANDLER:PlayerOwnsAnAnkh(ply) then
				ply:GiveEquipmentWeapon("weapon_ttt_ankh")
			else
				LANG.Msg(ply, "ankh_already_owned")
			end
		end
	end

	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("weapon_ttt_ankh")

		-- Since we're removing any ankh the pharaoh happens to own, we need to remove the data as well.
		PHARAOH_HANDLER:RemoveAnkhDataFromLoadout(ply)
	end
end
