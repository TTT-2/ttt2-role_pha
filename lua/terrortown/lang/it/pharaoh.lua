local L = LANG.GetLanguageTableReference("it")

-- GENERAL ROLE LANGUAGE STRINGS
L[PHARAOH.name] = "Faraone"
L["info_popup_" .. PHARAOH.name] = [[Sei il Faraone!
Usa la tua Ankh a tuo vantaggio. Piazzala in una posizione strategica e assicurati che sia protetta!]]
L["body_found_" .. PHARAOH.abbr] = "Era un Faraone."
L["search_role_" .. PHARAOH.abbr] = "Questa persona era un Faraone!"
L["target_" .. PHARAOH.name] = "Faraone"
L["ttt2_desc_" .. PHARAOH.name] = [[Il Faraone è un innocente che usa un oggetto speciale a suo vantaggio!]]

L[GRAVEROBBER.name] = "Profanatore"
L["info_popup_" .. GRAVEROBBER.name] = [[Sei il Profanatore!
Cerca un'Ankh piazzata e prova ad usarla a tuo vantaggio!]]
L["body_found_" .. GRAVEROBBER.abbr] = "Era un Profanatore."
L["search_role_" .. GRAVEROBBER.abbr] = "Questa persona era un Profanatore!"
L["target_" .. GRAVEROBBER.name] = "Profanatore"
L["ttt2_desc_" .. GRAVEROBBER.name] = [[Il Profanatore è un giocatore che fa parte dei traditori e che è l'avversario del Faraone, il suo compito è rubare l'ank del Faraone.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_weapon_ankh_name"] = "Ankh"
L["ttt2_weapon_ankh_desc"] = "Piazza quest'Ankh a terra."
L["weapon_ttt_ankh_help"] = "Usa {primaryfire} per piazzare l'Ankh a terra."
L["ankh_short_desc"] = "Un oggetto mistico a terra che permette ad alcuni player di respawnare."
L["ankh_convert"] = "Tieni premuto [{usekey}] per convertire"
L["ankh_no_convert"] = "Non puoi convertire quest'Ankh al momento"
L["ankh_unknown_terrorist"] = "Questa è un'Ankh di un traditore sconosciuto"
L["ankh_no_pickup"] = "Non puoi raccogliere quest'Ankh"
L["ankh_health_points"] = "HP: {health} / {maxhealth}"
L["ankh_progress"] = "Progresso conversione: {progress}%"
L["ankh_broken"] = "La tua Ankh è stata distrutta."
L["ankh_broken_adv"] = "La tua Ankh è stata distrutta."
L["ankh_no_traitor_alive"] = "L'Ankh non può essere posizionata se nessun traditore è vivo."
L["ankh_too_steep"] = "Questa superficie è troppo ripida per piazzare un'Ankh."
L["ankh_selected_graverobber"] = "Un traditore è stato convertito a un Profanatore. Ora è un tuo avversario!"
L["ankh_popup_converted_title"] = "La tua Ankh è stata convertita!"
L["ankh_popup_converted_text"] = "Il tuo avversario ha avuto abbastanza tempo per convertire la tua ankh ed usarlo per i suoi scopi. Tornaci ed assicurati che torni tua!"
L["ankh_revival"] = "Verrai rianimato!"
L["ankh_revival_text"] = "Il potere dell'Ankh ti rianimerà in {time} secondi. Stai pronto!."
L["ankh_revival_canceled"] = "Rianimazione cancellata"
L["ankh_revival_canceled_text"] = "La tua rianimazione è stata cancellata perchè il tuo Ankh è stata distrutta."
L["ankh_insufficient_room"] = "Spazio insufficente."
L["ankh_owner_is_reviving"] = "Conversione bloccata - il proprietario sta rinascendo"

--L["tooltip_ankh_conversion_score"] = "Ankh stolen: {score}"
--L["ankh_conversion_score"] = "Ankh stolen:"
--L["title_event_ankh_conversion"] = "A player stole the ankh"
--L["desc_event_ankh_conversion"] = "{new} ({nrole} / {nteam}) has stolen the ankh of {old} ({orole} / {oteam})."
--L["title_event_ankh_destroyed"] = "A player destroyed the ankh"
--L["desc_event_ankh_destroyed"] = "{attacker} ({arole} / {ateam}) has destroyed the ankh of {old} ({orole} / {oteam})."
--L["title_event_ankh_revive"] = "A player revived at their ankh"
--L["desc_event_ankh_revive"] = "{owner} ({role} / {team}) use their ankh to come back into life."

--L["label_ankh_health"] = "Ankh's HP"
--L["label_ankh_conversion_time"] = "Time it takes to convert the ankh"
--L["label_ankh_respawn_time"] = "Time until respawn"
--L["label_ankh_pharaoh_pickup"] = "Pharaoh can pick up their ankh"
--L["label_ankh_graverobber_pickup"] = "Graverobber can pick up their ankh"
--L["label_ankh_heal_ankh"] = "Ankh heals itself if the owner is close by"
--L["label_ankh_heal_owner"] = "Ankh heals the owner if they're close by"
--L["label_ankh_light_up"] = "Ankh lights up if its owner is close by"
--L["label_ankh_respawn_protection_time"] = "Owner's protection time post-respawn"
