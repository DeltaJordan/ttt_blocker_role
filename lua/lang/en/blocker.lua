L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[BLOCKER.name] = "Blocker"
L["info_popup_" .. BLOCKER.name] = [[You are a Blocker! You prevent anyone from identifying bodies while you're alive!]]
L["body_found_" .. BLOCKER.abbr] = "They were a Blocker!"
L["search_role_" .. BLOCKER.abbr] = "This person was a Blocker!"
L["target_" .. BLOCKER.name] = "Blocker"
L["ttt2_desc_" .. BLOCKER.name] = [[The Blocker is a Traitor that prevents anyone from identifying bodies until the Blocker is dead.]]