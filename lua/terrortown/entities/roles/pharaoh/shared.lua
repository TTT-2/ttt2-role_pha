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
	self.preventWin = false
	self.unknownTeam = true

	self.defaultTeam = TEAM_INNOCENT

	self.conVarData = {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		shopFallback = SHOP_DISABLED,
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 50,
		credits = 0,
		creditsAwardDeadEnable = 0,
		creditsAwardKillEnable = 0,
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

if CLIENT then
	function ROLE:AddToSettingsMenu(parent)
		local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

		form:MakeSlider({
			serverConvar = "ttt_ankh_health",
			label = "label_ankh_health",
			min = 10,
			max = 1000,
			decimal = 0
		})

		form:MakeSlider({
			serverConvar = "ttt_ankh_conversion_time",
			label = "label_ankh_conversion_time",
			min = 0,
			max = 10,
			decimal = 0
		})

		form:MakeSlider({
			serverConvar = "ttt_ankh_respawn_time",
			label = "label_ankh_respawn_time",
			min = 1,
			max = 20,
			decimal = 0
		})

		form:MakeCheckBox({
			serverConvar = "ttt_ankh_pharaoh_pickup",
			label = "label_ankh_pharaoh_pickup"
		})

		form:MakeCheckBox({
			serverConvar = "ttt_ankh_graverobber_pickup",
			label = "label_ankh_graverobber_pickup"
		})

		form:MakeCheckBox({
			serverConvar = "ttt_ankh_heal_ankh",
			label = "label_ankh_heal_ankh"
		})

		form:MakeCheckBox({
			serverConvar = "ttt_ankh_heal_owner",
			label = "label_ankh_heal_owner"
		})

		form:MakeCheckBox({
			serverConvar = "ttt_ankh_light_up",
			label = "label_ankh_light_up"
		})

		form:MakeSlider({
			serverConvar = "ttt_ankh_respawn_protection_time",
			label = "label_ankh_respawn_protection_time",
			min = 1,
			max = 10,
			decimal = 0
		})
	end
end