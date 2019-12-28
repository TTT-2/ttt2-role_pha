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

function ROLE:Initialize()
	if CLIENT then
		-- Role specific language elements
		LANG.AddToLanguage('English', PHARAOH.name, 'Pharaoh')
		LANG.AddToLanguage('English', 'info_popup_' .. PHARAOH.name,
			[[You are the Pharaoh!
			Use your Ankh to your benefit. Place it in a strategic position and make sure it is protected!]])
		LANG.AddToLanguage('English', 'body_found_' .. PHARAOH.abbr, 'They were a Pharaoh.')
		LANG.AddToLanguage('English', 'search_role_' .. PHARAOH.abbr, 'This person was a Pharaoh!')
		LANG.AddToLanguage('English', 'target_' .. PHARAOH.name, 'Pharaoh')
		LANG.AddToLanguage('English', 'ttt2_desc_' .. PHARAOH.name, [[The Pharaoh is an innocent player that has a special item to use to his benefit!]])

		LANG.AddToLanguage('Deutsch', PHARAOH.name, 'Pharao')
		LANG.AddToLanguage('Deutsch', 'info_popup_' .. PHARAOH.name,
			[[Du bist ein Pharao!
			Nutze deinen Ankh zu deinem Vorteil und stelle dabei sicher, dass dieser immer geschützt ist!]])
		LANG.AddToLanguage('Deutsch', 'body_found_' .. PHARAOH.abbr, 'Er war ein Pharao ...')
		LANG.AddToLanguage('Deutsch', 'search_role_' .. PHARAOH.abbr, 'Diese Person war ein Pharao')
		LANG.AddToLanguage('Deutsch', 'target_' .. PHARAOH.name, 'Pharao')
		LANG.AddToLanguage('Deutsch', 'ttt2_desc_' .. PHARAOH.name, [[Der Pharao ist ein unschuldiger Spieler, der den Ankh zu seinem Vorteil nutzen muss!]])
	end
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
