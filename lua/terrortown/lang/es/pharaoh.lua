local L = LANG.GetLanguageTableReference("es")

-- GENERAL ROLE LANGUAGE STRINGS
L[PHARAOH.name] = "Faraón"
L["info_popup_" .. PHARAOH.name] = [[¡Eres el Faraón!
Usa tu Ankh para tu beneficio. ¡Ponlo en una posición estratégica y asegura su protección!]]
L["body_found_" .. PHARAOH.abbr] = "¡Era un Faraón!"
L["search_role_" .. PHARAOH.abbr] = "Esta persona era un Faraón."
L["target_" .. PHARAOH.name] = "Faraón"
L["ttt2_desc_" .. PHARAOH.name] = [[El Faraón es un inocente con un objeto precioso que lo cura y puede revivirlo en caso de morir. 
Cuidado, habrá alguien acechando ese tesoro.]]

L[GRAVEROBBER.name] = "Ladrón de Tumbas"
L["info_popup_" .. GRAVEROBBER.name] = [[¡Eres el ladrón de Tumbas!
¡Intenta robar el Ankh y hacerte con su poder!]]
L["body_found_" .. GRAVEROBBER.abbr] = "¡Era un Ladrón de Tumbas!"
L["search_role_" .. GRAVEROBBER.abbr] = "Esta persona era un Ladrón de Tumbas."
L["target_" .. GRAVEROBBER.name] = "Ladrón de Tumbas"
L["ttt2_desc_" .. GRAVEROBBER.name] = [[El Ladrón de tumbas es un traidor capaz de llevarle la contraria al Faraón.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_weapon_ankh_name"] = "Ankh"
L["ttt2_weapon_ankh_desc"] = "Pon el Ankh en el suelo."
L["weapon_ttt_ankh_help"] = "Deja el Ankh clavado al piso y activa su efecto"
L["ankh_short_desc"] = "Un objetivo místico que permite la sanación y resurreción de su dueño."
L["ankh_convert"] = "Presiona [{usekey}] para convertirlo"
L["ankh_no_convert"] = "No puedes convertir este Ankh en este momento"
L["ankh_unknown_terrorist"] = "Este es el Ankh de un terrorista desconocido"
L["ankh_no_pickup"] = "No puedes recoger este Ankh"
L["ankh_health_points"] = "Vida: {health} / {maxhealth}"
L["ankh_progress"] = "Progreso de Conversión: {progress}%"
L["ankh_broken"] = "Tu Ankh fue destruído."
L["ankh_broken_adv"] = "Tu Ankh fue destruído."
L["ankh_no_traitor_alive"] = "El Ankh no puede ser puesto sin traidores vivos."
L["ankh_too_steep"] = "Esta superficie no es adecuada para poner el Ankh."
L["ankh_selected_graverobber"] = "Un traidor fue convertido a Ladrón de Tumbas. ¡Ahora tienes un adversario!"
L["ankh_popup_converted_title"] = "¡Tu Ankh fue convertido!"
L["ankh_popup_converted_text"] = "Tu adversario tuvo tiempo suficiente para hacerse con el Ankh y usar sus beneficios ¡Búscalo y recupéralo!"
L["ankh_revival"] = "¡Serás revivido!"
L["ankh_revival_text"] = "El poder del Ankh te revivirá en {time} segundos. Prepárate."
L["ankh_revival_canceled"] = "Algo canceló tu renacimiento."
L["ankh_revival_canceled_text"] = "Tu renacimiento fue cancelado por que alguien destruyó el Ankh."
L["ankh_insufficient_room"] = "Espacio insuficiente en la habitación."
L["ankh_owner_is_reviving"] = "Conversión bloqueada - El dueño está renaciendo."

--L["tooltip_ankh_conversion_score"] = "Ankh stolen: {score}"
--L["ankh_conversion_score"] = "Ankh stolen:"
--L["title_event_ankh_conversion"] = "A player stole the ankh"
--L["desc_event_ankh_conversion"] = "{new} ({nrole} / {nteam}) has stolen the ankh of {old} ({orole} / {oteam})."
--L["title_event_ankh_destroyed"] = "A player destroyed the ankh"
--L["desc_event_ankh_destroyed"] = "{attacker} ({arole} / {ateam}) has destroyed the ankh of {old} ({orole} / {oteam})."
--L["title_event_ankh_revive"] = "A player revived at their ankh"
--L["desc_event_ankh_revive"] = "{owner} ({role} / {team}) use their ankh to come back into life."
