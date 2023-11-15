local L = LANG.GetLanguageTableReference("tr")

-- GENERAL ROLE LANGUAGE STRINGS
L[PHARAOH.name] = "Firavun"
L["info_popup_" .. PHARAOH.name] = [[Firavunsun!
Ankh'ınızı kendi yararınıza kullanın. Stratejik bir konuma yerleştirin ve korunduğundan emin olun!]]
L["body_found_" .. PHARAOH.abbr] = "Onlar bir Firavundu."
L["search_role_" .. PHARAOH.abbr] = "Bu kişi bir Firavundu!"
L["target_" .. PHARAOH.name] = "Firavun"
L["ttt2_desc_" .. PHARAOH.name] = [[Firavun, kendi yararına kullanabileceği özel bir eşyası olan masum bir oyuncudur!]]

L[GRAVEROBBER.name] = "Mezar Soyguncusu"
L["info_popup_" .. GRAVEROBBER.name] = [[Mezar Soyguncususun!
Yerleştirilen Ankh'ı arayın ve kendi yararınıza kullanmaya çalışın!!]]
L["body_found_" .. GRAVEROBBER.abbr] = "Onlar bir Mezar Soyguncusuydu."
L["search_role_" .. GRAVEROBBER.abbr] = "Bu kişi bir Mezar Soyguncusuydu!"
L["target_" .. GRAVEROBBER.name] = "Mezar Soyguncusu"
L["ttt2_desc_" .. GRAVEROBBER.name] = [[Mezar Soyguncusu, hain takımda Firavun'un düşmanı olan bir oyuncudur.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_weapon_ankh_name"] = "Ankh"
L["ttt2_weapon_ankh_desc"] = "Bu ankh'ı yere koy."
L["weapon_ttt_ankh_help"] = "Ankh'ı yere yerleştirir"
L["ankh_short_desc"] = "Belirli oyuncuların yeniden canlanmasını sağlayan mistik bir şey."
L["ankh_convert"] = "Dönüştürmek için [{usekey}] tuşunu basılı tutun"
L["ankh_no_convert"] = "Bu ankh'ı şu anda dönüştüremezsiniz"
L["ankh_unknown_terrorist"] = "Bu, bilinmeyen bir teröristin Ankh'ı"
L["ankh_no_pickup"] = "Bu Ankh'ı alamazsınız"
L["ankh_health_points"] = "Sağlık: {health} / {maxhealth}"
L["ankh_progress"] = "Dönüşüm İlerlemesi: %{progress}"
L["ankh_broken"] = "Ankh'ınız kırıldı."
L["ankh_broken_adv"] = "Bir ankh kırıldı."
L["ankh_no_traitor_alive"] = "Hiçbir hain hayatta değilse Ankh yerleştirilemez."
L["ankh_already_owned"] = "Bu dünyada sahip olduğun bir ankh var. Bu nedenle, şu anda başka bir tane almayacaksınız."
L["ankh_too_steep"] = "Bu yüzey Ankh yerleştirmek için çok dik."
L["ankh_selected_graverobber"] = "Bir hain bir Mezar Soyguncusuna dönüştürüldü. Onlar artık senin düşmanın!"
L["ankh_popup_converted_title"] = "Ankh'ınız Dönüştürüldü!"
L["ankh_popup_converted_text"] = "Rakibinizin Ankh'ınızı dönüştürmek ve kendi amaçları için kullanmak için yeterli zamanı var. Geri dön ve tekrar senin olduğundan emin o!"
L["ankh_revival"] = "Dirileceksin!"
L["ankh_revival_text"] = "Ankh'ın gücü seni {time} saniye içinde diriltecek. Hazır olun."
L["ankh_revival_canceled"] = "Diriliş İptal Edildi"
L["ankh_revival_canceled_text"] = "Ankh'ınız yok edildiği için dirilişiniz iptal edildi."
L["ankh_insufficient_room"] = "Yetersiz alan."
L["ankh_owner_is_reviving"] = "Dönüşüm engellendi - sahibi diriliyor"
L["ankh_all_gone"] = "Tüm ankh'lar yok edildi ve bu nedenle eski rolünüz size geri verildi."

L["tooltip_ankh_conversion_score"] = "Çalınan Ankh: {score}"
L["ankh_conversion_score"] = "Çalınan Ankh:"
L["title_event_ankh_conversion"] = "Bir oyuncu ankh'ı çaldı"
L["desc_event_ankh_conversion"] = "{new} ({nrole} / {nteam}), {old} ({orole} / {oteam}) ankh'ını çaldı."
L["title_event_ankh_destroyed"] = "Bir oyuncu ankh'ı yok etti"
L["desc_event_ankh_destroyed"] = "{attacker} ({arole} / {ateam}), {old} ({orole} / {oteam}) ankh'ını yok etti."
L["title_event_ankh_revive"] = "Bir oyuncu ankh'ında dirildi"
L["desc_event_ankh_revive"] = "{owner} ({role} / {team}) hayata geri dönmek için ankh'larını kullanır."

L["label_ankh_health"] = "Ankh'ın Sağlığı"
L["label_ankh_conversion_time"] = "Ankh'ı dönüştürmek için gereken süre"
L["label_ankh_respawn_time"] = "Diriliş süresi"
L["label_ankh_pharaoh_pickup"] = "Firavun ankh'larını alabilir"
L["label_ankh_graverobber_pickup"] = "Mezar Soyguncusu ankh'larını alabilir"
L["label_ankh_heal_ankh"] = "Sahibi yakınsa Ankh kendini iyileştirir"
L["label_ankh_heal_owner"] = "Ankh, yakınlardaysa sahibini iyileştirir"
L["label_ankh_light_up"] = "Sahibi yakındaysa Ankh yanar"
L["label_ankh_respawn_protection_time"] = "Sahibin diriliş sonrası koruma süresi"
