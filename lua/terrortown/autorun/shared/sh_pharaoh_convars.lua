CreateConVar("ttt_ankh_health", 500, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_ankh_conversion_time", 6, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_ankh_respawn_time", 10, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_ankh_pharaoh_pickup", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_ankh_graverobber_pickup", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_ankh_heal_ankh", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_ankh_heal_owner", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_ankh_light_up", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_ankh_respawn_protection_time", 4, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

if SERVER then
	-- ConVar replication is broken in GMod, so we do this, at least Alf added a hook!
	-- I don't like it any more than you do, dear reader. Copycat!
	hook.Add("TTT2SyncGlobals", "ttt2_pharaoh_sync_convars", function()
		SetGlobalInt("ttt_ankh_conversion_time", GetConVar("ttt_ankh_conversion_time"):GetInt())
		SetGlobalInt("ttt_ankh_health", GetConVar("ttt_ankh_health"):GetInt())
		SetGlobalInt("ttt_ankh_respawn_time", GetConVar("ttt_ankh_respawn_time"):GetInt())
		SetGlobalBool("ttt_ankh_pharaoh_pickup", GetConVar("ttt_ankh_pharaoh_pickup"):GetBool())
		SetGlobalBool("ttt_ankh_graverobber_pickup", GetConVar("ttt_ankh_graverobber_pickup"):GetBool())
		SetGlobalBool("ttt_ankh_heal_ankh", GetConVar("ttt_ankh_heal_ankh"):GetBool())
		SetGlobalBool("ttt_ankh_heal_owner", GetConVar("ttt_ankh_heal_owner"):GetBool())
		SetGlobalBool("ttt_ankh_light_up", GetConVar("ttt_ankh_light_up"):GetBool())
	end)

	-- sync convars on change
	cvars.AddChangeCallback("ttt_ankh_conversion_time", function(cv, old, new)
		SetGlobalInt("ttt_ankh_conversion_time", tonumber(new))
	end)

	cvars.AddChangeCallback("ttt_ankh_health", function(cv, old, new)
		SetGlobalInt("ttt_ankh_health", tonumber(new))
	end)

	cvars.AddChangeCallback("ttt_ankh_respawn_time", function(cv, old, new)
		SetGlobalInt("ttt_ankh_respawn_time", tonumber(new))
	end)

	cvars.AddChangeCallback("ttt_ankh_pharaoh_pickup", function(cv, old, new)
		SetGlobalBool("ttt_ankh_pharaoh_pickup", tobool(tonumber(new)))
	end)

	cvars.AddChangeCallback("ttt_ankh_graverobber_pickup", function(cv, old, new)
		SetGlobalBool("ttt_ankh_graverobber_pickup", tobool(tonumber(new)))
	end)

	cvars.AddChangeCallback("ttt_ankh_heal_ankh", function(cv, old, new)
		SetGlobalBool("ttt_ankh_heal_ankh", tobool(tonumber(new)))
	end)

	cvars.AddChangeCallback("ttt_ankh_heal_owner", function(cv, old, new)
		SetGlobalBool("ttt_ankh_heal_owner", tobool(tonumber(new)))
	end)

	cvars.AddChangeCallback("ttt_ankh_light_up", function(cv, old, new)
		SetGlobalBool("ttt_ankh_light_up", tobool(tonumber(new)))
	end)
end
