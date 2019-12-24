if SERVER then
	resource.AddFile('ankh/runes/rune_graverobber')
	resource.AddFile('ankh/runes/rune_pharao')
	resource.AddFile('ankh/runes/rune_neutral')

	game.AddDecal('rune_graverobber', 'ankh/runes/rune_graverobber')
	game.AddDecal('rune_pharaoh', 'ankh/runes/rune_pharaoh')
	game.AddDecal('rune_neutral', 'ankh/runes/rune_neutral')
end

if CLIENT then
	hook.Add('Initialize', 'ttt2_role_pharao_setup_lang', function()
		LANG.AddToLanguage('English', 'ttt2_weapon_ankh_name', 'Ankh')
		LANG.AddToLanguage('Deutsch', 'ttt2_weapon_ankh_name', 'Ankh')

		LANG.AddToLanguage('English', 'ttt2_weapon_ankh_desc', 'Place this ankh on the ground.')
		LANG.AddToLanguage('Deutsch', 'ttt2_weapon_ankh_desc', 'Platziere den Ankh auf dem Boden.')

		LANG.AddToLanguage('English', 'weapon_ttt_ankh_help', 'Use {primaryfire} to place the ankh on the ground.')
		LANG.AddToLanguage('Deutsch', 'weapon_ttt_ankh_help', 'Nutze {primaryfire}, um den Ankh auf dem Boden zu platzieren.')
	end)
end
