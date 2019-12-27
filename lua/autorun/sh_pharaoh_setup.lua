if SERVER then
	resource.AddFile('ankh/runes/rune_graverobber')
	resource.AddFile('ankh/runes/rune_pharao')
	resource.AddFile('ankh/runes/rune_neutral')

	resource.AddFile('vgui/ttt/perks/hud_icon_ankh.png')
	resource.AddFile('vgui/ttt/perks/hud_icon_ankh_converting.png')

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

		LANG.AddToLanguage('English', 'ankh_short_desc', 'A mystic thing on the ground that allows specific players to respawn.')
		LANG.AddToLanguage('Deutsch', 'ankh_short_desc', 'Ein mystisches Ding auf dem Boden, dass manchen Spielern erlaubt wiederbelebt zu werden.')

		LANG.AddToLanguage('English', 'ankh_convert', 'Hold [key] to convert')
		LANG.AddToLanguage('Deutsch', 'ankh_convert', 'Halte [Taste], um zu konvertieren')

		LANG.AddToLanguage('English', 'ankh_unknown_terrorist', 'This is the Ankh of an unknown terrorist')
		LANG.AddToLanguage('Deutsch', 'ankh_unknown_terrorist', 'Dies ist der Ankh eines unbekannten Terroristen')

		LANG.AddToLanguage('English', 'ankh_health_points', 'Health: {health} / {maxhealth}')
		LANG.AddToLanguage('Deutsch', 'ankh_health_points', 'Leben: {health} / {maxhealth}')

		LANG.AddToLanguage('English', 'ankh_progress', 'Conversion Progress: {progress}%')
		LANG.AddToLanguage('Deutsch', 'ankh_progress', 'Übernahmefortschritt: {progress}%')

		LANG.AddToLanguage('English', 'ankh_broken', 'Your ankh was broken.')
		LANG.AddToLanguage('Deutsch', 'ankh_broken', 'Dein Ankh wurde zerstört.')

		LANG.AddToLanguage('English', 'ankh_broken_adv', 'The ankh was broken.')
		LANG.AddToLanguage('Deutsch', 'ankh_broken_adv', 'Der Ankh wurde zerstört.')

		LANG.AddToLanguage('English', 'ankh_no_traitor_alive', 'The Ankh can\'t be placed if no traitor is alive.')
		LANG.AddToLanguage('Deutsch', 'ankh_no_traitor_alive', 'Der Ankh kann nich tplatziert werden, wenn kein Verräter am Leben ist.')

		LANG.AddToLanguage('English', 'ankh_selected_graverobber', 'A traitor got converted to a graverobber. They are now your adversary!')
		LANG.AddToLanguage('Deutsch', 'ankh_selected_graverobber', 'Ein Verräter wurde zu einem Grabräuber konvertiert. Er ist nun dein Gegenspieler!')

		LANG.AddToLanguage('English', 'ankh_popup_converted_title', 'Your Ankh was Converted!')
		LANG.AddToLanguage('Deutsch', 'ankh_popup_converted_title', 'Dein Ankh wurde konvertiert!')

		LANG.AddToLanguage('English', 'ankh_popup_converted_text', 'Your adversary got enough time to convert your ankh and use it for his own purposes. Get back to it and make sure it is yours again!')
		LANG.AddToLanguage('Deutsch', 'ankh_popup_converted_text', 'Dein Gegenspieler hatte genug Zeit den Ankh für seine eigenen Zwecke zu missbrauchen. Sorge dafür, dass der Ankh wieder dir gehört!')

		-- setup satus icons
		STATUS:RegisterStatus('ttt_ankh_status', {
			hud = {
				Material('vgui/ttt/perks/hud_icon_ankh.png'),
				Material('vgui/ttt/perks/hud_icon_ankh_converting.png')
			},
			type = 'good'
		})
	end)
end

-- set up sounds
sound.Add({
	name = 'ankh_conversion',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	sound = 'ankh/conversion.wav'
})

sound.Add({
	name = 'ankh_converting',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	sound = 'ankh/converting.wav'
})

sound.Add({
	name = 'ankh_respawn',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 200,
	sound = 'ankh/respawn.wav'
})
