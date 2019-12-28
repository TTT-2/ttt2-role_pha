if SERVER then
	AddCSLuaFile()

	resource.AddFile('materials/vgui/ttt/dynamic/roles/icon_grav.vmt')
end

ROLE.Base = 'ttt_role_base'

function ROLE:PreInitialize()
	self.color = Color(200, 100, 60, 255)

	self.abbr = 'grav'
	self.surviveBonus = 0
	self.scoreKillsMultiplier = 1
	self.scoreTeamKillsMultiplier = -16
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
		shopFallback = SHOP_TRAITOR,
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 50
	}
end

function ROLE:Initialize()
	if CLIENT then
		-- Role specific language elements
		LANG.AddToLanguage('English', GRAVEROBBER.name, 'Graverobber')
		LANG.AddToLanguage('English', 'info_popup_' .. GRAVEROBBER.name,
			[[You are the Graverobber!
			Search for the placed Ankh and try to use it for your benefit!]])
		LANG.AddToLanguage('English', 'body_found_' .. GRAVEROBBER.abbr, 'They were a Graverobber.')
		LANG.AddToLanguage('English', 'search_role_' .. GRAVEROBBER.abbr, 'This person was a Graverobber!')
		LANG.AddToLanguage('English', 'target_' .. GRAVEROBBER.name, 'Graverobber')
		LANG.AddToLanguage('English', 'ttt2_desc_' .. GRAVEROBBER.name, [[The Graverobber is a player in the traitor team that is the adversary of the pharao.]])

		LANG.AddToLanguage('Deutsch', GRAVEROBBER.name, 'Grabräuber')
		LANG.AddToLanguage('Deutsch', 'info_popup_' .. GRAVEROBBER.name,
			[[Du bist ein Grabräuber!
			Suche nah dem platzierten Ankh und nutze ihn zu deinem Vorteil]])
		LANG.AddToLanguage('Deutsch', 'body_found_' .. GRAVEROBBER.abbr, 'Er war ein Grabräuber ...')
		LANG.AddToLanguage('Deutsch', 'search_role_' .. GRAVEROBBER.abbr, 'Diese Person war ein Grabräuber')
		LANG.AddToLanguage('Deutsch', 'target_' .. GRAVEROBBER.name, 'Grabräuber')
		LANG.AddToLanguage('Deutsch', 'ttt2_desc_' .. GRAVEROBBER.name, [[Der Grabräuber is ein Verräter und ein direkter Gegenspieler des Pharaos!]])
	end
end