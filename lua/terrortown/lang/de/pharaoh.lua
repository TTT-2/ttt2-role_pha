local L = LANG.GetLanguageTableReference("de")

-- GENERAL ROLE LANGUAGE STRINGS
L[PHARAOH.name] = "Pharao"
L["info_popup_" .. PHARAOH.name] = [[Du bist ein Pharao!
Nutze deinen Ankh zu deinem Vorteil und stelle dabei sicher, dass dieser immer geschützt ist!]]
L["body_found_" .. PHARAOH.abbr] = "Er war ein Pharao ..."
L["search_role_" .. PHARAOH.abbr] = "Diese Person war ein Pharao"
L["target_" .. PHARAOH.name] = "Pharao"
L["ttt2_desc_" .. PHARAOH.name] = [[Der Pharao ist ein unschuldiger Spieler, der den Ankh zu seinem Vorteil nutzen muss!]]

L[GRAVEROBBER.name] = "Grabräuber"
L["info_popup_" .. GRAVEROBBER.name] = [[Du bist ein Grabräuber!
Suche nah dem platzierten Ankh und nutze ihn zu deinem Vorteil]]
L["body_found_" .. GRAVEROBBER.abbr] = "Er war ein Grabräuber ..."
L["search_role_" .. GRAVEROBBER.abbr] = "Diese Person war ein Grabräuber"
L["target_" .. GRAVEROBBER.name] = "Grabräuber"
L["ttt2_desc_" .. GRAVEROBBER.name] = [[Der Grabräuber ist ein Verräter und ein direkter Gegenspieler des Pharaos!]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_weapon_ankh_name"] = "Ankh"
L["ttt2_weapon_ankh_desc"] = "Platziere den Ankh auf dem Boden."
L["weapon_ttt_ankh_help"] = "Platziert den Ankh auf dem Boden"
L["ankh_short_desc"] = "Ein mystisches Ding auf dem Boden, dass manchen Spielern erlaubt wiederbelebt zu werden."
L["ankh_convert"] = "Halte [{usekey}], um zu konvertieren"
L["ankh_no_convert"] = "Du kannst den Ankh aktuell nicht konvertieren"
L["ankh_unknown_terrorist"] = "Dies ist der Ankh eines unbekannten Terroristen"
L["ankh_no_pickup"] = "Du kannst diesen Ankh nicht aufheben"
L["ankh_health_points"] = "Leben: {health} / {maxhealth}"
L["ankh_progress"] = "Übernahmefortschritt: {progress}%"
L["ankh_broken"] = "Dein Ankh wurde zerstört."
L["ankh_broken_adv"] = "Der Ankh wurde zerstört."
L["ankh_no_traitor_alive"] = "Der Ankh kann nicht platziert werden, wenn kein Verräter am Leben ist."
L["ankh_too_steep"] = "Dieser Untergrund ist zu steil um einen Ankh zu platzieren."
L["ankh_selected_graverobber"] = "Ein Verräter wurde zu einem Grabräuber konvertiert. Er ist nun dein Gegenspieler!"
L["ankh_popup_converted_title"] = "Dein Ankh wurde übernommen!"
L["ankh_popup_converted_text"] = "Dein Gegenspieler hatte genug Zeit den Ankh für seine eigenen Zwecke zu missbrauchen. Sorge dafür, dass der Ankh wieder dir gehört!"
L["ankh_revival"] = "Du witst wiederbelebt!"
L["ankh_revival_text"] = "Die Macht des Ankh wird dich in {time} Sekunde(n) wiederbeleben. Sei vorbereitet."
L["ankh_revival_canceled"] = "Wiederbelebung abgebrochen."
L["ankh_revival_canceled_text"] = "Deine Wiederbelebung wurde abgebrochen, da dein Ankh zerstört wurde."
L["ankh_insufficient_room"] = "Nicht genügend Platz."
L["ankh_owner_is_reviving"] = "Konvertierung blockiert - Beseitzer belebt sich wieder"

L["tooltip_ankh_conversion_score"] = "Ankh geklaut: {score}"
L["ankh_conversion_score"] = "Ankh geklaut:"
L["title_event_ankh_conversion"] = "Ein Spieler hat einen Ankh geklaut"
L["desc_event_ankh_conversion"] = "{new} ({nrole} / {nteam}) hat den Ankh von {old} ({orole} / {oteam}) geklaut."
L["title_event_ankh_destroyed"] = "Ein Spieler hat einen Ankh zerstört"
L["desc_event_ankh_destroyed"] = "{attacker} ({arole} / {ateam}) hat den Ankh von {old} ({orole} / {oteam}) zerstört."
L["title_event_ankh_revive"] = "Ein Spieler wurde an seinem Ankh wiederbelebt"
L["desc_event_ankh_revive"] = "{owner} ({role} / {team}) hat seinen Ankh benutzt, um zurück ins Leben zu finden."
