local L = LANG.GetLanguageTableReference("fr")

-- GENERAL ROLE LANGUAGE STRINGS
L[PHARAOH.name] = "Pharaon"
L["info_popup_" .. PHARAOH.name] = [[Vous êtes le Pharaon!
Utilisez votre Ankh à votre avantage. Placez-le à un endroit  stratégique et assurez-vous qu'il est protégé!]]
L["body_found_" .. PHARAOH.abbr] = "C'était un Pharaon."
L["search_role_" .. PHARAOH.abbr] = "Cette personne était un Pharaon!"
L["target_" .. PHARAOH.name] = "Pharaon"
L["ttt2_desc_" .. PHARAOH.name] = [[Le Pharaon est un Innocent qui dispose d'un objet spécial à utiliser à son avantage!]]

L[GRAVEROBBER.name] = "Pilleur de tombes"
L["info_popup_" .. GRAVEROBBER.name] = [[Vous êtes le Pilleur de tombes!
Recherchez l'Ankh placé et essayez de l'utiliser à votre avantage!]]
L["body_found_" .. GRAVEROBBER.abbr] = "C'était un Pilleur de tombes."
L["search_role_" .. GRAVEROBBER.abbr] = "Cette personne était un Pilleur de tombes!"
L["target_" .. GRAVEROBBER.name] = "Pilleur de tombes"
L["ttt2_desc_" .. GRAVEROBBER.name] = [[Le Pilleur de tombes est un Traîtres qui est l'adversaire du Pharaon.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_weapon_ankh_name"] = "Ankh"
L["ttt2_weapon_ankh_desc"] = "Placez cet Ankh sur le sol."
L["weapon_ttt_ankh_help"] = "Placer l'Ankh sur le sol"
L["ankh_short_desc"] = "Une chose mystique sur le sol qui permet à des rôles spécifiques de ressusciter."
L["ankh_convert"] = "Maintenez [{usekey}] pour convertir"
L["ankh_no_convert"] = "Vous ne pouvez pas convertir cet Ankh pour le moment"
L["ankh_unknown_terrorist"] = "C'est l'Ankh d'un terroriste inconnu"
L["ankh_no_pickup"] = "Vous ne pouvez pas prendre cet Ankh"
L["ankh_health_points"] = "Santé: {health} / {maxhealth}"
L["ankh_progress"] = "Progression de la conversion: {progress}%"
L["ankh_broken"] = "Votre Ankh a été cassé."
L["ankh_broken_adv"] = "L'Ankh a été cassé."
L["ankh_no_traitor_alive"] = "L'Ankh ne peut pas être placé si aucun traître n'est vivant."
L["ankh_too_steep"] = "Cette surface est trop raide pour placer un Ankh."
L["ankh_selected_graverobber"] = "Un traître s'est converti en Pilleur de tombes. Ils sont désormais vos adversaire!"
L["ankh_popup_converted_title"] = "Votre Ankh a été converti!"
L["ankh_popup_converted_text"] = "Votre adversaire a eu suffisamment de temps pour convertir votre Ankh et l'utiliser à ses propres fins. Retournez-y et assurez-vous qu'il vous appartient à nouveau!"
L["ankh_revival"] = "Vous serez réanimé!"
L["ankh_revival_text"] = "La puissance de l'Ankh vous fera revivre dans {time} seconde(s). Soyez prêt."
L["ankh_revival_canceled"] = "Réanimation annulée"
L["ankh_revival_canceled_text"] = "Votre réanimation a été annulée parce que votre Ankh a été détruit."
L["ankh_insufficient_room"] = "Espace insuffisant."
L["ankh_owner_is_reviving"] = "Conversion bloquée - Le propriétaire est en train de ressusciter"

--L["tooltip_ankh_conversion_score"] = "Ankh stolen: {score}"
--L["ankh_conversion_score"] = "Ankh stolen:"
--L["title_event_ankh_conversion"] = "A player stole the ankh"
--L["desc_event_ankh_conversion"] = "{new} ({nrole} / {nteam}) has stolen the ankh of {old} ({orole} / {oteam})."
--L["title_event_ankh_destroyed"] = "A player destroyed the ankh"
--L["desc_event_ankh_destroyed"] = "{attacker} ({arole} / {ateam}) has destroyed the ankh of {old} ({orole} / {oteam})."
--L["title_event_ankh_revive"] = "A player revived at their ankh"
--L["desc_event_ankh_revive"] = "{owner} ({role} / {team}) use their ankh to come back into life."
