CreateConVar('ttt_ankh_health', 500, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_ankh_conversion_time', 6, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_ankh_pharaoh_pickup', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_ankh_graverobber_pickup', 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

if SERVER then
	-- ConVar replication is broken in GMod, so we do this, at least Alf added a hook!
	-- I don't like it any more than you do, dear reader. Copycat!
	hook.Add('TTT2SyncGlobals', 'ttt2_pharaoh_sync_convars', function()
		SetGlobalFloat('ttt_ankh_conversion_time', GetConVar('ttt_ankh_conversion_time'):GetInt())
		SetGlobalFloat('ttt_ankh_health', GetConVar('ttt_ankh_health'):GetInt())
		SetGlobalBool('ttt_ankh_pharaoh_pickup', GetConVar('ttt_ankh_pharaoh_pickup'):GetBool())
		SetGlobalBool('ttt_ankh_graverobber_pickup', GetConVar('ttt_ankh_graverobber_pickup'):GetBool())
	end)

	-- sync convars on change
	cvars.AddChangeCallback('ttt_ankh_conversion_time', function(cv, old, new)
		SetGlobalInt('ttt_ankh_conversion_time', tonumber(new))
	end)

	cvars.AddChangeCallback('ttt_ankh_health', function(cv, old, new)
		SetGlobalInt('ttt_ankh_health', tonumber(new))
	end)

	cvars.AddChangeCallback('ttt_ankh_pharaoh_pickup', function(cv, old, new)
		SetGlobalBool('ttt_ankh_pharaoh_pickup', tobool(tonumber(new)))
	end)

	cvars.AddChangeCallback('ttt_ankh_graverobber_pickup', function(cv, old, new)
		SetGlobalBool('ttt_ankh_graverobber_pickup', tobool(tonumber(new)))
	end)
end

hook.Add('TTTUlxDynamicRCVars', 'ttt2_ulx_dynamic_pharaoh_convars', function(tbl)
	tbl[ROLE_PHARAOH] = tbl[ROLE_PHARAOH] or {}

	table.insert(tbl[ROLE_PHARAOH], {cvar = 'ttt_ankh_pharaoh_pickup', checkbox = true, desc = 'ttt_ankh_pharaoh_pickup (def. 1)'})
	table.insert(tbl[ROLE_PHARAOH], {cvar = 'ttt_ankh_graverobber_pickup', checkbox = true, desc = 'ttt_ankh_graverobber_pickup (def. 0)'})
	table.insert(tbl[ROLE_PHARAOH], {cvar = 'ttt_ankh_conversion_time', slider = true, min = 0, max = 50, decimal = 0, desc = 'ttt_ankh_conversion_time (def. 6)'})
	table.insert(tbl[ROLE_PHARAOH], {cvar = 'ttt_ankh_health', slider = true, min = 0, max = 1000, decimal = 0, desc = 'ttt_ankh_health (def. 500)'})
end)