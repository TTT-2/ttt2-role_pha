if SERVER then
	resource.AddFile("materials/ankh/runes/rune_graverobber.vmt")
	resource.AddFile("materials/ankh/runes/rune_pharaoh.vmt")
	resource.AddFile("materials/ankh/runes/rune_neutral.vmt")

	resource.AddFile("materials/vgui/ttt/perks/hud_icon_ankh.png")
	resource.AddFile("materials/vgui/ttt/perks/hud_icon_ankh_converting.png")

	resource.AddFile("materials/pharaohs_ankh/pharaohs_ankh/pharaohs_ankh.vmt")

	resource.AddFile("materials/vgui/ttt/vskin/events/ankh_conversion.vmt")
	resource.AddFile("materials/vgui/ttt/vskin/events/ankh_destroyed.vmt")
	resource.AddFile("materials/vgui/ttt/vskin/events/ankh_revive.vmt")

	resource.AddFile("sound/ankh/conversion.wav")
	resource.AddFile("sound/ankh/converting.wav")
	resource.AddFile("sound/ankh/respawn.wav")

	resource.AddFile("models/pharaohs_ankh/pharaohs_ankh/pharaohs_ankh.dx80.vtx")
	resource.AddFile("models/pharaohs_ankh/pharaohs_ankh/pharaohs_ankh.dx90.ctx")
	resource.AddFile("models/pharaohs_ankh/pharaohs_ankh/pharaohs_ankh.mdl")
	resource.AddFile("models/pharaohs_ankh/pharaohs_ankh/pharaohs_ankh.phy")
	resource.AddFile("models/pharaohs_ankh/pharaohs_ankh/pharaohs_ankh.sw.vtx")
	resource.AddFile("models/pharaohs_ankh/pharaohs_ankh/pharaohs_ankh.vvd")
end

game.AddDecal("rune_graverobber", "ankh/runes/rune_graverobber")
game.AddDecal("rune_pharaoh", "ankh/runes/rune_pharaoh")
game.AddDecal("rune_neutral", "ankh/runes/rune_neutral")

if CLIENT then
	hook.Add("Initialize", "ttt2_role_pharao_setup_status", function()
		-- setup satus icons
		STATUS:RegisterStatus("ttt_ankh_status", {
			hud = {
				Material("vgui/ttt/perks/hud_icon_ankh.png"),
				Material("vgui/ttt/perks/hud_icon_ankh_converting.png")
			},
			type = "good"
		})
	end)
end

-- set up sounds
sound.Add({
	name = "ankh_conversion",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	sound = "ankh/conversion.wav"
})

sound.Add({
	name = "ankh_converting",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	sound = "ankh/converting.wav"
})

sound.Add({
	name = "ankh_respawn",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 200,
	sound = "ankh/respawn.wav"
})
